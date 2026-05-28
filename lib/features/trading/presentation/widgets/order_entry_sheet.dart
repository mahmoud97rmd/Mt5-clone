// Path: lib/features/trading/presentation/widgets/order_entry_sheet.dart
// ============================================================
// MT5 Clone — Order Entry Sheet
// Bottom sheet for placing market or pending orders.
// Direction toggle, lot size, SL/TP, limit price.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../../quotes/presentation/providers/quote_providers.dart';
import '../notifiers/trading_notifiers.dart';

class OrderEntrySheet extends ConsumerStatefulWidget {
  final String symbol;

  const OrderEntrySheet({super.key, required this.symbol});

  static Future<void> show(BuildContext context, String symbol) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => OrderEntrySheet(symbol: symbol),
    );
  }

  @override
  ConsumerState<OrderEntrySheet> createState() => _OrderEntrySheetState();
}

class _OrderEntrySheetState extends ConsumerState<OrderEntrySheet> {
  final _lotsController = TextEditingController(text: '0.01');
  final _slController = TextEditingController();
  final _tpController = TextEditingController();
  final _limitPriceController = TextEditingController();

  @override
  void dispose() {
    _lotsController.dispose();
    _slController.dispose();
    _tpController.dispose();
    _limitPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier =
        ref.read(orderEntryNotifierProvider(widget.symbol).notifier);
    final state = ref.watch(orderEntryNotifierProvider(widget.symbol));
    final tick = ref.watch(symbolTickProvider(widget.symbol));

    final currentBid = tick.value?.bid ?? 0;
    final currentAsk = tick.value?.ask ?? 0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.all(16.w),
            children: [
              // ── Handle Bar ──────────────────────────────────
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: AppTheme.textMuted,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // ── Symbol + Current Price ──────────────────────
              Row(
                children: [
                  Text(
                    widget.symbol,
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  _PriceQuote(
                    label: 'BID',
                    price: currentBid,
                    color: AppTheme.sellRed,
                  ),
                  SizedBox(width: 16.w),
                  _PriceQuote(
                    label: 'ASK',
                    price: currentAsk,
                    color: AppTheme.buyGreen,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // ── Direction Toggle ────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _DirectionButton(
                      label: 'BUY',
                      color: AppTheme.buyGreen,
                      isSelected: state.direction == TradeDirection.buy,
                      onTap: () => notifier.setDirection(TradeDirection.buy),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _DirectionButton(
                      label: 'SELL',
                      color: AppTheme.sellRed,
                      isSelected: state.direction == TradeDirection.sell,
                      onTap: () => notifier.setDirection(TradeDirection.sell),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // ── Order Type Selector ─────────────────────────
              Row(
                children: OrderType.values.take(4).map((type) {
                  final isSelected = state.orderType == type;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            type.shortName,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primaryTeal
                                  : AppTheme.textMuted,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppTheme.primaryTealGlow,
                        backgroundColor: AppTheme.surfaceElevated,
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primaryTeal
                              : AppTheme.surfaceBorder,
                        ),
                        onSelected: (_) => notifier.setOrderType(type),
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),

              // ── Lot Size ───────────────────────────────────
              _InputField(
                label: 'Lot Size',
                controller: _lotsController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) {
                  final lots = double.tryParse(val);
                  if (lots != null && lots > 0) notifier.setLots(lots);
                },
              ),
              SizedBox(height: 12.h),

              // ── Limit Price (only for pending orders) ──────
              if (state.orderType != OrderType.market)
                _InputField(
                  label: 'Limit Price',
                  controller: _limitPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (val) {
                    final price = double.tryParse(val);
                    notifier.setLimitPrice(price);
                  },
                ),
              if (state.orderType != OrderType.market)
                SizedBox(height: 12.h),

              // ── Stop Loss ──────────────────────────────────
              _InputField(
                label: 'Stop Loss (optional)',
                controller: _slController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) {
                  final sl = double.tryParse(val);
                  notifier.setStopLoss(sl);
                },
              ),
              SizedBox(height: 12.h),

              // ── Take Profit ────────────────────────────────
              _InputField(
                label: 'Take Profit (optional)',
                controller: _tpController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) {
                  final tp = double.tryParse(val);
                  notifier.setTakeProfit(tp);
                },
              ),
              SizedBox(height: 16.h),

              // ── Error Message ───────────────────────────────
              if (state.errorMessage != null)
                Container(
                  padding: EdgeInsets.all(8.w),
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: AppTheme.sellRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                        color: AppTheme.sellRed.withOpacity(0.3)),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppTheme.sellRed,
                    ),
                  ),
                ),

              // ── Submit Button ───────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: state.isSubmitting
                      ? null
                      : () => _submitOrder(state, notifier),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: state.direction == TradeDirection.buy
                        ? AppTheme.buyGreen
                        : AppTheme.sellRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: state.isSubmitting
                      ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '${state.direction == TradeDirection.buy ? 'Buy' : 'Sell'} '
                          '${state.orderType == OrderType.market ? 'Market' : 'Pending'}',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submitOrder(OrderEntryState state, OrderEntryNotifier notifier) {
    if (state.orderType == OrderType.market) {
      notifier.submitMarketOrder();
    }
    // Pending order submission would call a different method
  }
}

class _PriceQuote extends StatelessWidget {
  final String label;
  final double price;
  final Color color;

  const _PriceQuote({
    required this.label,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
        ),
        Text(
          price.toStringAsFixed(5),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _DirectionButton({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? color : AppTheme.surfaceBorder,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? color : AppTheme.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14.sp,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            filled: true,
            fillColor: AppTheme.surfaceElevated,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(color: AppTheme.surfaceBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide: const BorderSide(color: AppTheme.surfaceBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.r),
              borderSide:
                  const BorderSide(color: AppTheme.primaryTeal, width: 1.5),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
        ),
      ],
    );
  }
}
