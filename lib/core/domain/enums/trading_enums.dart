// Path: lib/core/domain/enums/trading_enums.dart
// ============================================================
// MT5 Clone — Trading Enums
// All domain-level enumerations used across the app.
// ============================================================

// ============================================================
// Trade Direction
// ============================================================

enum TradeDirection {
  buy,
  sell;

  bool get isBuy => this == TradeDirection.buy;
  bool get isSell => this == TradeDirection.sell;

  String get displayName => isBuy ? 'BUY' : 'SELL';
  String get shortName => isBuy ? 'B' : 'S';
  String get oandaValue => isBuy ? '1' : '-1';

  static TradeDirection fromString(String value) {
    switch (value.toUpperCase()) {
      case 'BUY':
      case 'LONG':
      case 'B':
        return TradeDirection.buy;
      case 'SELL':
      case 'SHORT':
      case 'S':
        return TradeDirection.sell;
      default:
        throw ArgumentError('Unknown trade direction: $value');
    }
  }
}

// ============================================================
// Order Type
// ============================================================

enum OrderType {
  market,
  buyLimit,
  sellLimit,
  buyStop,
  sellStop,
  buyStopLimit,
  sellStopLimit;

  String get displayName => switch (this) {
        OrderType.market => 'Market',
        OrderType.buyLimit => 'Buy Limit',
        OrderType.sellLimit => 'Sell Limit',
        OrderType.buyStop => 'Buy Stop',
        OrderType.sellStop => 'Sell Stop',
        OrderType.buyStopLimit => 'Buy Stop Limit',
        OrderType.sellStopLimit => 'Sell Stop Limit',
      };

  String get shortName => switch (this) {
        OrderType.market => 'MKT',
        OrderType.buyLimit => 'BL',
        OrderType.sellLimit => 'SL',
        OrderType.buyStop => 'BS',
        OrderType.sellStop => 'SS',
        OrderType.buyStopLimit => 'BSL',
        OrderType.sellStopLimit => 'SSL',
      };

  bool get isBuy => switch (this) {
        OrderType.market => true,
        OrderType.buyLimit => true,
        OrderType.sellLimit => false,
        OrderType.buyStop => true,
        OrderType.sellStop => false,
        OrderType.buyStopLimit => true,
        OrderType.sellStopLimit => false,
      };

  bool get isPending => this != OrderType.market;

  TradeDirection get direction =>
      isBuy ? TradeDirection.buy : TradeDirection.sell;

  String get oandaName => switch (this) {
        OrderType.market => 'MARKET',
        OrderType.buyLimit || OrderType.sellLimit => 'LIMIT_ORDER',
        OrderType.buyStop || OrderType.sellStop => 'STOP_ORDER',
        OrderType.buyStopLimit || OrderType.sellStopLimit =>
          'MARKET_IF_TOUCHED_ORDER',
      };

  static OrderType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'MARKET':
        return OrderType.market;
      case 'BUY_LIMIT':
        return OrderType.buyLimit;
      case 'SELL_LIMIT':
        return OrderType.sellLimit;
      case 'BUY_STOP':
        return OrderType.buyStop;
      case 'SELL_STOP':
        return OrderType.sellStop;
      case 'BUY_STOP_LIMIT':
        return OrderType.buyStopLimit;
      case 'SELL_STOP_LIMIT':
        return OrderType.sellStopLimit;
      case 'LIMIT':
        return OrderType.buyLimit;
      case 'STOP':
        return OrderType.buyStop;
      case 'STOP_LOSS':
      case 'STOP_LIMIT':
        return OrderType.buyStopLimit;
      default:
        return OrderType.market;
    }
  }
}

// ============================================================
// Order Status
// ============================================================

enum OrderStatus {
  pending,
  filled,
  cancelled,
  expired,
  rejected;

  String get displayName => switch (this) {
        OrderStatus.pending => 'Pending',
        OrderStatus.filled => 'Filled',
        OrderStatus.cancelled => 'Cancelled',
        OrderStatus.expired => 'Expired',
        OrderStatus.rejected => 'Rejected',
      };

  static OrderStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return OrderStatus.pending;
      case 'FILLED':
        return OrderStatus.filled;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'EXPIRED':
        return OrderStatus.expired;
      case 'REJECTED':
        return OrderStatus.rejected;
      default:
        return OrderStatus.pending;
    }
  }
}

// ============================================================
// Timeframe
// ============================================================

enum Timeframe {
  m1,
  m5,
  m10,
  m15,
  m30,
  h1,
  h2,
  h4,
  h6,
  h8,
  h12,
  d1,
  w1,
  mn;

  String get displayName => switch (this) {
        Timeframe.m1 => 'M1',
        Timeframe.m5 => 'M5',
        Timeframe.m10 => 'M10',
        Timeframe.m15 => 'M15',
        Timeframe.m30 => 'M30',
        Timeframe.h1 => 'H1',
        Timeframe.h2 => 'H2',
        Timeframe.h4 => 'H4',
        Timeframe.h6 => 'H6',
        Timeframe.h8 => 'H8',
        Timeframe.h12 => 'H12',
        Timeframe.d1 => 'D1',
        Timeframe.w1 => 'W1',
        Timeframe.mn => 'MN',
      };

