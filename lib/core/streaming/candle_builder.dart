// Path: lib/core/streaming/candle_builder.dart
// ============================================================
// MT5 Clone — Real-Time Candle Builder
// Assembles live OHLCV candles from the raw tick stream.
//
// For each (symbol, timeframe) pair:
//   - Opens a new candle at the start of each period
//   - Updates H/L/C on every incoming tick
//   - Closes the candle and opens a new one at period boundary
//   - Persists completed candles to SQLite via CandlesDao
//
// Architecture:
//   OandaStreamingService (ticks)
//         ↓
//   CandleBuilder.processTickStream()
//         ↓
//   BehaviorSubject<CandleEntity> per (symbol, timeframe)
//         ↓
//   Chart widgets subscribe → real-time chart updates
// ============================================================

import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/database/app_database.dart';
import '../../core/database/daos/candles_dao.dart';
import '../../core/database/database_providers.dart';
import '../../core/domain/entities/candle_entity.dart';
import '../../core/domain/entities/tick_entity.dart';
import '../../core/domain/enums/trading_enums.dart';


// ============================================================
// 5.5.1 — Candle Builder Service
// ============================================================

class CandleBuilder {
  final CandlesDao _candlesDao;
  final Logger _log = Logger();

  // Active (incomplete) candle state per (symbol+timeframe)
  final Map<String, _CandleState> _activeCandles = {};

  // Per (symbol, timeframe) BehaviorSubject for chart widgets
  final Map<String, BehaviorSubject<CandleEntity>> _candleSubjects = {};

  // Subscriptions to the tick stream
  final List<StreamSubscription> _subscriptions = [];

  CandleBuilder({required CandlesDao candlesDao})
      : _candlesDao = candlesDao;

  // ============================================================
  // 5.5.2 — Public API
  // ============================================================

  /// Start building candles for [symbol] on [timeframe],
  /// fed by [tickStream].
  void startBuilding({
    required String symbol,
    required Timeframe timeframe,
    required Stream<TickEntity> tickStream,
  }) {
    final key = _key(symbol, timeframe);
    if (_candleSubjects.containsKey(key)) return; // already building

    _log.d('CandleBuilder: Starting $symbol ${timeframe.displayName}');

    _candleSubjects[key] = BehaviorSubject<CandleEntity>();

    final sub = tickStream
        .where((tick) => tick.symbol == symbol)
        .listen((tick) => _processTick(tick, timeframe));

    _subscriptions.add(sub);
  }

  /// Watch live candle updates for [symbol] on [timeframe].
  Stream<CandleEntity> watchCurrentCandle(
    String symbol,
    Timeframe timeframe,
  ) {
    final key = _key(symbol, timeframe);
    _candleSubjects.putIfAbsent(
      key,
      () => BehaviorSubject<CandleEntity>(),
    );
    return _candleSubjects[key]!.stream;
  }

  /// Stop all candle building and release resources.
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();

