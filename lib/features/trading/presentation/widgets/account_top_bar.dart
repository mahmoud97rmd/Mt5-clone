// Path: lib/features/trading/presentation/widgets/account_top_bar.dart
// ============================================================
// MT5 Clone — Account Top Bar
// Collapsible metrics bar showing Balance, Equity, Margin, etc.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../account/presentation/providers/account_providers.dart';

class AccountTopBar extends ConsumerWidget {
  const AccountTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(topBarMetricsProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundSecondary,
        border: Border(
          bottom: BorderSide(color: AppTheme.surfaceBorder, width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Row 1: Balance | Equity | PnL ──────────────────
          Row(
            children: [
              _MetricCell(
                label: 'Balance',
                value: metrics.balanceDisplay,
              ),
              _Divider(),
              _MetricCell(
                label: 'Equity',
                value: metrics.equityDisplay,
              ),
              _Divider(),
              _MetricCell(
                label: 'P&L',
                value: metrics.unrealizedPnlDisplay,
                valueColor: AppTheme.pnlColor(metrics.unrealizedPnl),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // ── Row 2: Margin Used | Free Margin | Margin Lvl ──
          Row(
            children: [
              _MetricCell(
                label: 'Margin',
                value: metrics.marginUsedDisplay,
              ),
              _Divider(),
              _MetricCell(
                label: 'Free',
                value: metrics.freeMarginDisplay,
              ),
              _Divider(),
              _MetricCell(
                label: 'Margin Lvl',
                value: metrics.marginLevelDisplay,
                valueColor: AppTheme.marginLevelColor(metrics.marginLevel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
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
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 28.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      color: AppTheme.surfaceBorder,
    );
  }
}
