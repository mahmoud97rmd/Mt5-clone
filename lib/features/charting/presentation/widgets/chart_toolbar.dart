// Path: lib/features/charting/presentation/widgets/chart_toolbar.dart
// ============================================================
// MT5 Clone — Chart Toolbar
// Side toolbar for graphical drawing objects.
// Tools: Cursor, Horizontal Line, Vertical Line,
//        Trendline, Fibonacci Retracement, Text Label
//
// Active tool is stored in local state and passed to
// the chart gesture handler to enable drawing mode.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app/app_theme.dart';

// ============================================================
// Drawing Tool Enum
// ============================================================

enum DrawingTool {
  cursor,
  horizontalLine,
  verticalLine,
  trendLine,
  fibonacci,
  rectangle,
  textLabel,
}

extension DrawingToolX on DrawingTool {
  IconData get icon => switch (this) {
        DrawingTool.cursor => Icons.mouse_outlined,
        DrawingTool.horizontalLine => Icons.horizontal_rule,
        DrawingTool.verticalLine => Icons.vertical_align_center,
        DrawingTool.trendLine => Icons.show_chart,
        DrawingTool.fibonacci => Icons.grid_4x4_outlined,
        DrawingTool.rectangle => Icons.crop_square_outlined,
        DrawingTool.textLabel => Icons.text_fields,
      };

  String get tooltip => switch (this) {
        DrawingTool.cursor => 'Select',
        DrawingTool.horizontalLine => 'Horizontal Line',
        DrawingTool.verticalLine => 'Vertical Line',
        DrawingTool.trendLine => 'Trend Line',
        DrawingTool.fibonacci => 'Fibonacci',
        DrawingTool.rectangle => 'Rectangle',
        DrawingTool.textLabel => 'Text',
      };
}

// ============================================================
// Chart Toolbar Widget
// ============================================================

class ChartToolbar extends StatefulWidget {
  final ValueChanged<DrawingTool> onToolSelected;

  const ChartToolbar({super.key, required this.onToolSelected});

  @override
  State<ChartToolbar> createState() => _ChartToolbarState();
}

class _ChartToolbarState extends State<ChartToolbar> {
  DrawingTool _activeTool = DrawingTool.cursor;

  void _selectTool(DrawingTool tool) {
    setState(() => _activeTool = tool);
    widget.onToolSelected(tool);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        border: Border(
          right: BorderSide(color: AppTheme.surfaceBorder, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          ...DrawingTool.values.map((tool) {
            final isActive = tool == _activeTool;
            return Tooltip(
              message: tool.tooltip,
              preferBelow: false,
              child: GestureDetector(
                onTap: () => _selectTool(tool),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.symmetric(
                      vertical: 2.h, horizontal: 3.w),
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.primaryTealGlow
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.r),
                    border: isActive
                        ? Border.all(
                            color: AppTheme.primaryTeal, width: 0.8)
                        : null,
                  ),
                  child: Icon(
                    tool.icon,
                    size: 15.sp,
                    color: isActive
                        ? AppTheme.primaryTeal
                        : AppTheme.textMuted,
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // ── Undo last object ──────────────────────────────
          GestureDetector(
            onTap: () {/* implement undo in Phase 10 */},
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Icon(
                Icons.undo,
                size: 15.sp,
                color: AppTheme.textMuted,
              ),
            ),
          ),

          // ── Clear all objects ──────────────────────────────
          GestureDetector(
            onTap: () {/* implement clear in Phase 10 */},
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Icon(
                Icons.delete_outline,
                size: 15.sp,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
