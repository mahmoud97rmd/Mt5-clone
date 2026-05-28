// Path: lib/core/domain/repositories/repositories.dart
// ============================================================
// MT5 Clone — Repository Interface Contracts
// Abstract classes defining WHAT the data layer must provide.
// Domain layer depends only on these interfaces — never on
// concrete implementations (Drift, OANDA API, etc.)
//
// All methods return Either<Failure, T> for type-safe errors.
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../entities/account_entity.dart';
import '../entities/candle_entity.dart';
import '../entities/closed_trade_entity.dart';
import '../entities/ea_entities.dart';
import '../entities/order_entity.dart';
import '../entities/position_entity.dart';
import '../entities/symbol_entity.dart';
import '../entities/tick_entity.dart';
import '../enums/trading_enums.dart';
import '../failures/failures.dart';

// ============================================================
// 3.4.1 — Price / Tick Repository
// ============================================================

abstract class IPriceRepository {
  /// Stream of real-time tick updates for a symbol.
  /// Connects to OANDA WebSocket stream internally.
  Stream<Either<Failure, TickEntity>> watchTick(String symbol);

  /// Get the latest cached tick for a symbol (synchronous from Hive).
  TickEntity? getCachedTick(String symbol);

  /// Get tick history for a symbol within a time range.
  Future<Either<Failure, List<TickEntity>>> getTickHistory({
    required String symbol,
    required DateTime from,
    required DateTime to,
  });

  /// Start streaming prices for a list of symbols.
  Future<Either<Failure, Unit>> startStreaming(List<String> symbols);

  /// Stop the price stream.
  Future<Either<Failure, Unit>> stopStreaming();

  /// Whether the price stream is currently connected.
  bool get isStreaming;

  /// Stream of stream connection state changes.
  Stream<bool> get streamConnectionState;
}

// ============================================================
// 3.4.2 — Trading Repository
// ============================================================

abstract class ITradingRepository {
  // ── Position Operations ────────────────────────────────────

  /// Open a market order (buy or sell).
  Future<Either<Failure, PositionEntity>> openMarketOrder({
    required String symbol,
    required TradeDirection direction,
    required double lots,
    double? stopLoss,
    double? takeProfit,
    int magicNumber,
    String comment,
  });

  /// Close an open position.
  Future<Either<Failure, ClosedTradeEntity>> closePosition({
    required String oandaTradeId,
    double? lots, // partial close
  });

  /// Modify SL/TP of an open position.
  Future<Either<Failure, PositionEntity>> modifyPosition({
    required String oandaTradeId,
    double? stopLoss,
    double? takeProfit,
  });

  /// Close all open positions for a symbol.
  Future<Either<Failure, List<ClosedTradeEntity>>> closeAllPositions({
    String? symbol,
    int? magicNumber,
  });

  // ── Pending Order Operations ───────────────────────────────

  /// Place a pending order (limit, stop, stop-limit).
  Future<Either<Failure, OrderEntity>> placeOrder({
    required String symbol,
    required OrderType orderType,
    required double lots,
    required double price,
    double? priceBound,
    double? stopLoss,
    double? takeProfit,
    String timeInForce,
    DateTime? expiryTime,
    int magicNumber,
    String comment,
  });

  /// Cancel a pending order.
  Future<Either<Failure, Unit>> cancelOrder(String oandaOrderId);

  /// Modify a pending order's price, SL, or TP.
  Future<Either<Failure, OrderEntity>> modifyOrder({
    required String oandaOrderId,
    double? newPrice,
    double? newStopLoss,
    double? newTakeProfit,
  });

  // ── Data Streams ────────────────────────────────────────────

  /// Stream of all open positions (updated in real-time).
  Stream<List<PositionEntity>> watchOpenPositions();

  /// Stream of all pending orders.
  Stream<List<OrderEntity>> watchPendingOrders();

  /// Sync positions from OANDA API (reconcile local state).
  Future<Either<Failure, List<PositionEntity>>> syncPositions();

  /// Sync pending orders from OANDA API.
  Future<Either<Failure, List<OrderEntity>>> syncOrders();
}

// ============================================================
// 3.4.3 — Account Repository
// ============================================================

abstract class IAccountRepository {
  /// Get current account state from OANDA API.
  Future<Either<Failure, AccountEntity>> getAccount();

  /// Stream of account state updates (driven by tick + trade events).
  Stream<AccountEntity> watchAccount();

  /// Get all available instruments for this account.
  Future<Either<Failure, List<SymbolEntity>>> getInstruments();

  /// Get watchlisted symbols.
  Future<Either<Failure, List<SymbolEntity>>> getWatchlist();

  /// Stream of watchlist symbols.
  Stream<List<SymbolEntity>> watchWatchlist();

  /// Toggle a symbol on/off the watchlist.
  Future<Either<Failure, Unit>> toggleWatchlist(
      String symbol, bool isWatchlisted);

  /// Reorder the watchlist after drag-to-reorder.
  Future<Either<Failure, Unit>> reorderWatchlist(
      List<String> orderedSymbols);
}

