// Path: lib/features/ea/presentation/providers/ea_manager_providers.dart
// ============================================================
// MT5 Clone — EA Manager Providers
// Riverpod providers for EA management UI state.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/ea_entities.dart';
import '../../../../core/domain/enums/trading_enums.dart';
import '../../data/repositories/ea_repository_impl.dart';

// ── EA Instances ────────────────────────────────────────────

final eaInstancesProvider =
    StreamProvider<List<EaInstanceEntity>>((ref) {
  return ref.watch(eaRepositoryProvider).watchEaInstances();
});

final eaInstanceByIdProvider =
    Provider.family<EaInstanceEntity?, int>((ref, id) {
  final instances = ref.watch(eaInstancesProvider);
  return instances.whenData((list) {
    try {
      return list.firstWhere((ea) => ea.id == id);
    } catch (_) {
      return null;
    }
  }).valueOrNull;
});

// ── EA Logs ─────────────────────────────────────────────────

final eaLogsProvider =
    StreamProvider.family<List<EaLogEntity>, int>((ref, eaId) {
  return ref.watch(eaRepositoryProvider).watchEaLogs(eaId);
});

// ── Selected EA for log viewing ─────────────────────────────

final selectedEaLogIdProvider = StateProvider<int?>((ref) => null);

// ── EA running state ────────────────────────────────────────

final eaRunningStateProvider =
    StateProvider<Map<int, bool>>((ref) => {});

// ── EA stats (computed from instances) ──────────────────────

final totalRunningEaCountProvider = Provider<int>((ref) {
  final instances = ref.watch(eaInstancesProvider);
  return instances.whenData((list) {
    return list.where((ea) => ea.status == EaStatus.running).length;
  }).valueOrNull ?? 0;
});
