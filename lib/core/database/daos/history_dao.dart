// Path: lib/core/database/daos/history_dao.dart
// ============================================================
// MT5 Clone — History DAO
// All queries for closed trades — the History & Reports screen.
// Supports time filtering, grouping, and summary metrics.
// ============================================================

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/closed_trades_table.dart';

part 'history_dao.g.dart';

/// Summary metrics returned for the History screen header
class TradeSummary {
  final double totalNetProfit;
  final double totalRealizedPnl;
  final double totalSwap;
  final double totalCommission;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double winRate;
  final double averageProfit;
  final double averageLoss;
  final double profitFactor;
  final double largestWin;
  final double largestLoss;

  const TradeSummary({
    required this.totalNetProfit,
    required this.totalRealizedPnl,
    required this.totalSwap,
    required this.totalCommission,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.averageProfit,
    required this.averageLoss,
    required this.profitFactor,
    required this.largestWin,
    required this.largestLoss,
  });

  static const TradeSummary empty = TradeSummary(
    totalNetProfit: 0,
    totalRealizedPnl: 0,
    totalSwap: 0,
    totalCommission: 0,
    totalTrades: 0,
    winningTrades: 0,
    losingTrades: 0,
    winRate: 0,
    averageProfit: 0,
    averageLoss: 0,
    profitFactor: 0,
    largestWin: 0,
    largestLoss: 0,
  );
}

