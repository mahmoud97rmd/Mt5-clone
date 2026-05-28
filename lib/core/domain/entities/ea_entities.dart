// Path: lib/core/domain/entities/ea_entities.dart
// ============================================================
// MT5 Clone — EA Domain Entities
// Expert Advisor instance and log entry entities.
// ============================================================

import 'package:equatable/equatable.dart';

import '../enums/trading_enums.dart';

class EaInstanceEntity extends Equatable {
  final int? id;
  final String name;
  final String symbol;
  final String scriptPath;
  final int magicNumber;
  final double lotSize;
  final int maxPositions;
  final int killSwitchTimeoutSeconds;
  final double? dailyLossLimit;
  final bool autoStartOnBoot;
  final EaStatus status;
  final DateTime createdAt;
  final DateTime? lastStartedAt;
  final DateTime? lastStoppedAt;
  final int totalTrades;
  final double netPnl;
  final double winRate;
  final Map<String, String> customParams;

  const EaInstanceEntity({
    this.id,
    required this.name,
    required this.symbol,
    required this.scriptPath,
    required this.magicNumber,
    this.lotSize = 0.01,
    this.maxPositions = 1,
    this.killSwitchTimeoutSeconds = 10,
    this.dailyLossLimit,
    this.autoStartOnBoot = false,
    this.status = EaStatus.stopped,
    required this.createdAt,
    this.lastStartedAt,
    this.lastStoppedAt,
    this.totalTrades = 0,
    this.netPnl = 0.0,
    this.winRate = 0.0,
    this.customParams = const {},
  });

  bool get isRunning => status == EaStatus.running;
  bool get isStopped => status == EaStatus.stopped;
  bool get hasError => status == EaStatus.error;

  EaInstanceEntity copyWith({
    int? id,
    String? name,
    String? symbol,
    String? scriptPath,
    int? magicNumber,
    double? lotSize,
    int? maxPositions,
    int? killSwitchTimeoutSeconds,
    double? dailyLossLimit,
    bool? autoStartOnBoot,
    EaStatus? status,
    DateTime? createdAt,
    DateTime? lastStartedAt,
    DateTime? lastStoppedAt,
    int? totalTrades,
    double? netPnl,
    double? winRate,
    Map<String, String>? customParams,
  }) {
    return EaInstanceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      scriptPath: scriptPath ?? this.scriptPath,
      magicNumber: magicNumber ?? this.magicNumber,
      lotSize: lotSize ?? this.lotSize,
      maxPositions: maxPositions ?? this.maxPositions,
      killSwitchTimeoutSeconds: killSwitchTimeoutSeconds ?? this.killSwitchTimeoutSeconds,
      dailyLossLimit: dailyLossLimit ?? this.dailyLossLimit,
      autoStartOnBoot: autoStartOnBoot ?? this.autoStartOnBoot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastStartedAt: lastStartedAt ?? this.lastStartedAt,
      lastStoppedAt: lastStoppedAt ?? this.lastStoppedAt,
      totalTrades: totalTrades ?? this.totalTrades,
      netPnl: netPnl ?? this.netPnl,
      winRate: winRate ?? this.winRate,
      customParams: customParams ?? this.customParams,
    );
  }

  @override
  List<Object?> get props => [id, name, symbol, status, magicNumber];
}

class EaLogEntity extends Equatable {
  final int? id;
  final int eaInstanceId;
  final String level;
  final String source;
  final String message;
  final DateTime timestamp;

  const EaLogEntity({
    this.id,
    required this.eaInstanceId,
    required this.level,
    this.source = 'PYTHON',
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, eaInstanceId, level, message, timestamp];
}
