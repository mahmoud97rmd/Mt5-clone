// Path: lib/features/charting/presentation/notifiers/indicator_notifier.dart
// ============================================================
// MT5 Clone — Indicator Notifier
// Manages active indicator configurations and computed series.
// ============================================================

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/candle_entity.dart';
import '../../domain/indicators/indicator_calculators.dart';
import '../../domain/indicators/indicator_models.dart';

// ============================================================
// Indicator State
// ============================================================

class IndicatorState {
  final List<IndicatorConfig> activeIndicators;
  final List<IndicatorSeries> computedSeries;

  const IndicatorState({
    this.activeIndicators = const [],
    this.computedSeries = const [],
  });

  List<IndicatorSeries> get onChartSeries =>
      computedSeries.where((s) => s.config.type.isOnChart).toList();

  List<IndicatorSeries> get subChartSeries =>
      computedSeries.where((s) => !s.config.type.isOnChart).toList();

  IndicatorState copyWith({
    List<IndicatorConfig>? activeIndicators,
    List<IndicatorSeries>? computedSeries,
  }) {
    return IndicatorState(
      activeIndicators: activeIndicators ?? this.activeIndicators,
      computedSeries: computedSeries ?? this.computedSeries,
    );
  }
}

// ============================================================
// Indicator Notifier
// ============================================================

class IndicatorNotifier
    extends AutoDisposeFamilyNotifier<IndicatorState, String> {
  @override
  IndicatorState build(String symbol) {
    return const IndicatorState();
  }

  // ── Add Indicator ───────────────────────────────────────────

  void addIndicator(IndicatorConfig config) {
    final existing = List<IndicatorConfig>.from(state.activeIndicators);
    // Avoid duplicates
    if (existing.any((c) => c.id == config.id)) return;
    existing.add(config);
    state = state.copyWith(activeIndicators: existing);
  }

  // ── Remove Indicator ────────────────────────────────────────

  void removeIndicator(String configId) {
    final updated = state.activeIndicators
        .where((c) => c.id != configId)
        .toList();
    state = state.copyWith(activeIndicators: updated);
  }

  // ── Toggle Visibility ───────────────────────────────────────

  void toggleVisibility(String configId) {
    final updated = state.activeIndicators.map((c) {
      if (c.id == configId) {
        return c.copyWith(isVisible: !c.isVisible);
      }
      return c;
    }).toList();
    state = state.copyWith(activeIndicators: updated);
  }

  // ── Update Indicator ────────────────────────────────────────

  void updateIndicator(IndicatorConfig updatedConfig) {
    final updated = state.activeIndicators.map((c) {
      if (c.id == updatedConfig.id) return updatedConfig;
      return c;
    }).toList();
    state = state.copyWith(activeIndicators: updated);
  }

  // ── Recompute from candles ──────────────────────────────────

  void recompute(List<CandleEntity> candles) {
    final series = IndicatorCalculators.computeAll(
      candles: candles,
      configs: state.activeIndicators,
    );
    state = state.copyWith(computedSeries: series);
  }

  // ── Clear all ───────────────────────────────────────────────

  void clearAll() {
    state = const IndicatorState();
  }
}

// ============================================================
// Providers
// ============================================================

final indicatorNotifierProvider = AutoDisposeNotifierProviderFamily<
    IndicatorNotifier, IndicatorState, String>(IndicatorNotifier.new);

/// On-chart indicators for a symbol
final onChartIndicatorsProvider =
    Provider.autoDispose.family<List<IndicatorSeries>, String>((ref, symbol) {
  return ref.watch(indicatorNotifierProvider(symbol)).onChartSeries;
});

/// Sub-chart indicators for a symbol
final subChartIndicatorsProvider =
    Provider.autoDispose.family<List<IndicatorSeries>, String>((ref, symbol) {
  return ref.watch(indicatorNotifierProvider(symbol)).subChartSeries;
});

/// Active indicator configs for a symbol
final activeIndicatorConfigsProvider =
    Provider.autoDispose.family<List<IndicatorConfig>, String>((ref, symbol) {
  return ref.watch(indicatorNotifierProvider(symbol)).activeIndicators;
});
