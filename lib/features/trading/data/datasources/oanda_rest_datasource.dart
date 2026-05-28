// Path: lib/features/trading/data/datasources/oanda_rest_datasource.dart
// ============================================================
// MT5 Clone — OANDA REST Data Source
// Raw API calls to OANDA v20 REST endpoints.
// Returns DTOs — mapping to domain entities happens in repositories.
//
// This class:
//   - Knows about HTTP/JSON
//   - Does NOT know about domain entities or business rules
//   - Throws DioException on failure (caught by repositories)
// ============================================================

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/client/dio_client.dart';
import '../../../../core/security/credential_storage.dart';
import '../models/trade_order_dto.dart';
import '../models/transaction_candle_dto.dart';

class OandaRestDataSource {
  final Dio _dio;
  final CredentialStorage _credentials;

  OandaRestDataSource({
    required Dio dio,
    required CredentialStorage credentials,
  })  : _dio = dio,
        _credentials = credentials;

  // ── Internal helper to get account ID ─────────────────────
  Future<String> _getAccountId() async {
    final id = await _credentials.getAccountId();
    if (id == null || id.isEmpty) {
      throw DioException(
        requestOptions: RequestOptions(),
        message: 'Account ID not configured',
      );
    }
    return id;
  }

  // ============================================================
  // 4.3.1 — Account Endpoints
  // ============================================================

