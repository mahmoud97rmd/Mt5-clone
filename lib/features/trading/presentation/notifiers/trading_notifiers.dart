// Path: lib/features/trading/presentation/notifiers/trading_notifiers.dart
// ============================================================
// MT5 Clone — Trading Terminal State Notifiers
// Manages UI state for:
//   - Open positions list
//   - Pending orders list
//   - Order entry form
//   - Position modification
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/order_entity.dart';
import '../../../../core/domain/entities/position_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/domain/failures/failures.dart';
import '../../../../core/engine/account_math_engine.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../../../../core/database/database_providers.dart';
import '../../data/repositories/trading_repository_impl.dart';

// ============================================================
// 7.5.1 — Open Positions Notifier
// ============================================================

class OpenPositionsState {
  final List<PositionEntity> positions;
  final bool isLoading;
  final bool isClosingAll;
  final Failure? error;

  const OpenPositionsState({
    this.positions = const [],
    this.isLoading = false,
    this.isClosingAll = false,
    this.error,
  });

  double get totalFloatingPnl =>
      positions.fold(0.0, (sum, p) => sum + p.floatingPnl);

  double get totalMarginUsed =>
      positions.fold(0.0, (sum, p) => sum + p.marginUsed);

  OpenPositionsState copyWith({
    List<PositionEntity>? positions,
    bool? isLoading,
    bool? isClosingAll,
    Failure? error,
  }) =>
      OpenPositionsState(
        positions: positions ?? this.positions,
        isLoading: isLoading ?? this.isLoading,
        isClosingAll: isClosingAll ?? this.isClosingAll,
        error: error ?? this.error,
      );
}

class OpenPositionsNotifier
    extends AutoDisposeNotifier<OpenPositionsState> {
  @override
  OpenPositionsState build() {
    // Subscribe to positions stream
    ref.listen(openPositionsStreamProvider, (_, next) {
      next.whenData((positions) {
        final entities = positions
            .map((p) => PositionEntity(
                  oandaTradeId: p.oandaTradeId,
                  symbol: p.symbol,
                  direction: TradeDirection.fromString(p.direction),
                  lots: p.lots,
                  units: p.units,
                  openPrice: p.openPrice,
                  currentPrice: p.currentPrice,
                  stopLoss: p.stopLoss,
                  takeProfit: p.takeProfit,
                  floatingPnl: p.floatingPnl,
                  swap: p.swap,
                  commission: p.commission,
                  marginUsed: p.marginUsed,
                  openTime: DateTime.fromMicrosecondsSinceEpoch(
                      p.openTimeUs),
                  magicNumber: p.magicNumber,
                  comment: p.comment,
                ))
            .toList();
        state = state.copyWith(positions: entities, isLoading: false);
      });
    });

    return const OpenPositionsState(isLoading: true);
  }

  Future<void> closePosition(String tradeId) async {
    final repo = ref.read(tradingRepositoryProvider);
    final result = await repo.closePosition(oandaTradeId: tradeId);

    result.fold(
      (failure) => state = state.copyWith(error: failure),
      (closed) {
        ref.read(accountMathEngineProvider).onPositionClosed(tradeId);
      },
    );
  }

  Future<void> closeAll() async {
    state = state.copyWith(isClosingAll: true, error: null);
    final repo = ref.read(tradingRepositoryProvider);
    final result = await repo.closeAllPositions();

    result.fold(
      (f) => state = state.copyWith(isClosingAll: false, error: f),
      (_) => state = state.copyWith(isClosingAll: false),
    );
  }
}

final openPositionsNotifierProvider = AutoDisposeNotifierProvider<
    OpenPositionsNotifier, OpenPositionsState>(
  OpenPositionsNotifier.new,
);

// ============================================================
// 7.5.2 — Pending Orders Notifier
// ============================================================

class PendingOrdersState {
  final List<OrderEntity> orders;
  final bool isLoading;
  final Failure? error;

