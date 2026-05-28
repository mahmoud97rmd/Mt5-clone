// Path: lib/core/database/tables/account_snapshots_table.dart
// ============================================================
// MT5 Clone — Account Snapshots Table Definition
// ============================================================

import 'package:drift/drift.dart';

class AccountSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId => text().withLength(min: 1, max: 50)();
  RealColumn get balance => real()();
  RealColumn get equity => real()();
  RealColumn get marginUsed => real()();
  RealColumn get marginAvailable => real()();
  RealColumn get marginLevel => real().nullable()();
  RealColumn get nav => real().nullable()();
  IntColumn get openPositionCount => integer().withDefault(const Constant(0))();
  RealColumn get unrealizedPnl => real().withDefault(const Constant(0))();
  RealColumn get dailyRealizedPnl => real().withDefault(const Constant(0))();
  TextColumn get snapshotTrigger => text().withDefault(const Constant('PERIODIC'))();
  IntColumn get timestampUs => integer()();
  TextColumn get date => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {accountId, timestampUs},
      ];
}
