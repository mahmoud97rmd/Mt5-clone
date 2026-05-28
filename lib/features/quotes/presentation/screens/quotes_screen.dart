// Path: lib/features/quotes/presentation/screens/quotes_screen.dart
// ============================================================
// MT5 Clone — Quotes Screen (Market Watch)
// Displays real-time bid/ask prices for all watchlisted symbols.
// Features:
//   - Flashing red/blue price cells on each tick
//   - Simple and Advanced view modes
//   - Symbol search & filter
//   - Connection status indicator
//   - Pull-to-refresh
//   - Tap row → Symbol detail + quick trade
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/router/route_names.dart';
import '../providers/quote_providers.dart';
import '../widgets/quote_list_item.dart';
import '../widgets/quote_list_item_advanced.dart';
import '../widgets/stream_status_bar.dart';
import '../widgets/watchlist_manager_sheet.dart';

// ============================================================
// 8.1.1 — View Mode Enum
// ============================================================

enum QuoteViewMode { simple, advanced }

final quoteViewModeProvider =
    StateProvider<QuoteViewMode>((ref) => QuoteViewMode.simple);

final quoteSearchQueryProvider = StateProvider<String>((ref) => '');

// ============================================================
// 8.1.2 — Quotes Screen
// ============================================================

class QuotesScreen extends ConsumerStatefulWidget {
  const QuotesScreen({super.key});

