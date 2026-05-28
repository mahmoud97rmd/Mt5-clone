// Path: lib/core/domain/entities/symbol_entity.dart
// ============================================================
// MT5 Clone — Symbol Domain Entity
// Represents a tradeable instrument with its metadata.
// ============================================================

import 'package:equatable/equatable.dart';

import '../enums/trading_enums.dart';

class SymbolEntity extends Equatable {
  final String name;
  final String displayName;
  final String displayLabel;
  final InstrumentType type;
  final double pipSize;
  final int pipLocation;
  final double unitsPerLot;
  final int displayPrecision;
  final double? marginRate;
  final double? minimumTradeSize;
  final double? minLot;
  final double? maxLot;
  final double? lotStep;
  final double tradeUnitsPrecision;
  final bool isWatchlisted;
  final int watchlistSortOrder;
  final int sortOrder;

  SymbolEntity({
    required this.name,
    required this.displayName,
    String? displayLabel,
    this.type = InstrumentType.currency,
    required this.pipSize,
    required this.pipLocation,
    this.unitsPerLot = 100000,
    this.displayPrecision = 5,
    this.marginRate,
    this.minimumTradeSize,
    this.minLot = 0.01,
    this.maxLot = 100.0,
    this.lotStep = 0.01,
    this.tradeUnitsPrecision = 0,
    this.isWatchlisted = false,
    this.watchlistSortOrder = 999,
    this.sortOrder = 0,
  }) : displayLabel = displayLabel ?? name.replaceAll('_', '');

  /// Pip size derived from pipLocation (convenience getter).
  double get computedPipSize {
    double size = 1.0;
    for (int i = 0; i < -pipLocation; i++) size /= 10.0;
    return size;
  }

  SymbolEntity copyWith({
    String? name,
    String? displayName,
    String? displayLabel,
    InstrumentType? type,
    double? pipSize,
    int? pipLocation,
    double? unitsPerLot,
    int? displayPrecision,
    double? marginRate,
    double? minimumTradeSize,
    double? minLot,
    double? maxLot,
    double? lotStep,
    double? tradeUnitsPrecision,
    bool? isWatchlisted,
    int? watchlistSortOrder,
    int? sortOrder,
  }) {
    return SymbolEntity(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      displayLabel: displayLabel ?? this.displayLabel,
      type: type ?? this.type,
      pipSize: pipSize ?? this.pipSize,
      pipLocation: pipLocation ?? this.pipLocation,
      unitsPerLot: unitsPerLot ?? this.unitsPerLot,
      displayPrecision: displayPrecision ?? this.displayPrecision,
      marginRate: marginRate ?? this.marginRate,
      minimumTradeSize: minimumTradeSize ?? this.minimumTradeSize,
      minLot: minLot ?? this.minLot,
      maxLot: maxLot ?? this.maxLot,
      lotStep: lotStep ?? this.lotStep,
      tradeUnitsPrecision: tradeUnitsPrecision ?? this.tradeUnitsPrecision,
      isWatchlisted: isWatchlisted ?? this.isWatchlisted,
      watchlistSortOrder: watchlistSortOrder ?? this.watchlistSortOrder,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [name, isWatchlisted];
}
