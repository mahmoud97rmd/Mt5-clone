// Path: lib/features/trading/data/mappers/oanda_mappers.dart
// ============================================================
// MT5 Clone — OANDA DTO → Domain Entity Mappers
// Pure conversion functions. No business logic here —
// only structural transformation from OANDA JSON format
// to our clean domain entity format.
// ============================================================

import '../../../../core/database/app_database.dart';
import '../../../../core/domain/entities/account_entity.dart';
import '../../../../core/domain/entities/candle_entity.dart';
import '../../../../core/domain/entities/closed_trade_entity.dart';
import '../../../../core/domain/entities/order_entity.dart';
import '../../../../core/domain/entities/position_entity.dart';
import '../../../../core/domain/entities/symbol_entity.dart';
import '../../../../core/domain/entities/tick_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../models/trade_order_dto.dart';
import '../models/transaction_candle_dto.dart';
import '../../../account/data/models/account_dto.dart';

// ============================================================
// 4.4.1 — Account Mapper
// ============================================================

class AccountMapper {
  const AccountMapper._();

  static AccountEntity fromDto(AccountSummaryDto dto) {
    final marginLevel = dto.marginUsedValue > 0
        ? (dto.navValue / dto.marginUsedValue) * 100.0
        : null;

    final leverage = dto.marginRateValue > 0
        ? (1.0 / dto.marginRateValue).round()
        : 50;

    return AccountEntity(
      accountId: dto.id,
      currency: dto.currency,
      alias: dto.alias ?? '',
      isLive: true,
      leverage: leverage,
      balance: dto.balanceValue,
      equity: dto.navValue,
      marginUsed: dto.marginUsedValue,
      marginAvailable: dto.marginAvailableValue,
      marginLevel: marginLevel,
      nav: dto.navValue,
      openPositionCount: dto.openTradeCount,
      unrealizedPnl: dto.unrealizedPlValue,
      dailyRealizedPnl: dto.realizedPlValue,
      lastUpdated: DateTime.now(),
    );
  }
}

// ============================================================
// 4.4.2 — Symbol Mapper
// ============================================================

class SymbolMapper {
  const SymbolMapper._();

  static SymbolEntity fromDto(InstrumentDto dto) {
    final pipSize = _pipSizeFromLocation(dto.pipLocationValue);

    return SymbolEntity(
      name: dto.name,
      displayName: dto.displayName,
      displayLabel: dto.name.replaceAll('_', ''),
      type: InstrumentType.fromString(dto.type),
      pipSize: pipSize,
      pipLocation: dto.pipLocationValue,
      unitsPerLot: dto.type.contains('METALS') ? 100.0 : 100000.0,
      displayPrecision: dto.displayPrecision,
      marginRate: dto.marginRateValue,
      minimumTradeSize: dto.minimumTradeSizeValue,
      tradeUnitsPrecision: dto.tradeUnitsPrecision.toDouble(),
      isWatchlisted: _isDefaultWatchlisted(dto.name),
      watchlistSortOrder: _defaultSortOrder(dto.name),
      sortOrder: _defaultSortOrder(dto.name),
    );
  }

  static double _pipSizeFromLocation(int pipLocation) {
    double size = 1.0;
    final exp = -pipLocation;
    for (int i = 0; i < exp; i++) size /= 10.0;
    return size;
  }

  static List<SymbolEntity> fromDtoList(List<InstrumentDto> dtos) =>
      dtos.map(fromDto).toList();

  static bool _isDefaultWatchlisted(String name) {
    const defaults = ['XAU_USD', 'EUR_USD', 'GBP_USD', 'USD_JPY'];
    return defaults.contains(name);
  }

  static int _defaultSortOrder(String name) {
    const order = {
      'XAU_USD': 1, 'EUR_USD': 2, 'GBP_USD': 3, 'USD_JPY': 4,
    };
    return order[name] ?? 999;
  }
}

// ============================================================
// 4.4.3 — Position (Trade) Mapper
// ============================================================

class PositionMapper {
  const PositionMapper._();

