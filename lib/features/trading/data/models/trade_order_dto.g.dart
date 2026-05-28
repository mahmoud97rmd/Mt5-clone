// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeDto _$TradeDtoFromJson(Map<String, dynamic> json) => TradeDto(
      id: json['id'] as String,
      instrument: json['instrument'] as String,
      currentUnits: json['currentUnits'] as String,
      unrealizedPL: json['unrealizedPL'] as String?,
      price: json['price'] as String?,
      openTime: json['openTime'] as String?,
      stopLossOrder: json['stopLossOrder'] == null
          ? null
          : StopLossOrderDto.fromJson(
              json['stopLossOrder'] as Map<String, dynamic>),
      takeProfitOrder: json['takeProfitOrder'] == null
          ? null
          : TakeProfitOrderDto.fromJson(
              json['takeProfitOrder'] as Map<String, dynamic>),
      trailingStopLossOrder: json['trailingStopLossOrder'] == null
          ? null
          : TrailingStopLossOrderDto.fromJson(
              json['trailingStopLossOrder'] as Map<String, dynamic>),
      clientExtensions: json['clientExtensions'] == null
          ? null
          : ClientExtensionsDto.fromJson(
              json['clientExtensions'] as Map<String, dynamic>),
      financing: json['financing'] as String?,
      marginUsed: json['marginUsed'] as String?,
    );

Map<String, dynamic> _$TradeDtoToJson(TradeDto instance) => <String, dynamic>{
      'id': instance.id,
      'instrument': instance.instrument,
      'currentUnits': instance.currentUnits,
      'unrealizedPL': instance.unrealizedPL,
      'price': instance.price,
      'openTime': instance.openTime,
      'stopLossOrder': instance.stopLossOrder,
      'takeProfitOrder': instance.takeProfitOrder,
      'trailingStopLossOrder': instance.trailingStopLossOrder,
      'clientExtensions': instance.clientExtensions,
      'financing': instance.financing,
      'marginUsed': instance.marginUsed,
    };

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
      id: json['id'] as String,
      type: json['type'] as String,
      instrument: json['instrument'] as String,
      units: json['units'] as String,
      price: json['price'] as String?,
      priceBound: json['priceBound'] as String?,
      timeInForce: json['timeInForce'] as String,
      createTime: json['createTime'] as String?,
      stopLossOrder: json['stopLossOrder'] == null
          ? null
          : StopLossOrderDto.fromJson(
              json['stopLossOrder'] as Map<String, dynamic>),
      takeProfitOrder: json['takeProfitOrder'] == null
          ? null
          : TakeProfitOrderDto.fromJson(
              json['takeProfitOrder'] as Map<String, dynamic>),
      clientExtensions: json['clientExtensions'] == null
          ? null
          : ClientExtensionsDto.fromJson(
              json['clientExtensions'] as Map<String, dynamic>),
      state: json['state'] as String?,
      gtdTime: json['gtdTime'] as String?,
    );

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'instrument': instance.instrument,
      'units': instance.units,
      'price': instance.price,
      'priceBound': instance.priceBound,
      'timeInForce': instance.timeInForce,
      'createTime': instance.createTime,
      'stopLossOrder': instance.stopLossOrder,
      'takeProfitOrder': instance.takeProfitOrder,
      'clientExtensions': instance.clientExtensions,
      'state': instance.state,
      'gtdTime': instance.gtdTime,
    };

StopLossOrderDto _$StopLossOrderDtoFromJson(Map<String, dynamic> json) =>
    StopLossOrderDto(
      price: json['price'] as String?,
      distance: json['distance'] as String?,
    );

Map<String, dynamic> _$StopLossOrderDtoToJson(StopLossOrderDto instance) =>
    <String, dynamic>{
      'price': instance.price,
      'distance': instance.distance,
    };

TakeProfitOrderDto _$TakeProfitOrderDtoFromJson(Map<String, dynamic> json) =>
    TakeProfitOrderDto(
      price: json['price'] as String?,
      distance: json['distance'] as String?,
    );

Map<String, dynamic> _$TakeProfitOrderDtoToJson(TakeProfitOrderDto instance) =>
    <String, dynamic>{
      'price': instance.price,
      'distance': instance.distance,
    };

TrailingStopLossOrderDto _$TrailingStopLossOrderDtoFromJson(
        Map<String, dynamic> json) =>
    TrailingStopLossOrderDto(
      distance: json['distance'] as String?,
    );

Map<String, dynamic> _$TrailingStopLossOrderDtoToJson(
        TrailingStopLossOrderDto instance) =>
    <String, dynamic>{
      'distance': instance.distance,
    };

ClientExtensionsDto _$ClientExtensionsDtoFromJson(Map<String, dynamic> json) =>
    ClientExtensionsDto(
      id: json['id'] as String?,
      tag: json['tag'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ClientExtensionsDtoToJson(
        ClientExtensionsDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'comment': instance.comment,
    };
