// Path: lib/features/charting/presentation/widgets/timeframe_selector.dart
// ============================================================
// MT5 Clone — Timeframe Selector Bar
// Horizontal scrollable row of timeframe buttons.
// Matches MT5's timeframe selector: M1 M5 M15 M30 H1 H4 D1 W1 MN
// Selected timeframe has teal underline indicator.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/enums/trading_enums.dart';

class TimeframeSelector extends StatelessWidget {
  final Timeframe selected;
  final ValueChanged<Timeframe> onChanged;

  // Primary timeframes shown by default (matches MT5)
  static const _primaryTimeframes = [
    Timeframe.m1,
    Timeframe.m5,
    Timeframe.m15,
    Timeframe.m30,
    Timeframe.h1,
    Timeframe.h4,
    Timeframe.d1,
    Timeframe.w1,
    Timeframe.mn,
  ];

  const TimeframeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundSecondary,
        border: Border(
          top: BorderSide(color: AppTheme.surfaceBorder, width: 0.5),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _primaryTimeframes.length,
        itemBuilder: (context, i) {
          final tf = _primaryTimeframes[i];
          final isSelected = tf == selected;

          return GestureDetector(
            onTap: () => onChanged(tf),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.symmetric(
                  horizontal: 2.w, vertical: 4.h),
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryTealGlow
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4.r),
                border: isSelected
                    ? Border.all(
                        color: AppTheme.primaryTeal, width: 0.8)
                    : null,
              ),
              child: Center(
                child: Text(
                  tf.displayName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected
                        ? FontWeight.w800
                        : FontWeight.w500,
                    color: isSelected
                        ? AppTheme.primaryTeal
                        : AppTheme.textMuted,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
