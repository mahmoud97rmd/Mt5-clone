// Path: lib/features/charting/presentation/painters/indicator_painter.dart
// ============================================================
// MT5 Clone — Indicator Painter
// Renders technical indicator overlays and sub-charts.
// ============================================================

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/candle_entity.dart';
import '../../domain/indicators/indicator_models.dart';

// ============================================================
// Overlay Painter (renders on main chart)
// ============================================================

class IndicatorOverlayPainter extends CustomPainter {
  final List<IndicatorSeries> overlayIndicators;
  final List<CandleEntity> visibleCandles;
  final double priceHigh;
  final double priceLow;
  final double chartLeft;
  final double chartRight;
  final double chartTop;
  final double chartBottom;

  IndicatorOverlayPainter({
    required this.overlayIndicators,
    required this.visibleCandles,
    required this.priceHigh,
    required this.priceLow,
    required this.chartLeft,
    required this.chartRight,
    required this.chartTop,
    required this.chartBottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (visibleCandles.isEmpty) return;
    final priceRange = priceHigh - priceLow;
    if (priceRange <= 0) return;

    final chartWidth = chartRight - chartLeft;
    final candleWidth = chartWidth / visibleCandles.length;

    for (final series in overlayIndicators) {
      if (!series.config.isVisible || series.isEmpty) continue;

      // Draw fill areas first (e.g., Bollinger Bands, Ichimoku cloud)
      _drawFills(canvas, series, candleWidth, priceRange);

      // Draw lines
      for (int lineIdx = 0; lineIdx < series.lines.length; lineIdx++) {
        final points = series.lines[lineIdx];
        if (points.isEmpty) continue;

        final color = lineIdx < series.lineColors.length
            ? series.lineColors[lineIdx]
            : series.config.color;

        _drawIndicatorLine(
          canvas,
          points,
          candleWidth,
          priceRange,
          color,
          series.config.lineWidth,
        );
      }
    }
  }

  void _drawIndicatorLine(
    Canvas canvas,
    List<IndicatorPoint> points,
    double candleWidth,
    double priceRange,
    Color color,
    double lineWidth,
  ) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    bool started = false;

    for (final point in points) {
      final x = _timeToX(point.time, candleWidth);
      final y = _priceToY(point.value, priceRange);

      if (x < chartLeft - 10 || x > chartRight + 10) continue;

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawFills(
    Canvas canvas,
    IndicatorSeries series,
    double candleWidth,
    double priceRange,
  ) {
    // Bollinger Bands fill
    if (series.config.type == IndicatorType.bollingerBands &&
        series.lines.length >= 3) {
      final upper = series.lines[0];
      final lower = series.lines[2];
      _drawAreaFill(canvas, upper, lower, candleWidth, priceRange,
          series.config.color.withOpacity(0.08));
    }

    // Ichimoku cloud fill
    if (series.config.type == IndicatorType.ichimoku &&
        series.lines.length >= 4) {
      final senkouA = series.lines[2];
      final senkouB = series.lines[3];
      _drawIchimokuCloud(canvas, senkouA, senkouB, candleWidth, priceRange);
    }
  }

  void _drawAreaFill(
    Canvas canvas,
    List<IndicatorPoint> upper,
    List<IndicatorPoint> lower,
    double candleWidth,
    double priceRange,
    Color color,
  ) {
    if (upper.isEmpty || lower.isEmpty) return;

    final path = Path();
    final minLen = math.min(upper.length, lower.length);
    if (minLen < 2) return;

    // Upper line (left to right)
    bool started = false;
    for (int i = 0; i < minLen; i++) {
      final x = _timeToX(upper[i].time, candleWidth);
      final y = _priceToY(upper[i].value, priceRange);
      if (x < chartLeft - 10 || x > chartRight + 10) continue;
      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    // Lower line (right to left)
    for (int i = minLen - 1; i >= 0; i--) {
      final x = _timeToX(lower[i].time, candleWidth);
      final y = _priceToY(lower[i].value, priceRange);
      if (x < chartLeft - 10 || x > chartRight + 10) continue;
      path.lineTo(x, y);
    }

    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawIchimokuCloud(
    Canvas canvas,
    List<IndicatorPoint> senkouA,
    List<IndicatorPoint> senkouB,
    double candleWidth,
    double priceRange,
  ) {
    if (senkouA.isEmpty || senkouB.isEmpty) return;

    final minLen = math.min(senkouA.length, senkouB.length);
    if (minLen < 2) return;

    final path = Path();
    bool started = false;

    for (int i = 0; i < minLen; i++) {
      final x = _timeToX(senkouA[i].time, candleWidth);
      final y = _priceToY(senkouA[i].value, priceRange);
      if (x < chartLeft - 10 || x > chartRight + 10) continue;
      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    for (int i = minLen - 1; i >= 0; i--) {
      final x = _timeToX(senkouB[i].time, candleWidth);
      final y = _priceToY(senkouB[i].value, priceRange);
      if (x < chartLeft - 10 || x > chartRight + 10) continue;
      path.lineTo(x, y);
    }

    path.close();

    // Cloud color: green if Senkou A > Senkou B, red otherwise
    final isBullish = senkouA.length > 1 &&
        senkouA[senkouA.length ~/ 2].value > senkouB[senkouB.length ~/ 2].value;
    final cloudColor = isBullish
        ? AppTheme.buyGreen.withOpacity(0.12)
        : AppTheme.sellRed.withOpacity(0.12);

    canvas.drawPath(path, Paint()..color = cloudColor);
  }

  double _timeToX(DateTime time, double candleWidth) {
    // Find candle index by time
    for (int i = 0; i < visibleCandles.length; i++) {
      if (visibleCandles[i].openTime == time) {
        return chartLeft + candleWidth * i + candleWidth / 2;
      }
    }
    // Approximate position
    return chartLeft;
  }

  double _priceToY(double price, double priceRange) {
    final t = (priceHigh - price) / priceRange;
    return chartTop + (chartBottom - chartTop) * t;
  }

  @override
  bool shouldRepaint(IndicatorOverlayPainter old) {
    return old.overlayIndicators != overlayIndicators ||
        old.visibleCandles != visibleCandles ||
        old.priceHigh != priceHigh ||
        old.priceLow != priceLow;
  }
}

// ============================================================
// Sub-Chart Painter (RSI, MACD, Stochastic, ATR)
// ============================================================

class SubChartPainter extends CustomPainter {
  final IndicatorSeries series;
  final List<CandleEntity> visibleCandles;
  final double chartLeft;
  final double chartRight;

  SubChartPainter({
    required this.series,
    required this.visibleCandles,
    required this.chartLeft,
    required this.chartRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty || visibleCandles.isEmpty) return;

    final chartRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final dataMin = series.subChartMin ?? _minValue();
    final dataMax = series.subChartMax ?? _maxValue();
    final dataRange = dataMax - dataMin;
    if (dataRange <= 0) return;

    // Draw levels (e.g., RSI 70/30, Stochastic 80/20)
    _drawLevels(canvas, chartRect, dataMin, dataRange);

    // Draw histogram bars for MACD
    if (series.config.type == IndicatorType.macd && series.lines.length >= 3) {
      _drawHistogram(canvas, chartRect, series.lines[2], dataMin, dataRange);
    }

    // Draw lines
    final lineCount = series.config.type == IndicatorType.macd ? 2 : series.lines.length;
    for (int i = 0; i < lineCount; i++) {
      final points = series.lines[i];
      if (points.isEmpty) continue;

      final color = i < series.lineColors.length
          ? series.lineColors[i]
          : series.config.color;

      _drawLine(canvas, chartRect, points, dataMin, dataRange, color);
    }
  }

  void _drawLevels(
    Canvas canvas,
    Rect chartRect,
    double dataMin,
    double dataRange,
  ) {
    if (series.levels == null) return;

    for (final level in series.levels!) {
      final y = chartRect.bottom -
          ((level.value - dataMin) / dataRange) * chartRect.height;

      final paint = Paint()
        ..color = level.color.withOpacity(0.4)
        ..strokeWidth = 0.5;

      if (level.isDashed) {
        double x = chartRect.left;
        while (x < chartRect.right) {
          canvas.drawLine(
            Offset(x, y),
            Offset(math.min(x + 4, chartRect.right), y),
            paint,
          );
          x += 8;
        }
      } else {
        canvas.drawLine(
          Offset(chartRect.left, y),
          Offset(chartRect.right, y),
          paint,
        );
      }
    }
  }

  void _drawLine(
    Canvas canvas,
    Rect chartRect,
    List<IndicatorPoint> points,
    double dataMin,
    double dataRange,
    Color color,
  ) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = series.config.lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    bool started = false;
    final candleWidth = (chartRight - chartLeft) / visibleCandles.length;

    for (final point in points) {
      final x = _timeToX(point.time, candleWidth);
      final y = chartRect.bottom -
          ((point.value - dataMin) / dataRange) * chartRect.height;

      if (x < chartLeft - 10 || x > chartRight + 10) continue;

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawHistogram(
    Canvas canvas,
    Rect chartRect,
    List<IndicatorPoint> points,
    double dataMin,
    double dataRange,
  ) {
    final candleWidth = (chartRight - chartLeft) / visibleCandles.length;
    final barWidth = (candleWidth * 0.6).clamp(1.0, 8.0);
    final zeroY = chartRect.bottom -
        ((0 - dataMin) / dataRange) * chartRect.height;

    for (final point in points) {
      final x = _timeToX(point.time, candleWidth);
      final y = chartRect.bottom -
          ((point.value - dataMin) / dataRange) * chartRect.height;

      if (x < chartLeft - 10 || x > chartRight + 10) continue;

      final color = point.value >= 0 ? AppTheme.buyGreen : AppTheme.sellRed;
      final top = math.min(y, zeroY);
      final bottom = math.max(y, zeroY);

      canvas.drawRect(
        Rect.fromLTWH(x - barWidth / 2, top, barWidth, bottom - top),
        Paint()..color = color.withOpacity(0.7),
      );
    }
  }

  double _timeToX(DateTime time, double candleWidth) {
    for (int i = 0; i < visibleCandles.length; i++) {
      if (visibleCandles[i].openTime == time) {
        return chartLeft + candleWidth * i + candleWidth / 2;
      }
    }
    return chartLeft;
  }

  double _minValue() {
    double min = double.infinity;
    for (final line in series.lines) {
      for (final p in line) {
        if (p.value < min) min = p.value;
      }
    }
    return min == double.infinity ? 0 : min;
  }

  double _maxValue() {
    double max = double.negativeInfinity;
    for (final line in series.lines) {
      for (final p in line) {
        if (p.value > max) max = p.value;
      }
    }
    return max == double.negativeInfinity ? 100 : max;
  }

  @override
  bool shouldRepaint(SubChartPainter old) {
    return old.series != series || old.visibleCandles != visibleCandles;
  }
}
