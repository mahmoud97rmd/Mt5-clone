// Path: lib/core/database/tables/positions_table.dart
// ============================================================
// MT5 Clone — Positions Table (Drift Schema)
// Stores all currently OPEN trading positions.
//
// Lifecycle:
//   INSERT → when a trade is executed (buy/sell)
//   UPDATE → when SL/TP is modified, swap accumulates, price updates
//   DELETE → when position is closed (moved to ClosedTrades)
//
// Real-time fields (updated on each tick):
//   - currentPrice, floatingPnl, marginUsed
// ============================================================

import 'package:drift/drift.dart';

/// 2.1.3 — Open Positions Table
///
/// Each row represents one open trading position.
/// Updated in real-time as prices move.
class Positions extends Table {
  // ── Identity ──────────────────────────────────────────────
  /// Internal database ID (autoincrement)
  IntColumn get id => integer().autoIncrement()();

  /// OANDA Trade ID — the unique identifier from OANDA's system
  /// This is what we use to modify/close positions via API
  TextColumn get oandaTradeId => text().unique()();

  // ── Instrument ────────────────────────────────────────────
  /// Trading instrument (e.g., "XAU_USD")
  TextColumn get symbol => text()();

  // ── Direction & Volume ────────────────────────────────────
  /// "BUY" (long) or "SELL" (short)
  TextColumn get direction => text()();

  /// Position size in lots (e.g., 0.01, 0.1, 1.0)
  RealColumn get lots => real()();

  /// Position size in base units (OANDA uses units, not lots)
  RealColumn get units => real()();

  // ── Pricing ───────────────────────────────────────────────
  /// Price at which the position was opened
  RealColumn get openPrice => real()();

  /// Current market price (bid for longs, ask for shorts)
  /// Updated on every tick — this drives the PnL calculation
  RealColumn get currentPrice => real().withDefault(const Constant(0.0))();

  // ── Risk Management ───────────────────────────────────────
  /// Stop Loss price (null = no SL set)
  RealColumn get stopLoss => real().nullable()();

  /// Take Profit price (null = no TP set)
  RealColumn get takeProfit => real().nullable()();

  // ── Profit & Loss ─────────────────────────────────────────
  /// Floating (unrealized) P&L in account currency
  /// Recalculated on every tick update
  RealColumn get floatingPnl => real().withDefault(const Constant(0.0))();

  /// Accumulated swap/rollover charges (added daily at 5pm NY time)
  RealColumn get swap => real().withDefault(const Constant(0.0))();

  /// Commission charged on open (if applicable)
  RealColumn get commission => real().withDefault(const Constant(0.0))();

  // ── Margin ────────────────────────────────────────────────
  /// Margin currently used by this position (in account currency)
  RealColumn get marginUsed => real().withDefault(const Constant(0.0))();

  // ── Timing ────────────────────────────────────────────────
  /// When the position was opened (microseconds UTC)
  IntColumn get openTimeUs => integer()();

  // ── EA Association ────────────────────────────────────────
  /// Magic number identifying which EA opened this position (0 = manual)
  IntColumn get magicNumber => integer().withDefault(const Constant(0))();

  /// Order comment (max 32 chars, from EA or manual entry)
  TextColumn get comment => text().withDefault(const Constant(''))();

  // ── State ─────────────────────────────────────────────────
  /// Whether this position is currently being modified (UI lock)
  BoolColumn get isModifying => boolean().withDefault(const Constant(false))();
}