    for (final subject in _candleSubjects.values) {
      await subject.close();
    }
    _candleSubjects.clear();
    _activeCandles.clear();
  }

  // ============================================================
  // 5.5.3 — Tick Processor (the core logic)
  // ============================================================

  void _processTick(TickEntity tick, Timeframe timeframe) {
    final key = _key(tick.symbol, timeframe);
    final midPrice = tick.mid;
    final now = tick.timestamp;

    // Determine which candle period this tick belongs to
    final periodStart = _periodStart(now, timeframe);

    final existing = _activeCandles[key];

    if (existing == null || existing.periodStart != periodStart) {
      // ── New candle period started ─────────────────────────
      if (existing != null) {
        // Close and persist the previous candle
        _closeCandle(existing, tick.symbol, timeframe);
      }

      // Open new candle
      final newState = _CandleState(
        periodStart: periodStart,
        open: midPrice,
        high: midPrice,
        low: midPrice,
        close: midPrice,
        tickVolume: 1,
        bidClose: tick.bid,
        askClose: tick.ask,
      );
      _activeCandles[key] = newState;
      _emit(tick.symbol, timeframe, newState, isComplete: false);
    } else {
      // ── Update current candle ─────────────────────────────
      existing
        ..high = midPrice > existing.high ? midPrice : existing.high
        ..low = midPrice < existing.low ? midPrice : existing.low
        ..close = midPrice
        ..tickVolume = existing.tickVolume + 1
        ..bidClose = tick.bid
        ..askClose = tick.ask;

      _emit(tick.symbol, timeframe, existing, isComplete: false);
    }
  }

  // ============================================================
  // 5.5.4 — Candle Close & Persistence
  // ============================================================

  void _closeCandle(
    _CandleState state,
    String symbol,
    Timeframe timeframe,
  ) {
    final entity = _stateToEntity(state, symbol, timeframe, isComplete: true);

    // Emit the completed candle
    final key = _key(symbol, timeframe);
    _candleSubjects[key]?.add(entity);

    // Persist to SQLite asynchronously
    _persistCandle(entity);
    _log.d('CandleBuilder: Closed ${timeframe.displayName} candle '
        '$symbol @ ${state.periodStart}');
  }

  Future<void> _persistCandle(CandleEntity candle) async {
    try {
      await _candlesDao.upsertCandle(
        CandlesCompanion.insert(
          symbol: candle.symbol,
          timeframe: candle.timeframe,
          open: candle.open,
          high: candle.high,
          low: candle.low,
          close: candle.close,
          openTimeUs: candle.openTime.microsecondsSinceEpoch,
          volume: Value(candle.volume),
          isComplete: Value(candle.isComplete),
        ),
      );
    } catch (e) {
      _log.w('CandleBuilder: Persist error — $e');
    }
  }

  // ============================================================
  // 5.5.5 — Helpers
  // ============================================================

  void _emit(
    String symbol,
    Timeframe timeframe,
    _CandleState state,
    {required bool isComplete}
  ) {
    final key = _key(symbol, timeframe);
    final subject = _candleSubjects[key];
    if (subject == null || subject.isClosed) return;
    subject.add(_stateToEntity(state, symbol, timeframe,
        isComplete: isComplete));
  }

  CandleEntity _stateToEntity(
    _CandleState state,
    String symbol,
    Timeframe timeframe,
    {required bool isComplete}
  ) {
    return CandleEntity(
      symbol: symbol,
      timeframe: timeframe.oandaName,
      open: state.open,
      high: state.high,
      low: state.low,
      close: state.close,
      volume: state.tickVolume.toDouble(),
      openTime: state.periodStart,
      isComplete: isComplete,
    );
  }

  /// Calculate the start of the candle period containing [time].
  DateTime _periodStart(DateTime time, Timeframe timeframe) {
    final utc = time.toUtc();
    return switch (timeframe) {
      Timeframe.m1 => DateTime.utc(
          utc.year, utc.month, utc.day, utc.hour, utc.minute),
      Timeframe.m5 => DateTime.utc(
          utc.year, utc.month, utc.day, utc.hour,
          (utc.minute ~/ 5) * 5),
      Timeframe.m10 => DateTime.utc(
          utc.year, utc.month, utc.day, utc.hour,
          (utc.minute ~/ 10) * 10),
      Timeframe.m15 => DateTime.utc(
          utc.year, utc.month, utc.day, utc.hour,
          (utc.minute ~/ 15) * 15),
      Timeframe.m30 => DateTime.utc(
          utc.year, utc.month, utc.day, utc.hour,
          (utc.minute ~/ 30) * 30),
      Timeframe.h1 => DateTime.utc(
          utc.year, utc.month, utc.day, utc.hour),
      Timeframe.h2 => DateTime.utc(
          utc.year, utc.month, utc.day, (utc.hour ~/ 2) * 2),
      Timeframe.h4 => DateTime.utc(
          utc.year, utc.month, utc.day, (utc.hour ~/ 4) * 4),
      Timeframe.h6 => DateTime.utc(
          utc.year, utc.month, utc.day, (utc.hour ~/ 6) * 6),
      Timeframe.h8 => DateTime.utc(
          utc.year, utc.month, utc.day, (utc.hour ~/ 8) * 8),
      Timeframe.h12 => DateTime.utc(
          utc.year, utc.month, utc.day, (utc.hour ~/ 12) * 12),
      Timeframe.d1 => DateTime.utc(utc.year, utc.month, utc.day),
      Timeframe.w1 => _weekStart(utc),
      Timeframe.mn => DateTime.utc(utc.year, utc.month),
    };
  }

  /// ISO week start (Monday).
  DateTime _weekStart(DateTime utc) {
    final daysFromMonday = (utc.weekday - 1) % 7;
    final monday = utc.subtract(Duration(days: daysFromMonday));
    return DateTime.utc(monday.year, monday.month, monday.day);
  }

  static String _key(String symbol, Timeframe tf) =>
      '${symbol}_${tf.displayName}';
}

// ============================================================
// 5.5.6 — Mutable Candle State (internal use only)
// ============================================================

class _CandleState {
  final DateTime periodStart;
  final double open;
  double high;
  double low;
  double close;
  int tickVolume;
  double? bidClose;
  double? askClose;

  _CandleState({
    required this.periodStart,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.tickVolume,
    this.bidClose,
    this.askClose,
  });
}

// ============================================================
// 5.5.7 — Riverpod Provider
// ============================================================

final candleBuilderProvider = Provider<CandleBuilder>((ref) {
  final builder = CandleBuilder(
    candlesDao: ref.watch(candlesDaoProvider),
  );
  ref.onDispose(builder.dispose);
  return builder;
});
