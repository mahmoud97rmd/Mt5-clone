// Path: lib/features/charting/presentation/painters/candlestick_painter.dart
// ============================================================
// MT5 Clone — Candlestick Chart CustomPainter
// High-performance canvas rendering of OHLCV candlesticks.
//
// Rendering pipeline per frame:
//   1. Calculate candle width from available space + count
//   2. Map price → Y coordinate (linear interpolation)
//   3. Draw grid lines (horizontal price levels)
//   4. For each candle: draw wick (line) + body (rect)
//   5. Draw crosshair overlay (if active)
//   6. Draw price axis labels (right side)
//   7. Draw time axis labels (bottom)
//
// Performance:
//   - Uses Paint objects cached as fields (no per-frame allocation)
//   - shouldRepaint checks identity equality of candle list
//   - Canvas.drawLine/drawRect are hardware-accelerated
// ============================================================

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/candle_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../notifiers/chart_notifier.dart';

// ── Layout Constants ──────────────────────────────────────────
const double _priceAxisWidth = 72.0;
const double _timeAxisHeight = 24.0;
const double _candleGapRatio = 0.2; // gap = 20% of candleWidth

class CandlestickPainter extends CustomPainter {
  final List<CandleEntity> candles;
  final ChartType chartType;
  final double priceHigh;
  final double priceLow;
  final CrosshairState crosshair;
  final Timeframe timeframe;
  final int displayPrecision;
  final double currentPrice;

  // ── Cached Paint objects ──────────────────────────────────

  final _bullBodyPaint = Paint()
    ..color = AppTheme.chartBullCandle
    ..style = PaintingStyle.fill;

  final _bearBodyPaint = Paint()
    ..color = AppTheme.chartBearCandle
    ..style = PaintingStyle.fill;

  final _bullWickPaint = Paint()
    ..color = AppTheme.chartBullCandle
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final _bearWickPaint = Paint()
    ..color = AppTheme.chartBearCandle
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final _gridPaint = Paint()
    ..color = AppTheme.chartGrid
    ..strokeWidth = 0.5;

  final _crosshairPaint = Paint()
    ..color = AppTheme.chartCrosshair
    ..strokeWidth = 0.8
    ..style = PaintingStyle.stroke;

  final _currentPricePaint = Paint()
    ..color = AppTheme.primaryTeal
    ..strokeWidth = 0.8
    ..style = PaintingStyle.stroke;

  final _linePaint = Paint()
    ..color = AppTheme.primaryTeal
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  CandlestickPainter({
    required this.candles,
    required this.chartType,
    required this.priceHigh,
    required this.priceLow,
    required this.crosshair,
    required this.timeframe,
    required this.displayPrecision,
    required this.currentPrice,
  });

  // ============================================================
  // 9.2.1 — Main paint method
  // ============================================================

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    // Chart area excludes price axis (right) and time axis (bottom)
    final chartRect = Rect.fromLTWH(
      0,
      0,
      size.width - _priceAxisWidth,
      size.height - _timeAxisHeight,
    );

    // Clip to chart area for candle drawing
    canvas.save();
    canvas.clipRect(chartRect.inflate(2));

    // ── 1. Draw grid ─────────────────────────────────────────
    _drawGrid(canvas, chartRect);

    // ── 2. Draw candles or line ───────────────────────────────
    switch (chartType) {
      case ChartType.candlestick:
        _drawCandlesticks(canvas, chartRect);
      case ChartType.bar:
        _drawBarChart(canvas, chartRect);
      case ChartType.line:
        _drawLineChart(canvas, chartRect);
    }

    // ── 3. Current price line ─────────────────────────────────
    _drawCurrentPriceLine(canvas, chartRect);

    canvas.restore();

    // ── 4. Price axis (outside clip) ─────────────────────────
    _drawPriceAxis(canvas, size, chartRect);

    // ── 5. Time axis ─────────────────────────────────────────
    _drawTimeAxis(canvas, size, chartRect);