// ============================================================
// 3.4.4 — Candle / Chart Repository
// ============================================================

abstract class ICandleRepository {
  /// Get candles for charting — uses cache first, fetches from OANDA if needed.
  Future<Either<Failure, List<CandleEntity>>> getCandles({
    required String symbol,
    required Timeframe timeframe,
    int count,
    DateTime? from,
    DateTime? to,
  });

  /// Stream of candle updates — emits when a new candle opens or
  /// the current candle's close price changes.
  Stream<List<CandleEntity>> watchCandles({
    required String symbol,
    required Timeframe timeframe,
    int limit,
  });

  /// Force-refresh candles from OANDA API (bypass cache).
  Future<Either<Failure, List<CandleEntity>>> refreshCandles({
    required String symbol,
    required Timeframe timeframe,
    int count,
  });
}

// ============================================================
// 3.4.5 — History Repository
// ============================================================

abstract class IHistoryRepository {
  /// Get closed trade history from local DB with optional filters.
  Future<Either<Failure, List<ClosedTradeEntity>>> getClosedTrades({
    required DateTime from,
    required DateTime to,
    String? symbol,
    int? magicNumber,
    TradeDirection? direction,
  });

  /// Stream of recent closed trades (live updates).
  Stream<List<ClosedTradeEntity>> watchRecentTrades({int limit});

  /// Sync closed trade history from OANDA API.
  Future<Either<Failure, List<ClosedTradeEntity>>> syncHistory({
    required DateTime from,
    required DateTime to,
  });

  /// Get aggregated trade summary for reporting.
  Future<Either<Failure, TradeSummaryEntity>> getTradeSummary({
    required DateTime from,
    required DateTime to,
    String? symbol,
    int? magicNumber,
  });

  /// Get daily P&L breakdown for equity curve.
  Future<Either<Failure, List<DailyPnlEntity>>> getDailyPnl({
    required DateTime from,
    required DateTime to,
  });
}

// ============================================================
// 3.4.6 — EA Repository
// ============================================================

abstract class IEaRepository {
  /// Get all saved EA instances.
  Future<Either<Failure, List<EaInstanceEntity>>> getAllEaInstances();

  /// Stream of all EA instances (live UI updates).
  Stream<List<EaInstanceEntity>> watchEaInstances();

  /// Save a new EA configuration.
  Future<Either<Failure, EaInstanceEntity>> saveEaInstance(
      EaInstanceEntity ea);

  /// Update an existing EA configuration.
  Future<Either<Failure, Unit>> updateEaInstance(EaInstanceEntity ea);

  /// Delete an EA instance and its logs.
  Future<Either<Failure, Unit>> deleteEaInstance(int id);

  /// Start a specific EA instance.
  Future<Either<Failure, Unit>> startEa(int id);

  /// Stop a specific EA instance.
  Future<Either<Failure, Unit>> stopEa(int id);

  /// Get logs for an EA instance.
  Future<Either<Failure, List<EaLogEntity>>> getEaLogs(int eaInstanceId,
      {int limit});

  /// Stream of EA logs — live log viewer.
  Stream<List<EaLogEntity>> watchEaLogs(int eaInstanceId);

  /// Clear logs for an EA instance.
  Future<Either<Failure, Unit>> clearEaLogs(int eaInstanceId);

  /// Upload a .py script file and register it as an EA.
  Future<Either<Failure, String>> uploadEaScript({
    required String sourcePath,
    required String eaName,
  });
}

// ============================================================
// 3.4.7 — Supporting Entities (for repository return types)
// ============================================================

class TradeSummaryEntity extends Equatable {
  final double totalNetProfit;
  final double totalRealizedPnl;
  final double totalSwap;
  final double totalCommission;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double winRate;
  final double averageProfit;
  final double averageLoss;
  final double profitFactor;
  final double largestWin;
  final double largestLoss;

  const TradeSummaryEntity({
    required this.totalNetProfit,
    required this.totalRealizedPnl,
    required this.totalSwap,
    required this.totalCommission,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.winRate,
    required this.averageProfit,
    required this.averageLoss,
    required this.profitFactor,
    required this.largestWin,
    required this.largestLoss,
  });

  static const TradeSummaryEntity empty = TradeSummaryEntity(
    totalNetProfit: 0, totalRealizedPnl: 0, totalSwap: 0,
    totalCommission: 0, totalTrades: 0, winningTrades: 0,
    losingTrades: 0, winRate: 0, averageProfit: 0,
    averageLoss: 0, profitFactor: 0, largestWin: 0, largestLoss: 0,
  );

  @override
  List<Object?> get props => [totalNetProfit, totalTrades, winRate];
}

class DailyPnlEntity extends Equatable {
  final String date;       // "YYYY-MM-DD"
  final double netProfit;
  final int tradeCount;
  final bool isProfit;

  const DailyPnlEntity({
    required this.date,
    required this.netProfit,
    required this.tradeCount,
  }) : isProfit = netProfit >= 0;

  @override
  List<Object?> get props => [date, netProfit];
}

