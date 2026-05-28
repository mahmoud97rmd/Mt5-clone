// Path: lib/core/database/migrations/database_migrations.dart
// ============================================================
// MT5 Clone — Database Migrations
// Future migration strategies for schema upgrades.
// ============================================================

import 'package:drift/drift.dart';

class DatabaseMigrations {
  DatabaseMigrations._();

  /// Example migration for future schema changes.
  /// When schemaVersion is bumped in AppDatabase, add migration logic here.
  static Future<void> migrateV1ToV2(Migrator m) async {
    // Example: Add a new column to an existing table
    // await m.addColumn(orders, orders.newColumn);
  }
}
