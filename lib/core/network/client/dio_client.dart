// Path: lib/core/network/client/dio_client.dart
// ============================================================
// MT5 Clone — Dio HTTP Client Factory
// Creates and configures the Dio instance used for all
// OANDA REST API calls. Attaches all interceptors in order.
//
// Interceptor execution order (request):
//   AuthInterceptor → LoggingInterceptor → RetryInterceptor
// Interceptor execution order (response/error):
//   RetryInterceptor → ErrorInterceptor → LoggingInterceptor
// ============================================================

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api_constants.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/error_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../interceptors/retry_interceptor.dart';
import '../../security/credential_storage.dart';

// ============================================================
// 4.1.2.1 — Dio Client Factory Function
// ============================================================

/// Creates a fully configured Dio instance for OANDA REST API.
/// Called once at app startup via Riverpod provider.
Dio createDioClient({
  required String baseUrl,
  required CredentialStorage credentialStorage,
  bool enableLogging = false,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,

      // ── Timeouts ─────────────────────────────────────────
      connectTimeout: OandaApiConstants.connectTimeout,
      receiveTimeout: OandaApiConstants.receiveTimeout,
      sendTimeout: OandaApiConstants.sendTimeout,

      // ── Default Headers ───────────────────────────────────
      headers: {
        OandaApiConstants.headerContentType:
            OandaApiConstants.contentTypeJson,
        // Use UNIX timestamp format for microsecond precision
        OandaApiConstants.headerAcceptDatetimeFormat:
            OandaApiConstants.datetimeFormatUnix,
      },

      // ── Response Type ─────────────────────────────────────
      responseType: ResponseType.json,

      // ── Follow Redirects ──────────────────────────────────
      followRedirects: true,
      maxRedirects: 3,

      // ── Validation ────────────────────────────────────────
      // Don't throw on non-2xx — ErrorInterceptor handles that
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  // ── Attach Interceptors (order matters) ───────────────────
  dio.interceptors.addAll([
    // 1. Auth: injects Bearer token into every request
    AuthInterceptor(credentialStorage: credentialStorage),

    // 2. Retry: retries on transient failures (429, 503, network)
    RetryInterceptor(dio: dio),

    // 3. Error: maps HTTP error responses to typed Failures
    ErrorInterceptor(),

    // 4. Logging: logs requests/responses in debug mode
    if (enableLogging) LoggingInterceptor(),
  ]);

  return dio;
}

// ============================================================
// 4.1.2.2 — Dio Provider (Riverpod)
// ============================================================

/// Provider for the REST API Dio client.
/// Reads account type (live vs. practice) from settings.
final dioClientProvider = Provider<Dio>((ref) {
  final credentials = ref.watch(credentialStorageProvider);
  final isLive = credentials.isLiveAccount;

  final baseUrl = isLive
      ? OandaApiConstants.liveRestBase
      : OandaApiConstants.practiceRestBase;

  // Enable logging only in debug builds
  const enableLogging = bool.fromEnvironment('dart.vm.product') == false;

  return createDioClient(
    baseUrl: baseUrl,
    credentialStorage: credentials,
    enableLogging: enableLogging,
  );
});

/// Provider for a raw streaming Dio (different timeout config).
/// Used by OandaStreamingService for chunked streaming responses.
final streamingDioProvider = Provider<Dio>((ref) {
  final credentials = ref.watch(credentialStorageProvider);
  final isLive = credentials.isLiveAccount;

  final streamBase = isLive
      ? OandaApiConstants.liveStreamBase
      : OandaApiConstants.practiceStreamBase;

  final dio = Dio(
    BaseOptions(
      baseUrl: streamBase,
      connectTimeout: OandaApiConstants.connectTimeout,
      // ⭐ No receive timeout for streaming — connection is permanent
      receiveTimeout: OandaApiConstants.streamReceiveTimeout,
      headers: {
        OandaApiConstants.headerContentType:
            OandaApiConstants.contentTypeJson,
        OandaApiConstants.headerAcceptDatetimeFormat:
            OandaApiConstants.datetimeFormatUnix,
      },
      responseType: ResponseType.stream, // streaming response
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  dio.interceptors.add(
    AuthInterceptor(credentialStorage: credentials),
  );

  return dio;
});
