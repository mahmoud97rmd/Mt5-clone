// Path: lib/features/ea/presentation/screens/ea_logs_screen.dart
// ============================================================
// MT5 Clone — EA Logs Screen
// Real-time log viewer for a specific EA instance.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/ea_entities.dart';
import '../../data/repositories/ea_repository_impl.dart';
import '../providers/ea_manager_providers.dart';

class EaLogsScreen extends ConsumerWidget {
  final int eaId;
  final String eaName;

  const EaLogsScreen({super.key, required this.eaId, required this.eaName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(eaLogsProvider(eaId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eaName,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Logs',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, size: 22.sp),
            onPressed: () => _clearLogs(context, ref),
            tooltip: 'Clear Logs',
          ),
        ],
      ),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.article_outlined,
                      size: 48.sp, color: AppTheme.textDisabled),
                  SizedBox(height: 12.h),
                  Text(
                    'No logs yet',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(8.w),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return _LogLine(log: log);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryTeal),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: GoogleFonts.inter(
                  fontSize: 13.sp, color: AppTheme.sellRed)),
        ),
      ),
    );
  }

  Future<void> _clearLogs(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Logs'),
        content: const Text('Clear all logs for this EA?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(eaRepositoryProvider).clearEaLogs(eaId);
    }
  }
}

class _LogLine extends StatelessWidget {
  final EaLogEntity log;

  const _LogLine({required this.log});

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColor(log.level);
    final time = DateTime.fromMicrosecondsSinceEpoch(log.timestamp.microsecondsSinceEpoch);
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeStr,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10.sp,
              color: AppTheme.textDisabled,
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: levelColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Text(
              log.level.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: levelColor,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          if (log.source.isNotEmpty)
            Text(
              '[${log.source}] ',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.sp,
                color: AppTheme.primaryTeal,
              ),
            ),
          Expanded(
            child: Text(
              log.message,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10.sp,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _levelColor(String level) {
    switch (level.toUpperCase()) {
      case 'ERROR':
        return AppTheme.sellRed;
      case 'WARN':
        return AppTheme.warningAmber;
      case 'INFO':
        return AppTheme.primaryTeal;
      case 'DEBUG':
        return AppTheme.textMuted;
      default:
        return AppTheme.textSecondary;
    }
  }
}
