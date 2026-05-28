// Path: lib/core/app/app_state_notifier.dart
// ============================================================
// MT5 Clone — Global App State Notifier
// Manages: app lifecycle, connectivity, session state,
//          and coordinates stream pause/resume on background.
// ============================================================

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../features/quotes/data/datasources/oanda_streaming_service.dart';
import '../../features/quotes/presentation/providers/quote_providers.dart';

// ============================================================
// 7.2.1 — App State Model
// ============================================================

enum AppLifecycle { foreground, background, detached }

enum ConnectivityStatus { online, offline, unknown }

class AppState {
  final AppLifecycle lifecycle;
  final ConnectivityStatus connectivity;
  final bool isAuthenticated;
  final String? accountId;
  final bool isInitialized;

  const AppState({
    this.lifecycle = AppLifecycle.foreground,
    this.connectivity = ConnectivityStatus.unknown,
    this.isAuthenticated = false,
    this.accountId,
    this.isInitialized = false,
  });

  bool get isOnline => connectivity == ConnectivityStatus.online;
  bool get isForeground => lifecycle == AppLifecycle.foreground;

  AppState copyWith({
    AppLifecycle? lifecycle,
    ConnectivityStatus? connectivity,
    bool? isAuthenticated,
    String? accountId,
    bool? isInitialized,
  }) {
    return AppState(
      lifecycle: lifecycle ?? this.lifecycle,
      connectivity: connectivity ?? this.connectivity,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accountId: accountId ?? this.accountId,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

// ============================================================
// 7.2.2 — App State Notifier
// ============================================================

class AppStateNotifier extends Notifier<AppState> {
  final Logger _log = Logger();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  AppState build() {
    // Start connectivity monitoring
    _startConnectivityMonitor();

    // Cleanup on dispose
    ref.onDispose(() {
      _connectivitySub?.cancel();
    });

    return const AppState();
  }

  // ── Lifecycle Events ──────────────────────────────────────

  void onAppResumed() {
    _log.d('App resumed');
    state = state.copyWith(lifecycle: AppLifecycle.foreground);

    // Resume price streaming if it was running
    if (state.isAuthenticated) {
      final symbols = ref.read(watchlistedSymbolNamesProvider);
      if (symbols.isNotEmpty) {
        ref.read(oandaStreamingServiceProvider).connect(symbols);
      }
    }
  }

  void onAppPaused() {
    _log.d('App paused — stream continues via Foreground Service');
    state = state.copyWith(lifecycle: AppLifecycle.background);
    // Note: We do NOT disconnect the stream here.
    // The Android Foreground Service keeps it alive.
    // Stream management when backgrounded is handled natively.
  }

  void onAppDetached() {
    _log.d('App detached');
    state = state.copyWith(lifecycle: AppLifecycle.detached);
  }

  // ── Authentication ────────────────────────────────────────

  void onAuthenticated(String accountId) {
    state = state.copyWith(
      isAuthenticated: true,
      accountId: accountId,
      isInitialized: true,
    );
    _log.i('App authenticated — account: $accountId');
  }

  void onLogout() {
    state = const AppState();
    _log.i('App logged out');
  }

  void onInitialized() {
    state = state.copyWith(isInitialized: true);
  }

  // ── Connectivity Monitor ──────────────────────────────────

  void _startConnectivityMonitor() {
    _connectivitySub = Connectivity().onConnectivityChanged.listen(
      (results) {
        final isOnline = results.any((r) =>
            r == ConnectivityResult.wifi ||
            r == ConnectivityResult.mobile ||
            r == ConnectivityResult.ethernet);

        final newStatus = isOnline
            ? ConnectivityStatus.online
            : ConnectivityStatus.offline;

        if (newStatus != state.connectivity) {
          state = state.copyWith(connectivity: newStatus);
          _log.i('Connectivity changed: ${newStatus.name}');

          // On reconnect: attempt to restart price stream
          if (isOnline && state.isAuthenticated) {
            _onNetworkReconnected();
          }
        }
      },
    );

    // Check initial connectivity
    Connectivity().checkConnectivity().then((results) {
      final isOnline = results.any((r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet);
      state = state.copyWith(
        connectivity: isOnline
            ? ConnectivityStatus.online
            : ConnectivityStatus.offline,
      );
    });
  }

  void _onNetworkReconnected() {
    _log.i('Network reconnected — restarting price stream');
    final service = ref.read(oandaStreamingServiceProvider);
    if (!service.isConnected) {
      final symbols = ref.read(watchlistedSymbolNamesProvider);
      if (symbols.isNotEmpty) {
        service.connect(symbols);
      }
    }
  }
}

// ============================================================
// 7.2.3 — Riverpod Providers
// ============================================================

final appStateProvider =
    NotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier.new,
);

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isOnline;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isAuthenticated;
});

final connectivityStatusProvider =
    Provider<ConnectivityStatus>((ref) {
  return ref.watch(appStateProvider).connectivity;
});
