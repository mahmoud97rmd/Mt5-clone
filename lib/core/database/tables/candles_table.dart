// Path: lib/core/database/tables/candles_table.dart
// ============================================================
// MT5 Clone — Candles Table Definition
// ============================================================

import 'package:drift/drift.dart';

class Candles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().withLength(min: 1, max: 20)();
  TextColumn get timeframe => text().withLength(min: 1, max: 5)();
  IntColumn get openTimeUs => integer()();
  RealColumn get open => real()();
  RealColumn get high => real()();
  RealColumn get low => real()();
  RealColumn get close => real()();
  RealColumn get volume => real().withDefault(const Constant(0))();
  BoolColumn get isComplete => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {symbol, timeframe, openTimeUs},
      ];
}
