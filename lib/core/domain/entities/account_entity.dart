// Path: lib/core/domain/entities/account_entity.dart
// ============================================================
// MT5 Clone — Account Domain Entity
// Represents the trading account state with real-time metrics.
// ============================================================

import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String accountId;
  final String currency;
  final String alias;
  final bool isLive;
  final int leverage;
  final double balance;
  final double equity;
  final double marginUsed;
  final double marginAvailable;
  final double? marginLevel;
  final double nav;
  final int openPositionCount;
  final double unrealizedPnl;
  final double dailyRealizedPnl;
  final DateTime lastUpdated;

  const AccountEntity({
    required this.accountId,
    this.currency = 'USD',
    this.alias = '',
    this.isLive = false,
    this.leverage = 50,
    required this.balance,
    required this.equity,
    required this.marginUsed,
    required this.marginAvailable,
    this.marginLevel,
    required this.nav,
    this.openPositionCount = 0,
    this.unrealizedPnl = 0.0,
    this.dailyRealizedPnl = 0.0,
    required this.lastUpdated,
  });

  double get totalDailyPnl => dailyRealizedPnl + unrealizedPnl;
  bool get isMarginCallRisk => marginLevel != null && marginLevel! < 100.0;
  bool get isMarginCall => marginLevel != null && marginLevel! < 50.0;
  bool get hasOpenPositions => openPositionCount > 0;

  AccountEntity copyWith({
    String? accountId,
    String? currency,
    String? alias,
    bool? isLive,
    int? leverage,
    double? balance,
    double? equity,
    double? marginUsed,
    double? marginAvailable,
    double? marginLevel,
    double? nav,
    int? openPositionCount,
    double? unrealizedPnl,
    double? dailyRealizedPnl,
    DateTime? lastUpdated,
  }) {
    return AccountEntity(
      accountId: accountId ?? this.accountId,
      currency: currency ?? this.currency,
      alias: alias ?? this.alias,
      isLive: isLive ?? this.isLive,
      leverage: leverage ?? this.leverage,
      balance: balance ?? this.balance,
      equity: equity ?? this.equity,
      marginUsed: marginUsed ?? this.marginUsed,
      marginAvailable: marginAvailable ?? this.marginAvailable,
      marginLevel: marginLevel ?? this.marginLevel,
      nav: nav ?? this.nav,
      openPositionCount: openPositionCount ?? this.openPositionCount,
      unrealizedPnl: unrealizedPnl ?? this.unrealizedPnl,
      dailyRealizedPnl: dailyRealizedPnl ?? this.dailyRealizedPnl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  static AccountEntity empty(String accountId) => AccountEntity(
        accountId: accountId,
        balance: 0,
        equity: 0,
        marginUsed: 0,
        marginAvailable: 0,
        nav: 0,
        lastUpdated: DateTime.now(),
      );

  @override
  List<Object?> get props => [
        accountId,
        balance,
        equity,
        marginUsed,
        marginAvailable,
        marginLevel,
        unrealizedPnl,
        openPositionCount,
      ];
}
