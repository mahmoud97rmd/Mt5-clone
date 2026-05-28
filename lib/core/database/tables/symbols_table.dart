// Path: lib/core/database/tables/symbols_table.dart
// ============================================================
// MT5 Clone — Symbols Table Definition
// ============================================================

import 'package:drift/drift.dart';

class Symbols extends Table {
  TextColumn get name => text().withLength(min: 1, max: 20)();
  TextColumn get displayName => text().withLength(min: 1, max: 30)();
  TextColumn get displayExPrecision => text().nullable()();
  TextColumn get type => text().withLength(min: 1, max: 20)();
  RealColumn get pipSize => real()();
  IntColumn get pipLocation => integer()();
  RealColumn get unitsPerLot => real().withDefault(const Constant(100000))();
  IntColumn get displayPrecision => integer().withDefault(const Constant(5))();
  RealColumn get marginRate => real().nullable()();
  RealColumn get minimumTradeSize => real().nullable()();
  RealColumn get minLot => real().withDefault(const Constant(0.01))();
  RealColumn get maxLot => real().withDefault(const Constant(100.0))();
  RealColumn get lotStep => real().withDefault(const Constant(0.01))();
  RealColumn get tradeUnitsPrecision => real().withDefault(const Constant(0))();
  BoolColumn get isWatchlisted => boolean().withDefault(const Constant(false))();
  IntColumn get watchlistSortOrder => integer().withDefault(const Constant(999))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get lastUpdatedUs => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {name};
}
