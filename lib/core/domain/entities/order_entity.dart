// Path: lib/core/domain/entities/order_entity.dart
// ============================================================
// MT5 Clone — Order Domain Entity
// Represents a pending order (limit, stop, stop-limit).
// ============================================================

import 'package:equatable/equatable.dart';

import '../enums/trading_enums.dart';

class OrderEntity extends Equatable {
  final String oandaOrderId;
  final String symbol;
  final OrderType orderType;
  final TradeDirection direction;
  final double lots;
  final double units;
  final double price;
  final double? priceBound;
  final double? stopLoss;
  final double? takeProfit;
  final String timeInForce;
  final OrderStatus status;
  final DateTime createTime;
  final DateTime? expiryTime;
  final int magicNumber;
  final String comment;

  const OrderEntity({
    required this.oandaOrderId,
    required this.symbol,
    required this.orderType,
    required this.direction,
    required this.lots,
    required this.units,
    required this.price,
    this.priceBound,
    this.stopLoss,
    this.takeProfit,
    this.timeInForce = 'GTC',
    required this.status,
    required this.createTime,
    this.expiryTime,
    this.magicNumber = 0,
    this.comment = '',
  });

  bool get hasStopLoss => stopLoss != null;
  bool get hasTakeProfit => takeProfit != null;
  bool get isEaOrder => magicNumber != 0;

  double distanceFromMarket(double currentPrice) {
    return (price - currentPrice).abs();
  }

  double distanceInPips(double currentPrice, double pipSize) {
    if (pipSize <= 0) return 0;
    return distanceFromMarket(currentPrice) / pipSize;
  }

  OrderEntity copyWith({
    String? oandaOrderId,
    String? symbol,
    OrderType? orderType,
    TradeDirection? direction,
    double? lots,
    double? units,
    double? price,
    double? priceBound,
    double? stopLoss,
    double? takeProfit,
    String? timeInForce,
    OrderStatus? status,
    DateTime? createTime,
    DateTime? expiryTime,
    int? magicNumber,
    String? comment,
  }) {
    return OrderEntity(
      oandaOrderId: oandaOrderId ?? this.oandaOrderId,
      symbol: symbol ?? this.symbol,
      orderType: orderType ?? this.orderType,
      direction: direction ?? this.direction,
      lots: lots ?? this.lots,
      units: units ?? this.units,
      price: price ?? this.price,
      priceBound: priceBound ?? this.priceBound,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      timeInForce: timeInForce ?? this.timeInForce,
      status: status ?? this.status,
      createTime: createTime ?? this.createTime,
      expiryTime: expiryTime ?? this.expiryTime,
      magicNumber: magicNumber ?? this.magicNumber,
      comment: comment ?? this.comment,
    );
  }

  @override
  List<Object?> get props => [oandaOrderId, price, status];
}
