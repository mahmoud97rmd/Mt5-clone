// Path: lib/core/database/daos/positions_dao.dart
// ============================================================
// MT5 Clone — Positions DAO
// Manages open trading positions.
// Provides reactive streams for the Trading Terminal UI.
// ============================================================

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/positions_table.dart';

part 'positions_dao.g.dart';

@DriftAccessor(tables: [Positions])
class PositionsDao extends DatabaseAccessor<AppDatabase>
    with _$PositionsDaoMixin {
  PositionsDao(super.db);

  // ============================================================
  // 2.3.2.1 — WRITE OPERATIONS
  // ============================================================

  /// Insert a newly opened position.
  Future<int> insertPosition(PositionsCompanion position) =>
      into(positions).insert(position);

  /// Update position data (SL/TP modification, swap update, etc.)
  Future<bool> updatePosition(Position position) =>
      update(positions).replace(position);

  /// Update only the real-time pricing fields (currentPrice, floatingPnl).
  /// Called on every tick — designed to be fast with minimal data.
  Future<int> updatePositionPrice({
    required String oandaTradeId,
    required double currentPrice,
    required double floatingPnl,
    required double marginUsed,
  }) {
    return (update(positions)
          ..where((p) => p.oandaTradeId.equals(oandaTradeId)))
        .write(PositionsCompanion(
      currentPrice: Value(currentPrice),
      floatingPnl: Value(floatingPnl),
      marginUsed: Value(marginUsed),
    ));
  }

  /// Batch update prices for all positions at once (on tick).
  Future<void> batchUpdatePrices(
      List<({String tradeId, double price, double pnl, double margin})>
          updates) async {
    await batch((b) {
      for (final u in updates) {
        b.update(
          positions,
          PositionsCompanion(
            currentPrice: Value(u.price),
            floatingPnl: Value(u.pnl),
            marginUsed: Value(u.margin),
          ),
          where: (p) => p.oandaTradeId.equals(u.tradeId),
        );
      }
    });
  }

  /// Update SL/TP after a modification request succeeds.
  Future<int> updateStopLossTakeProfit({
    required String oandaTradeId,
    double? stopLoss,
    double? takeProfit,
  }) {
    return (update(positions)
          ..where((p) => p.oandaTradeId.equals(oandaTradeId)))
        .write(PositionsCompanion(
      stopLoss: Value(stopLoss),
      takeProfit: Value(takeProfit),
    ));
  }

  /// Delete a position (when it's closed — caller moves it to ClosedTrades).
  Future<int> deletePosition(String oandaTradeId) {
    return (delete(positions)
          ..where((p) => p.oandaTradeId.equals(oandaTradeId)))
        .go();
  }

  /// Delete all positions (e.g., on account switch or full sync).
  Future<int> deleteAllPositions() => delete(positions).go();

  // ============================================================
  // 2.3.2.2 — READ OPERATIONS
  // ============================================================

  /// Get all open positions, ordered by open time (newest first).
  Future<List<Position>> getAllPositions() {
    return (select(positions)
          ..orderBy([(p) => OrderingTerm.desc(p.openTimeUs)]))
        .get();
  }

  /// Watch all positions — Stream for Trading Terminal UI.
  /// Emits new list whenever any position changes.
  Stream<List<Position>> watchAllPositions() {
    return (select(positions)
          ..orderBy([(p) => OrderingTerm.desc(p.openTimeUs)]))
        .watch();
  }

  /// Get positions for a specific symbol.
  Future<List<Position>> getPositionsForSymbol(String symbol) {
    return (select(positions)
          ..where((p) => p.symbol.equals(symbol))
          ..orderBy([(p) => OrderingTerm.desc(p.openTimeUs)]))
        .get();
  }

  /// Get positions opened by a specific EA (by magic number).
  Future<List<Position>> getPositionsByMagic(int magic) {
    return (select(positions)
          ..where((p) => p.magicNumber.equals(magic))
          ..orderBy([(p) => OrderingTerm.desc(p.openTimeUs)]))
        .get();
  }

  /// Get a single position by OANDA trade ID.
  Future<Position?> getPositionByTradeId(String oandaTradeId) {
    return (select(positions)
          ..where((p) => p.oandaTradeId.equals(oandaTradeId)))
        .getSingleOrNull();
  }

  // ============================================================
  // 2.3.2.3 — AGGREGATED QUERIES (for Account Engine)
  // ============================================================

  /// Get total floating PnL across all open positions.
  Future<double> getTotalFloatingPnl() async {
    final expr = positions.floatingPnl.sum();
    final query = selectOnly(positions)..addColumns([expr]);
    return await query.map((r) => r.read(expr) ?? 0.0).getSingle();
  }

  /// Get total margin used by all open positions.
  Future<double> getTotalMarginUsed() async {
    final expr = positions.marginUsed.sum();
    final query = selectOnly(positions)..addColumns([expr]);
    return await query.map((r) => r.read(expr) ?? 0.0).getSingle();
  }

  /// Get count of open positions.
  Future<int> getPositionCount() async {
    final expr = positions.id.count();
    final query = selectOnly(positions)..addColumns([expr]);
    return await query.map((r) => r.read(expr) ?? 0).getSingle();
  }

  /// Watch aggregate account metrics (equity-driven fields).
  /// Returns stream of (totalPnl, totalMargin, positionCount).
  Stream<({double totalPnl, double totalMargin, int count})>
      watchPositionAggregates() {
    final pnlExpr = positions.floatingPnl.sum();
    final marginExpr = positions.marginUsed.sum();
    final countExpr = positions.id.count();

    return (selectOnly(positions)
          ..addColumns([pnlExpr, marginExpr, countExpr]))
        .watchSingle()
        .map((r) => (
              totalPnl: r.read(pnlExpr) ?? 0.0,
              totalMargin: r.read(marginExpr) ?? 0.0,
              count: r.read(countExpr) ?? 0,
            ));
  }
}
