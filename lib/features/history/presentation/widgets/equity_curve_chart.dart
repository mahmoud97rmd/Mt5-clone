// Path: lib/features/history/presentation/widgets/equity_curve_chart.dart
// ============================================================
// MT5 Clone — Equity Curve Chart
// Custom line chart showing account equity over time.
// ============================================================

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../account/data/datasources/account_snapshot_service.dart';

class EquityCurveChart extends StatelessWidget {
  final List<EquityCurvePoint> points;

  const EquityCurveChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: 180.h,
        child: Center(
          child: Text(
            'No equity data',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: AppTheme.textMuted,
            ),
          ),
        ),
      );
    }

    final values = points.map((p) => p.equity).toList();
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);

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
          Row(
            children: [
              Text(
                'Equity Curve',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${values.last.toStringAsFixed(2)}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryTeal,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _EquityCurvePainter(
                points: points,
                minVal: minVal,
                maxVal: maxVal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EquityCurvePainter extends CustomPainter {
  final List<EquityCurvePoint> points;
  final double minVal;
  final double maxVal;

  _EquityCurvePainter({
    required this.points,
    required this.minVal,
    required this.maxVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final range = maxVal - minVal;
    if (range == 0) return;

    final path = ui.Path();
    final fillPath = ui.Path();

    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = size.height -
          ((points[i].equity - minVal) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Close fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw gradient fill
    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, size.height),
        [
          AppTheme.primaryTeal.withOpacity(0.3),
          AppTheme.primaryTeal.withOpacity(0.0),
        ],
      )
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePaint = Paint()
      ..color = AppTheme.primaryTeal
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _EquityCurvePainter oldDelegate) =>
      oldDelegate.points != points;
}
