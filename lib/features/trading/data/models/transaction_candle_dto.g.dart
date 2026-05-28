// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_candle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    TransactionDto(
      id: json['id'] as String,
      type: json['type'] as String,
      accountID: json['accountID'] as String?,
      instrument: json['instrument'] as String?,
      units: json['units'] as String?,
      price: json['price'] as String?,
      pl: json['pl'] as String?,
      financing: json['financing'] as String?,
      commission: json['commission'] as String?,
      tradeID: json['tradeID'] as String?,
      orderID: json['orderID'] as String?,
      reason: json['reason'] as String?,
      time: json['time'] as String?,
      accountBalance: (json['accountBalance'] as num?)?.toInt(),
      tradesClosed: (json['tradesClosed'] as List<dynamic>?)
          ?.map((e) => ClosedTradeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      clientExtensions: json['clientExtensions'] == null
          ? null
          : ClientExtensionsDto.fromJson(
              json['clientExtensions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionDtoToJson(TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'accountID': instance.accountID,
      'instrument': instance.instrument,
      'units': instance.units,
      'price': instance.price,
      'pl': instance.pl,
      'financing': instance.financing,
      'commission': instance.commission,
      'tradeID': instance.tradeID,
      'orderID': instance.orderID,
      'reason': instance.reason,
      'time': instance.time,
      'accountBalance': instance.accountBalance,
      'tradesClosed': instance.tradesClosed,
      'clientExtensions': instance.clientExtensions,
    };

CandlestickResponseDto _$CandlestickResponseDtoFromJson(
        Map<String, dynamic> json) =>
    CandlestickResponseDto(
      candles: (json['candles'] as List<dynamic>)
          .map((e) => CandleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      instrument: json['instrument'] as String,
      granularity: json['granularity'] as String,
    );

Map<String, dynamic> _$CandlestickResponseDtoToJson(
        CandlestickResponseDto instance) =>
    <String, dynamic>{
      'candles': instance.candles,
      'instrument': instance.instrument,
      'granularity': instance.granularity,
    };

CandleDto _$CandleDtoFromJson(Map<String, dynamic> json) => CandleDto(
      mid: json['mid'] == null
          ? null
          : CandlePriceDto.fromJson(json['mid'] as Map<String, dynamic>),
      bid: json['bid'] == null
          ? null
          : CandlePriceDto.fromJson(json['bid'] as Map<String, dynamic>),
      ask: json['ask'] == null
          ? null
          : CandlePriceDto.fromJson(json['ask'] as Map<String, dynamic>),
      volume: json['volume'] as String,
      complete: json['complete'] as bool,
      time: json['time'] as String,
    );

Map<String, dynamic> _$CandleDtoToJson(CandleDto instance) => <String, dynamic>{
      'mid': instance.mid,
      'bid': instance.bid,
      'ask': instance.ask,
      'volume': instance.volume,
      'complete': instance.complete,
      'time': instance.time,
    };

CandlePriceDto _$CandlePriceDtoFromJson(Map<String, dynamic> json) =>
    CandlePriceDto(
      o: json['o'] as String,
      h: json['h'] as String,
      l: json['l'] as String,
      c: json['c'] as String,
    );

Map<String, dynamic> _$CandlePriceDtoToJson(CandlePriceDto instance) =>
    <String, dynamic>{
      'o': instance.o,
      'h': instance.h,
      'l': instance.l,
      'c': instance.c,
    };
