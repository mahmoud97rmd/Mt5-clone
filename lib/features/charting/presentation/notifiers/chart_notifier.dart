// Path: lib/features/charting/presentation/notifiers/chart_notifier.dart
// ============================================================
// MT5 Clone — Chart State Notifier
// Manages all chart view state:
//   - Symbol + Timeframe selection
//   - Chart type (Candle, Bar, Line)
//   - Zoom level (candles visible on screen)
//   - Pan offset (scroll position)
//   - Crosshair position & selected candle
//   - Price range (visible Y-axis min/max)
//   - Candle data + live candle updates
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/candle_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/streaming/candle_builder.dart';
import '../../data/repositories/candle_repository_impl.dart';

// ============================================================
// 9.5.1 — Chart Type Enum
// ============================================================

enum ChartType { candlestick, bar, line }

extension ChartTypeX on ChartType {
  IconData get icon => switch (this) {
        ChartType.candlestick => Icons.candlestick_chart,
        ChartType.bar => Icons.bar_chart,
        ChartType.line => Icons.show_chart,
      };
  String get label => switch (this) {
        ChartType.candlestick => 'Candles',
        ChartType.bar => 'Bars',
        ChartType.line => 'Line',
      };
}

// ============================================================
// 9.5.2 — Crosshair State
// ============================================================

class CrosshairState {
  final bool isActive;
  final Offset? position;      // screen coordinates
  final CandleEntity? candle;  // selected candle data
  final double? priceAtCursor; // exact price at cursor Y
  final DateTime? timeAtCursor;// exact time at cursor X

  const CrosshairState({
    this.isActive = false,
    this.position,
    this.candle,
    this.priceAtCursor,
    this.timeAtCursor,
  });

  CrosshairState copyWith({
    bool? isActive,
    Offset? position,
    CandleEntity? candle,
    double? priceAtCursor,
    DateTime? timeAtCursor,
  }) => CrosshairState(
        isActive: isActive ?? this.isActive,
        position: position ?? this.position,
        candle: candle ?? this.candle,
        priceAtCursor: priceAtCursor ?? this.priceAtCursor,
        timeAtCursor: timeAtCursor ?? this.timeAtCursor,
      );
}

// ============================================================
// 9.5.3 — Chart State
// ============================================================

class ChartState {
  final String symbol;
  final Timeframe timeframe;
  final ChartType chartType;

  // ── Data ───────────────────────────────────────────────────
  final List<CandleEntity> candles;
  final bool isLoading;
  final String? errorMessage;

  // ── View parameters ────────────────────────────────────────
  /// Number of candles visible on screen (controls zoom level)
  final int visibleCandleCount;

  /// Pan offset in candle units from the right edge
  /// 0 = latest candle at right edge
  final int panOffsetCandles;

  // ── Price range (Y axis) ───────────────────────────────────
  final double? visibleHigh;
  final double? visibleLow;

  // ── Crosshair ──────────────────────────────────────────────
  final CrosshairState crosshair;

  // ── Live candle ────────────────────────────────────────────
  final CandleEntity? liveCandle;

  const ChartState({
    required this.symbol,
    required this.timeframe,
    this.chartType = ChartType.candlestick,
    this.candles = const [],
    this.isLoading = true,
    this.errorMessage,
    this.visibleCandleCount = 60,
    this.panOffsetCandles = 0,
    this.visibleHigh,
    this.visibleLow,
    this.crosshair = const CrosshairState(),
    this.liveCandle,
  });

  /// Visible candles based on pan + zoom
  List<CandleEntity> get visibleCandles {
    if (candles.isEmpty) return [];
    final all = _candlesWithLive;
    final end = (all.length - panOffsetCandles).clamp(0, all.length);
    final start = (end - visibleCandleCount).clamp(0, end);
    return all.sublist(start, end);
  }

  /// Merge historical candles with live (incomplete) candle
  List<CandleEntity> get _candlesWithLive {
    if (liveCandle == null) return candles;
    if (candles.isEmpty) return [liveCandle!];
    // Replace last candle if same open time, else append
    final last = candles.last;
    if (last.openTime == liveCandle!.openTime) {
      return [...candles.sublist(0, candles.length - 1), liveCandle!];
    }
    return [...candles, liveCandle!];
  }

  bool get hasData => candles.isNotEmpty;
  bool get isAtLatest => panOffsetCandles == 0;

  ChartState copyWith({
    String? symbol,
    Timeframe? timeframe,
    ChartType? chartType,
    List<CandleEntity>? candles,
    bool? isLoading,
    String? errorMessage,
    int? visibleCandleCount,
    int? panOffsetCandles,
    double? visibleHigh,
    double? visibleLow,
    CrosshairState? crosshair,
    CandleEntity? liveCandle,
  }) => ChartState(
        symbol: symbol ?? this.symbol,
        timeframe: timeframe ?? this.timeframe,
        chartType: chartType ?? this.chartType,
        candles: candles ?? this.candles,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        visibleCandleCount: visibleCandleCount ?? this.visibleCandleCount,
        panOffsetCandles: panOffsetCandles ?? this.panOffsetCandles,
        visibleHigh: visibleHigh ?? this.visibleHigh,
        visibleLow: visibleLow ?? this.visibleLow,
        crosshair: crosshair ?? this.crosshair,
        liveCandle: liveCandle ?? this.liveCandle,
      );
}

