// Path: lib/features/ea/data/datasources/permissions_channel.dart
// ============================================================
// MT5 Clone — Permissions Channel
// Handles Android runtime permissions via MethodChannel.
// ============================================================

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PermissionsChannel {
  static const _channel = MethodChannel('com.mt5clone/permissions');

  /// Check if a specific permission is granted.
  Future<bool> checkPermission(String permission) async {
    final result = await _channel.invokeMethod<bool>(
      'checkPermission',
      {'permission': permission},
    );
    return result ?? false;
  }

  /// Request a specific permission. Returns true if granted.
  Future<bool> requestPermission(String permission) async {
    final result = await _channel.invokeMethod<bool>(
      'requestPermission',
      {'permission': permission},
    );
    return result ?? false;
  }

  /// Check if battery optimization is ignored (whitelisted).
  Future<bool> isBatteryOptimizationIgnored() async {
    final result = await _channel
        .invokeMethod<bool>('isBatteryOptimizationIgnored');
    return result ?? false;
  }

  /// Open battery optimization settings for the user to whitelist.
  Future<void> openBatteryOptimizationSettings() async {
    await _channel.invokeMethod('openBatteryOptimizationSettings');
  }

  /// Open app notification settings.
  Future<void> openNotificationSettings() async {
    await _channel.invokeMethod('openNotificationSettings');
  }

  /// Check if notification permission is granted (Android 13+).
  Future<bool> isNotificationPermissionGranted() async {
    final result = await _channel
        .invokeMethod<bool>('isNotificationPermissionGranted');
    return result ?? true; // default true for older Android
  }

  /// Request notification permission (Android 13+).
  Future<bool> requestNotificationPermission() async {
    final result = await _channel
        .invokeMethod<bool>('requestNotificationPermission');
    return result ?? true;
  }

  /// Check if overlay (SYSTEM_ALERT_WINDOW) permission is granted.
  Future<bool> canDrawOverlays() async {
    final result =
        await _channel.invokeMethod<bool>('canDrawOverlays');
    return result ?? false;
  }

  /// Open overlay permission settings.
  Future<void> openOverlaySettings() async {
    await _channel.invokeMethod('openOverlaySettings');
  }
}

final permissionsChannelProvider = Provider<PermissionsChannel>((ref) {
  return PermissionsChannel();
});
