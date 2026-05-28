// Path: lib/features/trading/data/models/transaction_candle_dto.dart
// ============================================================
// MT5 Clone — Transaction & Candle DTOs
// ============================================================

import 'package:json_annotation/json_annotation.dart';

import 'trade_order_dto.dart';

part 'transaction_candle_dto.g.dart';

@JsonSerializable()
class TransactionDto {
  final String id;
  final String type;
  final String? accountID;
  final String? instrument;
  final String? units;
  final String? price;
  final String? pl;
  final String? financing;
  final String? commission;
  final String? tradeID;
  final String? orderID;
  final String? reason;
  final String? time;
  final int? accountBalance;
  final List<ClosedTradeDto>? tradesClosed;
  final ClientExtensionsDto? clientExtensions;

  const TransactionDto({
    required this.id,
    required this.type,
    this.accountID,
    this.instrument,
    this.units,
    this.price,
    this.pl,
    this.financing,
    this.commission,
    this.tradeID,
    this.orderID,
    this.reason,
    this.time,
    this.accountBalance,
    this.tradesClosed,
    this.clientExtensions,
  });

  // Computed getters for mapper convenience
  bool get isCloseTrade =>
      type == 'ORDER_FILL' &&
      tradesClosed != null &&
      tradesClosed!.isNotEmpty;
  bool get isBuy => (double.tryParse(units ?? '0') ?? 0) > 0;
  double get priceValue => double.tryParse(price ?? '0') ?? 0.0;
  double get financingValue => double.tryParse(financing ?? '0') ?? 0.0;
  double get commissionValue =>
      double.tryParse(commission ?? '0') ?? 0.0;
  DateTime get dateTime {
    final epochSeconds = double.tryParse(time ?? '0') ?? 0.0;
    return DateTime.fromMicrosecondsSinceEpoch(
        (epochSeconds * 1000000).round());
  }

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionDtoToJson(this);
}

@JsonSerializable()
class CandlestickResponseDto {
  final List<CandleDto> candles;
  final String instrument;
  final String granularity;

  const CandlestickResponseDto({
    required this.candles,
    required this.instrument,
    required this.granularity,
  });

  factory CandlestickResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CandlestickResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CandlestickResponseDtoToJson(this);
}

@JsonSerializable()
class CandleDto {
  final CandlePriceDto? mid;
  final CandlePriceDto? bid;
  final CandlePriceDto? ask;
  final String volume;
  final bool complete;
  final String time;

  const CandleDto({
    this.mid,
    this.bid,
    this.ask,
    required this.volume,
    required this.complete,
    required this.time,
  });

  // Computed getters for mapper convenience
  DateTime get openDateTime {
    final epochSeconds = double.tryParse(time) ?? 0.0;
    return DateTime.fromMicrosecondsSinceEpoch(
        (epochSeconds * 1000000).round());
  }

  factory CandleDto.fromJson(Map<String, dynamic> json) =>
      _$CandleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CandleDtoToJson(this);
}

@JsonSerializable()
class CandlePriceDto {
  final String o;
  final String h;
  final String l;
  final String c;

  const CandlePriceDto({
    required this.o,
    required this.h,
    required this.l,
    required this.c,
  });

  // Computed getters for mapper convenience
  double get openValue => double.tryParse(o) ?? 0.0;
  double get highValue => double.tryParse(h) ?? 0.0;
  double get lowValue => double.tryParse(l) ?? 0.0;
  double get closeValue => double.tryParse(c) ?? 0.0;

  factory CandlePriceDto.fromJson(Map<String, dynamic> json) =>
      _$CandlePriceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CandlePriceDtoToJson(this);
}

// ============================================================
// Closed Trade DTO (within a transaction)
// ============================================================

class ClosedTradeDto {
  final String? tradeId;
  final String? units;
  final String? price;
  final String? realizedPL;

  const ClosedTradeDto({
    this.tradeId,
    this.units,
    this.price,
    this.realizedPL,
  });

  double get priceValue => double.tryParse(price ?? '0') ?? 0.0;
  double get realizedPlValue =>
      double.tryParse(realizedPL ?? '0') ?? 0.0;

  factory ClosedTradeDto.fromJson(Map<String, dynamic> json) {
    return ClosedTradeDto(
      tradeId: json['tradeID'] as String?,
      units: json['units'] as String?,
      price: json['price'] as String?,
      realizedPL: json['realizedPL'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'tradeID': tradeId,
        'units': units,
        'price': price,
        'realizedPL': realizedPL,
      };
}

// ============================================================
// Response wrapper DTOs
// ============================================================

class CandlesResponseDto {
  final List<CandleDto> candles;
  final String instrument;
  final String granularity;

  const CandlesResponseDto({
    required this.candles,
    required this.instrument,
    required this.granularity,
  });

  factory CandlesResponseDto.fromJson(Map<String, dynamic> json) {
    return CandlesResponseDto(
      candles: (json['candles'] as List<dynamic>)
          .map((e) =>
              CandleDto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      instrument: json['instrument'] as String? ?? '',
      granularity: json['granularity'] as String? ?? '',
    );
  }
}

class TransactionsResponseDto {
  final List<TransactionDto> transactions;

  const TransactionsResponseDto({required this.transactions});

  factory TransactionsResponseDto.fromJson(Map<String, dynamic> json) {
    return TransactionsResponseDto(
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionDto.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }
}
