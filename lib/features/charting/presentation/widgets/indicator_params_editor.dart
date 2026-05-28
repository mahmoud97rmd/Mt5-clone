// Path: lib/features/charting/presentation/widgets/indicator_params_editor.dart
// ============================================================
// MT5 Clone — Indicator Parameters Editor
// Dynamic form for editing indicator parameters.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../domain/indicators/indicator_models.dart';

class IndicatorParamsEditor extends StatefulWidget {
  final IndicatorConfig config;
  final ValueChanged<IndicatorConfig> onSave;

  const IndicatorParamsEditor({
    super.key,
    required this.config,
    required this.onSave,
  });

  @override
  State<IndicatorParamsEditor> createState() => _IndicatorParamsEditorState();
}

class _IndicatorParamsEditorState extends State<IndicatorParamsEditor> {
  late Map<String, dynamic> _params;
  late Color _selectedColor;
  late double _lineWidth;

  static const List<Color> _presetColors = [
    Color(0xFF00D4AA), // Teal
    Color(0xFF4D9FFF), // Blue
    Color(0xFFFFC107), // Amber
    Color(0xFFFF4757), // Red
    Color(0xFF00C853), // Green
    Color(0xFF9C27B0), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _params = Map<String, dynamic>.from(widget.config.params);
    _selectedColor = widget.config.color;
    _lineWidth = widget.config.lineWidth;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.all(16.w),
            children: [
              // Header
              Row(
                children: [
                  Text(
                    '${widget.config.type.displayName} Settings',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Period input (if applicable)
              if (_params.containsKey('period')) ...[
                _buildIntParam('Period', 'period'),
                SizedBox(height: 12.h),
              ],

              // Type-specific params
              ..._buildTypeSpecificParams(),
              SizedBox(height: 16.h),

              // Color picker
              Text(
                'Color',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: _presetColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.textPrimary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 16, color: Colors.black)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),

              // Line width
              Text(
                'Line Width: ${_lineWidth.toStringAsFixed(1)}',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Slider(
                value: _lineWidth,
                min: 1.0,
                max: 3.0,
                divisions: 4,
                activeColor: AppTheme.primaryTeal,
                onChanged: (v) => setState(() => _lineWidth = v),
              ),
              SizedBox(height: 24.h),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(
                    'Apply',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIntParam(String label, String key) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 80.w,
          child: TextFormField(
            initialValue: (_params[key] as int).toString(),
            keyboardType: TextInputType.number,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14.sp,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              isDense: true,
            ),
            onChanged: (v) {
              final parsed = int.tryParse(v);
              if (parsed != null && parsed > 0) {
                _params[key] = parsed;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDoubleParam(String label, String key) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 80.w,
          child: TextFormField(
            initialValue: (_params[key] as double).toStringAsFixed(1),
            keyboardType: TextInputType.number,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14.sp,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              isDense: true,
            ),
            onChanged: (v) {
              final parsed = double.tryParse(v);
              if (parsed != null && parsed > 0) {
                _params[key] = parsed;
              }
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTypeSpecificParams() {
    switch (widget.config.type) {
      case IndicatorType.bollingerBands:
        return [
          _buildDoubleParam('Std Dev Multiplier', 'stdDev'),
        ];
      case IndicatorType.ichimoku:
        return [
          _buildIntParam('Tenkan Period', 'tenkan'),
          SizedBox(height: 8.h),
          _buildIntParam('Kijun Period', 'kijun'),
          SizedBox(height: 8.h),
          _buildIntParam('Senkou Period', 'senkou'),
          SizedBox(height: 8.h),
          _buildIntParam('Displacement', 'displacement'),
        ];
      case IndicatorType.rsi:
        return [
          _buildDoubleParam('Overbought', 'overbought'),
          SizedBox(height: 8.h),
          _buildDoubleParam('Oversold', 'oversold'),
        ];
      case IndicatorType.macd:
        return [
          _buildIntParam('Fast Period', 'fast'),
          SizedBox(height: 8.h),
          _buildIntParam('Slow Period', 'slow'),
          SizedBox(height: 8.h),
          _buildIntParam('Signal Period', 'signal'),
        ];
      case IndicatorType.stochastic:
        return [
          _buildIntParam('%K Period', 'kPeriod'),
          SizedBox(height: 8.h),
          _buildIntParam('%D Period', 'dPeriod'),
          SizedBox(height: 8.h),
          _buildIntParam('Slowing', 'slowing'),
        ];
      default:
        return [];
    }
  }

  void _save() {
    widget.onSave(widget.config.copyWith(
      params: _params,
      color: _selectedColor,
      lineWidth: _lineWidth,
    ));
    Navigator.pop(context);
  }
}
