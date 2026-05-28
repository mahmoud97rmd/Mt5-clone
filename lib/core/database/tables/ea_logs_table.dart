// Path: lib/core/database/tables/ea_logs_table.dart
// ============================================================
// MT5 Clone — EA Logs Table Definition
// ============================================================

import 'package:drift/drift.dart';

class EaLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eaInstanceId => integer()();
  TextColumn get level => text().withLength(min: 1, max: 20)();
  TextColumn get source => text().withDefault(const Constant('PYTHON'))();
  TextColumn get message => text()();
  IntColumn get timestampUs => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {eaInstanceId, timestampUs},
      ];
}
