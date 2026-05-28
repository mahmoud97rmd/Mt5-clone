// Path: lib/features/quotes/data/datasources/oanda_streaming_service.dart
// ============================================================
// MT5 Clone — OANDA HTTP Streaming Service
// Manages the long-lived HTTP streaming connection to OANDA.
//
// ⭐ OANDA uses HTTP/1.1 chunked streaming (NOT WebSocket).
//    The connection is a standard GET request that never closes.
//    Each chunk is a newline-terminated JSON line (NDJSON).
//
// Architecture:
//   OandaStreamingService
//     ├── _ConnectionStateMachine  (tracks state transitions)
//     ├── OandaStreamParser        (bytes → DTOs)
//     ├── TickAssembler            (DTOs → TickEntities)
//     ├── _HeartbeatMonitor        (detects stale stream)
//     └── _ReconnectScheduler      (exponential backoff)
//
// Stream lifecycle:
//   connect() → _connecting → _connected (streaming ticks)
//              ↓ on error/timeout
//           _reconnecting → (retry with backoff)
//              ↓ on maxRetries or killSwitch
//           _killed / _error
// ============================================================

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/ticks_dao.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/database/hive_cache_service.dart';
import '../../../../core/database/tables/ticks_table.dart';
import '../../../../core/domain/entities/tick_entity.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/client/dio_client.dart';
import '../../../../core/security/credential_storage.dart';
import '../models/stream_dto.dart';
import 'stream_parser.dart';

// ============================================================
// 5.3.1 — Streaming Service Core
// ============================================================

class OandaStreamingService {
  final Dio _dio;
  final CredentialStorage _credentials;
  final TicksDao _ticksDao;
  final Logger _log = Logger();

  // ── State ─────────────────────────────────────────────────
  final _connectionState = BehaviorSubject<StreamConnectionState>.seeded(
    StreamConnectionState.disconnected,
  );

  // ── Tick Broadcast Stream ──────────────────────────────────
  // BehaviorSubject emits last tick on subscribe (for late UI subscribers)
  final _tickController = BehaviorSubject<TickEntity>();

  // Per-symbol latest tick subjects for O(1) latest-price access
  final Map<String, BehaviorSubject<TickEntity>> _symbolSubjects = {};

  // ── Internal State ─────────────────────────────────────────
  CancelToken? _cancelToken;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  StreamSubscription<StreamMessageDto>? _streamSubscription;

  List<String> _subscribedSymbols = [];
  bool _isKilled = false;
  int _reconnectAttempts = 0;
  DateTime? _lastHeartbeatAt;

  final OandaStreamParser _parser = OandaStreamParser();
  late final TickAssembler _assembler;

  // ── Constants ──────────────────────────────────────────────
  static const Duration _heartbeatTimeout = Duration(seconds: 15);
  static const Duration _initialReconnectDelay = Duration(seconds: 2);
  static const Duration _maxReconnectDelay = Duration(seconds: 60);
  static const int _maxReconnectAttempts = 20;

  OandaStreamingService({
    required Dio dio,
    required CredentialStorage credentials,
    required TicksDao ticksDao,
    Map<String, int>? pipLocations,
  })  : _dio = dio,
        _credentials = credentials,
        _ticksDao = ticksDao {
    _assembler = TickAssembler(pipLocations: pipLocations);
  }

  // ============================================================
  // 5.3.2 — Public API
  // ============================================================

  /// Stream of ALL tick updates across all subscribed symbols.
  Stream<TickEntity> get tickStream => _tickController.stream;

  /// Stream of connection state changes.
  Stream<StreamConnectionState> get connectionState =>
      _connectionState.stream;

  /// Current connection state (synchronous).
  StreamConnectionState get currentState => _connectionState.value;

  /// Whether the stream is currently receiving data.
  bool get isConnected =>
      _connectionState.value == StreamConnectionState.connected;

  /// Watch ticks for a specific symbol only.
  Stream<TickEntity> watchSymbol(String symbol) {
    _symbolSubjects.putIfAbsent(
      symbol,
      () => BehaviorSubject<TickEntity>(),
    );
    return _symbolSubjects[symbol]!.stream;
  }

  /// Latest tick for a symbol (synchronous from Hive cache).
  TickEntity? getLatestTick(String symbol) {
    final cached = HiveCacheService.getLatestTick(symbol);
    if (cached == null) return null;
    return TickEntity(
      symbol: symbol,
      bid: cached['bid'] as double,
      ask: cached['ask'] as double,
      spread: cached['spread'] as double,
      timestamp: DateTime.fromMicrosecondsSinceEpoch(
          cached['timestampUs'] as int),
    );
  }

