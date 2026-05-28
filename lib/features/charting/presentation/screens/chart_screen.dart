// Path: lib/features/charting/presentation/screens/chart_screen.dart
// ============================================================
// MT5 Clone — Chart Screen
// Full-featured interactive candlestick chart screen with
// integrated technical indicators overlay and sub-chart panels.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../../../quotes/presentation/providers/quote_providers.dart';
import '../../domain/indicators/indicator_models.dart';
import '../notifiers/chart_notifier.dart';
import '../notifiers/indicator_notifier.dart';
import '../painters/candlestick_painter.dart';
import '../painters/indicator_painter.dart';
import '../widgets/indicators_sheet.dart';
import '../widgets/ohlcv_info_panel.dart';
import '../widgets/sub_chart_panel.dart';
import '../widgets/timeframe_selector.dart';

class ChartScreen extends ConsumerStatefulWidget {
  final String symbol;
  const ChartScreen({super.key, required this.symbol});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  // ── Gesture state ─────────────────────────────────────────
  double _scaleStart = 1.0;
  double _panAccumulator = 0.0;
  static const double _panSensitivity = 0.015; // candles per pixel
  static const double _priceAxisWidth = 72.0;
  static const double _timeAxisHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    final chartState =
        ref.watch(chartNotifierProvider(widget.symbol));
    final notifier =
        ref.read(chartNotifierProvider(widget.symbol).notifier);

    // Live tick for current price display in app bar
    final tickAsync =
        ref.watch(symbolTickProvider(widget.symbol));
    final liveTick = tickAsync.valueOrNull;
    final currentPrice = liveTick?.ask ?? 0.0;

    // Indicators
    final onChartSeries =
        ref.watch(onChartIndicatorsProvider(widget.symbol));
    final subChartSeries =
        ref.watch(subChartIndicatorsProvider(widget.symbol));

