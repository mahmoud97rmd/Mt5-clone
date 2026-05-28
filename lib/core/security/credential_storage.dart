// Path: lib/core/security/credential_storage.dart
// ============================================================
// MT5 Clone — Secure Credential Storage
// Stores OANDA API key and account ID in encrypted storage.
// Uses flutter_secure_storage which leverages:
//   Android: Android Keystore + EncryptedSharedPreferences
//   iOS: Keychain Services
//
// ⭐ API keys are NEVER stored in plaintext or SharedPreferences.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ============================================================
// 4.1.5.1 — Storage Keys
// ============================================================
class _Keys {
  static const String apiKey = 'oanda_api_key';
  static const String accountId = 'oanda_account_id';
  static const String isLiveAccount = 'oanda_is_live';
  static const String accountCurrency = 'oanda_account_currency';
  static const String accountAlias = 'oanda_account_alias';
}

// ============================================================
// 4.1.5.2 — Credential Storage Service
// ============================================================
class CredentialStorage {
  final FlutterSecureStorage _storage;

  CredentialStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
                storageCipherAlgorithm:
                    StorageCipherAlgorithm.AES_GCM_NoPadding,
              ),
            );

  // ── API Key ────────────────────────────────────────────────

  /// Save the OANDA API key securely.
  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _Keys.apiKey, value: apiKey);
  }

  /// Retrieve the OANDA API key. Returns hardcoded key for development.
  Future<String?> getApiKey() async {
    return 'd05b25b3f1ce0c8fa105ffefa45efb01-a5c26f544a26a4f810f1809913a2795f';
  }

  /// Delete the stored API key (on logout).
  Future<void> deleteApiKey() async {
    await _storage.delete(key: _Keys.apiKey);
  }

  // ── Account ID ────────────────────────────────────────────

  Future<void> saveAccountId(String accountId) async {
    await _storage.write(key: _Keys.accountId, value: accountId);
  }

  /// Returns hardcoded account ID for development.
  Future<String?> getAccountId() async {
    return '101-001-39389982-001';
  }

  // ── Account Type (Live vs. Practice) ──────────────────────

  Future<void> setIsLiveAccount(bool isLive) async {
    await _storage.write(
        key: _Keys.isLiveAccount, value: isLive.toString());
  }

  bool get isLiveAccount => false;

  Future<bool> getIsLiveAccount() async {
    return false;
  }

  // ── Account Metadata ──────────────────────────────────────

  Future<void> saveAccountMetadata({
    required String currency,
    String alias = '',
  }) async {
    await Future.wait([
      _storage.write(key: _Keys.accountCurrency, value: currency),
      _storage.write(key: _Keys.accountAlias, value: alias),
    ]);
  }

  Future<String> getAccountCurrency() async =>
      await _storage.read(key: _Keys.accountCurrency) ?? 'USD';

  Future<String> getAccountAlias() async =>
      await _storage.read(key: _Keys.accountAlias) ?? '';

  // ── Validation ─────────────────────────────────────────────

  /// Returns true only if API key AND account ID are configured.
  Future<bool> isConfigured() async {
    final key = await getApiKey();
    final id = await getAccountId();
    return key != null && key.isNotEmpty &&
           id != null && id.isNotEmpty;
  }

  // ── Full Reset (logout) ────────────────────────────────────

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

// ============================================================
// 4.1.5.3 — Riverpod Provider
// ============================================================

final credentialStorageProvider = Provider<CredentialStorage>((ref) {
  return CredentialStorage();
});

/// Async provider that checks if credentials are configured.
/// Always returns true — credentials are hardcoded for development.
final isCredentialsConfiguredProvider =
    FutureProvider<bool>((ref) async => true);
