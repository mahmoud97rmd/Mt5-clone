// Path: lib/core/network/api_constants.dart
// ============================================================
// MT5 Clone — OANDA v20 API Constants
// Central registry of all endpoint URLs, headers, timeouts,
// and configuration values for the OANDA REST API.
//
// OANDA v20 API Docs: https://developer.oanda.com/rest-live-v20/introduction/
// ============================================================

class OandaApiConstants {
  OandaApiConstants._();

  // ============================================================
  // 4.1.1.1 — Base URLs
  // ============================================================

  /// OANDA Live (real money) trading environment
  static const String liveRestBase =
      'https://api-fxtrade.oanda.com/v3';
  static const String liveStreamBase =
      'https://stream-fxtrade.oanda.com/v3';

  /// OANDA Practice (demo) trading environment
  static const String practiceRestBase =
      'https://api-fxpractice.oanda.com/v3';
  static const String practiceStreamBase =
      'https://stream-fxpractice.oanda.com/v3';

  // ============================================================
  // 4.1.1.2 — HTTP Timeouts
  // ============================================================
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 15);

  /// Streaming endpoint — long-lived connection, no receive timeout
  static const Duration streamReceiveTimeout = Duration(days: 365);

  // ============================================================
  // 4.1.1.3 — Rate Limiting
  // ============================================================
  /// OANDA allows 120 requests per second per account
  static const int maxRequestsPerSecond = 100; // conservative limit

  /// Max retries on transient failures (429, 503)
  static const int maxRetryAttempts = 3;
  static const Duration initialRetryDelay = Duration(seconds: 1);
  static const Duration maxRetryDelay = Duration(seconds: 30);

  // ============================================================
  // 4.1.1.4 — REST API Endpoints
  // All paths are relative to the base URL (v3)
  // ============================================================

  // ── Account Endpoints ────────────────────────────────────────
  static const String accounts = '/accounts';
  static String accountDetails(String accountId) =>
      '/accounts/$accountId';
  static String accountSummary(String accountId) =>
      '/accounts/$accountId/summary';
  static String accountInstruments(String accountId) =>
      '/accounts/$accountId/instruments';
  static String accountChanges(String accountId) =>
      '/accounts/$accountId/changes';

  // ── Instrument / Pricing Endpoints ──────────────────────────
  static String pricing(String accountId) =>
      '/accounts/$accountId/pricing';
  static String pricingStream(String accountId) =>
      '/accounts/$accountId/pricing/stream';
  static String candles(String instrument) =>
      '/instruments/$instrument/candles';
  static String orderBook(String instrument) =>
      '/instruments/$instrument/orderBook';
  static String positionBook(String instrument) =>
      '/instruments/$instrument/positionBook';

  // ── Order Endpoints ──────────────────────────────────────────
  static String orders(String accountId) =>
      '/accounts/$accountId/orders';
  static String orderById(String accountId, String orderId) =>
      '/accounts/$accountId/orders/$orderId';
  static String pendingOrders(String accountId) =>
      '/accounts/$accountId/pendingOrders';
  static String cancelOrder(String accountId, String orderId) =>
      '/accounts/$accountId/orders/$orderId/cancel';

  // ── Trade / Position Endpoints ───────────────────────────────
  static String trades(String accountId) =>
      '/accounts/$accountId/trades';
  static String openTrades(String accountId) =>
      '/accounts/$accountId/openTrades';
  static String tradeById(String accountId, String tradeId) =>
      '/accounts/$accountId/trades/$tradeId';
  static String closeTradeById(String accountId, String tradeId) =>
      '/accounts/$accountId/trades/$tradeId/close';
  static String tradeOrders(String accountId, String tradeId) =>
      '/accounts/$accountId/trades/$tradeId/orders';

  // ── Position Endpoints ───────────────────────────────────────
  static String positions(String accountId) =>
      '/accounts/$accountId/positions';
  static String openPositions(String accountId) =>
      '/accounts/$accountId/openPositions';
  static String positionByInstrument(
          String accountId, String instrument) =>
      '/accounts/$accountId/positions/$instrument';
  static String closePosition(String accountId, String instrument) =>
      '/accounts/$accountId/positions/$instrument/close';

  // ── Transaction / History Endpoints ─────────────────────────
  static String transactions(String accountId) =>
      '/accounts/$accountId/transactions';
  static String transactionById(String accountId, String txId) =>
      '/accounts/$accountId/transactions/$txId';
  static String transactionSince(String accountId) =>
      '/accounts/$accountId/transactions/sinceid';
  static String transactionIdRange(String accountId) =>
      '/accounts/$accountId/transactions/idrange';

  // ============================================================
  // 4.1.1.5 — HTTP Headers
  // ============================================================
  static const String headerAuthorization = 'Authorization';
  static const String headerContentType = 'Content-Type';
  static const String headerAcceptDatetimeFormat = 'Accept-Datetime-Format';
  static const String headerXAcceptDatetimeFormat =
      'Accept-Datetime-Format';

  /// OANDA requires UNIX timestamp format for precise microsecond precision
  static const String datetimeFormatUnix = 'UNIX';
  static const String datetimeFormatRfc3339 = 'RFC3339';
  static const String contentTypeJson = 'application/json';

  // ============================================================
  // 4.1.1.6 — OANDA Candle Granularities
  // ============================================================
  static const List<String> validGranularities = [
    'S5', 'S10', 'S15', 'S30',
    'M1', 'M2', 'M4', 'M5', 'M10', 'M15', 'M30',
    'H1', 'H2', 'H3', 'H4', 'H6', 'H8', 'H12',
    'D', 'W', 'M',
  ];

  // ============================================================
  // 4.1.1.7 — OANDA Price Components
  // ============================================================
  static const String priceMid = 'M';   // Mid prices
  static const String priceBid = 'B';   // Bid prices
  static const String priceAsk = 'A';   // Ask prices
  static const String priceAll = 'MBA'; // All price components

  // ============================================================
  // 4.1.1.8 — Order Configuration
  // ============================================================
  /// OANDA time-in-force values
  static const String tifGtc = 'GTC'; // Good Till Cancelled
  static const String tifGtd = 'GTD'; // Good Till Date
  static const String tifFok = 'FOK'; // Fill Or Kill
  static const String tifIoc = 'IOC'; // Immediate Or Cancel

  /// Position fill modes
  static const String fillDefault = 'DEFAULT';
  static const String fillReduceFirst = 'REDUCE_FIRST';
  static const String fillReduceOnly = 'REDUCE_ONLY';
  static const String fillOpenOnly = 'OPEN_ONLY';

  // ============================================================
  // 4.1.1.9 — Max candles per request
  // OANDA limits: 5,000 candles per request for most granularities
  // ============================================================
  static const int maxCandlesPerRequest = 5000;
  static const int defaultCandleCount = 500;
}