    // Recompute indicators when candles change
    ref.listen(chartNotifierProvider(widget.symbol), (prev, next) {
      if (next.candles.isNotEmpty &&
          next.candles != prev?.candles) {
        ref
            .read(indicatorNotifierProvider(widget.symbol).notifier)
            .recompute(next.candles);
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.chartBg,
      appBar: _buildAppBar(context, chartState, currentPrice),
      body: Column(
        children: [
          // ── OHLCV Panel (crosshair mode) ───────────────────
          if (chartState.crosshair.isActive &&
              chartState.crosshair.candle != null)
            OhlcvInfoPanel(candle: chartState.crosshair.candle!),

          // ── Main Chart Area ────────────────────────────────
          SizedBox(
            height: _mainChartHeight(context, subChartSeries.length),
            child: chartState.isLoading
                ? _buildLoadingState()
                : chartState.errorMessage != null
                    ? _buildErrorState(chartState.errorMessage!, notifier)
                    : _buildChartGestureArea(
                        chartState, notifier, currentPrice,
                        onChartSeries, subChartSeries),
          ),

          // ── Sub-Chart Panels ───────────────────────────────
          ...subChartSeries.map((series) => SubChartPanel(
                series: series,
                visibleCandles: chartState.visibleCandles,
                chartLeft: 0,
                chartRight: MediaQuery.of(context).size.width - _priceAxisWidth,
                onSettingsTap: () => _showIndicatorsSheet(context),
              )),

          // ── Timeframe Selector ────────────────────────────
          TimeframeSelector(
            selected: chartState.timeframe,
            onChanged: notifier.changeTimeframe,
          ),
        ],
      ),
    );
  }

  double _mainChartHeight(BuildContext context, int subChartCount) {
    final totalHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight -
        48 - // timeframe selector
        (subChartCount * 122.h); // sub-chart panels
    return totalHeight.clamp(200.0, double.infinity);
  }

  // ============================================================
  // AppBar
  // ============================================================

  AppBar _buildAppBar(
    BuildContext context,
    ChartState state,
    double currentPrice,
  ) {
    final symbol = widget.symbol;
    final precision = _precisionForSymbol(symbol);

    return AppBar(
      backgroundColor: AppTheme.backgroundSecondary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        onPressed: () => context.go(RouteNames.quotes),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Text(
            symbol.replaceAll('_', ''),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(width: 8.w),
          if (currentPrice > 0)
            Text(
              currentPrice.toStringAsFixed(precision),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryTeal,
              ),
            ),
        ],
      ),
      actions: [
        _ChartTypeButton(
          current: state.chartType,
          onChanged: ref
              .read(chartNotifierProvider(widget.symbol).notifier)
              .changeChartType,
        ),
        _AppBarIconBtn(
          icon: Icons.add,
          onTap: ref
              .read(chartNotifierProvider(widget.symbol).notifier)
              .zoomIn,
        ),
        _AppBarIconBtn(
          icon: Icons.remove,
          onTap: ref
              .read(chartNotifierProvider(widget.symbol).notifier)
              .zoomOut,
        ),
        if (!state.isAtLatest)
          _AppBarIconBtn(
            icon: Icons.keyboard_double_arrow_right,
            onTap: ref
                .read(chartNotifierProvider(widget.symbol).notifier)
                .scrollToLatest,
            color: AppTheme.primaryTeal,
          ),
        _AppBarIconBtn(
          icon: Icons.analytics_outlined,
          onTap: () => _showIndicatorsSheet(context),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  // ============================================================
  // Gesture Area
  // ============================================================

  Widget _buildChartGestureArea(
    ChartState state,
    ChartNotifier notifier,
    double currentPrice,
    List<IndicatorSeries> onChartSeries,
    List<IndicatorSeries> subChartSeries,
  ) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _panAccumulator += details.delta.dx * _panSensitivity;
        final candles = _panAccumulator.round();
        if (candles != 0) {
          notifier.onPan(-candles.toDouble());
          _panAccumulator -= candles;
        }
      },
      onHorizontalDragEnd: (_) => _panAccumulator = 0.0,
      onScaleStart: (details) {
        _scaleStart = 1.0;
      },
      onScaleUpdate: (details) {
        if (details.pointerCount < 2) return;
        final delta = details.scale / _scaleStart;
        if ((delta - 1.0).abs() > 0.02) {
          notifier.onScale(delta);
          _scaleStart = details.scale;
        }
      },
      onDoubleTap: notifier.scrollToLatest,
      onLongPressStart: (details) =>
          _onCrosshairStart(details.localPosition, state, notifier),
      onLongPressMoveUpdate: (details) =>
          _onCrosshairMove(details.localPosition, state, notifier),
      onLongPressEnd: (_) => notifier.hideCrosshair(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth - _priceAxisWidth;
          final chartHeight = constraints.maxHeight - _timeAxisHeight;

          return Stack(
            children: [
              // Main candlestick chart
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: CandlestickPainter(
                  candles: state.visibleCandles,
                  chartType: state.chartType,
                  priceHigh: state.visibleHigh ?? 0,
                  priceLow: state.visibleLow ?? 0,
                  crosshair: state.crosshair,
                  timeframe: state.timeframe,
                  displayPrecision: _precisionForSymbol(widget.symbol),
                  currentPrice: currentPrice,
                ),
              ),

              // Indicator overlay
              if (onChartSeries.isNotEmpty)
                CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: IndicatorOverlayPainter(
                    overlayIndicators: onChartSeries,
                    visibleCandles: state.visibleCandles,
                    priceHigh: state.visibleHigh ?? 0,
                    priceLow: state.visibleLow ?? 0,
                    chartLeft: 0,
                    chartRight: chartWidth,
                    chartTop: 0,
                    chartBottom: chartHeight,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── Crosshair helpers ─────────────────────────────────────

  void _onCrosshairStart(
    Offset position,
    ChartState state,
    ChartNotifier notifier,
  ) {
    final candleIndex = _positionToCandleIndex(position, state);
    final price = _positionToPrice(position, state);
    notifier.showCrosshair(position, candleIndex, price);
  }

  void _onCrosshairMove(
    Offset position,
    ChartState state,
    ChartNotifier notifier,
  ) {
    final candleIndex = _positionToCandleIndex(position, state);
    final price = _positionToPrice(position, state);
    notifier.showCrosshair(position, candleIndex, price);
  }

  int _positionToCandleIndex(Offset pos, ChartState state) {
    final chartWidth = MediaQuery.of(context).size.width - _priceAxisWidth;
    final candleWidth = chartWidth / state.visibleCandles.length;
    return (pos.dx / candleWidth).floor()
        .clamp(0, state.visibleCandles.length - 1);
  }

  double _positionToPrice(Offset pos, ChartState state) {
    final chartHeight =
        MediaQuery.of(context).size.height - 200.0;
    final priceRange =
        (state.visibleHigh ?? 0) - (state.visibleLow ?? 0);
    if (priceRange <= 0) return 0;
    final t = pos.dy / chartHeight;
    return (state.visibleHigh ?? 0) - priceRange * t;
  }

  // ============================================================
  // States
  // ============================================================

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.primaryTeal),
    );
  }

  Widget _buildErrorState(String message, ChartNotifier notifier) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline,
              color: AppTheme.sellRed, size: 40),
          SizedBox(height: 12.h),
          Text(message,
              style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13.sp)),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: notifier.refresh,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showIndicatorsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IndicatorsSheet(symbol: widget.symbol),
    );
  }

  int _precisionForSymbol(String symbol) {
    if (symbol.contains('XAU')) return 2;
    if (symbol.contains('JPY')) return 3;
    return 5;
  }
}

// ── Helper Widgets ────────────────────────────────────────────

class _AppBarIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _AppBarIconBtn({
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Icon(
          icon,
          size: 18.sp,
          color: color ?? AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _ChartTypeButton extends StatelessWidget {
  final ChartType current;
  final ValueChanged<ChartType> onChanged;

  const _ChartTypeButton({
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final next = ChartType
            .values[(current.index + 1) % ChartType.values.length];
        onChanged(next);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Icon(current.icon, size: 18.sp, color: AppTheme.primaryTeal),
      ),
    );
  }
}
