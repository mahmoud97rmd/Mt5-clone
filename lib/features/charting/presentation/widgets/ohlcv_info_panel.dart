// Path: lib/features/charting/presentation/widgets/ohlcv_info_panel.dart
// ============================================================
// MT5 Clone — OHLCV Info Panel
// Displays candle data when crosshair is active.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/candle_entity.dart';

class OhlcvInfoPanel extends StatelessWidget {
  final CandleEntity candle;

  const OhlcvInfoPanel({super.key, required this.candle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      color: AppTheme.backgroundSecondary,
      child: Row(
        children: [
          _label('O', candle.open),
          SizedBox(width: 12.w),
          _label('H', candle.high),
          SizedBox(width: 12.w),
          _label('L', candle.low),
          SizedBox(width: 12.w),
          _label('C', candle.close),
          SizedBox(width: 12.w),
          _label('V', candle.volume, isVolume: true),
          const Spacer(),
          _changePercent(),
        ],
      ),
    );
  }

  Widget _label(String prefix, double value, {bool isVolume = false}) {
    final color = _valueColor(value);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$prefix: ',
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          isVolume ? value.toStringAsFixed(0) : value.toStringAsFixed(5),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10.sp,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _changePercent() {
    final pct = candle.changePercent;
    final color = pct >= 0 ? AppTheme.profitColor : AppTheme.lossColor;
    final sign = pct >= 0 ? '+' : '';
    return Text(
      '$sign${pct.toStringAsFixed(2)}%',
      style: GoogleFonts.jetBrainsMono(
        fontSize: 10.sp,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Color _valueColor(double value) {
    if (candle.isBull) return AppTheme.profitColor;
    if (candle.isBear) return AppTheme.lossColor;
    return AppTheme.textPrimary;
  }
}
