// Path: lib/core/router/app_router.dart
// ============================================================
// MT5 Clone — Application Router (GoRouter)
// Defines all app routes with:
//   - Auth guard (redirect to setup if not configured)
//   - Nested navigation (bottom nav tabs)
//   - Deep link handling (mt5clone://trade/...)
//   - Transition animations
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app/app_state_notifier.dart';
import '../../core/security/credential_storage.dart';
import '../../features/charting/presentation/screens/chart_screen.dart';
import '../../features/ea/presentation/screens/ea_logs_screen.dart';
import '../../features/ea/presentation/screens/ea_manager_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/quotes/presentation/screens/quotes_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/trading/presentation/screens/trading_screen.dart';
import 'route_names.dart';
import 'app_shell.dart';

// ============================================================
// 7.3.1 — Router Provider
// ============================================================

final appRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  final isConfigured =
      ref.watch(isCredentialsConfiguredProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,

    // ── Auth Redirect Guard ────────────────────────────────
    redirect: (context, state) {
      final configured = isConfigured.valueOrNull ?? false;
      final _ = isAuthenticated;
      final path = state.uri.path;

      // Allow splash and setup screens without auth
      final publicPaths = [
        RouteNames.splash,
        RouteNames.setup,
        RouteNames.setupApiKey,
      ];
      if (publicPaths.contains(path)) return null;

      // Redirect to setup if not configured
      if (!configured) return RouteNames.setup;

      return null;
    },

    // ── Routes ────────────────────────────────────────────
    routes: [
      // ── Splash ──────────────────────────────────────────
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const _SplashScreen(),
        ),
      ),

      // ── Setup / Onboarding ────────────────────────────
      GoRoute(
        path: RouteNames.setup,
        name: 'setup',
        pageBuilder: (context, state) => _slideTransition(
          state,
          const _SetupScreen(),
        ),
        routes: [
          GoRoute(
            path: 'api-key',
            name: 'setup-api-key',
            pageBuilder: (context, state) => _slideTransition(
              state,
              const _SetupApiKeyScreen(),
            ),
          ),
        ],
      ),

      // ── Main App Shell (bottom nav) ─────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // ── Quotes / Market Watch ────────────────────
          GoRoute(
            path: RouteNames.quotes,
            name: 'quotes',
            pageBuilder: (context, state) =>
                _noTransition(state, const QuotesScreen()),
          ),

          // ── Charting ─────────────────────────────────
          GoRoute(
            path: RouteNames.chart,
            name: 'chart',
            pageBuilder: (context, state) =>
                _noTransition(state, const _ChartDefaultScreen()),
            routes: [
              GoRoute(
                path: ':symbol',
                name: 'chart-symbol',
                pageBuilder: (context, state) {
                  final symbol = state.pathParameters['symbol']!;
                  return _slideTransition(
                    state,
                    ChartScreen(symbol: symbol),
                  );
                },
              ),
            ],
          ),

          // ── Trading Terminal ──────────────────────────
          GoRoute(
            path: RouteNames.trading,
            name: 'trading',
            pageBuilder: (context, state) =>
                _noTransition(state, const TradingScreen()),
          ),

          // ── History ───────────────────────────────────
          GoRoute(
            path: RouteNames.history,
            name: 'history',
            pageBuilder: (context, state) =>
                _noTransition(state, const HistoryScreen()),
          ),

          // ── EA Engine Manager ─────────────────────────
          GoRoute(
            path: RouteNames.eaManager,
            name: 'ea-manager',
            pageBuilder: (context, state) =>
                _noTransition(state, const EaManagerScreen()),
            routes: [
              GoRoute(
                path: 'logs/:eaId',
                name: 'ea-logs',
                pageBuilder: (context, state) {
                  final eaId = int.parse(
                      state.pathParameters['eaId']!);
                  return _slideTransition(
                    state,
                    EaLogsScreen(eaId: eaId, eaName: 'EA #$eaId'),
                  );
                },
              ),
            ],
          ),

          // ── Settings ──────────────────────────────────
          GoRoute(
            path: RouteNames.settings,
            name: 'settings',
            pageBuilder: (context, state) =>
                _noTransition(state, const SettingsScreen()),
          ),
        ],
      ),
    ],

    // ── Error page ────────────────────────────────────────
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E14),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  color: Color(0xFFFF4757), size: 48),
              const SizedBox(height: 16),
              Text(
                'Route not found: ${state.uri}',
                style: const TextStyle(color: Color(0xFFE6EDF3)),
              ),
              TextButton(
                onPressed: () => context.go(RouteNames.trading),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});

// ============================================================
// 7.3.2 — Page Transition Builders
// ============================================================

CustomTransitionPage<void> _fadeTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _slideTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (_, animation, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _noTransition(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    transitionsBuilder: (_, __, ___, child) => child,
  );
}

// ============================================================
// 7.3.3 — Internal Screens (Splash, Setup, Chart Default)
// ============================================================

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0E14),
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
      ),
    );
  }
}

class _SetupScreen extends StatelessWidget {
  const _SetupScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.show_chart,
                  color: Color(0xFF00D4AA), size: 64),
              const SizedBox(height: 24),
              const Text(
                'MT5 Clone',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE6EDF3),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connect your OANDA account to start trading',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7D8590),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => context.go(RouteNames.setupApiKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D4AA),
                    foregroundColor: const Color(0xFF0A0E14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Configure API Key',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupApiKeyScreen extends StatefulWidget {
  const _SetupApiKeyScreen();
  @override
  State<_SetupApiKeyScreen> createState() => _SetupApiKeyScreenState();
}

class _SetupApiKeyScreenState extends State<_SetupApiKeyScreen> {
  final _apiKeyController = TextEditingController();
  final _accountIdController = TextEditingController();
  bool _isPractice = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    _accountIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      appBar: AppBar(
        title: const Text('API Configuration'),
        backgroundColor: const Color(0xFF0D1117),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OANDA API Key',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B949E)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  color: Color(0xFFE6EDF3)),
              decoration: InputDecoration(
                hintText: 'Enter your OANDA API key',
                hintStyle: const TextStyle(color: Color(0xFF484F58)),
                filled: true,
                fillColor: const Color(0xFF1C2128),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF21262D)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF21262D)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Color(0xFF00D4AA), width: 1.5),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Account ID',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B949E)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _accountIdController,
              style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  color: Color(0xFFE6EDF3)),
              decoration: InputDecoration(
                hintText: '101-001-XXXXXXX-XXX',
                hintStyle: const TextStyle(color: Color(0xFF484F58)),
                filled: true,
                fillColor: const Color(0xFF1C2128),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF21262D)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF21262D)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: Color(0xFF00D4AA), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Environment:',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B949E)),
                ),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('Practice'),
                  selected: _isPractice,
                  selectedColor: const Color(0x3300D4AA),
                  onSelected: (v) => setState(() => _isPractice = true),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Live'),
                  selected: !_isPractice,
                  selectedColor: const Color(0x33FF4757),
                  onSelected: (v) => setState(() => _isPractice = false),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Save credentials and navigate
                  context.go(RouteNames.trading);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D4AA),
                  foregroundColor: const Color(0xFF0A0E14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Connect',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartDefaultScreen extends ConsumerWidget {
  const _ChartDefaultScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ChartScreen(symbol: 'EUR_USD');
  }
}
