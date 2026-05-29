// Path: lib/features/account/data/models/account_dto.dart
// ============================================================
// MT5 Clone — Account DTO
// OANDA account response data transfer object.
// ============================================================

import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class AccountSummaryDto {
  final String id;
  final String currency;
  final String balance;
  @JsonKey(name: 'unrealizedPL')
  final String unrealizedPl;
  @JsonKey(name: 'realizedPL')
  final String realizedPl;
  final String marginUsed;
  final String marginAvailable;
  final String marginRate;
  final String nav;
  final int openTradeCount;
  final int pendingOrderCount;

  const AccountSummaryDto({
    required this.id,
    required this.currency,
    required this.balance,
    required this.unrealizedPl,
    required this.realizedPl,
    required this.marginUsed,
    required this.marginAvailable,
    required this.marginRate,
    required this.nav,
    required this.openTradeCount,
    required this.pendingOrderCount,
  });

  factory AccountSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$AccountSummaryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSummaryDtoToJson(this);

  // Computed double getters for mapper convenience
  double get balanceValue => double.tryParse(balance) ?? 0.0;
  double get navValue => double.tryParse(nav) ?? 0.0;
  double get marginUsedValue => double.tryParse(marginUsed) ?? 0.0;
  double get marginAvailableValue => double.tryParse(marginAvailable) ?? 0.0;
  double get marginRateValue => double.tryParse(marginRate) ?? 0.0;
  double get unrealizedPlValue => double.tryParse(unrealizedPl) ?? 0.0;
  double get realizedPlValue => double.tryParse(realizedPl) ?? 0.0;
  String? get alias => null; // OANDA doesn't return alias in summary
}

@JsonSerializable()
class InstrumentDto {
  final String name;
  final String displayName;
  final String type;
  final PipLocationDto pipLocation;
  final String unitsPerLot;
  final int displayPrecision;
  final MarginRateDto? marginRate;
  @JsonKey(name: 'minimumTradeSize')
  final String? minimumTradeSize;

  const InstrumentDto({
    required this.name,
    required this.displayName,
    required this.type,
    required this.pipLocation,
    required this.unitsPerLot,
    required this.displayPrecision,
    this.marginRate,
    this.minimumTradeSize,
  });

  factory InstrumentDto.fromJson(Map<String, dynamic> json) =>
      _$InstrumentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$InstrumentDtoToJson(this);

  // Computed getters for mapper convenience
  int get pipLocationValue => pipLocation.location;
  double get marginRateValue =>
      marginRate != null
          ? (double.tryParse(marginRate!.defaultMarginRate) ?? 0.0)
          : 0.0;
  double get minimumTradeSizeValue =>
      double.tryParse(minimumTradeSize ?? '1') ?? 1.0;
  int get tradeUnitsPrecision => 0; // OANDA doesn't provide this directly
}

@JsonSerializable()
class PipLocationDto {
  final int location;

  const PipLocationDto({required this.location});

  factory PipLocationDto.fromJson(Map<String, dynamic> json) =>
      _$PipLocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PipLocationDtoToJson(this);
}

@JsonSerializable()
class MarginRateDto {
  final String defaultMarginRate;

  const MarginRateDto({required this.defaultMarginRate});

  factory MarginRateDto.fromJson(Map<String, dynamic> json) =>
      _$MarginRateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MarginRateDtoToJson(this);
}
