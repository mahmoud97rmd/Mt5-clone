// Path: lib/core/database/app_database.dart
// ============================================================
// MT5 Clone — App Database (Drift ORM)
// Central database with all tables and DAOs.
// ============================================================

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/ticks_table.dart';
import 'tables/symbols_table.dart';
import 'tables/positions_table.dart';
import 'tables/orders_table.dart';
import 'tables/closed_trades_table.dart';
import 'tables/account_snapshots_table.dart';
import 'tables/ea_instances_table.dart';
import 'tables/ea_logs_table.dart';
import 'tables/candles_table.dart';
import 'daos/ticks_dao.dart';
import 'daos/positions_dao.dart';
import 'daos/orders_dao.dart';
import 'daos/history_dao.dart';
import 'daos/account_dao.dart';
import 'daos/ea_dao.dart';
import 'daos/candles_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Ticks,
    Symbols,
    Positions,
    Orders,
    ClosedTrades,
    AccountSnapshots,
    EaInstances,
    EaLogs,
    Candles,
  ],
  daos: [
    TicksDao,
    PositionsDao,
    OrdersDao,
    HistoryDao,
    AccountDao,
    EaDao,
    CandlesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'mt5_clone',
      native: DriftNativeOptions(
        databasePath: () async {
          final dir = await getApplicationSupportDirectory();
          return '${dir.path}/mt5_clone.sqlite';
        },
      ),
    );
  }
}