@DriftAccessor(tables: [ClosedTrades])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(super.db);

  // ============================================================
  // 2.3.4.1 — WRITE OPERATIONS
  // ============================================================

  Future<int> insertClosedTrade(ClosedTradesCompanion trade) =>
      into(closedTrades).insert(trade, mode: InsertMode.insertOrIgnore);

  Future<void> insertClosedTrades(List<ClosedTradesCompanion> trades) async {
    await batch((b) => b.insertAllOnConflictUpdate(closedTrades, trades));
  }

  // ============================================================
  // 2.3.4.2 — FILTERED READ OPERATIONS
  // ============================================================

  /// Get closed trades within a date range.
  Future<List<ClosedTrade>> getTradesInRange({
    required DateTime from,
    required DateTime to,
    String? symbol,
    int? magicNumber,
    String? direction,
  }) {
    return (select(closedTrades)
          ..where((t) {
            Expression<bool> expr =
                t.closeTimeUs.isBiggerOrEqualValue(from.microsecondsSinceEpoch) &
                t.closeTimeUs.isSmallerOrEqualValue(to.microsecondsSinceEpoch);
            if (symbol != null) expr = expr & t.symbol.equals(symbol);
            if (magicNumber != null) {
              expr = expr & t.magicNumber.equals(magicNumber);
            }
            if (direction != null) expr = expr & t.direction.equals(direction);
            return expr;
          })
          ..orderBy([(t) => OrderingTerm.desc(t.closeTimeUs)]))
        .get();
  }

  /// Get trades for TODAY only.
  Future<List<ClosedTrade>> getTodaysTrades() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return getTradesInRange(from: todayStart, to: todayEnd);
  }

  /// Get trades for the last 7 days.
  Future<List<ClosedTrade>> getLastWeekTrades() {
    final now = DateTime.now();
    return getTradesInRange(
      from: now.subtract(const Duration(days: 7)),
      to: now,
    );
  }

  /// Get trades for the last 30 days.
  Future<List<ClosedTrade>> getLastMonthTrades() {
    final now = DateTime.now();
    return getTradesInRange(
      from: now.subtract(const Duration(days: 30)),
      to: now,
    );
  }

  /// Stream of recent trades for live History screen updates.
  Stream<List<ClosedTrade>> watchRecentTrades({int limit = 100}) {
    return (select(closedTrades)
          ..orderBy([(t) => OrderingTerm.desc(t.closeTimeUs)])
          ..limit(limit))
        .watch();
  }

  // ============================================================
  // 2.3.4.3 — AGGREGATED SUMMARY QUERIES
  // ============================================================

  /// Calculate full summary metrics for a given trade list.
  /// Used by History screen header and Reports screen.
  Future<TradeSummary> getSummaryForRange({
    required DateTime from,
    required DateTime to,
    String? symbol,
    int? magicNumber,
  }) async {
    final trades = await getTradesInRange(
      from: from,
      to: to,
      symbol: symbol,
      magicNumber: magicNumber,
    );

    if (trades.isEmpty) return TradeSummary.empty;

    final winning = trades.where((t) => t.netProfit > 0).toList();
    final losing = trades.where((t) => t.netProfit <= 0).toList();

    final totalNetProfit =
        trades.fold(0.0, (sum, t) => sum + t.netProfit);
    final totalRealizedPnl =
        trades.fold(0.0, (sum, t) => sum + t.realizedPnl);
    final totalSwap = trades.fold(0.0, (sum, t) => sum + t.swap);
    final totalCommission =
        trades.fold(0.0, (sum, t) => sum + t.commission);

    final grossProfit =
        winning.fold(0.0, (sum, t) => sum + t.netProfit);
    final grossLoss =
        losing.fold(0.0, (sum, t) => sum + t.netProfit.abs());

    final winRate = trades.isEmpty
        ? 0.0
        : (winning.length / trades.length) * 100.0;

    final avgProfit = winning.isEmpty
        ? 0.0
        : grossProfit / winning.length;
    final avgLoss =
        losing.isEmpty ? 0.0 : grossLoss / losing.length;

    final profitFactor =
        grossLoss == 0 ? 0.0 : grossProfit / grossLoss;

    final largestWin = winning.isEmpty
        ? 0.0
        : winning.map((t) => t.netProfit).reduce((a, b) => a > b ? a : b);
    final largestLoss = losing.isEmpty
        ? 0.0
        : losing
            .map((t) => t.netProfit.abs())
            .reduce((a, b) => a > b ? a : b);

    return TradeSummary(
      totalNetProfit: totalNetProfit,
      totalRealizedPnl: totalRealizedPnl,
      totalSwap: totalSwap,
      totalCommission: totalCommission,
      totalTrades: trades.length,
      winningTrades: winning.length,
      losingTrades: losing.length,
      winRate: winRate,
      averageProfit: avgProfit,
      averageLoss: avgLoss,
      profitFactor: profitFactor,
      largestWin: largestWin,
      largestLoss: largestLoss,
    );
  }

  /// Get daily P&L breakdown for equity curve charting.
  /// Returns list of (date, netProfit) sorted by date ascending.
  Future<List<({String date, double netProfit, int tradeCount})>>
      getDailyPnlBreakdown({
    required DateTime from,
    required DateTime to,
  }) async {
    final netProfitExpr = closedTrades.netProfit.sum();
    final countExpr = closedTrades.id.count();

    final query = selectOnly(closedTrades)
      ..addColumns([closedTrades.closeDate, netProfitExpr, countExpr])
      ..where(
        closedTrades.closeTimeUs
                .isBiggerOrEqualValue(from.microsecondsSinceEpoch) &
            closedTrades.closeTimeUs
                .isSmallerOrEqualValue(to.microsecondsSinceEpoch),
      )
      ..groupBy([closedTrades.closeDate])
      ..orderBy([OrderingTerm.asc(closedTrades.closeDate)]);

    return query
        .map((r) => (
              date: r.read(closedTrades.closeDate) ?? '',
              netProfit: r.read(netProfitExpr) ?? 0.0,
              tradeCount: r.read(countExpr) ?? 0,
            ))
        .get();
  }

  /// Count total closed trades.
  Future<int> getTotalTradeCount() async {
    final expr = closedTrades.id.count();
    final q = selectOnly(closedTrades)..addColumns([expr]);
    return await q.map((r) => r.read(expr) ?? 0).getSingle();
  }
}
