// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSummaryDto _$AccountSummaryDtoFromJson(Map<String, dynamic> json) =>
    AccountSummaryDto(
      id: json['id'] as String,
      currency: json['currency'] as String,
      balance: json['balance'] as String,
      unrealizedPl: json['unrealizedPL'] as String,
      realizedPl: json['realizedPL'] as String,
      marginUsed: json['marginUsed'] as String,
      marginAvailable: json['marginAvailable'] as String,
      marginRate: json['marginRate'] as String,
      nav: json['nav'] as String,
      openTradeCount: (json['openTradeCount'] as num).toInt(),
      pendingOrderCount: (json['pendingOrderCount'] as num).toInt(),
    );

Map<String, dynamic> _$AccountSummaryDtoToJson(AccountSummaryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'balance': instance.balance,
      'unrealizedPL': instance.unrealizedPl,
      'realizedPL': instance.realizedPl,
      'marginUsed': instance.marginUsed,
      'marginAvailable': instance.marginAvailable,
      'marginRate': instance.marginRate,
      'nav': instance.nav,
      'openTradeCount': instance.openTradeCount,
      'pendingOrderCount': instance.pendingOrderCount,
    };

InstrumentDto _$InstrumentDtoFromJson(Map<String, dynamic> json) =>
    InstrumentDto(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      type: json['type'] as String,
      pipLocation:
          PipLocationDto.fromJson(json['pipLocation'] as Map<String, dynamic>),
      unitsPerLot: json['unitsPerLot'] as String,
      displayPrecision: (json['displayPrecision'] as num).toInt(),
      marginRate: json['marginRate'] == null
          ? null
          : MarginRateDto.fromJson(json['marginRate'] as Map<String, dynamic>),
      minimumTradeSize: json['minimumTradeSize'] as String?,
    );

Map<String, dynamic> _$InstrumentDtoToJson(InstrumentDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'type': instance.type,
      'pipLocation': instance.pipLocation,
      'unitsPerLot': instance.unitsPerLot,
      'displayPrecision': instance.displayPrecision,
      'marginRate': instance.marginRate,
      'minimumTradeSize': instance.minimumTradeSize,
    };

PipLocationDto _$PipLocationDtoFromJson(Map<String, dynamic> json) =>
    PipLocationDto(
      location: (json['location'] as num).toInt(),
    );

Map<String, dynamic> _$PipLocationDtoToJson(PipLocationDto instance) =>
    <String, dynamic>{
      'location': instance.location,
    };

MarginRateDto _$MarginRateDtoFromJson(Map<String, dynamic> json) =>
    MarginRateDto(
      defaultMarginRate: json['defaultMarginRate'] as String,
    );

Map<String, dynamic> _$MarginRateDtoToJson(MarginRateDto instance) =>
    <String, dynamic>{
      'defaultMarginRate': instance.defaultMarginRate,
    };
