// Path: lib/core/app/app_theme.dart
// ============================================================
// MT5 Clone — Application Theme
// Dark professional trading terminal aesthetic.
// Color palette inspired by MetaTrader 5 dark theme.
//
// Design tokens:
//   Background:  #0A0E14 (deep charcoal navy)
//   Surface:     #0D1117 (card/panel background)
//   Surface2:    #161B22 (elevated surface)
//   Border:      #21262D (subtle borders)
//   Primary:     #00D4AA (teal — buy/profit)
//   Sell:        #FF4757 (red — sell/loss)
//   Text:        #E6EDF3 (primary text)
//   TextMuted:   #7D8590 (secondary text)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // 7.1.3.1 — Color Palette
  // ============================================================

  // ── Backgrounds ───────────────────────────────────────────
  static const Color backgroundPrimary   = Color(0xFF0A0E14);
  static const Color backgroundSecondary = Color(0xFF0D1117);
  static const Color surfaceCard         = Color(0xFF161B22);
  static const Color surfaceElevated     = Color(0xFF1C2128);
  static const Color surfaceBorder       = Color(0xFF21262D);
  static const Color surfaceDivider      = Color(0xFF30363D);

  // ── Brand / Accent ────────────────────────────────────────
  static const Color primaryTeal         = Color(0xFF00D4AA);
  static const Color primaryTealDim      = Color(0xFF00A884);
  static const Color primaryTealGlow     = Color(0x3300D4AA);

  // ── Trading Colors ────────────────────────────────────────
  static const Color buyGreen            = Color(0xFF00C853);
  static const Color buyGreenDim         = Color(0xFF00A044);
  static const Color buyGreenGlow        = Color(0x3300C853);
  static const Color sellRed             = Color(0xFFFF4757);
  static const Color sellRedDim          = Color(0xFFCC1A29);
  static const Color sellRedGlow         = Color(0x33FF4757);
  static const Color profitColor         = Color(0xFF00E676);
  static const Color lossColor           = Color(0xFFFF5252);
  static const Color warningAmber        = Color(0xFFFFC107);
  static const Color dangerRed           = Color(0xFFFF1744);

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary         = Color(0xFFE6EDF3);
  static const Color textSecondary       = Color(0xFF8B949E);
  static const Color textMuted           = Color(0xFF7D8590);
  static const Color textDisabled        = Color(0xFF484F58);

  // ── Chart Colors ──────────────────────────────────────────
  static const Color chartGrid           = Color(0xFF1C2128);
  static const Color chartCrosshair      = Color(0xFF4D9FFF);
  static const Color chartBullCandle     = Color(0xFF00C853);
  static const Color chartBearCandle     = Color(0xFFFF4757);
  static const Color chartVolume         = Color(0x5500D4AA);
  static const Color chartBg             = Color(0xFF0A0E14);

  // ============================================================
  // 7.1.3.2 — Typography
  // ============================================================

  static TextTheme _buildTextTheme() {
    // JetBrains Mono for numbers/prices, Inter for labels
    return TextTheme(
      // Large price display (e.g., 1950.23)
      displayLarge: GoogleFonts.jetBrainsMono(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.jetBrainsMono(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.jetBrainsMono(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      // Headlines (section titles)
      headlineLarge: GoogleFonts.inter(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      // Body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: textMuted,
      ),
      // Labels (table headers, tab labels)
      labelLarge: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: textMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  // ============================================================
  // 7.1.3.3 — Dark Theme
  // ============================================================

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    final textTheme = _buildTextTheme();

    return base.copyWith(
      brightness: Brightness.dark,
      textTheme: textTheme,

      // ── Color Scheme ──────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: primaryTeal,
        onPrimary: backgroundPrimary,
        primaryContainer: Color(0xFF003D33),
        onPrimaryContainer: primaryTeal,
        secondary: buyGreen,
        onSecondary: backgroundPrimary,
        error: sellRed,
        onError: Colors.white,
        surface: surfaceCard,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceElevated,
        outline: surfaceBorder,
        outlineVariant: surfaceDivider,
        shadow: Colors.black,
        scrim: Colors.black54,
      ),

      // ── Scaffold ──────────────────────────────────────────
      scaffoldBackgroundColor: backgroundPrimary,

      // ── AppBar ────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundSecondary,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 22),
        actionsIconTheme:
            const IconThemeData(color: textSecondary, size: 22),
      ),

      // ── Bottom Navigation ─────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundSecondary,
        selectedItemColor: primaryTeal,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle:
            GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w400),
      ),

      // ── Tab Bar ───────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: primaryTeal,
        unselectedLabelColor: textMuted,
        indicatorColor: primaryTeal,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle:
            GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w400),
      ),

      // ── Cards ─────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: const BorderSide(color: surfaceBorder, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Buttons ───────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: backgroundPrimary,
          textStyle: GoogleFonts.inter(
              fontSize: 14.sp, fontWeight: FontWeight.w700),
          padding:
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r)),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTeal,
          textStyle: GoogleFonts.inter(
              fontSize: 14.sp, fontWeight: FontWeight.w600),
          padding:
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          side: const BorderSide(color: primaryTeal, width: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryTeal,
          textStyle: GoogleFonts.inter(
              fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
      ),

      // ── Input Fields ──────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: primaryTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: sellRed),
        ),
        labelStyle: GoogleFonts.inter(
            fontSize: 13.sp, color: textSecondary),
        hintStyle:
            GoogleFonts.inter(fontSize: 13.sp, color: textDisabled),
        errorStyle:
            GoogleFonts.inter(fontSize: 11.sp, color: sellRed),
        prefixIconColor: textMuted,
        suffixIconColor: textMuted,
      ),

      // ── Dialogs ───────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceCard,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: surfaceBorder),
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14.sp,
          color: textSecondary,
        ),
      ),

      // ── Bottom Sheet ──────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceCard,
        modalBackgroundColor: surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        showDragHandle: true,
        dragHandleColor: textMuted,
      ),

      // ── List Tiles ────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        textColor: textPrimary,
        iconColor: textSecondary,
        tileColor: Colors.transparent,
        selectedTileColor: primaryTealGlow,
        selectedColor: primaryTeal,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
        dense: true,
      ),

      // ── Divider ───────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: surfaceBorder,
        thickness: 0.5,
        space: 0,
      ),

      // ── Chips ─────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: surfaceElevated,
        selectedColor: primaryTealGlow,
        labelStyle:
            GoogleFonts.inter(fontSize: 12.sp, color: textPrimary),
        side: const BorderSide(color: surfaceBorder),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r)),
        padding:
            EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      ),

      // ── Switches ──────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor:
            WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryTeal;
          }
          return textMuted;
        }),
        trackColor:
            WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryTealGlow;
          }
          return surfaceBorder;
        }),
      ),

      // ── Progress Indicators ───────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryTeal,
        linearTrackColor: surfaceBorder,
        circularTrackColor: surfaceBorder,
      ),

      // ── Snack Bar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceElevated,
        contentTextStyle:
            GoogleFonts.inter(fontSize: 13.sp, color: textPrimary),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ── Tooltip ───────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceElevated,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: surfaceBorder),
        ),
        textStyle:
            GoogleFonts.inter(fontSize: 11.sp, color: textPrimary),
      ),

      // ── Icon ──────────────────────────────────────────────
      iconTheme:
          const IconThemeData(color: textSecondary, size: 20),
    );
  }

  // ============================================================
  // 7.1.3.4 — Custom Color Extensions
  // ============================================================

  static Color pnlColor(double pnl) =>
      pnl >= 0 ? profitColor : lossColor;

  static Color directionColor(bool isBuy) =>
      isBuy ? buyGreen : sellRed;

  static Color marginLevelColor(double? level) {
    if (level == null) return primaryTeal;
    if (level < 50) return dangerRed;
    if (level < 100) return sellRed;
    if (level < 150) return warningAmber;
    return primaryTeal;
  }
}
