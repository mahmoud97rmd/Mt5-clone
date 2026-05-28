// Path: lib/features/account/data/datasources/account_snapshot_service.dart
// ============================================================
// MT5 Clone — Account Snapshot Service
// Builds the equity curve from stored account snapshots.
// Provides daily P&L aggregation for the History screen header.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/account_dao.dart';
import '../../../../core/database/database_providers.dart';

// ── Data Models ───────────────────────────────────────────────

class EquityCurvePoint {
  final DateTime time;
  final double equity;
  final double balance;

  const EquityCurvePoint({
    required this.time,
    required this.equity,
    required this.balance,
  });
}

class DailyPnlPoint {
  final String date;         // "YYYY-MM-DD"
  final double netProfit;
  final double equity;
  final bool isProfit;

  DailyPnlPoint({
    required this.date,
    required this.netProfit,
    required this.equity,
  }) : isProfit = netProfit >= 0;
}

// ── Service ───────────────────────────────────────────────────

class AccountSnapshotService {
  final AccountDao _accountDao;

  AccountSnapshotService({required AccountDao accountDao})
      : _accountDao = accountDao;

  // ============================================================
  // 6.3.1 — Equity Curve Builder
  // ============================================================

  /// Build the equity curve for the given date range.
  /// Downsamples snapshots to at most [maxPoints] for chart rendering.
  Future<List<EquityCurvePoint>> buildEquityCurve({
    required String accountId,
    required DateTime from,
    required DateTime to,
    int maxPoints = 500,
  }) async {
    final snapshots = await _accountDao.getSnapshots(
      accountId: accountId,
      from: from,
      to: to,
    );

    if (snapshots.isEmpty) return [];

    // Downsample if we have too many points
    final sampled = _downsample(snapshots, maxPoints);

    return sampled
        .map((s) => EquityCurvePoint(
              time: DateTime.fromMicrosecondsSinceEpoch(s.timestampUs),
              equity: s.equity,
              balance: s.balance,
            ))
        .toList();
  }

  // ============================================================
  // 6.3.2 — Daily P&L Aggregation
  // ============================================================

