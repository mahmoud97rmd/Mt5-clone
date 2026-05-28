// Path: lib/core/router/app_shell.dart
// ============================================================
// MT5 Clone — App Shell
// Main scaffold with bottom navigation bar.
// All 5 main screens share this persistent shell.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_theme.dart';
import '../app/app_state_notifier.dart';
import 'route_names.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  static const _tabs = [
    _TabItem(icon: Icons.show_chart,      label: 'Quotes',   path: RouteNames.quotes),
    _TabItem(icon: Icons.candlestick_chart, label: 'Charts', path: RouteNames.chart),
    _TabItem(icon: Icons.account_balance_wallet_outlined, label: 'Trade', path: RouteNames.trading),
    _TabItem(icon: Icons.history,         label: 'History',  path: RouteNames.history),
    _TabItem(icon: Icons.smart_toy_outlined, label: 'EA',   path: RouteNames.eaManager),
  ];

  int _currentIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final idx = _tabs.indexWhere((t) => path.startsWith(t.path));
    return idx < 0 ? 2 : idx;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Column(
        children: [
          // ── Connectivity Banner ──────────────────────────
          if (!isOnline)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              color: AppTheme.warningAmber,
              child: Text(
                '⚠️  No internet connection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // ── Main Content ─────────────────────────────────
          Expanded(child: child),
        ],
      ),

      // ── Bottom Navigation ──────────────────────────────
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final currentIdx = _currentIndex(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.backgroundSecondary,
        border: Border(
          top: BorderSide(color: AppTheme.surfaceBorder, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final idx = entry.key;
              final tab = entry.value;
              final isSelected = idx == currentIdx;

              return Expanded(
                child: InkWell(
                  onTap: () => context.go(tab.path),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tab.icon,
                        size: 22.sp,
                        color: isSelected
                            ? AppTheme.primaryTeal
                            : AppTheme.textMuted,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected
                              ? AppTheme.primaryTeal
                              : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  final String path;
  const _TabItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}
