// Path: lib/features/charting/presentation/widgets/sub_chart_panel.dart
// ============================================================
// MT5 Clone — Sub-Chart Panel Widget
// Renders a sub-chart indicator panel below the main chart.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/candle_entity.dart';
import '../../domain/indicators/indicator_models.dart';
import '../painters/indicator_painter.dart';

class SubChartPanel extends StatelessWidget {
  final IndicatorSeries series;
  final List<CandleEntity> visibleCandles;
  final double chartLeft;
  final double chartRight;
  final VoidCallback? onSettingsTap;

  const SubChartPanel({
    super.key,
    required this.series,
    required this.visibleCandles,
    required this.chartLeft,
    required this.chartRight,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    // Current value display
    final currentValue = _getCurrentValue();

    return Container(
      height: 120.h,
      margin: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            child: Row(
              children: [
                // Color dot
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: series.config.color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                // Indicator name
                Text(
                  series.config.type.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(width: 8.w),
                // Current value
                if (currentValue != null)
                  Text(
                    currentValue.toStringAsFixed(2),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: series.config.color,
                    ),
                  ),
                const Spacer(),
                // Settings button
                if (onSettingsTap != null)
                  GestureDetector(
                    onTap: onSettingsTap,
                    child: Icon(
                      Icons.settings,
                      size: 14,
                      color: AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ),

          // ── Chart ───────────────────────────────────────────
          Expanded(
            child: CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: SubChartPainter(
                series: series,
                visibleCandles: visibleCandles,
                chartLeft: chartLeft,
                chartRight: chartRight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double? _getCurrentValue() {
    if (series.lines.isEmpty) return null;
    for (final line in series.lines) {
      if (line.isNotEmpty) {
        return line.last.value;
      }
    }
    return null;
  }
}
