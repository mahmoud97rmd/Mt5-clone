// Path: lib/core/database/daos/orders_dao.dart
// ============================================================
// MT5 Clone — Orders DAO
// ============================================================

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/orders_table.dart';

part 'orders_dao.g.dart';

@DriftAccessor(tables: [Orders])
class OrdersDao extends DatabaseAccessor<AppDatabase>
    with _$OrdersDaoMixin {
  OrdersDao(super.db);

  Future<int> insertOrder(OrdersCompanion order) {
    return into(orders).insert(order, mode: InsertMode.insertOrReplace);
  }

  Future<List<Order>> getAllOrders() {
    return (select(orders)
          ..orderBy([(t) => OrderingTerm.desc(t.createTimeUs)]))
        .get();
  }

  Stream<List<Order>> watchAllOrders() {
    return (select(orders)
          ..orderBy([(t) => OrderingTerm.desc(t.createTimeUs)]))
        .watch();
  }

  Future<List<Order>> getOrdersBySymbol(String symbol) {
    return (select(orders)
          ..where((t) => t.symbol.equals(symbol))
          ..orderBy([(t) => OrderingTerm.desc(t.createTimeUs)]))
        .get();
  }

  Future<Order?> getOrderById(String oandaOrderId) {
    return (select(orders)
          ..where((t) => t.oandaOrderId.equals(oandaOrderId)))
        .getSingleOrNull();
  }

  Future<int> updateOrderStatus(String oandaOrderId, String status) {
    return (update(orders)
          ..where((t) => t.oandaOrderId.equals(oandaOrderId)))
        .write(OrdersCompanion(status: Value(status)));
  }

  Future<int> deleteOrder(String oandaOrderId) {
    return (delete(orders)
          ..where((t) => t.oandaOrderId.equals(oandaOrderId)))
        .go();
  }

  Future<int> deleteAllOrders() {
    return delete(orders).go();
  }

  Stream<List<Order>> watchPendingOrders() {
    return (select(orders)
          ..where((t) => t.status.equals('PENDING'))
          ..orderBy([(t) => OrderingTerm.desc(t.createTimeUs)]))
        .watch();
  }

  Future<int> cancelOrder(String oandaOrderId) {
    return deleteOrder(oandaOrderId);
  }
}
