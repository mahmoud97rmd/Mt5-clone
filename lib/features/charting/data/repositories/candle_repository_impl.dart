// Path: lib/features/charting/data/repositories/candle_repository_impl.dart
// ============================================================
// MT5 Clone — Candle Repository Implementation
// Cache-first candle loading: SQLite → OANDA REST fallback.
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/candles_dao.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/domain/entities/candle_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/domain/failures/failures.dart';
import '../../../../core/domain/repositories/repositories.dart';
import '../../../trading/data/datasources/oanda_rest_datasource.dart';
import '../../../trading/data/mappers/oanda_mappers.dart';

class CandleRepositoryImpl implements ICandleRepository {
  final CandlesDao _candlesDao;
  final OandaRestDataSource _restDataSource;

  CandleRepositoryImpl({
    required CandlesDao candlesDao,
    required OandaRestDataSource restDataSource,
  })  : _candlesDao = candlesDao,
        _restDataSource = restDataSource;

  @override
  Future<Either<Failure, List<CandleEntity>>> getCandles({
    required String symbol,
    required Timeframe timeframe,
    int count = 200,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      // 1. Try cache first
      final cached = await _candlesDao.getRecentCandles(
        symbol: symbol,
        timeframe: timeframe.oandaName,
        limit: count,
      );

      if (cached.length >= (count * 0.8).round()) {
        return Right(cached.map(CandleMapper.fromDb).toList());
      }

      // 2. Fallback to OANDA REST API
      return await refreshCandles(
        symbol: symbol,
        timeframe: timeframe,
        count: count,
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to load candles: $e'));
    }
  }

  @override
  Stream<List<CandleEntity>> watchCandles({
    required String symbol,
    required Timeframe timeframe,
    int limit = 200,
  }) {
    return _candlesDao
        .watchCandles(
          symbol: symbol,
          timeframe: timeframe.oandaName,
          limit: limit,
        )
        .map((rows) => rows.map(CandleMapper.fromDb).toList());
  }

  @override
  Future<Either<Failure, List<CandleEntity>>> refreshCandles({
    required String symbol,
    required Timeframe timeframe,
    int count = 200,
  }) async {
    try {
      final result = await _restDataSource.getCandles(
        instrument: symbol,
        granularity: timeframe.oandaName,
        count: count,
      );

      // Map and save to local DB
      final entities = <CandleEntity>[];
      for (final dto in result.candles) {
        final entity = CandleMapper.fromDto(
            dto: dto, symbol: symbol, timeframe: timeframe);
        entities.add(entity);
        await _candlesDao.upsertCandle(CandlesCompanion(
          symbol: Value(symbol),
          timeframe: Value(timeframe.oandaName),
          openTimeUs: Value(entity.openTime.microsecondsSinceEpoch),
          open: Value(entity.open),
          high: Value(entity.high),
          low: Value(entity.low),
          close: Value(entity.close),
          volume: Value(entity.volume),
          isComplete: Value(entity.isComplete),
        ));
      }

      return Right(entities);
    } catch (e) {
      return Left(NetworkFailure(message: 'Failed to fetch candles: $e'));
    }
  }
}

final candleRepositoryProvider = Provider<ICandleRepository>((ref) {
  return CandleRepositoryImpl(
    candlesDao: ref.watch(candlesDaoProvider),
    restDataSource: ref.watch(oandaRestDataSourceProvider),
  );
});
