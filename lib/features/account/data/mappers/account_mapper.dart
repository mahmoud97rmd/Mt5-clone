// Path: lib/features/account/data/mappers/account_mapper.dart
// ============================================================
// MT5 Clone — Account & Instrument Mappers
// Converts account and instrument DTOs → domain entities.
// ============================================================

import '../../../../core/domain/entities/account_entity.dart';
import '../../../../core/domain/entities/symbol_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../models/account_dto.dart';

// ============================================================
// Account DTO → Domain Entity
// ============================================================

class AccountDtoMapper {
  const AccountDtoMapper._();

  static AccountEntity fromSummaryDto(
    AccountSummaryDto dto, {
    bool isLive = false,
  }) {
    final marginLevel = dto.marginUsedValue > 0
        ? (dto.navValue / dto.marginUsedValue) * 100.0
        : null;
    final leverage = dto.marginRateValue > 0
        ? (1.0 / dto.marginRateValue).round()
        : 50;

    return AccountEntity(
      accountId: dto.id,
      currency: dto.currency,
      alias: dto.alias ?? '',
      isLive: isLive,
      leverage: leverage,
      balance: dto.balanceValue,
      equity: dto.navValue,
      marginUsed: dto.marginUsedValue,
      marginAvailable: dto.marginAvailableValue,
      marginLevel: marginLevel,
      nav: dto.navValue,
      openPositionCount: dto.openTradeCount,
      unrealizedPnl: dto.unrealizedPlValue,
      dailyRealizedPnl: dto.realizedPlValue,
      lastUpdated: DateTime.now(),
    );
  }
}

// ============================================================
// Instrument DTO → Symbol Entity
// ============================================================

class InstrumentDtoMapper {
  const InstrumentDtoMapper._();

  static SymbolEntity toEntity(InstrumentDto dto) {
    final pipSize = _pipSizeFromLocation(dto.pipLocationValue);

    return SymbolEntity(
      name: dto.name,
      displayName: dto.displayName,
      displayLabel: dto.name.replaceAll('_', ''),
      type: InstrumentType.fromString(dto.type),
      pipSize: pipSize,
      pipLocation: dto.pipLocationValue,
      unitsPerLot: dto.type.contains('METALS') ? 100.0 : 100000.0,
      displayPrecision: dto.displayPrecision,
      marginRate: dto.marginRateValue,
      minimumTradeSize: dto.minimumTradeSizeValue,
      tradeUnitsPrecision: dto.tradeUnitsPrecision.toDouble(),
      isWatchlisted: _isDefaultWatchlisted(dto.name),
      watchlistSortOrder: _defaultOrder(dto.name),
      sortOrder: _defaultOrder(dto.name),
    );
  }

  static List<SymbolEntity> toEntityList(List<InstrumentDto> dtos) =>
      dtos.map(toEntity).toList();

  static double _pipSizeFromLocation(int pipLocation) {
    double size = 1.0;
    final exp = -pipLocation;
    for (int i = 0; i < exp; i++) size /= 10.0;
    return size;
  }

  static bool _isDefaultWatchlisted(String name) =>
      const ['XAU_USD', 'EUR_USD', 'GBP_USD', 'USD_JPY']
          .contains(name);

  static int _defaultOrder(String name) {
    const order = {
      'XAU_USD': 1,
      'EUR_USD': 2,
      'GBP_USD': 3,
      'USD_JPY': 4,
    };
    return order[name] ?? 999;
  }
}
