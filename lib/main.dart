// Path: lib/main.dart
// ============================================================
// MT5 Clone — Application Entry Point
// Bootstrap sequence:
//   1. Flutter binding initialization
//   2. Hive cache initialization
//   3. ProviderScope + ProviderContainer setup
//   4. App launch
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app/mt5_app.dart';
import 'core/database/hive_cache_service.dart';
import 'core/di/provider_overrides.dart';
import 'core/logging/app_logger.dart';

Future<void> main() async {
  // ── 1. Flutter binding ─────────────────────────────────────
  WidgetsFlutterBinding.ensureInitialized();

  // ── 2. Logger (before everything — captures all crashes) ───
  await AppLogger.instance.initialize();
  AppLogger.instance.info('App starting');

  // ── 3. Lock to portrait only (MT5 is portrait-first) ──────
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ── 4. Status bar styling ──────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D1117),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // ── 5. Initialize Hive cache ───────────────────────────────
  await HiveCacheService.initialize();
  AppLogger.instance.info('Hive initialized');

  // ── 6. Launch app ──────────────────────────────────────────
  runApp(
    ProviderScope(
      overrides: buildProviderOverrides(),
      observers: [
        AppRiverpodObserver(),
      ],
      child: const Mt5App(),
    ),
  );
}

// ============================================================
// 7.1.1 — Riverpod Observer (for logging & debugging)
// ============================================================

class AppRiverpodObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    // Only log in debug mode
    assert(() {
      debugPrint('📦 Provider added: ${provider.name ?? provider.runtimeType}');
      return true;
    }());
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint(
      '❌ Provider failed: ${provider.name ?? provider.runtimeType}\n'
      'Error: $error',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    assert(() {
      debugPrint(
          '🗑️ Provider disposed: ${provider.name ?? provider.runtimeType}');
      return true;
    }());
  }
}
