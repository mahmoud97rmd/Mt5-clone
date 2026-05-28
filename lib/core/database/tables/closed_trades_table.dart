// Path: lib/core/database/tables/closed_trades_table.dart
// ============================================================
// MT5 Clone — Closed Trades Table (Drift Schema)
// Permanent record of all completed trades.
// Populated when a position is closed (manually or via SL/TP/EA).
//
// This table drives:
//   - History & Reports screen
//   - EA backtest performance metrics
//   - Daily P&L summary
//   - Export to CSV/PDF
// ============================================================

import 'package:drift/drift.dart';

/// 2.1.5 — Closed Trades History Table
///
/// Immutable once written — represents the final state of
/// a completed trade. Never UPDATE, only INSERT + SELECT.
class ClosedTrades extends Table {
  // ── Identity ──────────────────────────────────────────────
  IntColumn get id => integer().autoIncrement()();

  /// OANDA Trade ID (links to original position)
  TextColumn get oandaTradeId => text().unique()();

  // ── Instrument ────────────────────────────────────────────
  TextColumn get symbol => text()();

  // ── Direction & Volume ────────────────────────────────────
  /// "BUY" or "SELL"
  TextColumn get direction => text()();
  RealColumn get lots => real()();
  RealColumn get units => real()();

  // ── Pricing ───────────────────────────────────────────────
  /// Price at which position was opened
  RealColumn get openPrice => real()();

  /// Price at which position was closed
  RealColumn get closePrice => real()();

  // ── Risk Management (at time of close) ────────────────────
  RealColumn get stopLoss => real().nullable()();
  RealColumn get takeProfit => real().nullable()();

  // ── Financial Results ─────────────────────────────────────
  /// Realized P&L in account currency (positive = profit)
  RealColumn get realizedPnl => real()();

  /// Accumulated swap charges over holding period
  RealColumn get swap => real().withDefault(const Constant(0.0))();

  /// Commission paid (if applicable)
  RealColumn get commission => real().withDefault(const Constant(0.0))();

  /// Net profit = realizedPnl + swap - commission
  RealColumn get netProfit => real()();

  // ── Trade Metrics (for analysis) ──────────────────────────
  /// Maximum favorable excursion (highest unrealized profit during trade)
  RealColumn get maxProfit => real().nullable()();

  /// Maximum adverse excursion (deepest drawdown during trade)
  RealColumn get maxDrawdown => real().nullable()();

  /// Price distance between open and close (in pips)
  RealColumn get priceDeltaPips => real().nullable()();

  // ── Close Reason ──────────────────────────────────────────
  /// How the trade was closed:
  /// "MANUAL", "STOP_LOSS", "TAKE_PROFIT", "EA_CLOSE",
  /// "MARGIN_CALL", "TRAILING_STOP", "EXPIRED"
  TextColumn get closeReason => text().withDefault(const Constant('MANUAL'))();

  // ── Timing ────────────────────────────────────────────────
  /// When the position was opened (microseconds UTC)
  IntColumn get openTimeUs => integer()();

  /// When the position was closed (microseconds UTC)
  IntColumn get closeTimeUs => integer()();

  /// Holding duration in seconds (closeTimeUs - openTimeUs) / 1,000,000
  IntColumn get durationSeconds => integer()();

  // ── Session Context ───────────────────────────────────────
  /// Trading session at time of open: "SYDNEY", "TOKYO", "LONDON", "NEW_YORK"
  TextColumn get openSession => text().nullable()();

  // ── EA Association ────────────────────────────────────────
  IntColumn get magicNumber => integer().withDefault(const Constant(0))();
  TextColumn get comment => text().withDefault(const Constant(''))();

  // ── Grouping ──────────────────────────────────────────────
  /// Date string "YYYY-MM-DD" for fast daily aggregation queries
  TextColumn get closeDate => text()();
}
