// Path: lib/core/app/mt5_app.dart
// ============================================================
// MT5 Clone — Root Application Widget
// Configures: MaterialApp.router, GoRouter, theme,
//             localization, connectivity monitoring,
//             and global bootstrap side effects.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

import '../router/app_router.dart';
import '../app/app_theme.dart';
import '../app/app_state_notifier.dart';
import '../../features/account/presentation/providers/account_providers.dart';
import '../../features/quotes/presentation/providers/quote_providers.dart';
import '../streaming/stream_health_monitor.dart';

class Mt5App extends ConsumerStatefulWidget {
  const Mt5App({super.key});

  @override
  ConsumerState<Mt5App> createState() => _Mt5AppState();
}

class _Mt5AppState extends ConsumerState<Mt5App>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Bootstrap side effects after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  // ============================================================
  // App Bootstrap (runs once on launch)
  // ============================================================

  Future<void> _bootstrap() async {
    // 1. Initialize account (fetch from OANDA)
    await ref.read(accountInitProvider.future).catchError((e) {
      debugPrint('Bootstrap: account init failed — $e');
      return null;
    });

    // 2. Start price streaming for watchlisted symbols
    ref.read(streamBootstrapProvider);

    // 3. Start stream health monitor (EA kill switch)
    ref.read(streamHealthMonitorProvider);

    // 4. Auto-start any EAs configured for auto-start
    // (handled in Phase 13 EA Engine)
  }

  // ============================================================
  // App Lifecycle (pause/resume stream on background)
  // ============================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final appState = ref.read(appStateProvider.notifier);

    switch (state) {
      case AppLifecycleState.paused:
        appState.onAppPaused();
      case AppLifecycleState.resumed:
        appState.onAppResumed();
      case AppLifecycleState.detached:
        appState.onAppDetached();
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      // Design canvas based on standard Android trading terminal
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return OverlaySupport.global(
          child: MaterialApp.router(
            title: 'MT5 Clone',
            debugShowCheckedModeBanner: false,

            // ── Theme ─────────────────────────────────────────
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,

            // ── Routing ───────────────────────────────────────
            routerConfig: router,

            // ── Localization ──────────────────────────────────
            locale: const Locale('en', 'US'),

            // ── Builder: global scaffold for overlays ─────────
            builder: (context, child) {
              // Ensure text scale factor doesn't break trading UI
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(
                    MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
                  ),
                ),
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
