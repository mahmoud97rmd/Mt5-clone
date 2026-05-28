// Path: lib/features/history/data/mappers/history_mappers.dart
// ============================================================
// MT5 Clone — History Mappers
// Maps between DB rows and domain entities for history data.
// ============================================================

import '../../../../core/domain/entities/closed_trade_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';


class ClosedTradeMapper {
  static ClosedTradeEntity fromDb(dynamic row) {
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
      comment: row.comment ?? '',
      maxProfit: row.maxProfit ?? 0,
      maxDrawdown: row.maxDrawdown ?? 0,
    );
  }

  static ClosedTradeEntity fromTransactionDto(dynamic dto) {
    final timeStr = dto.time ?? '';
    final timestamp = double.tryParse(timeStr) ?? 0;
    final timeUs = (timestamp * 1e6).round();

    return ClosedTradeEntity(
      oandaTradeId: dto.tradeID ?? dto.id,
      symbol: dto.instrument ?? '',
      direction: _directionFromUnits(dto.units),
      lots: _lotsFromUnits(dto.units),
      units: (double.tryParse(dto.units ?? '0') ?? 0).abs(),
      openPrice: 0, // Will be filled from trade details
      closePrice: double.tryParse(dto.price ?? '0') ?? 0,
      openTime: DateTime.fromMicrosecondsSinceEpoch(timeUs),
      closeTime: DateTime.fromMicrosecondsSinceEpoch(timeUs),
      realizedPnl: double.tryParse(dto.pl ?? '0') ?? 0,
      swap: double.tryParse(dto.financing ?? '0') ?? 0,
      commission: double.tryParse(dto.commission ?? '0') ?? 0,
      netPnl: (double.tryParse(dto.pl ?? '0') ?? 0) +
          (double.tryParse(dto.financing ?? '0') ?? 0) -
          (double.tryParse(dto.commission ?? '0') ?? 0).abs(),
      closeReason: _reasonFromString(dto.reason),
    );
  }

  static TradeDirection _directionFromUnits(String? units) {
    final val = double.tryParse(units ?? '0') ?? 0;
    return val > 0 ? TradeDirection.buy : TradeDirection.sell;
  }

  static double _lotsFromUnits(String? units) {
    final val = (double.tryParse(units ?? '0') ?? 0).abs();
    return val / 100000; // Approximate
  }

  static CloseReason _reasonFromString(String? reason) {
    switch (reason?.toUpperCase()) {
      case 'STOP_LOSS_ORDER': return CloseReason.stopLoss;
      case 'TAKE_PROFIT_ORDER': return CloseReason.takeProfit;
      case 'MARGIN_CLOSEOUT': return CloseReason.marginCall;
      default: return CloseReason.manual;
    }
  }
}
