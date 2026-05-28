// Path: lib/features/quotes/presentation/widgets/stream_status_bar.dart
// ============================================================
// MT5 Clone — Stream Status Bar
// Thin bar displayed below the Market Watch header showing
// the real-time connection state to OANDA price stream.
//
// States:
//   Connected    → green pulsing dot + "Live" text
//   Connecting   → amber spinning indicator
//   Reconnecting → amber + retry count
//   Disconnected → red dot + "Offline"
//   Error        → red + error message
//   Killed       → red + "Stream Killed"
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/app/app_theme.dart';
import '../providers/quote_providers.dart';
import '../../data/models/stream_dto.dart';

class StreamStatusBar extends ConsumerWidget {
  const StreamStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(streamConnectionStateProvider);

    return stateAsync.when(
      data: (state) => _StatusBar(state: state),
      loading: () => _StatusBar(state: StreamConnectionState.connecting),
      error: (_, __) => _StatusBar(state: StreamConnectionState.error),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final StreamConnectionState state;
  const _StatusBar({required this.state});

  @override
  Widget build(BuildContext context) {
    // Don't show bar when connected (saves screen space)
    if (state == StreamConnectionState.connected) {
      return _ConnectedBar();
    }

    final (color, icon, text) = switch (state) {
      StreamConnectionState.connecting => (
          AppTheme.warningAmber,
          null,
          'Connecting to price stream...',
        ),
      StreamConnectionState.reconnecting => (
          AppTheme.warningAmber,
          Icons.sync,
          'Reconnecting...',
        ),
      StreamConnectionState.disconnected => (
          AppTheme.sellRed,
          Icons.wifi_off,
          'Price stream disconnected',
        ),
      StreamConnectionState.error => (
          AppTheme.sellRed,
          Icons.error_outline,
          'Stream connection error',
        ),
      StreamConnectionState.killed => (
          AppTheme.sellRed,
          Icons.stop_circle_outlined,
          'Stream killed by safety switch',
        ),
      _ => (AppTheme.textMuted, null, ''),
    };

    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      color: color.withValues(alpha: 0.12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: color),
            SizedBox(width: 6.w),
          ] else if (state == StreamConnectionState.connecting ||
              state == StreamConnectionState.reconnecting) ...[
            SizedBox(
              width: 10.w,
              height: 10.h,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: color,
              ),
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Connected Bar (minimal, pulsing green dot) ────────────────

class _ConnectedBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 18.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: AppTheme.buyGreenGlow,
      child: Row(
        children: [
          // Pulsing green dot
          Container(
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(
              color: AppTheme.buyGreen,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.4, 1.4),
                duration: 800.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.4, 1.4),
                end: const Offset(1, 1),
                duration: 800.ms,
                curve: Curves.easeInOut,
              ),

          SizedBox(width: 6.w),

          Text(
            'LIVE',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.buyGreen,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
