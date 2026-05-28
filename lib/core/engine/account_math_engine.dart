// Path: lib/core/engine/account_math_engine.dart
// ============================================================
// MT5 Clone — Account Math Engine
// The real-time financial calculation core.
//
// Triggered on EVERY price tick to recalculate:
//   - Floating PnL for every open position
//   - Total equity (balance + sum of all PnLs)
//   - Margin used, free margin, margin level %
//   - Per-position updated current price
//
// Performance requirements:
//   - Must complete in < 2ms (called 1–5 times/second)
//   - Zero allocations in the hot path where possible
//   - Writes to Hive cache (sync) THEN SQLite (async)
//
// Architecture:
//   OandaStreamingService (tick)
//         ↓ [for each open position on that symbol]
//   AccountMathEngine._recalculateForTick()
//         ↓
//   HiveCacheService.cacheAccountState()  ← immediate UI update
//         ↓
//   PositionsDao.batchUpdatePrices()      ← async DB persist
//         ↓
//   _accountStateController (BehaviorSubject)
//         ↓
//   AccountStateProvider → TopBar UI
// ============================================================

import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/account_dao.dart';
import '../../core/database/daos/positions_dao.dart';
import '../../core/database/database_providers.dart';
import '../../core/database/hive_cache_service.dart';
import '../../core/domain/entities/account_entity.dart';
import '../../core/domain/entities/position_entity.dart';
import '../../core/domain/entities/tick_entity.dart';
import '../../core/domain/enums/trading_enums.dart';
import '../../core/domain/services/trading_calculators.dart';
import '../../features/quotes/data/datasources/oanda_streaming_service.dart';

// ============================================================
// 6.1.1 — Account Math Engine
// ============================================================

class AccountMathEngine {
  final PositionsDao _positionsDao;
  final AccountDao _accountDao;
  final OandaStreamingService _streamingService;
  final Logger _log = Logger();

  // ── State ─────────────────────────────────────────────────
  final _accountStateController = BehaviorSubject<AccountEntity>();

  // In-memory positions cache for O(1) lookup on tick
  // Key: oandaTradeId, Value: latest PositionEntity
  final Map<String, PositionEntity> _positionCache = {};

  // In-memory account base state (balance, currency, etc.)
  AccountEntity? _baseAccount;

  // Symbol → [list of position IDs on that symbol]
  // For fast lookup when a tick arrives
  final Map<String, List<String>> _symbolPositionIndex = {};

  // Symbol → pip size (for fast PnL calculation)
  final Map<String, double> _pipSizeCache = {};

  // Symbol → units per lot
  final Map<String, double> _unitsPerLotCache = {};

  // Subscriptions
  StreamSubscription<TickEntity>? _tickSub;
  Timer? _snapshotTimer;

  // ── Constants ─────────────────────────────────────────────
  static const Duration _snapshotInterval = Duration(minutes: 1);

  AccountMathEngine({
    required PositionsDao positionsDao,
    required AccountDao accountDao,
    required OandaStreamingService streamingService,
  })  : _positionsDao = positionsDao,
        _accountDao = accountDao,
        _streamingService = streamingService;

  // ============================================================
  // 6.1.2 — Public API
  // ============================================================

  /// Stream of live account state. Emits on every recalculation.
  Stream<AccountEntity> get accountStream =>
      _accountStateController.stream;

  /// Current account state (synchronous).
  AccountEntity? get currentAccount => _accountStateController.valueOrNull;

  /// Initialize the engine with base account data.
  /// Must be called after account info is loaded from OANDA.
  Future<void> initialize(AccountEntity baseAccount) async {
    _baseAccount = baseAccount;

    // Load all open positions into memory cache
    await _rebuildPositionCache();

    // Start listening to the tick stream
    _startTickListener();

    // Start periodic snapshot writer
    _startSnapshotTimer();

    // Emit initial state immediately
    _recalculateAndEmit();

    _log.i('AccountMathEngine: Initialized — '
        '${_positionCache.length} positions, '
        'balance=${baseAccount.balance}');
  }

  /// Update the base account balance (after a trade closes).
  void updateBalance(double newBalance) {
    _baseAccount = _baseAccount?.copyWith(balance: newBalance);
    _recalculateAndEmit();
  }

  /// Add a newly opened position to the in-memory cache.
  void onPositionOpened(PositionEntity position) {
    _positionCache[position.oandaTradeId] = position;
    _indexPosition(position);
    _recalculateAndEmit();
    _log.d('AccountMathEngine: Position opened — ${position.oandaTradeId}');
  }

