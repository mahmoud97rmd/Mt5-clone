// Path: lib/core/database/daos/account_dao.dart
// ============================================================
// MT5 Clone — Account DAO
// ============================================================

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/account_snapshots_table.dart';
import '../tables/symbols_table.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [AccountSnapshots, Symbols])
class AccountDao extends DatabaseAccessor<AppDatabase>
    with _$AccountDaoMixin {
  AccountDao(super.db);

  Future<int> insertSnapshot(AccountSnapshotsCompanion snapshot) {
    return into(accountSnapshots).insert(snapshot);
  }

  Future<List<AccountSnapshot>> getSnapshots({
    required String accountId,
    required DateTime from,
    required DateTime to,
  }) {
    final fromUs = from.microsecondsSinceEpoch;
    final toUs = to.microsecondsSinceEpoch;
    return (select(accountSnapshots)
          ..where((t) =>
              t.accountId.equals(accountId) &
              t.timestampUs.isBiggerOrEqualValue(fromUs) &
              t.timestampUs.isSmallerOrEqualValue(toUs))
          ..orderBy([(t) => OrderingTerm.asc(t.timestampUs)]))
        .get();
  }

  Future<AccountSnapshot?> getLatestSnapshot(String accountId) {
    return (select(accountSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampUs)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> deleteOldSnapshots({
    required String accountId,
    required DateTime before,
  }) {
    final beforeUs = before.microsecondsSinceEpoch;
    return (delete(accountSnapshots)
          ..where((t) =>
              t.accountId.equals(accountId) &
              t.timestampUs.isSmallerThanValue(beforeUs)))
        .go();
  }

  // ── Symbols ─────────────────────────────────────────────────

  Future<List<Symbol>> getAllSymbols() {
    return (select(symbols)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<List<Symbol>> getWatchlistedSymbols() {
    return (select(symbols)
          ..where((t) => t.isWatchlisted.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.watchlistSortOrder)]))
        .get();
  }

  Stream<List<Symbol>> watchWatchlistedSymbols() {
    return (select(symbols)
          ..where((t) => t.isWatchlisted.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.watchlistSortOrder)]))
        .watch();
  }

  Future<void> upsertSymbols(List<SymbolsCompanion> companions) async {
    await batch((b) => b.insertAllOnConflictUpdate(symbols, companions));
  }

  Future<void> toggleWatchlist(String symbolName, bool isWatchlisted) async {
    await (update(symbols)..where((t) => t.name.equals(symbolName)))
        .write(SymbolsCompanion(isWatchlisted: Value(isWatchlisted)));
  }

  Future<void> reorderWatchlist(List<String> orderedSymbols) async {
    for (int i = 0; i < orderedSymbols.length; i++) {
      await (update(symbols)..where((t) => t.name.equals(orderedSymbols[i])))
          .write(SymbolsCompanion(watchlistSortOrder: Value(i)));
    }
  }
}
