// Path: lib/features/ea/data/datasources/file_picker_channel.dart
// ============================================================
// MT5 Clone — File Picker Channel
// Native Android file picker for .py EA scripts.
// ============================================================

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilePickerChannel {
  static const _channel = MethodChannel('com.mt5clone/file_picker');

  /// Pick a Python (.py) file from the device storage.
  /// Returns the absolute file path, or null if cancelled.
  Future<String?> pickPythonFile() async {
    final result = await _channel.invokeMethod<String>('pickPythonFile');
    return result;
  }

  /// Pick any file type.
  /// [allowedExtensions] — e.g. ['py', 'txt']
  Future<String?> pickFile({List<String>? allowedExtensions}) async {
    final result = await _channel.invokeMethod<String>(
      'pickFile',
      {
        if (allowedExtensions != null)
          'allowedExtensions': allowedExtensions,
      },
    );
    return result;
  }

  /// Read a file's content as a string.
  Future<String?> readFileContent(String path) async {
    final result = await _channel.invokeMethod<String>(
      'readFileContent',
      {'path': path},
    );
    return result;
  }

  /// Get the file name from a path.
  String getFileName(String path) {
    return path.split('/').last;
  }

  /// Get the file extension.
  String getFileExtension(String path) {
    final name = getFileName(path);
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex == -1) return '';
    return name.substring(dotIndex + 1).toLowerCase();
  }

  /// Validate that a file is a Python script.
  bool isValidPythonScript(String path) {
    return getFileExtension(path) == 'py';
  }
}

final filePickerChannelProvider = Provider<FilePickerChannel>((ref) {
  return FilePickerChannel();
});
