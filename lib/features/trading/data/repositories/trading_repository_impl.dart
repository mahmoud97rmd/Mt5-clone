// Path: lib/features/trading/data/repositories/trading_repository_impl.dart
// ============================================================
// MT5 Clone — Trading Repository Implementation
// Implements ITradingRepository using:
//   - OandaRestDataSource for API calls
//   - PositionsDao / OrdersDao for local persistence
//   - Mappers for DTO ↔ Entity conversion
//   - Either<Failure, T> for error propagation
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/daos/positions_dao.dart';
import '../../../../core/database/daos/orders_dao.dart';
import '../../../../core/domain/entities/closed_trade_entity.dart';
import '../../../../core/domain/entities/order_entity.dart';
import '../../../../core/domain/entities/position_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/domain/failures/failures.dart';
import '../../../../core/domain/repositories/repositories.dart';
import '../../../../core/network/api_constants.dart';
import '../datasources/oanda_rest_datasource.dart';
import '../mappers/oanda_mappers.dart';
import '../models/trade_order_dto.dart';

class TradingRepositoryImpl implements ITradingRepository {
  final OandaRestDataSource _dataSource;
  final PositionsDao _positionsDao;
  final OrdersDao _ordersDao;

  TradingRepositoryImpl({
    required OandaRestDataSource dataSource,
    required PositionsDao positionsDao,
    required OrdersDao ordersDao,
  })  : _dataSource = dataSource,
        _positionsDao = positionsDao,
        _ordersDao = ordersDao;

  // ============================================================
  // 4.6.1 — Open Market Order
  // ============================================================

  @override
  Future<Either<Failure, PositionEntity>> openMarketOrder({
    required String symbol,
    required TradeDirection direction,
    required double lots,
    double? stopLoss,
    double? takeProfit,
    int magicNumber = 0,
    String comment = '',
  }) async {
    return _guardAsync(() async {
      // Get instrument info for unit calculation
      final unitsPerLot = _getUnitsPerLot(symbol);
      final units = lots * unitsPerLot;

      // OANDA: positive units = buy, negative units = sell
      final oandaUnits = direction.isBuy ? units : -units;

      // Build the order request
      final request = CreateOrderRequestDto(
        order: CreateOrderBodyDto(
          type: 'MARKET',
          instrument: symbol,
          units: oandaUnits.toStringAsFixed(0),
          timeInForce: OandaApiConstants.tifFok,
          takeProfitOnFill: takeProfit != null
              ? TpOnFillDto(
                  price: takeProfit.toStringAsFixed(
                      _getPrecision(symbol)))
              : null,
          stopLossOnFill: stopLoss != null
              ? SlOnFillDto(
                  price: stopLoss.toStringAsFixed(
                      _getPrecision(symbol)))
              : null,
          // Encode magic number in clientExtensions.id for EA tracking
          tradeClientExtensions: magicNumber != 0
              ? ClientExtensionsDto(
                  id: magicNumber.toString(),
                  comment: comment,
                )
              : comment.isNotEmpty
                  ? ClientExtensionsDto(comment: comment)
                  : null,
        ),
      );

      final response = await _dataSource.createOrder(request: request);

      // Check if order was filled (market orders should fill immediately)
      if (response.orderFillTransaction == null) {
        return Left(OrderRejectedFailure(
          message: 'Market order was not filled immediately',
        ));
      }

      // Fetch the newly opened trade to get full details
      final tradeId = response.orderFillTransaction!.tradeOpened;
      if (tradeId == null) {
        return Left(OrderRejectedFailure(
          message: 'Trade ID not returned after order fill',
        ));
      }

      final tradeResponse = await _dataSource.getTrade(tradeId);
      final position =
          PositionMapper.fromTradeDto(tradeResponse.trade);

      // Persist locally
      await _positionsDao.insertPosition(_positionToCompanion(position));

      return Right(position);
    });
  }

  // ============================================================
  // 4.6.2 — Close Position
  // ============================================================

