// Path: lib/features/history/presentation/widgets/closed_trade_card.dart
// ============================================================
// MT5 Clone — Closed Trade Card
// Displays a single closed trade in the history list.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/closed_trade_entity.dart';

class ClosedTradeCard extends StatelessWidget {
  final ClosedTradeEntity trade;

  const ClosedTradeCard({super.key, required this.trade});

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.direction.isBuy;
    final dirColor = AppTheme.directionColor(isBuy);
    final pnlColor = AppTheme.pnlColor(trade.netPnl);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
      ),
      child: Column(
        children: [
          // ── Header Row ─────────────────────────────────────
          Row(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
                trade.symbol,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${trade.lots.toStringAsFixed(2)} lot',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppTheme.textMuted,
                ),
              ),
              const Spacer(),
              if (trade.isEaTrade)
                Icon(Icons.smart_toy,
                    size: 14.sp, color: AppTheme.primaryTeal),
              SizedBox(width: 4.w),
              Text(
                _closeReasonLabel(trade.closeReason),
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // ── Prices Row ─────────────────────────────────────
          Row(
            children: [
              _PriceInfo(
                label: 'Open',
                value: trade.openPrice.toStringAsFixed(5),
              ),
              _PriceInfo(
                label: 'Close',
                value: trade.closePrice.toStringAsFixed(5),
              ),
              _PriceInfo(
                label: 'Duration',
                value: trade.durationDisplay,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${trade.netPnl >= 0 ? '+' : ''}'
                    '${trade.netPnl.toStringAsFixed(2)}',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: pnlColor,
                    ),
                  ),
                  if (trade.swap != 0)
                    Text(
                      'Swap: ${trade.swap.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: AppTheme.textMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _closeReasonLabel(dynamic reason) {
    switch (reason.toString()) {
      case 'CloseReason.stopLoss':
        return 'SL';
      case 'CloseReason.takeProfit':
        return 'TP';
      case 'CloseReason.marginCall':
        return 'MC';
      default:
        return '';
    }
  }
}

class _PriceInfo extends StatelessWidget {
  final String label;
  final String value;

  const _PriceInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.w,
      margin: EdgeInsets.only(right: 8.w),
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
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
