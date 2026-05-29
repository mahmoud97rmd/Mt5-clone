// Path: lib/core/logging/app_logger.dart
// ============================================================
// MT5 Clone — Application Logger
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
  final List<String> _buffer = [];

  bool get isReady => _initialized;

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

      // Flush buffered messages
      for (final line in _buffer) {
        _sink!.writeln(line);
      }
      _sink!.flush();
      _initialized = true;

      info('Logger initialized — ${_logFile!.path}');
      info('Flushed ${_buffer.length} buffered messages');
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

    // Always print to logcat
    debugPrint(line);

    if (_initialized && _sink != null) {
      _sink!.writeln(line);
      _sink!.flush();
    } else {
      // Buffer until file is ready
      _buffer.add(line);
    }
  }

  // ── Access Log File ─────────────────────────────────────────

  String? get logFilePath => _logFile?.path;

  Future<String> readLogs() async {
    if (_logFile == null || !await _logFile!.exists()) return '';
    return _logFile!.readAsString();
  }

  Future<void> clearLogs() async {
    await _sink?.flush();
    if (_logFile != null && await _logFile!.exists()) {
      await _logFile!.writeAsString('');
    }
  }

  Future<void> dispose() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
    _initialized = false;
  }
}
