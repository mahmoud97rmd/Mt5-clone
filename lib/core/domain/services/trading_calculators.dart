// Path: lib/core/domain/services/trading_calculators.dart
// ============================================================
// MT5 Clone — Trading Math Domain Services
// Pure functions — no side effects, no external dependencies.
// All financial calculations live here (single source of truth).
//
// ⭐ These formulas must match OANDA's exact calculation model
//    to ensure our displayed PnL matches the broker's records.
// ============================================================

// ============================================================
// 3.5.1 — PnL Calculator
// ============================================================

class PnlCalculator {
  const PnlCalculator._();

  /// Calculate floating PnL for an open position.
  ///
  /// Formula (OANDA):
  ///   BUY PnL  = (currentPrice - openPrice) × units
  ///   SELL PnL = (openPrice - currentPrice) × units
  ///
  /// For XAU/USD: units = lots × 100 (100 oz per lot)
  /// For FX pairs: units = lots × 100,000
  ///
  /// Result is always in the QUOTE currency (USD for XAU/USD, EUR/USD, etc.)
  /// If account currency ≠ quote currency, conversion needed (see convertPnl).
  static double calculateFloatingPnl({
    required bool isBuy,
    required double openPrice,
    required double currentPrice,
    required double units,
  }) {
    if (openPrice <= 0 || currentPrice <= 0 || units == 0) return 0.0;

    final rawPnl = isBuy
        ? (currentPrice - openPrice) * units
        : (openPrice - currentPrice) * units;

    return double.parse(rawPnl.toStringAsFixed(2));
  }

  /// Calculate PnL using lot size (converts to units internally).
  static double calculatePnlFromLots({
    required bool isBuy,
    required double openPrice,
    required double currentPrice,
    required double lots,
    required double unitsPerLot,
  }) {
    return calculateFloatingPnl(
      isBuy: isBuy,
      openPrice: openPrice,
      currentPrice: currentPrice,
      units: lots * unitsPerLot,
    );
  }

  /// Convert PnL from quote currency to account currency.
  /// Required when quoting currency (XAU/USD's USD) ≠ account currency.
  ///
  /// Example: Account in EUR, trading GBP/USD
  ///   PnL in USD → multiply by EUR/USD rate to get EUR PnL
  static double convertPnlToAccountCurrency({
    required double pnlInQuoteCurrency,
    required double quoteCurrencyToAccountRate,
  }) {
    return pnlInQuoteCurrency / quoteCurrencyToAccountRate;
  }

  /// Calculate the realized PnL from a closed trade.
  static double calculateRealizedPnl({
    required bool isBuy,
    required double openPrice,
    required double closePrice,
    required double units,
    double swap = 0.0,
    double commission = 0.0,
  }) {
    final grossPnl = calculateFloatingPnl(
      isBuy: isBuy,
      openPrice: openPrice,
      currentPrice: closePrice,
      units: units,
    );
    return double.parse(
        (grossPnl + swap - commission).toStringAsFixed(2));
  }

  /// Calculate PnL in pips (for risk analysis).
  static double calculatePnlInPips({
    required bool isBuy,
    required double openPrice,
    required double currentPrice,
    required double pipSize,
  }) {
    final delta = isBuy
        ? currentPrice - openPrice
        : openPrice - currentPrice;
    return delta / pipSize;
  }

  /// Estimate the pip value (profit per pip per lot) for a symbol.
  /// This is the fundamental unit for risk management.
  ///
  /// Formula: pipValue = pipSize × units / currentPrice (for non-USD quote)
  ///
  /// For XAU/USD: pip = 0.01, units = 100/lot
  ///   pipValue = 0.01 × 100 = $1.00 per lot per pip
  ///
  /// For EUR/USD: pip = 0.0001, units = 100,000/lot
  ///   pipValue = 0.0001 × 100,000 = $10.00 per lot per pip
  static double calculatePipValue({
    required double pipSize,
    required double units,
    String quoteCurrency = 'USD',
    String accountCurrency = 'USD',
    double quoteCurrencyRate = 1.0, // USD/quoteCurrency rate if needed
  }) {
    final rawPipValue = pipSize * units;
    if (quoteCurrency == accountCurrency) return rawPipValue;
    return rawPipValue / quoteCurrencyRate;
  }
}

