// Path: lib/features/account/presentation/providers/account_providers.dart
// ============================================================
// MT5 Clone — Account Riverpod Providers
// All reactive providers for account state, balance, equity,
// margin metrics, and daily P&L used across the entire UI.
//
// Provider dependency graph:
//
//   accountRepositoryProvider
//         ↓
//   accountInitProvider (FutureProvider — runs once on launch)
//         ↓
//   liveAccountProvider (StreamProvider — real-time updates)
//         ↓
//   topBarMetricsProvider (derived — computed from account stream)
//   marginLevelProvider   (derived — margin level %)
//   dailyPnlProvider      (derived — today's P&L)
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/account_entity.dart';
import '../../../../core/engine/account_math_engine.dart';
import '../../../account/data/datasources/account_snapshot_service.dart';
import '../../../account/data/repositories/account_repository_impl.dart';

// ============================================================
// 6.4.1 — Account Initialization Provider
// ============================================================

/// Fetches account info from OANDA on app launch.
/// Initializes the math engine and starts real-time calculations.
/// Watch this provider in the root widget to trigger initialization.
final accountInitProvider = FutureProvider<AccountEntity>((ref) async {
  final repo = ref.watch(accountRepositoryProvider);
  final result = await repo.getAccount();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (account) => account,
  );
});

// ============================================================
// 6.4.2 — Live Account State Provider
// ============================================================

/// Real-time account state stream — emits on every tick.
/// Powers the top bar: Balance, Equity, Margin, Free Margin, Margin Level.
final liveAccountProvider = StreamProvider<AccountEntity>((ref) {
  return ref.watch(accountMathEngineProvider).accountStream;
});

/// Current account state (sync) — falls back to init data if stream
/// hasn't emitted yet. Used for immediate display on app launch.
final currentAccountProvider = Provider<AccountEntity?>((ref) {
  final streamValue = ref.watch(liveAccountProvider);
  return streamValue.maybeWhen(
    data: (account) => account,
    orElse: () => ref.watch(accountInitProvider).valueOrNull,
  );
});

// ============================================================
// 6.4.3 — Top Bar Metrics Provider
// ============================================================

/// Derived metrics specifically for the Trading Terminal top bar.
/// Formatted as display strings to avoid repeated formatting in UI.
final topBarMetricsProvider = Provider<TopBarMetrics>((ref) {
  final account = ref.watch(currentAccountProvider);
  if (account == null) return TopBarMetrics.empty;

  return TopBarMetrics(
    balance: account.balance,
    equity: account.equity,
    marginUsed: account.marginUsed,
    freeMargin: account.marginAvailable,
    marginLevel: account.marginLevel,
    unrealizedPnl: account.unrealizedPnl,
    currency: account.currency,
    isMarginCallRisk: account.isMarginCallRisk,
    isMarginCall: account.isMarginCall,
  );
});

/// Formatted display strings for top bar — pre-computed to avoid
/// calling toStringAsFixed() in every build cycle.
class TopBarMetrics {
  final double balance;
  final double equity;
  final double marginUsed;
  final double freeMargin;
  final double? marginLevel;
  final double unrealizedPnl;
  final String currency;
  final bool isMarginCallRisk;
  final bool isMarginCall;

  const TopBarMetrics({
    required this.balance,
    required this.equity,
    required this.marginUsed,
    required this.freeMargin,
    required this.marginLevel,
    required this.unrealizedPnl,
    required this.currency,
    required this.isMarginCallRisk,
    required this.isMarginCall,
  });

  static const TopBarMetrics empty = TopBarMetrics(
    balance: 0, equity: 0, marginUsed: 0, freeMargin: 0,
    marginLevel: null, unrealizedPnl: 0, currency: 'USD',
    isMarginCallRisk: false, isMarginCall: false,
  );

  // ── Pre-formatted strings ──────────────────────────────────

  String get balanceDisplay => _fmt(balance);
  String get equityDisplay => _fmt(equity);
  String get marginUsedDisplay => _fmt(marginUsed);
  String get freeMarginDisplay => _fmt(freeMargin);
  String get unrealizedPnlDisplay =>
      '${unrealizedPnl >= 0 ? '+' : ''}${_fmt(unrealizedPnl)}';

  String get marginLevelDisplay {
    if (marginLevel == null) return '∞';
    return '${marginLevel!.toStringAsFixed(2)}%';
  }

  /// Margin level as 0.0–1.0 for circular progress indicator.
  /// Capped at 5.0 (500%) for display sanity.
  double get marginLevelRatio {
    if (marginLevel == null) return 1.0;
    return (marginLevel! / 500.0).clamp(0.0, 1.0);
  }

  bool get isPnlPositive => unrealizedPnl >= 0;

  String _fmt(double v) => v.toStringAsFixed(2);
}

// ============================================================
// 6.4.4 — Margin Level Provider (for UI warnings)
// ============================================================

/// Current margin level percentage — used for color-coded indicator.
final marginLevelProvider = Provider<double?>((ref) {
  return ref.watch(currentAccountProvider)?.marginLevel;
});

/// Margin danger level — true when margin level < 100%
final isMarginDangerProvider = Provider<bool>((ref) {
  final level = ref.watch(marginLevelProvider);
  if (level == null) return false;
  return level < 100.0;
});

// ============================================================
// 6.4.5 — Daily P&L Provider
// ============================================================

/// Today's realized + unrealized P&L combined.
final dailyPnlProvider = Provider<double>((ref) {
  final account = ref.watch(currentAccountProvider);
  if (account == null) return 0.0;
  return account.totalDailyPnl;
});

/// Whether today's P&L is positive.
final isDailyProfitProvider = Provider<bool>((ref) {
  return ref.watch(dailyPnlProvider) >= 0;
});

// ============================================================
// 6.4.6 — Equity Curve Provider
// ============================================================

/// Equity curve data for the account chart (last 30 days).
final equityCurveProvider =
    FutureProvider<List<EquityCurvePoint>>((ref) async {
  final account = ref.watch(currentAccountProvider);
  if (account == null) return [];

  final service = ref.watch(accountSnapshotServiceProvider);
  final now = DateTime.now();

  return service.buildEquityCurve(
    accountId: account.accountId,
    from: now.subtract(const Duration(days: 30)),
    to: now,
    maxPoints: 300,
  );
});

/// Daily P&L breakdown for the last 30 days (bar chart).
final dailyPnlChartProvider =
    FutureProvider<List<DailyPnlPoint>>((ref) async {
  final account = ref.watch(currentAccountProvider);
  if (account == null) return [];

  final service = ref.watch(accountSnapshotServiceProvider);
  final now = DateTime.now();

  return service.buildDailyPnl(
    accountId: account.accountId,
    from: now.subtract(const Duration(days: 30)),
    to: now,
  );
});

// ============================================================
// 6.4.7 — Watchlist Providers
// ============================================================

/// Stream of watchlisted symbols.
final watchlistProvider = StreamProvider((ref) {
  return ref.watch(accountRepositoryProvider).watchWatchlist();
});

/// Load all available instruments from OANDA.
final instrumentsProvider =
    FutureProvider((ref) async {
  final result =
      await ref.watch(accountRepositoryProvider).getInstruments();
  return result.fold(
    (f) => throw Exception(f.message),
    (list) => list,
  );
});
