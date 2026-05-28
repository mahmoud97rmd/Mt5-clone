// Path: lib/features/trading/presentation/widgets/modify_position_sheet.dart
// ============================================================
// MT5 Clone — Modify Position Sheet
// Bottom sheet for editing Stop Loss and Take Profit of an open position.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/position_entity.dart';
import '../../data/repositories/trading_repository_impl.dart';

class ModifyPositionSheet extends ConsumerStatefulWidget {
  final PositionEntity position;

  const ModifyPositionSheet({super.key, required this.position});

  static Future<void> show(BuildContext context, PositionEntity position) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => ModifyPositionSheet(position: position),
    );
  }

  @override
  ConsumerState<ModifyPositionSheet> createState() =>
      _ModifyPositionSheetState();
}

class _ModifyPositionSheetState extends ConsumerState<ModifyPositionSheet> {
  late TextEditingController _slController;
  late TextEditingController _tpController;
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _slController = TextEditingController(
      text: widget.position.stopLoss?.toStringAsFixed(5) ?? '',
    );
    _tpController = TextEditingController(
      text: widget.position.takeProfit?.toStringAsFixed(5) ?? '',
    );
  }

  @override
  void dispose() {
    _slController.dispose();
    _tpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pos = widget.position;
    final isBuy = pos.direction.isBuy;
    final dirColor = AppTheme.directionColor(isBuy);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ────────────────────────────────────────
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

            // ── Position Info ─────────────────────────────────
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
                  pos.symbol,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${pos.lots.toStringAsFixed(2)} lot',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // ── Open / Current Price ──────────────────────────
            Row(
              children: [
                _InfoChip(label: 'Open', value: pos.openPrice.toStringAsFixed(5)),
                SizedBox(width: 12.w),
                _InfoChip(
                  label: 'Current',
                  value: pos.currentPrice.toStringAsFixed(5),
                  valueColor: dirColor,
                ),
                SizedBox(width: 12.w),
                _InfoChip(
                  label: 'P&L',
                  value:
                      '${pos.floatingPnl >= 0 ? '+' : ''}${pos.floatingPnl.toStringAsFixed(2)}',
                  valueColor: AppTheme.pnlColor(pos.floatingPnl),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // ── Stop Loss ────────────────────────────────────
            Text(
              'Stop Loss',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.sellRed,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _slController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14.sp,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'No SL',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppTheme.textDisabled,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      filled: true,
                      fillColor: AppTheme.surfaceElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide:
                            const BorderSide(color: AppTheme.surfaceBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide:
                            const BorderSide(color: AppTheme.surfaceBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                            color: AppTheme.sellRed, width: 1.5),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                _ClearButton(
                  onTap: () => _slController.clear(),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Take Profit ──────────────────────────────────
            Text(
              'Take Profit',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.buyGreen,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tpController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14.sp,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'No TP',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13.sp,
                        color: AppTheme.textDisabled,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      filled: true,
                      fillColor: AppTheme.surfaceElevated,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide:
                            const BorderSide(color: AppTheme.surfaceBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide:
                            const BorderSide(color: AppTheme.surfaceBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.r),
                        borderSide: const BorderSide(
                            color: AppTheme.buyGreen, width: 1.5),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                _ClearButton(
                  onTap: () => _tpController.clear(),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Error ─────────────────────────────────────────
            if (_error != null)
              Container(
                padding: EdgeInsets.all(8.w),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: AppTheme.sellRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                      color: AppTheme.sellRed.withValues(alpha: 0.3)),
                ),
                child: Text(
                  _error!,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: AppTheme.sellRed,
                  ),
                ),
              ),

            // ── Submit ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryTeal,
                  foregroundColor: AppTheme.backgroundPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.backgroundPrimary,
                        ),
                      )
                    : Text(
                        'Modify Position',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final sl = double.tryParse(_slController.text);
    final tp = double.tryParse(_tpController.text);

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final repo = ref.read(tradingRepositoryProvider);
    final result = await repo.modifyPosition(
      oandaTradeId: widget.position.oandaTradeId,
      stopLoss: sl,
      takeProfit: tp,
    );

    result.fold(
      (failure) {
        setState(() {
          _isSubmitting = false;
          _error = failure.message;
        });
      },
      (_) {
        Navigator.pop(context);
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoChip({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _ClearButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
        ),
        child: Icon(Icons.clear, size: 16.sp, color: AppTheme.textMuted),
      ),
    );
  }
}
