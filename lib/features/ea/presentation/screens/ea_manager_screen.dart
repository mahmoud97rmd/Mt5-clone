// Path: lib/features/ea/presentation/screens/ea_manager_screen.dart
// ============================================================
// MT5 Clone — EA Manager Screen
// List of EA instances with start/stop/delete actions.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/ea_entities.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../data/datasources/ea_engine_channel.dart';
import '../../data/repositories/ea_repository_impl.dart';
import '../providers/ea_manager_providers.dart';
import 'ea_setup_sheet.dart';
import 'ea_logs_screen.dart';

class EaManagerScreen extends ConsumerWidget {
  const EaManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final easAsync = ref.watch(eaInstancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expert Advisors',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new, size: 22.sp),
            onPressed: () => _killAll(context, ref),
            tooltip: 'Kill All EAs',
            color: AppTheme.sellRed,
          ),
        ],
      ),
      body: easAsync.when(
        data: (eas) {
          if (eas.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.smart_toy_outlined,
                      size: 64.sp, color: AppTheme.textDisabled),
                  SizedBox(height: 16.h),
                  Text(
                    'No Expert Advisors',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tap + to add an EA',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: AppTheme.textDisabled,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(12.w),
            itemCount: eas.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              return _EaCard(
                ea: eas[index],
                onStart: () => _startEa(context, ref, eas[index]),
                onStop: () => _stopEa(context, ref, eas[index]),
                onDelete: () => _deleteEa(context, ref, eas[index]),
                onViewLogs: () => _viewLogs(context, eas[index]),
              );
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryTeal,
        onPressed: () => EaSetupSheet.show(context),
        child: Icon(Icons.add,
            color: AppTheme.backgroundPrimary, size: 28.sp),
      ),
    );
  }

  Future<void> _startEa(
      BuildContext context, WidgetRef ref, EaInstanceEntity ea) async {
    if (ea.id == null) return;
    final channel = ref.read(eaEngineChannelProvider);
    final success = await channel.startEa(
      eaId: ea.id!,
      scriptPath: ea.scriptPath,
      symbol: ea.symbol,
      lotSize: ea.lotSize,
      magicNumber: ea.magicNumber,
      params: ea.customParams,
    );
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start EA: ${ea.name}'),
          backgroundColor: AppTheme.sellRed,
        ),
      );
    }
  }

  Future<void> _stopEa(
      BuildContext context, WidgetRef ref, EaInstanceEntity ea) async {
    if (ea.id == null) return;
    final channel = ref.read(eaEngineChannelProvider);
    await channel.stopEa(ea.id!);
  }

  Future<void> _deleteEa(
      BuildContext context, WidgetRef ref, EaInstanceEntity ea) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete EA'),
        content: Text('Delete "${ea.name}" and all its logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete',
                style: TextStyle(color: AppTheme.sellRed)),
          ),
        ],
      ),
    );
    if (confirmed == true && ea.id != null) {
      await ref.read(eaRepositoryProvider).deleteEaInstance(ea.id!);
    }
  }

  void _viewLogs(BuildContext context, EaInstanceEntity ea) {
    if (ea.id == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EaLogsScreen(eaId: ea.id!, eaName: ea.name),
      ),
    );
  }

  Future<void> _killAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kill All EAs'),
        content: const Text(
            'Emergency stop: This will immediately terminate ALL running EAs. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Kill All',
                style: TextStyle(color: AppTheme.sellRed)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(eaEngineChannelProvider).killAllEas();
    }
  }
}

class _EaCard extends StatelessWidget {
  final EaInstanceEntity ea;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onDelete;
  final VoidCallback onViewLogs;

  const _EaCard({
    required this.ea,
    required this.onStart,
    required this.onStop,
    required this.onDelete,
    required this.onViewLogs,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = ea.status == EaStatus.running;
    final statusColor = isRunning ? AppTheme.buyGreen : AppTheme.textMuted;

    return Container(
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
              Icon(Icons.smart_toy,
                  size: 20.sp, color: AppTheme.primaryTeal),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  ea.name,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      ea.status.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _InfoTag(label: ea.symbol),
              SizedBox(width: 6.w),
              _InfoTag(label: '${ea.lotSize} lot'),
              SizedBox(width: 6.w),
              _InfoTag(label: 'Magic: ${ea.magicNumber}'),
            ],
          ),
          SizedBox(height: 8.h),
          // ── Performance Stats (if running) ───────────────
          if (isRunning) ...[
            Row(
              children: [
                _StatItem(
                  label: 'P&L',
                  value:
                      '${ea.netPnl >= 0 ? '+' : ''}${ea.netPnl.toStringAsFixed(2)}',
                  color: AppTheme.pnlColor(ea.netPnl),
                ),
                _StatItem(
                  label: 'Trades',
                  value: ea.totalTrades.toString(),
                ),
                _StatItem(
                  label: 'Win Rate',
                  value: '${ea.winRate.toStringAsFixed(0)}%',
                  color: ea.winRate >= 50
                      ? AppTheme.buyGreen
                      : AppTheme.sellRed,
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
          // ── Action Buttons ───────────────────────────────
          Row(
            children: [
              if (!isRunning)
                _ActionButton(
                  icon: Icons.play_arrow,
                  label: 'Start',
                  color: AppTheme.buyGreen,
                  onTap: onStart,
                ),
              if (isRunning)
                _ActionButton(
                  icon: Icons.stop,
                  label: 'Stop',
                  color: AppTheme.sellRed,
                  onTap: onStop,
                ),
              SizedBox(width: 8.w),
              _ActionButton(
                icon: Icons.article_outlined,
                label: 'Logs',
                color: AppTheme.primaryTeal,
                onTap: onViewLogs,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    size: 20.sp, color: AppTheme.textMuted),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  final String label;
  const _InfoTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _StatItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      margin: EdgeInsets.only(right: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10.sp, color: AppTheme.textMuted)),
          Text(value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color ?? AppTheme.textPrimary,
              )),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: color.withOpacity(0.3), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