  // ============================================================
  // 5.3.3 — Connection Lifecycle
  // ============================================================

  /// Start streaming prices for the given symbols.
  Future<void> connect(List<String> symbols) async {
    if (symbols.isEmpty) {
      _log.w('StreamingService: connect() called with empty symbol list');
      return;
    }
    if (_isKilled) {
      _log.e('StreamingService: Cannot reconnect — stream was killed');
      return;
    }

    _subscribedSymbols = symbols;
    _reconnectAttempts = 0;
    await _openStream();
  }

  /// Disconnect and stop the stream permanently.
  Future<void> disconnect() async {
    _log.i('StreamingService: Disconnecting...');
    _isKilled = false; // allow reconnect if needed later
    await _cleanupConnection();
    _setState(StreamConnectionState.disconnected);
  }

  /// Emergency kill — stops stream and prevents any reconnection.
  /// Called by the EA kill switch or on account logout.
  Future<void> kill({String reason = 'manual'}) async {
    _log.w('StreamingService: KILLED — reason: $reason');
    _isKilled = true;
    await _cleanupConnection();
    _setState(StreamConnectionState.killed);
  }

  /// Update the pip location for a symbol (improves spread calculation).
  void updatePipLocation(String symbol, int pipLocation) {
    _assembler.updatePipLocation(symbol, pipLocation);
  }

  // ============================================================
  // 5.3.4 — Internal: Open HTTP Stream
  // ============================================================