  static PositionEntity fromTradeDto(TradeDto dto) {
    final direction =
        dto.isBuy ? TradeDirection.buy : TradeDirection.sell;
    final units = dto.currentUnitsValue.abs();
    final lots = dto.lots;

    return PositionEntity(
      oandaTradeId: dto.id,
      symbol: dto.instrument,
      direction: direction,
      lots: lots,
      units: units,
      openPrice: dto.priceValue,
      currentPrice: dto.priceValue, // updated by tick stream later
      stopLoss: dto.stopLossOrder?.priceValue,
      takeProfit: dto.takeProfitOrder?.priceValue,
      floatingPnl: dto.unrealizedPlValue,
      swap: dto.financingValue,
      commission: 0.0, // OANDA doesn't charge commission on most accounts
      marginUsed: dto.marginUsedValue,
      openTime: dto.openDateTime,
      magicNumber: _extractMagicNumber(dto.clientExtensions),
      comment: dto.clientExtensions?.comment ?? '',
    );
  }

  static List<PositionEntity> fromTradeDtoList(List<TradeDto> dtos) =>
      dtos.map(fromTradeDto).toList();

  static int _extractMagicNumber(ClientExtensionsDto? ext) {
    if (ext?.id == null) return 0;
    return int.tryParse(ext!.id!) ?? 0;
  }
}

// ============================================================
// 4.4.4 — Order Mapper
// ============================================================

class OrderMapper {
  const OrderMapper._();

  static OrderEntity fromOrderDto(OrderDto dto) {
    final isBuy = dto.isBuy;
    final orderType = _mapOrderType(dto.type, isBuy);

    return OrderEntity(
      oandaOrderId: dto.id,
      symbol: dto.instrument,
      orderType: orderType,
      direction: isBuy ? TradeDirection.buy : TradeDirection.sell,
      lots: dto.unitsValue.abs() / _unitsPerLot(dto.instrument),
      units: dto.unitsValue.abs(),
      price: dto.priceValue,
      priceBound: dto.priceBound != null
          ? double.tryParse(dto.priceBound!)
          : null,
      stopLoss: dto.stopLossOnFill?.priceValue,
      takeProfit: dto.takeProfitOnFill?.priceValue,
      timeInForce: dto.timeInForce,
      expiryTime: dto.gtdTime != null
          ? _parseUnixTimestamp(dto.gtdTime!)
          : null,
      status: OrderStatus.fromString(dto.state ?? ''),
      createTime: dto.createDateTime,
      magicNumber: _extractMagicNumber(dto.clientExtensions),
      comment: dto.clientExtensions?.comment ?? '',
    );
  }

  static List<OrderEntity> fromOrderDtoList(List<OrderDto> dtos) =>
      dtos.map(fromOrderDto).toList();

  static OrderType _mapOrderType(String oandaType, bool isBuy) {
    return switch (oandaType) {
      'LIMIT_ORDER' => isBuy ? OrderType.buyLimit : OrderType.sellLimit,
      'STOP_ORDER' => isBuy ? OrderType.buyStop : OrderType.sellStop,
      'MARKET_IF_TOUCHED_ORDER' =>
        isBuy ? OrderType.buyStopLimit : OrderType.sellStopLimit,
      _ => OrderType.market,
    };
  }

  static double _unitsPerLot(String instrument) {
    return instrument.contains('XAU') || instrument.contains('XAG')
        ? 100.0
        : 100000.0;
  }

  static int _extractMagicNumber(ClientExtensionsDto? ext) {
    if (ext?.id == null) return 0;
    return int.tryParse(ext!.id!) ?? 0;
  }

  static DateTime? _parseUnixTimestamp(String ts) {
    final seconds = double.tryParse(ts);
    if (seconds == null) return null;
    return DateTime.fromMicrosecondsSinceEpoch(
        (seconds * 1000000).round());
  }
}

// ============================================================
// 4.4.5 — Closed Trade Mapper
// ============================================================

class ClosedTradeMapper {
  const ClosedTradeMapper._();

  /// Convert a Drift [ClosedTrade] data class (from the database) to a domain entity.
  static ClosedTradeEntity fromDb(ClosedTrade row) {
    return ClosedTradeEntity(
      oandaTradeId: row.oandaTradeId,
      symbol: row.symbol,
      direction: TradeDirection.fromString(row.direction),
      lots: row.lots,
      units: row.units,
      openPrice: row.openPrice,
      closePrice: row.closePrice,
      openTime: DateTime.fromMicrosecondsSinceEpoch(row.openTimeUs),
      closeTime: DateTime.fromMicrosecondsSinceEpoch(row.closeTimeUs),
      realizedPnl: row.realizedPnl,
      swap: row.swap,
      commission: row.commission,
      netPnl: row.netProfit,
      closeReason: CloseReason.fromString(row.closeReason),
      magicNumber: row.magicNumber,
      comment: row.comment,
      maxProfit: row.maxProfit ?? 0.0,
      maxDrawdown: row.maxDrawdown ?? 0.0,
    );
  }