// ============================================================
// 9.5.4 — Chart Notifier
// ============================================================

class ChartNotifier extends AutoDisposeFamilyNotifier<ChartState, String> {
  StreamSubscription<CandleEntity>? _liveCandleSub;

  // ── Zoom constraints ──────────────────────────────────────
  static const int _minVisibleCandles = 10;
  static const int _maxVisibleCandles = 300;

  @override
  ChartState build(String symbol) {
    ref.onDispose(() => _liveCandleSub?.cancel());

    final initial = ChartState(
      symbol: symbol,
      timeframe: Timeframe.h1,
    );

    // Load candles after build
    Future.microtask(() => _loadCandles(symbol, Timeframe.h1));

    return initial;
  }

  // ============================================================
  // 9.5.5 — Data Loading
  // ============================================================

  Future<void> _loadCandles(String symbol, Timeframe tf) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final repo = ref.read(candleRepositoryProvider);
    final result = await repo.getCandles(
      symbol: symbol,
      timeframe: tf,
      count: tf.defaultFetchCount,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (candles) {
        state = state.copyWith(
          candles: candles,
          isLoading: false,
          errorMessage: null,
        );
        _updatePriceRange();
        _startLiveCandleStream(symbol, tf);
      },
    );
  }

  // ============================================================
  // 9.5.6 — Live Candle Stream
  // ============================================================

  void _startLiveCandleStream(String symbol, Timeframe tf) {
    _liveCandleSub?.cancel();

    final builder = ref.read(candleBuilderProvider);
    _liveCandleSub = builder
        .watchCurrentCandle(symbol, tf)
        .listen((liveCandle) {
      state = state.copyWith(liveCandle: liveCandle);
      if (state.isAtLatest) _updatePriceRange();
    });
  }

  // ============================================================
  // 9.5.7 — Public Actions
  // ============================================================

  void changeTimeframe(Timeframe tf) {
    state = state.copyWith(
      timeframe: tf,
      panOffsetCandles: 0,
      crosshair: const CrosshairState(),
    );
    _loadCandles(state.symbol, tf);
  }

  void changeChartType(ChartType type) {
    state = state.copyWith(chartType: type);
  }

  /// Zoom in (show fewer candles)
  void zoomIn() {
    final newCount =
        (state.visibleCandleCount * 0.7).round()
        .clamp(_minVisibleCandles, _maxVisibleCandles);
    state = state.copyWith(visibleCandleCount: newCount);
    _updatePriceRange();
  }

  /// Zoom out (show more candles)
  void zoomOut() {
    final newCount =
        (state.visibleCandleCount * 1.4).round()
        .clamp(_minVisibleCandles, _maxVisibleCandles);
    state = state.copyWith(visibleCandleCount: newCount);
    _updatePriceRange();
  }

  /// Handle pinch-to-zoom gesture (scale factor)
  void onScale(double scaleFactor) {
    final newCount = (state.visibleCandleCount / scaleFactor)
        .round()
        .clamp(_minVisibleCandles, _maxVisibleCandles);
    state = state.copyWith(visibleCandleCount: newCount);
    _updatePriceRange();
  }

  /// Handle pan (scroll left/right through candle history)
  void onPan(double deltaCandles) {
    final maxOffset =
        (state.candles.length - state.visibleCandleCount)
        .clamp(0, state.candles.length);
    final newOffset =
        (state.panOffsetCandles + deltaCandles.round())
        .clamp(0, maxOffset);
    state = state.copyWith(panOffsetCandles: newOffset.toInt());
    _updatePriceRange();
  }

  /// Jump to the latest candle
  void scrollToLatest() {
    state = state.copyWith(panOffsetCandles: 0);
    _updatePriceRange();
  }

  // ── Crosshair ─────────────────────────────────────────────

  void showCrosshair(Offset position, int candleIndex, double price) {
    final visible = state.visibleCandles;
    final candle = (candleIndex >= 0 && candleIndex < visible.length)
        ? visible[candleIndex]
        : null;

    state = state.copyWith(
      crosshair: CrosshairState(
        isActive: true,
        position: position,
        candle: candle,
        priceAtCursor: price,
        timeAtCursor: candle?.openTime,
      ),
    );
  }

  void hideCrosshair() {
    state = state.copyWith(crosshair: const CrosshairState());
  }

  // ── Price Range ───────────────────────────────────────────

  void _updatePriceRange() {
    final visible = state.visibleCandles;
    if (visible.isEmpty) return;

    var high = visible.first.high;
    var low = visible.first.low;
    for (final c in visible) {
      if (c.high > high) high = c.high;
      if (c.low < low) low = c.low;
    }

    // Add 10% padding above and below
    final range = high - low;
    final pad = range * 0.10;

    state = state.copyWith(
      visibleHigh: high + pad,
      visibleLow: low - pad,
    );
  }

  // ── Refresh ───────────────────────────────────────────────

  Future<void> refresh() async {
    final repo = ref.read(candleRepositoryProvider);
    await repo.refreshCandles(
      symbol: state.symbol,
      timeframe: state.timeframe,
    );
    await _loadCandles(state.symbol, state.timeframe);
  }
}

// ============================================================
// 9.5.8 — Providers
// ============================================================

final chartNotifierProvider = AutoDisposeNotifierProviderFamily<
    ChartNotifier, ChartState, String>(ChartNotifier.new);