  /// Aggregate daily equity snapshots into one point per day.
  /// Uses the LAST snapshot of each day as the daily closing equity.
  Future<List<DailyPnlPoint>> buildDailyPnl({
    required String accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    final snapshots = await _accountDao.getSnapshots(
      accountId: accountId,
      from: from,
      to: to,
    );

    if (snapshots.isEmpty) return [];

    // Group by date, keep last snapshot per day
    final byDate = <String, AccountSnapshot>{};
    for (final s in snapshots) {
      byDate[s.date] = s; // last write wins (snapshots are asc ordered)
    }

    final sorted = byDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Calculate daily PnL as difference between consecutive days
    final result = <DailyPnlPoint>[];
    double? prevBalance;

    for (final entry in sorted) {
      final snap = entry.value;
      final dailyPnl = prevBalance != null
          ? snap.balance - prevBalance
          : snap.dailyRealizedPnl;

      result.add(DailyPnlPoint(
        date: snap.date,
        netProfit: dailyPnl,
        equity: snap.equity,
      ));

      prevBalance = snap.balance;
    }

    return result;
  }

  // ============================================================
  // 6.3.3 — Summary Stats (for Reports screen)
  // ============================================================

  Future<AccountPeriodStats> getPeriodStats({
    required String accountId,
    required DateTime from,
    required DateTime to,
  }) async {
    final snapshots = await _accountDao.getSnapshots(
      accountId: accountId,
      from: from,
      to: to,
    );

    if (snapshots.isEmpty) {
      return AccountPeriodStats.empty;
    }

    final first = snapshots.first;
    final last = snapshots.last;

    final equities = snapshots.map((s) => s.equity).toList();
    final maxEquity = equities.reduce((a, b) => a > b ? a : b);
    final minEquity = equities.reduce((a, b) => a < b ? a : b);

    // Max drawdown: largest peak-to-trough decline
    double maxDrawdown = 0.0;
    double peak = equities.first;
    for (final eq in equities) {
      if (eq > peak) peak = eq;
      final dd = peak - eq;
      if (dd > maxDrawdown) maxDrawdown = dd;
    }

    final maxDrawdownPct =
        peak > 0 ? (maxDrawdown / peak) * 100.0 : 0.0;

    return AccountPeriodStats(
      startBalance: first.balance,
      endBalance: last.balance,
      startEquity: first.equity,
      endEquity: last.equity,
      maxEquity: maxEquity,
      minEquity: minEquity,
      maxDrawdown: maxDrawdown,
      maxDrawdownPct: maxDrawdownPct,
      netChange: last.balance - first.balance,
      netChangePct: first.balance > 0
          ? ((last.balance - first.balance) / first.balance) * 100.0
          : 0.0,
    );
  }

  // ============================================================
  // 6.3.4 — Downsampling (LTTB Algorithm — Largest-Triangle-Three-Buckets)
  // Preserves visual shape while reducing point count.
  // ============================================================

  List<AccountSnapshot> _downsample(
    List<AccountSnapshot> data,
    int threshold,
  ) {
    if (data.length <= threshold) return data;

    final sampled = <AccountSnapshot>[data.first];
    final bucketSize = (data.length - 2) / (threshold - 2);

    int a = 0;
    for (int i = 0; i < threshold - 2; i++) {
      final avgStart = ((i + 1) * bucketSize).floor() + 1;
      final avgEnd = ((i + 2) * bucketSize).floor() + 1;

      // Calculate average point in next bucket
      double avgX = 0, avgY = 0;
      int count = 0;
      for (int j = avgStart;
          j < avgEnd && j < data.length;
          j++, count++) {
        avgX += data[j].timestampUs;
        avgY += data[j].equity;
      }
      if (count > 0) {
        avgX /= count;
        avgY /= count;
      }

      // Find point in current bucket with max triangle area
      final rangeStart = (i * bucketSize).floor() + 1;
      final rangeEnd = ((i + 1) * bucketSize).floor() + 1;

      final aX = data[a].timestampUs.toDouble();
      final aY = data[a].equity;

      double maxArea = -1;
      int nextA = rangeStart;

      for (int j = rangeStart;
          j < rangeEnd && j < data.length;
          j++) {
        final area = ((aX - avgX) * (data[j].equity - aY) -
                (aX - data[j].timestampUs) * (avgY - aY))
            .abs() *
            0.5;
        if (area > maxArea) {
          maxArea = area;
          nextA = j;
        }
      }

      sampled.add(data[nextA]);
      a = nextA;
    }

    sampled.add(data.last);
    return sampled;
  }
}

// ── Period Stats Model ────────────────────────────────────────

class AccountPeriodStats {
  final double startBalance;
  final double endBalance;
  final double startEquity;
  final double endEquity;
  final double maxEquity;
  final double minEquity;
  final double maxDrawdown;
  final double maxDrawdownPct;
  final double netChange;
  final double netChangePct;

  const AccountPeriodStats({
    required this.startBalance,
    required this.endBalance,
    required this.startEquity,
    required this.endEquity,
    required this.maxEquity,
    required this.minEquity,
    required this.maxDrawdown,
    required this.maxDrawdownPct,
    required this.netChange,
    required this.netChangePct,
  });

  static const AccountPeriodStats empty = AccountPeriodStats(
    startBalance: 0, endBalance: 0,
    startEquity: 0, endEquity: 0,
    maxEquity: 0, minEquity: 0,
    maxDrawdown: 0, maxDrawdownPct: 0,
    netChange: 0, netChangePct: 0,
  );

  bool get isProfit => netChange >= 0;
}

// ── Riverpod Provider ─────────────────────────────────────────

final accountSnapshotServiceProvider =
    Provider<AccountSnapshotService>((ref) {
  return AccountSnapshotService(
    accountDao: ref.watch(accountDaoProvider),
  );
});
