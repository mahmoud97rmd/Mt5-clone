// Path: lib/features/charting/domain/indicators/indicator_models.dart
// ============================================================
// MT5 Clone — Indicator Models
// Configuration and data models for all technical indicators.
// ============================================================

import 'dart:ui';

import '../../../../core/domain/entities/candle_entity.dart';

// ============================================================
// Indicator Type Enum
// ============================================================

enum IndicatorType {
  sma,
  ema,
  wma,
  bollingerBands,
  ichimoku,
  rsi,
  macd,
  stochastic,
  atr;

  String get displayName => switch (this) {
        IndicatorType.sma => 'SMA',
        IndicatorType.ema => 'EMA',
        IndicatorType.wma => 'WMA',
        IndicatorType.bollingerBands => 'Bollinger Bands',
        IndicatorType.ichimoku => 'Ichimoku Cloud',
        IndicatorType.rsi => 'RSI',
        IndicatorType.macd => 'MACD',
        IndicatorType.stochastic => 'Stochastic',
        IndicatorType.atr => 'ATR',
      };

  bool get isOnChart => switch (this) {
        IndicatorType.sma => true,
        IndicatorType.ema => true,
        IndicatorType.wma => true,
        IndicatorType.bollingerBands => true,
        IndicatorType.ichimoku => true,
        IndicatorType.rsi => false,
        IndicatorType.macd => false,
        IndicatorType.stochastic => false,
        IndicatorType.atr => false,
      };

  String get locationLabel => isOnChart ? 'On Chart' : 'Sub-Chart';
}

// ============================================================
// Indicator Configuration
// ============================================================

class IndicatorConfig {
  final String id;
  final IndicatorType type;
  final bool isVisible;
  final Color color;
  final double lineWidth;
  final Map<String, dynamic> params;

  const IndicatorConfig({
    required this.id,
    required this.type,
    this.isVisible = true,
    required this.color,
    this.lineWidth = 1.5,
    this.params = const {},
  });

  IndicatorConfig copyWith({
    String? id,
    IndicatorType? type,
    bool? isVisible,
    Color? color,
    double? lineWidth,
    Map<String, dynamic>? params,
  }) {
    return IndicatorConfig(
      id: id ?? this.id,
      type: type ?? this.type,
      isVisible: isVisible ?? this.isVisible,
      color: color ?? this.color,
      lineWidth: lineWidth ?? this.lineWidth,
      params: params ?? this.params,
    );
  }

  // Default configs for each indicator type
  factory IndicatorConfig.sma({
    String? id,
    int period = 20,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'sma_$period',
      type: IndicatorType.sma,
      color: color ?? const Color(0xFF00D4AA),
      params: {'period': period},
    );
  }

  factory IndicatorConfig.ema({
    String? id,
    int period = 20,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'ema_$period',
      type: IndicatorType.ema,
      color: color ?? const Color(0xFFFFC107),
      params: {'period': period},
    );
  }

  factory IndicatorConfig.wma({
    String? id,
    int period = 20,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'wma_$period',
      type: IndicatorType.wma,
      color: color ?? const Color(0xFF9C27B0),
      params: {'period': period},
    );
  }

  factory IndicatorConfig.bollingerBands({
    String? id,
    int period = 20,
    double stdDev = 2.0,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'bb_${period}_$stdDev',
      type: IndicatorType.bollingerBands,
      color: color ?? const Color(0xFF4D9FFF),
      params: {'period': period, 'stdDev': stdDev},
    );
  }

  factory IndicatorConfig.ichimoku({
    String? id,
    int tenkan = 9,
    int kijun = 26,
    int senkou = 52,
    int displacement = 26,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'ichimoku',
      type: IndicatorType.ichimoku,
      color: color ?? const Color(0xFF00D4AA),
      params: {
        'tenkan': tenkan,
        'kijun': kijun,
        'senkou': senkou,
        'displacement': displacement,
      },
    );
  }

  factory IndicatorConfig.rsi({
    String? id,
    int period = 14,
    double overbought = 70,
    double oversold = 30,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'rsi_$period',
      type: IndicatorType.rsi,
      color: color ?? const Color(0xFF00D4AA),
      params: {
        'period': period,
        'overbought': overbought,
        'oversold': oversold,
      },
    );
  }

  factory IndicatorConfig.macd({
    String? id,
    int fast = 12,
    int slow = 26,
    int signal = 9,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'macd_${fast}_$slow',
      type: IndicatorType.macd,
      color: color ?? const Color(0xFF4D9FFF),
      params: {'fast': fast, 'slow': slow, 'signal': signal},
    );
  }

  factory IndicatorConfig.stochastic({
    String? id,
    int kPeriod = 14,
    int dPeriod = 3,
    int slowing = 3,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'stoch_${kPeriod}_$dPeriod',
      type: IndicatorType.stochastic,
      color: color ?? const Color(0xFF4D9FFF),
      params: {'kPeriod': kPeriod, 'dPeriod': dPeriod, 'slowing': slowing},
    );
  }

  factory IndicatorConfig.atr({
    String? id,
    int period = 14,
    Color? color,
  }) {
    return IndicatorConfig(
      id: id ?? 'atr_$period',
      type: IndicatorType.atr,
      color: color ?? const Color(0xFFFFC107),
      params: {'period': period},
    );
  }
}

// ============================================================
// Indicator Series (computed data)
// ============================================================

/// A single data point on an indicator line.
class IndicatorPoint {
  final DateTime time;
  final double value;

  const IndicatorPoint({required this.time, required this.value});
}

/// A complete indicator series (one or more lines).
class IndicatorSeries {
  final IndicatorConfig config;
  final List<List<IndicatorPoint>> lines;
  final List<String> lineLabels;
  final List<Color> lineColors;

  /// For sub-chart indicators (RSI, MACD, Stochastic, ATR)
  final double? subChartMin;
  final double? subChartMax;
  final List<SubChartLevel>? levels;

  const IndicatorSeries({
    required this.config,
    required this.lines,
    this.lineLabels = const [],
    this.lineColors = const [],
    this.subChartMin,
    this.subChartMax,
    this.levels,
  });

  bool get isEmpty => lines.isEmpty || lines.every((l) => l.isEmpty);
  bool get isSubChart => !config.type.isOnChart;
}

/// A horizontal reference level on a sub-chart (e.g., RSI 70/30).
class SubChartLevel {
  final double value;
  final Color color;
  final bool isDashed;

  const SubChartLevel({
    required this.value,
    required this.color,
    this.isDashed = true,
  });
}

/// Fill area between two indicator lines (e.g., Bollinger Bands, Ichimoku cloud).
class IndicatorFill {
  final List<IndicatorPoint> upperLine;
  final List<IndicatorPoint> lowerLine;
  final Color color;

  const IndicatorFill({
    required this.upperLine,
    required this.lowerLine,
    required this.color,
  });
}
