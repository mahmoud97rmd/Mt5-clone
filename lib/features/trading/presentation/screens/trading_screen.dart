// Path: lib/features/trading/presentation/screens/trading_screen.dart
// ============================================================
// MT5 Clone — Trading Screen
// Main trading terminal with account top bar, tab bar for
// Open Positions / Pending Orders, and FAB for order entry.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../account/presentation/providers/account_providers.dart';
import '../../../quotes/presentation/providers/quote_providers.dart';
import '../notifiers/trading_notifiers.dart';
import '../widgets/account_top_bar.dart';
import '../widgets/modify_position_sheet.dart';
import '../widgets/open_positions_tab.dart';
import '../widgets/order_entry_sheet.dart';
import '../widgets/pending_orders_tab.dart';

class TradingScreen extends ConsumerStatefulWidget {
  const TradingScreen({super.key});

  @override
  ConsumerState<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends ConsumerState<TradingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    try {
      final accountAsync = ref.read(accountInitProvider);
      accountAsync.when(
        data: (_) {
          if (mounted) setState(() => _connectionError = null);
        },
        loading: () {},
        error: (e, _) {
          if (mounted) setState(() => _connectionError = e.toString());
        },
      );
    } catch (e) {
      if (mounted) setState(() => _connectionError = e.toString());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(accountInitProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trading Terminal',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 22.sp),
            onPressed: () => _showOrderEntry(context),
            tooltip: 'New Order',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Connection Error Banner ────────────────────────
          if (_connectionError != null || accountAsync.hasError)
            _ErrorBanner(
              message: _connectionError ??
                  accountAsync.error.toString(),
              onRetry: () {
                ref.invalidate(accountInitProvider);
                setState(() => _connectionError = null);
              },
            ),

          // ── Account Top Bar ─────────────────────────────────
          const AccountTopBar(),

          // ── Tab Bar ─────────────────────────────────────────
          Container(
            color: AppTheme.backgroundSecondary,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Positions'),
                Tab(text: 'Orders'),
              ],
            ),
          ),

          // ── Tab Content ─────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OpenPositionsTab(
                  onModifyPosition: (tradeId) =>
                      _showModifySheet(context, tradeId),
                ),
                const PendingOrdersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryTeal,
        onPressed: () => _showOrderEntry(context),
        child: Icon(Icons.add,
            color: AppTheme.backgroundPrimary, size: 28.sp),
      ),
    );
  }

  void _showOrderEntry(BuildContext context) {
    // Default to first watchlisted symbol
    final watchlist = ref.read(watchlistedSymbolNamesProvider);
    final symbol = watchlist.isNotEmpty ? watchlist.first : 'EUR_USD';
    OrderEntrySheet.show(context, symbol);
  }

  void _showModifySheet(BuildContext context, String tradeId) {
    // Find the position from the notifier state
    final positions = ref
        .read(openPositionsNotifierProvider)
        .positions;
    final pos = positions.where((p) => p.oandaTradeId == tradeId).firstOrNull;
    if (pos != null) {
      ModifyPositionSheet.show(context, pos);
    }
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0x33FF4757),
      child: Row(
        children: [
          const Icon(Icons.error_outline,
              color: Color(0xFFFF4757), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Connection error: $message',
              style: const TextStyle(
                color: Color(0xFFFF4757),
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry',
                style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
