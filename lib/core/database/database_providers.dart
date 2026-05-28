// Path: lib/core/database/database_providers.dart
// ============================================================
// MT5 Clone — Database Riverpod Providers
// Registers AppDatabase and all DAOs as injectable providers.
//
// Usage in any widget or notifier:
//   final db = ref.watch(appDatabaseProvider);
//   final positions = ref.watch(positionsDaoProvider);
//   final ticks = ref.watch(ticksDaoProvider);
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/account_dao.dart';
import 'daos/candles_dao.dart';
import 'daos/ea_dao.dart';
import 'daos/history_dao.dart';
import 'daos/orders_dao.dart';
import 'daos/positions_dao.dart';
import 'daos/ticks_dao.dart';
import 'hive_cache_service.dart';

// ============================================================
// 2.6.1 — Core Database Provider
// Single shared instance — AppDatabase is a singleton internally,
// but Riverpod ensures the same instance is used everywhere.
// ============================================================

/// The main Drift database — root of all DAO access.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  // Dispose database connection when provider is destroyed
  ref.onDispose(db.close);

  return db;
});

// ============================================================
// 2.6.2 — DAO Providers
// Each DAO is derived from the main database provider.
// ============================================================

/// Ticks DAO — real-time price data
final ticksDaoProvider = Provider<TicksDao>((ref) {
  return ref.watch(appDatabaseProvider).ticksDao;
});

/// Positions DAO — open trades
final positionsDaoProvider = Provider<PositionsDao>((ref) {
  return ref.watch(appDatabaseProvider).positionsDao;
});

/// Orders DAO — pending orders
final ordersDaoProvider = Provider<OrdersDao>((ref) {
  return ref.watch(appDatabaseProvider).ordersDao;
});

/// History DAO — closed trades
final historyDaoProvider = Provider<HistoryDao>((ref) {
  return ref.watch(appDatabaseProvider).historyDao;
});

/// Account DAO — account snapshots + symbols
final accountDaoProvider = Provider<AccountDao>((ref) {
  return ref.watch(appDatabaseProvider).accountDao;
});

/// EA DAO — Expert Advisor instances + logs
final eaDaoProvider = Provider<EaDao>((ref) {
  return ref.watch(appDatabaseProvider).eaDao;
});

/// Candles DAO — OHLCV candlestick data
final candlesDaoProvider = Provider<CandlesDao>((ref) {
  return ref.watch(appDatabaseProvider).candlesDao;
});

// ============================================================
// 2.6.3 — Hive Cache Provider
// Provides access to the fast in-memory price cache.
// ============================================================

/// Hive cache — synchronous access to latest tick prices.
/// This is a static service, so the provider is just a reference holder.
final hiveCacheProvider = Provider<HiveCacheService>((ref) {
  // HiveCacheService uses static methods — provider just confirms init
  return HiveCacheService();
});

// ============================================================
// 2.6.4 — Reactive Data Streams (convenience providers)
// Pre-built streaming providers used directly in UI widgets.
// ============================================================

/// Stream of all open positions — used by Trading Terminal.
final openPositionsStreamProvider = StreamProvider((ref) {
  return ref.watch(positionsDaoProvider).watchAllPositions();
});

/// Stream of all pending orders — used by Trading Terminal.
final pendingOrdersStreamProvider = StreamProvider((ref) {
  return ref.watch(ordersDaoProvider).watchPendingOrders();
});

/// Stream of watchlisted symbols — used by Market Watch.
final watchlistedSymbolsStreamProvider = StreamProvider((ref) {
  return ref.watch(accountDaoProvider).watchWatchlistedSymbols();
});

/// Stream of all EA instances — used by EA Manager screen.
final eaInstancesStreamProvider = StreamProvider((ref) {
  return ref.watch(eaDaoProvider).watchAllEaInstances();
});

/// Position aggregate stream — drives the top bar metrics.
final positionAggregatesStreamProvider = StreamProvider((ref) {
  return ref.watch(positionsDaoProvider).watchPositionAggregates();
});

/// EA logs stream — takes the EA instance ID as a parameter.
final eaLogsStreamProvider =
    StreamProvider.family<List<EaLog>, int>((ref, eaInstanceId) {
  return ref.watch(eaDaoProvider).watchLogsForEa(eaInstanceId);
});

/// Latest tick stream — used by Market Watch price cells.
final latestTickStreamProvider =
    StreamProvider.family<Tick?, String>((ref, symbol) {
  return ref.watch(ticksDaoProvider).watchLatestTick(symbol);
});

/// Candles stream — used by Chart screen.
final candlesStreamProvider = StreamProvider.family<List<Candle>,
    ({String symbol, String timeframe, int limit})>((ref, params) {
  return ref.watch(candlesDaoProvider).watchCandles(
        symbol: params.symbol,
        timeframe: params.timeframe,
        limit: params.limit,
      );
});