    // ── 6. Crosshair ─────────────────────────────────────────
    if (crosshair.isActive && crosshair.position != null) {
      _drawCrosshair(canvas, size, chartRect, crosshair.position!);
    }
  }

  // ============================================================
  // 9.2.2 — Grid Lines
  // ============================================================

  void _drawGrid(Canvas canvas, Rect chartRect) {
    const gridLineCount = 6;
    final priceRange = priceHigh - priceLow;
    if (priceRange <= 0) return;

    for (int i = 0; i <= gridLineCount; i++) {
      final y = chartRect.top +
          (chartRect.height * i / gridLineCount);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        _gridPaint,
      );
    }
  }

  // ============================================================
  // 9.2.3 — Candlestick Drawing
  // ============================================================

  void _drawCandlesticks(Canvas canvas, Rect chartRect) {
    if (candles.isEmpty) return;

    final candleWidth = chartRect.width / candles.length;
    final gap = candleWidth * _candleGapRatio;
    final bodyWidth = (candleWidth - gap * 2).clamp(1.0, 24.0);

    for (int i = 0; i < candles.length; i++) {
      final candle = candles[i];
      final centerX = chartRect.left + candleWidth * i + candleWidth / 2;

      final openY = _priceToY(candle.open, chartRect);
      final closeY = _priceToY(candle.close, chartRect);
      final highY = _priceToY(candle.high, chartRect);
      final lowY = _priceToY(candle.low, chartRect);

      final isBull = candle.close >= candle.open;
      final bodyPaint = isBull ? _bullBodyPaint : _bearBodyPaint;
      final wickPaint = isBull ? _bullWickPaint : _bearWickPaint;

      // ── Wick (high-low line) ────────────────────────────
      canvas.drawLine(
        Offset(centerX, highY),
        Offset(centerX, lowY),
        wickPaint,
      );

      // ── Body (open-close rectangle) ─────────────────────
      final bodyTop = math.min(openY, closeY);
      final bodyBottom = math.max(openY, closeY);
      final bodyHeight = (bodyBottom - bodyTop).clamp(1.0, double.infinity);

      final bodyRect = Rect.fromLTWH(
        centerX - bodyWidth / 2,
        bodyTop,
        bodyWidth,
        bodyHeight,
      );

      // Fill
      canvas.drawRect(bodyRect, bodyPaint);

      // Border (thin outline for very small bodies)
      if (bodyHeight < 2) {
        canvas.drawRect(
          bodyRect,
          Paint()
            ..color = isBull ? AppTheme.chartBullCandle : AppTheme.chartBearCandle
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }
  }

  // ============================================================
  // 9.2.4 — Bar Chart Drawing
  // ============================================================

  void _drawBarChart(Canvas canvas, Rect chartRect) {
    final candleWidth = chartRect.width / candles.length;
    final halfBar = (candleWidth * 0.3).clamp(1.0, 8.0);

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final centerX = chartRect.left + candleWidth * i + candleWidth / 2;
      final isBull = c.close >= c.open;
      final paint = isBull ? _bullWickPaint : _bearWickPaint;

      // Main bar (high-low)
      canvas.drawLine(
        Offset(centerX, _priceToY(c.high, chartRect)),
        Offset(centerX, _priceToY(c.low, chartRect)),
        paint,
      );
      // Open tick (left)
      canvas.drawLine(
        Offset(centerX - halfBar, _priceToY(c.open, chartRect)),
        Offset(centerX, _priceToY(c.open, chartRect)),
        paint,
      );
      // Close tick (right)
      canvas.drawLine(
        Offset(centerX, _priceToY(c.close, chartRect)),
        Offset(centerX + halfBar, _priceToY(c.close, chartRect)),
        paint,
      );
    }
  }

  // ============================================================
  // 9.2.5 — Line Chart Drawing
  // ============================================================

  void _drawLineChart(Canvas canvas, Rect chartRect) {
    if (candles.length < 2) return;

    final candleWidth = chartRect.width / candles.length;
    final path = Path();

    for (int i = 0; i < candles.length; i++) {
      final x = chartRect.left + candleWidth * i + candleWidth / 2;
      final y = _priceToY(candles[i].close, chartRect);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, _linePaint);

    // Area fill under the line
    final fillPath = Path.from(path);
    fillPath.lineTo(
      chartRect.left + candleWidth * (candles.length - 1) + candleWidth / 2,
      chartRect.bottom,
    );
    fillPath.lineTo(
      chartRect.left + candleWidth / 2,
      chartRect.bottom,
    );
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryTeal.withValues(alpha: 0.25),
            AppTheme.primaryTeal.withValues(alpha: 0.0),
          ],
        ).createShader(chartRect)
        ..style = PaintingStyle.fill,
    );
  }

  // ============================================================
  // 9.2.6 — Current Price Line (dashed teal line)
  // ============================================================

  void _drawCurrentPriceLine(Canvas canvas, Rect chartRect) {
    if (currentPrice <= 0) return;
    final priceRange = priceHigh - priceLow;
    if (priceRange <= 0) return;
    if (currentPrice < priceLow || currentPrice > priceHigh) return;

    final y = _priceToY(currentPrice, chartRect);

    // Dashed line
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double x = chartRect.left;
    while (x < chartRect.right) {
      canvas.drawLine(
        Offset(x, y),
        Offset(math.min(x + dashWidth, chartRect.right), y),
        _currentPricePaint,
      );
      x += dashWidth + dashSpace;
    }
  }

  // ============================================================
  // 9.2.7 — Price Axis (Y-axis labels)
  // ============================================================

  void _drawPriceAxis(Canvas canvas, Size size, Rect chartRect) {
    const gridLineCount = 6;
    final priceRange = priceHigh - priceLow;
    if (priceRange <= 0) return;

    final axisX = chartRect.right + 4;

    for (int i = 0; i <= gridLineCount; i++) {
      final t = i / gridLineCount;
      final y = chartRect.top + chartRect.height * t;
      final price = priceHigh - priceRange * t;

      _drawPriceLabel(
        canvas,
        price.toStringAsFixed(displayPrecision),
        Offset(axisX, y - 6),
        color: AppTheme.textMuted,
      );
    }

    // Current price label (highlighted)
    if (currentPrice > priceLow && currentPrice < priceHigh) {
      final y = _priceToY(currentPrice, chartRect);
      _drawPriceBadge(
        canvas,
        currentPrice.toStringAsFixed(displayPrecision),
        Offset(axisX, y),
        color: AppTheme.primaryTeal,
        size: size,
      );
    }
  }

  void _drawPriceLabel(
    Canvas canvas,
    String text,
    Offset offset, {
    required Color color,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontFamily: 'JetBrainsMono',
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  void _drawPriceBadge(
    Canvas canvas,
    String text,
    Offset offset, {
    required Color color,
    required Size size,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.black,
          fontFamily: 'JetBrainsMono',
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    final badgeRect = Rect.fromLTWH(
      offset.dx - 2,
      offset.dy - tp.height / 2 - 2,
      tp.width + 4,
      tp.height + 4,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(badgeRect, const Radius.circular(2)),
      Paint()..color = color,
    );
    tp.paint(canvas, Offset(offset.dx - 2, offset.dy - tp.height / 2));
  }

  // ============================================================
  // 9.2.8 — Time Axis (X-axis labels)
  // ============================================================

  void _drawTimeAxis(Canvas canvas, Size size, Rect chartRect) {
    if (candles.isEmpty) return;

    final candleWidth = chartRect.width / candles.length;
    final labelEvery = _labelInterval(candleWidth);
    final fmt = _timeLabelFormat(timeframe);

    for (int i = 0; i < candles.length; i++) {
      if (i % labelEvery != 0) continue;
      final x = chartRect.left + candleWidth * i + candleWidth / 2;
      final time = candles[i].openTime.toLocal();
      final label = fmt.format(time);

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 9,
            color: AppTheme.textMuted,
            fontFamily: 'JetBrainsMono',
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(x - tp.width / 2,
            chartRect.bottom + (_timeAxisHeight - tp.height) / 2),
      );
    }
  }

  // ============================================================
  // 9.3 — Crosshair Drawing
  // ============================================================

  void _drawCrosshair(
    Canvas canvas,
    Size size,
    Rect chartRect,
    Offset position,
  ) {
    // Clamp to chart area
    final x = position.dx.clamp(chartRect.left, chartRect.right);
    final y = position.dy.clamp(chartRect.top, chartRect.bottom);

    // Vertical line
    canvas.drawLine(
      Offset(x, chartRect.top),
      Offset(x, chartRect.bottom),
      _crosshairPaint,
    );

    // Horizontal line
    canvas.drawLine(
      Offset(chartRect.left, y),
      Offset(chartRect.right, y),
      _crosshairPaint,
    );

    // Price label at crosshair Y
    final price = _yToPrice(y, chartRect);
    _drawPriceBadge(
      canvas,
      price.toStringAsFixed(displayPrecision),
      Offset(chartRect.right + 4, y),
      color: AppTheme.chartCrosshair,
      size: size,
    );
  }

  // ============================================================
  // 9.2.9 — Coordinate Helpers
  // ============================================================

  double _priceToY(double price, Rect chartRect) {
    final priceRange = priceHigh - priceLow;
    if (priceRange <= 0) return chartRect.center.dy;
    final t = (priceHigh - price) / priceRange;
    return chartRect.top + chartRect.height * t;
  }

  double _yToPrice(double y, Rect chartRect) {
    final t = (y - chartRect.top) / chartRect.height;
    return priceHigh - (priceHigh - priceLow) * t;
  }

  int _labelInterval(double candleWidth) {
    if (candleWidth >= 20) return 5;
    if (candleWidth >= 10) return 10;
    if (candleWidth >= 5) return 20;
    return 30;
  }

  DateFormat _timeLabelFormat(Timeframe tf) {
    return switch (tf) {
      Timeframe.m1 || Timeframe.m5 || Timeframe.m15 ||
      Timeframe.m30 => DateFormat('HH:mm'),
      Timeframe.h1 || Timeframe.h4 => DateFormat('MM/dd HH:mm'),
      Timeframe.d1 || Timeframe.w1 => DateFormat('MM/dd'),
      _ => DateFormat('yyyy/MM'),
    };
  }

  // ============================================================
  // 9.2.10 — Repaint Optimization
  // ============================================================

  @override
  bool shouldRepaint(CandlestickPainter old) {
    return old.candles != candles ||
        old.priceHigh != priceHigh ||
        old.priceLow != priceLow ||
        old.crosshair.position != crosshair.position ||
        old.crosshair.isActive != crosshair.isActive ||
        old.chartType != chartType ||
        old.currentPrice != currentPrice;
  }
}
