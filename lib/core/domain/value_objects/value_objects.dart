// Path: lib/core/domain/value_objects/value_objects.dart
// ============================================================
// MT5 Clone — Financial Value Objects
// Encapsulates domain-specific types with built-in validation.
// Prevents primitive obsession (passing raw doubles for prices).
//
// Value Objects are:
//   - Immutable
//   - Self-validating
//   - Comparable by value (not identity)
// ============================================================

import 'package:equatable/equatable.dart';

// ============================================================
// 3.1.3.1 — Price Value Object
// Represents a financial price (bid, ask, SL, TP, open price)
// ============================================================

class Price extends Equatable {
  final double value;
  final int precision; // decimal places

  const Price._(this.value, this.precision);

  /// Create a Price. Throws if value is negative or zero.
  factory Price(double value, {int precision = 5}) {
    if (value <= 0) {
      throw ArgumentError('Price must be positive, got: $value');
    }
    // Round to the specified precision to avoid floating-point drift
    final rounded = _round(value, precision);
    return Price._(rounded, precision);
  }

  /// Create a Price without validation (for internal use).
  factory Price.unchecked(double value, {int precision = 5}) {
    return Price._(_round(value, precision), precision);
  }

  /// Format price for display with correct decimal places.
  String toDisplayString() => value.toStringAsFixed(precision);

  /// Pip value based on precision.
  /// For 5-decimal pairs (EUR/USD): 1 pip = 0.0001
  /// For 2-decimal pairs (XAU/USD): 1 pip = 0.01
  double get pipSize {
    switch (precision) {
      case 2: return 0.01;
      case 3: return 0.001;
      case 4: return 0.0001;
      case 5: return 0.00001;
      default: return 0.0001;
    }
  }

  Price operator +(Price other) =>
      Price._(value + other.value, precision);
  Price operator -(Price other) =>
      Price._(value - other.value, precision);
  bool operator >(Price other) => value > other.value;
  bool operator <(Price other) => value < other.value;
  bool operator >=(Price other) => value >= other.value;
  bool operator <=(Price other) => value <= other.value;

  static double _round(double v, int p) =>
      double.parse(v.toStringAsFixed(p));

  @override
  List<Object?> get props => [value, precision];

  @override
  String toString() => toDisplayString();
}

// ============================================================
// 3.1.3.2 — Lots Value Object
// Represents position size in lots (0.01 = 1 micro lot)
// ============================================================

class Lots extends Equatable {
  final double value;

  const Lots._(this.value);

  factory Lots(double value) {
    if (value <= 0) throw ArgumentError('Lots must be positive, got: $value');
    if (value < 0.01) throw ArgumentError('Minimum lot size is 0.01');
    if (value > 1000) throw ArgumentError('Maximum lot size is 1000');
    // Round to 2 decimal places (standard lot precision)
    return Lots._(double.parse(value.toStringAsFixed(2)));
  }

  factory Lots.micro() => const Lots._(0.01);   // 1,000 units
  factory Lots.mini() => const Lots._(0.10);    // 10,000 units
  factory Lots.standard() => const Lots._(1.00); // 100,000 units

  /// Convert lots to OANDA units.
  /// For XAU_USD: 1 lot = 100 oz (OANDA convention)
  /// For FX pairs: 1 lot = 100,000 units of base currency
  double toUnits({double unitsPerLot = 100000}) => value * unitsPerLot;

  String toDisplayString() => value.toStringAsFixed(2);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => toDisplayString();
}

// ============================================================
// 3.1.3.3 — Pips Value Object
// Represents price distance in pips
// ============================================================

class Pips extends Equatable {
  final double value;

  const Pips(this.value);

  factory Pips.fromPriceDelta({
    required double delta,
    required int pipLocation,
  }) {
    // pipLocation is negative: -4 means 1 pip = 0.0001
    final pipSize = _pipSizeFromLocation(pipLocation);
    return Pips(delta / pipSize);
  }

  static double _pipSizeFromLocation(int location) {
    return pow10(-location);
  }

  static double pow10(int exp) {
    double result = 1.0;
    for (int i = 0; i < exp; i++) result *= 10.0;
    return result;
  }

  double toPrice(int pipLocation) =>
      value * _pipSizeFromLocation(pipLocation);

  String toDisplayString({int decimals = 1}) =>
      value.toStringAsFixed(decimals);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => toDisplayString();
}

// ============================================================
// 3.1.3.4 — Money Value Object
// Represents a monetary amount in account currency (USD, EUR, etc.)
// ============================================================

class Money extends Equatable {
  final double amount;
  final String currency;

  const Money._(this.amount, this.currency);

  factory Money(double amount, {String currency = 'USD'}) {
    return Money._(double.parse(amount.toStringAsFixed(2)), currency);
  }

  factory Money.zero({String currency = 'USD'}) =>
      Money._(0.0, currency);

  bool get isPositive => amount > 0;
  bool get isNegative => amount < 0;
  bool get isZero => amount == 0;

  Money operator +(Money other) {
    assert(currency == other.currency, 'Cannot add different currencies');
    return Money(amount + other.amount, currency: currency);
  }

  Money operator -(Money other) {
    assert(currency == other.currency, 'Cannot subtract different currencies');
    return Money(amount - other.amount, currency: currency);
  }

  Money operator *(double factor) =>
      Money(amount * factor, currency: currency);

  bool operator >(Money other) => amount > other.amount;
  bool operator <(Money other) => amount < other.amount;

  /// Format with currency symbol (simplified).
  String toDisplayString({bool showSign = false}) {
    final sign = showSign && amount > 0 ? '+' : '';
    final symbol = _currencySymbol();
    return '$sign$symbol${amount.abs().toStringAsFixed(2)}';
  }

  String _currencySymbol() {
    switch (currency) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'JPY': return '¥';
      default: return '$currency ';
    }
  }

  @override
  List<Object?> get props => [amount, currency];

  @override
  String toString() => toDisplayString();
}

// ============================================================
// 3.1.3.5 — Spread Value Object
// Represents the bid-ask spread
// ============================================================

class Spread extends Equatable {
  /// Spread in pips
  final double pips;

  /// Spread in price units
  final double price;

  const Spread({required this.pips, required this.price});

  factory Spread.fromBidAsk({
    required double bid,
    required double ask,
    required int pipLocation,
  }) {
    final priceSpread = ask - bid;
    final pipSize = Pips._pipSizeFromLocation(-pipLocation);
    return Spread(
      pips: priceSpread / pipSize,
      price: priceSpread,
    );
  }

  String toDisplayString({int decimals = 1}) =>
      pips.toStringAsFixed(decimals);

  @override
  List<Object?> get props => [pips, price];
}
