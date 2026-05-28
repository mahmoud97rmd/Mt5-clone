// Path: lib/features/account/data/repositories/account_repository_impl.dart
// ============================================================
// MT5 Clone — Account Repository Implementation
// Implements IAccountRepository using:
//   - OandaRestDataSource for OANDA API calls
//   - AccountDao for local SQLite persistence
//   - AccountMathEngine for real-time state stream
//   - HiveCacheService for synchronous state reads
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drift/drift.dart' show Value;
import '../../../../core/database/app_database.dart' as db;
import '../../../../core/database/daos/account_dao.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/domain/entities/account_entity.dart';
import '../../../../core/domain/entities/symbol_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/domain/failures/failures.dart';
import '../../../../core/domain/repositories/repositories.dart';
import '../../../../core/engine/account_math_engine.dart';
import '../../../../core/security/credential_storage.dart';

import '../datasources/account_remote_datasource.dart';
import '../mappers/account_mapper.dart';

class AccountRepositoryImpl implements IAccountRepository {
  final AccountRemoteDataSource _remote;
  final AccountDao _accountDao;
  final AccountMathEngine _mathEngine;
  final CredentialStorage _credentials;

  AccountRepositoryImpl({
    required AccountRemoteDataSource remote,
    required AccountDao accountDao,
    required AccountMathEngine mathEngine,
    required CredentialStorage credentials,
  })  : _remote = remote,
        _accountDao = accountDao,
        _mathEngine = mathEngine,
        _credentials = credentials;

  // ============================================================
  // 6.2.1 — Get & Sync Account
  // ============================================================

  @override
  Future<Either<Failure, AccountEntity>> getAccount() async {
    return _guard(() async {
      final dto = await _remote.getAccountSummary();
      final isLive = await _credentials.getIsLiveAccount();
      final entity = AccountDtoMapper.fromSummaryDto(dto, isLive: isLive);

      // Initialize math engine with base account data
      await _mathEngine.initialize(entity);

      // Save account metadata for offline use
      await _credentials.saveAccountMetadata(
        currency: entity.currency,
        alias: entity.alias,
      );

      // Write initial snapshot
      await _accountDao.insertSnapshot(
        _buildSnapshotCompanion(entity, trigger: 'SESSION_START'),
      );

      return Right(entity);
    });
  }

  // ============================================================
  // 6.2.2 — Live Account Stream
  // ============================================================

  @override
  Stream<AccountEntity> watchAccount() {
    return _mathEngine.accountStream;
  }

  // ============================================================
  // 6.2.3 — Instruments
  // ============================================================

  @override
  Future<Either<Failure, List<SymbolEntity>>> getInstruments() async {
    return _guard(() async {
      // Try local DB first
      final cached = await _accountDao.getAllSymbols();
      if (cached.isNotEmpty) {
        return Right(cached.map(_symbolFromDb).toList());
      }

      // Fetch from OANDA
      return _fetchAndStoreInstruments();
    });
  }

  Future<Either<Failure, List<SymbolEntity>>>
      _fetchAndStoreInstruments() async {
    final dtos = await _remote.getInstruments();
    final entities = dtos.map(InstrumentDtoMapper.toEntity).toList();

    // Persist to SQLite
    final companions = entities.map(_symbolToCompanion).toList();
    await _accountDao.upsertSymbols(companions);

    // Configure math engine with pip/unit data
    for (final entity in entities) {
      _mathEngine.setSymbolConfig(
        symbol: entity.name,
        pipSize: entity.pipSize,
        unitsPerLot: entity.unitsPerLot,
      );
    }

    return Right(entities);
  }

  // ============================================================
  // 6.2.4 — Watchlist
  // ============================================================

  @override
  Future<Either<Failure, List<SymbolEntity>>> getWatchlist() async {
    return _guard(() async {
      final symbols = await _accountDao.getWatchlistedSymbols();
      return Right(symbols.map(_symbolFromDb).toList());
    });
  }