  /// GET /accounts — list all accounts for this API key
  Future<AccountsListResponseDto> getAccounts() async {
    final response = await _dio.get(OandaApiConstants.accounts);
    return AccountsListResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// GET /accounts/{id}/summary — full account state
  Future<AccountSummaryResponseDto> getAccountSummary() async {
    final accountId = await _getAccountId();
    final response = await _dio.get(
        OandaApiConstants.accountSummary(accountId));
    return AccountSummaryResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// GET /accounts/{id}/instruments — all tradeable instruments
  Future<InstrumentsResponseDto> getInstruments({
    List<String>? instrumentNames,
  }) async {
    final accountId = await _getAccountId();
    final response = await _dio.get(
      OandaApiConstants.accountInstruments(accountId),
      queryParameters: instrumentNames != null
          ? {'instruments': instrumentNames.join(',')}
          : null,
    );
    return InstrumentsResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  // ============================================================
  // 4.3.2 — Pricing Endpoints
  // ============================================================

  /// GET /accounts/{id}/pricing — snapshot prices for instruments
  Future<PricingResponseDto> getPricing({
    required List<String> instruments,
    bool includeUnitsAvailable = false,
    bool includeHomeConversions = false,
  }) async {
    final accountId = await _getAccountId();
    final response = await _dio.get(
      OandaApiConstants.pricing(accountId),
      queryParameters: {
        'instruments': instruments.join(','),
        'includeUnitsAvailable': includeUnitsAvailable,
        'includeHomeConversions': includeHomeConversions,
      },
    );
    return PricingResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// GET /instruments/{instrument}/candles — OHLCV candle data
  Future<CandlesResponseDto> getCandles({
    required String instrument,
    required String granularity,
    int? count,
    String? fromTime,      // UNIX timestamp string
    String? toTime,        // UNIX timestamp string
    String price = 'MBA',  // Mid, Bid, Ask
    bool smooth = false,
    bool includeFirst = true,
    int? dailyAlignment,
    String? alignmentTimezone,
    String? weeklyAlignment,
  }) async {
    final queryParams = <String, dynamic>{
      'granularity': granularity,
      'price': price,
      'smooth': smooth,
      'includeFirst': includeFirst,
    };

    if (count != null) queryParams['count'] = count;
    if (fromTime != null) queryParams['from'] = fromTime;
    if (toTime != null) queryParams['to'] = toTime;
    if (dailyAlignment != null) {
      queryParams['dailyAlignment'] = dailyAlignment;
    }
    if (alignmentTimezone != null) {
      queryParams['alignmentTimezone'] = alignmentTimezone;
    }
    if (weeklyAlignment != null) {
      queryParams['weeklyAlignment'] = weeklyAlignment;
    }

    final response = await _dio.get(
      OandaApiConstants.candles(instrument),
      queryParameters: queryParams,
    );
    return CandlesResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  // ============================================================
  // 4.3.3 — Order Execution Endpoints
  // ============================================================

  /// POST /accounts/{id}/orders — create any type of order
  Future<OrderFillResponseDto> createOrder({
    required CreateOrderRequestDto request,
  }) async {
    final accountId = await _getAccountId();
    final response = await _dio.post(
      OandaApiConstants.orders(accountId),
      data: request.toJson(),
    );
    return OrderFillResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// GET /accounts/{id}/pendingOrders — all pending orders
  Future<PendingOrdersResponseDto> getPendingOrders() async {
    final accountId = await _getAccountId();
    final response = await _dio.get(
        OandaApiConstants.pendingOrders(accountId));
    return PendingOrdersResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// PUT /accounts/{id}/orders/{orderId}/cancel — cancel pending order
  Future<void> cancelOrder(String orderId) async {
    final accountId = await _getAccountId();
    await _dio.put(OandaApiConstants.cancelOrder(accountId, orderId));
  }

  // ============================================================
  // 4.3.4 — Trade Management Endpoints
  // ============================================================

  /// GET /accounts/{id}/openTrades — all open positions
  Future<OpenTradesResponseDto> getOpenTrades() async {
    final accountId = await _getAccountId();
    final response = await _dio.get(
        OandaApiConstants.openTrades(accountId));
    return OpenTradesResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// GET /accounts/{id}/trades/{id} — single trade details
  Future<SingleTradeResponseDto> getTrade(String tradeId) async {
    final accountId = await _getAccountId();
    final response = await _dio.get(
        OandaApiConstants.tradeById(accountId, tradeId));
    return SingleTradeResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// PUT /accounts/{id}/trades/{id}/close — close a trade (full or partial)
  Future<OrderFillResponseDto> closeTrade({
    required String tradeId,
    double? units, // null = full close
  }) async {
    final accountId = await _getAccountId();
    final body = units != null
        ? {'units': units.abs().toStringAsFixed(0)}
        : {'units': 'ALL'};

    final response = await _dio.put(
      OandaApiConstants.closeTradeById(accountId, tradeId),
      data: body,
    );
    return OrderFillResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// PUT /accounts/{id}/trades/{id}/orders — modify SL/TP of a trade
  Future<ModifyTradeResponseDto> modifyTrade({
    required String tradeId,
    double? takeProfitPrice,
    double? stopLossPrice,
    int displayPrecision = 5,
  }) async {
    final accountId = await _getAccountId();

    final body = <String, dynamic>{};

    if (takeProfitPrice != null) {
      body['takeProfit'] = {
        'price': takeProfitPrice.toStringAsFixed(displayPrecision),
        'timeInForce': 'GTC',
      };
    } else {
      // Explicitly cancel TP if null passed
      body['takeProfit'] = {}; // empty = cancel
    }

    if (stopLossPrice != null) {
      body['stopLoss'] = {
        'price': stopLossPrice.toStringAsFixed(displayPrecision),
        'timeInForce': 'GTC',
      };
    } else {
      body['stopLoss'] = {}; // empty = cancel
    }

    // Remove empty entries to avoid unintentional cancellations
    // Only include if explicitly provided
    final cleanBody = <String, dynamic>{};
    if (takeProfitPrice != null) cleanBody['takeProfit'] = body['takeProfit'];
    if (stopLossPrice != null) cleanBody['stopLoss'] = body['stopLoss'];

    final response = await _dio.put(
      OandaApiConstants.tradeOrders(accountId, tradeId),
      data: cleanBody,
    );
    return ModifyTradeResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  // ============================================================
  // 4.3.5 — Transaction / History Endpoints
  // ============================================================

  /// GET /accounts/{id}/transactions — trade history
  Future<TransactionsResponseDto> getTransactions({
    String? fromTime,
    String? toTime,
    int? pageSize,
    List<String>? type, // filter by transaction type
  }) async {
    final accountId = await _getAccountId();

    final queryParams = <String, dynamic>{};
    if (fromTime != null) queryParams['from'] = fromTime;
    if (toTime != null) queryParams['to'] = toTime;
    if (pageSize != null) queryParams['pageSize'] = pageSize;
    if (type != null) queryParams['type'] = type.join(',');

    final response = await _dio.get(
      OandaApiConstants.transactions(accountId),
      queryParameters: queryParams,
    );
    return TransactionsResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// GET /accounts/{id}/transactions/sinceid — transactions since last ID
  /// Used for incremental sync — only fetch new transactions.
  Future<TransactionsResponseDto> getTransactionsSince({
    required String sinceId,
    List<String>? type,
  }) async {
    final accountId = await _getAccountId();

    final queryParams = <String, dynamic>{'id': sinceId};
    if (type != null) queryParams['type'] = type.join(',');

    final response = await _dio.get(
      OandaApiConstants.transactionSince(accountId),
      queryParameters: queryParams,
    );
    return TransactionsResponseDto.fromJson(
        response.data as Map<String, dynamic>);
  }
}

// ============================================================
// 4.3.6 — Riverpod Provider
// ============================================================

final oandaRestDataSourceProvider =
    Provider<OandaRestDataSource>((ref) {
  return OandaRestDataSource(
    dio: ref.watch(dioClientProvider),
    credentials: ref.watch(credentialStorageProvider),
  );
});
