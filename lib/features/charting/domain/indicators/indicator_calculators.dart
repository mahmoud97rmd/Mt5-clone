// Path: lib/features/charting/domain/indicators/indicator_calculators.dart
// ============================================================
// MT5 Clone — Indicator Calculators
// Pure computation functions for all technical indicators.
// No side effects, no external dependencies.
// ============================================================

import 'dart:ui';

import '../../../../core/domain/entities/candle_entity.dart';
import 'indicator_models.dart';

class IndicatorCalculators {
  IndicatorCalculators._();

  // ============================================================
  // Simple Moving Average (SMA)
  // ============================================================

  static IndicatorSeries calculateSMA({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final period = config.params['period'] as int? ?? 20;
    final points = <IndicatorPoint>[];

    for (int i = period - 1; i < candles.length; i++) {
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += candles[j].close;
      }
      points.add(IndicatorPoint(
        time: candles[i].openTime,
        value: sum / period,
      ));
    }

    return IndicatorSeries(
      config: config,
      lines: [points],
      lineLabels: ['SMA($period)'],
      lineColors: [config.color],
    );
  }

  // ============================================================
  // Exponential Moving Average (EMA)
  // ============================================================

  static IndicatorSeries calculateEMA({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final period = config.params['period'] as int? ?? 20;
    final points = <IndicatorPoint>[];

    if (candles.length < period) {
      return IndicatorSeries(
        config: config,
        lines: [points],
        lineLabels: ['EMA($period)'],
        lineColors: [config.color],
      );
    }

    // Initial SMA for seed
    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += candles[i].close;
    }
    double ema = sum / period;
    points.add(IndicatorPoint(time: candles[period - 1].openTime, value: ema));

    // EMA multiplier
    final multiplier = 2.0 / (period + 1);

    for (int i = period; i < candles.length; i++) {
      ema = (candles[i].close - ema) * multiplier + ema;
      points.add(IndicatorPoint(time: candles[i].openTime, value: ema));
    }

    return IndicatorSeries(
      config: config,
      lines: [points],
      lineLabels: ['EMA($period)'],
      lineColors: [config.color],
    );
  }

  // ============================================================
  // Weighted Moving Average (WMA)
  // ============================================================