  @override
  Future<Either<Failure, ClosedTradeEntity>> closePosition({
    required String oandaTradeId,
    double? lots,
  }) async {
    return _guardAsync(() async {
      final unitsPerLot =
          _getUnitsPerLotFromTradeId(oandaTradeId); // simplified
      final units = lots != null ? lots * unitsPerLot : null;

      await _dataSource.closeTrade(
        tradeId: oandaTradeId,
        units: units,
      );

      // Remove from local positions DB
      await _positionsDao.deletePosition(oandaTradeId);

      // Create a minimal ClosedTradeEntity — full details via history sync
      return Right(ClosedTradeEntity(
        oandaTradeId: oandaTradeId,
        symbol: '',     // filled by caller or history sync
        direction: TradeDirection.buy,
        lots: lots ?? 0,
        units: units ?? 0,
        openPrice: 0,
        closePrice: 0,
        realizedPnl: 0,
        netPnl: 0,
        closeReason: CloseReason.manual,
        openTime: DateTime.now(),
        closeTime: DateTime.now(),
      ));
    });
  }

  // ============================================================
  // 4.6.3 — Modify Position (SL/TP)
  // ============================================================

  @override
  Future<Either<Failure, PositionEntity>> modifyPosition({
    required String oandaTradeId,
    double? stopLoss,
    double? takeProfit,
  }) async {
    return _guardAsync(() async {
      await _dataSource.modifyTrade(
        tradeId: oandaTradeId,
        takeProfitPrice: takeProfit,
        stopLossPrice: stopLoss,
      );

      // Update local DB
      await _positionsDao.updateStopLossTakeProfit(
        oandaTradeId: oandaTradeId,
        stopLoss: stopLoss,
        takeProfit: takeProfit,
      );

      // Return updated position from local DB
      final position =
          await _positionsDao.getPositionByTradeId(oandaTradeId);

      if (position == null) {
        return Left(PositionNotFoundFailure(
          message: 'Position not found: $oandaTradeId',
        ));
      }

      return Right(_positionFromDb(position));
    });
  }

  // ============================================================
  // 4.6.4 — Close All Positions
  // ============================================================

  @override
  Future<Either<Failure, List<ClosedTradeEntity>>> closeAllPositions({
    String? symbol,
    int? magicNumber,
  }) async {
    return _guardAsync(() async {
      List<db.Position> toClose;

      if (symbol != null) {
        toClose = await _positionsDao.getPositionsForSymbol(symbol);
      } else if (magicNumber != null) {
        toClose = await _positionsDao.getPositionsByMagic(magicNumber);
      } else {
        toClose = await _positionsDao.getAllPositions();
      }

      final closedTrades = <ClosedTradeEntity>[];
      for (final pos in toClose) {
        final result = await closePosition(oandaTradeId: pos.oandaTradeId);
        result.fold(
          (failure) => null, // log failure but continue
          (closed) => closedTrades.add(closed),
        );
      }

      return Right(closedTrades);
    });
  }

  // ============================================================
  // 4.6.5 — Place Pending Order
  // ============================================================

