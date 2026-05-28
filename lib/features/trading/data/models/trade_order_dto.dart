// Path: lib/features/trading/data/models/trade_order_dto.dart
// ============================================================
// MT5 Clone — Trade/Order DTOs
// OANDA trade and order response data transfer objects.
// ============================================================

import 'package:json_annotation/json_annotation.dart';

import '../../../account/data/models/account_dto.dart';

part 'trade_order_dto.g.dart';

@JsonSerializable()
class TradeDto {
  final String id;
  final String instrument;
  final String currentUnits;
  final String? unrealizedPL;
  final String? price;
  @JsonKey(name: 'openTime')
  final String? openTime;
  final StopLossOrderDto? stopLossOrder;
  final TakeProfitOrderDto? takeProfitOrder;
  final TrailingStopLossOrderDto? trailingStopLossOrder;
  final ClientExtensionsDto? clientExtensions;
  final String? financing;
  final String? marginUsed;

  const TradeDto({
    required this.id,
    required this.instrument,
    required this.currentUnits,
    this.unrealizedPL,
    this.price,
    this.openTime,
    this.stopLossOrder,
    this.takeProfitOrder,
    this.trailingStopLossOrder,
    this.clientExtensions,
    this.financing,
    this.marginUsed,
  });

  // Computed getters for mapper convenience
  double get priceValue => double.tryParse(price ?? '0') ?? 0.0;
  bool get isBuy => (double.tryParse(currentUnits ?? '0') ?? 0) > 0;
  double get lots =>
      (double.tryParse(currentUnits ?? '0') ?? 0).abs() / 100000.0;
  double get currentUnitsValue =>
      double.tryParse(currentUnits ?? '0') ?? 0.0;
  double get unrealizedPlValue =>
      double.tryParse(unrealizedPL ?? '0') ?? 0.0;
  double get financingValue =>
      double.tryParse(financing ?? '0') ?? 0.0;
  double get marginUsedValue =>
      double.tryParse(marginUsed ?? '0') ?? 0.0;
  DateTime get openDateTime {
    final epochSeconds = double.tryParse(openTime ?? '0') ?? 0.0;
    return DateTime.fromMicrosecondsSinceEpoch(
        (epochSeconds * 1000000).round());
  }

  factory TradeDto.fromJson(Map<String, dynamic> json) =>
      _$TradeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TradeDtoToJson(this);
}

@JsonSerializable()
class OrderDto {
  final String id;
  final String type;
  final String instrument;
  final String units;
  final String? price;
  final String? priceBound;
  final String timeInForce;
  final String? createTime;
  final StopLossOrderDto? stopLossOrder;
  final TakeProfitOrderDto? takeProfitOrder;
  final ClientExtensionsDto? clientExtensions;
  final String? state;
  final String? gtdTime;

  const OrderDto({
    required this.id,
    required this.type,
    required this.instrument,
    required this.units,
    this.price,
    this.priceBound,
    required this.timeInForce,
    this.createTime,
    this.stopLossOrder,
    this.takeProfitOrder,
    this.clientExtensions,
    this.state,
    this.gtdTime,
  });

  // Computed getters for mapper convenience
  bool get isBuy => (double.tryParse(units ?? '0') ?? 0) > 0;
  double get unitsValue => double.tryParse(units ?? '0') ?? 0.0;
  double get priceValue => double.tryParse(price ?? '0') ?? 0.0;
  DateTime get createDateTime {
    final epochSeconds = double.tryParse(createTime ?? '0') ?? 0.0;
    return DateTime.fromMicrosecondsSinceEpoch(
        (epochSeconds * 1000000).round());
  }

  /// Alias: mapper references stopLossOnFill for pending order SL
  StopLossOrderDto? get stopLossOnFill => stopLossOrder;

  /// Alias: mapper references takeProfitOnFill for pending order TP
  TakeProfitOrderDto? get takeProfitOnFill => takeProfitOrder;

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}

@JsonSerializable()
class StopLossOrderDto {
  final String? price;
  final String? distance;

  const StopLossOrderDto({this.price, this.distance});

  double get priceValue => double.tryParse(price ?? '0') ?? 0.0;

  factory StopLossOrderDto.fromJson(Map<String, dynamic> json) =>
      _$StopLossOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StopLossOrderDtoToJson(this);
}

@JsonSerializable()
class TakeProfitOrderDto {
  final String? price;
  final String? distance;

  const TakeProfitOrderDto({this.price, this.distance});

  double get priceValue => double.tryParse(price ?? '0') ?? 0.0;

  factory TakeProfitOrderDto.fromJson(Map<String, dynamic> json) =>
      _$TakeProfitOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TakeProfitOrderDtoToJson(this);
}

