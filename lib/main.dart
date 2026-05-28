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
  // Catch any error before Flutter binding is ready
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Set up Flutter-level error handling
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('FLUTTER ERROR: ${details.exception}');
      debugPrint('  Stack: ${details.stack}');
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
      debugPrint('Logger init failed (non-fatal): $e');
    }
    AppLogger.instance.info('App starting');

    // ── Portrait lock ──────────────────────────────────────
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      debugPrint('Orientation lock failed: $e');
    }

    // ── Status bar ─────────────────────────────────────────
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0D1117),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // ── Hive ───────────────────────────────────────────────
    try {
      await HiveCacheService.initialize()
          .timeout(const Duration(seconds: 5));
      AppLogger.instance.info('Hive initialized');
    } catch (e) {
      debugPrint('Hive init failed: $e');
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
  }, (error, stack) {
    // Top-level error handler — catches anything missed
    debugPrint('UNCAUGHT: $error');
    debugPrint('  Stack: $stack');
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