  @override
  Future<Either<Failure, OrderEntity>> placeOrder({
    required String symbol,
    required OrderType orderType,
    required double lots,
    required double price,
    double? priceBound,
    double? stopLoss,
    double? takeProfit,
    String timeInForce = 'GTC',
    DateTime? expiryTime,
    int magicNumber = 0,
    String comment = '',
  }) async {
    return _guardAsync(() async {
      final unitsPerLot = _getUnitsPerLot(symbol);
      final units = lots * unitsPerLot;
      final isBuy = orderType.direction.isBuy;
      final oandaUnits = isBuy ? units : -units;
      final precision = _getPrecision(symbol);

      final oandaOrderType = switch (orderType) {
        OrderType.buyLimit || OrderType.sellLimit => 'LIMIT',
        OrderType.buyStop || OrderType.sellStop => 'STOP',
        OrderType.buyStopLimit || OrderType.sellStopLimit => 'STOP',
        _ => 'MARKET',
      };

      final request = CreateOrderRequestDto(
        order: CreateOrderBodyDto(
          type: '${oandaOrderType}_ORDER',
          instrument: symbol,
          units: oandaUnits.toStringAsFixed(0),
          price: price.toStringAsFixed(precision),
          priceBound:
              priceBound?.toStringAsFixed(precision),
          timeInForce: timeInForce,
          gtdTime: expiryTime != null
              ? (expiryTime.microsecondsSinceEpoch / 1000000)
                  .toStringAsFixed(6)
              : null,
          takeProfitOnFill: takeProfit != null
              ? TpOnFillDto(
                  price: takeProfit.toStringAsFixed(precision))
              : null,
          stopLossOnFill: stopLoss != null
              ? SlOnFillDto(
                  price: stopLoss.toStringAsFixed(precision))
              : null,
          clientExtensions: magicNumber != 0
              ? ClientExtensionsDto(
                  id: magicNumber.toString(),
                  comment: comment,
                )
              : null,
        ),
      );

      await _dataSource.createOrder(request: request);

      // Fetch the newly created pending order
      final pendingOrders = await _dataSource.getPendingOrders();
      final newOrder = pendingOrders.orders
          .where((o) => o.instrument == symbol)
          .firstOrNull;

      if (newOrder == null) {
        return Left(NotFoundFailure(message: 'Pending order not found after creation'));
      }

      final orderEntity = OrderMapper.fromOrderDto(newOrder);

      // Persist locally
      await _ordersDao.insertOrder(_orderToCompanion(orderEntity));

      return Right(orderEntity);
    });
  }

  // ============================================================
  // 4.6.6 — Cancel Order
  // ============================================================

  @override
  Future<Either<Failure, Unit>> cancelOrder(String oandaOrderId) async {
    return _guardAsync(() async {
      await _dataSource.cancelOrder(oandaOrderId);
      await _ordersDao.cancelOrder(oandaOrderId);
      return const Right(unit);
    });
  }

  @override
  Future<Either<Failure, OrderEntity>> modifyOrder({
    required String oandaOrderId,
    double? newPrice,
    double? newStopLoss,
    double? newTakeProfit,
  }) async {
    // OANDA doesn't support modifying pending orders directly.
    // Must cancel and re-create. Simplified implementation:
    return Left(UnexpectedFailure(
      message: 'Order modification not yet implemented',
    ));
  }

  // ============================================================
  // 4.6.7 — Streams (delegate to DAO)
  // ============================================================

  @override
  Stream<List<PositionEntity>> watchOpenPositions() {
    return _positionsDao.watchAllPositions().map(
          (positions) => positions.map(_positionFromDb).toList(),
        );
  }

  @override
  Stream<List<OrderEntity>> watchPendingOrders() {
    return _ordersDao.watchPendingOrders().map(
          (orders) => orders.map(_orderFromDb).toList(),
        );
  }

  // ============================================================
  // 4.6.8 — Sync (reconcile local DB with OANDA)
  // ============================================================