  /// Map an ORDER_FILL transaction (that closed trades) to ClosedTradeEntity list.
  static List<ClosedTradeEntity> fromTransactionDto(TransactionDto tx) {
    if (!tx.isCloseTrade || tx.tradesClosed == null) return [];

    return tx.tradesClosed!.map((closedTrade) {
      final isBuy = tx.isBuy; // direction of the closing order
      final closePrice = closedTrade.priceValue > 0
          ? closedTrade.priceValue
          : tx.priceValue;

      final netProfit =
          closedTrade.realizedPlValue + tx.financingValue - tx.commissionValue;

      return ClosedTradeEntity(
        oandaTradeId: closedTrade.tradeId ?? '',
        symbol: tx.instrument ?? '',
        direction: !isBuy ? TradeDirection.buy : TradeDirection.sell,
        lots: (double.tryParse(closedTrade.units ?? '0') ?? 0.0).abs() /
            _unitsPerLot(tx.instrument ?? ''),
        units: (double.tryParse(closedTrade.units ?? '0') ?? 0.0).abs(),
        openPrice: 0.0,
        closePrice: closePrice,
        openTime: tx.dateTime,
        closeTime: tx.dateTime,
        realizedPnl: closedTrade.realizedPlValue,
        swap: tx.financingValue,
        commission: tx.commissionValue,
        netPnl: netProfit,
        closeReason: CloseReason.manual,
        magicNumber: _extractMagicNumber(tx.clientExtensions),
        comment: tx.clientExtensions?.comment ?? '',
      );
    }).toList();
  }

  static double _unitsPerLot(String instrument) {
    return instrument.contains('XAU') || instrument.contains('XAG')
        ? 100.0
        : 100000.0;
  }

  static int _extractMagicNumber(ClientExtensionsDto? ext) {
    if (ext?.id == null) return 0;
    return int.tryParse(ext!.id!) ?? 0;
  }
}

// ============================================================
// 4.4.6 — Candle Mapper
// ============================================================

class CandleMapper {
  const CandleMapper._();

  static CandleEntity fromDb(dynamic row) {
    return CandleEntity(
      symbol: row.symbol,
      timeframe: row.timeframe,
      openTime: DateTime.fromMicrosecondsSinceEpoch(row.openTimeUs),
      open: row.open,
      high: row.high,
      low: row.low,
      close: row.close,
      volume: row.volume,
      isComplete: row.isComplete,
    );
  }

  static CandleEntity fromDto({
    required CandleDto dto,
    required String symbol,
    required Timeframe timeframe,
  }) {
    final ohlc = dto.mid ?? dto.bid ?? dto.ask;

    return CandleEntity(
      symbol: symbol,
      timeframe: timeframe.oandaName,
      open: ohlc?.openValue ?? 0.0,
      high: ohlc?.highValue ?? 0.0,
      low: ohlc?.lowValue ?? 0.0,
      close: ohlc?.closeValue ?? 0.0,
      volume: double.tryParse(dto.volume) ?? 0.0,
      openTime: dto.openDateTime,
      isComplete: dto.complete,
    );
  }

  static List<CandleEntity> fromDtoList({
    required List<CandleDto> dtos,
    required String symbol,
    required Timeframe timeframe,
  }) {
    return dtos
        .map((dto) => fromDto(dto: dto, symbol: symbol, timeframe: timeframe))
        .toList();
  }
}

// ============================================================
// 4.4.7 — Tick Mapper (from REST pricing snapshot)
// ============================================================

class TickMapper {
  const TickMapper._();

  static TickEntity fromPriceDto(PriceDto dto) {
    final bid = dto.bestBid;
    final ask = dto.bestAsk;
    final spread = ask - bid;

    return TickEntity(
      symbol: dto.instrument,
      bid: bid,
      ask: ask,
      spread: spread,
      timestamp: dto.dateTime,
    );
  }
}
