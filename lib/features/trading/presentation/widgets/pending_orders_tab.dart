// Path: lib/features/trading/presentation/widgets/pending_orders_tab.dart
// ============================================================
// MT5 Clone — Pending Orders Tab
// Lists all pending orders with cancel action.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/order_entity.dart';
import '../notifiers/trading_notifiers.dart';

class PendingOrdersTab extends ConsumerWidget {
  const PendingOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pendingOrdersNotifierProvider);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryTeal),
      );
    }

    if (state.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pending_actions,
                size: 48.sp, color: AppTheme.textDisabled),
            SizedBox(height: 12.h),
            Text(
              'No pending orders',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(8.w),
      itemCount: state.orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 6.h),
      itemBuilder: (context, index) {
        final order = state.orders[index];
        return _OrderCard(
          order: order,
          onCancel: () => _confirmCancel(context, ref, order.oandaOrderId),
        );
      },
    );
  }

  void _confirmCancel(
      BuildContext context, WidgetRef ref, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Cancel this pending order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(pendingOrdersNotifierProvider.notifier)
                  .cancelOrder(orderId);
            },
            child: Text('Cancel Order',
                style: TextStyle(color: AppTheme.sellRed)),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback onCancel;

  const _OrderCard({required this.order, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final isBuy = order.direction.isBuy;
    final dirColor = AppTheme.directionColor(isBuy);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
      ),
      child: Column(
        children: [
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
                  order.orderType.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: dirColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                order.symbol,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${order.lots.toStringAsFixed(2)} lot',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _InfoCell(label: 'Price', value: order.price.toStringAsFixed(5)),
              _InfoCell(
                label: 'SL',
                value: order.stopLoss?.toStringAsFixed(5) ?? '—',
                valueColor: order.stopLoss != null
                    ? AppTheme.sellRed
                    : AppTheme.textDisabled,
              ),
              _InfoCell(
                label: 'TP',
                value: order.takeProfit?.toStringAsFixed(5) ?? '—',
                valueColor: order.takeProfit != null
                    ? AppTheme.buyGreen
                    : AppTheme.textDisabled,
              ),
              const Spacer(),
              InkWell(
                onTap: onCancel,
                borderRadius: BorderRadius.circular(4.r),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.sellRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                        color: AppTheme.sellRed.withValues(alpha: 0.3), width: 0.5),
                  ),
                  child: Text(
                    'Cancel',
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
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
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
              color: valueColor ?? AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
