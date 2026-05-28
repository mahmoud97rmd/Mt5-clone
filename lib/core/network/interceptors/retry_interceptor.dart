// Path: lib/core/network/interceptors/retry_interceptor.dart
// ============================================================
// MT5 Clone — Retry Interceptor
// Automatically retries failed requests with exponential backoff.
// Only retries transient failures (network, timeout, 429, 503).
// Never retries auth failures or validation errors (400, 401, 403).
// ============================================================

import 'dart:math' as math;

import 'package:dio/dio.dart';

import '../api_constants.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxAttempts;
  final Duration initialDelay;

  RetryInterceptor({
    required this.dio,
    this.maxAttempts = OandaApiConstants.maxRetryAttempts,
    this.initialDelay = OandaApiConstants.initialRetryDelay,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = _getAttemptCount(err.requestOptions);

    if (!_shouldRetry(err) || attempt >= maxAttempts) {
      handler.next(err);
      return;
    }

    // Exponential backoff: 1s, 2s, 4s, capped at 30s
    final delay = _calculateDelay(attempt);
    await Future.delayed(delay);

    try {
      // Clone request and increment attempt counter
      final options = err.requestOptions.copyWith(
        extra: {
          ...err.requestOptions.extra,
          '_retry_attempt': attempt + 1,
        },
      );

      final response = await dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  bool _shouldRetry(DioException err) {
    final status = err.response?.statusCode;

    // Retry on network/timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on rate limit (429) and server errors (500, 502, 503, 504)
    if (status == 429 || status == 500 || status == 502 ||
        status == 503 || status == 504) {
      return true;
    }

    // Never retry auth, validation, or not-found errors
    return false;
  }

  int _getAttemptCount(RequestOptions options) {
    return options.extra['_retry_attempt'] as int? ?? 0;
  }

  Duration _calculateDelay(int attempt) {
    final ms = initialDelay.inMilliseconds *
        math.pow(2, attempt).toInt();
    final capped = math.min(
        ms, OandaApiConstants.maxRetryDelay.inMilliseconds);

    // Add jitter (±20%) to avoid thundering herd
    final jitter = (capped * 0.2 * (math.Random().nextDouble() - 0.5))
        .toInt();
    return Duration(milliseconds: capped + jitter);
  }
}
