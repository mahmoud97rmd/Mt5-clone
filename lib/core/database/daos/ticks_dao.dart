// Path: lib/core/database/daos/ticks_dao.dart
// ============================================================
// MT5 Clone — Ticks DAO
// All database operations for real-time price tick data.
//
// Critical performance path:
//   OANDA streams ~1-5 ticks/second per instrument.
//   This DAO must handle high-frequency writes without blocking UI.
//   All writes use batch operations and WAL mode for concurrency.
// ============================================================

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/ticks_table.dart';

part 'ticks_dao.g.dart';

@DriftAccessor(tables: [Ticks])
class TicksDao extends DatabaseAccessor<AppDatabase> with _$TicksDaoMixin {
  TicksDao(super.db);

  // ============================================================
  // 2.3.1.1 — WRITE OPERATIONS
  // ============================================================

  /// Insert a single tick. Used for real-time stream updates.
  /// Returns the inserted row's ID.
  Future<int> insertTick(TicksCompanion tick) =>
      into(ticks).insert(tick, mode: InsertMode.insertOrIgnore);

  /// Batch insert multiple ticks. Used when fetching historical data.
  /// Much faster than individual inserts for bulk operations.
  Future<void> insertTicks(List<TicksCompanion> tickList) async {
    await batch((b) => b.insertAllOnConflictUpdate(ticks, tickList));
  }

  /// Upsert a tick — insert or update if same timestamp+symbol exists.
  Future<void> upsertTick(TicksCompanion tick) async {
    await into(ticks).insertOnConflictUpdate(tick);
  }

  // ============================================================
  // 2.3.1.2 — LATEST PRICE QUERIES
  // ============================================================

  /// Get the most recent tick for a symbol.
  /// Used by the Market Watch screen and PnL calculator.
  Future<Tick?> getLatestTick(String symbol) {
    return (select(ticks)
          ..where((t) => t.symbol.equals(symbol))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampUs)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Watch (Stream) the latest tick for a symbol.
  /// UI widgets subscribe to this for real-time price display.
  Stream<Tick?> watchLatestTick(String symbol) {
    return (select(ticks)
          ..where((t) => t.symbol.equals(symbol))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampUs)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Get latest ticks for ALL watchlisted symbols in one query.
  /// Returns a Map<symbol, Tick> for the Market Watch screen.
  Future<Map<String, Tick>> getLatestTicksForSymbols(
      List<String> symbolList) async {
    if (symbolList.isEmpty) return {};

    // Use a subquery to get the max timestamp per symbol,
    // then join back to get full tick data
    final result = <String, Tick>{};

    for (final symbol in symbolList) {
      final tick = await getLatestTick(symbol);
      if (tick != null) result[symbol] = tick;
    }
    return result;
  }

  /// Stream of latest ticks for multiple symbols.
  /// Emits a new Map every time any symbol's price updates.
  Stream<Map<String, Tick>> watchLatestTicksForSymbols(
      List<String> symbolList) {
    // Combine multiple streams — emits on any price change
    if (symbolList.isEmpty) return Stream.value({});

    return (select(ticks)
          ..where((t) => t.symbol.isIn(symbolList))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampUs)]))
        .watch()
        .map((allTicks) {
      final latestMap = <String, Tick>{};
      for (final tick in allTicks) {
        if (!latestMap.containsKey(tick.symbol)) {
          latestMap[tick.symbol] = tick;
        }
      }
      return latestMap;
    });
  }

  // ============================================================
  // 2.3.1.3 — HISTORICAL RANGE QUERIES (for charting)
  // ============================================================

  /// Get ticks within a time range for a specific symbol.
  /// Used by the charting engine to build candlesticks from raw ticks.
  Future<List<Tick>> getTicksInRange({
    required String symbol,
    required DateTime from,
    required DateTime to,
  }) {
    final fromUs = from.microsecondsSinceEpoch;
    final toUs = to.microsecondsSinceEpoch;

    return (select(ticks)
          ..where((t) =>
              t.symbol.equals(symbol) &
              t.timestampUs.isBiggerOrEqualValue(fromUs) &
              t.timestampUs.isSmallerOrEqualValue(toUs))
          ..orderBy([(t) => OrderingTerm.asc(t.timestampUs)]))
        .get();
  }

  /// Get the last N ticks for a symbol. Used for indicator calculation.
  Future<List<Tick>> getLastNTicks(String symbol, int n) {
    return (select(ticks)
          ..where((t) => t.symbol.equals(symbol))
          ..orderBy([(t) => OrderingTerm.desc(t.timestampUs)])
          ..limit(n))
        .get();
  }

  // ============================================================
  // 2.3.1.4 — AGGREGATED QUERIES (for session high/low)
  // ============================================================

  /// Get the session high (max ask) and low (min bid) for today.
  Future<({double? high, double? low})> getSessionHighLow(
      String symbol) async {
    final now = DateTime.now();
    final sessionStart = DateTime(now.year, now.month, now.day);

    final highExpr = ticks.ask.max();
    final lowExpr = ticks.bid.min();

    final query = selectOnly(ticks)
      ..addColumns([highExpr, lowExpr])
      ..where(ticks.symbol.equals(symbol) &
          ticks.timestampUs
              .isBiggerOrEqualValue(sessionStart.microsecondsSinceEpoch));

    final row = await query.getSingleOrNull();
    if (row == null) return (high: null, low: null);

    return (
      high: row.read(highExpr),
      low: row.read(lowExpr),
    );
  }

  // ============================================================
  // 2.3.1.5 — MAINTENANCE
  // ============================================================

  /// Count total ticks stored for a symbol.
  Future<int> countTicksForSymbol(String symbol) async {
    final countExpr = ticks.id.count();
    final query = selectOnly(ticks)
      ..addColumns([countExpr])
      ..where(ticks.symbol.equals(symbol));
    return await query.map((r) => r.read(countExpr) ?? 0).getSingle();
  }

  /// Delete all ticks for a symbol (e.g., when removing from watchlist).
  Future<int> deleteTicksForSymbol(String symbol) {
    return (delete(ticks)..where((t) => t.symbol.equals(symbol))).go();
  }

  /// Delete ticks older than the given timestamp.
  Future<int> deleteTicksOlderThan(DateTime cutoff) {
    return (delete(ticks)
          ..where(
              (t) => t.timestampUs.isSmallerThanValue(cutoff.microsecondsSinceEpoch)))
        .go();
  }
}
