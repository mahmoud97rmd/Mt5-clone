// Path: lib/features/ea/data/datasources/ea_engine_channel.dart
// ============================================================
// MT5 Clone — EA Engine Method/Event Channel
// Bridge between Flutter and Kotlin EA Engine Service.
// ============================================================

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EaEngineChannel {
  static const _method = MethodChannel('com.mt5clone/ea_engine');
  static const _event = EventChannel('com.mt5clone/ea_log_events');

  Stream<Map<String, dynamic>>? _logStream;

  // ── EA Lifecycle ───────────────────────────────────────────

  Future<bool> startEa({
    required int eaId,
    required String scriptPath,
    required String symbol,
    required double lotSize,
    required int magicNumber,
    Map<String, dynamic>? params,
  }) async {
    final result = await _method.invokeMethod<bool>('startEa', {
      'eaId': eaId,
      'scriptPath': scriptPath,
      'symbol': symbol,
      'lotSize': lotSize,
      'magicNumber': magicNumber,
      'params': params ?? {},
    });
    return result ?? false;
  }

  Future<bool> stopEa(int eaId) async {
    final result = await _method.invokeMethod<bool>('stopEa', {
      'eaId': eaId,
    });
    return result ?? false;
  }

  Future<bool> killAllEas() async {
    final result = await _method.invokeMethod<bool>('killAllEas');
    return result ?? false;
  }

  // ── EA State Queries ───────────────────────────────────────

  Future<bool> isEaRunning(int eaId) async {
    final result = await _method.invokeMethod<bool>('isEaRunning', {
      'eaId': eaId,
    });
    return result ?? false;
  }

  Future<List<Map<String, dynamic>>> getRunningEas() async {
    final result =
        await _method.invokeMethod<List<dynamic>>('getRunningEas');
    if (result == null) return [];
    return result
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // ── EA Script Operations ───────────────────────────────────

  Future<String?> pickPythonScript() async {
    final result =
        await _method.invokeMethod<String>('pickPythonScript');
    return result;
  }

  Future<String> copyScriptToAppDir(String sourcePath) async {
    final result = await _method.invokeMethod<String>(
      'copyScriptToAppDir',
      {'sourcePath': sourcePath},
    );
    return result ?? '';
  }

  // ── Tick Dispatch (for EA engine) ──────────────────────────

  Future<void> dispatchTick({
    required String symbol,
    required double bid,
    required double ask,
  }) async {
    await _method.invokeMethod('dispatchTick', {
      'symbol': symbol,
      'bid': bid,
      'ask': ask,
    });
  }

  // ── Log Stream ─────────────────────────────────────────────

  Stream<Map<String, dynamic>> get logStream {
    _logStream ??= _event
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map));
    return _logStream!;
  }

  // ── Service Control ────────────────────────────────────────

  Future<bool> startEngineService() async {
    final result =
        await _method.invokeMethod<bool>('startEngineService');
    return result ?? false;
  }

  Future<bool> stopEngineService() async {
    final result =
        await _method.invokeMethod<bool>('stopEngineService');
    return result ?? false;
  }

  Future<bool> isServiceRunning() async {
    final result =
        await _method.invokeMethod<bool>('isServiceRunning');
    return result ?? false;
  }
}

final eaEngineChannelProvider = Provider<EaEngineChannel>((ref) {
  return EaEngineChannel();
});
