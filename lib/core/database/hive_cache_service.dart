// Path: lib/core/database/hive_cache_service.dart
// ============================================================
// MT5 Clone — Hive Cache Service
// Fast synchronous cache for real-time price data.
// ============================================================

import 'package:hive_flutter/hive_flutter.dart';

class HiveCacheService {
  static const String _tickBoxName = 'ticks';
  static const String _accountBoxName = 'account';
  static const String _settingsBoxName = 'settings';

  static Box<Map>? _tickBox;
  static Box<Map>? _accountBox;
  static Box? _settingsBox;
  static bool _initialized = false;

  static bool get isReady => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Hive.initFlutter();
      _tickBox = await Hive.openBox<Map>(_tickBoxName);
      _accountBox = await Hive.openBox<Map>(_accountBoxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
      _initialized = true;
    } catch (e) {
      // App works without cache — just log and continue
      print('HiveCacheService: init failed — $e');
    }
  }

  // ── Tick Cache (synchronous for hot path) ────────────────────

  static void cacheTick({
    required String symbol,
    required double bid,
    required double ask,
    required double spread,
    required int timestampUs,
    double? sessionHigh,
    double? sessionLow,
  }) {
    _tickBox?.put(symbol, {
      'bid': bid,
      'ask': ask,
      'spread': spread,
      'timestampUs': timestampUs,
      'sessionHigh': sessionHigh,
      'sessionLow': sessionLow,
    });
  }

  static double? getLatestBid(String symbol) {
    final data = _tickBox?.get(symbol);
    return data?['bid'] as double?;
  }

  static double? getLatestAsk(String symbol) {
    final data = _tickBox?.get(symbol);
    return data?['ask'] as double?;
  }

  static double? getLatestSpread(String symbol) {
    final data = _tickBox?.get(symbol);
    return data?['spread'] as double?;
  }

  static Map<String, dynamic>? getLatestTick(String symbol) {
    final data = _tickBox?.get(symbol);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  // ── Account Cache ───────────────────────────────────────────

  static void cacheAccountState({
    required String accountId,
    required double balance,
    required double equity,
    required double marginUsed,
    required double marginAvailable,
    double? marginLevel,
    required double unrealizedPnl,
  }) {
    _accountBox?.put(accountId, {
      'balance': balance,
      'equity': equity,
      'marginUsed': marginUsed,
      'marginAvailable': marginAvailable,
      'marginLevel': marginLevel,
      'unrealizedPnl': unrealizedPnl,
    });
  }

  static Map<String, dynamic>? getAccountState(String accountId) {
    final data = _accountBox?.get(accountId);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  // ── Settings Cache ──────────────────────────────────────────

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox?.get(key, defaultValue: defaultValue);
  }

  static Future<void> setSetting(String key, dynamic value) async {
    await _settingsBox?.put(key, value);
  }

  // ── Cleanup ─────────────────────────────────────────────────

  static Future<void> clearTickCache() async {
    await _tickBox?.clear();
  }

  static Future<void> clearAll() async {
    await _tickBox?.clear();
    await _accountBox?.clear();
  }
}