  /// Remove a closed position from the in-memory cache.
  void onPositionClosed(String oandaTradeId) {
    final position = _positionCache.remove(oandaTradeId);
    if (position != null) {
      _symbolPositionIndex[position.symbol]?.remove(oandaTradeId);
    }
    _recalculateAndEmit();
    _log.d('AccountMathEngine: Position closed — $oandaTradeId');
  }

  /// Update SL/TP in cache after modification.
  void onPositionModified(
    String oandaTradeId, {
    double? stopLoss,
    double? takeProfit,
  }) {
    final pos = _positionCache[oandaTradeId];
    if (pos == null) return;
    _positionCache[oandaTradeId] =
        pos.withModifiedSlTp(newStopLoss: stopLoss, newTakeProfit: takeProfit);
  }

  /// Force a full position reload from DB (e.g., after app resume).
  Future<void> reloadPositions() async {
    await _rebuildPositionCache();
    _recalculateAndEmit();
  }

  /// Update pip configuration for a symbol (from instrument data).
  void setSymbolConfig({
    required String symbol,
    required double pipSize,
    required double unitsPerLot,
  }) {
    _pipSizeCache[symbol] = pipSize;
    _unitsPerLotCache[symbol] = unitsPerLot;
  }

  // ============================================================
  // 6.1.3 — Tick Listener
  // ============================================================

  void _startTickListener() {
    _tickSub?.cancel();
    _tickSub = _streamingService.tickStream.listen(
      _onTick,
      onError: (e) => _log.w('AccountMathEngine: Tick error — $e'),
    );
  }

  // ============================================================
  // 6.1.4 — Core Tick Handler (HOT PATH — must be fast)
  // ============================================================

  void _onTick(TickEntity tick) {
    // Quick exit: no positions on this symbol
    final positionIds = _symbolPositionIndex[tick.symbol];
    if (positionIds == null || positionIds.isEmpty) return;

    // Recalculate PnL for each affected position
    final updatedPositions = <({
      String tradeId,
      double price,
      double pnl,
      double margin,
    })>[];

    for (final tradeId in positionIds) {
      final position = _positionCache[tradeId];
      if (position == null) continue;

      final newPrice = position.direction.isBuy ? tick.bid : tick.ask;
      final unitsPerLot =
          _unitsPerLotCache[tick.symbol] ?? _defaultUnitsPerLot(tick.symbol);
      final units = position.lots * unitsPerLot;

      // Calculate floating PnL
      final newPnl = PnlCalculator.calculateFloatingPnl(
        isBuy: position.direction.isBuy,
        openPrice: position.openPrice,
        currentPrice: newPrice,
        units: units,
      );

      // Calculate margin (based on current price)
      final marginRate = _marginRate(tick.symbol);
      final newMargin = MarginCalculator.calculateRequiredMargin(
        units: units,
        price: newPrice,
        marginRate: marginRate,
      );

      // Update in-memory cache (zero allocation update)
      _positionCache[tradeId] = position.withUpdatedPrice(
        newCurrentPrice: newPrice,
        newFloatingPnl: newPnl,
        newMarginUsed: newMargin,
      );

      updatedPositions.add((
        tradeId: tradeId,
        price: newPrice,
        pnl: newPnl,
        margin: newMargin,
      ));
    }

    // Recalculate account totals and emit
    _recalculateAndEmit();

    // Persist to SQLite asynchronously (non-blocking)
    if (updatedPositions.isNotEmpty) {
      _positionsDao
          .batchUpdatePrices(updatedPositions)
          .catchError((e) => _log.w('AccountMathEngine: DB update error — $e'));
    }
  }

  // ============================================================
  // 6.1.5 — Account State Recalculation
  // ============================================================

  void _recalculateAndEmit() {
    final base = _baseAccount;
    if (base == null) return;

    // Aggregate across all positions
    double totalFloatingPnl = 0.0;
    double totalMarginUsed = 0.0;
    int positionCount = 0;

    for (final position in _positionCache.values) {
      totalFloatingPnl += position.floatingPnl;
      totalMarginUsed += position.marginUsed;
      positionCount++;
    }

    // Recalculate account metrics
    final equity = base.balance + totalFloatingPnl;
    final freeMargin = equity - totalMarginUsed;
    final marginLevel = totalMarginUsed > 0
        ? (equity / totalMarginUsed) * 100.0
        : null;

    // Build updated account entity
    final updated = base.copyWith(
      equity: equity,
      marginUsed: totalMarginUsed,
      marginAvailable: freeMargin,
      marginLevel: marginLevel,
      openPositionCount: positionCount,
      unrealizedPnl: totalFloatingPnl,
      lastUpdated: DateTime.now(),
    );

    // 1. Write to Hive cache (sync — immediate UI update)
    HiveCacheService.cacheAccountState(
      accountId: updated.accountId,
      balance: updated.balance,
      equity: updated.equity,
      marginUsed: updated.marginUsed,
      marginAvailable: updated.marginAvailable,
      marginLevel: updated.marginLevel,
      unrealizedPnl: updated.unrealizedPnl,
    );

    // 2. Emit to BehaviorSubject → UI
    _accountStateController.add(updated);
  }