// ============================================================
// 3.5.2 — Margin Calculator
// ============================================================

class MarginCalculator {
  const MarginCalculator._();

  /// Calculate required margin to open a position.
  ///
  /// Formula (OANDA):
  ///   Margin = units × price × marginRate
  ///
  /// Where marginRate = 1/leverage (e.g., 50:1 leverage → 0.02 rate)
  ///
  /// For XAU/USD at 1,950.00 with 1% margin rate, 0.01 lots (1 unit):
  ///   Margin = 1 × 1950.00 × 0.01 = $19.50
  static double calculateRequiredMargin({
    required double units,
    required double price,
    required double marginRate,
  }) {
    if (units <= 0 || price <= 0 || marginRate <= 0) return 0.0;
    return double.parse(
        (units * price * marginRate).toStringAsFixed(2));
  }

  /// Calculate required margin from lot size.
  static double calculateMarginFromLots({
    required double lots,
    required double unitsPerLot,
    required double price,
    required double marginRate,
  }) {
    return calculateRequiredMargin(
      units: lots * unitsPerLot,
      price: price,
      marginRate: marginRate,
    );
  }

  /// Calculate the current margin level percentage.
  ///
  /// Formula: MarginLevel% = (Equity / MarginUsed) × 100
  ///
  /// Thresholds:
  ///   > 200% → Safe
  ///   100–200% → Caution
  ///   50–100% → Danger (margin call imminent)
  ///   < 50%  → Stop out (OANDA closes positions)
  static double? calculateMarginLevel({
    required double equity,
    required double marginUsed,
  }) {
    if (marginUsed <= 0) return null; // No positions open
    return (equity / marginUsed) * 100.0;
  }

  /// Calculate equity from balance and floating PnL.
  static double calculateEquity({
    required double balance,
    required double totalFloatingPnl,
  }) {
    return balance + totalFloatingPnl;
  }

  /// Calculate free margin (available for new trades).
  static double calculateFreeMargin({
    required double equity,
    required double marginUsed,
  }) {
    return equity - marginUsed;
  }

  /// Calculate the maximum lot size tradeable given free margin.
  static double calculateMaxLots({
    required double freeMargin,
    required double price,
    required double marginRate,
    required double unitsPerLot,
    double safetyFactor = 0.95, // Use 95% of free margin for safety
  }) {
    if (freeMargin <= 0 || price <= 0 || marginRate <= 0) return 0.0;
    final safeFreeMargin = freeMargin * safetyFactor;
    final maxUnits = safeFreeMargin / (price * marginRate);
    final maxLots = maxUnits / unitsPerLot;
    // Round down to nearest 0.01 lot
    return (maxLots * 100).floor() / 100.0;
  }

  /// Check if there is sufficient margin to open a new position.
  static bool hasSufficientMargin({
    required double freeMargin,
    required double requiredMargin,
    double minimumBuffer = 0.0, // extra safety buffer
  }) {
    return freeMargin >= requiredMargin + minimumBuffer;
  }
}

// ============================================================
// 3.5.3 — Pip Calculator
// ============================================================

class PipCalculator {
  const PipCalculator._();

  /// Convert a price distance to pips.
  static double priceToPips(double priceDistance, double pipSize) {
    if (pipSize <= 0) return 0.0;
    return priceDistance / pipSize;
  }

  /// Convert pips to price distance.
  static double pipsToPrice(double pips, double pipSize) {
    return pips * pipSize;
  }

  /// Calculate SL price from pips distance.
  static double calculateSlPrice({
    required bool isBuy,
    required double entryPrice,
    required double slPips,
    required double pipSize,
  }) {
    final slDistance = slPips * pipSize;
    return isBuy ? entryPrice - slDistance : entryPrice + slDistance;
  }

  /// Calculate TP price from pips distance.
  static double calculateTpPrice({
    required bool isBuy,
    required double entryPrice,
    required double tpPips,
    required double pipSize,
  }) {
    final tpDistance = tpPips * pipSize;
    return isBuy ? entryPrice + tpDistance : entryPrice - tpDistance;
  }

  /// Calculate Risk:Reward ratio.
  static double calculateRiskRewardRatio({
    required double slPips,
    required double tpPips,
  }) {
    if (slPips <= 0) return 0.0;
    return tpPips / slPips;
  }

