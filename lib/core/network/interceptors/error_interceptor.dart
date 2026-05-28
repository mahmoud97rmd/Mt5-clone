// Path: lib/core/network/interceptors/error_interceptor.dart
// ============================================================
// MT5 Clone — Error Interceptor
// Converts raw HTTP errors and DioExceptions into typed
// domain Failures that the repository layer can handle.
//
// OANDA-specific error codes are mapped to meaningful messages.
// ============================================================

import 'package:dio/dio.dart';

import '../../domain/failures/failures.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Map to a typed Failure and re-throw as a DioException
    // with the failure attached in the 'extra' field for retrieval
    final failure = _mapToFailure(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,             // Failure in .error field
        message: failure.message,
      ),
    );
  }

  // ============================================================
  // 4.1.4.1 — HTTP Status → Failure mapping
  // ============================================================
  Failure _mapToFailure(DioException err) {
    // ── Connection-level errors ────────────────────────────
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(originalError: err);

      case DioExceptionType.connectionError:
        return NetworkFailure(originalError: err);

      case DioExceptionType.cancel:
        return UnexpectedFailure(
          message: err.message ?? 'Request cancelled',
          originalError: err,
        );

      case DioExceptionType.unknown:
        if (err.error is Failure) return err.error as Failure;
        return UnexpectedFailure(
          message: err.message ?? 'Unknown network error',
          originalError: err,
        );

      case DioExceptionType.badResponse:
        return _mapHttpStatusToFailure(err);

      default:
        return UnexpectedFailure(originalError: err);
    }
  }

  // ============================================================
  // 4.1.4.2 — HTTP Status Code → Specific Failure
  // ============================================================
  Failure _mapHttpStatusToFailure(DioException err) {
    final status = err.response?.statusCode;
    final data = err.response?.data;

    // Extract OANDA error message from response body
    final oandaMessage = _extractOandaErrorMessage(data);

    return switch (status) {
      // ── Authentication ──────────────────────────────────
      400 => InvalidOrderFailure(
          message: oandaMessage ?? 'Bad request: invalid parameters',
          originalError: err,
        ),
      401 => AuthFailure(
          message: oandaMessage ??
              'Authentication failed. Check your OANDA API key.',
          originalError: err,
        ),
      403 => PermissionFailure(
          message: oandaMessage ??
              'Permission denied. Check your account permissions.',
          originalError: err,
        ),
      404 => NotFoundFailure(
          message: oandaMessage ?? 'Resource not found',
        ),

      // ── Rate Limiting ───────────────────────────────────
      429 => ServerFailure(
          message: 'Rate limit exceeded. Please wait before retrying.',
          statusCode: 429,
          code: 'RATE_LIMIT',
          originalError: err,
        ),

      // ── OANDA-specific order rejection codes ─────────────
      // OANDA returns 400 with specific errorCodes for order issues
      _ when oandaMessage?.contains('INSUFFICIENT_MARGIN') == true =>
        InsufficientMarginFailure(
          requiredMargin: 0, // Would be parsed from response
          availableMargin: 0,
        ),

      _ when oandaMessage?.contains('MARKET_ORDER_REJECT') == true =>
        OrderRejectedFailure(
          message: oandaMessage ?? 'Order rejected by broker',
          rejectReason: _extractOandaRejectReason(data),
          originalError: err,
        ),

      _ when oandaMessage?.contains('CLOSEOUT') == true =>
        OrderRejectedFailure(
          message: 'Order rejected: account in closeout',
          rejectReason: 'CLOSEOUT',
          originalError: err,
        ),

      // ── Server Errors ───────────────────────────────────
      500 || 502 || 503 || 504 => ServerFailure(
          message: 'OANDA server error. Please try again later.',
          statusCode: status,
          originalError: err,
        ),

      // ── Unknown ─────────────────────────────────────────
      _ => ServerFailure(
          message: oandaMessage ?? 'HTTP error $status',
          statusCode: status,
          originalError: err,
        ),
    };
  }

  // ============================================================
  // 4.1.4.3 — OANDA Error Body Parsing
  // ============================================================

  /// OANDA error format:
  /// { "errorCode": "MARKET_ORDER_REJECT", "errorMessage": "..." }
  /// or
  /// { "orderRejectTransaction": { "rejectReason": "..." } }
  String? _extractOandaErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is! Map<String, dynamic>) return null;

    return data['errorMessage'] as String? ??
        data['message'] as String?;
  }

  String? _extractOandaRejectReason(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return null;
    final rejectTx = data['orderRejectTransaction'] as Map<String, dynamic>?;
    return rejectTx?['rejectReason'] as String?;
  }
}
