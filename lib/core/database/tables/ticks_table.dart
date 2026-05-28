// Path: lib/core/database/tables/ticks_table.dart
// ============================================================
// MT5 Clone — Ticks Table Definition
// ============================================================

import 'package:drift/drift.dart';

class Ticks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text().withLength(min: 1, max: 20)();
  RealColumn get bid => real()();
  RealColumn get ask => real()();
  RealColumn get spread => real()();
  IntColumn get timestampUs => integer()();
  RealColumn get sessionHigh => real().nullable()();
  RealColumn get sessionLow => real().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {symbol, timestampUs},
      ];
}
