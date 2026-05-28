// Path: lib/features/history/presentation/screens/history_screen.dart
// ============================================================
// MT5 Clone — History Screen
// Trade history with summary metrics, charts, and trade list.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../providers/history_providers.dart';
import '../widgets/closed_trade_card.dart';
import '../widgets/daily_pnl_bar_chart.dart';
import '../widgets/equity_curve_chart.dart';
import '../widgets/summary_metrics_card.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final tradesAsync = ref.watch(closedTradesProvider);
    final summaryAsync = ref.watch(tradeSummaryProvider);
    final dailyPnlAsync = ref.watch(dailyPnlHistoryProvider);
    final equityCurveAsync = ref.watch(equityCurveProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trade History',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range, size: 22.sp),
            onPressed: _pickDateRange,
            tooltip: 'Date Range',
          ),
          IconButton(
            icon: Icon(Icons.filter_list, size: 22.sp),
            onPressed: _showFilters,
            tooltip: 'Filters',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryTeal,
        onRefresh: () async {
          ref.invalidate(closedTradesProvider);
          ref.invalidate(tradeSummaryProvider);
          ref.invalidate(dailyPnlHistoryProvider);
          ref.invalidate(equityCurveProvider);
        },
        child: CustomScrollView(
          slivers: [
            // ── Summary Card ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                child: summaryAsync.when(
                  data: (summary) => SummaryMetricsCard(summary: summary),
                  loading: () => _loadingCard(),
                  error: (e, _) => _errorCard(e.toString()),
                ),
              ),
            ),

            // ── Equity Curve ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                child: equityCurveAsync.when(
                  data: (points) => EquityCurveChart(points: points),
                  loading: () => _loadingCard(),
                  error: (e, _) => _errorCard(e.toString()),
                ),
              ),
            ),

            // ── Daily P&L Chart ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                child: dailyPnlAsync.when(
                  data: (daily) => DailyPnlBarChart(dailyPnl: daily),
                  loading: () => _loadingCard(),
                  error: (e, _) => _errorCard(e.toString()),
                ),
              ),
            ),

            // ── Section Header ───────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 8.h),
                child: Text(
                  'Closed Trades',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),

            // ── Trade List ───────────────────────────────────
            tradesAsync.when(
              data: (trades) {
                if (trades.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No trades in this period',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                      child: ClosedTradeCard(trade: trades[index]),
                    ),
                    childCount: trades.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                      color: AppTheme.primaryTeal),
                ),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Error: $e',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppTheme.sellRed,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final current = ref.read(historyDateRangeProvider);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: current.start,
        end: current.end,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryTeal,
              surface: AppTheme.surfaceCard,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(historyDateRangeProvider.notifier).state =
          DateRange(start: picked.start, end: picked.end);
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              // Symbol filter
              Text(
                'Symbol',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              // Direction filter chips
              Text(
                'Direction',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: ref.read(historyDirectionFilterProvider) == null,
                    onTap: () {
                      ref.read(historyDirectionFilterProvider.notifier).state =
                          null;
                    },
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: 'Buy',
                    isSelected: ref.read(historyDirectionFilterProvider)
                       ?.isBuy ==
                        true,
                    color: AppTheme.buyGreen,
                    onTap: () {
                      // ref.read(historyDirectionFilterProvider.notifier).state = TradeDirection.buy;
                    },
                  ),
                  SizedBox(width: 8.w),
                  _FilterChip(
                    label: 'Sell',
                    isSelected: ref.read(historyDirectionFilterProvider)
                        ?.isSell ==
                        true,
                    color: AppTheme.sellRed,
                    onTap: () {
                      // ref.read(historyDirectionFilterProvider.notifier).state = TradeDirection.sell;
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _loadingCard() {
    return Container(
      height: 150.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryTeal),
      ),
    );
  }

  Widget _errorCard(String message) {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppTheme.sellRed,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppTheme.primaryTeal).withValues(alpha: 0.15)
              : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? (color ?? AppTheme.primaryTeal)
                : AppTheme.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? (color ?? AppTheme.primaryTeal)
                : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }
}
