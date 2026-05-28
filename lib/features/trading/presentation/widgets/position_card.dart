// Path: lib/features/trading/presentation/widgets/position_card.dart
// ============================================================
// MT5 Clone — Position Card
// Displays a single open position with PnL, SL/TP, and actions.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/position_entity.dart';

class PositionCard extends StatelessWidget {
  final PositionEntity position;
  final VoidCallback? onClose;
  final VoidCallback? onModify;
  final VoidCallback? onTap;

  const PositionCard({
    super.key,
    required this.position,
    this.onClose,
    this.onModify,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = position.direction.isBuy;
    final dirColor = AppTheme.directionColor(isBuy);
    final pnlColor = AppTheme.pnlColor(position.floatingPnl);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
        ),
        child: Column(
          children: [
            // ── Header: Symbol + Direction + Lots ────────────
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: dirColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    isBuy ? 'BUY' : 'SELL',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: dirColor,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  position.symbol,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${position.lots.toStringAsFixed(2)} lot',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (position.isEaPosition) ...[
                  SizedBox(width: 6.w),
                  Icon(Icons.smart_toy,
                      size: 14.sp, color: AppTheme.primaryTeal),
                ],
              ],
            ),
            SizedBox(height: 8.h),

            // ── Prices Row ───────────────────────────────────
            Row(
              children: [
                _PriceColumn(
                  label: 'Open',
                  value: position.openPrice.toStringAsFixed(5),
                ),
                _PriceColumn(
                  label: 'Current',
                  value: position.currentPrice.toStringAsFixed(5),
                  valueColor: dirColor,
                ),
                _PriceColumn(
                  label: 'SL',
                  value: position.stopLoss?.toStringAsFixed(5) ?? '—',
                  valueColor: position.hasStopLoss
                      ? AppTheme.sellRed
                      : AppTheme.textDisabled,
                ),
                _PriceColumn(
                  label: 'TP',
                  value: position.takeProfit?.toStringAsFixed(5) ?? '—',
                  valueColor: position.hasTakeProfit
                      ? AppTheme.buyGreen
                      : AppTheme.textDisabled,
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // ── PnL + Actions Row ────────────────────────────
            Row(
              children: [
                Text(
                  '${position.floatingPnl >= 0 ? '+' : ''}'
                  '${position.floatingPnl.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: pnlColor,
                  ),
                ),
                SizedBox(width: 4.w),
                const Spacer(),
                if (onModify != null)
                  _ActionChip(
                    icon: Icons.tune,
                    label: 'Modify',
                    onTap: onModify!,
                  ),
                SizedBox(width: 8.w),
                if (onClose != null)
                  _ActionChip(
                    icon: Icons.close,
                    label: 'Close',
                    color: AppTheme.sellRed,
                    onTap: onClose!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _PriceColumn({
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
              color: AppTheme.textMuted,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primaryTeal;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: c.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.sp, color: c),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: c,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
