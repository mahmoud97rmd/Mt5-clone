// Path: lib/core/database/tables/ea_instances_table.dart
// ============================================================
// MT5 Clone — EA Instances Table Definition
// ============================================================

import 'package:drift/drift.dart';

class EaInstances extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get symbol => text().withLength(min: 1, max: 20)();
  TextColumn get scriptPath => text()();
  IntColumn get magicNumber => integer()();
  RealColumn get lotSize => real().withDefault(const Constant(0.01))();
  IntColumn get maxPositions => integer().withDefault(const Constant(1))();
  IntColumn get killSwitchTimeoutSeconds => integer().withDefault(const Constant(10))();
  RealColumn get dailyLossLimit => real().nullable()();
  BoolColumn get autoStartOnBoot => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('STOPPED'))();
  IntColumn get createdAtUs => integer()();
  IntColumn get lastStartedAtUs => integer().nullable()();
  IntColumn get lastStoppedAtUs => integer().nullable()();
  IntColumn get totalTrades => integer().withDefault(const Constant(0))();
  RealColumn get netPnl => real().withDefault(const Constant(0))();
  RealColumn get winRate => real().withDefault(const Constant(0))();
  TextColumn get customParams => text().withDefault(const Constant('{}'))();
}
