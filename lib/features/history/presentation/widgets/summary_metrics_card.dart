// Path: lib/features/history/presentation/widgets/summary_metrics_card.dart
// ============================================================
// MT5 Clone — Summary Metrics Card
// Displays trade summary: total P&L, win rate, profit factor, etc.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/repositories/repositories.dart';

class SummaryMetricsCard extends StatelessWidget {
  final TradeSummaryEntity summary;

  const SummaryMetricsCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Summary',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),

          // ── Net P&L ──────────────────────────────────────
          Center(
            child: Column(
              children: [
                Text(
                  '${summary.totalNetProfit >= 0 ? '+' : ''}'
                  '${summary.totalNetProfit.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.pnlColor(summary.totalNetProfit),
                  ),
                ),
                Text(
                  'Net Profit',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // ── Metrics Grid ─────────────────────────────────
          Row(
            children: [
              _MetricTile(
                label: 'Total Trades',
                value: summary.totalTrades.toString(),
              ),
              _MetricTile(
                label: 'Win Rate',
                value: '${summary.winRate.toStringAsFixed(1)}%',
                valueColor: summary.winRate >= 50
                    ? AppTheme.buyGreen
                    : AppTheme.sellRed,
              ),
              _MetricTile(
                label: 'Profit Factor',
                value: summary.profitFactor.toStringAsFixed(2),
                valueColor: summary.profitFactor >= 1
                    ? AppTheme.buyGreen
                    : AppTheme.sellRed,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _MetricTile(
                label: 'Avg Win',
                value: '+${summary.averageProfit.toStringAsFixed(2)}',
                valueColor: AppTheme.buyGreen,
              ),
              _MetricTile(
                label: 'Avg Loss',
                value: summary.averageLoss.toStringAsFixed(2),
                valueColor: AppTheme.sellRed,
              ),
              _MetricTile(
                label: 'Win/Loss',
                value: '${summary.winningTrades}/${summary.losingTrades}',
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _MetricTile(
                label: 'Largest Win',
                value: '+${summary.largestWin.toStringAsFixed(2)}',
                valueColor: AppTheme.buyGreen,
              ),
              _MetricTile(
                label: 'Largest Loss',
                value: summary.largestLoss.toStringAsFixed(2),
                valueColor: AppTheme.sellRed,
              ),
              _MetricTile(
                label: 'Swap',
                value: summary.totalSwap.toStringAsFixed(2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: AppTheme.textMuted,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
