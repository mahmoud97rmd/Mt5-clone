// Path: lib/main.dart
// ============================================================
// MT5 Clone — Application Entry Point
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app/mt5_app.dart';
import 'core/di/provider_overrides.dart';
import 'core/logging/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.instance.initialize();
  AppLogger.instance.info('main() started');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D1117),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  AppLogger.instance.info('Calling runApp');

  try {
    runApp(
      ProviderScope(
        overrides: buildProviderOverrides(),
        child: const Mt5App(),
      ),
    );
    AppLogger.instance.info('runApp returned');
  } catch (e, st) {
    AppLogger.instance.error('runApp CRASHED', e, st);
    debugPrint('runApp CRASHED: $e\n$st');
  }
}