  @override
  Future<Either<Failure, List<PositionEntity>>> syncPositions() async {
    return _guardAsync(() async {
      final response = await _dataSource.getOpenTrades();
      final entities = PositionMapper.fromTradeDtoList(response.trades);

      // Clear and re-insert for full sync
      await _positionsDao.deleteAllPositions();
      for (final pos in entities) {
        await _positionsDao.insertPosition(_positionToCompanion(pos));
      }

      return Right(entities);
    });
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> syncOrders() async {
    return _guardAsync(() async {
      final response = await _dataSource.getPendingOrders();
      final entities = OrderMapper.fromOrderDtoList(response.orders);
      return Right(entities);
    });
  }

  // ============================================================
  // 4.6.9 — Private Helpers
  // ============================================================

  /// Wraps async call in try-catch → Either<Failure, T>
  Future<Either<Failure, T>> _guardAsync<T>(
      Future<Either<Failure, T>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      // Error interceptor already converted to Failure in e.error
      if (e.error is Failure) return Left(e.error as Failure);
      return Left(NetworkFailure(originalError: e));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  double _getUnitsPerLot(String symbol) =>
      symbol.contains('XAU') || symbol.contains('XAG')
          ? 100.0
          : 100000.0;

  double _getUnitsPerLotFromTradeId(String _) => 100000.0;

  int _getPrecision(String symbol) {
    if (symbol.contains('XAU')) return 2;
    if (symbol.contains('JPY')) return 3;
    return 5;
  }

  /// Convert Drift Position DB row to domain entity
  PositionEntity _positionFromDb(db.Position row) => PositionEntity(
        oandaTradeId: row.oandaTradeId,
        symbol: row.symbol,
        direction: TradeDirection.fromString(row.direction),
        lots: row.lots,
        units: row.units,
        openPrice: row.openPrice,
        currentPrice: row.currentPrice,
        stopLoss: row.stopLoss,
        takeProfit: row.takeProfit,
        floatingPnl: row.floatingPnl,
        swap: row.swap,
        commission: row.commission,
        marginUsed: row.marginUsed,
        openTime: DateTime.fromMicrosecondsSinceEpoch(row.openTimeUs),
        magicNumber: row.magicNumber,
        comment: row.comment,
      );

  /// Convert domain entity to Drift companion for DB insert
  db.PositionsCompanion _positionToCompanion(PositionEntity e) =>
      db.PositionsCompanion.insert(
        oandaTradeId: e.oandaTradeId,
        symbol: e.symbol,
        direction: e.direction.oandaValue,
        lots: e.lots,
        units: e.units,
        openPrice: e.openPrice,
        openTimeUs: e.openTime.microsecondsSinceEpoch,
        currentPrice: Value(e.currentPrice),
        stopLoss: Value(e.stopLoss),
        takeProfit: Value(e.takeProfit),
        floatingPnl: Value(e.floatingPnl),
        swap: Value(e.swap),
        commission: Value(e.commission),
        marginUsed: Value(e.marginUsed),
        magicNumber: Value(e.magicNumber),
        comment: Value(e.comment),
      );

  OrderEntity _orderFromDb(db.Order row) => OrderEntity(
        oandaOrderId: row.oandaOrderId,
        symbol: row.symbol,
        orderType: OrderType.fromString(row.orderType),
        direction: TradeDirection.fromString(row.direction),
        lots: row.lots,
        units: row.units,
        price: row.price,
        stopLoss: row.stopLoss,
        takeProfit: row.takeProfit,
        timeInForce: row.timeInForce,
        status: OrderStatus.fromString(row.status),
        createTime:
            DateTime.fromMicrosecondsSinceEpoch(row.createTimeUs),
        magicNumber: row.magicNumber,
        comment: row.comment,
      );

  db.OrdersCompanion _orderToCompanion(OrderEntity e) =>
      db.OrdersCompanion.insert(
        oandaOrderId: e.oandaOrderId,
        symbol: e.symbol,
        orderType: e.orderType.oandaName,
        direction: e.direction.oandaValue,
        lots: e.lots,
        units: e.units,
        price: e.price,
        stopLoss: Value(e.stopLoss),
        takeProfit: Value(e.takeProfit),
        timeInForce: Value(e.timeInForce),
        status: Value(e.status.displayName.toUpperCase()),
        createTimeUs: e.createTime.microsecondsSinceEpoch,
        magicNumber: Value(e.magicNumber),
        comment: Value(e.comment),
      );
}

// ============================================================
// 4.6.10 — Riverpod Provider
// ============================================================

final tradingRepositoryProvider = Provider<ITradingRepository>((ref) {
  return TradingRepositoryImpl(
    dataSource: ref.watch(oandaRestDataSourceProvider),
    positionsDao: ref.watch(positionsDaoProvider),
    ordersDao: ref.watch(ordersDaoProvider),
  );
});