  // ============================================================
  // 6.1.6 — Position Cache Management
  // ============================================================

  Future<void> _rebuildPositionCache() async {
    _positionCache.clear();
    _symbolPositionIndex.clear();

    final dbPositions = await _positionsDao.getAllPositions();

    for (final dbPos in dbPositions) {
      final entity = PositionEntity(
        oandaTradeId: dbPos.oandaTradeId,
        symbol: dbPos.symbol,
        direction: TradeDirection.fromString(dbPos.direction),
        lots: dbPos.lots,
        units: dbPos.units,
        openPrice: dbPos.openPrice,
        currentPrice: dbPos.currentPrice,
        stopLoss: dbPos.stopLoss,
        takeProfit: dbPos.takeProfit,
        floatingPnl: dbPos.floatingPnl,
        swap: dbPos.swap,
        commission: dbPos.commission,
        marginUsed: dbPos.marginUsed,
        openTime: DateTime.fromMicrosecondsSinceEpoch(dbPos.openTimeUs),
        magicNumber: dbPos.magicNumber,
        comment: dbPos.comment,
      );
      _positionCache[entity.oandaTradeId] = entity;
      _indexPosition(entity);
    }

    _log.d('AccountMathEngine: Cache rebuilt — '
        '${_positionCache.length} positions');
  }

  void _indexPosition(PositionEntity position) {
    _symbolPositionIndex
        .putIfAbsent(position.symbol, () => [])
        .add(position.oandaTradeId);
  }

  // ============================================================
  // 6.1.7 — Periodic Snapshot Writer
  // ============================================================

  void _startSnapshotTimer() {
    _snapshotTimer?.cancel();
    _snapshotTimer = Timer.periodic(_snapshotInterval, (_) {
      _writeSnapshot(trigger: 'PERIODIC');
    });
  }

  Future<void> _writeSnapshot({String trigger = 'PERIODIC'}) async {
    final account = _accountStateController.valueOrNull;
    if (account == null) return;

    try {
      final now = DateTime.now();
      await _accountDao.insertSnapshot(
        AccountSnapshotsCompanion.insert(
          accountId: account.accountId,
          balance: account.balance,
          equity: account.equity,
          marginUsed: account.marginUsed,
          marginAvailable: account.marginAvailable,
          marginLevel: Value(account.marginLevel),
          nav: Value(account.nav),
          openPositionCount: Value(account.openPositionCount),
          unrealizedPnl: Value(account.unrealizedPnl),
          dailyRealizedPnl: Value(account.dailyRealizedPnl),
          snapshotTrigger: Value(trigger),
          timestampUs: now.microsecondsSinceEpoch,
          date: now.toIso8601String().substring(0, 10),
        ),
      );
    } catch (e) {
      _log.w('AccountMathEngine: Snapshot write error — $e');
    }
  }

  // ============================================================
  // 6.1.8 — Helpers
  // ============================================================

  double _defaultUnitsPerLot(String symbol) {
    return symbol.contains('XAU') || symbol.contains('XAG')
        ? 100.0
        : 100000.0;
  }

  double _marginRate(String symbol) {
    // Default rates — overridden by setSymbolConfig()
    if (symbol.contains('XAU') || symbol.contains('XAG')) return 0.05;
    return 0.02;
  }

  // ============================================================
  // 6.1.9 — Dispose
  // ============================================================

  Future<void> dispose() async {
    await _tickSub?.cancel();
    _snapshotTimer?.cancel();
    await _accountStateController.close();
    _positionCache.clear();
    _symbolPositionIndex.clear();
    _log.d('AccountMathEngine: Disposed');
  }
}

// ============================================================
// 6.1.10 — Riverpod Provider
// ============================================================

final accountMathEngineProvider = Provider<AccountMathEngine>((ref) {
  final engine = AccountMathEngine(
    positionsDao: ref.watch(positionsDaoProvider),
    accountDao: ref.watch(accountDaoProvider),
    streamingService: ref.watch(oandaStreamingServiceProvider),
  );
  ref.onDispose(engine.dispose);
  return engine;
});
