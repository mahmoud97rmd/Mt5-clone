// Path: lib/core/domain/entities/candle_entity.dart
// ============================================================
// MT5 Clone — Candle Domain Entity
// Represents a single OHLCV candle for charting.
// ============================================================

import 'package:equatable/equatable.dart';

class CandleEntity extends Equatable {
  final String symbol;
  final String timeframe;
  final DateTime openTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final bool isComplete;

  const CandleEntity({
    required this.symbol,
    required this.timeframe,
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume = 0,
    this.isComplete = true,
  });

  bool get isBull => close >= open;
  bool get isBear => close < open;
  double get bodySize => (close - open).abs();
  double get wickSize => high - low;
  double get changePercent =>
      open > 0 ? ((close - open) / open) * 100 : 0;

  CandleEntity copyWith({
    String? symbol,
    String? timeframe,
    DateTime? openTime,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
    bool? isComplete,
  }) {
    return CandleEntity(
      symbol: symbol ?? this.symbol,
      timeframe: timeframe ?? this.timeframe,
      openTime: openTime ?? this.openTime,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [symbol, timeframe, openTime, open, high, low, close];
}