  static IndicatorSeries calculateWMA({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final period = config.params['period'] as int? ?? 20;
    final points = <IndicatorPoint>[];

    final weightSum = period * (period + 1) / 2;

    for (int i = period - 1; i < candles.length; i++) {
      double weightedSum = 0;
      for (int j = 0; j < period; j++) {
        weightedSum += candles[i - j].close * (period - j);
      }
      points.add(IndicatorPoint(
        time: candles[i].openTime,
        value: weightedSum / weightSum,
      ));
    }

    return IndicatorSeries(
      config: config,
      lines: [points],
      lineLabels: ['WMA($period)'],
      lineColors: [config.color],
    );
  }

  // ============================================================
  // Bollinger Bands
  // ============================================================

  static IndicatorSeries calculateBollingerBands({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final period = config.params['period'] as int? ?? 20;
    final stdDevMultiplier = config.params['stdDev'] as double? ?? 2.0;

    final middlePoints = <IndicatorPoint>[];
    final upperPoints = <IndicatorPoint>[];
    final lowerPoints = <IndicatorPoint>[];

    for (int i = period - 1; i < candles.length; i++) {
      // Calculate SMA
      double sum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        sum += candles[j].close;
      }
      final sma = sum / period;

      // Calculate standard deviation
      double varianceSum = 0;
      for (int j = i - period + 1; j <= i; j++) {
        final diff = candles[j].close - sma;
        varianceSum += diff * diff;
      }
      final stdDev = (varianceSum / period).sqrt();

      middlePoints.add(IndicatorPoint(time: candles[i].openTime, value: sma));
      upperPoints.add(IndicatorPoint(
        time: candles[i].openTime,
        value: sma + stdDev * stdDevMultiplier,
      ));
      lowerPoints.add(IndicatorPoint(
        time: candles[i].openTime,
        value: sma - stdDev * stdDevMultiplier,
      ));
    }

    return IndicatorSeries(
      config: config,
      lines: [upperPoints, middlePoints, lowerPoints],
      lineLabels: ['Upper', 'BB($period)', 'Lower'],
      lineColors: [
        config.color.withValues(alpha: 0.6),
        config.color,
        config.color.withValues(alpha: 0.6),
      ],
    );
  }

  // ============================================================
  // RSI (Relative Strength Index)
  // ============================================================

  static IndicatorSeries calculateRSI({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final period = config.params['period'] as int? ?? 14;
    final overbought = config.params['overbought'] as double? ?? 70;
    final oversold = config.params['oversold'] as double? ?? 30;
    final points = <IndicatorPoint>[];

    if (candles.length < period + 1) {
      return IndicatorSeries(
        config: config,
        lines: [points],
        lineLabels: ['RSI($period)'],
        lineColors: [config.color],
        subChartMin: 0,
        subChartMax: 100,
        levels: [
          SubChartLevel(value: overbought, color: const Color(0xFFFF4757)),
          SubChartLevel(value: 50, color: const Color(0xFF30363D)),
          SubChartLevel(value: oversold, color: const Color(0xFF00C853)),
        ],
      );
    }

    // Calculate initial gains and losses
    double avgGain = 0;
    double avgLoss = 0;
    for (int i = 1; i <= period; i++) {
      final change = candles[i].close - candles[i - 1].close;
      if (change > 0) {
        avgGain += change;
      } else {
        avgLoss += change.abs();
      }
    }
    avgGain /= period;
    avgLoss /= period;

    // First RSI value
    final rs = avgLoss > 0 ? avgGain / avgLoss : 100;
    final rsi = 100 - (100 / (1 + rs));
    points.add(IndicatorPoint(time: candles[period].openTime, value: rsi));

    // Subsequent RSI values using smoothed averages
    for (int i = period + 1; i < candles.length; i++) {
      final change = candles[i].close - candles[i - 1].close;
      final gain = change > 0 ? change : 0;
      final loss = change < 0 ? change.abs() : 0;

      avgGain = (avgGain * (period - 1) + gain) / period;
      avgLoss = (avgLoss * (period - 1) + loss) / period;

      final currentRs = avgLoss > 0 ? avgGain / avgLoss : 100;
      final currentRsi = 100 - (100 / (1 + currentRs));
      points.add(IndicatorPoint(
        time: candles[i].openTime,
        value: currentRsi,
      ));
    }

    return IndicatorSeries(
      config: config,
      lines: [points],
      lineLabels: ['RSI($period)'],
      lineColors: [config.color],
      subChartMin: 0,
      subChartMax: 100,
      levels: [
        SubChartLevel(value: overbought, color: const Color(0xFFFF4757)),
        SubChartLevel(value: 50, color: const Color(0xFF30363D)),
        SubChartLevel(value: oversold, color: const Color(0xFF00C853)),
      ],
    );
  }

  // ============================================================
  // MACD (Moving Average Convergence Divergence)
  // ============================================================

  static IndicatorSeries calculateMACD({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final fastPeriod = config.params['fast'] as int? ?? 12;
    final slowPeriod = config.params['slow'] as int? ?? 26;
    final signalPeriod = config.params['signal'] as int? ?? 9;

    if (candles.length < slowPeriod + signalPeriod) {
      return IndicatorSeries(
        config: config,
        lines: [[], [], []],
        lineLabels: ['MACD', 'Signal', 'Histogram'],
        lineColors: [config.color, const Color(0xFFFFC107), const Color(0xFF00C853)],
      );
    }

    // Calculate fast EMA
    final fastEma = _emaValues(candles, fastPeriod);
    // Calculate slow EMA
    final slowEma = _emaValues(candles, slowPeriod);

    // MACD line = fast EMA - slow EMA
    final macdPoints = <IndicatorPoint>[];
    final slowStart = slowPeriod - 1;
    for (int i = 0; i < slowEma.length; i++) {
      final fastIdx = slowStart + i;
      if (fastIdx < fastEma.length) {
        macdPoints.add(IndicatorPoint(
          time: candles[slowStart + i].openTime,
          value: fastEma[fastIdx] - slowEma[i],
        ));
      }
    }

    // Signal line = EMA of MACD line
    final signalPoints = <IndicatorPoint>[];
    if (macdPoints.length >= signalPeriod) {
      double sum = 0;
      for (int i = 0; i < signalPeriod; i++) {
        sum += macdPoints[i].value;
      }
      double ema = sum / signalPeriod;
      signalPoints.add(IndicatorPoint(
        time: macdPoints[signalPeriod - 1].time,
        value: ema,
      ));

      final multiplier = 2.0 / (signalPeriod + 1);
      for (int i = signalPeriod; i < macdPoints.length; i++) {
        ema = (macdPoints[i].value - ema) * multiplier + ema;
        signalPoints.add(IndicatorPoint(
          time: macdPoints[i].time,
          value: ema,
        ));
      }
    }

    // Histogram = MACD - Signal
    final histogramPoints = <IndicatorPoint>[];
    final signalMap = <DateTime, double>{};
    for (final p in signalPoints) {
      signalMap[p.time] = p.value;
    }
    for (final p in macdPoints) {
      final signalVal = signalMap[p.time];
      if (signalVal != null) {
        histogramPoints.add(IndicatorPoint(
          time: p.time,
          value: p.value - signalVal,
        ));
      }
    }

    return IndicatorSeries(
      config: config,
      lines: [macdPoints, signalPoints, histogramPoints],
      lineLabels: ['MACD', 'Signal', 'Histogram'],
      lineColors: [config.color, const Color(0xFFFFC107), const Color(0xFF00C853)],
    );
  }

  // ============================================================
  // Stochastic Oscillator
  // ============================================================

  static IndicatorSeries calculateStochastic({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final kPeriod = config.params['kPeriod'] as int? ?? 14;
    final dPeriod = config.params['dPeriod'] as int? ?? 3;
    final slowing = config.params['slowing'] as int? ?? 3;

    final kPoints = <IndicatorPoint>[];
    final dPoints = <IndicatorPoint>[];

    if (candles.length < kPeriod + slowing - 1) {
      return IndicatorSeries(
        config: config,
        lines: [kPoints, dPoints],
        lineLabels: ['%K', '%D'],
        lineColors: [config.color, const Color(0xFFFFC107)],
        subChartMin: 0,
        subChartMax: 100,
        levels: [
          SubChartLevel(value: 80, color: const Color(0xFFFF4757)),
          SubChartLevel(value: 20, color: const Color(0xFF00C853)),
        ],
      );
    }

    // Calculate raw %K values
    final rawKValues = <double>[];
    for (int i = kPeriod - 1; i < candles.length; i++) {
      double highest = candles[i - kPeriod + 1].high;
      double lowest = candles[i - kPeriod + 1].low;
      for (int j = i - kPeriod + 1; j <= i; j++) {
        if (candles[j].high > highest) highest = candles[j].high;
        if (candles[j].low < lowest) lowest = candles[j].low;
      }
      final range = highest - lowest;
      final k = range > 0
          ? ((candles[i].close - lowest) / range) * 100
          : 50;
      rawKValues.add(k.toDouble());
    }

    // Apply slowing (SMA of raw %K)
    for (int i = slowing - 1; i < rawKValues.length; i++) {
      double sum = 0;
      for (int j = i - slowing + 1; j <= i; j++) {
        sum += rawKValues[j];
      }
      final k = sum / slowing;
      final candleIdx = kPeriod - 1 + i;
      kPoints.add(IndicatorPoint(
        time: candles[candleIdx].openTime,
        value: k,
      ));
    }

    // %D = SMA of %K
    if (kPoints.length >= dPeriod) {
      for (int i = dPeriod - 1; i < kPoints.length; i++) {
        double sum = 0;
        for (int j = i - dPeriod + 1; j <= i; j++) {
          sum += kPoints[j].value;
        }
        dPoints.add(IndicatorPoint(
          time: kPoints[i].time,
          value: sum / dPeriod,
        ));
      }
    }

    return IndicatorSeries(
      config: config,
      lines: [kPoints, dPoints],
      lineLabels: ['%K', '%D'],
      lineColors: [config.color, const Color(0xFFFFC107)],
      subChartMin: 0,
      subChartMax: 100,
      levels: [
        SubChartLevel(value: 80, color: const Color(0xFFFF4757)),
        SubChartLevel(value: 20, color: const Color(0xFF00C853)),
      ],
    );
  }

  // ============================================================
  // ATR (Average True Range)
  // ============================================================

  static IndicatorSeries calculateATR({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final period = config.params['period'] as int? ?? 14;
    final points = <IndicatorPoint>[];

    if (candles.length < period + 1) {
      return IndicatorSeries(
        config: config,
        lines: [points],
        lineLabels: ['ATR($period)'],
        lineColors: [config.color],
      );
    }

    // Calculate true ranges
    final trueRanges = <double>[];
    for (int i = 1; i < candles.length; i++) {
      final high = candles[i].high;
      final low = candles[i].low;
      final prevClose = candles[i - 1].close;
      final tr = [
        high - low,
        (high - prevClose).abs(),
        (low - prevClose).abs(),
      ].reduce((a, b) => a > b ? a : b);
      trueRanges.add(tr);
    }

    // Initial ATR = average of first `period` true ranges
    double atr = 0;
    for (int i = 0; i < period; i++) {
      atr += trueRanges[i];
    }
    atr /= period;
    points.add(IndicatorPoint(time: candles[period].openTime, value: atr));

    // Subsequent ATR values (smoothed)
    for (int i = period; i < trueRanges.length; i++) {
      atr = (atr * (period - 1) + trueRanges[i]) / period;
      points.add(IndicatorPoint(
        time: candles[i + 1].openTime,
        value: atr,
      ));
    }

    return IndicatorSeries(
      config: config,
      lines: [points],
      lineLabels: ['ATR($period)'],
      lineColors: [config.color],
    );
  }

  // ============================================================
  // Ichimoku Cloud
  // ============================================================

  static IndicatorSeries calculateIchimoku({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    final tenkanPeriod = config.params['tenkan'] as int? ?? 9;
    final kijunPeriod = config.params['kijun'] as int? ?? 26;
    final senkouPeriod = config.params['senkou'] as int? ?? 52;
    final displacement = config.params['displacement'] as int? ?? 26;

    final tenkanPoints = <IndicatorPoint>[];
    final kijunPoints = <IndicatorPoint>[];
    final senkouAPoints = <IndicatorPoint>[];
    final senkouBPoints = <IndicatorPoint>[];
    final chikouPoints = <IndicatorPoint>[];

    // Tenkan-sen (Conversion Line) = (highest high + lowest low) / 2 for tenkanPeriod
    for (int i = tenkanPeriod - 1; i < candles.length; i++) {
      double highest = candles[i - tenkanPeriod + 1].high;
      double lowest = candles[i - tenkanPeriod + 1].low;
      for (int j = i - tenkanPeriod + 1; j <= i; j++) {
        if (candles[j].high > highest) highest = candles[j].high;
        if (candles[j].low < lowest) lowest = candles[j].low;
      }
      tenkanPoints.add(IndicatorPoint(
        time: candles[i].openTime,
        value: (highest + lowest) / 2,
      ));
    }

    // Kijun-sen (Base Line) = (highest high + lowest low) / 2 for kijunPeriod
    for (int i = kijunPeriod - 1; i < candles.length; i++) {
      double highest = candles[i - kijunPeriod + 1].high;
      double lowest = candles[i - kijunPeriod + 1].low;
      for (int j = i - kijunPeriod + 1; j <= i; j++) {
        if (candles[j].high > highest) highest = candles[j].high;
        if (candles[j].low < lowest) lowest = candles[j].low;
      }
      kijunPoints.add(IndicatorPoint(
        time: candles[i].openTime,
        value: (highest + lowest) / 2,
      ));
    }

    // Senkou Span A = (Tenkan + Kijun) / 2, displaced forward
    final tenkanMap = <DateTime, double>{};
    for (final p in tenkanPoints) {
      tenkanMap[p.time] = p.value;
    }
    final kijunMap = <DateTime, double>{};
    for (final p in kijunPoints) {
      kijunMap[p.time] = p.value;
    }

    for (int i = 0; i < candles.length; i++) {
      final tenkan = tenkanMap[candles[i].openTime];
      final kijun = kijunMap[candles[i].openTime];
      if (tenkan != null && kijun != null) {
        final displacedIdx = i + displacement;
        if (displacedIdx < candles.length) {
          senkouAPoints.add(IndicatorPoint(
            time: candles[displacedIdx].openTime,
            value: (tenkan + kijun) / 2,
          ));
        }
      }
    }

    // Senkou Span B = (highest high + lowest low) / 2 for senkouPeriod, displaced forward
    for (int i = senkouPeriod - 1; i < candles.length; i++) {
      double highest = candles[i - senkouPeriod + 1].high;
      double lowest = candles[i - senkouPeriod + 1].low;
      for (int j = i - senkouPeriod + 1; j <= i; j++) {
        if (candles[j].high > highest) highest = candles[j].high;
        if (candles[j].low < lowest) lowest = candles[j].low;
      }
      final displacedIdx = i + displacement;
      if (displacedIdx < candles.length) {
        senkouBPoints.add(IndicatorPoint(
          time: candles[displacedIdx].openTime,
          value: (highest + lowest) / 2,
        ));
      }
    }

    // Chikou Span = close price, displaced backward
    for (int i = displacement; i < candles.length; i++) {
      chikouPoints.add(IndicatorPoint(
        time: candles[i - displacement].openTime,
        value: candles[i].close,
      ));
    }

    return IndicatorSeries(
      config: config,
      lines: [tenkanPoints, kijunPoints, senkouAPoints, senkouBPoints, chikouPoints],
      lineLabels: ['Tenkan', 'Kijun', 'Senkou A', 'Senkou B', 'Chikou'],
      lineColors: [
        const Color(0xFF00D4AA),   // Tenkan (teal)
        const Color(0xFFFF4757),   // Kijun (red)
        const Color(0xFF00C853),   // Senkou A (green)
        const Color(0xFFFFC107),   // Senkou B (amber)
        const Color(0xFF7D8590),   // Chikou (muted)
      ],
    );
  }

  // ============================================================
  // Compute all active indicators
  // ============================================================

  static List<IndicatorSeries> computeAll({
    required List<CandleEntity> candles,
    required List<IndicatorConfig> configs,
  }) {
    return configs
        .where((c) => c.isVisible)
        .map((config) => computeOne(candles: candles, config: config))
        .where((s) => !s.isEmpty)
        .toList();
  }

  static IndicatorSeries computeOne({
    required List<CandleEntity> candles,
    required IndicatorConfig config,
  }) {
    return switch (config.type) {
      IndicatorType.sma => calculateSMA(candles: candles, config: config),
      IndicatorType.ema => calculateEMA(candles: candles, config: config),
      IndicatorType.wma => calculateWMA(candles: candles, config: config),
      IndicatorType.bollingerBands => calculateBollingerBands(candles: candles, config: config),
      IndicatorType.ichimoku => calculateIchimoku(candles: candles, config: config),
      IndicatorType.rsi => calculateRSI(candles: candles, config: config),
      IndicatorType.macd => calculateMACD(candles: candles, config: config),
      IndicatorType.stochastic => calculateStochastic(candles: candles, config: config),
      IndicatorType.atr => calculateATR(candles: candles, config: config),
    };
  }

  // ============================================================
  // Helper: EMA values
  // ============================================================

  static List<double> _emaValues(List<CandleEntity> candles, int period) {
    if (candles.length < period) return [];

    double sum = 0;
    for (int i = 0; i < period; i++) {
      sum += candles[i].close;
    }
    double ema = sum / period;
    final values = <double>[ema];

    final multiplier = 2.0 / (period + 1);
    for (int i = period; i < candles.length; i++) {
      ema = (candles[i].close - ema) * multiplier + ema;
      values.add(ema);
    }

    return values;
  }
}

// ============================================================
// sqrt extension for double
// ============================================================

extension _DoubleSqrt on double {
  double sqrt() {
    if (this < 0) return 0;
    double guess = this / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + this / guess) / 2;
    }
    return guess;
  }
}
