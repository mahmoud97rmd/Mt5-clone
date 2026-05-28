// Path: lib/features/history/data/repositories/history_repository_impl.dart
// ============================================================
// MT5 Clone — History Repository Implementation
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/daos/history_dao.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/domain/entities/closed_trade_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/domain/failures/failures.dart';
import '../../../../core/domain/repositories/repositories.dart';
import '../../../trading/data/datasources/oanda_rest_datasource.dart';
import '../../../trading/data/mappers/oanda_mappers.dart';

class HistoryRepositoryImpl implements IHistoryRepository {
  final HistoryDao _historyDao;
  final OandaRestDataSource _restDataSource;

  HistoryRepositoryImpl({
    required HistoryDao historyDao,
    required OandaRestDataSource restDataSource,
  })  : _historyDao = historyDao,
        _restDataSource = restDataSource;

  @override
  Future<Either<Failure, List<ClosedTradeEntity>>> getClosedTrades({
    required DateTime from,
    required DateTime to,
    String? symbol,
    int? magicNumber,
    TradeDirection? direction,
  }) async {
    try {
      final trades = await _historyDao.getTradesInRange(
        from: from,
        to: to,
        symbol: symbol,
        magicNumber: magicNumber,
        direction: direction?.displayName,
      );
      return Right(trades.map(ClosedTradeMapper.fromDb).toList());
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to load history: $e'));
    }
  }

  @override
  Stream<List<ClosedTradeEntity>> watchRecentTrades({int limit = 50}) {
    return _historyDao
        .watchRecentTrades(limit: limit)
        .map((rows) => rows.map(ClosedTradeMapper.fromDb).toList());
  }

  @override
  Future<Either<Failure, List<ClosedTradeEntity>>> syncHistory({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final result = await _restDataSource.getTransactions(
        fromTime: from.toUtc().toIso8601String(),
        toTime: to.toUtc().toIso8601String(),
      );

      final entities = <ClosedTradeEntity>[];
      for (final tx in result.transactions) {
        if (tx.type == 'ORDER_FILL' && tx.tradeID != null) {
          final tradeEntities = ClosedTradeMapper.fromTransactionDto(tx);
          for (final entity in tradeEntities) {
            entities.add(entity);
            await _historyDao.insertClosedTrade(entity.toCompanion());
          }
        }
      }

      return Right(entities);
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to sync history: $e'));
    }
  }

  @override
  Future<Either<Failure, TradeSummaryEntity>> getTradeSummary({
    required DateTime from,
    required DateTime to,
    String? symbol,
    int? magicNumber,
  }) async {
    try {
      final summary = await _historyDao.getSummaryForRange(
        from: from,
        to: to,
        symbol: symbol,
        magicNumber: magicNumber,
      );
      return Right(TradeSummaryEntity(
        totalNetProfit: summary.totalNetProfit,
        totalRealizedPnl: summary.totalRealizedPnl,
        totalSwap: summary.totalSwap,
        totalCommission: summary.totalCommission,
        totalTrades: summary.totalTrades,
        winningTrades: summary.winningTrades,
        losingTrades: summary.losingTrades,
        winRate: summary.winRate,
        averageProfit: summary.averageProfit,
        averageLoss: summary.averageLoss,
        profitFactor: summary.profitFactor,
        largestWin: summary.largestWin,
        largestLoss: summary.largestLoss,
      ));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get summary: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DailyPnlEntity>>> getDailyPnl({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final daily = await _historyDao.getDailyPnlBreakdown(
        from: from,
        to: to,
      );
      return Right(daily
          .map((r) => DailyPnlEntity(
                date: r.date,
                netProfit: r.netProfit,
                tradeCount: r.tradeCount,
              ))
          .toList());
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to get daily PnL: $e'));
    }
  }
}

final historyRepositoryProvider = Provider<IHistoryRepository>((ref) {
  return HistoryRepositoryImpl(
    historyDao: ref.watch(historyDaoProvider),
    restDataSource: ref.watch(oandaRestDataSourceProvider),
  );
});
