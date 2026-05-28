// Path: lib/core/domain/entities/closed_trade_entity.dart
// ============================================================
// MT5 Clone — Closed Trade Domain Entity
// Represents a completed (closed) trade in history.
// ============================================================

import 'package:drift/drift.dart' show Value;
import 'package:equatable/equatable.dart';

import '../../database/app_database.dart';
import '../enums/trading_enums.dart';

class ClosedTradeEntity extends Equatable {
  final String oandaTradeId;
  final String symbol;
  final TradeDirection direction;
  final double lots;
  final double units;
  final double openPrice;
  final double closePrice;
  final DateTime openTime;
  final DateTime closeTime;
  final double realizedPnl;
  final double swap;
  final double commission;
  final double netPnl;
  final CloseReason closeReason;
  final int magicNumber;
  final String comment;
  final double maxProfit;
  final double maxDrawdown;

  const ClosedTradeEntity({
    required this.oandaTradeId,
    required this.symbol,
    required this.direction,
    required this.lots,
    required this.units,
    required this.openPrice,
    required this.closePrice,
    required this.openTime,
    required this.closeTime,
    required this.realizedPnl,
    this.swap = 0.0,
    this.commission = 0.0,
    required this.netPnl,
    this.closeReason = CloseReason.manual,
    this.magicNumber = 0,
    this.comment = '',
    this.maxProfit = 0.0,
    this.maxDrawdown = 0.0,
  });

  bool get isProfit => netPnl >= 0;
  Duration get duration => closeTime.difference(openTime);
  bool get isEaTrade => magicNumber != 0;

  String get durationDisplay {
    final d = duration;
    if (d.inDays > 0) return '${d.inDays}d ${d.inHours % 24}h';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    return '${d.inMinutes}m ${d.inSeconds % 60}s';
  }

  /// Convert this domain entity to a Drift companion for database insertion.
  ClosedTradesCompanion toCompanion() {
    final openTimeUs = openTime.microsecondsSinceEpoch;
    final closeTimeUs = closeTime.microsecondsSinceEpoch;
    final closeDateStr =
        '${closeTime.year.toString().padLeft(4, '0')}-'
        '${closeTime.month.toString().padLeft(2, '0')}-'
        '${closeTime.day.toString().padLeft(2, '0')}';

    return ClosedTradesCompanion.insert(
      oandaTradeId: oandaTradeId,
      symbol: symbol,
      direction: direction.displayName,
      lots: lots,
      units: units,
      openPrice: openPrice,
      closePrice: closePrice,
      realizedPnl: realizedPnl,
      netProfit: netPnl,
      openTimeUs: openTimeUs,
      closeTimeUs: closeTimeUs,
      durationSeconds: ((closeTimeUs - openTimeUs) / 1000000).round(),
      closeDate: closeDateStr,
      swap: Value(swap),
      commission: Value(commission),
      maxProfit: Value(maxProfit),
      maxDrawdown: Value(maxDrawdown),
      closeReason: Value(_closeReasonToDbString(closeReason)),
      magicNumber: Value(magicNumber),
      comment: Value(comment),
    );
  }

  /// Convert a [CloseReason] enum value to its UPPER_SNAKE_CASE database string.
  static String _closeReasonToDbString(CloseReason reason) {
    return switch (reason) {
      CloseReason.manual => 'MANUAL',
      CloseReason.stopLoss => 'STOP_LOSS',
      CloseReason.takeProfit => 'TAKE_PROFIT',
      CloseReason.marginCall => 'MARGIN_CALL',
      CloseReason.eaClose => 'EA_CLOSE',
      CloseReason.brokerClose => 'BROKER_CLOSE',
    };
  }

  @override
  List<Object?> get props => [oandaTradeId, netPnl, closeTime];
}
