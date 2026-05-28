// Path: lib/features/quotes/data/datasources/stream_parser.dart
// ============================================================
// MT5 Clone — OANDA NDJSON Stream Parser
// Converts raw HTTP chunked response bytes into typed stream DTOs.
//
// OANDA streams NDJSON — each newline-delimited chunk is a
// complete JSON object representing either a price tick or heartbeat.
//
// Challenges handled:
//   - Chunks may split mid-JSON (buffer incomplete lines)
//   - Chunks may contain multiple lines (split and process each)
//   - Malformed JSON lines are silently skipped with error logging
//   - UTF-8 decoding errors are handled gracefully
// ============================================================

import 'dart:async';
import 'dart:convert';

import 'package:logger/logger.dart';

import '../../../../core/domain/entities/tick_entity.dart';
import '../models/stream_dto.dart';

class OandaStreamParser {
  final Logger _log = Logger();

  // Buffer for incomplete line fragments between chunks
  final StringBuffer _lineBuffer = StringBuffer();

  // ============================================================
  // 5.2.1 — Transform Stream: Bytes → StreamMessageDto
  // ============================================================

  /// Transforms a raw byte stream (chunked HTTP response) into
  /// a stream of typed StreamMessageDto objects.
  ///
  /// Usage:
  ///   final parser = OandaStreamParser();
  ///   final tickStream = rawByteStream.transform(parser.transformer);
  StreamTransformer<List<int>, StreamMessageDto> get transformer {
    return StreamTransformer.fromHandlers(
      handleData: _handleChunk,
      handleError: _handleError,
      handleDone: _handleDone,
    );
  }

  // ============================================================
  // 5.2.2 — Chunk Handler
  // Processes each incoming byte chunk from the HTTP stream.
  // ============================================================

  void _handleChunk(
    List<int> chunk,
    EventSink<StreamMessageDto> sink,
  ) {
    String text;
    try {
      // Decode bytes to UTF-8 string
      text = utf8.decode(chunk, allowMalformed: true);
    } catch (e) {
      _log.w('StreamParser: UTF-8 decode error, skipping chunk: $e');
      return;
    }

    // Append to buffer (handles split chunks)
    _lineBuffer.write(text);

    // Process all complete lines (delimited by '\n')
    final buffered = _lineBuffer.toString();
    final lines = buffered.split('\n');

    // The last element may be an incomplete line — keep in buffer
    _lineBuffer.clear();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (i == lines.length - 1 && !buffered.endsWith('\n')) {
        // Last fragment — incomplete line, buffer it
        _lineBuffer.write(lines[i]);
        break;
      }

      if (line.isEmpty) continue;

      // Parse and emit the complete JSON line
      final dto = _parseLine(line);
      if (dto != null) sink.add(dto);
    }
  }

  // ============================================================
  // 5.2.3 — Single Line Parser
  // ============================================================

  StreamMessageDto? _parseLine(String line) {
    try {
      final json = jsonDecode(line) as Map<String, dynamic>;
      return StreamMessageDto.fromJsonLine(json);
    } on FormatException catch (e) {
      _log.w('StreamParser: Invalid JSON line: $e\nLine: '
          '${line.length > 200 ? line.substring(0, 200) : line}');
      return null;
    } catch (e) {
      _log.e('StreamParser: Unexpected error parsing line: $e');
      return null;
    }
  }

  // ============================================================
  // 5.2.4 — Error & Done Handlers
  // ============================================================

  void _handleError(
    Object error,
    StackTrace stackTrace,
    EventSink<StreamMessageDto> sink,
  ) {
    _log.e('StreamParser: Stream error', error: error, stackTrace: stackTrace);
    sink.addError(error, stackTrace);
  }

  void _handleDone(EventSink<StreamMessageDto> sink) {
    // Flush any remaining buffered content
    final remaining = _lineBuffer.toString().trim();
    if (remaining.isNotEmpty) {
      final dto = _parseLine(remaining);
      if (dto != null) sink.add(dto);
    }
    _lineBuffer.clear();
    sink.close();
  }

  /// Reset the internal buffer (call before reconnect).
  void reset() => _lineBuffer.clear();
}

// ============================================================
// 5.2.5 — Tick Assembler: StreamPriceDto → TickEntity
// ============================================================

class TickAssembler {
  /// Symbol metadata cache: symbol → pipLocation
  /// Populated when instruments are loaded.
  final Map<String, int> _pipLocations;

  const TickAssembler({Map<String, int>? pipLocations})
      : _pipLocations = pipLocations ?? const {};

  /// Convert a raw StreamPriceDto to a domain TickEntity.
  TickEntity assemble(StreamPriceDto dto) {
    final bid = dto.bestBid;
    final ask = dto.bestAsk;
    final spread = ask - bid;

    return TickEntity(
      symbol: dto.instrument,
      bid: bid,
      ask: ask,
      spread: spread,
      timestamp: dto.dateTime,
    );
  }

  /// Update pip location for a symbol (called when instruments load).
  void updatePipLocation(String symbol, int pipLocation) {
    (_pipLocations as Map<String, int>)[symbol] = pipLocation;
  }
}
