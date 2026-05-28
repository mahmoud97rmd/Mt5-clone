// Path: lib/main.dart
// ============================================================
// MT5 Clone — Application Entry Point
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app/mt5_app.dart';
import 'core/di/provider_overrides.dart';
import 'core/logging/app_logger.dart';

void main() {
  // Absolute minimum — no awaits, no platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Fire and forget logger
  AppLogger.instance.initialize();

  // Launch immediately
  runApp(
    ProviderScope(
      overrides: buildProviderOverrides(),
      child: const Mt5App(),
    ),
  );
}
