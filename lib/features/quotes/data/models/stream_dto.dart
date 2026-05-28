// Path: lib/features/quotes/data/models/stream_dto.dart
// ============================================================
// MT5 Clone — OANDA Streaming DTOs
// Models for OANDA's NDJSON (Newline-Delimited JSON) stream.
//
// OANDA Pricing Stream format — each line is a complete JSON object:
//
// Price tick line:
// {"type":"PRICE","time":"1234567890.123456","instrument":"XAU_USD",
//  "tradeable":true,"bids":[{"price":"1950.23","liquidity":10000000}],
//  "asks":[{"price":"1950.45","liquidity":10000000}],
//  "closeoutBid":"1950.23","closeoutAsk":"1950.45",
//  "status":"tradeable"}
//
// Heartbeat line (every 5 seconds):
// {"type":"HEARTBEAT","time":"1234567890.123456"}
//
// Docs: https://developer.oanda.com/rest-live-v20/pricing/
// ============================================================

// ============================================================
// 5.1.1 — Stream Message Types
// ============================================================

/// Discriminator for stream line types
enum StreamMessageType { price, heartbeat, unknown }

/// Base class for all stream messages
abstract class StreamMessageDto {
  final StreamMessageType type;
  final String rawTime;

  const StreamMessageDto({required this.type, required this.rawTime});

  DateTime get dateTime {
    final epochSeconds = double.tryParse(rawTime) ?? 0.0;
    return DateTime.fromMicrosecondsSinceEpoch(
        (epochSeconds * 1000000).round());
  }

  int get timestampUs {
    final epochSeconds = double.tryParse(rawTime) ?? 0.0;
    return (epochSeconds * 1000000).round();
  }

  /// Parse a raw NDJSON line into the appropriate DTO subtype.
  static StreamMessageDto fromJsonLine(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'UNKNOWN';
    return switch (type) {
      'PRICE' => StreamPriceDto.fromJson(json),
      'HEARTBEAT' => StreamHeartbeatDto.fromJson(json),
      _ => StreamUnknownDto(
          rawType: type,
          rawTime: json['time'] as String? ?? '0',
        ),
    };
  }
}

// ============================================================
// 5.1.2 — Price Tick DTO (from stream)
// ============================================================

class StreamPriceDto extends StreamMessageDto {
  final String instrument;
  final bool tradeable;
  final String status;         // "tradeable", "non-tradeable", "invalid"
  final List<StreamBidAskDto> bids;
  final List<StreamBidAskDto> asks;
  final String closeoutBid;
  final String closeoutAsk;

  const StreamPriceDto({
    required super.rawTime,
    required this.instrument,
    required this.tradeable,
    required this.status,
    required this.bids,
    required this.asks,
    required this.closeoutBid,
    required this.closeoutAsk,
  }) : super(type: StreamMessageType.price);

  factory StreamPriceDto.fromJson(Map<String, dynamic> json) {
    // Helper to parse bid/ask bucket arrays
    List<StreamBidAskDto> parseBuckets(dynamic raw) {
      if (raw == null) return [];
      return (raw as List)
          .map((b) => StreamBidAskDto.fromJson(
              Map<String, dynamic>.from(b as Map)))
          .toList();
    }

    return StreamPriceDto(
      rawTime: json['time'] as String? ?? '0',
      instrument: json['instrument'] as String? ?? '',
      tradeable: json['tradeable'] as bool? ?? false,
      status: json['status'] as String? ?? 'non-tradeable',
      bids: parseBuckets(json['bids']),
      asks: parseBuckets(json['asks']),
      closeoutBid: json['closeoutBid'] as String? ?? '0',
      closeoutAsk: json['closeoutAsk'] as String? ?? '0',
    );
  }

  // ── Best Price Accessors ───────────────────────────────────

  /// Best bid (highest bid in bucket list)
  double get bestBid {
    if (bids.isNotEmpty) return bids.first.priceValue;
    return double.tryParse(closeoutBid) ?? 0.0;
  }

  /// Best ask (lowest ask in bucket list)
  double get bestAsk {
    if (asks.isNotEmpty) return asks.first.priceValue;
    return double.tryParse(closeoutAsk) ?? 0.0;
  }

  /// Spread in price units
  double get spread => bestAsk - bestBid;

  /// Whether this tick is tradeable (market open, not in gap)
  bool get isTradeable => tradeable && status == 'tradeable';

  @override
  String toString() =>
      'StreamPrice($instrument bid=$bestBid ask=$bestAsk @ $rawTime)';
}

class StreamBidAskDto {
  final String price;
  final int liquidity;

  const StreamBidAskDto({required this.price, required this.liquidity});

  factory StreamBidAskDto.fromJson(Map<String, dynamic> json) {
    return StreamBidAskDto(
      price: json['price'] as String? ?? '0',
      liquidity: (json['liquidity'] as num?)?.toInt() ?? 0,
    );
  }

  double get priceValue => double.tryParse(price) ?? 0.0;
}

// ============================================================
// 5.1.1 — Heartbeat DTO
// ============================================================

class StreamHeartbeatDto extends StreamMessageDto {
  const StreamHeartbeatDto({required super.rawTime})
      : super(type: StreamMessageType.heartbeat);

  factory StreamHeartbeatDto.fromJson(Map<String, dynamic> json) {
    return StreamHeartbeatDto(
      rawTime: json['time'] as String? ?? '0',
    );
  }

  @override
  String toString() => 'Heartbeat(@ $rawTime)';
}

// ============================================================
// 5.1.3 — Unknown / Passthrough DTO
// ============================================================

class StreamUnknownDto extends StreamMessageDto {
  final String rawType;

  const StreamUnknownDto({
    required this.rawType,
    required super.rawTime,
  }) : super(type: StreamMessageType.unknown);
}

// ============================================================
// 5.1.4 — Stream Connection State
// ============================================================

enum StreamConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
  killed, // killed by auto-kill-switch
}

extension StreamConnectionStateX on StreamConnectionState {
  bool get isActive =>
      this == StreamConnectionState.connected ||
      this == StreamConnectionState.reconnecting;

  bool get isConnected => this == StreamConnectionState.connected;

  String get displayName => switch (this) {
        StreamConnectionState.disconnected => 'Disconnected',
        StreamConnectionState.connecting => 'Connecting...',
        StreamConnectionState.connected => 'Connected',
        StreamConnectionState.reconnecting => 'Reconnecting...',
        StreamConnectionState.error => 'Connection Error',
        StreamConnectionState.killed => 'Stream Killed',
      };
}