  Future<void> _openStream() async {
    if (_isKilled) return;

    _setState(StreamConnectionState.connecting);
    _cancelToken = CancelToken();
    _parser.reset();

    try {
      final accountId = await _credentials.getAccountId();
      if (accountId == null) {
        _log.e('StreamingService: Account ID not configured');
        _setState(StreamConnectionState.error);
        return;
      }

      final path = OandaApiConstants.pricingStream(accountId);
      final instruments = _subscribedSymbols.join(',');

      _log.i('StreamingService: Opening stream for [$instruments]');

      // ── Open long-lived streaming GET request ──────────────
      final response = await _dio.get<ResponseBody>(
        path,
        queryParameters: {
          'instruments': instruments,
          'snapshot': true, // emit current price on connect
        },
        options: Options(responseType: ResponseType.stream),
        cancelToken: _cancelToken,
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Stream returned HTTP ${response.statusCode}',
        );
      }

      _setState(StreamConnectionState.connected);
      _reconnectAttempts = 0;
      _startHeartbeatMonitor();

      // ── Subscribe to the raw byte stream ──────────────────
      final byteStream = response.data!.stream;

      final Stream<List<int>> typedByteStream = byteStream;

      _streamSubscription = typedByteStream
          .transform(_parser.transformer)
          .listen(
            _onStreamMessage,
            onError: _onStreamError,
            onDone: _onStreamDone,
            cancelOnError: false, // keep listening even on single errors
          );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        _log.d('StreamingService: Stream cancelled (expected)');
        return;
      }
      _log.e('StreamingService: Connection error — ${e.message}');
      _scheduleReconnect();
    } catch (e, st) {
      _log.e('StreamingService: Unexpected error', error: e, stackTrace: st);
      _scheduleReconnect();
    }
  }

  // ============================================================
  // 5.3.5 — Internal: Message Handler
  // ============================================================

  void _onStreamMessage(StreamMessageDto msg) {
    switch (msg) {
      // ── Price Tick ─────────────────────────────────────────
      case final StreamPriceDto price:
        _resetHeartbeatTimer(); // price counts as heartbeat

        if (!price.isTradeable) {
          // Market is closed or instrument unavailable — skip
          return;
        }

        final tick = _assembler.assemble(price);
        _dispatchTick(tick);

      // ── Heartbeat ──────────────────────────────────────────
      case final StreamHeartbeatDto heartbeat:
        _lastHeartbeatAt = heartbeat.dateTime;
        _resetHeartbeatTimer();
        _log.d('StreamingService: ♥ Heartbeat @ ${heartbeat.rawTime}');

      // ── Unknown ────────────────────────────────────────────
      case final StreamUnknownDto unknown:
        _log.d('StreamingService: Unknown message type: ${unknown.rawType}');
    }
  }

  // ============================================================
  // 5.3.6 — Internal: Tick Dispatch & Persistence
  // ============================================================

  void _dispatchTick(TickEntity tick) {
    // 1. Broadcast to all-symbols stream
    _tickController.add(tick);

    // 2. Broadcast to per-symbol stream
    _symbolSubjects
        .putIfAbsent(tick.symbol, () => BehaviorSubject<TickEntity>())
        .add(tick);

    // 3. Write to Hive cache (sync, O(1))
    HiveCacheService.cacheTick(
      symbol: tick.symbol,
      bid: tick.bid,
      ask: tick.ask,
      spread: tick.spread,
      timestampUs: tick.timestamp.microsecondsSinceEpoch,
    );

    // 4. Persist to SQLite asynchronously (non-blocking)
    _persistTick(tick);
  }

  Future<void> _persistTick(TickEntity tick) async {
    try {
      await _ticksDao.insertTick(
        TicksCompanion.insert(
          symbol: tick.symbol,
          bid: tick.bid,
          ask: tick.ask,
          spread: tick.spread,
          timestampUs: tick.timestamp.microsecondsSinceEpoch,
        ),
      );
    } catch (e) {
      // Tick persistence failure should never crash the stream
      _log.w('StreamingService: Tick persist error — $e');
    }
  }

  // ============================================================
  // 5.3.7 — Internal: Error & Done Handlers
  // ============================================================

  void _onStreamError(Object error, StackTrace st) {
    if (_isKilled) return;

    if (error is DioException && CancelToken.isCancel(error)) {
      _log.d('StreamingService: Stream cancelled cleanly');
      return;
    }

    _log.e('StreamingService: Stream error', error: error, stackTrace: st);
    _scheduleReconnect();
  }

  void _onStreamDone() {
    if (_isKilled) return;

    _log.w('StreamingService: Stream ended unexpectedly — scheduling reconnect');
    _scheduleReconnect();
  }

  // ============================================================
  // 5.3.8 — Internal: Heartbeat Monitor
  // Detects stale stream (no heartbeat for >15 seconds)
  // ============================================================

  void _startHeartbeatMonitor() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkHeartbeat(),
    );
  }

  void _resetHeartbeatTimer() {
    _lastHeartbeatAt = DateTime.now();
  }

  void _checkHeartbeat() {
    if (_isKilled) return;
    if (_lastHeartbeatAt == null) return;

    final elapsed = DateTime.now().difference(_lastHeartbeatAt!);
    if (elapsed > _heartbeatTimeout) {
      _log.w('StreamingService: ⚠️ No heartbeat for ${elapsed.inSeconds}s — reconnecting');
      _cancelToken?.cancel('heartbeat_timeout');
      _scheduleReconnect();
    }
  }

  // ============================================================
  // 5.3.9 — Internal: Auto-Reconnect with Exponential Backoff
  // ============================================================

  void _scheduleReconnect() {
    if (_isKilled) return;

    _reconnectAttempts++;

    if (_reconnectAttempts > _maxReconnectAttempts) {
      _log.e('StreamingService: Max reconnect attempts reached — killing stream');
      kill(reason: 'max_reconnect_attempts');
      return;
    }

    _setState(StreamConnectionState.reconnecting);

    // Exponential backoff: 2s, 4s, 8s, ..., capped at 60s
    final delayMs = (_initialReconnectDelay.inMilliseconds *
            (1 << (_reconnectAttempts - 1).clamp(0, 5)))
        .clamp(
      _initialReconnectDelay.inMilliseconds,
      _maxReconnectDelay.inMilliseconds,
    );

    _log.i('StreamingService: Reconnect attempt $_reconnectAttempts '
        'in ${delayMs}ms...');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(milliseconds: delayMs),
      () => _openStream(),
    );
  }

  // ============================================================
  // 5.3.10 — Internal: Cleanup
  // ============================================================

  Future<void> _cleanupConnection() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _cancelToken?.cancel('cleanup');
    _cancelToken = null;

    await _streamSubscription?.cancel();
    _streamSubscription = null;

    _parser.reset();
    _lastHeartbeatAt = null;
  }

  void _setState(StreamConnectionState state) {
    if (_connectionState.value == state) return;
    _log.d('StreamingService: State → ${state.displayName}');
    _connectionState.add(state);
  }

  // ============================================================
  // 5.3.11 — Dispose
  // ============================================================

  Future<void> dispose() async {
    await _cleanupConnection();
    await _tickController.close();
    await _connectionState.close();
    for (final subject in _symbolSubjects.values) {
      await subject.close();
    }
    _symbolSubjects.clear();
  }
}

// ============================================================
// 5.3.12 — Riverpod Provider
// ============================================================

final oandaStreamingServiceProvider =
    Provider<OandaStreamingService>((ref) {
  final service = OandaStreamingService(
    dio: ref.watch(streamingDioProvider),
    credentials: ref.watch(credentialStorageProvider),
    ticksDao: ref.watch(ticksDaoProvider),
  );

  ref.onDispose(service.dispose);
  return service;
});
