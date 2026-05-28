// Path: lib/features/settings/presentation/screens/settings_screen.dart
// ============================================================
// MT5 Clone — Settings Screen
// App configuration, credentials, display preferences.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../../../ea/data/datasources/permissions_channel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _batteryOptimized = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final perms = ref.read(permissionsChannelProvider);
    final batteryOk = await perms.isBatteryOptimizationIgnored();
    final notifOk = await perms.isNotificationPermissionGranted();
    if (mounted) {
      setState(() {
        _batteryOptimized = batteryOk;
        _notificationsEnabled = notifOk;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(currentAccountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(12.w),
        children: [
          // ── Account Section ─────────────────────────────────
          _SectionHeader(title: 'Account'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Account ID',
                subtitle: account?.accountId ?? 'Not configured',
              ),
              _SettingsTile(
                icon: Icons.attach_money,
                title: 'Currency',
                subtitle: account?.currency ?? 'USD',
              ),
              _SettingsTile(
                icon: Icons.leaderboard_outlined,
                title: 'Leverage',
                subtitle: '1:${account?.leverage ?? 50}',
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── Notifications Section ───────────────────────────
          _SectionHeader(title: 'Notifications & Reliability'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: _notificationsEnabled ? 'Enabled' : 'Disabled',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (val) async {
                    final perms = ref.read(permissionsChannelProvider);
                    if (val) {
                      await perms.requestNotificationPermission();
                    } else {
                      await perms.openNotificationSettings();
                    }
                    _checkPermissions();
                  },
                ),
              ),
              _SettingsTile(
                icon: Icons.battery_saver_outlined,
                title: 'Battery Optimization',
                subtitle: _batteryOptimized
                    ? 'Whitelisted (recommended)'
                    : 'Not whitelisted — EA may be killed',
                trailing: TextButton(
                  onPressed: () async {
                    final perms = ref.read(permissionsChannelProvider);
                    await perms.openBatteryOptimizationSettings();
                  },
                  child: Text(
                    _batteryOptimized ? 'OK' : 'Fix',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: _batteryOptimized
                          ? AppTheme.buyGreen
                          : AppTheme.warningAmber,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── Display Section ─────────────────────────────────
          _SectionHeader(title: 'Display'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.straighten,
                title: 'Default Lots',
                subtitle: '0.01',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.language,
                title: 'Quote View Mode',
                subtitle: 'Advanced',
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── Data Section ────────────────────────────────────
          _SectionHeader(title: 'Data'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.sync,
                title: 'Sync History',
                subtitle: 'Fetch closed trades from OANDA',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.delete_outline,
                title: 'Clear Cache',
                subtitle: 'Remove cached ticks and candles',
                onTap: () => _confirmClearCache(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── About ───────────────────────────────────────────
          _SectionHeader(title: 'About'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '1.0.0 (Build 1)',
              ),
              _SettingsTile(
                icon: Icons.code,
                title: 'Engine',
                subtitle: 'Chaquopy Python 3.11 + Kotlin',
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  void _confirmClearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
            'This will remove all cached tick data and chart candles. '
            'History and settings will not be affected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: Text('Clear',
                style: TextStyle(color: AppTheme.sellRed)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppTheme.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              indent: 52.w,
              height: 0.5,
              color: AppTheme.surfaceBorder,
            );
          }
          return children[index ~/ 2];
        }),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22.sp, color: AppTheme.textSecondary),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.textMuted,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right,
                  size: 20.sp, color: AppTheme.textDisabled)
              : null),
      onTap: onTap,
    );
  }
}
