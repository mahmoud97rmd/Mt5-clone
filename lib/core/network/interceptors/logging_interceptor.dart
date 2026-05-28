// Path: lib/core/network/interceptors/logging_interceptor.dart
// ============================================================
// MT5 Clone — Logging Interceptor
// Dio interceptor for HTTP request/response logging.
// ============================================================

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggingInterceptor extends Interceptor {
  final Logger _log = Logger(
    printer: PrettyPrinter(methodCount: 0, printTime: true),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log.d(
      '┌─ REQUEST: ${options.method} ${options.uri}\n'
      '├─ Headers: ${options.headers}\n'
      '└─ Data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log.d(
      '┌─ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}\n'
      '└─ Data: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log.e(
      '┌─ ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}\n'
      '├─ Type: ${err.type}\n'
      '└─ Message: ${err.message}',
    );
    handler.next(err);
  }
}
