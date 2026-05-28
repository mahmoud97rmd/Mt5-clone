// Path: lib/core/database/daos/ea_dao.dart
// ============================================================
// MT5 Clone — EA DAO
// ============================================================

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/ea_instances_table.dart';
import '../tables/ea_logs_table.dart';

part 'ea_dao.g.dart';

@DriftAccessor(tables: [EaInstances, EaLogs])
class EaDao extends DatabaseAccessor<AppDatabase> with _$EaDaoMixin {
  EaDao(super.db);

  // ── EA Instances ────────────────────────────────────────────

  Future<int> insertEaInstance(EaInstancesCompanion ea) {
    return into(eaInstances).insert(ea);
  }

  Future<List<EaInstance>> getAllEaInstances() {
    return (select(eaInstances)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  Stream<List<EaInstance>> watchAllEaInstances() {
    return (select(eaInstances)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<EaInstance?> getEaInstanceById(int id) {
    return (select(eaInstances)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> updateEaStatus(int id, String status) {
    return (update(eaInstances)..where((t) => t.id.equals(id)))
        .write(EaInstancesCompanion(status: Value(status)));
  }

  Future<int> updateEaStats({
    required int id,
    required int totalTrades,
    required double netPnl,
    required double winRate,
  }) {
    return (update(eaInstances)..where((t) => t.id.equals(id))).write(
      EaInstancesCompanion(
        totalTrades: Value(totalTrades),
        netPnl: Value(netPnl),
        winRate: Value(winRate),
      ),
    );
  }

  Future<int> deleteEaInstance(int id) {
    return (delete(eaInstances)..where((t) => t.id.equals(id))).go();
  }

  // ── EA Logs ─────────────────────────────────────────────────

  Future<int> insertLog(EaLogsCompanion log) {
    return into(eaLogs).insert(log);
  }

  Future<List<EaLog>> getLogs(int eaInstanceId, {int limit = 500}) {
    return (select(eaLogs)
          ..where((t) => t.eaInstanceId.equals(eaInstanceId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampUs)])
          ..limit(limit))
        .get();
  }

  Stream<List<EaLog>> watchLogs(int eaInstanceId, {int limit = 500}) {
    return (select(eaLogs)
          ..where((t) => t.eaInstanceId.equals(eaInstanceId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampUs)])
          ..limit(limit))
        .watch();
  }

  Future<int> clearLogs(int eaInstanceId) {
    return (delete(eaLogs)
          ..where((t) => t.eaInstanceId.equals(eaInstanceId)))
        .go();
  }

  Stream<List<EaLog>> watchLogsForEa(int eaInstanceId, {int limit = 500}) {
    return watchLogs(eaInstanceId, limit: limit);
  }
}
