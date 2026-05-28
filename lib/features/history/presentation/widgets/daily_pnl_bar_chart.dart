// Path: lib/features/history/presentation/widgets/daily_pnl_bar_chart.dart
// ============================================================
// MT5 Clone — Daily P&L Bar Chart
// Custom bar chart showing daily profit/loss breakdown.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/repositories/repositories.dart';

class DailyPnlBarChart extends StatelessWidget {
  final List<DailyPnlEntity> dailyPnl;

  const DailyPnlBarChart({super.key, required this.dailyPnl});

  @override
  Widget build(BuildContext context) {
    if (dailyPnl.isEmpty) {
      return SizedBox(
        height: 180.h,
        child: Center(
          child: Text(
            'No P&L data',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppTheme.textMuted,
            ),
          ),
        ),
      );
    }

    final maxAbs = dailyPnl
        .map((d) => d.netProfit.abs())
        .reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily P&L',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _DailyPnlPainter(
                data: dailyPnl,
                maxAbsValue: maxAbs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyPnlPainter extends CustomPainter {
  final List<DailyPnlEntity> data;
  final double maxAbsValue;

  _DailyPnlPainter({required this.data, required this.maxAbsValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxAbsValue == 0) return;

    final barWidth = (size.width / data.length).clamp(4.0, 20.0);
    final gap = (size.width - barWidth * data.length) / (data.length + 1);
    final midY = size.height / 2;
    final scaleY = midY / maxAbsValue;

    // Draw zero line
    final zeroPaint = Paint()
      ..color = AppTheme.surfaceBorder
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(0, midY),
      Offset(size.width, midY),
      zeroPaint,
    );

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      final x = gap + i * (barWidth + gap);
      final barHeight = d.netProfit.abs() * scaleY;
      final isProfit = d.netProfit >= 0;

      final barPaint = Paint()
        ..color = isProfit ? AppTheme.buyGreen : AppTheme.sellRed
        ..style = PaintingStyle.fill;

      final rect = isProfit
          ? Rect.fromLTWH(x, midY - barHeight, barWidth, barHeight)
          : Rect.fromLTWH(x, midY, barWidth, barHeight);

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DailyPnlPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.maxAbsValue != maxAbsValue;
}