@JsonSerializable()
class TrailingStopLossOrderDto {
  final String? distance;

  const TrailingStopLossOrderDto({this.distance});

  factory TrailingStopLossOrderDto.fromJson(Map<String, dynamic> json) =>
      _$TrailingStopLossOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TrailingStopLossOrderDtoToJson(this);
}

@JsonSerializable()
class ClientExtensionsDto {
  final String? id;
  final String? tag;
  final String? comment;

  const ClientExtensionsDto({this.id, this.tag, this.comment});

  factory ClientExtensionsDto.fromJson(Map<String, dynamic> json) =>
      _$ClientExtensionsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClientExtensionsDtoToJson(this);
}

// ============================================================
// Price DTO (REST pricing snapshot)
// ============================================================

class PriceDto {
  final String instrument;
  final String time;
  final String closeoutBid;
  final String closeoutAsk;
  final List<PriceBucketDto> bids;
  final List<PriceBucketDto> asks;
  final bool tradeable;

  const PriceDto({
    required this.instrument,
    required this.time,
    required this.closeoutBid,
    required this.closeoutAsk,
    this.bids = const [],
    this.asks = const [],
    this.tradeable = true,
  });

  double get bestBid => bids.isNotEmpty
      ? bids.first.priceValue
      : (double.tryParse(closeoutBid) ?? 0.0);
  double get bestAsk => asks.isNotEmpty
      ? asks.first.priceValue
      : (double.tryParse(closeoutAsk) ?? 0.0);
  DateTime get dateTime {
    final epochSeconds = double.tryParse(time) ?? 0.0;
    return DateTime.fromMicrosecondsSinceEpoch(
        (epochSeconds * 1000000).round());
  }