  /// Calculate lot size based on risk percentage.
  ///
  /// Formula: Lots = (AccountBalance × RiskPct%) / (SL_Pips × PipValue)
  ///
  /// Example: $10,000 account, 1% risk, 50 pip SL, $1 pip value (0.01 lot XAU)
  ///   Risk amount = $10,000 × 0.01 = $100
  ///   Lots = $100 / (50 × $1) = 2 lots... but XAU $1/pip is per 0.01 lot
  ///   So we'd divide by pipValuePerLot
  static double calculateLotSizeFromRisk({
    required double accountBalance,
    required double riskPercent,  // e.g., 1.0 for 1%
    required double slPips,
    required double pipValuePerLot, // in account currency
    double minLots = 0.01,
    double maxLots = 100.0,
  }) {
    if (slPips <= 0 || pipValuePerLot <= 0) return minLots;
    final riskAmount = accountBalance * (riskPercent / 100.0);
    final rawLots = riskAmount / (slPips * pipValuePerLot);
    // Clamp and round to 2 decimal places
    final clampedLots = rawLots.clamp(minLots, maxLots);
    return (clampedLots * 100).round() / 100.0;
  }

  /// Calculate pip size from OANDA pipLocation.
  /// pipLocation: -4 → 0.0001, -2 → 0.01, -5 → 0.00001
  static double pipSizeFromLocation(int pipLocation) {
    double size = 1.0;
    final exp = -pipLocation;
    for (int i = 0; i < exp; i++) size /= 10.0;
    return size;
  }

  /// Validate that a SL price is on the correct side of entry.
  static bool isValidStopLoss({
    required bool isBuy,
    required double entryPrice,
    required double slPrice,
  }) {
    return isBuy ? slPrice < entryPrice : slPrice > entryPrice;
  }

  /// Validate that a TP price is on the correct side of entry.
  static bool isValidTakeProfit({
    required bool isBuy,
    required double entryPrice,
    required double tpPrice,
  }) {
    return isBuy ? tpPrice > entryPrice : tpPrice < entryPrice;
  }
}

// ============================================================
// 3.5.4 — Account Math Engine (combines all calculators)
// The single class called on every tick to update account state.
// ============================================================

class AccountMathEngine {
  const AccountMathEngine._();

  /// Recalculate all account metrics from current positions and balance.
  /// Called on every price tick — must be fast (O(n) positions).
  static AccountMetrics recalculate({
    required double balance,
    required List<PositionMetrics> positions,
  }) {
    double totalFloatingPnl = 0.0;
    double totalMarginUsed = 0.0;

    for (final pos in positions) {
      totalFloatingPnl += pos.floatingPnl;
      totalMarginUsed += pos.marginUsed;
    }

    final equity = MarginCalculator.calculateEquity(
      balance: balance,
      totalFloatingPnl: totalFloatingPnl,
    );

    final freeMargin = MarginCalculator.calculateFreeMargin(
      equity: equity,
      marginUsed: totalMarginUsed,
    );

    final marginLevel = MarginCalculator.calculateMarginLevel(
      equity: equity,
      marginUsed: totalMarginUsed,
    );

    return AccountMetrics(
      balance: balance,
      equity: equity,
      marginUsed: totalMarginUsed,
      freeMargin: freeMargin,
      marginLevel: marginLevel,
      totalFloatingPnl: totalFloatingPnl,
    );
  }
}

/// Input data for one position in the account math calculation.
class PositionMetrics {
  final double floatingPnl;
  final double marginUsed;

  const PositionMetrics({
    required this.floatingPnl,
    required this.marginUsed,
  });
}

/// Output of AccountMathEngine.recalculate()
class AccountMetrics {
  final double balance;
  final double equity;
  final double marginUsed;
  final double freeMargin;
  final double? marginLevel;
  final double totalFloatingPnl;

  const AccountMetrics({
    required this.balance,
    required this.equity,
    required this.marginUsed,
    required this.freeMargin,
    required this.marginLevel,
    required this.totalFloatingPnl,
  });

  bool get isMarginCallRisk {
    final ml = marginLevel;
    return ml != null && ml < 100.0;
  }
}
