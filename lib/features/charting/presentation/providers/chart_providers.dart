// Path: lib/features/charting/presentation/providers/chart_providers.dart
// ============================================================
// MT5 Clone — Chart Riverpod Providers
// Convenience providers used by chart widgets.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/candle_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../notifiers/chart_notifier.dart';

// ── Candles for a specific symbol + timeframe ────────────────

typedef ChartKey = ({String symbol, Timeframe timeframe});

final visibleCandlesProvider =
    Provider.autoDispose.family<List<CandleEntity>, String>(
  (ref, symbol) {
    final state = ref.watch(chartNotifierProvider(symbol));
    return state.visibleCandles;
  },
);

/// Current visible price range for a symbol's chart
final chartPriceRangeProvider =
    Provider.autoDispose.family<({double high, double low}), String>(
  (ref, symbol) {
    final state = ref.watch(chartNotifierProvider(symbol));
    return (
      high: state.visibleHigh ?? 0.0,
      low: state.visibleLow ?? 0.0,
    );
  },
);

/// Is the chart in crosshair mode for a given symbol?
final isCrosshairActiveProvider =
    Provider.autoDispose.family<bool, String>(
  (ref, symbol) {
    return ref
        .watch(chartNotifierProvider(symbol))
        .crosshair
        .isActive;
  },
);

/// Selected candle data in crosshair mode
final crosshairCandleProvider =
    Provider.autoDispose.family<CandleEntity?, String>(
  (ref, symbol) {
    return ref
        .watch(chartNotifierProvider(symbol))
        .crosshair
        .candle;
  },
);
