// Path: lib/features/account/data/datasources/account_remote_datasource.dart
// ============================================================
// MT5 Clone — Account Remote Data Source
// Direct OANDA API calls for account and instrument data.
// ============================================================

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/client/dio_client.dart';
import '../../../../core/security/credential_storage.dart';
import '../models/account_dto.dart';

class AccountRemoteDataSource {
  final Dio _dio;
  final CredentialStorage _credentials;

  AccountRemoteDataSource({
    required Dio dio,
    required CredentialStorage credentials,
  })  : _dio = dio,
        _credentials = credentials;

  Future<AccountSummaryDto> getAccountSummary() async {
    final accountId = await _credentials.getAccountId();
    final response = await _dio.get(
      '${OandaApiConstants.accounts}/$accountId/summary',
    );
    return AccountSummaryDto.fromJson(response.data['account']);
  }

  Future<List<InstrumentDto>> getInstruments() async {
    final accountId = await _credentials.getAccountId();
    final response = await _dio.get(
      '${OandaApiConstants.accounts}/$accountId/instruments',
    );
    final List<dynamic> instruments = response.data['instruments'];
    return instruments
        .map((json) => InstrumentDto.fromJson(json))
        .toList();
  }
}

// ============================================================
// Riverpod Provider
// ============================================================

final accountRemoteDataSourceProvider =
    Provider<AccountRemoteDataSource>((ref) {
  return AccountRemoteDataSource(
    dio: ref.watch(dioClientProvider),
    credentials: ref.watch(credentialStorageProvider),
  );
});
