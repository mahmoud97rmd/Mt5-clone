// Path: lib/core/network/interceptors/auth_interceptor.dart
// ============================================================
// MT5 Clone — Auth Interceptor
// Injects the OANDA Bearer token into every outgoing request.
// If no token is configured, throws AuthFailure immediately.
// ============================================================

import 'package:dio/dio.dart';

import '../../security/credential_storage.dart';
import '../api_constants.dart';

class AuthInterceptor extends Interceptor {
  final CredentialStorage credentialStorage;

  AuthInterceptor({required this.credentialStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final apiKey = await credentialStorage.getApiKey();

    if (apiKey == null || apiKey.isEmpty) {
      // Reject immediately — no point hitting the API without auth
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message: 'OANDA API key not configured. '
              'Please enter your API key in Settings.',
        ),
      );
      return;
    }

    // Inject OANDA Bearer token format: "Bearer <token>"
    options.headers[OandaApiConstants.headerAuthorization] =
        'Bearer $apiKey';

    handler.next(options);
  }
}
