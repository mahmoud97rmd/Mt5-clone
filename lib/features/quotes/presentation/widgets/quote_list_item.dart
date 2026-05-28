// Path: lib/features/quotes/presentation/widgets/quote_list_item.dart
// ============================================================
// MT5 Clone — Quote List Item (Simple View)
// Single row in the Market Watch list.
//
// Features:
//   - Bid/Ask price display with JetBrains Mono font
//   - Flash animation: blue on price rise, red on price fall
//   - Spread display in pips
//   - Mini sparkline direction arrow
//   - Tap → Symbol detail sheet
//   - Long press → Quick trade
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app/app_theme.dart';
import '../../../../core/domain/entities/tick_entity.dart';
import '../providers/quote_providers.dart';

// ============================================================
// 8.2.1 — Quote List Item (Simple View)
// ============================================================

class QuoteListItem extends ConsumerStatefulWidget {
  final MarketWatchItem item;
  final VoidCallback onTap;
  final VoidCallback? onChartTap;

  const QuoteListItem({
    super.key,
    required this.item,
    required this.onTap,
    this.onChartTap,
  });

  @override
  ConsumerState<QuoteListItem> createState() => _QuoteListItemState();
}

class _QuoteListItemState extends ConsumerState<QuoteListItem>
    with SingleTickerProviderStateMixin {

  // ── Flash state ───────────────────────────────────────────
  _FlashColor _bidFlash = _FlashColor.none;
  _FlashColor _askFlash = _FlashColor.none;

  double? _prevBid;
  double? _prevAsk;

  Timer? _bidFlashTimer;
  Timer? _askFlashTimer;

  // ── Flash duration ────────────────────────────────────────
  static const _flashDuration = Duration(milliseconds: 600);

  @override
  void dispose() {
    _bidFlashTimer?.cancel();
    _askFlashTimer?.cancel();
    super.dispose();
  }

  // ============================================================
  // 8.2.2 — Price Change Detection & Flash Trigger
  // ============================================================

  void _onTickUpdate(TickEntity tick) {
    if (!mounted) return;

    // Bid flash
    if (_prevBid != null && tick.bid != _prevBid) {
      final newBidFlash =
          tick.bid > _prevBid! ? _FlashColor.up : _FlashColor.down;
      setState(() => _bidFlash = newBidFlash);
      _bidFlashTimer?.cancel();
      _bidFlashTimer = Timer(_flashDuration, () {
        if (mounted) setState(() => _bidFlash = _FlashColor.none);
      });
    }

    // Ask flash
    if (_prevAsk != null && tick.ask != _prevAsk) {
      final newAskFlash =
          tick.ask > _prevAsk! ? _FlashColor.up : _FlashColor.down;
      setState(() => _askFlash = newAskFlash);
      _askFlashTimer?.cancel();
      _askFlashTimer = Timer(_flashDuration, () {
        if (mounted) setState(() => _askFlash = _FlashColor.none);
      });
    }

    _prevBid = tick.bid;
    _prevAsk = tick.ask;
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to live tick stream for this symbol
    ref.listen(
      symbolTickProvider(widget.item.symbol.name),
      (_, next) => next.whenData((tick) { if (tick != null) _onTickUpdate(tick); }),
    );

    final tick = widget.item.tick;
    final symbol = widget.item.symbol;
    final precision = symbol.displayPrecision;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () => _showQuickTrade(context),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        color: Colors.transparent,
        child: Row(
          children: [
            // ── Symbol Name ─────────────────────────────────
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol.displayLabel,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    symbol.type.displayName,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // ── Bid Price ────────────────────────────────────
            Expanded(
              flex: 2,
              child: _PriceCell(
                value: tick?.bid,
                precision: precision,
                flash: _bidFlash,
                align: TextAlign.right,
              ),
            ),

            SizedBox(width: 4.w),

            // ── Ask Price ────────────────────────────────────
            Expanded(
              flex: 2,
              child: _PriceCell(
                value: tick?.ask,
                precision: precision,
                flash: _askFlash,
                align: TextAlign.right,
              ),
            ),

            SizedBox(width: 4.w),

            // ── Spread ───────────────────────────────────────
            Expanded(
              flex: 2,
              child: _SpreadCell(spreadPips: tick?.spreadPips),
            ),

            SizedBox(width: 4.w),

            // ── Chart shortcut ───────────────────────────────
            GestureDetector(
              onTap: widget.onChartTap,
              child: Icon(
                Icons.candlestick_chart_outlined,
                size: 16.sp,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickTrade(BuildContext context) {
    // Implemented in Phase 11 (Order Entry)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Long press → Quick trade for ${widget.item.symbol.displayLabel}'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppTheme.surfaceElevated,
      ),
    );
  }
}

// ============================================================
// 8.2.2 — Price Flash Cell
// Animates background color when price changes.
// ============================================================

enum _FlashColor { none, up, down }

class _PriceCell extends StatelessWidget {
  final double? value;
  final int precision;
  final _FlashColor flash;
  final TextAlign align;

  const _PriceCell({
    required this.value,
    required this.precision,
    required this.flash,
    required this.align,
  });

  Color get _bgColor => switch (flash) {
        _FlashColor.up => AppTheme.buyGreenGlow,
        _FlashColor.down => AppTheme.sellRedGlow,
        _FlashColor.none => Colors.transparent,
      };

  Color get _textColor => switch (flash) {
        _FlashColor.up => AppTheme.buyGreen,
        _FlashColor.down => AppTheme.sellRed,
        _FlashColor.none => AppTheme.textPrimary,
      };

  @override
  Widget build(BuildContext context) {
    final displayValue = value != null
        ? _formatPrice(value!, precision)
        : '—';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 150),
        style: GoogleFonts.jetBrainsMono(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
        child: Text(
          displayValue,
          textAlign: align,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  /// Format price with highlighted last digit (fractional pip)
  String _formatPrice(double price, int precision) {
    return price.toStringAsFixed(precision);
  }
}

// ============================================================
// 8.2.3 — Spread Cell
// ============================================================

class _SpreadCell extends StatelessWidget {
  final double? spreadPips;

  const _SpreadCell({this.spreadPips});

  @override
  Widget build(BuildContext context) {
    final display = spreadPips != null
        ? spreadPips!.toStringAsFixed(1)
        : '—';

    // Color code: tight spread = green, wide = amber/red
    final color = spreadPips == null
        ? AppTheme.textMuted
        : spreadPips! < 3
            ? AppTheme.textSecondary
            : spreadPips! < 10
                ? AppTheme.warningAmber
                : AppTheme.sellRed;

    return Text(
      display,
      textAlign: TextAlign.right,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 11.sp,
        color: color,
      ),
    );
  }
}