  String get oandaName => switch (this) {
        Timeframe.m1 => 'M1',
        Timeframe.m5 => 'M5',
        Timeframe.m10 => 'M10',
        Timeframe.m15 => 'M15',
        Timeframe.m30 => 'M30',
        Timeframe.h1 => 'H1',
        Timeframe.h2 => 'H2',
        Timeframe.h4 => 'H4',
        Timeframe.h6 => 'H6',
        Timeframe.h8 => 'H8',
        Timeframe.h12 => 'H12',
        Timeframe.d1 => 'D',
        Timeframe.w1 => 'W',
        Timeframe.mn => 'M',
      };

  Duration get duration => switch (this) {
        Timeframe.m1 => const Duration(minutes: 1),
        Timeframe.m5 => const Duration(minutes: 5),
        Timeframe.m10 => const Duration(minutes: 10),
        Timeframe.m15 => const Duration(minutes: 15),
        Timeframe.m30 => const Duration(minutes: 30),
        Timeframe.h1 => const Duration(hours: 1),
        Timeframe.h2 => const Duration(hours: 2),
        Timeframe.h4 => const Duration(hours: 4),
        Timeframe.h6 => const Duration(hours: 6),
        Timeframe.h8 => const Duration(hours: 8),
        Timeframe.h12 => const Duration(hours: 12),
        Timeframe.d1 => const Duration(days: 1),
        Timeframe.w1 => const Duration(days: 7),
        Timeframe.mn => const Duration(days: 30),
      };

  int get defaultFetchCount => switch (this) {
        Timeframe.m1 => 500,
        Timeframe.m5 => 500,
        Timeframe.m10 => 300,
        Timeframe.m15 => 300,
        Timeframe.m30 => 200,
        Timeframe.h1 => 200,
        Timeframe.h2 => 150,
        Timeframe.h4 => 150,
        Timeframe.h6 => 100,
        Timeframe.h8 => 100,
        Timeframe.h12 => 100,
        Timeframe.d1 => 100,
        Timeframe.w1 => 52,
        Timeframe.mn => 24,
      };

  static Timeframe fromString(String value) {
    switch (value.toUpperCase()) {
      case 'M1': return Timeframe.m1;
      case 'M5': return Timeframe.m5;
      case 'M10': return Timeframe.m10;
      case 'M15': return Timeframe.m15;
      case 'M30': return Timeframe.m30;
      case 'H1': return Timeframe.h1;
      case 'H2': return Timeframe.h2;
      case 'H4': return Timeframe.h4;
      case 'H6': return Timeframe.h6;
      case 'H8': return Timeframe.h8;
      case 'H12': return Timeframe.h12;
      case 'D': case 'D1': return Timeframe.d1;
      case 'W': case 'W1': return Timeframe.w1;
      case 'M': case 'MN': return Timeframe.mn;
      default: return Timeframe.h1;
    }
  }
}

// ============================================================
// Close Reason
// ============================================================

enum CloseReason {
  manual,
  stopLoss,
  takeProfit,
  marginCall,
  eaClose,
  brokerClose;

  String get displayName => switch (this) {
        CloseReason.manual => 'Manual',
        CloseReason.stopLoss => 'Stop Loss',
        CloseReason.takeProfit => 'Take Profit',
        CloseReason.marginCall => 'Margin Call',
        CloseReason.eaClose => 'EA Close',
        CloseReason.brokerClose => 'Broker Close',
      };

  static CloseReason fromString(String value) {
    switch (value.toUpperCase()) {
      case 'MANUAL': return CloseReason.manual;
      case 'STOP_LOSS': return CloseReason.stopLoss;
      case 'TAKE_PROFIT': return CloseReason.takeProfit;
      case 'MARGIN_CALL': return CloseReason.marginCall;
      case 'EA_CLOSE': return CloseReason.eaClose;
      case 'BROKER_CLOSE': return CloseReason.brokerClose;
      default: return CloseReason.manual;
    }
  }
}

// ============================================================
// EA Status
// ============================================================

enum EaStatus {
  stopped,
  running,
  paused,
  error;

  String get displayName => switch (this) {
        EaStatus.stopped => 'Stopped',
        EaStatus.running => 'Running',
        EaStatus.paused => 'Paused',
        EaStatus.error => 'Error',
      };

  static EaStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'STOPPED': return EaStatus.stopped;
      case 'RUNNING': return EaStatus.running;
      case 'PAUSED': return EaStatus.paused;
      case 'ERROR': return EaStatus.error;
      default: return EaStatus.stopped;
    }
  }
}

// ============================================================
// Instrument Type
// ============================================================

enum InstrumentType {
  currency,
  metal,
  indices,
  commodity,
  crypto;

  String get displayName => switch (this) {
        InstrumentType.currency => 'Currency',
        InstrumentType.metal => 'Metal',
        InstrumentType.indices => 'Index',
        InstrumentType.commodity => 'Commodity',
        InstrumentType.crypto => 'Crypto',
      };

  static InstrumentType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CURRENCY': return InstrumentType.currency;
      case 'METAL': return InstrumentType.metal;
      case 'INDEX': return InstrumentType.indices;
      case 'COMMODITY': return InstrumentType.commodity;
      case 'CRYPTO': return InstrumentType.crypto;
      default: return InstrumentType.currency;
    }
  }
}

// ============================================================
// Quote View Mode
// ============================================================

enum QuoteViewMode {
  simple,
  advanced;

  String get displayName => switch (this) {
        QuoteViewMode.simple => 'Simple',
        QuoteViewMode.advanced => 'Advanced',
      };
}

// ============================================================
// Connectivity Status
// ============================================================

enum ConnectivityStatus {
  online,
  offline,
  unknown;
}
