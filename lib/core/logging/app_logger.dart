// Path: lib/core/logging/app_logger.dart
// ============================================================
// MT5 Clone — Application Logger
// Writes logs to internal storage for debugging.
// Log file: /data/data/com.mt5clone.app/files/mt5_logs/app.log
// ============================================================

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AppLogger {
  AppLogger._();
  static final AppLogger instance = AppLogger._();

  IOSink? _sink;
  File? _logFile;
  bool _initialized = false;

  // ── Initialization ──────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/mt5_logs');
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }
      _logFile = File('${logDir.path}/app.log');

      // Rotate if larger than 5 MB
      if (await _logFile!.exists()) {
        final size = await _logFile!.length();
        if (size > 5 * 1024 * 1024) {
          final old = File('${logDir.path}/app_old.log');
          if (await old.exists()) await old.delete();
          await _logFile!.rename(old.path);
          _logFile = File('${logDir.path}/app.log');
        }
      }

      _sink = _logFile!.openWrite(mode: FileMode.append);
      _initialized = true;
      info('Logger initialized — ${_logFile!.path}');
    } catch (e) {
      debugPrint('AppLogger: failed to initialize — $e');
    }
  }

  // ── Log Methods ─────────────────────────────────────────────

  void info(String message) => _write('INFO', message);
  void warn(String message) => _write('WARN', message);
  void error(String message, [Object? error, StackTrace? stack]) {
    _write('ERROR', message);
    if (error != null) _write('ERROR', '  Exception: $error');
    if (stack != null) _write('ERROR', '  Stack: $stack');
  }

  void debug(String message) {
    if (kDebugMode) _write('DEBUG', message);
  }

  // ── Internal ────────────────────────────────────────────────

  void _write(String level, String message) {
    final ts = DateTime.now().toIso8601String().substring(0, 23);
    final line = '$ts [$level] $message';
    debugPrint(line); // always print to logcat
    _sink?.writeln(line);
    _sink?.flush();
  }

  // ── Access Log File ─────────────────────────────────────────

  String? get logFilePath => _logFile?.path;

  Future<String> readLogs() async {
    if (_logFile == null || !await _logFile!.exists()) return '';
    return _logFile!.readAsString();
  }

  Future<void> clearLogs() async {
    _sink?.flush();
    if (_logFile != null && await _logFile!.exists()) {
      await _logFile!.writeAsString('');
    }
  }

  // ── Cleanup ─────────────────────────────────────────────────

  Future<void> dispose() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
    _initialized = false;
  }
}