  factory PriceDto.fromJson(Map<String, dynamic> json) {
    List<PriceBucketDto> parseBuckets(dynamic raw) {
      if (raw == null) return [];
      return (raw as List)
          .map((b) =>
              PriceBucketDto.fromJson(Map<String, dynamic>.from(b as Map)))
          .toList();
    }

    return PriceDto(
      instrument: json['instrument'] as String? ?? '',
      time: json['time'] as String? ?? '0',
      closeoutBid: json['closeoutBid'] as String? ?? '0',
      closeoutAsk: json['closeoutAsk'] as String? ?? '0',
      bids: parseBuckets(json['bids']),
      asks: parseBuckets(json['asks']),
      tradeable: json['tradeable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'instrument': instrument,
        'time': time,
        'closeoutBid': closeoutBid,
        'closeoutAsk': closeoutAsk,
        'bids': bids.map((b) => b.toJson()).toList(),
        'asks': asks.map((a) => a.toJson()).toList(),
        'tradeable': tradeable,
      };
}

class PriceBucketDto {
  final String price;
  final int liquidity;

  const PriceBucketDto({required this.price, required this.liquidity});

  double get priceValue => double.tryParse(price) ?? 0.0;

  factory PriceBucketDto.fromJson(Map<String, dynamic> json) {
    return PriceBucketDto(
      price: json['price'] as String? ?? '0',
      liquidity: (json['liquidity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'price': price,
        'liquidity': liquidity,
      };
}

// ============================================================
// Request DTOs for order creation
// ============================================================

class CreateOrderRequestDto {
  final CreateOrderBodyDto order;

  const CreateOrderRequestDto({required this.order});

  Map<String, dynamic> toJson() => {'order': order.toJson()};
}

class CreateOrderBodyDto {
  final String type;
  final String instrument;
  final String units;
  final String timeInForce;
  final String? price;
  final String? priceBound;
  final String? gtdTime;
  final TpOnFillDto? takeProfitOnFill;
  final SlOnFillDto? stopLossOnFill;
  final ClientExtensionsDto? clientExtensions;
  final ClientExtensionsDto? tradeClientExtensions;

  const CreateOrderBodyDto({
    required this.type,
    required this.instrument,
    required this.units,
    required this.timeInForce,
    this.price,
    this.priceBound,
    this.gtdTime,
    this.takeProfitOnFill,
    this.stopLossOnFill,
    this.clientExtensions,
    this.tradeClientExtensions,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
      'instrument': instrument,
      'units': units,
      'timeInForce': timeInForce,
    };
    if (price != null) json['price'] = price;
    if (priceBound != null) json['priceBound'] = priceBound;
    if (gtdTime != null) json['gtdTime'] = gtdTime;
    if (takeProfitOnFill != null) {
      json['takeProfitOnFill'] = takeProfitOnFill!.toJson();
    }
    if (stopLossOnFill != null) {
      json['stopLossOnFill'] = stopLossOnFill!.toJson();
    }
    if (clientExtensions != null) {
      json['clientExtensions'] = clientExtensions!.toJson();
    }
    if (tradeClientExtensions != null) {
      json['tradeClientExtensions'] = tradeClientExtensions!.toJson();
    }
    return json;
  }
}

class SlOnFillDto {
  final String price;

  const SlOnFillDto({required this.price});

  Map<String, dynamic> toJson() => {'price': price};
}

class TpOnFillDto {
  final String price;

  const TpOnFillDto({required this.price});

  Map<String, dynamic> toJson() => {'price': price};
}

// ============================================================
// Response wrapper DTOs
// ============================================================

class AccountListItemDto {
  final String id;
  final List<String> tags;

  const AccountListItemDto({required this.id, this.tags = const []});

  factory AccountListItemDto.fromJson(Map<String, dynamic> json) {
    return AccountListItemDto(
      id: json['id'] as String,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class AccountsListResponseDto {
  final List<AccountListItemDto> accounts;

  const AccountsListResponseDto({required this.accounts});

  factory AccountsListResponseDto.fromJson(Map<String, dynamic> json) {
    return AccountsListResponseDto(
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => AccountListItemDto.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class AccountSummaryResponseDto {
  final AccountSummaryDto account;

  const AccountSummaryResponseDto({required this.account});

  factory AccountSummaryResponseDto.fromJson(Map<String, dynamic> json) {
    return AccountSummaryResponseDto(
      account: AccountSummaryDto.fromJson(
          Map<String, dynamic>.from(json['account'] as Map)),
    );
  }
}

class InstrumentsResponseDto {
  final List<InstrumentDto> instruments;

  const InstrumentsResponseDto({required this.instruments});

  factory InstrumentsResponseDto.fromJson(Map<String, dynamic> json) {
    return InstrumentsResponseDto(
      instruments: (json['instruments'] as List<dynamic>)
          .map((e) =>
              InstrumentDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class PricingResponseDto {
  final List<PriceDto> prices;

  const PricingResponseDto({required this.prices});

  factory PricingResponseDto.fromJson(Map<String, dynamic> json) {
    return PricingResponseDto(
      prices: (json['prices'] as List<dynamic>)
          .map((e) =>
              PriceDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class PendingOrdersResponseDto {
  final List<OrderDto> orders;

  const PendingOrdersResponseDto({required this.orders});

  factory PendingOrdersResponseDto.fromJson(Map<String, dynamic> json) {
    return PendingOrdersResponseDto(
      orders: (json['orders'] as List<dynamic>)
          .map((e) =>
              OrderDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class OpenTradesResponseDto {
  final List<TradeDto> trades;

  const OpenTradesResponseDto({required this.trades});

  factory OpenTradesResponseDto.fromJson(Map<String, dynamic> json) {
    return OpenTradesResponseDto(
      trades: (json['trades'] as List<dynamic>)
          .map((e) =>
              TradeDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class SingleTradeResponseDto {
  final TradeDto trade;

  const SingleTradeResponseDto({required this.trade});

  factory SingleTradeResponseDto.fromJson(Map<String, dynamic> json) {
    return SingleTradeResponseDto(
      trade: TradeDto.fromJson(
          Map<String, dynamic>.from(json['trade'] as Map)),
    );
  }
}

class OrderFillResponseDto {
  final OrderFillTransactionDto? orderFillTransaction;

  const OrderFillResponseDto({this.orderFillTransaction});

  factory OrderFillResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderFillResponseDto(
      orderFillTransaction: json['orderFillTransaction'] != null
          ? OrderFillTransactionDto.fromJson(
              Map<String, dynamic>.from(
                  json['orderFillTransaction'] as Map))
          : null,
    );
  }
}

class OrderFillTransactionDto {
  final String? id;
  final String? type;
  final String? time;
  final String? tradeOpened;

  const OrderFillTransactionDto({
    this.id,
    this.type,
    this.time,
    this.tradeOpened,
  });

  factory OrderFillTransactionDto.fromJson(Map<String, dynamic> json) {
    // OANDA returns tradeOpened as an object {tradeID: "...", units: "..."}
    // Extract just the tradeID for convenience.
    String? tradeId;
    final tradeOpenedRaw = json['tradeOpened'];
    if (tradeOpenedRaw is Map) {
      tradeId = tradeOpenedRaw['tradeID'] as String?;
    }

    return OrderFillTransactionDto(
      id: json['id'] as String?,
      type: json['type'] as String?,
      time: json['time'] as String?,
      tradeOpened: tradeId,
    );
  }
}

class ModifyTradeResponseDto {
  const ModifyTradeResponseDto();

  factory ModifyTradeResponseDto.fromJson(Map<String, dynamic> json) {
    return const ModifyTradeResponseDto();
  }
}
