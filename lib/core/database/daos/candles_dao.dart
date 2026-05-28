// Path: lib/core/database/daos/candles_dao.dart
// ============================================================
// MT5 Clone — Candles DAO
// OHLCV candlestick data for all instruments and timeframes.
// Critical performance path — charting queries must be fast.
// ============================================================

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/candles_table.dart';

part 'candles_dao.g.dart';

@DriftAccessor(tables: [Candles])
class CandlesDao extends DatabaseAccessor<AppDatabase>
    with _$CandlesDaoMixin {
  CandlesDao(super.db);

  // ============================================================
  // 2.3.7.1 — WRITE OPERATIONS
  // ============================================================

  /// Upsert a single candle (insert or update on duplicate).
  Future<void> upsertCandle(CandlesCompanion candle) async {
    await into(candles).insertOnConflictUpdate(candle);
  }

  /// Batch upsert candles — used when loading historical data.
  Future<void> upsertCandles(List<CandlesCompanion> candleList) async {
    await batch((b) => b.insertAllOnConflictUpdate(candles, candleList));
  }

  /// Update only the last (incomplete) candle with new tick data.
  Future<int> updateIncompleteCandle({
    required String symbol,
    required String timeframe,
    required int openTimeUs,
    required double newHigh,
    required double newLow,
    required double newClose,
    required int newTickVolume,
  }) {
    return (update(candles)
          ..where((c) =>
              c.symbol.equals(symbol) &
              c.timeframe.equals(timeframe) &
              c.openTimeUs.equals(openTimeUs) &
              c.isComplete.equals(false)))
        .write(CandlesCompanion(
      high: Value(newHigh),
      low: Value(newLow),
      close: Value(newClose),
      volume: Value(newTickVolume.toDouble()),
    ));
  }

  /// Mark a candle as complete (no longer the current candle).
  Future<int> markCandleComplete(
      String symbol, String timeframe, int openTimeUs) {
    return (update(candles)
          ..where((c) =>
              c.symbol.equals(symbol) &
              c.timeframe.equals(timeframe) &
              c.openTimeUs.equals(openTimeUs)))
        .write(const CandlesCompanion(isComplete: Value(true)));
  }

  // ============================================================
  // 2.3.7.2 — READ OPERATIONS (for charting engine)
  // ============================================================

  /// Get N most recent candles for a symbol+timeframe.
  /// Primary query used by the charting engine on initial load.
  Future<List<Candle>> getRecentCandles({
    required String symbol,
    required String timeframe,
    int limit = 500,
  }) {
    return (select(candles)
          ..where((c) =>
              c.symbol.equals(symbol) & c.timeframe.equals(timeframe))
          ..orderBy([(c) => OrderingTerm.desc(c.openTimeUs)])
          ..limit(limit))
        .get()
        .then((list) => list.reversed.toList());
    // Reversed: chart needs oldest-first ordering
  }

  /// Get candles within a specific time range.
  Future<List<Candle>> getCandlesInRange({
    required String symbol,
    required String timeframe,
    required DateTime from,
    required DateTime to,
  }) {
    return (select(candles)
          ..where((c) =>
              c.symbol.equals(symbol) &
              c.timeframe.equals(timeframe) &
              c.openTimeUs
                  .isBiggerOrEqualValue(from.microsecondsSinceEpoch) &
              c.openTimeUs
                  .isSmallerOrEqualValue(to.microsecondsSinceEpoch))
          ..orderBy([(c) => OrderingTerm.asc(c.openTimeUs)]))
        .get();
  }

  /// Watch candles — stream for live chart updates.
  /// Emits every time a candle is inserted or updated.
  Stream<List<Candle>> watchCandles({
    required String symbol,
    required String timeframe,
    int limit = 300,
  }) {
    return (select(candles)
          ..where((c) =>
              c.symbol.equals(symbol) & c.timeframe.equals(timeframe))
          ..orderBy([(c) => OrderingTerm.desc(c.openTimeUs)])
          ..limit(limit))
        .watch()
        .map((list) => list.reversed.toList());
  }

  /// Get only the current (incomplete) candle for live price display.
  Future<Candle?> getCurrentCandle(String symbol, String timeframe) {
    return (select(candles)
          ..where((c) =>
              c.symbol.equals(symbol) &
              c.timeframe.equals(timeframe) &
              c.isComplete.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.openTimeUs)])
          ..limit(1))
        .getSingleOrNull();
  }

  // ============================================================
  // 2.3.7.3 — AVAILABILITY CHECKS
  // ============================================================

  /// Check if we have candle data for symbol+timeframe.
  /// Used to decide whether to fetch from OANDA or use cache.
  Future<bool> hasCandles(String symbol, String timeframe) async {
    final expr = candles.id.count();
    final q = selectOnly(candles)
      ..addColumns([expr])
      ..where(candles.symbol.equals(symbol) &
          candles.timeframe.equals(timeframe));
    final count = await q.map((r) => r.read(expr) ?? 0).getSingle();
    return count > 0;
  }

  /// Get the timestamp of the most recent candle.
  /// Used to determine how far back to fetch from OANDA.
  Future<int?> getLatestCandleTime(String symbol, String timeframe) async {
    final expr = candles.openTimeUs.max();
    final q = selectOnly(candles)
      ..addColumns([expr])
      ..where(candles.symbol.equals(symbol) &
          candles.timeframe.equals(timeframe));
    return await q.map((r) => r.read(expr)).getSingle();
  }

  /// Delete all candles for a symbol+timeframe (force re-fetch).
  Future<int> deleteCandles(String symbol, String timeframe) {
    return (delete(candles)
          ..where((c) =>
              c.symbol.equals(symbol) & c.timeframe.equals(timeframe)))
        .go();
  }
}
