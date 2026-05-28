// Path: lib/core/router/route_names.dart
// ============================================================
// MT5 Clone — Route Path Constants
// Centralized route paths used by GoRouter and navigation.
// ============================================================

class RouteNames {
  RouteNames._();

  static const String splash = '/splash';
  static const String setup = '/setup';
  static const String setupApiKey = '/setup/api-key';

  // Main tabs (ShellRoute)
  static const String quotes = '/quotes';
  static const String chart = '/chart';
  static const String trading = '/trading';
  static const String history = '/history';
  static const String eaManager = '/ea';
  static const String settings = '/settings';

  // Sub-routes
  static const String orderEntry = '/trading/order';
  static const String modifyPosition = '/trading/modify';
  static const String chartSymbol = '/chart';
  static const String eaLogs = '/ea/logs';
}
