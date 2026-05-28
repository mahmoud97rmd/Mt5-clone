// Path: lib/core/app/mt5_app.dart
// ============================================================
// MT5 Clone — Root Application Widget
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../logging/app_logger.dart';
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

    ErrorWidget.builder = (details) {
      debugPrint('ErrorWidget: ${details.exception}');
      return MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF0A0E14),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error: ${details.exception}\n\n${details.stack}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
      );
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final log = AppLogger.instance;
    log.info('Bootstrap started');

    try {
      await ref.read(accountInitProvider.future);
      log.info('Account initialized');
    } catch (e) {
      log.warn('Account init failed — $e');
    }

    try {
      ref.read(streamBootstrapProvider);
      log.info('Stream bootstrap triggered');
    } catch (e) {
      log.warn('Stream bootstrap failed — $e');
    }

    ref.read(streamHealthMonitorProvider);
    log.info('Bootstrap complete');
  }

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

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'MT5 Clone',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: router,
          locale: const Locale('en', 'US'),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
