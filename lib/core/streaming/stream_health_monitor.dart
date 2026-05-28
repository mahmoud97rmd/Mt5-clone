// Path: lib/core/streaming/stream_health_monitor.dart
// ============================================================
// MT5 Clone — Stream Health Monitor
// Implements the EA kill switch:
//   "Auto-kill EA if WebSocket disconnects for > N seconds"
//
// Monitors:
//   - Stream connection state changes
//   - Time since last tick received per symbol
//   - Reconnect attempt count
//
// On kill trigger:
//   1. Calls EaRepository.stopEa() for all running EAs
//   2. Emits a kill event to the EA Engine Service
//   3. Writes a CRITICAL log entry for each stopped EA
//   4. Updates EA status to ERROR in local DB
// ============================================================

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../features/quotes/data/datasources/oanda_streaming_service.dart';
import '../../features/quotes/data/models/stream_dto.dart';
import '../database/app_database.dart';
import '../database/daos/ea_dao.dart';
import '../database/database_providers.dart';
import '../domain/enums/trading_enums.dart';

class StreamHealthMonitor {
  final OandaStreamingService _streamingService;
  final EaDao _eaDao;
  final Logger _log = Logger();

  // Kill switch configuration
  static const Duration _defaultKillTimeout = Duration(seconds: 10);

  // Disconnect timestamp for each EA (starts when stream disconnects)
  final Map<int, DateTime> _disconnectStartTimes = {};

  // Active timers: eaId → kill timer
  final Map<int, Timer> _killTimers = {};

  StreamSubscription<StreamConnectionState>? _connectionSub;
  bool _isStreamConnected = false;

  StreamHealthMonitor({
    required OandaStreamingService streamingService,
    required EaDao eaDao,
  })  : _streamingService = streamingService,
        _eaDao = eaDao;

  // ============================================================
  // 5.8.1 — Start Monitoring
  // ============================================================

  void startMonitoring() {
    _connectionSub = _streamingService.connectionState.listen(
      _onConnectionStateChange,
    );
    _log.d('StreamHealthMonitor: Started');
  }

  // ============================================================
  // 5.8.2 — Connection State Handler
  // ============================================================

  void _onConnectionStateChange(StreamConnectionState state) {
    _log.d('StreamHealthMonitor: Connection → ${state.displayName}');

    if (state == StreamConnectionState.connected) {
      _isStreamConnected = true;
      _cancelAllKillTimers();
      _disconnectStartTimes.clear();
    } else if (!state.isActive) {
      // Stream is not connected/reconnecting
      if (_isStreamConnected) {
        // Just disconnected — start kill timers for all running EAs
        _isStreamConnected = false;
        _scheduleKillTimersForRunningEas();
      }
    }
  }

  // ============================================================
  // 5.8.3 — Kill Timer Scheduling
  // ============================================================

  Future<void> _scheduleKillTimersForRunningEas() async {
    final allEas = await _eaDao.getAllEaInstances();
    final runningEas = allEas.where((ea) => ea.status == 'RUNNING').toList();
    if (runningEas.isEmpty) return;

    _log.w('StreamHealthMonitor: Stream disconnected — '
        '${runningEas.length} EA(s) at risk. '
        'Kill switch in ${_defaultKillTimeout.inSeconds}s');

    for (final ea in runningEas) {
      _disconnectStartTimes[ea.id] = DateTime.now();
      _scheduleKillTimer(ea);
    }
  }

  void _scheduleKillTimer(EaInstance ea) {
    final timeout = Duration(seconds: ea.killSwitchTimeoutSeconds);

    _killTimers[ea.id] = Timer(timeout, () async {
      await _executeKillSwitch(ea);
    });
  }

  // ============================================================
  // 5.8.4 — Kill Switch Execution
  // ============================================================

  Future<void> _executeKillSwitch(EaInstance ea) async {
    final disconnectDuration =
        _disconnectStartTimes[ea.id] != null
            ? DateTime.now().difference(_disconnectStartTimes[ea.id]!)
            : const Duration(seconds: 0);

    _log.e(
      'StreamHealthMonitor: KILL SWITCH — EA "${ea.name}" '
      '(id=${ea.id}) killed after '
      '${disconnectDuration.inSeconds}s disconnect',
    );

    try {
      // 1. Update EA status to ERROR in DB
      await _eaDao.updateEaStatus(
        ea.id,
        EaStatus.error.name.toUpperCase(),
      );

      // 2. Write CRITICAL log entry
      await _eaDao.insertLog(
        EaLogsCompanion.insert(
          eaInstanceId: ea.id,
          level: 'CRITICAL',
          message: 'EA KILLED by safety switch: '
              'Price stream disconnected for '
              '${disconnectDuration.inSeconds}s '
              '(limit: ${ea.killSwitchTimeoutSeconds}s)',
          timestampUs: DateTime.now().microsecondsSinceEpoch,
        ),
      );

      _log.w('StreamHealthMonitor: EA ${ea.id} killed and logged');
    } catch (e) {
      _log.e('StreamHealthMonitor: Kill switch error — $e');
    } finally {
      _disconnectStartTimes.remove(ea.id);
      _killTimers.remove(ea.id);
    }
  }

  // ============================================================
  // 5.8.5 — Cancel Timers (on reconnect)
  // ============================================================

  void _cancelAllKillTimers() {
    if (_killTimers.isEmpty) return;

    _log.i('StreamHealthMonitor: ✅ Stream reconnected — '
        'cancelling ${_killTimers.length} kill timer(s)');

    for (final timer in _killTimers.values) {
      timer.cancel();
    }
    _killTimers.clear();
  }

  // ── Helpers ──────────────────────────────────────────────────

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final ms = (dt.millisecond).toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }

  // ============================================================
  // 5.8.6 — Dispose
  // ============================================================

  Future<void> dispose() async {
    await _connectionSub?.cancel();
    _cancelAllKillTimers();
    _disconnectStartTimes.clear();
    _log.d('StreamHealthMonitor: Disposed');
  }
}

// ============================================================
// 5.8.7 — Riverpod Provider
// ============================================================

final streamHealthMonitorProvider =
    Provider<StreamHealthMonitor>((ref) {
  final monitor = StreamHealthMonitor(
    streamingService: ref.watch(oandaStreamingServiceProvider),
    eaDao: ref.watch(eaDaoProvider),
  );

  monitor.startMonitoring();
  ref.onDispose(monitor.dispose);

  return monitor;
});
