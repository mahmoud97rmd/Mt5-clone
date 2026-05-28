// Path: lib/features/ea/data/repositories/ea_repository_impl.dart
// ============================================================
// MT5 Clone — EA Repository Implementation
// ============================================================

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:drift/drift.dart' show Value;

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/ea_dao.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/domain/entities/ea_entities.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/domain/failures/failures.dart';
import '../../../../core/domain/repositories/repositories.dart';

class EaRepositoryImpl implements IEaRepository {
  final EaDao _eaDao;
  static const _channel = MethodChannel('com.mt5clone/ea_engine');
  static const _logChannel = EventChannel('com.mt5clone/ea_log_events');

  EaRepositoryImpl({required EaDao eaDao}) : _eaDao = eaDao;

  @override
  Future<Either<Failure, List<EaInstanceEntity>>> getAllEaInstances() async {
    try {
      final instances = await _eaDao.getAllEaInstances();
      return Right(instances.map(_fromDb).toList());
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to load EAs: $e'));
    }
  }

  @override
  Stream<List<EaInstanceEntity>> watchEaInstances() {
    return _eaDao
        .watchAllEaInstances()
        .map((list) => list.map(_fromDb).toList());
  }

  @override
  Future<Either<Failure, EaInstanceEntity>> saveEaInstance(
      EaInstanceEntity ea) async {
    try {
      final id = await _eaDao.insertEaInstance(
        EaInstancesCompanion.insert(
          name: ea.name,
          symbol: ea.symbol,
          scriptPath: ea.scriptPath,
          magicNumber: ea.magicNumber,
          lotSize: Value(ea.lotSize),
          maxPositions: Value(ea.maxPositions),
          killSwitchTimeoutSeconds: Value(ea.killSwitchTimeoutSeconds),
          dailyLossLimit: Value(ea.dailyLossLimit),
          autoStartOnBoot: Value(ea.autoStartOnBoot),
          status: Value(ea.status.displayName.toUpperCase()),
          createdAtUs: ea.createdAt.microsecondsSinceEpoch,
          customParams: Value(jsonEncode(ea.customParams)),
        ),
      );
      return Right(ea.copyWith(id: id));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to save EA: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateEaInstance(EaInstanceEntity ea) async {
    try {
      if (ea.id == null) return const Left(UnexpectedFailure(message: 'EA has no ID'));
      await _eaDao.updateEaStatus(ea.id!, ea.status.displayName.toUpperCase());
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to update EA: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEaInstance(int id) async {
    try {
      await _eaDao.deleteEaInstance(id);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to delete EA: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> startEa(int id) async {
    try {
      await _channel.invokeMethod('startEa', {'eaId': id});
      await _eaDao.updateEaStatus(id, 'RUNNING');
      return const Right(unit);
    } catch (e) {
      return Left(EaRuntimeFailure(message: 'Failed to start EA: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> stopEa(int id) async {
    try {
      await _channel.invokeMethod('stopEa', {'eaId': id});
      await _eaDao.updateEaStatus(id, 'STOPPED');
      return const Right(unit);
    } catch (e) {
      return Left(EaRuntimeFailure(message: 'Failed to stop EA: $e'));
    }
  }

  @override
  Future<Either<Failure, List<EaLogEntity>>> getEaLogs(int eaInstanceId,
      {int limit = 500}) async {
    try {
      final logs = await _eaDao.getLogs(eaInstanceId, limit: limit);
      return Right(logs.map(_logFromDb).toList());
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to load logs: $e'));
    }
  }

  @override
  Stream<List<EaLogEntity>> watchEaLogs(int eaInstanceId) {
    return _eaDao
        .watchLogs(eaInstanceId)
        .map((list) => list.map(_logFromDb).toList());
  }

  @override
  Future<Either<Failure, Unit>> clearEaLogs(int eaInstanceId) async {
    try {
      await _eaDao.clearLogs(eaInstanceId);
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to clear logs: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadEaScript({
    required String sourcePath,
    required String eaName,
  }) async {
    try {
      final dir = await getApplicationSupportDirectory();
      final eaDir = Directory('${dir.path}/ea_scripts');
      if (!await eaDir.exists()) {
        await eaDir.create(recursive: true);
      }

      final sourceFile = File(sourcePath);
      final destPath = '${eaDir.path}/$eaName.py';
      await sourceFile.copy(destPath);

      return Right(destPath);
    } catch (e) {
      return Left(EaLoadFailure(message: 'Failed to upload script: $e'));
    }
  }

  EaInstanceEntity _fromDb(dynamic dbRow) {
    return EaInstanceEntity(
      id: dbRow.id,
      name: dbRow.name,
      symbol: dbRow.symbol,
      scriptPath: dbRow.scriptPath,
      magicNumber: dbRow.magicNumber,
      lotSize: dbRow.lotSize,
      maxPositions: dbRow.maxPositions,
      killSwitchTimeoutSeconds: dbRow.killSwitchTimeoutSeconds,
      dailyLossLimit: dbRow.dailyLossLimit,
      autoStartOnBoot: dbRow.autoStartOnBoot,
      status: EaStatus.fromString(dbRow.status),
      createdAt: DateTime.fromMicrosecondsSinceEpoch(dbRow.createdAtUs),
      lastStartedAt: dbRow.lastStartedAtUs != null
          ? DateTime.fromMicrosecondsSinceEpoch(dbRow.lastStartedAtUs!)
          : null,
      lastStoppedAt: dbRow.lastStoppedAtUs != null
          ? DateTime.fromMicrosecondsSinceEpoch(dbRow.lastStoppedAtUs!)
          : null,
      totalTrades: dbRow.totalTrades,
      netPnl: dbRow.netPnl,
      winRate: dbRow.winRate,
      customParams: Map<String, String>.from(
          jsonDecode(dbRow.customParams) as Map),
    );
  }

  EaLogEntity _logFromDb(dynamic dbRow) {
    return EaLogEntity(
      id: dbRow.id,
      eaInstanceId: dbRow.eaInstanceId,
      level: dbRow.level,
      source: dbRow.source,
      message: dbRow.message,
      timestamp: DateTime.fromMicrosecondsSinceEpoch(dbRow.timestampUs),
    );
  }
}

final eaRepositoryProvider = Provider<IEaRepository>((ref) {
  return EaRepositoryImpl(
    eaDao: ref.watch(eaDaoProvider),
  );
});
