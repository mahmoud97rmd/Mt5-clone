// Path: lib/core/domain/failures/failures.dart
// ============================================================
// MT5 Clone — Domain Failure Classes
// Type-safe error hierarchy for Either<Failure, T> pattern.
// Each failure carries a user-facing message and optional details.
// ============================================================

abstract class Failure {
  final String message;
  final String? details;
  final int? statusCode;
  final Object? originalError;

  const Failure({
    required this.message,
    this.details,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'Failure: $message${details != null ? ' ($details)' : ''}';
}

// ── Network Failures ─────────────────────────────────────────

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network error. Please check your connection.',
    super.details,
    super.originalError,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.details,
    super.originalError,
  });
}

class ConnectionFailure extends Failure {
  const ConnectionFailure({
    super.message = 'Unable to connect to server.',
    super.details,
    super.originalError,
  });
}

// ── Auth Failures ────────────────────────────────────────────

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please check your API key.',
    super.details,
    super.statusCode,
    super.originalError,
  });
}

class InvalidApiKeyFailure extends Failure {
  const InvalidApiKeyFailure({
    super.message = 'Invalid API key. Please check your credentials.',
    super.details,
  });
}

class ExpiredTokenFailure extends Failure {
  const ExpiredTokenFailure({
    super.message = 'Session expired. Please re-authenticate.',
    super.details,
  });
}

// ── API Failures ─────────────────────────────────────────────

class ServerFailure extends Failure {
  final String? code;
  const ServerFailure({
    super.message = 'Server error. Please try again later.',
    super.details,
    super.statusCode,
    super.originalError,
    this.code,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission denied.',
    super.details,
    super.originalError,
  });
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Invalid request. Please check your input.',
    super.details,
    super.statusCode,
    super.originalError,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found.',
    super.details,
  });
}

class RateLimitFailure extends Failure {
  const RateLimitFailure({
    super.message = 'Too many requests. Please wait and try again.',
    super.details,
  });
}

// ── Trading Failures ─────────────────────────────────────────

class InsufficientMarginFailure extends Failure {
  final double? requiredMargin;
  final double? availableMargin;
  const InsufficientMarginFailure({
    super.message = 'Insufficient margin to open this position.',
    super.details,
    super.originalError,
    this.requiredMargin,
    this.availableMargin,
  });
}

class OrderRejectedFailure extends Failure {
  final String? rejectReason;
  const OrderRejectedFailure({
    super.message = 'Order was rejected by the broker.',
    super.details,
    super.originalError,
    this.rejectReason,
  });
}

class PositionNotFoundFailure extends Failure {
  const PositionNotFoundFailure({
    super.message = 'Position not found. It may have been closed.',
    super.details,
  });
}

class InvalidOrderFailure extends Failure {
  const InvalidOrderFailure({
    super.message = 'Invalid order parameters.',
    super.details,
    super.originalError,
  });
}

class MarketClosedFailure extends Failure {
  const MarketClosedFailure({
    super.message = 'Market is currently closed.',
    super.details,
  });
}

// ── Data Failures ────────────────────────────────────────────

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache error. Please refresh.',
    super.details,
  });
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    super.message = 'Database error. Please restart the app.',
    super.details,
  });
}

class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'Data parsing error.',
    super.details,
  });
}

// ── EA Failures ──────────────────────────────────────────────

class EaLoadFailure extends Failure {
  const EaLoadFailure({
    super.message = 'Failed to load EA script.',
    super.details,
  });
}

class EaRuntimeFailure extends Failure {
  const EaRuntimeFailure({
    super.message = 'EA runtime error.',
    super.details,
  });
}

// ── Generic ──────────────────────────────────────────────────

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred.',
    super.details,
    super.originalError,
  });
}
