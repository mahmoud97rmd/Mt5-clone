// Path: lib/features/quotes/presentation/widgets/quote_list_item_advanced.dart
// ============================================================
// MT5 Clone — Quote List Item (Advanced View)
// Extended row showing:
//   - Symbol + type
//   - Session High / Low
//   - Bid / Ask with flash
//   - Spread in pips
//   - Visual range bar showing where current price sits
//     relative to today's High-Low range (like MT5)
//   - Last update time
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/tick_entity.dart';
import '../providers/quote_providers.dart';

class QuoteListItemAdvanced extends ConsumerStatefulWidget {
  final MarketWatchItem item;
  final VoidCallback onTap;

  const QuoteListItemAdvanced({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  ConsumerState<QuoteListItemAdvanced> createState() =>
      _QuoteListItemAdvancedState();
}

class _QuoteListItemAdvancedState
    extends ConsumerState<QuoteListItemAdvanced> {

  // ── Price tracking ────────────────────────────────────────
  double? _prevMid;
  bool _isUp = true;
  bool _flashing = false;
  Timer? _flashTimer;

  // ── Session high/low tracking ─────────────────────────────
  double? _sessionHigh;
  double? _sessionLow;

  // ── Last update time ──────────────────────────────────────
  DateTime? _lastUpdateTime;

  static final _timeFmt = DateFormat('HH:mm:ss');

  @override
  void dispose() {
    _flashTimer?.cancel();
    super.dispose();
  }

  void _onTick(TickEntity tick) {
    if (!mounted) return;
    final mid = tick.mid;

    // Update session high/low
    _sessionHigh = (_sessionHigh == null || mid > _sessionHigh!)
        ? mid
        : _sessionHigh;
    _sessionLow =
        (_sessionLow == null || mid < _sessionLow!) ? mid : _sessionLow;

    // Detect direction & trigger flash
    if (_prevMid != null && mid != _prevMid) {
      setState(() {
        _isUp = mid > _prevMid!;
        _flashing = true;
        _lastUpdateTime = tick.timestamp;
      });
      _flashTimer?.cancel();
      _flashTimer = Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _flashing = false);
      });
    } else {
      setState(() => _lastUpdateTime = tick.timestamp);
    }

    _prevMid = mid;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      symbolTickProvider(widget.item.symbol.name),
      (_, next) => next.whenData((tick) { if (tick != null) _onTick(tick); }),
    );

    final tick = widget.item.tick;
    final symbol = widget.item.symbol;
    final precision = symbol.displayPrecision;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 68.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        color: Colors.transparent,
        child: Column(
          children: [
            // ── Top Row: Symbol + Bid + Ask + Spread ──────────
            Row(
              children: [
                // Symbol
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      // Direction arrow
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _isUp
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          key: ValueKey(_isUp),
                          color: _isUp
                              ? AppTheme.buyGreen
                              : AppTheme.sellRed,
                          size: 18.sp,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          symbol.displayLabel,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // High
                Expanded(
                  flex: 2,
                  child: _SmallPriceLabel(
                    label: 'H',
                    value: _sessionHigh ?? tick?.sessionHigh,
                    precision: precision,
                    color: AppTheme.buyGreen,
                  ),
                ),

                // Low
                Expanded(
                  flex: 2,
                  child: _SmallPriceLabel(
                    label: 'L',
                    value: _sessionLow ?? tick?.sessionLow,
                    precision: precision,
                    color: AppTheme.sellRed,
                  ),
                ),

                // Bid (with flash)
                Expanded(
                  flex: 2,
                  child: _FlashPrice(
                    value: tick?.bid,
                    precision: precision,
                    flashing: _flashing,
                    isUp: _isUp,
                  ),
                ),

                // Ask (with flash)
                Expanded(
                  flex: 2,
                  child: _FlashPrice(
                    value: tick?.ask,
                    precision: precision,
                    flashing: _flashing,
                    isUp: _isUp,
                  ),
                ),

                // Spread
                SizedBox(
                  width: 36.w,
                  child: Text(
                    tick != null
                        ? tick.spreadPips.toStringAsFixed(1)
                        : '—',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.sp,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // ── Bottom Row: Range bar + time ───────────────────
            Row(
              children: [
                SizedBox(width: 18.w), // align with arrow

                // Range bar
                Expanded(
                  child: _SessionRangeBar(
                    high: _sessionHigh,
                    low: _sessionLow,
                    current: tick?.mid,
                  ),
                ),

                SizedBox(width: 8.w),

                // Last update time
                Text(
                  _lastUpdateTime != null
                      ? _timeFmt.format(_lastUpdateTime!.toLocal())
                      : '--:--:--',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppTheme.textDisabled,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 8.2.4 — Session Range Bar
// Visual indicator of where current price sits in today's
// High-Low range — same as MT5's range indicator.
// ============================================================

class _SessionRangeBar extends StatelessWidget {
  final double? high;
  final double? low;
  final double? current;

  const _SessionRangeBar({this.high, this.low, this.current});

  @override
  Widget build(BuildContext context) {
    if (high == null || low == null || current == null) {
      return Container(
        height: 4.h,
        decoration: BoxDecoration(
          color: AppTheme.surfaceBorder,
          borderRadius: BorderRadius.circular(2.r),
        ),
      );
    }

    final range = high! - low!;
    final position = range > 0
        ? ((current! - low!) / range).clamp(0.0, 1.0)
        : 0.5;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final dotPosition = (totalWidth * position).clamp(
          4.0, totalWidth - 4.0);

        return SizedBox(
          height: 8.h,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // ── Track ────────────────────────────────────
              Container(
                height: 3.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.sellRed, AppTheme.warningAmber,
                             AppTheme.buyGreen],
                  ),
                  borderRadius: BorderRadius.circular(1.5.r),
                ),
              ),

              // ── Current price dot ─────────────────────────
              Positioned(
                left: dotPosition - 4.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryTeal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryTealGlow,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────

class _SmallPriceLabel extends StatelessWidget {
  final String label;
  final double? value;
  final int precision;
  final Color color;

  const _SmallPriceLabel({
    required this.label,
    required this.value,
    required this.precision,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 8.sp,
              color: color,
              fontWeight: FontWeight.w700),
        ),
        Text(
          value != null ? value!.toStringAsFixed(precision) : '—',
          textAlign: TextAlign.right,
          style: GoogleFonts.jetBrainsMono(
              fontSize: 10.sp, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

class _FlashPrice extends StatelessWidget {
  final double? value;
  final int precision;
  final bool flashing;
  final bool isUp;

  const _FlashPrice({
    required this.value,
    required this.precision,
    required this.flashing,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    final flashColor = isUp ? AppTheme.buyGreenGlow : AppTheme.sellRedGlow;
    final textColor = isUp ? AppTheme.buyGreen : AppTheme.sellRed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: flashing ? flashColor : Colors.transparent,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Text(
        value != null ? value!.toStringAsFixed(precision) : '—',
        textAlign: TextAlign.right,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: flashing ? textColor : AppTheme.textPrimary,
        ),
      ),
    );
  }
}
