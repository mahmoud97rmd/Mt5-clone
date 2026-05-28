// Path: lib/features/charting/presentation/widgets/indicators_sheet.dart
// ============================================================
// MT5 Clone — Indicators Settings Sheet
// Bottom sheet for managing chart technical indicators.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../domain/indicators/indicator_models.dart';
import '../notifiers/indicator_notifier.dart';
import 'indicator_type_picker.dart';
import 'indicator_params_editor.dart';

class IndicatorsSheet extends ConsumerWidget {
  final String symbol;

  const IndicatorsSheet({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(indicatorNotifierProvider(symbol));
    final notifier = ref.read(indicatorNotifierProvider(symbol).notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────
              _buildHeader(context, state, notifier),

              // ── Active Indicators List ──────────────────────
              Expanded(
                child: state.activeIndicators.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: state.activeIndicators.length,
                        itemBuilder: (context, index) {
                          final config = state.activeIndicators[index];
                          return _IndicatorTile(
                            config: config,
                            onToggleVisibility: () =>
                                notifier.toggleVisibility(config.id),
                            onEdit: () =>
                                _showParamsEditor(context, config, notifier),
                            onRemove: () =>
                                notifier.removeIndicator(config.id),
                          );
                        },
                      ),
              ),

              // ── Add Indicator Button ────────────────────────
              _buildAddButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, IndicatorState state, IndicatorNotifier notifier) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Row(
        children: [
          Text(
            'Indicators',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          if (state.activeIndicators.isNotEmpty)
            TextButton(
              onPressed: notifier.clearAll,
              child: Text(
                'Clear All',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppTheme.sellRed,
                ),
              ),
            ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.analytics_outlined, size: 48, color: AppTheme.textMuted),
          SizedBox(height: 12.h),
          Text(
            'No indicators added',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Tap + to add a technical indicator',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showTypePicker(context),
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            'Add Indicator',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
      ),
    );
  }

  void _showTypePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IndicatorTypePicker(symbol: symbol),
    );
  }

  void _showParamsEditor(
    BuildContext context,
    IndicatorConfig config,
    IndicatorNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IndicatorParamsEditor(
        config: config,
        onSave: notifier.updateIndicator,
      ),
    );
  }
}

// ============================================================
// Indicator Tile Widget
// ============================================================

class _IndicatorTile extends StatelessWidget {
  final IndicatorConfig config;
  final VoidCallback onToggleVisibility;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _IndicatorTile({
    required this.config,
    required this.onToggleVisibility,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
      ),
      child: Row(
        children: [
          // Color dot
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),

          // Name + type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.type.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  config.type.locationLabel,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Visibility toggle
          GestureDetector(
            onTap: onToggleVisibility,
            child: Icon(
              config.isVisible ? Icons.visibility : Icons.visibility_off,
              size: 18,
              color: config.isVisible ? AppTheme.primaryTeal : AppTheme.textMuted,
            ),
          ),
          SizedBox(width: 8.w),

          // Edit button
          GestureDetector(
            onTap: onEdit,
            child: const Icon(Icons.edit, size: 18, color: AppTheme.textSecondary),
          ),
          SizedBox(width: 8.w),

          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.delete_outline, size: 18, color: AppTheme.sellRed),
          ),
        ],
      ),
    );
  }
}
