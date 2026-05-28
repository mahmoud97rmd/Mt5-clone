// Path: lib/features/quotes/presentation/providers/quote_providers.dart
// ============================================================
// MT5 Clone — Quote Providers
// Riverpod providers for market watch / quotes screen.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/symbol_entity.dart';
import '../../../../core/domain/entities/tick_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../data/datasources/oanda_streaming_service.dart';
import '../../data/models/stream_dto.dart';
import '../../../account/data/repositories/account_repository_impl.dart';
import '../../../account/presentation/providers/account_providers.dart';

// ── Market Watch Item ─────────────────────────────────────────

class MarketWatchItem {
  final SymbolEntity symbol;
  final TickEntity? tick;

  const MarketWatchItem({required this.symbol, this.tick});

  double? get bid => tick?.bid;
  double? get ask => tick?.ask;
  double? get spread => tick?.spread;
}

// ── View Mode ─────────────────────────────────────────────────

final quoteViewModeProvider = StateProvider<QuoteViewMode>(
  (ref) => QuoteViewMode.simple,
);

// ── Search Query ──────────────────────────────────────────────

final quoteSearchQueryProvider = StateProvider<String>(
  (ref) => '',
);

// ── Watchlisted Symbols ───────────────────────────────────────

final watchlistedSymbolNamesProvider = Provider<List<String>>((ref) {
  final watchlist = ref.watch(watchlistProvider);
  return watchlist.maybeWhen(
    data: (symbols) => symbols.map((s) => s.name).toList(),
    orElse: () => ['XAU_USD', 'EUR_USD', 'GBP_USD', 'USD_JPY'],
  );
});

// ── Stream Connection State ───────────────────────────────────

final streamConnectionStateProvider =
    StreamProvider<StreamConnectionState>((ref) {
  final service = ref.watch(oandaStreamingServiceProvider);
  return service.connectionState;
});

// ── Symbol Tick Provider ──────────────────────────────────────

final symbolTickProvider =
    StreamProvider.family<TickEntity?, String>((ref, symbol) {
  final service = ref.watch(oandaStreamingServiceProvider);
  return service.tickStream.where((tick) => tick.symbol == symbol);
});

// ── Market Watch Provider ─────────────────────────────────────

final marketWatchProvider =
    StreamProvider<List<MarketWatchItem>>((ref) {
  final symbols = ref.watch(watchlistedSymbolNamesProvider);
  final service = ref.watch(oandaStreamingServiceProvider);

  return service.tickStream.map((tick) {
    // Build market watch items from latest ticks
    return symbols.map((symbolName) {
      final symbol = SymbolEntity(
        name: symbolName,
        displayName: symbolName.replaceAll('_', '/'),
        pipSize: symbolName.contains('XAU') ? 0.01 : 0.0001,
        pipLocation: symbolName.contains('XAU') ? -2 : -4,
        unitsPerLot: symbolName.contains('XAU') ? 100 : 100000,
        displayPrecision: symbolName.contains('XAU') ? 2 : 5,
      );

      final latestTick = service.getLatestTick(symbolName);
      return MarketWatchItem(symbol: symbol, tick: latestTick);
    }).toList();
  });
});

// ── Stream Bootstrap Provider ─────────────────────────────────

final streamBootstrapProvider = FutureProvider<void>((ref) async {
  final _ = ref.watch(accountRepositoryProvider);
  final service = ref.watch(oandaStreamingServiceProvider);

  // Get watchlist symbols
  final symbols = ref.watch(watchlistedSymbolNamesProvider);
  if (symbols.isNotEmpty) {
    await service.connect(symbols);
  }
});
