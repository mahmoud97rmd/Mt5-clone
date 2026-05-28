// Path: lib/features/trading/presentation/widgets/open_positions_tab.dart
// ============================================================
// MT5 Clone — Open Positions Tab
// Lists all open positions with pull-to-refresh and close-all.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../notifiers/trading_notifiers.dart';
import 'position_card.dart';

class OpenPositionsTab extends ConsumerWidget {
  final void Function(String tradeId)? onModifyPosition;

  const OpenPositionsTab({super.key, this.onModifyPosition});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(openPositionsNotifierProvider);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryTeal),
      );
    }

    if (state.positions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart,
                size: 48.sp, color: AppTheme.textDisabled),
            SizedBox(height: 12.h),
            Text(
              'No open positions',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // ── Summary Bar ──────────────────────────────────────
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: const BoxDecoration(
            color: AppTheme.surfaceCard,
            border: Border(
              bottom: BorderSide(color: AppTheme.surfaceBorder, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Text(
                '${state.positions.length} position${state.positions.length > 1 ? 's' : ''}',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'Total P&L: ',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: AppTheme.textMuted,
                ),
              ),
              Text(
                '${state.totalFloatingPnl >= 0 ? '+' : ''}'
                '${state.totalFloatingPnl.toStringAsFixed(2)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.pnlColor(state.totalFloatingPnl),
                ),
              ),
              SizedBox(width: 12.w),
              InkWell(
                onTap: state.isClosingAll
                    ? null
                    : () => _showCloseAllDialog(context, ref),
                borderRadius: BorderRadius.circular(4.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.sellRed.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                        color: AppTheme.sellRed.withOpacity(0.3), width: 0.5),
                  ),
                  child: state.isClosingAll
                      ? SizedBox(
                          width: 14.sp,
                          height: 14.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.sellRed,
                          ),
                        )
                      : Text(
                          'Close All',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.sellRed,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),

        // ── Positions List ───────────────────────────────────
        Expanded(
          child: RefreshIndicator(
            color: AppTheme.primaryTeal,
            onRefresh: () async {},
            child: ListView.separated(
              padding: EdgeInsets.all(8.w),
              itemCount: state.positions.length,
              separatorBuilder: (_, __) => SizedBox(height: 6.h),
              itemBuilder: (context, index) {
                final pos = state.positions[index];
                return PositionCard(
                  position: pos,
                  onClose: () => _confirmClose(context, ref, pos.oandaTradeId),
                  onModify: onModifyPosition != null
                      ? () => onModifyPosition!(pos.oandaTradeId)
                      : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _confirmClose(
      BuildContext context, WidgetRef ref, String tradeId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close Position'),
        content: const Text('Are you sure you want to close this position?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(openPositionsNotifierProvider.notifier)
                  .closePosition(tradeId);
            },
            child: Text('Close',
                style: TextStyle(color: AppTheme.sellRed)),
          ),
        ],
      ),
    );
  }

  void _showCloseAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close All Positions'),
        content: const Text(
            'This will close ALL open positions. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(openPositionsNotifierProvider.notifier)
                  .closeAll();
            },
            child: Text('Close All',
                style: TextStyle(color: AppTheme.sellRed)),
          ),
        ],
      ),
    );
  }
}
