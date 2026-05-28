// Path: lib/core/domain/entities/tick_entity.dart
// ============================================================
// MT5 Clone — Tick Domain Entity
// Represents a single price update (bid/ask) for an instrument.
// ============================================================

import 'package:equatable/equatable.dart';

class TickEntity extends Equatable {
  final String symbol;
  final double bid;
  final double ask;
  final double spread;
  final DateTime timestamp;
  final double? sessionHigh;
  final double? sessionLow;

  const TickEntity({
    required this.symbol,
    required this.bid,
    required this.ask,
    required this.spread,
    required this.timestamp,
    this.sessionHigh,
    this.sessionLow,
  });

  double get mid => (bid + ask) / 2.0;
  double get spreadPips => spread;

  TickEntity copyWith({
    String? symbol,
    double? bid,
    double? ask,
    double? spread,
    DateTime? timestamp,
    double? sessionHigh,
    double? sessionLow,
  }) {
    return TickEntity(
      symbol: symbol ?? this.symbol,
      bid: bid ?? this.bid,
      ask: ask ?? this.ask,
      spread: spread ?? this.spread,
      timestamp: timestamp ?? this.timestamp,
      sessionHigh: sessionHigh ?? this.sessionHigh,
      sessionLow: sessionLow ?? this.sessionLow,
    );
  }

  @override
  List<Object?> get props => [symbol, bid, ask, timestamp];
}
