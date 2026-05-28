// Path: lib/core/database/tables/orders_table.dart
// ============================================================
// MT5 Clone — Orders Table Definition
// ============================================================

import 'package:drift/drift.dart';

class Orders extends Table {
  TextColumn get oandaOrderId => text().withLength(min: 1, max: 50)();
  TextColumn get symbol => text().withLength(min: 1, max: 20)();
  TextColumn get orderType => text().withLength(min: 1, max: 20)();
  TextColumn get direction => text().withLength(min: 1, max: 10)();
  RealColumn get lots => real()();
  RealColumn get units => real()();
  RealColumn get price => real()();
  RealColumn get priceBound => real().nullable()();
  RealColumn get stopLoss => real().nullable()();
  RealColumn get takeProfit => real().nullable()();
  TextColumn get timeInForce => text().withDefault(const Constant('GTC'))();
  TextColumn get status => text().withDefault(const Constant('PENDING'))();
  IntColumn get createTimeUs => integer()();
  IntColumn get expiryTimeUs => integer().nullable()();
  IntColumn get magicNumber => integer().withDefault(const Constant(0))();
  TextColumn get comment => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {oandaOrderId};
}
