// Path: lib/main.dart
// ============================================================
// MT5 Clone — Application Entry Point
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app/mt5_app.dart';
import 'core/database/hive_cache_service.dart';
import 'core/di/provider_overrides.dart';
import 'core/logging/app_logger.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('FLUTTER ERROR: ${details.exception}');
      AppLogger.instance.error(
        'Flutter error',
        details.exception,
        details.stack,
      );
    };

    // ── Logger ─────────────────────────────────────────────
    try {
      await AppLogger.instance
          .initialize()
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint('Logger init failed: $e');
    }
    AppLogger.instance.info('App starting');

    // ── Portrait lock (non-blocking, can hang on MIUI) ─────
    AppLogger.instance.info('Setting orientations');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).timeout(const Duration(seconds: 2))
      .catchError((e) {
        AppLogger.instance.warn('Orientation lock failed: $e');
      });

    // ── Status bar ─────────────────────────────────────────
    AppLogger.instance.info('Setting system UI');
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0D1117),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // ── Hive ───────────────────────────────────────────────
    AppLogger.instance.info('Initializing Hive');
    try {
      await HiveCacheService.initialize()
          .timeout(const Duration(seconds: 5));
      AppLogger.instance.info('Hive initialized');
    } catch (e) {
      AppLogger.instance.error('Hive init failed', e);
    }

    // ── Launch ─────────────────────────────────────────────
    AppLogger.instance.info('Launching runApp');
    runApp(
      ProviderScope(
        overrides: buildProviderOverrides(),
        observers: [AppRiverpodObserver()],
        child: const Mt5App(),
      ),
    );
    AppLogger.instance.info('runApp returned');
  }, (error, stack) {
    debugPrint('UNCAUGHT: $error');
    debugPrint('STACK: $stack');
    AppLogger.instance.error('Uncaught error', error, stack);
  });
}

// ============================================================
// Riverpod Observer
// ============================================================

class AppRiverpodObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    assert(() {
      debugPrint(
          'Provider added: ${provider.name ?? provider.runtimeType}');
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
      'Provider failed: ${provider.name ?? provider.runtimeType}\n'
      '  Error: $error',
    );
    AppLogger.instance.error(
      'Provider failed: ${provider.name ?? provider.runtimeType}',
      error,
      stackTrace,
    );
  }
}
