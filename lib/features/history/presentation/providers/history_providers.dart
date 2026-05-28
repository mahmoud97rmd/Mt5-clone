// Path: lib/features/history/presentation/providers/history_providers.dart
// ============================================================
// MT5 Clone — History Providers
// Riverpod providers for trade history, summaries, and daily P&L.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/closed_trade_entity.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../../core/domain/repositories/repositories.dart';
import '../../data/repositories/history_repository_impl.dart';

// ── Date Range ──────────────────────────────────────────────

final historyDateRangeProvider = StateProvider<DateRange>((ref) {
  final now = DateTime.now();
  return DateRange(
    start: now.subtract(const Duration(days: 30)),
    end: now,
  );
});

// ── Filter State ────────────────────────────────────────────

final historySymbolFilterProvider = StateProvider<String?>((ref) => null);
final historyDirectionFilterProvider =
    StateProvider<TradeDirection?>((ref) => null);

// ── Closed Trades ───────────────────────────────────────────

final closedTradesProvider =
    FutureProvider<List<ClosedTradeEntity>>((ref) async {
  final range = ref.watch(historyDateRangeProvider);
  final symbol = ref.watch(historySymbolFilterProvider);
  final direction = ref.watch(historyDirectionFilterProvider);
  final repo = ref.watch(historyRepositoryProvider);

  final result = await repo.getClosedTrades(
    from: range.start,
    to: range.end,
    symbol: symbol,
    direction: direction,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (trades) => trades,
  );
});

// ── Trade Summary ───────────────────────────────────────────

final tradeSummaryProvider =
    FutureProvider<TradeSummaryEntity>((ref) async {
  final range = ref.watch(historyDateRangeProvider);
  final symbol = ref.watch(historySymbolFilterProvider);
  final repo = ref.watch(historyRepositoryProvider);

  final result = await repo.getTradeSummary(
    from: range.start,
    to: range.end,
    symbol: symbol,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (summary) => summary,
  );
});

// ── Daily P&L ───────────────────────────────────────────────

final dailyPnlHistoryProvider =
    FutureProvider<List<DailyPnlEntity>>((ref) async {
  final range = ref.watch(historyDateRangeProvider);
  final repo = ref.watch(historyRepositoryProvider);

  final result = await repo.getDailyPnl(
    from: range.start,
    to: range.end,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (daily) => daily,
  );
});

class DateRange {
  final DateTime start;
  final DateTime end;
  const DateRange({required this.start, required this.end});
}