  const PendingOrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  PendingOrdersState copyWith({
    List<OrderEntity>? orders,
    bool? isLoading,
    Failure? error,
  }) =>
      PendingOrdersState(
        orders: orders ?? this.orders,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class PendingOrdersNotifier
    extends AutoDisposeNotifier<PendingOrdersState> {
  @override
  PendingOrdersState build() {
    ref.listen(pendingOrdersStreamProvider, (_, next) {
      next.whenData((orders) {
        final entities = orders
            .map((o) => OrderEntity(
                  oandaOrderId: o.oandaOrderId,
                  symbol: o.symbol,
                  orderType: OrderType.fromString(o.orderType),
                  direction: TradeDirection.fromString(o.direction),
                  lots: o.lots,
                  units: o.units,
                  price: o.price,
                  stopLoss: o.stopLoss,
                  takeProfit: o.takeProfit,
                  timeInForce: o.timeInForce,
                  status: OrderStatus.fromString(o.status),
                  createTime: DateTime.fromMicrosecondsSinceEpoch(
                      o.createTimeUs),
                  magicNumber: o.magicNumber,
                  comment: o.comment,
                ))
            .toList();
        state = state.copyWith(orders: entities, isLoading: false);
      });
    });

    return const PendingOrdersState(isLoading: true);
  }

  Future<void> cancelOrder(String orderId) async {
    final repo = ref.read(tradingRepositoryProvider);
    final result = await repo.cancelOrder(orderId);
    result.fold(
      (f) => state = state.copyWith(error: f),
      (_) {},
    );
  }
}

final pendingOrdersNotifierProvider = AutoDisposeNotifierProvider<
    PendingOrdersNotifier, PendingOrdersState>(
  PendingOrdersNotifier.new,
);

// ============================================================
// 7.5.3 — Order Entry Notifier (form state)
// ============================================================

class OrderEntryState {
  final String symbol;
  final TradeDirection direction;
  final OrderType orderType;
  final double lots;
  final double? limitPrice;
  final double? stopLoss;
  final double? takeProfit;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  const OrderEntryState({
    required this.symbol,
    this.direction = TradeDirection.buy,
    this.orderType = OrderType.market,
    this.lots = 0.01,
    this.limitPrice,
    this.stopLoss,
    this.takeProfit,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  OrderEntryState copyWith({
    String? symbol,
    TradeDirection? direction,
    OrderType? orderType,
    double? lots,
    double? limitPrice,
    double? stopLoss,
    double? takeProfit,
    bool? isSubmitting,
    String? errorMessage,
    bool? isSuccess,
  }) =>
      OrderEntryState(
        symbol: symbol ?? this.symbol,
        direction: direction ?? this.direction,
        orderType: orderType ?? this.orderType,
        lots: lots ?? this.lots,
        limitPrice: limitPrice ?? this.limitPrice,
        stopLoss: stopLoss ?? this.stopLoss,
        takeProfit: takeProfit ?? this.takeProfit,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage,
        isSuccess: isSuccess ?? this.isSuccess,
      );
}

class OrderEntryNotifier
    extends AutoDisposeFamilyNotifier<OrderEntryState, String> {
  @override
  OrderEntryState build(String symbol) {
    return OrderEntryState(symbol: symbol);
  }

  void setDirection(TradeDirection dir) =>
      state = state.copyWith(direction: dir);

  void setOrderType(OrderType type) =>
      state = state.copyWith(orderType: type);

  void setLots(double lots) =>
      state = state.copyWith(lots: lots);

  void setStopLoss(double? sl) =>
      state = state.copyWith(stopLoss: sl);

  void setTakeProfit(double? tp) =>
      state = state.copyWith(takeProfit: tp);

  void setLimitPrice(double? price) =>
      state = state.copyWith(limitPrice: price);

  Future<void> submitMarketOrder() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final repo = ref.read(tradingRepositoryProvider);
    final result = await repo.openMarketOrder(
      symbol: state.symbol,
      direction: state.direction,
      lots: state.lots,
      stopLoss: state.stopLoss,
      takeProfit: state.takeProfit,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      ),
      (position) {
        ref
            .read(accountMathEngineProvider)
            .onPositionOpened(position);
        state = state.copyWith(
            isSubmitting: false, isSuccess: true);
      },
    );
  }
}

final orderEntryNotifierProvider = AutoDisposeNotifierProviderFamily<
    OrderEntryNotifier, OrderEntryState, String>(
  OrderEntryNotifier.new,
);