  @override
  Stream<List<SymbolEntity>> watchWatchlist() {
    return _accountDao
        .watchWatchlistedSymbols()
        .map((rows) => rows.map(_symbolFromDb).toList());
  }

  @override
  Future<Either<Failure, Unit>> toggleWatchlist(
    String symbol,
    bool isWatchlisted,
  ) async {
    return _guard(() async {
      await _accountDao.toggleWatchlist(symbol, isWatchlisted);
      return const Right(unit);
    });
  }

  @override
  Future<Either<Failure, Unit>> reorderWatchlist(
    List<String> orderedSymbols,
  ) async {
    return _guard(() async {
      await _accountDao.reorderWatchlist(orderedSymbols);
      return const Right(unit);
    });
  }

  // ============================================================
  // 6.2.5 — Private Helpers
  // ============================================================

  Future<Either<Failure, T>> _guard<T>(
    Future<Either<Failure, T>> Function() call,
  ) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is Failure) return Left(e.error as Failure);
      return Left(NetworkFailure(originalError: e));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  db.AccountSnapshotsCompanion _buildSnapshotCompanion(
    AccountEntity entity, {
    required String trigger,
  }) {
    final now = DateTime.now();
    return db.AccountSnapshotsCompanion.insert(
      accountId: entity.accountId,
      balance: entity.balance,
      equity: entity.equity,
      marginUsed: entity.marginUsed,
      marginAvailable: entity.marginAvailable,
      marginLevel: Value(entity.marginLevel),
      nav: Value(entity.nav),
      openPositionCount: Value(entity.openPositionCount),
      unrealizedPnl: Value(entity.unrealizedPnl),
      dailyRealizedPnl: Value(entity.dailyRealizedPnl),
      snapshotTrigger: Value(trigger),
      timestampUs: now.microsecondsSinceEpoch,
      date: now.toIso8601String().substring(0, 10),
    );
  }

  SymbolEntity _symbolFromDb(db.Symbol row) {
    final pipSize = _pipSizeFromLocation(row.pipLocation);
    return SymbolEntity(
      name: row.name,
      displayName: row.displayName,
      displayLabel: row.displayExPrecision ?? row.name.replaceAll('_', ''),
      type: InstrumentType.fromString(row.type),
      pipSize: pipSize,
      pipLocation: row.pipLocation,
      displayPrecision: row.displayPrecision,
      minimumTradeSize: row.minimumTradeSize,
      marginRate: row.marginRate,
      tradeUnitsPrecision: row.tradeUnitsPrecision,
      isWatchlisted: row.isWatchlisted,
      watchlistSortOrder: row.watchlistSortOrder,
    );
  }

  double _pipSizeFromLocation(int pipLocation) {
    double size = 1.0;
    for (int i = 0; i < -pipLocation; i++) size /= 10.0;
    return size;
  }

  db.SymbolsCompanion _symbolToCompanion(SymbolEntity e) =>
      db.SymbolsCompanion.insert(
        name: e.name,
        displayName: e.displayName,
        displayExPrecision: Value(e.displayLabel),
        type: e.type.name.toUpperCase(),
        pipSize: e.pipSize,
        pipLocation: e.pipLocation,
        displayPrecision: Value(e.displayPrecision),
        minimumTradeSize: Value(e.minimumTradeSize),
        marginRate: Value(e.marginRate),
        tradeUnitsPrecision: Value(e.tradeUnitsPrecision),
        isWatchlisted: Value(e.isWatchlisted),
        watchlistSortOrder: Value(e.watchlistSortOrder),
        lastUpdatedUs: Value(DateTime.now().microsecondsSinceEpoch),
      );
}

// ============================================================
// Riverpod Provider
// ============================================================

final accountRepositoryProvider =
    Provider<IAccountRepository>((ref) {
  return AccountRepositoryImpl(
    remote: ref.watch(accountRemoteDataSourceProvider),
    accountDao: ref.watch(accountDaoProvider),
    mathEngine: ref.watch(accountMathEngineProvider),
    credentials: ref.watch(credentialStorageProvider),
  );
});
