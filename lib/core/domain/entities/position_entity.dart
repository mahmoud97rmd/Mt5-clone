// Path: lib/core/domain/entities/position_entity.dart
// ============================================================
// MT5 Clone — Position Domain Entity
// Represents a single open trading position.
// The PnL and status are recalculated from domain state,
// NOT stored as mutable fields — they derive from price.
// ============================================================

import 'package:equatable/equatable.dart';

import '../enums/trading_enums.dart';

class PositionEntity extends Equatable {
  // ── Identity ──────────────────────────────────────────────
  final String oandaTradeId;
  final String symbol;

  // ── Trade Details ──────────────────────────────────────────
  final TradeDirection direction;
  final double lots;
  final double units;
  final double openPrice;
  final double currentPrice;

  // ── Risk Management ────────────────────────────────────────
  final double? stopLoss;
  final double? takeProfit;

  // ── Financials ─────────────────────────────────────────────
  final double floatingPnl;
  final double swap;
  final double commission;
  final double marginUsed;

  // ── Metadata ───────────────────────────────────────────────
  final DateTime openTime;
  final int magicNumber;
  final String comment;

  const PositionEntity({
    required this.oandaTradeId,
    required this.symbol,
    required this.direction,
    required this.lots,
    required this.units,
    required this.openPrice,
    required this.currentPrice,
    this.stopLoss,
    this.takeProfit,
    required this.floatingPnl,
    this.swap = 0.0,
    this.commission = 0.0,
    required this.marginUsed,
    required this.openTime,
    this.magicNumber = 0,
    this.comment = '',
  });

  // ── Derived Properties ─────────────────────────────────────

  /// Net floating PnL (includes swap charges)
  double get netFloatingPnl => floatingPnl + swap - commission;

  /// Total profit/loss including all costs
  double get totalPnl => netFloatingPnl;

  /// Whether the position is currently in profit
  bool get isProfit => floatingPnl > 0;

  /// Whether the position has a Stop Loss set
  bool get hasStopLoss => stopLoss != null;

  /// Whether the position has a Take Profit set
  bool get hasTakeProfit => takeProfit != null;

  /// Price distance from open to current (in price units)
  double get priceDistance {
    return direction.isBuy
        ? currentPrice - openPrice
        : openPrice - currentPrice;
  }

  /// Whether this position was opened by an EA (magic != 0)
  bool get isEaPosition => magicNumber != 0;

  /// How long the position has been open
  Duration get holdingDuration => DateTime.now().difference(openTime);

  /// Color coding for PnL display
  bool get isPnlPositive => floatingPnl >= 0;

  // ── Update (creates new immutable instance with updated price) ──

  PositionEntity withUpdatedPrice({
    required double newCurrentPrice,
    required double newFloatingPnl,
    required double newMarginUsed,
  }) {
    return PositionEntity(
      oandaTradeId: oandaTradeId,
      symbol: symbol,
      direction: direction,
      lots: lots,
      units: units,
      openPrice: openPrice,
      currentPrice: newCurrentPrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      floatingPnl: newFloatingPnl,
      swap: swap,
      commission: commission,
      marginUsed: newMarginUsed,
      openTime: openTime,
      magicNumber: magicNumber,
      comment: comment,
    );
  }

  PositionEntity withModifiedSlTp({
    double? newStopLoss,
    double? newTakeProfit,
  }) {
    return PositionEntity(
      oandaTradeId: oandaTradeId,
      symbol: symbol,
      direction: direction,
      lots: lots,
      units: units,
      openPrice: openPrice,
      currentPrice: currentPrice,
      stopLoss: newStopLoss,
      takeProfit: newTakeProfit,
      floatingPnl: floatingPnl,
      swap: swap,
      commission: commission,
      marginUsed: marginUsed,
      openTime: openTime,
      magicNumber: magicNumber,
      comment: comment,
    );
  }

  @override
  List<Object?> get props => [oandaTradeId, currentPrice, floatingPnl, stopLoss, takeProfit];

  @override
  String toString() =>
      'Position($oandaTradeId ${direction.displayName} $lots lots $symbol '
      '@ $openPrice → $currentPrice PnL=${floatingPnl.toStringAsFixed(2)})';
}
