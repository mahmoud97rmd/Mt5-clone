// Path: lib/features/charting/presentation/widgets/indicator_type_picker.dart
// ============================================================
// MT5 Clone — Indicator Type Picker
// Grid of available indicator types for adding new indicators.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/app/app_theme.dart';
import '../../domain/indicators/indicator_models.dart';
import '../notifiers/indicator_notifier.dart';

class IndicatorTypePicker extends ConsumerWidget {
  final String symbol;

  const IndicatorTypePicker({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(indicatorNotifierProvider(symbol).notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: Row(
                  children: [
                    Text(
                      'Add Indicator',
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
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: IndicatorType.values.length,
                  itemBuilder: (context, index) {
                    final type = IndicatorType.values[index];
                    return _IndicatorTypeCard(
                      type: type,
                      onTap: () {
                        final config = _defaultConfig(type);
                        notifier.addIndicator(config);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IndicatorConfig _defaultConfig(IndicatorType type) {
    const uuid = Uuid();
    switch (type) {
      case IndicatorType.sma:
        return IndicatorConfig.sma(id: uuid.v4());
      case IndicatorType.ema:
        return IndicatorConfig.ema(id: uuid.v4());
      case IndicatorType.wma:
        return IndicatorConfig.wma(id: uuid.v4());
      case IndicatorType.bollingerBands:
        return IndicatorConfig.bollingerBands(id: uuid.v4());
      case IndicatorType.ichimoku:
        return IndicatorConfig.ichimoku(id: uuid.v4());
      case IndicatorType.rsi:
        return IndicatorConfig.rsi(id: uuid.v4());
      case IndicatorType.macd:
        return IndicatorConfig.macd(id: uuid.v4());
      case IndicatorType.stochastic:
        return IndicatorConfig.stochastic(id: uuid.v4());
      case IndicatorType.atr:
        return IndicatorConfig.atr(id: uuid.v4());
    }
  }
}

class _IndicatorTypeCard extends StatelessWidget {
  final IndicatorType type;
  final VoidCallback onTap;

  const _IndicatorTypeCard({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _iconForType(type),
              size: 24,
              color: AppTheme.primaryTeal,
            ),
            SizedBox(height: 6.h),
            Text(
              type.displayName,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: type.isOnChart
                    ? AppTheme.primaryTeal.withOpacity(0.15)
                    : AppTheme.warningAmber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                type.locationLabel,
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  color: type.isOnChart ? AppTheme.primaryTeal : AppTheme.warningAmber,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(IndicatorType type) {
    switch (type) {
      case IndicatorType.sma:
      case IndicatorType.ema:
      case IndicatorType.wma:
        return Icons.show_chart;
      case IndicatorType.bollingerBands:
        return Icons.unfold_more;
      case IndicatorType.ichimoku:
        return Icons.cloud_outlined;
      case IndicatorType.rsi:
        return Icons.speed;
      case IndicatorType.macd:
        return Icons.bar_chart;
      case IndicatorType.stochastic:
        return Icons.waves;
      case IndicatorType.atr:
        return Icons.swap_vert;
    }
  }
}
