// Path: lib/features/quotes/presentation/widgets/watchlist_manager_sheet.dart
// ============================================================
// MT5 Clone — Symbol Detail Sheet + Watchlist Manager
// SymbolDetailSheet: shows instrument info + quick trade actions
// WatchlistManagerSheet: add/remove/reorder symbols
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/symbol_entity.dart';
import '../../../../core/router/route_names.dart';
import '../providers/quote_providers.dart';
import '../../data/repositories/price_repository_impl.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../../../account/data/repositories/account_repository_impl.dart';

// ============================================================
// 8.3.1 — Symbol Detail Sheet
// ============================================================

class SymbolDetailSheet extends ConsumerWidget {
  final MarketWatchItem item;
  const SymbolDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symbol = item.symbol;
    final tick = item.tick;
    final tickAsync = ref.watch(symbolTickProvider(symbol.name));
    final liveTick = tickAsync.valueOrNull ?? tick;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16.r)),
          border: const Border(
            top: BorderSide(color: AppTheme.surfaceBorder, width: 0.5),
          ),
        ),
        child: Column(
          children: [
            // ── Drag Handle ──────────────────────────────────
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 4.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDivider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // ── Header: Symbol + Live Price ─────────────────
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol.displayLabel,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          symbol.displayName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        liveTick != null
                            ? liveTick.ask.toStringAsFixed(
                                symbol.displayPrecision)
                            : '—',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.buyGreen,
                        ),
                      ),
                      Text(
                        liveTick != null
                            ? liveTick.bid.toStringAsFixed(
                                symbol.displayPrecision)
                            : '—',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.sellRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 0, color: AppTheme.surfaceBorder),

            // ── Info Grid ────────────────────────────────────
            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.all(16.r),
                children: [
                  _InfoGrid(symbol: symbol, tick: liveTick),
                  SizedBox(height: 20.h),

                  // ── Quick Trade Buttons ────────────────────
                  _QuickTradeButtons(symbol: symbol, tick: liveTick),
                  SizedBox(height: 12.h),

                  // ── Navigation Buttons ────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            context.go(
                              '${RouteNames.chart}/${symbol.name}',
                            );
                          },
                          icon: const Icon(Icons.candlestick_chart,
                              size: 16),
                          label: const Text('View Chart'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info Grid ─────────────────────────────────────────────────

class _InfoGrid extends StatelessWidget {
  final SymbolEntity symbol;
  final dynamic tick;

  const _InfoGrid({required this.symbol, this.tick});

  @override
  Widget build(BuildContext context) {
    final spread = tick != null
        ? tick.spreadPips.toStringAsFixed(1)
        : '—';
    final leverage = (1 / (symbol.marginRate ?? 1.0)).round();

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.2,
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      children: [
        _InfoCell(label: 'Spread', value: spread, unit: 'pips'),
        _InfoCell(label: 'Pip Size',
            value: symbol.pipSize.toStringAsFixed(
                symbol.pipLocation.abs())),
        _InfoCell(label: 'Leverage', value: '1:$leverage'),
        _InfoCell(label: 'Margin', value: '${((symbol.marginRate ?? 0.0) * 100).toStringAsFixed(0)}%'),
        _InfoCell(label: 'Min Lot',
            value: (symbol.minimumTradeSize ?? 0.0).toStringAsFixed(2)),
        _InfoCell(label: 'Type', value: symbol.type.displayName),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;

  const _InfoCell({required this.label, required this.value, this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 9.sp, color: AppTheme.textMuted)),
          SizedBox(height: 2.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  )),
              if (unit != null) ...[
                SizedBox(width: 2.w),
                Text(unit!,
                    style: TextStyle(
                        fontSize: 8.sp, color: AppTheme.textMuted)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Quick Trade Buttons ────────────────────────────────────────

class _QuickTradeButtons extends StatelessWidget {
  final SymbolEntity symbol;
  final dynamic tick;

  const _QuickTradeButtons({required this.symbol, this.tick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SELL button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('${RouteNames.trading}/order/${symbol.name}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sellRed,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8.r)),
              ),
            ),
            child: Column(
              children: [
                Text('SELL',
                    style: TextStyle(
                        fontSize: 13.sp, fontWeight: FontWeight.w800)),
                if (tick != null)
                  Text(
                    tick.bid.toStringAsFixed(symbol.displayPrecision),
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 1.w),
        // BUY button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('${RouteNames.trading}/order/${symbol.name}');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.buyGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(8.r)),
              ),
            ),
            child: Column(
              children: [
                Text('BUY',
                    style: TextStyle(
                        fontSize: 13.sp, fontWeight: FontWeight.w800)),
                if (tick != null)
                  Text(
                    tick.ask.toStringAsFixed(symbol.displayPrecision),
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 8.4 — Watchlist Manager Sheet
// ============================================================

class WatchlistManagerSheet extends ConsumerStatefulWidget {
  const WatchlistManagerSheet({super.key});

  @override
  ConsumerState<WatchlistManagerSheet> createState() =>
      _WatchlistManagerSheetState();
}

class _WatchlistManagerSheetState
    extends ConsumerState<WatchlistManagerSheet> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allInstruments = ref.watch(instrumentsProvider);
    final watchlist = ref.watch(watchlistProvider);

    final watchlistNames = watchlist.valueOrNull
            ?.map((s) => s.name)
            .toSet() ??
        {};

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          children: [
            // ── Handle ───────────────────────────────────────
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDivider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Text('Manage Watchlist',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),

            // ── Search Bar ────────────────────────────────────
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                controller: _searchCtrl,
                style: TextStyle(
                    fontSize: 13.sp, color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search instruments...',
                  prefixIcon: Icon(Icons.search, size: 18),
                  isDense: true,
                ),
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
              ),
            ),

            const Divider(height: 0, color: AppTheme.surfaceBorder),

            // ── Instruments List ──────────────────────────────
            Expanded(
              child: allInstruments.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppTheme.primaryTeal),
                ),
                error: (e, _) => Center(
                  child: Text('Failed to load instruments',
                      style: TextStyle(color: AppTheme.textSecondary)),
                ),
                data: (instruments) {
                  final filtered = _searchQuery.isEmpty
                      ? instruments
                      : instruments
                          .where((s) =>
                              s.name
                                  .toLowerCase()
                                  .contains(_searchQuery) ||
                              s.displayName
                                  .toLowerCase()
                                  .contains(_searchQuery))
                          .toList();

                  return ListView.separated(
                    controller: controller,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                        height: 0,
                        thickness: 0.3,
                        color: AppTheme.surfaceBorder),
                    itemBuilder: (_, i) {
                      final sym = filtered[i];
                      final isWatched =
                          watchlistNames.contains(sym.name);

                      return ListTile(
                        dense: true,
                        title: Text(
                          sym.displayLabel,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          sym.displayName,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppTheme.textSecondary),
                        ),
                        trailing: GestureDetector(
                          onTap: () => _toggleWatchlist(sym, isWatched),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: isWatched
                                  ? AppTheme.primaryTeal
                                  : AppTheme.surfaceElevated,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isWatched
                                    ? AppTheme.primaryTeal
                                    : AppTheme.surfaceBorder,
                              ),
                            ),
                            child: Icon(
                              isWatched ? Icons.check : Icons.add,
                              size: 14.sp,
                              color: isWatched
                                  ? AppTheme.backgroundPrimary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleWatchlist(
      SymbolEntity sym, bool isWatched) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.toggleWatchlist(sym.name, !isWatched);
  }
}
