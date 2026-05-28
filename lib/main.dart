// Path: lib/main.dart
// ============================================================
// MT5 Clone — Application Entry Point
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app/mt5_app.dart';
import 'core/database/hive_cache_service.dart';
import 'core/di/provider_overrides.dart';
import 'core/logging/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger synchronously (writes to file, no platform channel)
  AppLogger.instance.initialize().then((_) {
    AppLogger.instance.info('Logger ready');
  });

  // Fire-and-forget: these can hang on MIUI/Xiaomi devices.
  // Do NOT await them — let the app render immediately.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    AppLogger.instance.info('Orientations set');
  }).catchError((e) {
    AppLogger.instance.warn('Orientation failed: $e');
  });

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D1117),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Hive init — fire and forget, app works without cache
  HiveCacheService.initialize().then((_) {
    AppLogger.instance.info('Hive ready');
  }).catchError((e) {
    AppLogger.instance.warn('Hive failed: $e');
  });

  // Launch immediately — don't wait for anything
  runApp(
    ProviderScope(
      overrides: buildProviderOverrides(),
      observers: [AppRiverpodObserver()],
      child: const Mt5App(),
    ),
  );
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
