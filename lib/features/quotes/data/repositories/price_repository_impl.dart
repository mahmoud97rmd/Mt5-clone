// Path: lib/features/quotes/data/repositories/price_repository_impl.dart
// ============================================================
// MT5 Clone — Price Repository Implementation
// Implements IPriceRepository using OandaStreamingService
// and OandaRestDataSource for snapshot fallback.
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/tick_entity.dart';
import '../../../../core/domain/failures/failures.dart';
import '../../../../core/domain/repositories/repositories.dart';
import '../../../trading/data/datasources/oanda_rest_datasource.dart';
import '../../../trading/data/mappers/oanda_mappers.dart';
import '../datasources/oanda_streaming_service.dart';
import '../models/stream_dto.dart';

class PriceRepositoryImpl implements IPriceRepository {
  final OandaStreamingService _streamingService;
  final OandaRestDataSource _restDataSource;

  PriceRepositoryImpl({
    required OandaStreamingService streamingService,
    required OandaRestDataSource restDataSource,
  })  : _streamingService = streamingService,
        _restDataSource = restDataSource;

  // ============================================================
  // 5.4.1 — Stream Operations
  // ============================================================

  @override
  Stream<Either<Failure, TickEntity>> watchTick(String symbol) {
    return _streamingService
        .watchSymbol(symbol)
        .map<Either<Failure, TickEntity>>(Right.new)
        .handleError((Object error) => Left(_mapError(error)));
  }

  @override
  TickEntity? getCachedTick(String symbol) {
    return _streamingService.getLatestTick(symbol);
  }

  @override
  bool get isStreaming => _streamingService.isConnected;

  @override
  Stream<bool> get streamConnectionState => _streamingService
      .connectionState
      .map((s) => s == StreamConnectionState.connected);

  // ============================================================
  // 5.4.2 — Start / Stop Streaming
  // ============================================================

  @override
  Future<Either<Failure, Unit>> startStreaming(
      List<String> symbols) async {
    try {
      await _streamingService.connect(symbols);
      return const Right(unit);
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> stopStreaming() async {
    try {
      await _streamingService.disconnect();
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(originalError: e));
    }
  }

  // ============================================================
  // 5.4.3 — Historical Tick Data (REST fallback)
  // ============================================================

  @override
  Future<Either<Failure, List<TickEntity>>> getTickHistory({
    required String symbol,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      // Fetch from local SQLite first
      final ticks =
          await _ticksDaoFallback(symbol: symbol, from: from, to: to);
      if (ticks.isNotEmpty) return Right(ticks);

      // Fallback: fetch REST pricing snapshot (no historical tick API in OANDA v20)
      final response = await _restDataSource.getPricing(
        instruments: [symbol],
      );

      final entities = response.prices
          .map((p) => TickMapper.fromPriceDto(p))
          .toList();

      return Right(entities);
    } on DioException catch (e) {
      if (e.error is Failure) return Left(e.error as Failure);
      return Left(NetworkFailure(originalError: e));
    } catch (e) {
      return Left(UnexpectedFailure(originalError: e));
    }
  }

  // ============================================================
  // 5.4.4 — Private Helpers
  // ============================================================

  /// Attempt to load tick history from local SQLite cache.
  Future<List<TickEntity>> _ticksDaoFallback({
    required String symbol,
    required DateTime from,
    required DateTime to,
  }) async {
    // This would use ticksDao — simplified here
    return [];
  }

  Failure _mapError(Object error) {
    if (error is DioException) {
      if (error.error is Failure) return error.error as Failure;
      if (error.type == DioExceptionType.connectionError) {
        return NetworkFailure(originalError: error);
      }
    }
    return UnexpectedFailure(
      message: error.toString(),
      originalError: error,
    );
  }
}

// ============================================================
// 5.4.5 — Riverpod Provider
// ============================================================

final priceRepositoryProvider = Provider<IPriceRepository>((ref) {
  return PriceRepositoryImpl(
    streamingService: ref.watch(oandaStreamingServiceProvider),
    restDataSource: ref.watch(oandaRestDataSourceProvider),
  );
});