  @override
  ConsumerState<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends ConsumerState<QuotesScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewMode = ref.watch(quoteViewModeProvider);
    final searchQuery = ref.watch(quoteSearchQueryProvider);
    final marketWatch = ref.watch(marketWatchProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            _buildHeader(viewMode),

            // ── Stream Status Bar ───────────────────────────
            const StreamStatusBar(),

            // ── Search Bar (when active) ────────────────────
            if (_isSearching) _buildSearchBar(),

            // ── Column Headers ──────────────────────────────
            _buildColumnHeaders(viewMode),

            // ── Quotes List ─────────────────────────────────
            Expanded(
              child: marketWatch.when(
                data: (items) {
                  // Filter by search query
                  final filtered = searchQuery.isEmpty
                      ? items
                      : items
                          .where((item) =>
                              item.symbol.name
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()) ||
                              item.symbol.displayLabel
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return _buildEmptyState(searchQuery);
                  }

                  return RefreshIndicator(
                    color: AppTheme.primaryTeal,
                    backgroundColor: AppTheme.surfaceCard,
                    onRefresh: () async {
                      ref.invalidate(marketWatchProvider);
                      await Future.delayed(
                          const Duration(milliseconds: 500));
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 0,
                        thickness: 0.3,
                        color: AppTheme.surfaceBorder,
                      ),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return viewMode == QuoteViewMode.simple
                            ? QuoteListItem(
                                item: item,
                                onTap: () =>
                                    _onSymbolTap(context, item),
                                onChartTap: () => context.go(
                                  '${RouteNames.chart}/${item.symbol.name}',
                                ),
                              )
                            : QuoteListItemAdvanced(
                                item: item,
                                onTap: () =>
                                    _onSymbolTap(context, item),
                              );
                      },
                    ),
                  );
                },
                loading: () => _buildLoadingState(),
                error: (err, _) => _buildErrorState(err),
              ),
            ),
          ],
        ),
      ),

      // ── FAB: Add Symbol ──────────────────────────────────
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: AppTheme.backgroundPrimary,
        onPressed: () => _showWatchlistManager(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ============================================================
  // 8.1.3 — Header
  // ============================================================

  Widget _buildHeader(QuoteViewMode viewMode) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundSecondary,
        border: Border(
          bottom: BorderSide(color: AppTheme.surfaceBorder, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // ── Title ─────────────────────────────────────────
          Text(
            'Market Watch',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),

          // ── Search toggle ──────────────────────────────────
          _HeaderIconButton(
            icon: _isSearching ? Icons.search_off : Icons.search,
            onTap: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(quoteSearchQueryProvider.notifier).state = '';
                }
              });
            },
          ),

          SizedBox(width: 4.w),

          // ── View mode toggle ───────────────────────────────
          _HeaderIconButton(
            icon: viewMode == QuoteViewMode.simple
                ? Icons.view_agenda_outlined
                : Icons.view_list_outlined,
            onTap: () {
              ref.read(quoteViewModeProvider.notifier).state =
                  viewMode == QuoteViewMode.simple
                      ? QuoteViewMode.advanced
                      : QuoteViewMode.simple;
            },
          ),

          SizedBox(width: 4.w),

          // ── Manage watchlist ───────────────────────────────
          _HeaderIconButton(
            icon: Icons.tune,
            onTap: () => _showWatchlistManager(context),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.all(8.r),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(fontSize: 13.sp, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search symbols...',
          prefixIcon: const Icon(Icons.search, size: 18),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    ref.read(quoteSearchQueryProvider.notifier).state = '';
                  },
                  child: const Icon(Icons.clear, size: 16),
                )
              : null,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
          isDense: true,
        ),
        onChanged: (v) =>
            ref.read(quoteSearchQueryProvider.notifier).state = v,
      ),
    );
  }

  // ── Column Headers ────────────────────────────────────────

  Widget _buildColumnHeaders(QuoteViewMode mode) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: AppTheme.surfaceCard,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _ColHeader('Symbol'),
          ),
          if (mode == QuoteViewMode.advanced)
            Expanded(flex: 2, child: _ColHeader('High', right: true)),
          if (mode == QuoteViewMode.advanced)
            Expanded(flex: 2, child: _ColHeader('Low', right: true)),
          Expanded(flex: 2, child: _ColHeader('Bid', right: true)),
          Expanded(flex: 2, child: _ColHeader('Ask', right: true)),
          Expanded(flex: 2, child: _ColHeader('Spread', right: true)),
        ],
      ),
    );
  }

  // ── Empty / Loading / Error States ────────────────────────

  Widget _buildEmptyState(String query) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off,
              size: 48.sp, color: AppTheme.textDisabled),
          SizedBox(height: 12.h),
          Text(
            query.isEmpty
                ? 'No symbols in watchlist.\nTap + to add symbols.'
                : 'No results for "$query"',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) =>
          const Divider(height: 0, color: AppTheme.surfaceBorder),
      itemBuilder: (_, __) => _QuoteRowSkeleton(),
    );
  }

  Widget _buildErrorState(Object err) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off,
              color: AppTheme.sellRed, size: 40),
          SizedBox(height: 12.h),
          Text(
            'Failed to load prices',
            style: TextStyle(
                color: AppTheme.textSecondary, fontSize: 14.sp),
          ),
          TextButton(
            onPressed: () => ref.invalidate(marketWatchProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // ── Actions ───────────────────────────────────────────────

  void _onSymbolTap(BuildContext context, MarketWatchItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SymbolDetailSheet(item: item),
    );
  }

  void _showWatchlistManager(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const WatchlistManagerSheet(),
    );
  }
}

// ============================================================
// Helper Widgets
// ============================================================

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppTheme.surfaceBorder, width: 0.5),
        ),
        child: Icon(icon, size: 16.sp, color: AppTheme.textSecondary),
      ),
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String label;
  final bool right;
  const _ColHeader(this.label, {this.right = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: right ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        fontSize: 9.sp,
        fontWeight: FontWeight.w600,
        color: AppTheme.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _QuoteRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          _SkeletonBox(width: 80.w, height: 14.h),
          const Spacer(),
          _SkeletonBox(width: 60.w, height: 14.h),
          SizedBox(width: 8.w),
          _SkeletonBox(width: 60.w, height: 14.h),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.surfaceBorder,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}
