// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TicksTable extends Ticks with TableInfo<$TicksTable, Tick> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _bidMeta = const VerificationMeta('bid');
  @override
  late final GeneratedColumn<double> bid = GeneratedColumn<double>(
      'bid', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _askMeta = const VerificationMeta('ask');
  @override
  late final GeneratedColumn<double> ask = GeneratedColumn<double>(
      'ask', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _spreadMeta = const VerificationMeta('spread');
  @override
  late final GeneratedColumn<double> spread = GeneratedColumn<double>(
      'spread', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timestampUsMeta =
      const VerificationMeta('timestampUs');
  @override
  late final GeneratedColumn<int> timestampUs = GeneratedColumn<int>(
      'timestamp_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sessionHighMeta =
      const VerificationMeta('sessionHigh');
  @override
  late final GeneratedColumn<double> sessionHigh = GeneratedColumn<double>(
      'session_high', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sessionLowMeta =
      const VerificationMeta('sessionLow');
  @override
  late final GeneratedColumn<double> sessionLow = GeneratedColumn<double>(
      'session_low', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, symbol, bid, ask, spread, timestampUs, sessionHigh, sessionLow];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ticks';
  @override
  VerificationContext validateIntegrity(Insertable<Tick> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('bid')) {
      context.handle(
          _bidMeta, bid.isAcceptableOrUnknown(data['bid']!, _bidMeta));
    } else if (isInserting) {
      context.missing(_bidMeta);
    }
    if (data.containsKey('ask')) {
      context.handle(
          _askMeta, ask.isAcceptableOrUnknown(data['ask']!, _askMeta));
    } else if (isInserting) {
      context.missing(_askMeta);
    }
    if (data.containsKey('spread')) {
      context.handle(_spreadMeta,
          spread.isAcceptableOrUnknown(data['spread']!, _spreadMeta));
    } else if (isInserting) {
      context.missing(_spreadMeta);
    }
    if (data.containsKey('timestamp_us')) {
      context.handle(
          _timestampUsMeta,
          timestampUs.isAcceptableOrUnknown(
              data['timestamp_us']!, _timestampUsMeta));
    } else if (isInserting) {
      context.missing(_timestampUsMeta);
    }
    if (data.containsKey('session_high')) {
      context.handle(
          _sessionHighMeta,
          sessionHigh.isAcceptableOrUnknown(
              data['session_high']!, _sessionHighMeta));
    }
    if (data.containsKey('session_low')) {
      context.handle(
          _sessionLowMeta,
          sessionLow.isAcceptableOrUnknown(
              data['session_low']!, _sessionLowMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {symbol, timestampUs},
      ];
  @override
  Tick map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tick(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      bid: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bid'])!,
      ask: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ask'])!,
      spread: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}spread'])!,
      timestampUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp_us'])!,
      sessionHigh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}session_high']),
      sessionLow: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}session_low']),
    );
  }

  @override
  $TicksTable createAlias(String alias) {
    return $TicksTable(attachedDatabase, alias);
  }
}

class Tick extends DataClass implements Insertable<Tick> {
  final int id;
  final String symbol;
  final double bid;
  final double ask;
  final double spread;
  final int timestampUs;
  final double? sessionHigh;
  final double? sessionLow;
  const Tick(
      {required this.id,
      required this.symbol,
      required this.bid,
      required this.ask,
      required this.spread,
      required this.timestampUs,
      this.sessionHigh,
      this.sessionLow});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['bid'] = Variable<double>(bid);
    map['ask'] = Variable<double>(ask);
    map['spread'] = Variable<double>(spread);
    map['timestamp_us'] = Variable<int>(timestampUs);
    if (!nullToAbsent || sessionHigh != null) {
      map['session_high'] = Variable<double>(sessionHigh);
    }
    if (!nullToAbsent || sessionLow != null) {
      map['session_low'] = Variable<double>(sessionLow);
    }
    return map;
  }

  TicksCompanion toCompanion(bool nullToAbsent) {
    return TicksCompanion(
      id: Value(id),
      symbol: Value(symbol),
      bid: Value(bid),
      ask: Value(ask),
      spread: Value(spread),
      timestampUs: Value(timestampUs),
      sessionHigh: sessionHigh == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionHigh),
      sessionLow: sessionLow == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionLow),
    );
  }

  factory Tick.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tick(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      bid: serializer.fromJson<double>(json['bid']),
      ask: serializer.fromJson<double>(json['ask']),
      spread: serializer.fromJson<double>(json['spread']),
      timestampUs: serializer.fromJson<int>(json['timestampUs']),
      sessionHigh: serializer.fromJson<double?>(json['sessionHigh']),
      sessionLow: serializer.fromJson<double?>(json['sessionLow']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'bid': serializer.toJson<double>(bid),
      'ask': serializer.toJson<double>(ask),
      'spread': serializer.toJson<double>(spread),
      'timestampUs': serializer.toJson<int>(timestampUs),
      'sessionHigh': serializer.toJson<double?>(sessionHigh),
      'sessionLow': serializer.toJson<double?>(sessionLow),
    };
  }

  Tick copyWith(
          {int? id,
          String? symbol,
          double? bid,
          double? ask,
          double? spread,
          int? timestampUs,
          Value<double?> sessionHigh = const Value.absent(),
          Value<double?> sessionLow = const Value.absent()}) =>
      Tick(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        bid: bid ?? this.bid,
        ask: ask ?? this.ask,
        spread: spread ?? this.spread,
        timestampUs: timestampUs ?? this.timestampUs,
        sessionHigh: sessionHigh.present ? sessionHigh.value : this.sessionHigh,
        sessionLow: sessionLow.present ? sessionLow.value : this.sessionLow,
      );
  Tick copyWithCompanion(TicksCompanion data) {
    return Tick(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      bid: data.bid.present ? data.bid.value : this.bid,
      ask: data.ask.present ? data.ask.value : this.ask,
      spread: data.spread.present ? data.spread.value : this.spread,
      timestampUs:
          data.timestampUs.present ? data.timestampUs.value : this.timestampUs,
      sessionHigh:
          data.sessionHigh.present ? data.sessionHigh.value : this.sessionHigh,
      sessionLow:
          data.sessionLow.present ? data.sessionLow.value : this.sessionLow,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tick(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('bid: $bid, ')
          ..write('ask: $ask, ')
          ..write('spread: $spread, ')
          ..write('timestampUs: $timestampUs, ')
          ..write('sessionHigh: $sessionHigh, ')
          ..write('sessionLow: $sessionLow')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, symbol, bid, ask, spread, timestampUs, sessionHigh, sessionLow);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tick &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.bid == this.bid &&
          other.ask == this.ask &&
          other.spread == this.spread &&
          other.timestampUs == this.timestampUs &&
          other.sessionHigh == this.sessionHigh &&
          other.sessionLow == this.sessionLow);
}

class TicksCompanion extends UpdateCompanion<Tick> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<double> bid;
  final Value<double> ask;
  final Value<double> spread;
  final Value<int> timestampUs;
  final Value<double?> sessionHigh;
  final Value<double?> sessionLow;
  const TicksCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.bid = const Value.absent(),
    this.ask = const Value.absent(),
    this.spread = const Value.absent(),
    this.timestampUs = const Value.absent(),
    this.sessionHigh = const Value.absent(),
    this.sessionLow = const Value.absent(),
  });
  TicksCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required double bid,
    required double ask,
    required double spread,
    required int timestampUs,
    this.sessionHigh = const Value.absent(),
    this.sessionLow = const Value.absent(),
  })  : symbol = Value(symbol),
        bid = Value(bid),
        ask = Value(ask),
        spread = Value(spread),
        timestampUs = Value(timestampUs);
  static Insertable<Tick> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<double>? bid,
    Expression<double>? ask,
    Expression<double>? spread,
    Expression<int>? timestampUs,
    Expression<double>? sessionHigh,
    Expression<double>? sessionLow,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (bid != null) 'bid': bid,
      if (ask != null) 'ask': ask,
      if (spread != null) 'spread': spread,
      if (timestampUs != null) 'timestamp_us': timestampUs,
      if (sessionHigh != null) 'session_high': sessionHigh,
      if (sessionLow != null) 'session_low': sessionLow,
    });
  }

  TicksCompanion copyWith(
      {Value<int>? id,
      Value<String>? symbol,
      Value<double>? bid,
      Value<double>? ask,
      Value<double>? spread,
      Value<int>? timestampUs,
      Value<double?>? sessionHigh,
      Value<double?>? sessionLow}) {
    return TicksCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      bid: bid ?? this.bid,
      ask: ask ?? this.ask,
      spread: spread ?? this.spread,
      timestampUs: timestampUs ?? this.timestampUs,
      sessionHigh: sessionHigh ?? this.sessionHigh,
      sessionLow: sessionLow ?? this.sessionLow,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (bid.present) {
      map['bid'] = Variable<double>(bid.value);
    }
    if (ask.present) {
      map['ask'] = Variable<double>(ask.value);
    }
    if (spread.present) {
      map['spread'] = Variable<double>(spread.value);
    }
    if (timestampUs.present) {
      map['timestamp_us'] = Variable<int>(timestampUs.value);
    }
    if (sessionHigh.present) {
      map['session_high'] = Variable<double>(sessionHigh.value);
    }
    if (sessionLow.present) {
      map['session_low'] = Variable<double>(sessionLow.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicksCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('bid: $bid, ')
          ..write('ask: $ask, ')
          ..write('spread: $spread, ')
          ..write('timestampUs: $timestampUs, ')
          ..write('sessionHigh: $sessionHigh, ')
          ..write('sessionLow: $sessionLow')
          ..write(')'))
        .toString();
  }
}

class $SymbolsTable extends Symbols with TableInfo<$SymbolsTable, Symbol> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymbolsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _displayExPrecisionMeta =
      const VerificationMeta('displayExPrecision');
  @override
  late final GeneratedColumn<String> displayExPrecision =
      GeneratedColumn<String>('display_ex_precision', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _pipSizeMeta =
      const VerificationMeta('pipSize');
  @override
  late final GeneratedColumn<double> pipSize = GeneratedColumn<double>(
      'pip_size', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _pipLocationMeta =
      const VerificationMeta('pipLocation');
  @override
  late final GeneratedColumn<int> pipLocation = GeneratedColumn<int>(
      'pip_location', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitsPerLotMeta =
      const VerificationMeta('unitsPerLot');
  @override
  late final GeneratedColumn<double> unitsPerLot = GeneratedColumn<double>(
      'units_per_lot', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(100000));
  static const VerificationMeta _displayPrecisionMeta =
      const VerificationMeta('displayPrecision');
  @override
  late final GeneratedColumn<int> displayPrecision = GeneratedColumn<int>(
      'display_precision', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _marginRateMeta =
      const VerificationMeta('marginRate');
  @override
  late final GeneratedColumn<double> marginRate = GeneratedColumn<double>(
      'margin_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _minimumTradeSizeMeta =
      const VerificationMeta('minimumTradeSize');
  @override
  late final GeneratedColumn<double> minimumTradeSize = GeneratedColumn<double>(
      'minimum_trade_size', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _minLotMeta = const VerificationMeta('minLot');
  @override
  late final GeneratedColumn<double> minLot = GeneratedColumn<double>(
      'min_lot', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.01));
  static const VerificationMeta _maxLotMeta = const VerificationMeta('maxLot');
  @override
  late final GeneratedColumn<double> maxLot = GeneratedColumn<double>(
      'max_lot', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(100.0));
  static const VerificationMeta _lotStepMeta =
      const VerificationMeta('lotStep');
  @override
  late final GeneratedColumn<double> lotStep = GeneratedColumn<double>(
      'lot_step', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.01));
  static const VerificationMeta _tradeUnitsPrecisionMeta =
      const VerificationMeta('tradeUnitsPrecision');
  @override
  late final GeneratedColumn<double> tradeUnitsPrecision =
      GeneratedColumn<double>('trade_units_precision', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _isWatchlistedMeta =
      const VerificationMeta('isWatchlisted');
  @override
  late final GeneratedColumn<bool> isWatchlisted = GeneratedColumn<bool>(
      'is_watchlisted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_watchlisted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _watchlistSortOrderMeta =
      const VerificationMeta('watchlistSortOrder');
  @override
  late final GeneratedColumn<int> watchlistSortOrder = GeneratedColumn<int>(
      'watchlist_sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(999));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastUpdatedUsMeta =
      const VerificationMeta('lastUpdatedUs');
  @override
  late final GeneratedColumn<int> lastUpdatedUs = GeneratedColumn<int>(
      'last_updated_us', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        name,
        displayName,
        displayExPrecision,
        type,
        pipSize,
        pipLocation,
        unitsPerLot,
        displayPrecision,
        marginRate,
        minimumTradeSize,
        minLot,
        maxLot,
        lotStep,
        tradeUnitsPrecision,
        isWatchlisted,
        watchlistSortOrder,
        sortOrder,
        lastUpdatedUs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symbols';
  @override
  VerificationContext validateIntegrity(Insertable<Symbol> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('display_ex_precision')) {
      context.handle(
          _displayExPrecisionMeta,
          displayExPrecision.isAcceptableOrUnknown(
              data['display_ex_precision']!, _displayExPrecisionMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('pip_size')) {
      context.handle(_pipSizeMeta,
          pipSize.isAcceptableOrUnknown(data['pip_size']!, _pipSizeMeta));
    } else if (isInserting) {
      context.missing(_pipSizeMeta);
    }
    if (data.containsKey('pip_location')) {
      context.handle(
          _pipLocationMeta,
          pipLocation.isAcceptableOrUnknown(
              data['pip_location']!, _pipLocationMeta));
    } else if (isInserting) {
      context.missing(_pipLocationMeta);
    }
    if (data.containsKey('units_per_lot')) {
      context.handle(
          _unitsPerLotMeta,
          unitsPerLot.isAcceptableOrUnknown(
              data['units_per_lot']!, _unitsPerLotMeta));
    }
    if (data.containsKey('display_precision')) {
      context.handle(
          _displayPrecisionMeta,
          displayPrecision.isAcceptableOrUnknown(
              data['display_precision']!, _displayPrecisionMeta));
    }
    if (data.containsKey('margin_rate')) {
      context.handle(
          _marginRateMeta,
          marginRate.isAcceptableOrUnknown(
              data['margin_rate']!, _marginRateMeta));
    }
    if (data.containsKey('minimum_trade_size')) {
      context.handle(
          _minimumTradeSizeMeta,
          minimumTradeSize.isAcceptableOrUnknown(
              data['minimum_trade_size']!, _minimumTradeSizeMeta));
    }
    if (data.containsKey('min_lot')) {
      context.handle(_minLotMeta,
          minLot.isAcceptableOrUnknown(data['min_lot']!, _minLotMeta));
    }
    if (data.containsKey('max_lot')) {
      context.handle(_maxLotMeta,
          maxLot.isAcceptableOrUnknown(data['max_lot']!, _maxLotMeta));
    }
    if (data.containsKey('lot_step')) {
      context.handle(_lotStepMeta,
          lotStep.isAcceptableOrUnknown(data['lot_step']!, _lotStepMeta));
    }
    if (data.containsKey('trade_units_precision')) {
      context.handle(
          _tradeUnitsPrecisionMeta,
          tradeUnitsPrecision.isAcceptableOrUnknown(
              data['trade_units_precision']!, _tradeUnitsPrecisionMeta));
    }
    if (data.containsKey('is_watchlisted')) {
      context.handle(
          _isWatchlistedMeta,
          isWatchlisted.isAcceptableOrUnknown(
              data['is_watchlisted']!, _isWatchlistedMeta));
    }
    if (data.containsKey('watchlist_sort_order')) {
      context.handle(
          _watchlistSortOrderMeta,
          watchlistSortOrder.isAcceptableOrUnknown(
              data['watchlist_sort_order']!, _watchlistSortOrderMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('last_updated_us')) {
      context.handle(
          _lastUpdatedUsMeta,
          lastUpdatedUs.isAcceptableOrUnknown(
              data['last_updated_us']!, _lastUpdatedUsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Symbol map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Symbol(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      displayExPrecision: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}display_ex_precision']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      pipSize: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}pip_size'])!,
      pipLocation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pip_location'])!,
      unitsPerLot: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}units_per_lot'])!,
      displayPrecision: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_precision'])!,
      marginRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}margin_rate']),
      minimumTradeSize: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}minimum_trade_size']),
      minLot: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_lot'])!,
      maxLot: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_lot'])!,
      lotStep: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lot_step'])!,
      tradeUnitsPrecision: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}trade_units_precision'])!,
      isWatchlisted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_watchlisted'])!,
      watchlistSortOrder: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}watchlist_sort_order'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      lastUpdatedUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_updated_us'])!,
    );
  }

  @override
  $SymbolsTable createAlias(String alias) {
    return $SymbolsTable(attachedDatabase, alias);
  }
}

class Symbol extends DataClass implements Insertable<Symbol> {
  final String name;
  final String displayName;
  final String? displayExPrecision;
  final String type;
  final double pipSize;
  final int pipLocation;
  final double unitsPerLot;
  final int displayPrecision;
  final double? marginRate;
  final double? minimumTradeSize;
  final double minLot;
  final double maxLot;
  final double lotStep;
  final double tradeUnitsPrecision;
  final bool isWatchlisted;
  final int watchlistSortOrder;
  final int sortOrder;
  final int lastUpdatedUs;
  const Symbol(
      {required this.name,
      required this.displayName,
      this.displayExPrecision,
      required this.type,
      required this.pipSize,
      required this.pipLocation,
      required this.unitsPerLot,
      required this.displayPrecision,
      this.marginRate,
      this.minimumTradeSize,
      required this.minLot,
      required this.maxLot,
      required this.lotStep,
      required this.tradeUnitsPrecision,
      required this.isWatchlisted,
      required this.watchlistSortOrder,
      required this.sortOrder,
      required this.lastUpdatedUs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || displayExPrecision != null) {
      map['display_ex_precision'] = Variable<String>(displayExPrecision);
    }
    map['type'] = Variable<String>(type);
    map['pip_size'] = Variable<double>(pipSize);
    map['pip_location'] = Variable<int>(pipLocation);
    map['units_per_lot'] = Variable<double>(unitsPerLot);
    map['display_precision'] = Variable<int>(displayPrecision);
    if (!nullToAbsent || marginRate != null) {
      map['margin_rate'] = Variable<double>(marginRate);
    }
    if (!nullToAbsent || minimumTradeSize != null) {
      map['minimum_trade_size'] = Variable<double>(minimumTradeSize);
    }
    map['min_lot'] = Variable<double>(minLot);
    map['max_lot'] = Variable<double>(maxLot);
    map['lot_step'] = Variable<double>(lotStep);
    map['trade_units_precision'] = Variable<double>(tradeUnitsPrecision);
    map['is_watchlisted'] = Variable<bool>(isWatchlisted);
    map['watchlist_sort_order'] = Variable<int>(watchlistSortOrder);
    map['sort_order'] = Variable<int>(sortOrder);
    map['last_updated_us'] = Variable<int>(lastUpdatedUs);
    return map;
  }

  SymbolsCompanion toCompanion(bool nullToAbsent) {
    return SymbolsCompanion(
      name: Value(name),
      displayName: Value(displayName),
      displayExPrecision: displayExPrecision == null && nullToAbsent
          ? const Value.absent()
          : Value(displayExPrecision),
      type: Value(type),
      pipSize: Value(pipSize),
      pipLocation: Value(pipLocation),
      unitsPerLot: Value(unitsPerLot),
      displayPrecision: Value(displayPrecision),
      marginRate: marginRate == null && nullToAbsent
          ? const Value.absent()
          : Value(marginRate),
      minimumTradeSize: minimumTradeSize == null && nullToAbsent
          ? const Value.absent()
          : Value(minimumTradeSize),
      minLot: Value(minLot),
      maxLot: Value(maxLot),
      lotStep: Value(lotStep),
      tradeUnitsPrecision: Value(tradeUnitsPrecision),
      isWatchlisted: Value(isWatchlisted),
      watchlistSortOrder: Value(watchlistSortOrder),
      sortOrder: Value(sortOrder),
      lastUpdatedUs: Value(lastUpdatedUs),
    );
  }

  factory Symbol.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Symbol(
      name: serializer.fromJson<String>(json['name']),
      displayName: serializer.fromJson<String>(json['displayName']),
      displayExPrecision:
          serializer.fromJson<String?>(json['displayExPrecision']),
      type: serializer.fromJson<String>(json['type']),
      pipSize: serializer.fromJson<double>(json['pipSize']),
      pipLocation: serializer.fromJson<int>(json['pipLocation']),
      unitsPerLot: serializer.fromJson<double>(json['unitsPerLot']),
      displayPrecision: serializer.fromJson<int>(json['displayPrecision']),
      marginRate: serializer.fromJson<double?>(json['marginRate']),
      minimumTradeSize: serializer.fromJson<double?>(json['minimumTradeSize']),
      minLot: serializer.fromJson<double>(json['minLot']),
      maxLot: serializer.fromJson<double>(json['maxLot']),
      lotStep: serializer.fromJson<double>(json['lotStep']),
      tradeUnitsPrecision:
          serializer.fromJson<double>(json['tradeUnitsPrecision']),
      isWatchlisted: serializer.fromJson<bool>(json['isWatchlisted']),
      watchlistSortOrder: serializer.fromJson<int>(json['watchlistSortOrder']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      lastUpdatedUs: serializer.fromJson<int>(json['lastUpdatedUs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'displayName': serializer.toJson<String>(displayName),
      'displayExPrecision': serializer.toJson<String?>(displayExPrecision),
      'type': serializer.toJson<String>(type),
      'pipSize': serializer.toJson<double>(pipSize),
      'pipLocation': serializer.toJson<int>(pipLocation),
      'unitsPerLot': serializer.toJson<double>(unitsPerLot),
      'displayPrecision': serializer.toJson<int>(displayPrecision),
      'marginRate': serializer.toJson<double?>(marginRate),
      'minimumTradeSize': serializer.toJson<double?>(minimumTradeSize),
      'minLot': serializer.toJson<double>(minLot),
      'maxLot': serializer.toJson<double>(maxLot),
      'lotStep': serializer.toJson<double>(lotStep),
      'tradeUnitsPrecision': serializer.toJson<double>(tradeUnitsPrecision),
      'isWatchlisted': serializer.toJson<bool>(isWatchlisted),
      'watchlistSortOrder': serializer.toJson<int>(watchlistSortOrder),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'lastUpdatedUs': serializer.toJson<int>(lastUpdatedUs),
    };
  }

  Symbol copyWith(
          {String? name,
          String? displayName,
          Value<String?> displayExPrecision = const Value.absent(),
          String? type,
          double? pipSize,
          int? pipLocation,
          double? unitsPerLot,
          int? displayPrecision,
          Value<double?> marginRate = const Value.absent(),
          Value<double?> minimumTradeSize = const Value.absent(),
          double? minLot,
          double? maxLot,
          double? lotStep,
          double? tradeUnitsPrecision,
          bool? isWatchlisted,
          int? watchlistSortOrder,
          int? sortOrder,
          int? lastUpdatedUs}) =>
      Symbol(
        name: name ?? this.name,
        displayName: displayName ?? this.displayName,
        displayExPrecision: displayExPrecision.present
            ? displayExPrecision.value
            : this.displayExPrecision,
        type: type ?? this.type,
        pipSize: pipSize ?? this.pipSize,
        pipLocation: pipLocation ?? this.pipLocation,
        unitsPerLot: unitsPerLot ?? this.unitsPerLot,
        displayPrecision: displayPrecision ?? this.displayPrecision,
        marginRate: marginRate.present ? marginRate.value : this.marginRate,
        minimumTradeSize: minimumTradeSize.present
            ? minimumTradeSize.value
            : this.minimumTradeSize,
        minLot: minLot ?? this.minLot,
        maxLot: maxLot ?? this.maxLot,
        lotStep: lotStep ?? this.lotStep,
        tradeUnitsPrecision: tradeUnitsPrecision ?? this.tradeUnitsPrecision,
        isWatchlisted: isWatchlisted ?? this.isWatchlisted,
        watchlistSortOrder: watchlistSortOrder ?? this.watchlistSortOrder,
        sortOrder: sortOrder ?? this.sortOrder,
        lastUpdatedUs: lastUpdatedUs ?? this.lastUpdatedUs,
      );
  Symbol copyWithCompanion(SymbolsCompanion data) {
    return Symbol(
      name: data.name.present ? data.name.value : this.name,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      displayExPrecision: data.displayExPrecision.present
          ? data.displayExPrecision.value
          : this.displayExPrecision,
      type: data.type.present ? data.type.value : this.type,
      pipSize: data.pipSize.present ? data.pipSize.value : this.pipSize,
      pipLocation:
          data.pipLocation.present ? data.pipLocation.value : this.pipLocation,
      unitsPerLot:
          data.unitsPerLot.present ? data.unitsPerLot.value : this.unitsPerLot,
      displayPrecision: data.displayPrecision.present
          ? data.displayPrecision.value
          : this.displayPrecision,
      marginRate:
          data.marginRate.present ? data.marginRate.value : this.marginRate,
      minimumTradeSize: data.minimumTradeSize.present
          ? data.minimumTradeSize.value
          : this.minimumTradeSize,
      minLot: data.minLot.present ? data.minLot.value : this.minLot,
      maxLot: data.maxLot.present ? data.maxLot.value : this.maxLot,
      lotStep: data.lotStep.present ? data.lotStep.value : this.lotStep,
      tradeUnitsPrecision: data.tradeUnitsPrecision.present
          ? data.tradeUnitsPrecision.value
          : this.tradeUnitsPrecision,
      isWatchlisted: data.isWatchlisted.present
          ? data.isWatchlisted.value
          : this.isWatchlisted,
      watchlistSortOrder: data.watchlistSortOrder.present
          ? data.watchlistSortOrder.value
          : this.watchlistSortOrder,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      lastUpdatedUs: data.lastUpdatedUs.present
          ? data.lastUpdatedUs.value
          : this.lastUpdatedUs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Symbol(')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('displayExPrecision: $displayExPrecision, ')
          ..write('type: $type, ')
          ..write('pipSize: $pipSize, ')
          ..write('pipLocation: $pipLocation, ')
          ..write('unitsPerLot: $unitsPerLot, ')
          ..write('displayPrecision: $displayPrecision, ')
          ..write('marginRate: $marginRate, ')
          ..write('minimumTradeSize: $minimumTradeSize, ')
          ..write('minLot: $minLot, ')
          ..write('maxLot: $maxLot, ')
          ..write('lotStep: $lotStep, ')
          ..write('tradeUnitsPrecision: $tradeUnitsPrecision, ')
          ..write('isWatchlisted: $isWatchlisted, ')
          ..write('watchlistSortOrder: $watchlistSortOrder, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('lastUpdatedUs: $lastUpdatedUs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      name,
      displayName,
      displayExPrecision,
      type,
      pipSize,
      pipLocation,
      unitsPerLot,
      displayPrecision,
      marginRate,
      minimumTradeSize,
      minLot,
      maxLot,
      lotStep,
      tradeUnitsPrecision,
      isWatchlisted,
      watchlistSortOrder,
      sortOrder,
      lastUpdatedUs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Symbol &&
          other.name == this.name &&
          other.displayName == this.displayName &&
          other.displayExPrecision == this.displayExPrecision &&
          other.type == this.type &&
          other.pipSize == this.pipSize &&
          other.pipLocation == this.pipLocation &&
          other.unitsPerLot == this.unitsPerLot &&
          other.displayPrecision == this.displayPrecision &&
          other.marginRate == this.marginRate &&
          other.minimumTradeSize == this.minimumTradeSize &&
          other.minLot == this.minLot &&
          other.maxLot == this.maxLot &&
          other.lotStep == this.lotStep &&
          other.tradeUnitsPrecision == this.tradeUnitsPrecision &&
          other.isWatchlisted == this.isWatchlisted &&
          other.watchlistSortOrder == this.watchlistSortOrder &&
          other.sortOrder == this.sortOrder &&
          other.lastUpdatedUs == this.lastUpdatedUs);
}

class SymbolsCompanion extends UpdateCompanion<Symbol> {
  final Value<String> name;
  final Value<String> displayName;
  final Value<String?> displayExPrecision;
  final Value<String> type;
  final Value<double> pipSize;
  final Value<int> pipLocation;
  final Value<double> unitsPerLot;
  final Value<int> displayPrecision;
  final Value<double?> marginRate;
  final Value<double?> minimumTradeSize;
  final Value<double> minLot;
  final Value<double> maxLot;
  final Value<double> lotStep;
  final Value<double> tradeUnitsPrecision;
  final Value<bool> isWatchlisted;
  final Value<int> watchlistSortOrder;
  final Value<int> sortOrder;
  final Value<int> lastUpdatedUs;
  final Value<int> rowid;
  const SymbolsCompanion({
    this.name = const Value.absent(),
    this.displayName = const Value.absent(),
    this.displayExPrecision = const Value.absent(),
    this.type = const Value.absent(),
    this.pipSize = const Value.absent(),
    this.pipLocation = const Value.absent(),
    this.unitsPerLot = const Value.absent(),
    this.displayPrecision = const Value.absent(),
    this.marginRate = const Value.absent(),
    this.minimumTradeSize = const Value.absent(),
    this.minLot = const Value.absent(),
    this.maxLot = const Value.absent(),
    this.lotStep = const Value.absent(),
    this.tradeUnitsPrecision = const Value.absent(),
    this.isWatchlisted = const Value.absent(),
    this.watchlistSortOrder = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.lastUpdatedUs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SymbolsCompanion.insert({
    required String name,
    required String displayName,
    this.displayExPrecision = const Value.absent(),
    required String type,
    required double pipSize,
    required int pipLocation,
    this.unitsPerLot = const Value.absent(),
    this.displayPrecision = const Value.absent(),
    this.marginRate = const Value.absent(),
    this.minimumTradeSize = const Value.absent(),
    this.minLot = const Value.absent(),
    this.maxLot = const Value.absent(),
    this.lotStep = const Value.absent(),
    this.tradeUnitsPrecision = const Value.absent(),
    this.isWatchlisted = const Value.absent(),
    this.watchlistSortOrder = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.lastUpdatedUs = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        displayName = Value(displayName),
        type = Value(type),
        pipSize = Value(pipSize),
        pipLocation = Value(pipLocation);
  static Insertable<Symbol> custom({
    Expression<String>? name,
    Expression<String>? displayName,
    Expression<String>? displayExPrecision,
    Expression<String>? type,
    Expression<double>? pipSize,
    Expression<int>? pipLocation,
    Expression<double>? unitsPerLot,
    Expression<int>? displayPrecision,
    Expression<double>? marginRate,
    Expression<double>? minimumTradeSize,
    Expression<double>? minLot,
    Expression<double>? maxLot,
    Expression<double>? lotStep,
    Expression<double>? tradeUnitsPrecision,
    Expression<bool>? isWatchlisted,
    Expression<int>? watchlistSortOrder,
    Expression<int>? sortOrder,
    Expression<int>? lastUpdatedUs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (displayName != null) 'display_name': displayName,
      if (displayExPrecision != null)
        'display_ex_precision': displayExPrecision,
      if (type != null) 'type': type,
      if (pipSize != null) 'pip_size': pipSize,
      if (pipLocation != null) 'pip_location': pipLocation,
      if (unitsPerLot != null) 'units_per_lot': unitsPerLot,
      if (displayPrecision != null) 'display_precision': displayPrecision,
      if (marginRate != null) 'margin_rate': marginRate,
      if (minimumTradeSize != null) 'minimum_trade_size': minimumTradeSize,
      if (minLot != null) 'min_lot': minLot,
      if (maxLot != null) 'max_lot': maxLot,
      if (lotStep != null) 'lot_step': lotStep,
      if (tradeUnitsPrecision != null)
        'trade_units_precision': tradeUnitsPrecision,
      if (isWatchlisted != null) 'is_watchlisted': isWatchlisted,
      if (watchlistSortOrder != null)
        'watchlist_sort_order': watchlistSortOrder,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (lastUpdatedUs != null) 'last_updated_us': lastUpdatedUs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SymbolsCompanion copyWith(
      {Value<String>? name,
      Value<String>? displayName,
      Value<String?>? displayExPrecision,
      Value<String>? type,
      Value<double>? pipSize,
      Value<int>? pipLocation,
      Value<double>? unitsPerLot,
      Value<int>? displayPrecision,
      Value<double?>? marginRate,
      Value<double?>? minimumTradeSize,
      Value<double>? minLot,
      Value<double>? maxLot,
      Value<double>? lotStep,
      Value<double>? tradeUnitsPrecision,
      Value<bool>? isWatchlisted,
      Value<int>? watchlistSortOrder,
      Value<int>? sortOrder,
      Value<int>? lastUpdatedUs,
      Value<int>? rowid}) {
    return SymbolsCompanion(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      displayExPrecision: displayExPrecision ?? this.displayExPrecision,
      type: type ?? this.type,
      pipSize: pipSize ?? this.pipSize,
      pipLocation: pipLocation ?? this.pipLocation,
      unitsPerLot: unitsPerLot ?? this.unitsPerLot,
      displayPrecision: displayPrecision ?? this.displayPrecision,
      marginRate: marginRate ?? this.marginRate,
      minimumTradeSize: minimumTradeSize ?? this.minimumTradeSize,
      minLot: minLot ?? this.minLot,
      maxLot: maxLot ?? this.maxLot,
      lotStep: lotStep ?? this.lotStep,
      tradeUnitsPrecision: tradeUnitsPrecision ?? this.tradeUnitsPrecision,
      isWatchlisted: isWatchlisted ?? this.isWatchlisted,
      watchlistSortOrder: watchlistSortOrder ?? this.watchlistSortOrder,
      sortOrder: sortOrder ?? this.sortOrder,
      lastUpdatedUs: lastUpdatedUs ?? this.lastUpdatedUs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (displayExPrecision.present) {
      map['display_ex_precision'] = Variable<String>(displayExPrecision.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (pipSize.present) {
      map['pip_size'] = Variable<double>(pipSize.value);
    }
    if (pipLocation.present) {
      map['pip_location'] = Variable<int>(pipLocation.value);
    }
    if (unitsPerLot.present) {
      map['units_per_lot'] = Variable<double>(unitsPerLot.value);
    }
    if (displayPrecision.present) {
      map['display_precision'] = Variable<int>(displayPrecision.value);
    }
    if (marginRate.present) {
      map['margin_rate'] = Variable<double>(marginRate.value);
    }
    if (minimumTradeSize.present) {
      map['minimum_trade_size'] = Variable<double>(minimumTradeSize.value);
    }
    if (minLot.present) {
      map['min_lot'] = Variable<double>(minLot.value);
    }
    if (maxLot.present) {
      map['max_lot'] = Variable<double>(maxLot.value);
    }
    if (lotStep.present) {
      map['lot_step'] = Variable<double>(lotStep.value);
    }
    if (tradeUnitsPrecision.present) {
      map['trade_units_precision'] =
          Variable<double>(tradeUnitsPrecision.value);
    }
    if (isWatchlisted.present) {
      map['is_watchlisted'] = Variable<bool>(isWatchlisted.value);
    }
    if (watchlistSortOrder.present) {
      map['watchlist_sort_order'] = Variable<int>(watchlistSortOrder.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (lastUpdatedUs.present) {
      map['last_updated_us'] = Variable<int>(lastUpdatedUs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymbolsCompanion(')
          ..write('name: $name, ')
          ..write('displayName: $displayName, ')
          ..write('displayExPrecision: $displayExPrecision, ')
          ..write('type: $type, ')
          ..write('pipSize: $pipSize, ')
          ..write('pipLocation: $pipLocation, ')
          ..write('unitsPerLot: $unitsPerLot, ')
          ..write('displayPrecision: $displayPrecision, ')
          ..write('marginRate: $marginRate, ')
          ..write('minimumTradeSize: $minimumTradeSize, ')
          ..write('minLot: $minLot, ')
          ..write('maxLot: $maxLot, ')
          ..write('lotStep: $lotStep, ')
          ..write('tradeUnitsPrecision: $tradeUnitsPrecision, ')
          ..write('isWatchlisted: $isWatchlisted, ')
          ..write('watchlistSortOrder: $watchlistSortOrder, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('lastUpdatedUs: $lastUpdatedUs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PositionsTable extends Positions
    with TableInfo<$PositionsTable, Position> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _oandaTradeIdMeta =
      const VerificationMeta('oandaTradeId');
  @override
  late final GeneratedColumn<String> oandaTradeId = GeneratedColumn<String>(
      'oanda_trade_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
      'direction', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lotsMeta = const VerificationMeta('lots');
  @override
  late final GeneratedColumn<double> lots = GeneratedColumn<double>(
      'lots', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
      'units', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _openPriceMeta =
      const VerificationMeta('openPrice');
  @override
  late final GeneratedColumn<double> openPrice = GeneratedColumn<double>(
      'open_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentPriceMeta =
      const VerificationMeta('currentPrice');
  @override
  late final GeneratedColumn<double> currentPrice = GeneratedColumn<double>(
      'current_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _stopLossMeta =
      const VerificationMeta('stopLoss');
  @override
  late final GeneratedColumn<double> stopLoss = GeneratedColumn<double>(
      'stop_loss', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _takeProfitMeta =
      const VerificationMeta('takeProfit');
  @override
  late final GeneratedColumn<double> takeProfit = GeneratedColumn<double>(
      'take_profit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _floatingPnlMeta =
      const VerificationMeta('floatingPnl');
  @override
  late final GeneratedColumn<double> floatingPnl = GeneratedColumn<double>(
      'floating_pnl', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _swapMeta = const VerificationMeta('swap');
  @override
  late final GeneratedColumn<double> swap = GeneratedColumn<double>(
      'swap', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _commissionMeta =
      const VerificationMeta('commission');
  @override
  late final GeneratedColumn<double> commission = GeneratedColumn<double>(
      'commission', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _marginUsedMeta =
      const VerificationMeta('marginUsed');
  @override
  late final GeneratedColumn<double> marginUsed = GeneratedColumn<double>(
      'margin_used', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _openTimeUsMeta =
      const VerificationMeta('openTimeUs');
  @override
  late final GeneratedColumn<int> openTimeUs = GeneratedColumn<int>(
      'open_time_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _magicNumberMeta =
      const VerificationMeta('magicNumber');
  @override
  late final GeneratedColumn<int> magicNumber = GeneratedColumn<int>(
      'magic_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isModifyingMeta =
      const VerificationMeta('isModifying');
  @override
  late final GeneratedColumn<bool> isModifying = GeneratedColumn<bool>(
      'is_modifying', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_modifying" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        oandaTradeId,
        symbol,
        direction,
        lots,
        units,
        openPrice,
        currentPrice,
        stopLoss,
        takeProfit,
        floatingPnl,
        swap,
        commission,
        marginUsed,
        openTimeUs,
        magicNumber,
        comment,
        isModifying
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'positions';
  @override
  VerificationContext validateIntegrity(Insertable<Position> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('oanda_trade_id')) {
      context.handle(
          _oandaTradeIdMeta,
          oandaTradeId.isAcceptableOrUnknown(
              data['oanda_trade_id']!, _oandaTradeIdMeta));
    } else if (isInserting) {
      context.missing(_oandaTradeIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('lots')) {
      context.handle(
          _lotsMeta, lots.isAcceptableOrUnknown(data['lots']!, _lotsMeta));
    } else if (isInserting) {
      context.missing(_lotsMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('open_price')) {
      context.handle(_openPriceMeta,
          openPrice.isAcceptableOrUnknown(data['open_price']!, _openPriceMeta));
    } else if (isInserting) {
      context.missing(_openPriceMeta);
    }
    if (data.containsKey('current_price')) {
      context.handle(
          _currentPriceMeta,
          currentPrice.isAcceptableOrUnknown(
              data['current_price']!, _currentPriceMeta));
    }
    if (data.containsKey('stop_loss')) {
      context.handle(_stopLossMeta,
          stopLoss.isAcceptableOrUnknown(data['stop_loss']!, _stopLossMeta));
    }
    if (data.containsKey('take_profit')) {
      context.handle(
          _takeProfitMeta,
          takeProfit.isAcceptableOrUnknown(
              data['take_profit']!, _takeProfitMeta));
    }
    if (data.containsKey('floating_pnl')) {
      context.handle(
          _floatingPnlMeta,
          floatingPnl.isAcceptableOrUnknown(
              data['floating_pnl']!, _floatingPnlMeta));
    }
    if (data.containsKey('swap')) {
      context.handle(
          _swapMeta, swap.isAcceptableOrUnknown(data['swap']!, _swapMeta));
    }
    if (data.containsKey('commission')) {
      context.handle(
          _commissionMeta,
          commission.isAcceptableOrUnknown(
              data['commission']!, _commissionMeta));
    }
    if (data.containsKey('margin_used')) {
      context.handle(
          _marginUsedMeta,
          marginUsed.isAcceptableOrUnknown(
              data['margin_used']!, _marginUsedMeta));
    }
    if (data.containsKey('open_time_us')) {
      context.handle(
          _openTimeUsMeta,
          openTimeUs.isAcceptableOrUnknown(
              data['open_time_us']!, _openTimeUsMeta));
    } else if (isInserting) {
      context.missing(_openTimeUsMeta);
    }
    if (data.containsKey('magic_number')) {
      context.handle(
          _magicNumberMeta,
          magicNumber.isAcceptableOrUnknown(
              data['magic_number']!, _magicNumberMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('is_modifying')) {
      context.handle(
          _isModifyingMeta,
          isModifying.isAcceptableOrUnknown(
              data['is_modifying']!, _isModifyingMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Position map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Position(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      oandaTradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}oanda_trade_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direction'])!,
      lots: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lots'])!,
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}units'])!,
      openPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}open_price'])!,
      currentPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_price'])!,
      stopLoss: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stop_loss']),
      takeProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}take_profit']),
      floatingPnl: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}floating_pnl'])!,
      swap: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}swap'])!,
      commission: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}commission'])!,
      marginUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}margin_used'])!,
      openTimeUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}open_time_us'])!,
      magicNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}magic_number'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      isModifying: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_modifying'])!,
    );
  }

  @override
  $PositionsTable createAlias(String alias) {
    return $PositionsTable(attachedDatabase, alias);
  }
}

class Position extends DataClass implements Insertable<Position> {
  /// Internal database ID (autoincrement)
  final int id;

  /// OANDA Trade ID — the unique identifier from OANDA's system
  /// This is what we use to modify/close positions via API
  final String oandaTradeId;

  /// Trading instrument (e.g., "XAU_USD")
  final String symbol;

  /// "BUY" (long) or "SELL" (short)
  final String direction;

  /// Position size in lots (e.g., 0.01, 0.1, 1.0)
  final double lots;

  /// Position size in base units (OANDA uses units, not lots)
  final double units;

  /// Price at which the position was opened
  final double openPrice;

  /// Current market price (bid for longs, ask for shorts)
  /// Updated on every tick — this drives the PnL calculation
  final double currentPrice;

  /// Stop Loss price (null = no SL set)
  final double? stopLoss;

  /// Take Profit price (null = no TP set)
  final double? takeProfit;

  /// Floating (unrealized) P&L in account currency
  /// Recalculated on every tick update
  final double floatingPnl;

  /// Accumulated swap/rollover charges (added daily at 5pm NY time)
  final double swap;

  /// Commission charged on open (if applicable)
  final double commission;

  /// Margin currently used by this position (in account currency)
  final double marginUsed;

  /// When the position was opened (microseconds UTC)
  final int openTimeUs;

  /// Magic number identifying which EA opened this position (0 = manual)
  final int magicNumber;

  /// Order comment (max 32 chars, from EA or manual entry)
  final String comment;

  /// Whether this position is currently being modified (UI lock)
  final bool isModifying;
  const Position(
      {required this.id,
      required this.oandaTradeId,
      required this.symbol,
      required this.direction,
      required this.lots,
      required this.units,
      required this.openPrice,
      required this.currentPrice,
      this.stopLoss,
      this.takeProfit,
      required this.floatingPnl,
      required this.swap,
      required this.commission,
      required this.marginUsed,
      required this.openTimeUs,
      required this.magicNumber,
      required this.comment,
      required this.isModifying});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['oanda_trade_id'] = Variable<String>(oandaTradeId);
    map['symbol'] = Variable<String>(symbol);
    map['direction'] = Variable<String>(direction);
    map['lots'] = Variable<double>(lots);
    map['units'] = Variable<double>(units);
    map['open_price'] = Variable<double>(openPrice);
    map['current_price'] = Variable<double>(currentPrice);
    if (!nullToAbsent || stopLoss != null) {
      map['stop_loss'] = Variable<double>(stopLoss);
    }
    if (!nullToAbsent || takeProfit != null) {
      map['take_profit'] = Variable<double>(takeProfit);
    }
    map['floating_pnl'] = Variable<double>(floatingPnl);
    map['swap'] = Variable<double>(swap);
    map['commission'] = Variable<double>(commission);
    map['margin_used'] = Variable<double>(marginUsed);
    map['open_time_us'] = Variable<int>(openTimeUs);
    map['magic_number'] = Variable<int>(magicNumber);
    map['comment'] = Variable<String>(comment);
    map['is_modifying'] = Variable<bool>(isModifying);
    return map;
  }

  PositionsCompanion toCompanion(bool nullToAbsent) {
    return PositionsCompanion(
      id: Value(id),
      oandaTradeId: Value(oandaTradeId),
      symbol: Value(symbol),
      direction: Value(direction),
      lots: Value(lots),
      units: Value(units),
      openPrice: Value(openPrice),
      currentPrice: Value(currentPrice),
      stopLoss: stopLoss == null && nullToAbsent
          ? const Value.absent()
          : Value(stopLoss),
      takeProfit: takeProfit == null && nullToAbsent
          ? const Value.absent()
          : Value(takeProfit),
      floatingPnl: Value(floatingPnl),
      swap: Value(swap),
      commission: Value(commission),
      marginUsed: Value(marginUsed),
      openTimeUs: Value(openTimeUs),
      magicNumber: Value(magicNumber),
      comment: Value(comment),
      isModifying: Value(isModifying),
    );
  }

  factory Position.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Position(
      id: serializer.fromJson<int>(json['id']),
      oandaTradeId: serializer.fromJson<String>(json['oandaTradeId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      direction: serializer.fromJson<String>(json['direction']),
      lots: serializer.fromJson<double>(json['lots']),
      units: serializer.fromJson<double>(json['units']),
      openPrice: serializer.fromJson<double>(json['openPrice']),
      currentPrice: serializer.fromJson<double>(json['currentPrice']),
      stopLoss: serializer.fromJson<double?>(json['stopLoss']),
      takeProfit: serializer.fromJson<double?>(json['takeProfit']),
      floatingPnl: serializer.fromJson<double>(json['floatingPnl']),
      swap: serializer.fromJson<double>(json['swap']),
      commission: serializer.fromJson<double>(json['commission']),
      marginUsed: serializer.fromJson<double>(json['marginUsed']),
      openTimeUs: serializer.fromJson<int>(json['openTimeUs']),
      magicNumber: serializer.fromJson<int>(json['magicNumber']),
      comment: serializer.fromJson<String>(json['comment']),
      isModifying: serializer.fromJson<bool>(json['isModifying']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'oandaTradeId': serializer.toJson<String>(oandaTradeId),
      'symbol': serializer.toJson<String>(symbol),
      'direction': serializer.toJson<String>(direction),
      'lots': serializer.toJson<double>(lots),
      'units': serializer.toJson<double>(units),
      'openPrice': serializer.toJson<double>(openPrice),
      'currentPrice': serializer.toJson<double>(currentPrice),
      'stopLoss': serializer.toJson<double?>(stopLoss),
      'takeProfit': serializer.toJson<double?>(takeProfit),
      'floatingPnl': serializer.toJson<double>(floatingPnl),
      'swap': serializer.toJson<double>(swap),
      'commission': serializer.toJson<double>(commission),
      'marginUsed': serializer.toJson<double>(marginUsed),
      'openTimeUs': serializer.toJson<int>(openTimeUs),
      'magicNumber': serializer.toJson<int>(magicNumber),
      'comment': serializer.toJson<String>(comment),
      'isModifying': serializer.toJson<bool>(isModifying),
    };
  }

  Position copyWith(
          {int? id,
          String? oandaTradeId,
          String? symbol,
          String? direction,
          double? lots,
          double? units,
          double? openPrice,
          double? currentPrice,
          Value<double?> stopLoss = const Value.absent(),
          Value<double?> takeProfit = const Value.absent(),
          double? floatingPnl,
          double? swap,
          double? commission,
          double? marginUsed,
          int? openTimeUs,
          int? magicNumber,
          String? comment,
          bool? isModifying}) =>
      Position(
        id: id ?? this.id,
        oandaTradeId: oandaTradeId ?? this.oandaTradeId,
        symbol: symbol ?? this.symbol,
        direction: direction ?? this.direction,
        lots: lots ?? this.lots,
        units: units ?? this.units,
        openPrice: openPrice ?? this.openPrice,
        currentPrice: currentPrice ?? this.currentPrice,
        stopLoss: stopLoss.present ? stopLoss.value : this.stopLoss,
        takeProfit: takeProfit.present ? takeProfit.value : this.takeProfit,
        floatingPnl: floatingPnl ?? this.floatingPnl,
        swap: swap ?? this.swap,
        commission: commission ?? this.commission,
        marginUsed: marginUsed ?? this.marginUsed,
        openTimeUs: openTimeUs ?? this.openTimeUs,
        magicNumber: magicNumber ?? this.magicNumber,
        comment: comment ?? this.comment,
        isModifying: isModifying ?? this.isModifying,
      );
  Position copyWithCompanion(PositionsCompanion data) {
    return Position(
      id: data.id.present ? data.id.value : this.id,
      oandaTradeId: data.oandaTradeId.present
          ? data.oandaTradeId.value
          : this.oandaTradeId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      direction: data.direction.present ? data.direction.value : this.direction,
      lots: data.lots.present ? data.lots.value : this.lots,
      units: data.units.present ? data.units.value : this.units,
      openPrice: data.openPrice.present ? data.openPrice.value : this.openPrice,
      currentPrice: data.currentPrice.present
          ? data.currentPrice.value
          : this.currentPrice,
      stopLoss: data.stopLoss.present ? data.stopLoss.value : this.stopLoss,
      takeProfit:
          data.takeProfit.present ? data.takeProfit.value : this.takeProfit,
      floatingPnl:
          data.floatingPnl.present ? data.floatingPnl.value : this.floatingPnl,
      swap: data.swap.present ? data.swap.value : this.swap,
      commission:
          data.commission.present ? data.commission.value : this.commission,
      marginUsed:
          data.marginUsed.present ? data.marginUsed.value : this.marginUsed,
      openTimeUs:
          data.openTimeUs.present ? data.openTimeUs.value : this.openTimeUs,
      magicNumber:
          data.magicNumber.present ? data.magicNumber.value : this.magicNumber,
      comment: data.comment.present ? data.comment.value : this.comment,
      isModifying:
          data.isModifying.present ? data.isModifying.value : this.isModifying,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Position(')
          ..write('id: $id, ')
          ..write('oandaTradeId: $oandaTradeId, ')
          ..write('symbol: $symbol, ')
          ..write('direction: $direction, ')
          ..write('lots: $lots, ')
          ..write('units: $units, ')
          ..write('openPrice: $openPrice, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('floatingPnl: $floatingPnl, ')
          ..write('swap: $swap, ')
          ..write('commission: $commission, ')
          ..write('marginUsed: $marginUsed, ')
          ..write('openTimeUs: $openTimeUs, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('comment: $comment, ')
          ..write('isModifying: $isModifying')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      oandaTradeId,
      symbol,
      direction,
      lots,
      units,
      openPrice,
      currentPrice,
      stopLoss,
      takeProfit,
      floatingPnl,
      swap,
      commission,
      marginUsed,
      openTimeUs,
      magicNumber,
      comment,
      isModifying);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Position &&
          other.id == this.id &&
          other.oandaTradeId == this.oandaTradeId &&
          other.symbol == this.symbol &&
          other.direction == this.direction &&
          other.lots == this.lots &&
          other.units == this.units &&
          other.openPrice == this.openPrice &&
          other.currentPrice == this.currentPrice &&
          other.stopLoss == this.stopLoss &&
          other.takeProfit == this.takeProfit &&
          other.floatingPnl == this.floatingPnl &&
          other.swap == this.swap &&
          other.commission == this.commission &&
          other.marginUsed == this.marginUsed &&
          other.openTimeUs == this.openTimeUs &&
          other.magicNumber == this.magicNumber &&
          other.comment == this.comment &&
          other.isModifying == this.isModifying);
}

class PositionsCompanion extends UpdateCompanion<Position> {
  final Value<int> id;
  final Value<String> oandaTradeId;
  final Value<String> symbol;
  final Value<String> direction;
  final Value<double> lots;
  final Value<double> units;
  final Value<double> openPrice;
  final Value<double> currentPrice;
  final Value<double?> stopLoss;
  final Value<double?> takeProfit;
  final Value<double> floatingPnl;
  final Value<double> swap;
  final Value<double> commission;
  final Value<double> marginUsed;
  final Value<int> openTimeUs;
  final Value<int> magicNumber;
  final Value<String> comment;
  final Value<bool> isModifying;
  const PositionsCompanion({
    this.id = const Value.absent(),
    this.oandaTradeId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.direction = const Value.absent(),
    this.lots = const Value.absent(),
    this.units = const Value.absent(),
    this.openPrice = const Value.absent(),
    this.currentPrice = const Value.absent(),
    this.stopLoss = const Value.absent(),
    this.takeProfit = const Value.absent(),
    this.floatingPnl = const Value.absent(),
    this.swap = const Value.absent(),
    this.commission = const Value.absent(),
    this.marginUsed = const Value.absent(),
    this.openTimeUs = const Value.absent(),
    this.magicNumber = const Value.absent(),
    this.comment = const Value.absent(),
    this.isModifying = const Value.absent(),
  });
  PositionsCompanion.insert({
    this.id = const Value.absent(),
    required String oandaTradeId,
    required String symbol,
    required String direction,
    required double lots,
    required double units,
    required double openPrice,
    this.currentPrice = const Value.absent(),
    this.stopLoss = const Value.absent(),
    this.takeProfit = const Value.absent(),
    this.floatingPnl = const Value.absent(),
    this.swap = const Value.absent(),
    this.commission = const Value.absent(),
    this.marginUsed = const Value.absent(),
    required int openTimeUs,
    this.magicNumber = const Value.absent(),
    this.comment = const Value.absent(),
    this.isModifying = const Value.absent(),
  })  : oandaTradeId = Value(oandaTradeId),
        symbol = Value(symbol),
        direction = Value(direction),
        lots = Value(lots),
        units = Value(units),
        openPrice = Value(openPrice),
        openTimeUs = Value(openTimeUs);
  static Insertable<Position> custom({
    Expression<int>? id,
    Expression<String>? oandaTradeId,
    Expression<String>? symbol,
    Expression<String>? direction,
    Expression<double>? lots,
    Expression<double>? units,
    Expression<double>? openPrice,
    Expression<double>? currentPrice,
    Expression<double>? stopLoss,
    Expression<double>? takeProfit,
    Expression<double>? floatingPnl,
    Expression<double>? swap,
    Expression<double>? commission,
    Expression<double>? marginUsed,
    Expression<int>? openTimeUs,
    Expression<int>? magicNumber,
    Expression<String>? comment,
    Expression<bool>? isModifying,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (oandaTradeId != null) 'oanda_trade_id': oandaTradeId,
      if (symbol != null) 'symbol': symbol,
      if (direction != null) 'direction': direction,
      if (lots != null) 'lots': lots,
      if (units != null) 'units': units,
      if (openPrice != null) 'open_price': openPrice,
      if (currentPrice != null) 'current_price': currentPrice,
      if (stopLoss != null) 'stop_loss': stopLoss,
      if (takeProfit != null) 'take_profit': takeProfit,
      if (floatingPnl != null) 'floating_pnl': floatingPnl,
      if (swap != null) 'swap': swap,
      if (commission != null) 'commission': commission,
      if (marginUsed != null) 'margin_used': marginUsed,
      if (openTimeUs != null) 'open_time_us': openTimeUs,
      if (magicNumber != null) 'magic_number': magicNumber,
      if (comment != null) 'comment': comment,
      if (isModifying != null) 'is_modifying': isModifying,
    });
  }

  PositionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? oandaTradeId,
      Value<String>? symbol,
      Value<String>? direction,
      Value<double>? lots,
      Value<double>? units,
      Value<double>? openPrice,
      Value<double>? currentPrice,
      Value<double?>? stopLoss,
      Value<double?>? takeProfit,
      Value<double>? floatingPnl,
      Value<double>? swap,
      Value<double>? commission,
      Value<double>? marginUsed,
      Value<int>? openTimeUs,
      Value<int>? magicNumber,
      Value<String>? comment,
      Value<bool>? isModifying}) {
    return PositionsCompanion(
      id: id ?? this.id,
      oandaTradeId: oandaTradeId ?? this.oandaTradeId,
      symbol: symbol ?? this.symbol,
      direction: direction ?? this.direction,
      lots: lots ?? this.lots,
      units: units ?? this.units,
      openPrice: openPrice ?? this.openPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      floatingPnl: floatingPnl ?? this.floatingPnl,
      swap: swap ?? this.swap,
      commission: commission ?? this.commission,
      marginUsed: marginUsed ?? this.marginUsed,
      openTimeUs: openTimeUs ?? this.openTimeUs,
      magicNumber: magicNumber ?? this.magicNumber,
      comment: comment ?? this.comment,
      isModifying: isModifying ?? this.isModifying,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (oandaTradeId.present) {
      map['oanda_trade_id'] = Variable<String>(oandaTradeId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (lots.present) {
      map['lots'] = Variable<double>(lots.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (openPrice.present) {
      map['open_price'] = Variable<double>(openPrice.value);
    }
    if (currentPrice.present) {
      map['current_price'] = Variable<double>(currentPrice.value);
    }
    if (stopLoss.present) {
      map['stop_loss'] = Variable<double>(stopLoss.value);
    }
    if (takeProfit.present) {
      map['take_profit'] = Variable<double>(takeProfit.value);
    }
    if (floatingPnl.present) {
      map['floating_pnl'] = Variable<double>(floatingPnl.value);
    }
    if (swap.present) {
      map['swap'] = Variable<double>(swap.value);
    }
    if (commission.present) {
      map['commission'] = Variable<double>(commission.value);
    }
    if (marginUsed.present) {
      map['margin_used'] = Variable<double>(marginUsed.value);
    }
    if (openTimeUs.present) {
      map['open_time_us'] = Variable<int>(openTimeUs.value);
    }
    if (magicNumber.present) {
      map['magic_number'] = Variable<int>(magicNumber.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (isModifying.present) {
      map['is_modifying'] = Variable<bool>(isModifying.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionsCompanion(')
          ..write('id: $id, ')
          ..write('oandaTradeId: $oandaTradeId, ')
          ..write('symbol: $symbol, ')
          ..write('direction: $direction, ')
          ..write('lots: $lots, ')
          ..write('units: $units, ')
          ..write('openPrice: $openPrice, ')
          ..write('currentPrice: $currentPrice, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('floatingPnl: $floatingPnl, ')
          ..write('swap: $swap, ')
          ..write('commission: $commission, ')
          ..write('marginUsed: $marginUsed, ')
          ..write('openTimeUs: $openTimeUs, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('comment: $comment, ')
          ..write('isModifying: $isModifying')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _oandaOrderIdMeta =
      const VerificationMeta('oandaOrderId');
  @override
  late final GeneratedColumn<String> oandaOrderId = GeneratedColumn<String>(
      'oanda_order_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _orderTypeMeta =
      const VerificationMeta('orderType');
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
      'order_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
      'direction', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lotsMeta = const VerificationMeta('lots');
  @override
  late final GeneratedColumn<double> lots = GeneratedColumn<double>(
      'lots', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
      'units', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceBoundMeta =
      const VerificationMeta('priceBound');
  @override
  late final GeneratedColumn<double> priceBound = GeneratedColumn<double>(
      'price_bound', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stopLossMeta =
      const VerificationMeta('stopLoss');
  @override
  late final GeneratedColumn<double> stopLoss = GeneratedColumn<double>(
      'stop_loss', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _takeProfitMeta =
      const VerificationMeta('takeProfit');
  @override
  late final GeneratedColumn<double> takeProfit = GeneratedColumn<double>(
      'take_profit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _timeInForceMeta =
      const VerificationMeta('timeInForce');
  @override
  late final GeneratedColumn<String> timeInForce = GeneratedColumn<String>(
      'time_in_force', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('GTC'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _createTimeUsMeta =
      const VerificationMeta('createTimeUs');
  @override
  late final GeneratedColumn<int> createTimeUs = GeneratedColumn<int>(
      'create_time_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _expiryTimeUsMeta =
      const VerificationMeta('expiryTimeUs');
  @override
  late final GeneratedColumn<int> expiryTimeUs = GeneratedColumn<int>(
      'expiry_time_us', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _magicNumberMeta =
      const VerificationMeta('magicNumber');
  @override
  late final GeneratedColumn<int> magicNumber = GeneratedColumn<int>(
      'magic_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        oandaOrderId,
        symbol,
        orderType,
        direction,
        lots,
        units,
        price,
        priceBound,
        stopLoss,
        takeProfit,
        timeInForce,
        status,
        createTimeUs,
        expiryTimeUs,
        magicNumber,
        comment
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('oanda_order_id')) {
      context.handle(
          _oandaOrderIdMeta,
          oandaOrderId.isAcceptableOrUnknown(
              data['oanda_order_id']!, _oandaOrderIdMeta));
    } else if (isInserting) {
      context.missing(_oandaOrderIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta));
    } else if (isInserting) {
      context.missing(_orderTypeMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('lots')) {
      context.handle(
          _lotsMeta, lots.isAcceptableOrUnknown(data['lots']!, _lotsMeta));
    } else if (isInserting) {
      context.missing(_lotsMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('price_bound')) {
      context.handle(
          _priceBoundMeta,
          priceBound.isAcceptableOrUnknown(
              data['price_bound']!, _priceBoundMeta));
    }
    if (data.containsKey('stop_loss')) {
      context.handle(_stopLossMeta,
          stopLoss.isAcceptableOrUnknown(data['stop_loss']!, _stopLossMeta));
    }
    if (data.containsKey('take_profit')) {
      context.handle(
          _takeProfitMeta,
          takeProfit.isAcceptableOrUnknown(
              data['take_profit']!, _takeProfitMeta));
    }
    if (data.containsKey('time_in_force')) {
      context.handle(
          _timeInForceMeta,
          timeInForce.isAcceptableOrUnknown(
              data['time_in_force']!, _timeInForceMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('create_time_us')) {
      context.handle(
          _createTimeUsMeta,
          createTimeUs.isAcceptableOrUnknown(
              data['create_time_us']!, _createTimeUsMeta));
    } else if (isInserting) {
      context.missing(_createTimeUsMeta);
    }
    if (data.containsKey('expiry_time_us')) {
      context.handle(
          _expiryTimeUsMeta,
          expiryTimeUs.isAcceptableOrUnknown(
              data['expiry_time_us']!, _expiryTimeUsMeta));
    }
    if (data.containsKey('magic_number')) {
      context.handle(
          _magicNumberMeta,
          magicNumber.isAcceptableOrUnknown(
              data['magic_number']!, _magicNumberMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {oandaOrderId};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      oandaOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}oanda_order_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      orderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direction'])!,
      lots: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lots'])!,
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}units'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      priceBound: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_bound']),
      stopLoss: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stop_loss']),
      takeProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}take_profit']),
      timeInForce: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_in_force'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createTimeUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}create_time_us'])!,
      expiryTimeUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expiry_time_us']),
      magicNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}magic_number'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final String oandaOrderId;
  final String symbol;
  final String orderType;
  final String direction;
  final double lots;
  final double units;
  final double price;
  final double? priceBound;
  final double? stopLoss;
  final double? takeProfit;
  final String timeInForce;
  final String status;
  final int createTimeUs;
  final int? expiryTimeUs;
  final int magicNumber;
  final String comment;
  const Order(
      {required this.oandaOrderId,
      required this.symbol,
      required this.orderType,
      required this.direction,
      required this.lots,
      required this.units,
      required this.price,
      this.priceBound,
      this.stopLoss,
      this.takeProfit,
      required this.timeInForce,
      required this.status,
      required this.createTimeUs,
      this.expiryTimeUs,
      required this.magicNumber,
      required this.comment});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['oanda_order_id'] = Variable<String>(oandaOrderId);
    map['symbol'] = Variable<String>(symbol);
    map['order_type'] = Variable<String>(orderType);
    map['direction'] = Variable<String>(direction);
    map['lots'] = Variable<double>(lots);
    map['units'] = Variable<double>(units);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || priceBound != null) {
      map['price_bound'] = Variable<double>(priceBound);
    }
    if (!nullToAbsent || stopLoss != null) {
      map['stop_loss'] = Variable<double>(stopLoss);
    }
    if (!nullToAbsent || takeProfit != null) {
      map['take_profit'] = Variable<double>(takeProfit);
    }
    map['time_in_force'] = Variable<String>(timeInForce);
    map['status'] = Variable<String>(status);
    map['create_time_us'] = Variable<int>(createTimeUs);
    if (!nullToAbsent || expiryTimeUs != null) {
      map['expiry_time_us'] = Variable<int>(expiryTimeUs);
    }
    map['magic_number'] = Variable<int>(magicNumber);
    map['comment'] = Variable<String>(comment);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      oandaOrderId: Value(oandaOrderId),
      symbol: Value(symbol),
      orderType: Value(orderType),
      direction: Value(direction),
      lots: Value(lots),
      units: Value(units),
      price: Value(price),
      priceBound: priceBound == null && nullToAbsent
          ? const Value.absent()
          : Value(priceBound),
      stopLoss: stopLoss == null && nullToAbsent
          ? const Value.absent()
          : Value(stopLoss),
      takeProfit: takeProfit == null && nullToAbsent
          ? const Value.absent()
          : Value(takeProfit),
      timeInForce: Value(timeInForce),
      status: Value(status),
      createTimeUs: Value(createTimeUs),
      expiryTimeUs: expiryTimeUs == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryTimeUs),
      magicNumber: Value(magicNumber),
      comment: Value(comment),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      oandaOrderId: serializer.fromJson<String>(json['oandaOrderId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      orderType: serializer.fromJson<String>(json['orderType']),
      direction: serializer.fromJson<String>(json['direction']),
      lots: serializer.fromJson<double>(json['lots']),
      units: serializer.fromJson<double>(json['units']),
      price: serializer.fromJson<double>(json['price']),
      priceBound: serializer.fromJson<double?>(json['priceBound']),
      stopLoss: serializer.fromJson<double?>(json['stopLoss']),
      takeProfit: serializer.fromJson<double?>(json['takeProfit']),
      timeInForce: serializer.fromJson<String>(json['timeInForce']),
      status: serializer.fromJson<String>(json['status']),
      createTimeUs: serializer.fromJson<int>(json['createTimeUs']),
      expiryTimeUs: serializer.fromJson<int?>(json['expiryTimeUs']),
      magicNumber: serializer.fromJson<int>(json['magicNumber']),
      comment: serializer.fromJson<String>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'oandaOrderId': serializer.toJson<String>(oandaOrderId),
      'symbol': serializer.toJson<String>(symbol),
      'orderType': serializer.toJson<String>(orderType),
      'direction': serializer.toJson<String>(direction),
      'lots': serializer.toJson<double>(lots),
      'units': serializer.toJson<double>(units),
      'price': serializer.toJson<double>(price),
      'priceBound': serializer.toJson<double?>(priceBound),
      'stopLoss': serializer.toJson<double?>(stopLoss),
      'takeProfit': serializer.toJson<double?>(takeProfit),
      'timeInForce': serializer.toJson<String>(timeInForce),
      'status': serializer.toJson<String>(status),
      'createTimeUs': serializer.toJson<int>(createTimeUs),
      'expiryTimeUs': serializer.toJson<int?>(expiryTimeUs),
      'magicNumber': serializer.toJson<int>(magicNumber),
      'comment': serializer.toJson<String>(comment),
    };
  }

  Order copyWith(
          {String? oandaOrderId,
          String? symbol,
          String? orderType,
          String? direction,
          double? lots,
          double? units,
          double? price,
          Value<double?> priceBound = const Value.absent(),
          Value<double?> stopLoss = const Value.absent(),
          Value<double?> takeProfit = const Value.absent(),
          String? timeInForce,
          String? status,
          int? createTimeUs,
          Value<int?> expiryTimeUs = const Value.absent(),
          int? magicNumber,
          String? comment}) =>
      Order(
        oandaOrderId: oandaOrderId ?? this.oandaOrderId,
        symbol: symbol ?? this.symbol,
        orderType: orderType ?? this.orderType,
        direction: direction ?? this.direction,
        lots: lots ?? this.lots,
        units: units ?? this.units,
        price: price ?? this.price,
        priceBound: priceBound.present ? priceBound.value : this.priceBound,
        stopLoss: stopLoss.present ? stopLoss.value : this.stopLoss,
        takeProfit: takeProfit.present ? takeProfit.value : this.takeProfit,
        timeInForce: timeInForce ?? this.timeInForce,
        status: status ?? this.status,
        createTimeUs: createTimeUs ?? this.createTimeUs,
        expiryTimeUs:
            expiryTimeUs.present ? expiryTimeUs.value : this.expiryTimeUs,
        magicNumber: magicNumber ?? this.magicNumber,
        comment: comment ?? this.comment,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      oandaOrderId: data.oandaOrderId.present
          ? data.oandaOrderId.value
          : this.oandaOrderId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      direction: data.direction.present ? data.direction.value : this.direction,
      lots: data.lots.present ? data.lots.value : this.lots,
      units: data.units.present ? data.units.value : this.units,
      price: data.price.present ? data.price.value : this.price,
      priceBound:
          data.priceBound.present ? data.priceBound.value : this.priceBound,
      stopLoss: data.stopLoss.present ? data.stopLoss.value : this.stopLoss,
      takeProfit:
          data.takeProfit.present ? data.takeProfit.value : this.takeProfit,
      timeInForce:
          data.timeInForce.present ? data.timeInForce.value : this.timeInForce,
      status: data.status.present ? data.status.value : this.status,
      createTimeUs: data.createTimeUs.present
          ? data.createTimeUs.value
          : this.createTimeUs,
      expiryTimeUs: data.expiryTimeUs.present
          ? data.expiryTimeUs.value
          : this.expiryTimeUs,
      magicNumber:
          data.magicNumber.present ? data.magicNumber.value : this.magicNumber,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('oandaOrderId: $oandaOrderId, ')
          ..write('symbol: $symbol, ')
          ..write('orderType: $orderType, ')
          ..write('direction: $direction, ')
          ..write('lots: $lots, ')
          ..write('units: $units, ')
          ..write('price: $price, ')
          ..write('priceBound: $priceBound, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('timeInForce: $timeInForce, ')
          ..write('status: $status, ')
          ..write('createTimeUs: $createTimeUs, ')
          ..write('expiryTimeUs: $expiryTimeUs, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      oandaOrderId,
      symbol,
      orderType,
      direction,
      lots,
      units,
      price,
      priceBound,
      stopLoss,
      takeProfit,
      timeInForce,
      status,
      createTimeUs,
      expiryTimeUs,
      magicNumber,
      comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.oandaOrderId == this.oandaOrderId &&
          other.symbol == this.symbol &&
          other.orderType == this.orderType &&
          other.direction == this.direction &&
          other.lots == this.lots &&
          other.units == this.units &&
          other.price == this.price &&
          other.priceBound == this.priceBound &&
          other.stopLoss == this.stopLoss &&
          other.takeProfit == this.takeProfit &&
          other.timeInForce == this.timeInForce &&
          other.status == this.status &&
          other.createTimeUs == this.createTimeUs &&
          other.expiryTimeUs == this.expiryTimeUs &&
          other.magicNumber == this.magicNumber &&
          other.comment == this.comment);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> oandaOrderId;
  final Value<String> symbol;
  final Value<String> orderType;
  final Value<String> direction;
  final Value<double> lots;
  final Value<double> units;
  final Value<double> price;
  final Value<double?> priceBound;
  final Value<double?> stopLoss;
  final Value<double?> takeProfit;
  final Value<String> timeInForce;
  final Value<String> status;
  final Value<int> createTimeUs;
  final Value<int?> expiryTimeUs;
  final Value<int> magicNumber;
  final Value<String> comment;
  final Value<int> rowid;
  const OrdersCompanion({
    this.oandaOrderId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.orderType = const Value.absent(),
    this.direction = const Value.absent(),
    this.lots = const Value.absent(),
    this.units = const Value.absent(),
    this.price = const Value.absent(),
    this.priceBound = const Value.absent(),
    this.stopLoss = const Value.absent(),
    this.takeProfit = const Value.absent(),
    this.timeInForce = const Value.absent(),
    this.status = const Value.absent(),
    this.createTimeUs = const Value.absent(),
    this.expiryTimeUs = const Value.absent(),
    this.magicNumber = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String oandaOrderId,
    required String symbol,
    required String orderType,
    required String direction,
    required double lots,
    required double units,
    required double price,
    this.priceBound = const Value.absent(),
    this.stopLoss = const Value.absent(),
    this.takeProfit = const Value.absent(),
    this.timeInForce = const Value.absent(),
    this.status = const Value.absent(),
    required int createTimeUs,
    this.expiryTimeUs = const Value.absent(),
    this.magicNumber = const Value.absent(),
    this.comment = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : oandaOrderId = Value(oandaOrderId),
        symbol = Value(symbol),
        orderType = Value(orderType),
        direction = Value(direction),
        lots = Value(lots),
        units = Value(units),
        price = Value(price),
        createTimeUs = Value(createTimeUs);
  static Insertable<Order> custom({
    Expression<String>? oandaOrderId,
    Expression<String>? symbol,
    Expression<String>? orderType,
    Expression<String>? direction,
    Expression<double>? lots,
    Expression<double>? units,
    Expression<double>? price,
    Expression<double>? priceBound,
    Expression<double>? stopLoss,
    Expression<double>? takeProfit,
    Expression<String>? timeInForce,
    Expression<String>? status,
    Expression<int>? createTimeUs,
    Expression<int>? expiryTimeUs,
    Expression<int>? magicNumber,
    Expression<String>? comment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (oandaOrderId != null) 'oanda_order_id': oandaOrderId,
      if (symbol != null) 'symbol': symbol,
      if (orderType != null) 'order_type': orderType,
      if (direction != null) 'direction': direction,
      if (lots != null) 'lots': lots,
      if (units != null) 'units': units,
      if (price != null) 'price': price,
      if (priceBound != null) 'price_bound': priceBound,
      if (stopLoss != null) 'stop_loss': stopLoss,
      if (takeProfit != null) 'take_profit': takeProfit,
      if (timeInForce != null) 'time_in_force': timeInForce,
      if (status != null) 'status': status,
      if (createTimeUs != null) 'create_time_us': createTimeUs,
      if (expiryTimeUs != null) 'expiry_time_us': expiryTimeUs,
      if (magicNumber != null) 'magic_number': magicNumber,
      if (comment != null) 'comment': comment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith(
      {Value<String>? oandaOrderId,
      Value<String>? symbol,
      Value<String>? orderType,
      Value<String>? direction,
      Value<double>? lots,
      Value<double>? units,
      Value<double>? price,
      Value<double?>? priceBound,
      Value<double?>? stopLoss,
      Value<double?>? takeProfit,
      Value<String>? timeInForce,
      Value<String>? status,
      Value<int>? createTimeUs,
      Value<int?>? expiryTimeUs,
      Value<int>? magicNumber,
      Value<String>? comment,
      Value<int>? rowid}) {
    return OrdersCompanion(
      oandaOrderId: oandaOrderId ?? this.oandaOrderId,
      symbol: symbol ?? this.symbol,
      orderType: orderType ?? this.orderType,
      direction: direction ?? this.direction,
      lots: lots ?? this.lots,
      units: units ?? this.units,
      price: price ?? this.price,
      priceBound: priceBound ?? this.priceBound,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      timeInForce: timeInForce ?? this.timeInForce,
      status: status ?? this.status,
      createTimeUs: createTimeUs ?? this.createTimeUs,
      expiryTimeUs: expiryTimeUs ?? this.expiryTimeUs,
      magicNumber: magicNumber ?? this.magicNumber,
      comment: comment ?? this.comment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (oandaOrderId.present) {
      map['oanda_order_id'] = Variable<String>(oandaOrderId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (lots.present) {
      map['lots'] = Variable<double>(lots.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (priceBound.present) {
      map['price_bound'] = Variable<double>(priceBound.value);
    }
    if (stopLoss.present) {
      map['stop_loss'] = Variable<double>(stopLoss.value);
    }
    if (takeProfit.present) {
      map['take_profit'] = Variable<double>(takeProfit.value);
    }
    if (timeInForce.present) {
      map['time_in_force'] = Variable<String>(timeInForce.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createTimeUs.present) {
      map['create_time_us'] = Variable<int>(createTimeUs.value);
    }
    if (expiryTimeUs.present) {
      map['expiry_time_us'] = Variable<int>(expiryTimeUs.value);
    }
    if (magicNumber.present) {
      map['magic_number'] = Variable<int>(magicNumber.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('oandaOrderId: $oandaOrderId, ')
          ..write('symbol: $symbol, ')
          ..write('orderType: $orderType, ')
          ..write('direction: $direction, ')
          ..write('lots: $lots, ')
          ..write('units: $units, ')
          ..write('price: $price, ')
          ..write('priceBound: $priceBound, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('timeInForce: $timeInForce, ')
          ..write('status: $status, ')
          ..write('createTimeUs: $createTimeUs, ')
          ..write('expiryTimeUs: $expiryTimeUs, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('comment: $comment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClosedTradesTable extends ClosedTrades
    with TableInfo<$ClosedTradesTable, ClosedTrade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClosedTradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _oandaTradeIdMeta =
      const VerificationMeta('oandaTradeId');
  @override
  late final GeneratedColumn<String> oandaTradeId = GeneratedColumn<String>(
      'oanda_trade_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
      'direction', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lotsMeta = const VerificationMeta('lots');
  @override
  late final GeneratedColumn<double> lots = GeneratedColumn<double>(
      'lots', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
      'units', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _openPriceMeta =
      const VerificationMeta('openPrice');
  @override
  late final GeneratedColumn<double> openPrice = GeneratedColumn<double>(
      'open_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closePriceMeta =
      const VerificationMeta('closePrice');
  @override
  late final GeneratedColumn<double> closePrice = GeneratedColumn<double>(
      'close_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stopLossMeta =
      const VerificationMeta('stopLoss');
  @override
  late final GeneratedColumn<double> stopLoss = GeneratedColumn<double>(
      'stop_loss', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _takeProfitMeta =
      const VerificationMeta('takeProfit');
  @override
  late final GeneratedColumn<double> takeProfit = GeneratedColumn<double>(
      'take_profit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _realizedPnlMeta =
      const VerificationMeta('realizedPnl');
  @override
  late final GeneratedColumn<double> realizedPnl = GeneratedColumn<double>(
      'realized_pnl', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _swapMeta = const VerificationMeta('swap');
  @override
  late final GeneratedColumn<double> swap = GeneratedColumn<double>(
      'swap', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _commissionMeta =
      const VerificationMeta('commission');
  @override
  late final GeneratedColumn<double> commission = GeneratedColumn<double>(
      'commission', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _netProfitMeta =
      const VerificationMeta('netProfit');
  @override
  late final GeneratedColumn<double> netProfit = GeneratedColumn<double>(
      'net_profit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxProfitMeta =
      const VerificationMeta('maxProfit');
  @override
  late final GeneratedColumn<double> maxProfit = GeneratedColumn<double>(
      'max_profit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _maxDrawdownMeta =
      const VerificationMeta('maxDrawdown');
  @override
  late final GeneratedColumn<double> maxDrawdown = GeneratedColumn<double>(
      'max_drawdown', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _priceDeltaPipsMeta =
      const VerificationMeta('priceDeltaPips');
  @override
  late final GeneratedColumn<double> priceDeltaPips = GeneratedColumn<double>(
      'price_delta_pips', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _closeReasonMeta =
      const VerificationMeta('closeReason');
  @override
  late final GeneratedColumn<String> closeReason = GeneratedColumn<String>(
      'close_reason', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('MANUAL'));
  static const VerificationMeta _openTimeUsMeta =
      const VerificationMeta('openTimeUs');
  @override
  late final GeneratedColumn<int> openTimeUs = GeneratedColumn<int>(
      'open_time_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _closeTimeUsMeta =
      const VerificationMeta('closeTimeUs');
  @override
  late final GeneratedColumn<int> closeTimeUs = GeneratedColumn<int>(
      'close_time_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _openSessionMeta =
      const VerificationMeta('openSession');
  @override
  late final GeneratedColumn<String> openSession = GeneratedColumn<String>(
      'open_session', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _magicNumberMeta =
      const VerificationMeta('magicNumber');
  @override
  late final GeneratedColumn<int> magicNumber = GeneratedColumn<int>(
      'magic_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _closeDateMeta =
      const VerificationMeta('closeDate');
  @override
  late final GeneratedColumn<String> closeDate = GeneratedColumn<String>(
      'close_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        oandaTradeId,
        symbol,
        direction,
        lots,
        units,
        openPrice,
        closePrice,
        stopLoss,
        takeProfit,
        realizedPnl,
        swap,
        commission,
        netProfit,
        maxProfit,
        maxDrawdown,
        priceDeltaPips,
        closeReason,
        openTimeUs,
        closeTimeUs,
        durationSeconds,
        openSession,
        magicNumber,
        comment,
        closeDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'closed_trades';
  @override
  VerificationContext validateIntegrity(Insertable<ClosedTrade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('oanda_trade_id')) {
      context.handle(
          _oandaTradeIdMeta,
          oandaTradeId.isAcceptableOrUnknown(
              data['oanda_trade_id']!, _oandaTradeIdMeta));
    } else if (isInserting) {
      context.missing(_oandaTradeIdMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('lots')) {
      context.handle(
          _lotsMeta, lots.isAcceptableOrUnknown(data['lots']!, _lotsMeta));
    } else if (isInserting) {
      context.missing(_lotsMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('open_price')) {
      context.handle(_openPriceMeta,
          openPrice.isAcceptableOrUnknown(data['open_price']!, _openPriceMeta));
    } else if (isInserting) {
      context.missing(_openPriceMeta);
    }
    if (data.containsKey('close_price')) {
      context.handle(
          _closePriceMeta,
          closePrice.isAcceptableOrUnknown(
              data['close_price']!, _closePriceMeta));
    } else if (isInserting) {
      context.missing(_closePriceMeta);
    }
    if (data.containsKey('stop_loss')) {
      context.handle(_stopLossMeta,
          stopLoss.isAcceptableOrUnknown(data['stop_loss']!, _stopLossMeta));
    }
    if (data.containsKey('take_profit')) {
      context.handle(
          _takeProfitMeta,
          takeProfit.isAcceptableOrUnknown(
              data['take_profit']!, _takeProfitMeta));
    }
    if (data.containsKey('realized_pnl')) {
      context.handle(
          _realizedPnlMeta,
          realizedPnl.isAcceptableOrUnknown(
              data['realized_pnl']!, _realizedPnlMeta));
    } else if (isInserting) {
      context.missing(_realizedPnlMeta);
    }
    if (data.containsKey('swap')) {
      context.handle(
          _swapMeta, swap.isAcceptableOrUnknown(data['swap']!, _swapMeta));
    }
    if (data.containsKey('commission')) {
      context.handle(
          _commissionMeta,
          commission.isAcceptableOrUnknown(
              data['commission']!, _commissionMeta));
    }
    if (data.containsKey('net_profit')) {
      context.handle(_netProfitMeta,
          netProfit.isAcceptableOrUnknown(data['net_profit']!, _netProfitMeta));
    } else if (isInserting) {
      context.missing(_netProfitMeta);
    }
    if (data.containsKey('max_profit')) {
      context.handle(_maxProfitMeta,
          maxProfit.isAcceptableOrUnknown(data['max_profit']!, _maxProfitMeta));
    }
    if (data.containsKey('max_drawdown')) {
      context.handle(
          _maxDrawdownMeta,
          maxDrawdown.isAcceptableOrUnknown(
              data['max_drawdown']!, _maxDrawdownMeta));
    }
    if (data.containsKey('price_delta_pips')) {
      context.handle(
          _priceDeltaPipsMeta,
          priceDeltaPips.isAcceptableOrUnknown(
              data['price_delta_pips']!, _priceDeltaPipsMeta));
    }
    if (data.containsKey('close_reason')) {
      context.handle(
          _closeReasonMeta,
          closeReason.isAcceptableOrUnknown(
              data['close_reason']!, _closeReasonMeta));
    }
    if (data.containsKey('open_time_us')) {
      context.handle(
          _openTimeUsMeta,
          openTimeUs.isAcceptableOrUnknown(
              data['open_time_us']!, _openTimeUsMeta));
    } else if (isInserting) {
      context.missing(_openTimeUsMeta);
    }
    if (data.containsKey('close_time_us')) {
      context.handle(
          _closeTimeUsMeta,
          closeTimeUs.isAcceptableOrUnknown(
              data['close_time_us']!, _closeTimeUsMeta));
    } else if (isInserting) {
      context.missing(_closeTimeUsMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('open_session')) {
      context.handle(
          _openSessionMeta,
          openSession.isAcceptableOrUnknown(
              data['open_session']!, _openSessionMeta));
    }
    if (data.containsKey('magic_number')) {
      context.handle(
          _magicNumberMeta,
          magicNumber.isAcceptableOrUnknown(
              data['magic_number']!, _magicNumberMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('close_date')) {
      context.handle(_closeDateMeta,
          closeDate.isAcceptableOrUnknown(data['close_date']!, _closeDateMeta));
    } else if (isInserting) {
      context.missing(_closeDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClosedTrade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClosedTrade(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      oandaTradeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}oanda_trade_id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direction'])!,
      lots: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lots'])!,
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}units'])!,
      openPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}open_price'])!,
      closePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}close_price'])!,
      stopLoss: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stop_loss']),
      takeProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}take_profit']),
      realizedPnl: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}realized_pnl'])!,
      swap: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}swap'])!,
      commission: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}commission'])!,
      netProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_profit'])!,
      maxProfit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_profit']),
      maxDrawdown: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_drawdown']),
      priceDeltaPips: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}price_delta_pips']),
      closeReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}close_reason'])!,
      openTimeUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}open_time_us'])!,
      closeTimeUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}close_time_us'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      openSession: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}open_session']),
      magicNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}magic_number'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      closeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}close_date'])!,
    );
  }

  @override
  $ClosedTradesTable createAlias(String alias) {
    return $ClosedTradesTable(attachedDatabase, alias);
  }
}

class ClosedTrade extends DataClass implements Insertable<ClosedTrade> {
  final int id;

  /// OANDA Trade ID (links to original position)
  final String oandaTradeId;
  final String symbol;

  /// "BUY" or "SELL"
  final String direction;
  final double lots;
  final double units;

  /// Price at which position was opened
  final double openPrice;

  /// Price at which position was closed
  final double closePrice;
  final double? stopLoss;
  final double? takeProfit;

  /// Realized P&L in account currency (positive = profit)
  final double realizedPnl;

  /// Accumulated swap charges over holding period
  final double swap;

  /// Commission paid (if applicable)
  final double commission;

  /// Net profit = realizedPnl + swap - commission
  final double netProfit;

  /// Maximum favorable excursion (highest unrealized profit during trade)
  final double? maxProfit;

  /// Maximum adverse excursion (deepest drawdown during trade)
  final double? maxDrawdown;

  /// Price distance between open and close (in pips)
  final double? priceDeltaPips;

  /// How the trade was closed:
  /// "MANUAL", "STOP_LOSS", "TAKE_PROFIT", "EA_CLOSE",
  /// "MARGIN_CALL", "TRAILING_STOP", "EXPIRED"
  final String closeReason;

  /// When the position was opened (microseconds UTC)
  final int openTimeUs;

  /// When the position was closed (microseconds UTC)
  final int closeTimeUs;

  /// Holding duration in seconds (closeTimeUs - openTimeUs) / 1,000,000
  final int durationSeconds;

  /// Trading session at time of open: "SYDNEY", "TOKYO", "LONDON", "NEW_YORK"
  final String? openSession;
  final int magicNumber;
  final String comment;

  /// Date string "YYYY-MM-DD" for fast daily aggregation queries
  final String closeDate;
  const ClosedTrade(
      {required this.id,
      required this.oandaTradeId,
      required this.symbol,
      required this.direction,
      required this.lots,
      required this.units,
      required this.openPrice,
      required this.closePrice,
      this.stopLoss,
      this.takeProfit,
      required this.realizedPnl,
      required this.swap,
      required this.commission,
      required this.netProfit,
      this.maxProfit,
      this.maxDrawdown,
      this.priceDeltaPips,
      required this.closeReason,
      required this.openTimeUs,
      required this.closeTimeUs,
      required this.durationSeconds,
      this.openSession,
      required this.magicNumber,
      required this.comment,
      required this.closeDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['oanda_trade_id'] = Variable<String>(oandaTradeId);
    map['symbol'] = Variable<String>(symbol);
    map['direction'] = Variable<String>(direction);
    map['lots'] = Variable<double>(lots);
    map['units'] = Variable<double>(units);
    map['open_price'] = Variable<double>(openPrice);
    map['close_price'] = Variable<double>(closePrice);
    if (!nullToAbsent || stopLoss != null) {
      map['stop_loss'] = Variable<double>(stopLoss);
    }
    if (!nullToAbsent || takeProfit != null) {
      map['take_profit'] = Variable<double>(takeProfit);
    }
    map['realized_pnl'] = Variable<double>(realizedPnl);
    map['swap'] = Variable<double>(swap);
    map['commission'] = Variable<double>(commission);
    map['net_profit'] = Variable<double>(netProfit);
    if (!nullToAbsent || maxProfit != null) {
      map['max_profit'] = Variable<double>(maxProfit);
    }
    if (!nullToAbsent || maxDrawdown != null) {
      map['max_drawdown'] = Variable<double>(maxDrawdown);
    }
    if (!nullToAbsent || priceDeltaPips != null) {
      map['price_delta_pips'] = Variable<double>(priceDeltaPips);
    }
    map['close_reason'] = Variable<String>(closeReason);
    map['open_time_us'] = Variable<int>(openTimeUs);
    map['close_time_us'] = Variable<int>(closeTimeUs);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || openSession != null) {
      map['open_session'] = Variable<String>(openSession);
    }
    map['magic_number'] = Variable<int>(magicNumber);
    map['comment'] = Variable<String>(comment);
    map['close_date'] = Variable<String>(closeDate);
    return map;
  }

  ClosedTradesCompanion toCompanion(bool nullToAbsent) {
    return ClosedTradesCompanion(
      id: Value(id),
      oandaTradeId: Value(oandaTradeId),
      symbol: Value(symbol),
      direction: Value(direction),
      lots: Value(lots),
      units: Value(units),
      openPrice: Value(openPrice),
      closePrice: Value(closePrice),
      stopLoss: stopLoss == null && nullToAbsent
          ? const Value.absent()
          : Value(stopLoss),
      takeProfit: takeProfit == null && nullToAbsent
          ? const Value.absent()
          : Value(takeProfit),
      realizedPnl: Value(realizedPnl),
      swap: Value(swap),
      commission: Value(commission),
      netProfit: Value(netProfit),
      maxProfit: maxProfit == null && nullToAbsent
          ? const Value.absent()
          : Value(maxProfit),
      maxDrawdown: maxDrawdown == null && nullToAbsent
          ? const Value.absent()
          : Value(maxDrawdown),
      priceDeltaPips: priceDeltaPips == null && nullToAbsent
          ? const Value.absent()
          : Value(priceDeltaPips),
      closeReason: Value(closeReason),
      openTimeUs: Value(openTimeUs),
      closeTimeUs: Value(closeTimeUs),
      durationSeconds: Value(durationSeconds),
      openSession: openSession == null && nullToAbsent
          ? const Value.absent()
          : Value(openSession),
      magicNumber: Value(magicNumber),
      comment: Value(comment),
      closeDate: Value(closeDate),
    );
  }

  factory ClosedTrade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClosedTrade(
      id: serializer.fromJson<int>(json['id']),
      oandaTradeId: serializer.fromJson<String>(json['oandaTradeId']),
      symbol: serializer.fromJson<String>(json['symbol']),
      direction: serializer.fromJson<String>(json['direction']),
      lots: serializer.fromJson<double>(json['lots']),
      units: serializer.fromJson<double>(json['units']),
      openPrice: serializer.fromJson<double>(json['openPrice']),
      closePrice: serializer.fromJson<double>(json['closePrice']),
      stopLoss: serializer.fromJson<double?>(json['stopLoss']),
      takeProfit: serializer.fromJson<double?>(json['takeProfit']),
      realizedPnl: serializer.fromJson<double>(json['realizedPnl']),
      swap: serializer.fromJson<double>(json['swap']),
      commission: serializer.fromJson<double>(json['commission']),
      netProfit: serializer.fromJson<double>(json['netProfit']),
      maxProfit: serializer.fromJson<double?>(json['maxProfit']),
      maxDrawdown: serializer.fromJson<double?>(json['maxDrawdown']),
      priceDeltaPips: serializer.fromJson<double?>(json['priceDeltaPips']),
      closeReason: serializer.fromJson<String>(json['closeReason']),
      openTimeUs: serializer.fromJson<int>(json['openTimeUs']),
      closeTimeUs: serializer.fromJson<int>(json['closeTimeUs']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      openSession: serializer.fromJson<String?>(json['openSession']),
      magicNumber: serializer.fromJson<int>(json['magicNumber']),
      comment: serializer.fromJson<String>(json['comment']),
      closeDate: serializer.fromJson<String>(json['closeDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'oandaTradeId': serializer.toJson<String>(oandaTradeId),
      'symbol': serializer.toJson<String>(symbol),
      'direction': serializer.toJson<String>(direction),
      'lots': serializer.toJson<double>(lots),
      'units': serializer.toJson<double>(units),
      'openPrice': serializer.toJson<double>(openPrice),
      'closePrice': serializer.toJson<double>(closePrice),
      'stopLoss': serializer.toJson<double?>(stopLoss),
      'takeProfit': serializer.toJson<double?>(takeProfit),
      'realizedPnl': serializer.toJson<double>(realizedPnl),
      'swap': serializer.toJson<double>(swap),
      'commission': serializer.toJson<double>(commission),
      'netProfit': serializer.toJson<double>(netProfit),
      'maxProfit': serializer.toJson<double?>(maxProfit),
      'maxDrawdown': serializer.toJson<double?>(maxDrawdown),
      'priceDeltaPips': serializer.toJson<double?>(priceDeltaPips),
      'closeReason': serializer.toJson<String>(closeReason),
      'openTimeUs': serializer.toJson<int>(openTimeUs),
      'closeTimeUs': serializer.toJson<int>(closeTimeUs),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'openSession': serializer.toJson<String?>(openSession),
      'magicNumber': serializer.toJson<int>(magicNumber),
      'comment': serializer.toJson<String>(comment),
      'closeDate': serializer.toJson<String>(closeDate),
    };
  }

  ClosedTrade copyWith(
          {int? id,
          String? oandaTradeId,
          String? symbol,
          String? direction,
          double? lots,
          double? units,
          double? openPrice,
          double? closePrice,
          Value<double?> stopLoss = const Value.absent(),
          Value<double?> takeProfit = const Value.absent(),
          double? realizedPnl,
          double? swap,
          double? commission,
          double? netProfit,
          Value<double?> maxProfit = const Value.absent(),
          Value<double?> maxDrawdown = const Value.absent(),
          Value<double?> priceDeltaPips = const Value.absent(),
          String? closeReason,
          int? openTimeUs,
          int? closeTimeUs,
          int? durationSeconds,
          Value<String?> openSession = const Value.absent(),
          int? magicNumber,
          String? comment,
          String? closeDate}) =>
      ClosedTrade(
        id: id ?? this.id,
        oandaTradeId: oandaTradeId ?? this.oandaTradeId,
        symbol: symbol ?? this.symbol,
        direction: direction ?? this.direction,
        lots: lots ?? this.lots,
        units: units ?? this.units,
        openPrice: openPrice ?? this.openPrice,
        closePrice: closePrice ?? this.closePrice,
        stopLoss: stopLoss.present ? stopLoss.value : this.stopLoss,
        takeProfit: takeProfit.present ? takeProfit.value : this.takeProfit,
        realizedPnl: realizedPnl ?? this.realizedPnl,
        swap: swap ?? this.swap,
        commission: commission ?? this.commission,
        netProfit: netProfit ?? this.netProfit,
        maxProfit: maxProfit.present ? maxProfit.value : this.maxProfit,
        maxDrawdown: maxDrawdown.present ? maxDrawdown.value : this.maxDrawdown,
        priceDeltaPips:
            priceDeltaPips.present ? priceDeltaPips.value : this.priceDeltaPips,
        closeReason: closeReason ?? this.closeReason,
        openTimeUs: openTimeUs ?? this.openTimeUs,
        closeTimeUs: closeTimeUs ?? this.closeTimeUs,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        openSession: openSession.present ? openSession.value : this.openSession,
        magicNumber: magicNumber ?? this.magicNumber,
        comment: comment ?? this.comment,
        closeDate: closeDate ?? this.closeDate,
      );
  ClosedTrade copyWithCompanion(ClosedTradesCompanion data) {
    return ClosedTrade(
      id: data.id.present ? data.id.value : this.id,
      oandaTradeId: data.oandaTradeId.present
          ? data.oandaTradeId.value
          : this.oandaTradeId,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      direction: data.direction.present ? data.direction.value : this.direction,
      lots: data.lots.present ? data.lots.value : this.lots,
      units: data.units.present ? data.units.value : this.units,
      openPrice: data.openPrice.present ? data.openPrice.value : this.openPrice,
      closePrice:
          data.closePrice.present ? data.closePrice.value : this.closePrice,
      stopLoss: data.stopLoss.present ? data.stopLoss.value : this.stopLoss,
      takeProfit:
          data.takeProfit.present ? data.takeProfit.value : this.takeProfit,
      realizedPnl:
          data.realizedPnl.present ? data.realizedPnl.value : this.realizedPnl,
      swap: data.swap.present ? data.swap.value : this.swap,
      commission:
          data.commission.present ? data.commission.value : this.commission,
      netProfit: data.netProfit.present ? data.netProfit.value : this.netProfit,
      maxProfit: data.maxProfit.present ? data.maxProfit.value : this.maxProfit,
      maxDrawdown:
          data.maxDrawdown.present ? data.maxDrawdown.value : this.maxDrawdown,
      priceDeltaPips: data.priceDeltaPips.present
          ? data.priceDeltaPips.value
          : this.priceDeltaPips,
      closeReason:
          data.closeReason.present ? data.closeReason.value : this.closeReason,
      openTimeUs:
          data.openTimeUs.present ? data.openTimeUs.value : this.openTimeUs,
      closeTimeUs:
          data.closeTimeUs.present ? data.closeTimeUs.value : this.closeTimeUs,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      openSession:
          data.openSession.present ? data.openSession.value : this.openSession,
      magicNumber:
          data.magicNumber.present ? data.magicNumber.value : this.magicNumber,
      comment: data.comment.present ? data.comment.value : this.comment,
      closeDate: data.closeDate.present ? data.closeDate.value : this.closeDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClosedTrade(')
          ..write('id: $id, ')
          ..write('oandaTradeId: $oandaTradeId, ')
          ..write('symbol: $symbol, ')
          ..write('direction: $direction, ')
          ..write('lots: $lots, ')
          ..write('units: $units, ')
          ..write('openPrice: $openPrice, ')
          ..write('closePrice: $closePrice, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('realizedPnl: $realizedPnl, ')
          ..write('swap: $swap, ')
          ..write('commission: $commission, ')
          ..write('netProfit: $netProfit, ')
          ..write('maxProfit: $maxProfit, ')
          ..write('maxDrawdown: $maxDrawdown, ')
          ..write('priceDeltaPips: $priceDeltaPips, ')
          ..write('closeReason: $closeReason, ')
          ..write('openTimeUs: $openTimeUs, ')
          ..write('closeTimeUs: $closeTimeUs, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('openSession: $openSession, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('comment: $comment, ')
          ..write('closeDate: $closeDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        oandaTradeId,
        symbol,
        direction,
        lots,
        units,
        openPrice,
        closePrice,
        stopLoss,
        takeProfit,
        realizedPnl,
        swap,
        commission,
        netProfit,
        maxProfit,
        maxDrawdown,
        priceDeltaPips,
        closeReason,
        openTimeUs,
        closeTimeUs,
        durationSeconds,
        openSession,
        magicNumber,
        comment,
        closeDate
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClosedTrade &&
          other.id == this.id &&
          other.oandaTradeId == this.oandaTradeId &&
          other.symbol == this.symbol &&
          other.direction == this.direction &&
          other.lots == this.lots &&
          other.units == this.units &&
          other.openPrice == this.openPrice &&
          other.closePrice == this.closePrice &&
          other.stopLoss == this.stopLoss &&
          other.takeProfit == this.takeProfit &&
          other.realizedPnl == this.realizedPnl &&
          other.swap == this.swap &&
          other.commission == this.commission &&
          other.netProfit == this.netProfit &&
          other.maxProfit == this.maxProfit &&
          other.maxDrawdown == this.maxDrawdown &&
          other.priceDeltaPips == this.priceDeltaPips &&
          other.closeReason == this.closeReason &&
          other.openTimeUs == this.openTimeUs &&
          other.closeTimeUs == this.closeTimeUs &&
          other.durationSeconds == this.durationSeconds &&
          other.openSession == this.openSession &&
          other.magicNumber == this.magicNumber &&
          other.comment == this.comment &&
          other.closeDate == this.closeDate);
}

class ClosedTradesCompanion extends UpdateCompanion<ClosedTrade> {
  final Value<int> id;
  final Value<String> oandaTradeId;
  final Value<String> symbol;
  final Value<String> direction;
  final Value<double> lots;
  final Value<double> units;
  final Value<double> openPrice;
  final Value<double> closePrice;
  final Value<double?> stopLoss;
  final Value<double?> takeProfit;
  final Value<double> realizedPnl;
  final Value<double> swap;
  final Value<double> commission;
  final Value<double> netProfit;
  final Value<double?> maxProfit;
  final Value<double?> maxDrawdown;
  final Value<double?> priceDeltaPips;
  final Value<String> closeReason;
  final Value<int> openTimeUs;
  final Value<int> closeTimeUs;
  final Value<int> durationSeconds;
  final Value<String?> openSession;
  final Value<int> magicNumber;
  final Value<String> comment;
  final Value<String> closeDate;
  const ClosedTradesCompanion({
    this.id = const Value.absent(),
    this.oandaTradeId = const Value.absent(),
    this.symbol = const Value.absent(),
    this.direction = const Value.absent(),
    this.lots = const Value.absent(),
    this.units = const Value.absent(),
    this.openPrice = const Value.absent(),
    this.closePrice = const Value.absent(),
    this.stopLoss = const Value.absent(),
    this.takeProfit = const Value.absent(),
    this.realizedPnl = const Value.absent(),
    this.swap = const Value.absent(),
    this.commission = const Value.absent(),
    this.netProfit = const Value.absent(),
    this.maxProfit = const Value.absent(),
    this.maxDrawdown = const Value.absent(),
    this.priceDeltaPips = const Value.absent(),
    this.closeReason = const Value.absent(),
    this.openTimeUs = const Value.absent(),
    this.closeTimeUs = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.openSession = const Value.absent(),
    this.magicNumber = const Value.absent(),
    this.comment = const Value.absent(),
    this.closeDate = const Value.absent(),
  });
  ClosedTradesCompanion.insert({
    this.id = const Value.absent(),
    required String oandaTradeId,
    required String symbol,
    required String direction,
    required double lots,
    required double units,
    required double openPrice,
    required double closePrice,
    this.stopLoss = const Value.absent(),
    this.takeProfit = const Value.absent(),
    required double realizedPnl,
    this.swap = const Value.absent(),
    this.commission = const Value.absent(),
    required double netProfit,
    this.maxProfit = const Value.absent(),
    this.maxDrawdown = const Value.absent(),
    this.priceDeltaPips = const Value.absent(),
    this.closeReason = const Value.absent(),
    required int openTimeUs,
    required int closeTimeUs,
    required int durationSeconds,
    this.openSession = const Value.absent(),
    this.magicNumber = const Value.absent(),
    this.comment = const Value.absent(),
    required String closeDate,
  })  : oandaTradeId = Value(oandaTradeId),
        symbol = Value(symbol),
        direction = Value(direction),
        lots = Value(lots),
        units = Value(units),
        openPrice = Value(openPrice),
        closePrice = Value(closePrice),
        realizedPnl = Value(realizedPnl),
        netProfit = Value(netProfit),
        openTimeUs = Value(openTimeUs),
        closeTimeUs = Value(closeTimeUs),
        durationSeconds = Value(durationSeconds),
        closeDate = Value(closeDate);
  static Insertable<ClosedTrade> custom({
    Expression<int>? id,
    Expression<String>? oandaTradeId,
    Expression<String>? symbol,
    Expression<String>? direction,
    Expression<double>? lots,
    Expression<double>? units,
    Expression<double>? openPrice,
    Expression<double>? closePrice,
    Expression<double>? stopLoss,
    Expression<double>? takeProfit,
    Expression<double>? realizedPnl,
    Expression<double>? swap,
    Expression<double>? commission,
    Expression<double>? netProfit,
    Expression<double>? maxProfit,
    Expression<double>? maxDrawdown,
    Expression<double>? priceDeltaPips,
    Expression<String>? closeReason,
    Expression<int>? openTimeUs,
    Expression<int>? closeTimeUs,
    Expression<int>? durationSeconds,
    Expression<String>? openSession,
    Expression<int>? magicNumber,
    Expression<String>? comment,
    Expression<String>? closeDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (oandaTradeId != null) 'oanda_trade_id': oandaTradeId,
      if (symbol != null) 'symbol': symbol,
      if (direction != null) 'direction': direction,
      if (lots != null) 'lots': lots,
      if (units != null) 'units': units,
      if (openPrice != null) 'open_price': openPrice,
      if (closePrice != null) 'close_price': closePrice,
      if (stopLoss != null) 'stop_loss': stopLoss,
      if (takeProfit != null) 'take_profit': takeProfit,
      if (realizedPnl != null) 'realized_pnl': realizedPnl,
      if (swap != null) 'swap': swap,
      if (commission != null) 'commission': commission,
      if (netProfit != null) 'net_profit': netProfit,
      if (maxProfit != null) 'max_profit': maxProfit,
      if (maxDrawdown != null) 'max_drawdown': maxDrawdown,
      if (priceDeltaPips != null) 'price_delta_pips': priceDeltaPips,
      if (closeReason != null) 'close_reason': closeReason,
      if (openTimeUs != null) 'open_time_us': openTimeUs,
      if (closeTimeUs != null) 'close_time_us': closeTimeUs,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (openSession != null) 'open_session': openSession,
      if (magicNumber != null) 'magic_number': magicNumber,
      if (comment != null) 'comment': comment,
      if (closeDate != null) 'close_date': closeDate,
    });
  }

  ClosedTradesCompanion copyWith(
      {Value<int>? id,
      Value<String>? oandaTradeId,
      Value<String>? symbol,
      Value<String>? direction,
      Value<double>? lots,
      Value<double>? units,
      Value<double>? openPrice,
      Value<double>? closePrice,
      Value<double?>? stopLoss,
      Value<double?>? takeProfit,
      Value<double>? realizedPnl,
      Value<double>? swap,
      Value<double>? commission,
      Value<double>? netProfit,
      Value<double?>? maxProfit,
      Value<double?>? maxDrawdown,
      Value<double?>? priceDeltaPips,
      Value<String>? closeReason,
      Value<int>? openTimeUs,
      Value<int>? closeTimeUs,
      Value<int>? durationSeconds,
      Value<String?>? openSession,
      Value<int>? magicNumber,
      Value<String>? comment,
      Value<String>? closeDate}) {
    return ClosedTradesCompanion(
      id: id ?? this.id,
      oandaTradeId: oandaTradeId ?? this.oandaTradeId,
      symbol: symbol ?? this.symbol,
      direction: direction ?? this.direction,
      lots: lots ?? this.lots,
      units: units ?? this.units,
      openPrice: openPrice ?? this.openPrice,
      closePrice: closePrice ?? this.closePrice,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      realizedPnl: realizedPnl ?? this.realizedPnl,
      swap: swap ?? this.swap,
      commission: commission ?? this.commission,
      netProfit: netProfit ?? this.netProfit,
      maxProfit: maxProfit ?? this.maxProfit,
      maxDrawdown: maxDrawdown ?? this.maxDrawdown,
      priceDeltaPips: priceDeltaPips ?? this.priceDeltaPips,
      closeReason: closeReason ?? this.closeReason,
      openTimeUs: openTimeUs ?? this.openTimeUs,
      closeTimeUs: closeTimeUs ?? this.closeTimeUs,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      openSession: openSession ?? this.openSession,
      magicNumber: magicNumber ?? this.magicNumber,
      comment: comment ?? this.comment,
      closeDate: closeDate ?? this.closeDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (oandaTradeId.present) {
      map['oanda_trade_id'] = Variable<String>(oandaTradeId.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (lots.present) {
      map['lots'] = Variable<double>(lots.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (openPrice.present) {
      map['open_price'] = Variable<double>(openPrice.value);
    }
    if (closePrice.present) {
      map['close_price'] = Variable<double>(closePrice.value);
    }
    if (stopLoss.present) {
      map['stop_loss'] = Variable<double>(stopLoss.value);
    }
    if (takeProfit.present) {
      map['take_profit'] = Variable<double>(takeProfit.value);
    }
    if (realizedPnl.present) {
      map['realized_pnl'] = Variable<double>(realizedPnl.value);
    }
    if (swap.present) {
      map['swap'] = Variable<double>(swap.value);
    }
    if (commission.present) {
      map['commission'] = Variable<double>(commission.value);
    }
    if (netProfit.present) {
      map['net_profit'] = Variable<double>(netProfit.value);
    }
    if (maxProfit.present) {
      map['max_profit'] = Variable<double>(maxProfit.value);
    }
    if (maxDrawdown.present) {
      map['max_drawdown'] = Variable<double>(maxDrawdown.value);
    }
    if (priceDeltaPips.present) {
      map['price_delta_pips'] = Variable<double>(priceDeltaPips.value);
    }
    if (closeReason.present) {
      map['close_reason'] = Variable<String>(closeReason.value);
    }
    if (openTimeUs.present) {
      map['open_time_us'] = Variable<int>(openTimeUs.value);
    }
    if (closeTimeUs.present) {
      map['close_time_us'] = Variable<int>(closeTimeUs.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (openSession.present) {
      map['open_session'] = Variable<String>(openSession.value);
    }
    if (magicNumber.present) {
      map['magic_number'] = Variable<int>(magicNumber.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (closeDate.present) {
      map['close_date'] = Variable<String>(closeDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClosedTradesCompanion(')
          ..write('id: $id, ')
          ..write('oandaTradeId: $oandaTradeId, ')
          ..write('symbol: $symbol, ')
          ..write('direction: $direction, ')
          ..write('lots: $lots, ')
          ..write('units: $units, ')
          ..write('openPrice: $openPrice, ')
          ..write('closePrice: $closePrice, ')
          ..write('stopLoss: $stopLoss, ')
          ..write('takeProfit: $takeProfit, ')
          ..write('realizedPnl: $realizedPnl, ')
          ..write('swap: $swap, ')
          ..write('commission: $commission, ')
          ..write('netProfit: $netProfit, ')
          ..write('maxProfit: $maxProfit, ')
          ..write('maxDrawdown: $maxDrawdown, ')
          ..write('priceDeltaPips: $priceDeltaPips, ')
          ..write('closeReason: $closeReason, ')
          ..write('openTimeUs: $openTimeUs, ')
          ..write('closeTimeUs: $closeTimeUs, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('openSession: $openSession, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('comment: $comment, ')
          ..write('closeDate: $closeDate')
          ..write(')'))
        .toString();
  }
}

class $AccountSnapshotsTable extends AccountSnapshots
    with TableInfo<$AccountSnapshotsTable, AccountSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _equityMeta = const VerificationMeta('equity');
  @override
  late final GeneratedColumn<double> equity = GeneratedColumn<double>(
      'equity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _marginUsedMeta =
      const VerificationMeta('marginUsed');
  @override
  late final GeneratedColumn<double> marginUsed = GeneratedColumn<double>(
      'margin_used', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _marginAvailableMeta =
      const VerificationMeta('marginAvailable');
  @override
  late final GeneratedColumn<double> marginAvailable = GeneratedColumn<double>(
      'margin_available', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _marginLevelMeta =
      const VerificationMeta('marginLevel');
  @override
  late final GeneratedColumn<double> marginLevel = GeneratedColumn<double>(
      'margin_level', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _navMeta = const VerificationMeta('nav');
  @override
  late final GeneratedColumn<double> nav = GeneratedColumn<double>(
      'nav', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _openPositionCountMeta =
      const VerificationMeta('openPositionCount');
  @override
  late final GeneratedColumn<int> openPositionCount = GeneratedColumn<int>(
      'open_position_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unrealizedPnlMeta =
      const VerificationMeta('unrealizedPnl');
  @override
  late final GeneratedColumn<double> unrealizedPnl = GeneratedColumn<double>(
      'unrealized_pnl', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dailyRealizedPnlMeta =
      const VerificationMeta('dailyRealizedPnl');
  @override
  late final GeneratedColumn<double> dailyRealizedPnl = GeneratedColumn<double>(
      'daily_realized_pnl', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _snapshotTriggerMeta =
      const VerificationMeta('snapshotTrigger');
  @override
  late final GeneratedColumn<String> snapshotTrigger = GeneratedColumn<String>(
      'snapshot_trigger', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PERIODIC'));
  static const VerificationMeta _timestampUsMeta =
      const VerificationMeta('timestampUs');
  @override
  late final GeneratedColumn<int> timestampUs = GeneratedColumn<int>(
      'timestamp_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        balance,
        equity,
        marginUsed,
        marginAvailable,
        marginLevel,
        nav,
        openPositionCount,
        unrealizedPnl,
        dailyRealizedPnl,
        snapshotTrigger,
        timestampUs,
        date
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<AccountSnapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('equity')) {
      context.handle(_equityMeta,
          equity.isAcceptableOrUnknown(data['equity']!, _equityMeta));
    } else if (isInserting) {
      context.missing(_equityMeta);
    }
    if (data.containsKey('margin_used')) {
      context.handle(
          _marginUsedMeta,
          marginUsed.isAcceptableOrUnknown(
              data['margin_used']!, _marginUsedMeta));
    } else if (isInserting) {
      context.missing(_marginUsedMeta);
    }
    if (data.containsKey('margin_available')) {
      context.handle(
          _marginAvailableMeta,
          marginAvailable.isAcceptableOrUnknown(
              data['margin_available']!, _marginAvailableMeta));
    } else if (isInserting) {
      context.missing(_marginAvailableMeta);
    }
    if (data.containsKey('margin_level')) {
      context.handle(
          _marginLevelMeta,
          marginLevel.isAcceptableOrUnknown(
              data['margin_level']!, _marginLevelMeta));
    }
    if (data.containsKey('nav')) {
      context.handle(
          _navMeta, nav.isAcceptableOrUnknown(data['nav']!, _navMeta));
    }
    if (data.containsKey('open_position_count')) {
      context.handle(
          _openPositionCountMeta,
          openPositionCount.isAcceptableOrUnknown(
              data['open_position_count']!, _openPositionCountMeta));
    }
    if (data.containsKey('unrealized_pnl')) {
      context.handle(
          _unrealizedPnlMeta,
          unrealizedPnl.isAcceptableOrUnknown(
              data['unrealized_pnl']!, _unrealizedPnlMeta));
    }
    if (data.containsKey('daily_realized_pnl')) {
      context.handle(
          _dailyRealizedPnlMeta,
          dailyRealizedPnl.isAcceptableOrUnknown(
              data['daily_realized_pnl']!, _dailyRealizedPnlMeta));
    }
    if (data.containsKey('snapshot_trigger')) {
      context.handle(
          _snapshotTriggerMeta,
          snapshotTrigger.isAcceptableOrUnknown(
              data['snapshot_trigger']!, _snapshotTriggerMeta));
    }
    if (data.containsKey('timestamp_us')) {
      context.handle(
          _timestampUsMeta,
          timestampUs.isAcceptableOrUnknown(
              data['timestamp_us']!, _timestampUsMeta));
    } else if (isInserting) {
      context.missing(_timestampUsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {accountId, timestampUs},
      ];
  @override
  AccountSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountSnapshot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      equity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}equity'])!,
      marginUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}margin_used'])!,
      marginAvailable: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}margin_available'])!,
      marginLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}margin_level']),
      nav: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nav']),
      openPositionCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}open_position_count'])!,
      unrealizedPnl: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unrealized_pnl'])!,
      dailyRealizedPnl: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}daily_realized_pnl'])!,
      snapshotTrigger: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}snapshot_trigger'])!,
      timestampUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp_us'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $AccountSnapshotsTable createAlias(String alias) {
    return $AccountSnapshotsTable(attachedDatabase, alias);
  }
}

class AccountSnapshot extends DataClass implements Insertable<AccountSnapshot> {
  final int id;
  final String accountId;
  final double balance;
  final double equity;
  final double marginUsed;
  final double marginAvailable;
  final double? marginLevel;
  final double? nav;
  final int openPositionCount;
  final double unrealizedPnl;
  final double dailyRealizedPnl;
  final String snapshotTrigger;
  final int timestampUs;
  final String date;
  const AccountSnapshot(
      {required this.id,
      required this.accountId,
      required this.balance,
      required this.equity,
      required this.marginUsed,
      required this.marginAvailable,
      this.marginLevel,
      this.nav,
      required this.openPositionCount,
      required this.unrealizedPnl,
      required this.dailyRealizedPnl,
      required this.snapshotTrigger,
      required this.timestampUs,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<String>(accountId);
    map['balance'] = Variable<double>(balance);
    map['equity'] = Variable<double>(equity);
    map['margin_used'] = Variable<double>(marginUsed);
    map['margin_available'] = Variable<double>(marginAvailable);
    if (!nullToAbsent || marginLevel != null) {
      map['margin_level'] = Variable<double>(marginLevel);
    }
    if (!nullToAbsent || nav != null) {
      map['nav'] = Variable<double>(nav);
    }
    map['open_position_count'] = Variable<int>(openPositionCount);
    map['unrealized_pnl'] = Variable<double>(unrealizedPnl);
    map['daily_realized_pnl'] = Variable<double>(dailyRealizedPnl);
    map['snapshot_trigger'] = Variable<String>(snapshotTrigger);
    map['timestamp_us'] = Variable<int>(timestampUs);
    map['date'] = Variable<String>(date);
    return map;
  }

  AccountSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return AccountSnapshotsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      balance: Value(balance),
      equity: Value(equity),
      marginUsed: Value(marginUsed),
      marginAvailable: Value(marginAvailable),
      marginLevel: marginLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(marginLevel),
      nav: nav == null && nullToAbsent ? const Value.absent() : Value(nav),
      openPositionCount: Value(openPositionCount),
      unrealizedPnl: Value(unrealizedPnl),
      dailyRealizedPnl: Value(dailyRealizedPnl),
      snapshotTrigger: Value(snapshotTrigger),
      timestampUs: Value(timestampUs),
      date: Value(date),
    );
  }

  factory AccountSnapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountSnapshot(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      balance: serializer.fromJson<double>(json['balance']),
      equity: serializer.fromJson<double>(json['equity']),
      marginUsed: serializer.fromJson<double>(json['marginUsed']),
      marginAvailable: serializer.fromJson<double>(json['marginAvailable']),
      marginLevel: serializer.fromJson<double?>(json['marginLevel']),
      nav: serializer.fromJson<double?>(json['nav']),
      openPositionCount: serializer.fromJson<int>(json['openPositionCount']),
      unrealizedPnl: serializer.fromJson<double>(json['unrealizedPnl']),
      dailyRealizedPnl: serializer.fromJson<double>(json['dailyRealizedPnl']),
      snapshotTrigger: serializer.fromJson<String>(json['snapshotTrigger']),
      timestampUs: serializer.fromJson<int>(json['timestampUs']),
      date: serializer.fromJson<String>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<String>(accountId),
      'balance': serializer.toJson<double>(balance),
      'equity': serializer.toJson<double>(equity),
      'marginUsed': serializer.toJson<double>(marginUsed),
      'marginAvailable': serializer.toJson<double>(marginAvailable),
      'marginLevel': serializer.toJson<double?>(marginLevel),
      'nav': serializer.toJson<double?>(nav),
      'openPositionCount': serializer.toJson<int>(openPositionCount),
      'unrealizedPnl': serializer.toJson<double>(unrealizedPnl),
      'dailyRealizedPnl': serializer.toJson<double>(dailyRealizedPnl),
      'snapshotTrigger': serializer.toJson<String>(snapshotTrigger),
      'timestampUs': serializer.toJson<int>(timestampUs),
      'date': serializer.toJson<String>(date),
    };
  }

  AccountSnapshot copyWith(
          {int? id,
          String? accountId,
          double? balance,
          double? equity,
          double? marginUsed,
          double? marginAvailable,
          Value<double?> marginLevel = const Value.absent(),
          Value<double?> nav = const Value.absent(),
          int? openPositionCount,
          double? unrealizedPnl,
          double? dailyRealizedPnl,
          String? snapshotTrigger,
          int? timestampUs,
          String? date}) =>
      AccountSnapshot(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        balance: balance ?? this.balance,
        equity: equity ?? this.equity,
        marginUsed: marginUsed ?? this.marginUsed,
        marginAvailable: marginAvailable ?? this.marginAvailable,
        marginLevel: marginLevel.present ? marginLevel.value : this.marginLevel,
        nav: nav.present ? nav.value : this.nav,
        openPositionCount: openPositionCount ?? this.openPositionCount,
        unrealizedPnl: unrealizedPnl ?? this.unrealizedPnl,
        dailyRealizedPnl: dailyRealizedPnl ?? this.dailyRealizedPnl,
        snapshotTrigger: snapshotTrigger ?? this.snapshotTrigger,
        timestampUs: timestampUs ?? this.timestampUs,
        date: date ?? this.date,
      );
  AccountSnapshot copyWithCompanion(AccountSnapshotsCompanion data) {
    return AccountSnapshot(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      balance: data.balance.present ? data.balance.value : this.balance,
      equity: data.equity.present ? data.equity.value : this.equity,
      marginUsed:
          data.marginUsed.present ? data.marginUsed.value : this.marginUsed,
      marginAvailable: data.marginAvailable.present
          ? data.marginAvailable.value
          : this.marginAvailable,
      marginLevel:
          data.marginLevel.present ? data.marginLevel.value : this.marginLevel,
      nav: data.nav.present ? data.nav.value : this.nav,
      openPositionCount: data.openPositionCount.present
          ? data.openPositionCount.value
          : this.openPositionCount,
      unrealizedPnl: data.unrealizedPnl.present
          ? data.unrealizedPnl.value
          : this.unrealizedPnl,
      dailyRealizedPnl: data.dailyRealizedPnl.present
          ? data.dailyRealizedPnl.value
          : this.dailyRealizedPnl,
      snapshotTrigger: data.snapshotTrigger.present
          ? data.snapshotTrigger.value
          : this.snapshotTrigger,
      timestampUs:
          data.timestampUs.present ? data.timestampUs.value : this.timestampUs,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountSnapshot(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('balance: $balance, ')
          ..write('equity: $equity, ')
          ..write('marginUsed: $marginUsed, ')
          ..write('marginAvailable: $marginAvailable, ')
          ..write('marginLevel: $marginLevel, ')
          ..write('nav: $nav, ')
          ..write('openPositionCount: $openPositionCount, ')
          ..write('unrealizedPnl: $unrealizedPnl, ')
          ..write('dailyRealizedPnl: $dailyRealizedPnl, ')
          ..write('snapshotTrigger: $snapshotTrigger, ')
          ..write('timestampUs: $timestampUs, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountId,
      balance,
      equity,
      marginUsed,
      marginAvailable,
      marginLevel,
      nav,
      openPositionCount,
      unrealizedPnl,
      dailyRealizedPnl,
      snapshotTrigger,
      timestampUs,
      date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountSnapshot &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.balance == this.balance &&
          other.equity == this.equity &&
          other.marginUsed == this.marginUsed &&
          other.marginAvailable == this.marginAvailable &&
          other.marginLevel == this.marginLevel &&
          other.nav == this.nav &&
          other.openPositionCount == this.openPositionCount &&
          other.unrealizedPnl == this.unrealizedPnl &&
          other.dailyRealizedPnl == this.dailyRealizedPnl &&
          other.snapshotTrigger == this.snapshotTrigger &&
          other.timestampUs == this.timestampUs &&
          other.date == this.date);
}

class AccountSnapshotsCompanion extends UpdateCompanion<AccountSnapshot> {
  final Value<int> id;
  final Value<String> accountId;
  final Value<double> balance;
  final Value<double> equity;
  final Value<double> marginUsed;
  final Value<double> marginAvailable;
  final Value<double?> marginLevel;
  final Value<double?> nav;
  final Value<int> openPositionCount;
  final Value<double> unrealizedPnl;
  final Value<double> dailyRealizedPnl;
  final Value<String> snapshotTrigger;
  final Value<int> timestampUs;
  final Value<String> date;
  const AccountSnapshotsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.balance = const Value.absent(),
    this.equity = const Value.absent(),
    this.marginUsed = const Value.absent(),
    this.marginAvailable = const Value.absent(),
    this.marginLevel = const Value.absent(),
    this.nav = const Value.absent(),
    this.openPositionCount = const Value.absent(),
    this.unrealizedPnl = const Value.absent(),
    this.dailyRealizedPnl = const Value.absent(),
    this.snapshotTrigger = const Value.absent(),
    this.timestampUs = const Value.absent(),
    this.date = const Value.absent(),
  });
  AccountSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    required double balance,
    required double equity,
    required double marginUsed,
    required double marginAvailable,
    this.marginLevel = const Value.absent(),
    this.nav = const Value.absent(),
    this.openPositionCount = const Value.absent(),
    this.unrealizedPnl = const Value.absent(),
    this.dailyRealizedPnl = const Value.absent(),
    this.snapshotTrigger = const Value.absent(),
    required int timestampUs,
    required String date,
  })  : accountId = Value(accountId),
        balance = Value(balance),
        equity = Value(equity),
        marginUsed = Value(marginUsed),
        marginAvailable = Value(marginAvailable),
        timestampUs = Value(timestampUs),
        date = Value(date);
  static Insertable<AccountSnapshot> custom({
    Expression<int>? id,
    Expression<String>? accountId,
    Expression<double>? balance,
    Expression<double>? equity,
    Expression<double>? marginUsed,
    Expression<double>? marginAvailable,
    Expression<double>? marginLevel,
    Expression<double>? nav,
    Expression<int>? openPositionCount,
    Expression<double>? unrealizedPnl,
    Expression<double>? dailyRealizedPnl,
    Expression<String>? snapshotTrigger,
    Expression<int>? timestampUs,
    Expression<String>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (balance != null) 'balance': balance,
      if (equity != null) 'equity': equity,
      if (marginUsed != null) 'margin_used': marginUsed,
      if (marginAvailable != null) 'margin_available': marginAvailable,
      if (marginLevel != null) 'margin_level': marginLevel,
      if (nav != null) 'nav': nav,
      if (openPositionCount != null) 'open_position_count': openPositionCount,
      if (unrealizedPnl != null) 'unrealized_pnl': unrealizedPnl,
      if (dailyRealizedPnl != null) 'daily_realized_pnl': dailyRealizedPnl,
      if (snapshotTrigger != null) 'snapshot_trigger': snapshotTrigger,
      if (timestampUs != null) 'timestamp_us': timestampUs,
      if (date != null) 'date': date,
    });
  }

  AccountSnapshotsCompanion copyWith(
      {Value<int>? id,
      Value<String>? accountId,
      Value<double>? balance,
      Value<double>? equity,
      Value<double>? marginUsed,
      Value<double>? marginAvailable,
      Value<double?>? marginLevel,
      Value<double?>? nav,
      Value<int>? openPositionCount,
      Value<double>? unrealizedPnl,
      Value<double>? dailyRealizedPnl,
      Value<String>? snapshotTrigger,
      Value<int>? timestampUs,
      Value<String>? date}) {
    return AccountSnapshotsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      balance: balance ?? this.balance,
      equity: equity ?? this.equity,
      marginUsed: marginUsed ?? this.marginUsed,
      marginAvailable: marginAvailable ?? this.marginAvailable,
      marginLevel: marginLevel ?? this.marginLevel,
      nav: nav ?? this.nav,
      openPositionCount: openPositionCount ?? this.openPositionCount,
      unrealizedPnl: unrealizedPnl ?? this.unrealizedPnl,
      dailyRealizedPnl: dailyRealizedPnl ?? this.dailyRealizedPnl,
      snapshotTrigger: snapshotTrigger ?? this.snapshotTrigger,
      timestampUs: timestampUs ?? this.timestampUs,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (equity.present) {
      map['equity'] = Variable<double>(equity.value);
    }
    if (marginUsed.present) {
      map['margin_used'] = Variable<double>(marginUsed.value);
    }
    if (marginAvailable.present) {
      map['margin_available'] = Variable<double>(marginAvailable.value);
    }
    if (marginLevel.present) {
      map['margin_level'] = Variable<double>(marginLevel.value);
    }
    if (nav.present) {
      map['nav'] = Variable<double>(nav.value);
    }
    if (openPositionCount.present) {
      map['open_position_count'] = Variable<int>(openPositionCount.value);
    }
    if (unrealizedPnl.present) {
      map['unrealized_pnl'] = Variable<double>(unrealizedPnl.value);
    }
    if (dailyRealizedPnl.present) {
      map['daily_realized_pnl'] = Variable<double>(dailyRealizedPnl.value);
    }
    if (snapshotTrigger.present) {
      map['snapshot_trigger'] = Variable<String>(snapshotTrigger.value);
    }
    if (timestampUs.present) {
      map['timestamp_us'] = Variable<int>(timestampUs.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('balance: $balance, ')
          ..write('equity: $equity, ')
          ..write('marginUsed: $marginUsed, ')
          ..write('marginAvailable: $marginAvailable, ')
          ..write('marginLevel: $marginLevel, ')
          ..write('nav: $nav, ')
          ..write('openPositionCount: $openPositionCount, ')
          ..write('unrealizedPnl: $unrealizedPnl, ')
          ..write('dailyRealizedPnl: $dailyRealizedPnl, ')
          ..write('snapshotTrigger: $snapshotTrigger, ')
          ..write('timestampUs: $timestampUs, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $EaInstancesTable extends EaInstances
    with TableInfo<$EaInstancesTable, EaInstance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EaInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _scriptPathMeta =
      const VerificationMeta('scriptPath');
  @override
  late final GeneratedColumn<String> scriptPath = GeneratedColumn<String>(
      'script_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _magicNumberMeta =
      const VerificationMeta('magicNumber');
  @override
  late final GeneratedColumn<int> magicNumber = GeneratedColumn<int>(
      'magic_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lotSizeMeta =
      const VerificationMeta('lotSize');
  @override
  late final GeneratedColumn<double> lotSize = GeneratedColumn<double>(
      'lot_size', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.01));
  static const VerificationMeta _maxPositionsMeta =
      const VerificationMeta('maxPositions');
  @override
  late final GeneratedColumn<int> maxPositions = GeneratedColumn<int>(
      'max_positions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _killSwitchTimeoutSecondsMeta =
      const VerificationMeta('killSwitchTimeoutSeconds');
  @override
  late final GeneratedColumn<int> killSwitchTimeoutSeconds =
      GeneratedColumn<int>('kill_switch_timeout_seconds', aliasedName, false,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultValue: const Constant(10));
  static const VerificationMeta _dailyLossLimitMeta =
      const VerificationMeta('dailyLossLimit');
  @override
  late final GeneratedColumn<double> dailyLossLimit = GeneratedColumn<double>(
      'daily_loss_limit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _autoStartOnBootMeta =
      const VerificationMeta('autoStartOnBoot');
  @override
  late final GeneratedColumn<bool> autoStartOnBoot = GeneratedColumn<bool>(
      'auto_start_on_boot', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_start_on_boot" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('STOPPED'));
  static const VerificationMeta _createdAtUsMeta =
      const VerificationMeta('createdAtUs');
  @override
  late final GeneratedColumn<int> createdAtUs = GeneratedColumn<int>(
      'created_at_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastStartedAtUsMeta =
      const VerificationMeta('lastStartedAtUs');
  @override
  late final GeneratedColumn<int> lastStartedAtUs = GeneratedColumn<int>(
      'last_started_at_us', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastStoppedAtUsMeta =
      const VerificationMeta('lastStoppedAtUs');
  @override
  late final GeneratedColumn<int> lastStoppedAtUs = GeneratedColumn<int>(
      'last_stopped_at_us', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalTradesMeta =
      const VerificationMeta('totalTrades');
  @override
  late final GeneratedColumn<int> totalTrades = GeneratedColumn<int>(
      'total_trades', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _netPnlMeta = const VerificationMeta('netPnl');
  @override
  late final GeneratedColumn<double> netPnl = GeneratedColumn<double>(
      'net_pnl', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _winRateMeta =
      const VerificationMeta('winRate');
  @override
  late final GeneratedColumn<double> winRate = GeneratedColumn<double>(
      'win_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _customParamsMeta =
      const VerificationMeta('customParams');
  @override
  late final GeneratedColumn<String> customParams = GeneratedColumn<String>(
      'custom_params', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        symbol,
        scriptPath,
        magicNumber,
        lotSize,
        maxPositions,
        killSwitchTimeoutSeconds,
        dailyLossLimit,
        autoStartOnBoot,
        status,
        createdAtUs,
        lastStartedAtUs,
        lastStoppedAtUs,
        totalTrades,
        netPnl,
        winRate,
        customParams
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ea_instances';
  @override
  VerificationContext validateIntegrity(Insertable<EaInstance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('script_path')) {
      context.handle(
          _scriptPathMeta,
          scriptPath.isAcceptableOrUnknown(
              data['script_path']!, _scriptPathMeta));
    } else if (isInserting) {
      context.missing(_scriptPathMeta);
    }
    if (data.containsKey('magic_number')) {
      context.handle(
          _magicNumberMeta,
          magicNumber.isAcceptableOrUnknown(
              data['magic_number']!, _magicNumberMeta));
    } else if (isInserting) {
      context.missing(_magicNumberMeta);
    }
    if (data.containsKey('lot_size')) {
      context.handle(_lotSizeMeta,
          lotSize.isAcceptableOrUnknown(data['lot_size']!, _lotSizeMeta));
    }
    if (data.containsKey('max_positions')) {
      context.handle(
          _maxPositionsMeta,
          maxPositions.isAcceptableOrUnknown(
              data['max_positions']!, _maxPositionsMeta));
    }
    if (data.containsKey('kill_switch_timeout_seconds')) {
      context.handle(
          _killSwitchTimeoutSecondsMeta,
          killSwitchTimeoutSeconds.isAcceptableOrUnknown(
              data['kill_switch_timeout_seconds']!,
              _killSwitchTimeoutSecondsMeta));
    }
    if (data.containsKey('daily_loss_limit')) {
      context.handle(
          _dailyLossLimitMeta,
          dailyLossLimit.isAcceptableOrUnknown(
              data['daily_loss_limit']!, _dailyLossLimitMeta));
    }
    if (data.containsKey('auto_start_on_boot')) {
      context.handle(
          _autoStartOnBootMeta,
          autoStartOnBoot.isAcceptableOrUnknown(
              data['auto_start_on_boot']!, _autoStartOnBootMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at_us')) {
      context.handle(
          _createdAtUsMeta,
          createdAtUs.isAcceptableOrUnknown(
              data['created_at_us']!, _createdAtUsMeta));
    } else if (isInserting) {
      context.missing(_createdAtUsMeta);
    }
    if (data.containsKey('last_started_at_us')) {
      context.handle(
          _lastStartedAtUsMeta,
          lastStartedAtUs.isAcceptableOrUnknown(
              data['last_started_at_us']!, _lastStartedAtUsMeta));
    }
    if (data.containsKey('last_stopped_at_us')) {
      context.handle(
          _lastStoppedAtUsMeta,
          lastStoppedAtUs.isAcceptableOrUnknown(
              data['last_stopped_at_us']!, _lastStoppedAtUsMeta));
    }
    if (data.containsKey('total_trades')) {
      context.handle(
          _totalTradesMeta,
          totalTrades.isAcceptableOrUnknown(
              data['total_trades']!, _totalTradesMeta));
    }
    if (data.containsKey('net_pnl')) {
      context.handle(_netPnlMeta,
          netPnl.isAcceptableOrUnknown(data['net_pnl']!, _netPnlMeta));
    }
    if (data.containsKey('win_rate')) {
      context.handle(_winRateMeta,
          winRate.isAcceptableOrUnknown(data['win_rate']!, _winRateMeta));
    }
    if (data.containsKey('custom_params')) {
      context.handle(
          _customParamsMeta,
          customParams.isAcceptableOrUnknown(
              data['custom_params']!, _customParamsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EaInstance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EaInstance(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      scriptPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}script_path'])!,
      magicNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}magic_number'])!,
      lotSize: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lot_size'])!,
      maxPositions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_positions'])!,
      killSwitchTimeoutSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kill_switch_timeout_seconds'])!,
      dailyLossLimit: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}daily_loss_limit']),
      autoStartOnBoot: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}auto_start_on_boot'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAtUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_us'])!,
      lastStartedAtUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_started_at_us']),
      lastStoppedAtUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_stopped_at_us']),
      totalTrades: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_trades'])!,
      netPnl: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_pnl'])!,
      winRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}win_rate'])!,
      customParams: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_params'])!,
    );
  }

  @override
  $EaInstancesTable createAlias(String alias) {
    return $EaInstancesTable(attachedDatabase, alias);
  }
}

class EaInstance extends DataClass implements Insertable<EaInstance> {
  final int id;
  final String name;
  final String symbol;
  final String scriptPath;
  final int magicNumber;
  final double lotSize;
  final int maxPositions;
  final int killSwitchTimeoutSeconds;
  final double? dailyLossLimit;
  final bool autoStartOnBoot;
  final String status;
  final int createdAtUs;
  final int? lastStartedAtUs;
  final int? lastStoppedAtUs;
  final int totalTrades;
  final double netPnl;
  final double winRate;
  final String customParams;
  const EaInstance(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.scriptPath,
      required this.magicNumber,
      required this.lotSize,
      required this.maxPositions,
      required this.killSwitchTimeoutSeconds,
      this.dailyLossLimit,
      required this.autoStartOnBoot,
      required this.status,
      required this.createdAtUs,
      this.lastStartedAtUs,
      this.lastStoppedAtUs,
      required this.totalTrades,
      required this.netPnl,
      required this.winRate,
      required this.customParams});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['symbol'] = Variable<String>(symbol);
    map['script_path'] = Variable<String>(scriptPath);
    map['magic_number'] = Variable<int>(magicNumber);
    map['lot_size'] = Variable<double>(lotSize);
    map['max_positions'] = Variable<int>(maxPositions);
    map['kill_switch_timeout_seconds'] =
        Variable<int>(killSwitchTimeoutSeconds);
    if (!nullToAbsent || dailyLossLimit != null) {
      map['daily_loss_limit'] = Variable<double>(dailyLossLimit);
    }
    map['auto_start_on_boot'] = Variable<bool>(autoStartOnBoot);
    map['status'] = Variable<String>(status);
    map['created_at_us'] = Variable<int>(createdAtUs);
    if (!nullToAbsent || lastStartedAtUs != null) {
      map['last_started_at_us'] = Variable<int>(lastStartedAtUs);
    }
    if (!nullToAbsent || lastStoppedAtUs != null) {
      map['last_stopped_at_us'] = Variable<int>(lastStoppedAtUs);
    }
    map['total_trades'] = Variable<int>(totalTrades);
    map['net_pnl'] = Variable<double>(netPnl);
    map['win_rate'] = Variable<double>(winRate);
    map['custom_params'] = Variable<String>(customParams);
    return map;
  }

  EaInstancesCompanion toCompanion(bool nullToAbsent) {
    return EaInstancesCompanion(
      id: Value(id),
      name: Value(name),
      symbol: Value(symbol),
      scriptPath: Value(scriptPath),
      magicNumber: Value(magicNumber),
      lotSize: Value(lotSize),
      maxPositions: Value(maxPositions),
      killSwitchTimeoutSeconds: Value(killSwitchTimeoutSeconds),
      dailyLossLimit: dailyLossLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyLossLimit),
      autoStartOnBoot: Value(autoStartOnBoot),
      status: Value(status),
      createdAtUs: Value(createdAtUs),
      lastStartedAtUs: lastStartedAtUs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStartedAtUs),
      lastStoppedAtUs: lastStoppedAtUs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStoppedAtUs),
      totalTrades: Value(totalTrades),
      netPnl: Value(netPnl),
      winRate: Value(winRate),
      customParams: Value(customParams),
    );
  }

  factory EaInstance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EaInstance(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String>(json['symbol']),
      scriptPath: serializer.fromJson<String>(json['scriptPath']),
      magicNumber: serializer.fromJson<int>(json['magicNumber']),
      lotSize: serializer.fromJson<double>(json['lotSize']),
      maxPositions: serializer.fromJson<int>(json['maxPositions']),
      killSwitchTimeoutSeconds:
          serializer.fromJson<int>(json['killSwitchTimeoutSeconds']),
      dailyLossLimit: serializer.fromJson<double?>(json['dailyLossLimit']),
      autoStartOnBoot: serializer.fromJson<bool>(json['autoStartOnBoot']),
      status: serializer.fromJson<String>(json['status']),
      createdAtUs: serializer.fromJson<int>(json['createdAtUs']),
      lastStartedAtUs: serializer.fromJson<int?>(json['lastStartedAtUs']),
      lastStoppedAtUs: serializer.fromJson<int?>(json['lastStoppedAtUs']),
      totalTrades: serializer.fromJson<int>(json['totalTrades']),
      netPnl: serializer.fromJson<double>(json['netPnl']),
      winRate: serializer.fromJson<double>(json['winRate']),
      customParams: serializer.fromJson<String>(json['customParams']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String>(symbol),
      'scriptPath': serializer.toJson<String>(scriptPath),
      'magicNumber': serializer.toJson<int>(magicNumber),
      'lotSize': serializer.toJson<double>(lotSize),
      'maxPositions': serializer.toJson<int>(maxPositions),
      'killSwitchTimeoutSeconds':
          serializer.toJson<int>(killSwitchTimeoutSeconds),
      'dailyLossLimit': serializer.toJson<double?>(dailyLossLimit),
      'autoStartOnBoot': serializer.toJson<bool>(autoStartOnBoot),
      'status': serializer.toJson<String>(status),
      'createdAtUs': serializer.toJson<int>(createdAtUs),
      'lastStartedAtUs': serializer.toJson<int?>(lastStartedAtUs),
      'lastStoppedAtUs': serializer.toJson<int?>(lastStoppedAtUs),
      'totalTrades': serializer.toJson<int>(totalTrades),
      'netPnl': serializer.toJson<double>(netPnl),
      'winRate': serializer.toJson<double>(winRate),
      'customParams': serializer.toJson<String>(customParams),
    };
  }

  EaInstance copyWith(
          {int? id,
          String? name,
          String? symbol,
          String? scriptPath,
          int? magicNumber,
          double? lotSize,
          int? maxPositions,
          int? killSwitchTimeoutSeconds,
          Value<double?> dailyLossLimit = const Value.absent(),
          bool? autoStartOnBoot,
          String? status,
          int? createdAtUs,
          Value<int?> lastStartedAtUs = const Value.absent(),
          Value<int?> lastStoppedAtUs = const Value.absent(),
          int? totalTrades,
          double? netPnl,
          double? winRate,
          String? customParams}) =>
      EaInstance(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        scriptPath: scriptPath ?? this.scriptPath,
        magicNumber: magicNumber ?? this.magicNumber,
        lotSize: lotSize ?? this.lotSize,
        maxPositions: maxPositions ?? this.maxPositions,
        killSwitchTimeoutSeconds:
            killSwitchTimeoutSeconds ?? this.killSwitchTimeoutSeconds,
        dailyLossLimit:
            dailyLossLimit.present ? dailyLossLimit.value : this.dailyLossLimit,
        autoStartOnBoot: autoStartOnBoot ?? this.autoStartOnBoot,
        status: status ?? this.status,
        createdAtUs: createdAtUs ?? this.createdAtUs,
        lastStartedAtUs: lastStartedAtUs.present
            ? lastStartedAtUs.value
            : this.lastStartedAtUs,
        lastStoppedAtUs: lastStoppedAtUs.present
            ? lastStoppedAtUs.value
            : this.lastStoppedAtUs,
        totalTrades: totalTrades ?? this.totalTrades,
        netPnl: netPnl ?? this.netPnl,
        winRate: winRate ?? this.winRate,
        customParams: customParams ?? this.customParams,
      );
  EaInstance copyWithCompanion(EaInstancesCompanion data) {
    return EaInstance(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      scriptPath:
          data.scriptPath.present ? data.scriptPath.value : this.scriptPath,
      magicNumber:
          data.magicNumber.present ? data.magicNumber.value : this.magicNumber,
      lotSize: data.lotSize.present ? data.lotSize.value : this.lotSize,
      maxPositions: data.maxPositions.present
          ? data.maxPositions.value
          : this.maxPositions,
      killSwitchTimeoutSeconds: data.killSwitchTimeoutSeconds.present
          ? data.killSwitchTimeoutSeconds.value
          : this.killSwitchTimeoutSeconds,
      dailyLossLimit: data.dailyLossLimit.present
          ? data.dailyLossLimit.value
          : this.dailyLossLimit,
      autoStartOnBoot: data.autoStartOnBoot.present
          ? data.autoStartOnBoot.value
          : this.autoStartOnBoot,
      status: data.status.present ? data.status.value : this.status,
      createdAtUs:
          data.createdAtUs.present ? data.createdAtUs.value : this.createdAtUs,
      lastStartedAtUs: data.lastStartedAtUs.present
          ? data.lastStartedAtUs.value
          : this.lastStartedAtUs,
      lastStoppedAtUs: data.lastStoppedAtUs.present
          ? data.lastStoppedAtUs.value
          : this.lastStoppedAtUs,
      totalTrades:
          data.totalTrades.present ? data.totalTrades.value : this.totalTrades,
      netPnl: data.netPnl.present ? data.netPnl.value : this.netPnl,
      winRate: data.winRate.present ? data.winRate.value : this.winRate,
      customParams: data.customParams.present
          ? data.customParams.value
          : this.customParams,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EaInstance(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('scriptPath: $scriptPath, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('lotSize: $lotSize, ')
          ..write('maxPositions: $maxPositions, ')
          ..write('killSwitchTimeoutSeconds: $killSwitchTimeoutSeconds, ')
          ..write('dailyLossLimit: $dailyLossLimit, ')
          ..write('autoStartOnBoot: $autoStartOnBoot, ')
          ..write('status: $status, ')
          ..write('createdAtUs: $createdAtUs, ')
          ..write('lastStartedAtUs: $lastStartedAtUs, ')
          ..write('lastStoppedAtUs: $lastStoppedAtUs, ')
          ..write('totalTrades: $totalTrades, ')
          ..write('netPnl: $netPnl, ')
          ..write('winRate: $winRate, ')
          ..write('customParams: $customParams')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      symbol,
      scriptPath,
      magicNumber,
      lotSize,
      maxPositions,
      killSwitchTimeoutSeconds,
      dailyLossLimit,
      autoStartOnBoot,
      status,
      createdAtUs,
      lastStartedAtUs,
      lastStoppedAtUs,
      totalTrades,
      netPnl,
      winRate,
      customParams);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EaInstance &&
          other.id == this.id &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.scriptPath == this.scriptPath &&
          other.magicNumber == this.magicNumber &&
          other.lotSize == this.lotSize &&
          other.maxPositions == this.maxPositions &&
          other.killSwitchTimeoutSeconds == this.killSwitchTimeoutSeconds &&
          other.dailyLossLimit == this.dailyLossLimit &&
          other.autoStartOnBoot == this.autoStartOnBoot &&
          other.status == this.status &&
          other.createdAtUs == this.createdAtUs &&
          other.lastStartedAtUs == this.lastStartedAtUs &&
          other.lastStoppedAtUs == this.lastStoppedAtUs &&
          other.totalTrades == this.totalTrades &&
          other.netPnl == this.netPnl &&
          other.winRate == this.winRate &&
          other.customParams == this.customParams);
}

class EaInstancesCompanion extends UpdateCompanion<EaInstance> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> symbol;
  final Value<String> scriptPath;
  final Value<int> magicNumber;
  final Value<double> lotSize;
  final Value<int> maxPositions;
  final Value<int> killSwitchTimeoutSeconds;
  final Value<double?> dailyLossLimit;
  final Value<bool> autoStartOnBoot;
  final Value<String> status;
  final Value<int> createdAtUs;
  final Value<int?> lastStartedAtUs;
  final Value<int?> lastStoppedAtUs;
  final Value<int> totalTrades;
  final Value<double> netPnl;
  final Value<double> winRate;
  final Value<String> customParams;
  const EaInstancesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.scriptPath = const Value.absent(),
    this.magicNumber = const Value.absent(),
    this.lotSize = const Value.absent(),
    this.maxPositions = const Value.absent(),
    this.killSwitchTimeoutSeconds = const Value.absent(),
    this.dailyLossLimit = const Value.absent(),
    this.autoStartOnBoot = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAtUs = const Value.absent(),
    this.lastStartedAtUs = const Value.absent(),
    this.lastStoppedAtUs = const Value.absent(),
    this.totalTrades = const Value.absent(),
    this.netPnl = const Value.absent(),
    this.winRate = const Value.absent(),
    this.customParams = const Value.absent(),
  });
  EaInstancesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String symbol,
    required String scriptPath,
    required int magicNumber,
    this.lotSize = const Value.absent(),
    this.maxPositions = const Value.absent(),
    this.killSwitchTimeoutSeconds = const Value.absent(),
    this.dailyLossLimit = const Value.absent(),
    this.autoStartOnBoot = const Value.absent(),
    this.status = const Value.absent(),
    required int createdAtUs,
    this.lastStartedAtUs = const Value.absent(),
    this.lastStoppedAtUs = const Value.absent(),
    this.totalTrades = const Value.absent(),
    this.netPnl = const Value.absent(),
    this.winRate = const Value.absent(),
    this.customParams = const Value.absent(),
  })  : name = Value(name),
        symbol = Value(symbol),
        scriptPath = Value(scriptPath),
        magicNumber = Value(magicNumber),
        createdAtUs = Value(createdAtUs);
  static Insertable<EaInstance> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<String>? scriptPath,
    Expression<int>? magicNumber,
    Expression<double>? lotSize,
    Expression<int>? maxPositions,
    Expression<int>? killSwitchTimeoutSeconds,
    Expression<double>? dailyLossLimit,
    Expression<bool>? autoStartOnBoot,
    Expression<String>? status,
    Expression<int>? createdAtUs,
    Expression<int>? lastStartedAtUs,
    Expression<int>? lastStoppedAtUs,
    Expression<int>? totalTrades,
    Expression<double>? netPnl,
    Expression<double>? winRate,
    Expression<String>? customParams,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (scriptPath != null) 'script_path': scriptPath,
      if (magicNumber != null) 'magic_number': magicNumber,
      if (lotSize != null) 'lot_size': lotSize,
      if (maxPositions != null) 'max_positions': maxPositions,
      if (killSwitchTimeoutSeconds != null)
        'kill_switch_timeout_seconds': killSwitchTimeoutSeconds,
      if (dailyLossLimit != null) 'daily_loss_limit': dailyLossLimit,
      if (autoStartOnBoot != null) 'auto_start_on_boot': autoStartOnBoot,
      if (status != null) 'status': status,
      if (createdAtUs != null) 'created_at_us': createdAtUs,
      if (lastStartedAtUs != null) 'last_started_at_us': lastStartedAtUs,
      if (lastStoppedAtUs != null) 'last_stopped_at_us': lastStoppedAtUs,
      if (totalTrades != null) 'total_trades': totalTrades,
      if (netPnl != null) 'net_pnl': netPnl,
      if (winRate != null) 'win_rate': winRate,
      if (customParams != null) 'custom_params': customParams,
    });
  }

  EaInstancesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? symbol,
      Value<String>? scriptPath,
      Value<int>? magicNumber,
      Value<double>? lotSize,
      Value<int>? maxPositions,
      Value<int>? killSwitchTimeoutSeconds,
      Value<double?>? dailyLossLimit,
      Value<bool>? autoStartOnBoot,
      Value<String>? status,
      Value<int>? createdAtUs,
      Value<int?>? lastStartedAtUs,
      Value<int?>? lastStoppedAtUs,
      Value<int>? totalTrades,
      Value<double>? netPnl,
      Value<double>? winRate,
      Value<String>? customParams}) {
    return EaInstancesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      scriptPath: scriptPath ?? this.scriptPath,
      magicNumber: magicNumber ?? this.magicNumber,
      lotSize: lotSize ?? this.lotSize,
      maxPositions: maxPositions ?? this.maxPositions,
      killSwitchTimeoutSeconds:
          killSwitchTimeoutSeconds ?? this.killSwitchTimeoutSeconds,
      dailyLossLimit: dailyLossLimit ?? this.dailyLossLimit,
      autoStartOnBoot: autoStartOnBoot ?? this.autoStartOnBoot,
      status: status ?? this.status,
      createdAtUs: createdAtUs ?? this.createdAtUs,
      lastStartedAtUs: lastStartedAtUs ?? this.lastStartedAtUs,
      lastStoppedAtUs: lastStoppedAtUs ?? this.lastStoppedAtUs,
      totalTrades: totalTrades ?? this.totalTrades,
      netPnl: netPnl ?? this.netPnl,
      winRate: winRate ?? this.winRate,
      customParams: customParams ?? this.customParams,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (scriptPath.present) {
      map['script_path'] = Variable<String>(scriptPath.value);
    }
    if (magicNumber.present) {
      map['magic_number'] = Variable<int>(magicNumber.value);
    }
    if (lotSize.present) {
      map['lot_size'] = Variable<double>(lotSize.value);
    }
    if (maxPositions.present) {
      map['max_positions'] = Variable<int>(maxPositions.value);
    }
    if (killSwitchTimeoutSeconds.present) {
      map['kill_switch_timeout_seconds'] =
          Variable<int>(killSwitchTimeoutSeconds.value);
    }
    if (dailyLossLimit.present) {
      map['daily_loss_limit'] = Variable<double>(dailyLossLimit.value);
    }
    if (autoStartOnBoot.present) {
      map['auto_start_on_boot'] = Variable<bool>(autoStartOnBoot.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAtUs.present) {
      map['created_at_us'] = Variable<int>(createdAtUs.value);
    }
    if (lastStartedAtUs.present) {
      map['last_started_at_us'] = Variable<int>(lastStartedAtUs.value);
    }
    if (lastStoppedAtUs.present) {
      map['last_stopped_at_us'] = Variable<int>(lastStoppedAtUs.value);
    }
    if (totalTrades.present) {
      map['total_trades'] = Variable<int>(totalTrades.value);
    }
    if (netPnl.present) {
      map['net_pnl'] = Variable<double>(netPnl.value);
    }
    if (winRate.present) {
      map['win_rate'] = Variable<double>(winRate.value);
    }
    if (customParams.present) {
      map['custom_params'] = Variable<String>(customParams.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EaInstancesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('scriptPath: $scriptPath, ')
          ..write('magicNumber: $magicNumber, ')
          ..write('lotSize: $lotSize, ')
          ..write('maxPositions: $maxPositions, ')
          ..write('killSwitchTimeoutSeconds: $killSwitchTimeoutSeconds, ')
          ..write('dailyLossLimit: $dailyLossLimit, ')
          ..write('autoStartOnBoot: $autoStartOnBoot, ')
          ..write('status: $status, ')
          ..write('createdAtUs: $createdAtUs, ')
          ..write('lastStartedAtUs: $lastStartedAtUs, ')
          ..write('lastStoppedAtUs: $lastStoppedAtUs, ')
          ..write('totalTrades: $totalTrades, ')
          ..write('netPnl: $netPnl, ')
          ..write('winRate: $winRate, ')
          ..write('customParams: $customParams')
          ..write(')'))
        .toString();
  }
}

class $EaLogsTable extends EaLogs with TableInfo<$EaLogsTable, EaLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EaLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _eaInstanceIdMeta =
      const VerificationMeta('eaInstanceId');
  @override
  late final GeneratedColumn<int> eaInstanceId = GeneratedColumn<int>(
      'ea_instance_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PYTHON'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampUsMeta =
      const VerificationMeta('timestampUs');
  @override
  late final GeneratedColumn<int> timestampUs = GeneratedColumn<int>(
      'timestamp_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, eaInstanceId, level, source, message, timestampUs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ea_logs';
  @override
  VerificationContext validateIntegrity(Insertable<EaLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ea_instance_id')) {
      context.handle(
          _eaInstanceIdMeta,
          eaInstanceId.isAcceptableOrUnknown(
              data['ea_instance_id']!, _eaInstanceIdMeta));
    } else if (isInserting) {
      context.missing(_eaInstanceIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('timestamp_us')) {
      context.handle(
          _timestampUsMeta,
          timestampUs.isAcceptableOrUnknown(
              data['timestamp_us']!, _timestampUsMeta));
    } else if (isInserting) {
      context.missing(_timestampUsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {eaInstanceId, timestampUs},
      ];
  @override
  EaLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EaLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      eaInstanceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ea_instance_id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      timestampUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp_us'])!,
    );
  }

  @override
  $EaLogsTable createAlias(String alias) {
    return $EaLogsTable(attachedDatabase, alias);
  }
}

class EaLog extends DataClass implements Insertable<EaLog> {
  final int id;
  final int eaInstanceId;
  final String level;
  final String source;
  final String message;
  final int timestampUs;
  const EaLog(
      {required this.id,
      required this.eaInstanceId,
      required this.level,
      required this.source,
      required this.message,
      required this.timestampUs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ea_instance_id'] = Variable<int>(eaInstanceId);
    map['level'] = Variable<String>(level);
    map['source'] = Variable<String>(source);
    map['message'] = Variable<String>(message);
    map['timestamp_us'] = Variable<int>(timestampUs);
    return map;
  }

  EaLogsCompanion toCompanion(bool nullToAbsent) {
    return EaLogsCompanion(
      id: Value(id),
      eaInstanceId: Value(eaInstanceId),
      level: Value(level),
      source: Value(source),
      message: Value(message),
      timestampUs: Value(timestampUs),
    );
  }

  factory EaLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EaLog(
      id: serializer.fromJson<int>(json['id']),
      eaInstanceId: serializer.fromJson<int>(json['eaInstanceId']),
      level: serializer.fromJson<String>(json['level']),
      source: serializer.fromJson<String>(json['source']),
      message: serializer.fromJson<String>(json['message']),
      timestampUs: serializer.fromJson<int>(json['timestampUs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eaInstanceId': serializer.toJson<int>(eaInstanceId),
      'level': serializer.toJson<String>(level),
      'source': serializer.toJson<String>(source),
      'message': serializer.toJson<String>(message),
      'timestampUs': serializer.toJson<int>(timestampUs),
    };
  }

  EaLog copyWith(
          {int? id,
          int? eaInstanceId,
          String? level,
          String? source,
          String? message,
          int? timestampUs}) =>
      EaLog(
        id: id ?? this.id,
        eaInstanceId: eaInstanceId ?? this.eaInstanceId,
        level: level ?? this.level,
        source: source ?? this.source,
        message: message ?? this.message,
        timestampUs: timestampUs ?? this.timestampUs,
      );
  EaLog copyWithCompanion(EaLogsCompanion data) {
    return EaLog(
      id: data.id.present ? data.id.value : this.id,
      eaInstanceId: data.eaInstanceId.present
          ? data.eaInstanceId.value
          : this.eaInstanceId,
      level: data.level.present ? data.level.value : this.level,
      source: data.source.present ? data.source.value : this.source,
      message: data.message.present ? data.message.value : this.message,
      timestampUs:
          data.timestampUs.present ? data.timestampUs.value : this.timestampUs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EaLog(')
          ..write('id: $id, ')
          ..write('eaInstanceId: $eaInstanceId, ')
          ..write('level: $level, ')
          ..write('source: $source, ')
          ..write('message: $message, ')
          ..write('timestampUs: $timestampUs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eaInstanceId, level, source, message, timestampUs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EaLog &&
          other.id == this.id &&
          other.eaInstanceId == this.eaInstanceId &&
          other.level == this.level &&
          other.source == this.source &&
          other.message == this.message &&
          other.timestampUs == this.timestampUs);
}

class EaLogsCompanion extends UpdateCompanion<EaLog> {
  final Value<int> id;
  final Value<int> eaInstanceId;
  final Value<String> level;
  final Value<String> source;
  final Value<String> message;
  final Value<int> timestampUs;
  const EaLogsCompanion({
    this.id = const Value.absent(),
    this.eaInstanceId = const Value.absent(),
    this.level = const Value.absent(),
    this.source = const Value.absent(),
    this.message = const Value.absent(),
    this.timestampUs = const Value.absent(),
  });
  EaLogsCompanion.insert({
    this.id = const Value.absent(),
    required int eaInstanceId,
    required String level,
    this.source = const Value.absent(),
    required String message,
    required int timestampUs,
  })  : eaInstanceId = Value(eaInstanceId),
        level = Value(level),
        message = Value(message),
        timestampUs = Value(timestampUs);
  static Insertable<EaLog> custom({
    Expression<int>? id,
    Expression<int>? eaInstanceId,
    Expression<String>? level,
    Expression<String>? source,
    Expression<String>? message,
    Expression<int>? timestampUs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eaInstanceId != null) 'ea_instance_id': eaInstanceId,
      if (level != null) 'level': level,
      if (source != null) 'source': source,
      if (message != null) 'message': message,
      if (timestampUs != null) 'timestamp_us': timestampUs,
    });
  }

  EaLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? eaInstanceId,
      Value<String>? level,
      Value<String>? source,
      Value<String>? message,
      Value<int>? timestampUs}) {
    return EaLogsCompanion(
      id: id ?? this.id,
      eaInstanceId: eaInstanceId ?? this.eaInstanceId,
      level: level ?? this.level,
      source: source ?? this.source,
      message: message ?? this.message,
      timestampUs: timestampUs ?? this.timestampUs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eaInstanceId.present) {
      map['ea_instance_id'] = Variable<int>(eaInstanceId.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (timestampUs.present) {
      map['timestamp_us'] = Variable<int>(timestampUs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EaLogsCompanion(')
          ..write('id: $id, ')
          ..write('eaInstanceId: $eaInstanceId, ')
          ..write('level: $level, ')
          ..write('source: $source, ')
          ..write('message: $message, ')
          ..write('timestampUs: $timestampUs')
          ..write(')'))
        .toString();
  }
}

class $CandlesTable extends Candles with TableInfo<$CandlesTable, Candle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CandlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _timeframeMeta =
      const VerificationMeta('timeframe');
  @override
  late final GeneratedColumn<String> timeframe = GeneratedColumn<String>(
      'timeframe', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 5),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _openTimeUsMeta =
      const VerificationMeta('openTimeUs');
  @override
  late final GeneratedColumn<int> openTimeUs = GeneratedColumn<int>(
      'open_time_us', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _openMeta = const VerificationMeta('open');
  @override
  late final GeneratedColumn<double> open = GeneratedColumn<double>(
      'open', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _highMeta = const VerificationMeta('high');
  @override
  late final GeneratedColumn<double> high = GeneratedColumn<double>(
      'high', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lowMeta = const VerificationMeta('low');
  @override
  late final GeneratedColumn<double> low = GeneratedColumn<double>(
      'low', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _closeMeta = const VerificationMeta('close');
  @override
  late final GeneratedColumn<double> close = GeneratedColumn<double>(
      'close', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
      'volume', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isCompleteMeta =
      const VerificationMeta('isComplete');
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
      'is_complete', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_complete" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        symbol,
        timeframe,
        openTimeUs,
        open,
        high,
        low,
        close,
        volume,
        isComplete
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'candles';
  @override
  VerificationContext validateIntegrity(Insertable<Candle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('timeframe')) {
      context.handle(_timeframeMeta,
          timeframe.isAcceptableOrUnknown(data['timeframe']!, _timeframeMeta));
    } else if (isInserting) {
      context.missing(_timeframeMeta);
    }
    if (data.containsKey('open_time_us')) {
      context.handle(
          _openTimeUsMeta,
          openTimeUs.isAcceptableOrUnknown(
              data['open_time_us']!, _openTimeUsMeta));
    } else if (isInserting) {
      context.missing(_openTimeUsMeta);
    }
    if (data.containsKey('open')) {
      context.handle(
          _openMeta, open.isAcceptableOrUnknown(data['open']!, _openMeta));
    } else if (isInserting) {
      context.missing(_openMeta);
    }
    if (data.containsKey('high')) {
      context.handle(
          _highMeta, high.isAcceptableOrUnknown(data['high']!, _highMeta));
    } else if (isInserting) {
      context.missing(_highMeta);
    }
    if (data.containsKey('low')) {
      context.handle(
          _lowMeta, low.isAcceptableOrUnknown(data['low']!, _lowMeta));
    } else if (isInserting) {
      context.missing(_lowMeta);
    }
    if (data.containsKey('close')) {
      context.handle(
          _closeMeta, close.isAcceptableOrUnknown(data['close']!, _closeMeta));
    } else if (isInserting) {
      context.missing(_closeMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(_volumeMeta,
          volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta));
    }
    if (data.containsKey('is_complete')) {
      context.handle(
          _isCompleteMeta,
          isComplete.isAcceptableOrUnknown(
              data['is_complete']!, _isCompleteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {symbol, timeframe, openTimeUs},
      ];
  @override
  Candle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Candle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      timeframe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timeframe'])!,
      openTimeUs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}open_time_us'])!,
      open: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}open'])!,
      high: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}high'])!,
      low: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}low'])!,
      close: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}close'])!,
      volume: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}volume'])!,
      isComplete: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_complete'])!,
    );
  }

  @override
  $CandlesTable createAlias(String alias) {
    return $CandlesTable(attachedDatabase, alias);
  }
}

class Candle extends DataClass implements Insertable<Candle> {
  final int id;
  final String symbol;
  final String timeframe;
  final int openTimeUs;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final bool isComplete;
  const Candle(
      {required this.id,
      required this.symbol,
      required this.timeframe,
      required this.openTimeUs,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.volume,
      required this.isComplete});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['timeframe'] = Variable<String>(timeframe);
    map['open_time_us'] = Variable<int>(openTimeUs);
    map['open'] = Variable<double>(open);
    map['high'] = Variable<double>(high);
    map['low'] = Variable<double>(low);
    map['close'] = Variable<double>(close);
    map['volume'] = Variable<double>(volume);
    map['is_complete'] = Variable<bool>(isComplete);
    return map;
  }

  CandlesCompanion toCompanion(bool nullToAbsent) {
    return CandlesCompanion(
      id: Value(id),
      symbol: Value(symbol),
      timeframe: Value(timeframe),
      openTimeUs: Value(openTimeUs),
      open: Value(open),
      high: Value(high),
      low: Value(low),
      close: Value(close),
      volume: Value(volume),
      isComplete: Value(isComplete),
    );
  }

  factory Candle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Candle(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      timeframe: serializer.fromJson<String>(json['timeframe']),
      openTimeUs: serializer.fromJson<int>(json['openTimeUs']),
      open: serializer.fromJson<double>(json['open']),
      high: serializer.fromJson<double>(json['high']),
      low: serializer.fromJson<double>(json['low']),
      close: serializer.fromJson<double>(json['close']),
      volume: serializer.fromJson<double>(json['volume']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'timeframe': serializer.toJson<String>(timeframe),
      'openTimeUs': serializer.toJson<int>(openTimeUs),
      'open': serializer.toJson<double>(open),
      'high': serializer.toJson<double>(high),
      'low': serializer.toJson<double>(low),
      'close': serializer.toJson<double>(close),
      'volume': serializer.toJson<double>(volume),
      'isComplete': serializer.toJson<bool>(isComplete),
    };
  }

  Candle copyWith(
          {int? id,
          String? symbol,
          String? timeframe,
          int? openTimeUs,
          double? open,
          double? high,
          double? low,
          double? close,
          double? volume,
          bool? isComplete}) =>
      Candle(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        timeframe: timeframe ?? this.timeframe,
        openTimeUs: openTimeUs ?? this.openTimeUs,
        open: open ?? this.open,
        high: high ?? this.high,
        low: low ?? this.low,
        close: close ?? this.close,
        volume: volume ?? this.volume,
        isComplete: isComplete ?? this.isComplete,
      );
  Candle copyWithCompanion(CandlesCompanion data) {
    return Candle(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      timeframe: data.timeframe.present ? data.timeframe.value : this.timeframe,
      openTimeUs:
          data.openTimeUs.present ? data.openTimeUs.value : this.openTimeUs,
      open: data.open.present ? data.open.value : this.open,
      high: data.high.present ? data.high.value : this.high,
      low: data.low.present ? data.low.value : this.low,
      close: data.close.present ? data.close.value : this.close,
      volume: data.volume.present ? data.volume.value : this.volume,
      isComplete:
          data.isComplete.present ? data.isComplete.value : this.isComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Candle(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('timeframe: $timeframe, ')
          ..write('openTimeUs: $openTimeUs, ')
          ..write('open: $open, ')
          ..write('high: $high, ')
          ..write('low: $low, ')
          ..write('close: $close, ')
          ..write('volume: $volume, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, symbol, timeframe, openTimeUs, open, high,
      low, close, volume, isComplete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Candle &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.timeframe == this.timeframe &&
          other.openTimeUs == this.openTimeUs &&
          other.open == this.open &&
          other.high == this.high &&
          other.low == this.low &&
          other.close == this.close &&
          other.volume == this.volume &&
          other.isComplete == this.isComplete);
}

class CandlesCompanion extends UpdateCompanion<Candle> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<String> timeframe;
  final Value<int> openTimeUs;
  final Value<double> open;
  final Value<double> high;
  final Value<double> low;
  final Value<double> close;
  final Value<double> volume;
  final Value<bool> isComplete;
  const CandlesCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.timeframe = const Value.absent(),
    this.openTimeUs = const Value.absent(),
    this.open = const Value.absent(),
    this.high = const Value.absent(),
    this.low = const Value.absent(),
    this.close = const Value.absent(),
    this.volume = const Value.absent(),
    this.isComplete = const Value.absent(),
  });
  CandlesCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required String timeframe,
    required int openTimeUs,
    required double open,
    required double high,
    required double low,
    required double close,
    this.volume = const Value.absent(),
    this.isComplete = const Value.absent(),
  })  : symbol = Value(symbol),
        timeframe = Value(timeframe),
        openTimeUs = Value(openTimeUs),
        open = Value(open),
        high = Value(high),
        low = Value(low),
        close = Value(close);
  static Insertable<Candle> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<String>? timeframe,
    Expression<int>? openTimeUs,
    Expression<double>? open,
    Expression<double>? high,
    Expression<double>? low,
    Expression<double>? close,
    Expression<double>? volume,
    Expression<bool>? isComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (timeframe != null) 'timeframe': timeframe,
      if (openTimeUs != null) 'open_time_us': openTimeUs,
      if (open != null) 'open': open,
      if (high != null) 'high': high,
      if (low != null) 'low': low,
      if (close != null) 'close': close,
      if (volume != null) 'volume': volume,
      if (isComplete != null) 'is_complete': isComplete,
    });
  }

  CandlesCompanion copyWith(
      {Value<int>? id,
      Value<String>? symbol,
      Value<String>? timeframe,
      Value<int>? openTimeUs,
      Value<double>? open,
      Value<double>? high,
      Value<double>? low,
      Value<double>? close,
      Value<double>? volume,
      Value<bool>? isComplete}) {
    return CandlesCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      timeframe: timeframe ?? this.timeframe,
      openTimeUs: openTimeUs ?? this.openTimeUs,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (timeframe.present) {
      map['timeframe'] = Variable<String>(timeframe.value);
    }
    if (openTimeUs.present) {
      map['open_time_us'] = Variable<int>(openTimeUs.value);
    }
    if (open.present) {
      map['open'] = Variable<double>(open.value);
    }
    if (high.present) {
      map['high'] = Variable<double>(high.value);
    }
    if (low.present) {
      map['low'] = Variable<double>(low.value);
    }
    if (close.present) {
      map['close'] = Variable<double>(close.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CandlesCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('timeframe: $timeframe, ')
          ..write('openTimeUs: $openTimeUs, ')
          ..write('open: $open, ')
          ..write('high: $high, ')
          ..write('low: $low, ')
          ..write('close: $close, ')
          ..write('volume: $volume, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TicksTable ticks = $TicksTable(this);
  late final $SymbolsTable symbols = $SymbolsTable(this);
  late final $PositionsTable positions = $PositionsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $ClosedTradesTable closedTrades = $ClosedTradesTable(this);
  late final $AccountSnapshotsTable accountSnapshots =
      $AccountSnapshotsTable(this);
  late final $EaInstancesTable eaInstances = $EaInstancesTable(this);
  late final $EaLogsTable eaLogs = $EaLogsTable(this);
  late final $CandlesTable candles = $CandlesTable(this);
  late final TicksDao ticksDao = TicksDao(this as AppDatabase);
  late final PositionsDao positionsDao = PositionsDao(this as AppDatabase);
  late final OrdersDao ordersDao = OrdersDao(this as AppDatabase);
  late final HistoryDao historyDao = HistoryDao(this as AppDatabase);
  late final AccountDao accountDao = AccountDao(this as AppDatabase);
  late final EaDao eaDao = EaDao(this as AppDatabase);
  late final CandlesDao candlesDao = CandlesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        ticks,
        symbols,
        positions,
        orders,
        closedTrades,
        accountSnapshots,
        eaInstances,
        eaLogs,
        candles
      ];
}

typedef $$TicksTableCreateCompanionBuilder = TicksCompanion Function({
  Value<int> id,
  required String symbol,
  required double bid,
  required double ask,
  required double spread,
  required int timestampUs,
  Value<double?> sessionHigh,
  Value<double?> sessionLow,
});
typedef $$TicksTableUpdateCompanionBuilder = TicksCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<double> bid,
  Value<double> ask,
  Value<double> spread,
  Value<int> timestampUs,
  Value<double?> sessionHigh,
  Value<double?> sessionLow,
});

class $$TicksTableFilterComposer extends Composer<_$AppDatabase, $TicksTable> {
  $$TicksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bid => $composableBuilder(
      column: $table.bid, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ask => $composableBuilder(
      column: $table.ask, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get spread => $composableBuilder(
      column: $table.spread, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sessionHigh => $composableBuilder(
      column: $table.sessionHigh, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sessionLow => $composableBuilder(
      column: $table.sessionLow, builder: (column) => ColumnFilters(column));
}

class $$TicksTableOrderingComposer
    extends Composer<_$AppDatabase, $TicksTable> {
  $$TicksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bid => $composableBuilder(
      column: $table.bid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get ask => $composableBuilder(
      column: $table.ask, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get spread => $composableBuilder(
      column: $table.spread, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sessionHigh => $composableBuilder(
      column: $table.sessionHigh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sessionLow => $composableBuilder(
      column: $table.sessionLow, builder: (column) => ColumnOrderings(column));
}

class $$TicksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TicksTable> {
  $$TicksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<double> get bid =>
      $composableBuilder(column: $table.bid, builder: (column) => column);

  GeneratedColumn<double> get ask =>
      $composableBuilder(column: $table.ask, builder: (column) => column);

  GeneratedColumn<double> get spread =>
      $composableBuilder(column: $table.spread, builder: (column) => column);

  GeneratedColumn<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => column);

  GeneratedColumn<double> get sessionHigh => $composableBuilder(
      column: $table.sessionHigh, builder: (column) => column);

  GeneratedColumn<double> get sessionLow => $composableBuilder(
      column: $table.sessionLow, builder: (column) => column);
}

class $$TicksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TicksTable,
    Tick,
    $$TicksTableFilterComposer,
    $$TicksTableOrderingComposer,
    $$TicksTableAnnotationComposer,
    $$TicksTableCreateCompanionBuilder,
    $$TicksTableUpdateCompanionBuilder,
    (Tick, BaseReferences<_$AppDatabase, $TicksTable, Tick>),
    Tick,
    PrefetchHooks Function()> {
  $$TicksTableTableManager(_$AppDatabase db, $TicksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<double> bid = const Value.absent(),
            Value<double> ask = const Value.absent(),
            Value<double> spread = const Value.absent(),
            Value<int> timestampUs = const Value.absent(),
            Value<double?> sessionHigh = const Value.absent(),
            Value<double?> sessionLow = const Value.absent(),
          }) =>
              TicksCompanion(
            id: id,
            symbol: symbol,
            bid: bid,
            ask: ask,
            spread: spread,
            timestampUs: timestampUs,
            sessionHigh: sessionHigh,
            sessionLow: sessionLow,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String symbol,
            required double bid,
            required double ask,
            required double spread,
            required int timestampUs,
            Value<double?> sessionHigh = const Value.absent(),
            Value<double?> sessionLow = const Value.absent(),
          }) =>
              TicksCompanion.insert(
            id: id,
            symbol: symbol,
            bid: bid,
            ask: ask,
            spread: spread,
            timestampUs: timestampUs,
            sessionHigh: sessionHigh,
            sessionLow: sessionLow,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TicksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TicksTable,
    Tick,
    $$TicksTableFilterComposer,
    $$TicksTableOrderingComposer,
    $$TicksTableAnnotationComposer,
    $$TicksTableCreateCompanionBuilder,
    $$TicksTableUpdateCompanionBuilder,
    (Tick, BaseReferences<_$AppDatabase, $TicksTable, Tick>),
    Tick,
    PrefetchHooks Function()>;
typedef $$SymbolsTableCreateCompanionBuilder = SymbolsCompanion Function({
  required String name,
  required String displayName,
  Value<String?> displayExPrecision,
  required String type,
  required double pipSize,
  required int pipLocation,
  Value<double> unitsPerLot,
  Value<int> displayPrecision,
  Value<double?> marginRate,
  Value<double?> minimumTradeSize,
  Value<double> minLot,
  Value<double> maxLot,
  Value<double> lotStep,
  Value<double> tradeUnitsPrecision,
  Value<bool> isWatchlisted,
  Value<int> watchlistSortOrder,
  Value<int> sortOrder,
  Value<int> lastUpdatedUs,
  Value<int> rowid,
});
typedef $$SymbolsTableUpdateCompanionBuilder = SymbolsCompanion Function({
  Value<String> name,
  Value<String> displayName,
  Value<String?> displayExPrecision,
  Value<String> type,
  Value<double> pipSize,
  Value<int> pipLocation,
  Value<double> unitsPerLot,
  Value<int> displayPrecision,
  Value<double?> marginRate,
  Value<double?> minimumTradeSize,
  Value<double> minLot,
  Value<double> maxLot,
  Value<double> lotStep,
  Value<double> tradeUnitsPrecision,
  Value<bool> isWatchlisted,
  Value<int> watchlistSortOrder,
  Value<int> sortOrder,
  Value<int> lastUpdatedUs,
  Value<int> rowid,
});

class $$SymbolsTableFilterComposer
    extends Composer<_$AppDatabase, $SymbolsTable> {
  $$SymbolsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayExPrecision => $composableBuilder(
      column: $table.displayExPrecision,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pipSize => $composableBuilder(
      column: $table.pipSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pipLocation => $composableBuilder(
      column: $table.pipLocation, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitsPerLot => $composableBuilder(
      column: $table.unitsPerLot, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get displayPrecision => $composableBuilder(
      column: $table.displayPrecision,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marginRate => $composableBuilder(
      column: $table.marginRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minimumTradeSize => $composableBuilder(
      column: $table.minimumTradeSize,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minLot => $composableBuilder(
      column: $table.minLot, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxLot => $composableBuilder(
      column: $table.maxLot, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lotStep => $composableBuilder(
      column: $table.lotStep, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tradeUnitsPrecision => $composableBuilder(
      column: $table.tradeUnitsPrecision,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isWatchlisted => $composableBuilder(
      column: $table.isWatchlisted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get watchlistSortOrder => $composableBuilder(
      column: $table.watchlistSortOrder,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastUpdatedUs => $composableBuilder(
      column: $table.lastUpdatedUs, builder: (column) => ColumnFilters(column));
}

class $$SymbolsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymbolsTable> {
  $$SymbolsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayExPrecision => $composableBuilder(
      column: $table.displayExPrecision,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pipSize => $composableBuilder(
      column: $table.pipSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pipLocation => $composableBuilder(
      column: $table.pipLocation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitsPerLot => $composableBuilder(
      column: $table.unitsPerLot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayPrecision => $composableBuilder(
      column: $table.displayPrecision,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marginRate => $composableBuilder(
      column: $table.marginRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minimumTradeSize => $composableBuilder(
      column: $table.minimumTradeSize,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minLot => $composableBuilder(
      column: $table.minLot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxLot => $composableBuilder(
      column: $table.maxLot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lotStep => $composableBuilder(
      column: $table.lotStep, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tradeUnitsPrecision => $composableBuilder(
      column: $table.tradeUnitsPrecision,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isWatchlisted => $composableBuilder(
      column: $table.isWatchlisted,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get watchlistSortOrder => $composableBuilder(
      column: $table.watchlistSortOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastUpdatedUs => $composableBuilder(
      column: $table.lastUpdatedUs,
      builder: (column) => ColumnOrderings(column));
}

class $$SymbolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymbolsTable> {
  $$SymbolsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get displayExPrecision => $composableBuilder(
      column: $table.displayExPrecision, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get pipSize =>
      $composableBuilder(column: $table.pipSize, builder: (column) => column);

  GeneratedColumn<int> get pipLocation => $composableBuilder(
      column: $table.pipLocation, builder: (column) => column);

  GeneratedColumn<double> get unitsPerLot => $composableBuilder(
      column: $table.unitsPerLot, builder: (column) => column);

  GeneratedColumn<int> get displayPrecision => $composableBuilder(
      column: $table.displayPrecision, builder: (column) => column);

  GeneratedColumn<double> get marginRate => $composableBuilder(
      column: $table.marginRate, builder: (column) => column);

  GeneratedColumn<double> get minimumTradeSize => $composableBuilder(
      column: $table.minimumTradeSize, builder: (column) => column);

  GeneratedColumn<double> get minLot =>
      $composableBuilder(column: $table.minLot, builder: (column) => column);

  GeneratedColumn<double> get maxLot =>
      $composableBuilder(column: $table.maxLot, builder: (column) => column);

  GeneratedColumn<double> get lotStep =>
      $composableBuilder(column: $table.lotStep, builder: (column) => column);

  GeneratedColumn<double> get tradeUnitsPrecision => $composableBuilder(
      column: $table.tradeUnitsPrecision, builder: (column) => column);

  GeneratedColumn<bool> get isWatchlisted => $composableBuilder(
      column: $table.isWatchlisted, builder: (column) => column);

  GeneratedColumn<int> get watchlistSortOrder => $composableBuilder(
      column: $table.watchlistSortOrder, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get lastUpdatedUs => $composableBuilder(
      column: $table.lastUpdatedUs, builder: (column) => column);
}

class $$SymbolsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SymbolsTable,
    Symbol,
    $$SymbolsTableFilterComposer,
    $$SymbolsTableOrderingComposer,
    $$SymbolsTableAnnotationComposer,
    $$SymbolsTableCreateCompanionBuilder,
    $$SymbolsTableUpdateCompanionBuilder,
    (Symbol, BaseReferences<_$AppDatabase, $SymbolsTable, Symbol>),
    Symbol,
    PrefetchHooks Function()> {
  $$SymbolsTableTableManager(_$AppDatabase db, $SymbolsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymbolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymbolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymbolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String?> displayExPrecision = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> pipSize = const Value.absent(),
            Value<int> pipLocation = const Value.absent(),
            Value<double> unitsPerLot = const Value.absent(),
            Value<int> displayPrecision = const Value.absent(),
            Value<double?> marginRate = const Value.absent(),
            Value<double?> minimumTradeSize = const Value.absent(),
            Value<double> minLot = const Value.absent(),
            Value<double> maxLot = const Value.absent(),
            Value<double> lotStep = const Value.absent(),
            Value<double> tradeUnitsPrecision = const Value.absent(),
            Value<bool> isWatchlisted = const Value.absent(),
            Value<int> watchlistSortOrder = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> lastUpdatedUs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SymbolsCompanion(
            name: name,
            displayName: displayName,
            displayExPrecision: displayExPrecision,
            type: type,
            pipSize: pipSize,
            pipLocation: pipLocation,
            unitsPerLot: unitsPerLot,
            displayPrecision: displayPrecision,
            marginRate: marginRate,
            minimumTradeSize: minimumTradeSize,
            minLot: minLot,
            maxLot: maxLot,
            lotStep: lotStep,
            tradeUnitsPrecision: tradeUnitsPrecision,
            isWatchlisted: isWatchlisted,
            watchlistSortOrder: watchlistSortOrder,
            sortOrder: sortOrder,
            lastUpdatedUs: lastUpdatedUs,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            required String displayName,
            Value<String?> displayExPrecision = const Value.absent(),
            required String type,
            required double pipSize,
            required int pipLocation,
            Value<double> unitsPerLot = const Value.absent(),
            Value<int> displayPrecision = const Value.absent(),
            Value<double?> marginRate = const Value.absent(),
            Value<double?> minimumTradeSize = const Value.absent(),
            Value<double> minLot = const Value.absent(),
            Value<double> maxLot = const Value.absent(),
            Value<double> lotStep = const Value.absent(),
            Value<double> tradeUnitsPrecision = const Value.absent(),
            Value<bool> isWatchlisted = const Value.absent(),
            Value<int> watchlistSortOrder = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> lastUpdatedUs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SymbolsCompanion.insert(
            name: name,
            displayName: displayName,
            displayExPrecision: displayExPrecision,
            type: type,
            pipSize: pipSize,
            pipLocation: pipLocation,
            unitsPerLot: unitsPerLot,
            displayPrecision: displayPrecision,
            marginRate: marginRate,
            minimumTradeSize: minimumTradeSize,
            minLot: minLot,
            maxLot: maxLot,
            lotStep: lotStep,
            tradeUnitsPrecision: tradeUnitsPrecision,
            isWatchlisted: isWatchlisted,
            watchlistSortOrder: watchlistSortOrder,
            sortOrder: sortOrder,
            lastUpdatedUs: lastUpdatedUs,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SymbolsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SymbolsTable,
    Symbol,
    $$SymbolsTableFilterComposer,
    $$SymbolsTableOrderingComposer,
    $$SymbolsTableAnnotationComposer,
    $$SymbolsTableCreateCompanionBuilder,
    $$SymbolsTableUpdateCompanionBuilder,
    (Symbol, BaseReferences<_$AppDatabase, $SymbolsTable, Symbol>),
    Symbol,
    PrefetchHooks Function()>;
typedef $$PositionsTableCreateCompanionBuilder = PositionsCompanion Function({
  Value<int> id,
  required String oandaTradeId,
  required String symbol,
  required String direction,
  required double lots,
  required double units,
  required double openPrice,
  Value<double> currentPrice,
  Value<double?> stopLoss,
  Value<double?> takeProfit,
  Value<double> floatingPnl,
  Value<double> swap,
  Value<double> commission,
  Value<double> marginUsed,
  required int openTimeUs,
  Value<int> magicNumber,
  Value<String> comment,
  Value<bool> isModifying,
});
typedef $$PositionsTableUpdateCompanionBuilder = PositionsCompanion Function({
  Value<int> id,
  Value<String> oandaTradeId,
  Value<String> symbol,
  Value<String> direction,
  Value<double> lots,
  Value<double> units,
  Value<double> openPrice,
  Value<double> currentPrice,
  Value<double?> stopLoss,
  Value<double?> takeProfit,
  Value<double> floatingPnl,
  Value<double> swap,
  Value<double> commission,
  Value<double> marginUsed,
  Value<int> openTimeUs,
  Value<int> magicNumber,
  Value<String> comment,
  Value<bool> isModifying,
});

class $$PositionsTableFilterComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oandaTradeId => $composableBuilder(
      column: $table.oandaTradeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lots => $composableBuilder(
      column: $table.lots, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openPrice => $composableBuilder(
      column: $table.openPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stopLoss => $composableBuilder(
      column: $table.stopLoss, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get floatingPnl => $composableBuilder(
      column: $table.floatingPnl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get swap => $composableBuilder(
      column: $table.swap, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get commission => $composableBuilder(
      column: $table.commission, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marginUsed => $composableBuilder(
      column: $table.marginUsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isModifying => $composableBuilder(
      column: $table.isModifying, builder: (column) => ColumnFilters(column));
}

class $$PositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oandaTradeId => $composableBuilder(
      column: $table.oandaTradeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lots => $composableBuilder(
      column: $table.lots, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openPrice => $composableBuilder(
      column: $table.openPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentPrice => $composableBuilder(
      column: $table.currentPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stopLoss => $composableBuilder(
      column: $table.stopLoss, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get floatingPnl => $composableBuilder(
      column: $table.floatingPnl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get swap => $composableBuilder(
      column: $table.swap, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get commission => $composableBuilder(
      column: $table.commission, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marginUsed => $composableBuilder(
      column: $table.marginUsed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isModifying => $composableBuilder(
      column: $table.isModifying, builder: (column) => ColumnOrderings(column));
}

class $$PositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get oandaTradeId => $composableBuilder(
      column: $table.oandaTradeId, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<double> get lots =>
      $composableBuilder(column: $table.lots, builder: (column) => column);

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<double> get openPrice =>
      $composableBuilder(column: $table.openPrice, builder: (column) => column);

  GeneratedColumn<double> get currentPrice => $composableBuilder(
      column: $table.currentPrice, builder: (column) => column);

  GeneratedColumn<double> get stopLoss =>
      $composableBuilder(column: $table.stopLoss, builder: (column) => column);

  GeneratedColumn<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => column);

  GeneratedColumn<double> get floatingPnl => $composableBuilder(
      column: $table.floatingPnl, builder: (column) => column);

  GeneratedColumn<double> get swap =>
      $composableBuilder(column: $table.swap, builder: (column) => column);

  GeneratedColumn<double> get commission => $composableBuilder(
      column: $table.commission, builder: (column) => column);

  GeneratedColumn<double> get marginUsed => $composableBuilder(
      column: $table.marginUsed, builder: (column) => column);

  GeneratedColumn<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => column);

  GeneratedColumn<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<bool> get isModifying => $composableBuilder(
      column: $table.isModifying, builder: (column) => column);
}

class $$PositionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PositionsTable,
    Position,
    $$PositionsTableFilterComposer,
    $$PositionsTableOrderingComposer,
    $$PositionsTableAnnotationComposer,
    $$PositionsTableCreateCompanionBuilder,
    $$PositionsTableUpdateCompanionBuilder,
    (Position, BaseReferences<_$AppDatabase, $PositionsTable, Position>),
    Position,
    PrefetchHooks Function()> {
  $$PositionsTableTableManager(_$AppDatabase db, $PositionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> oandaTradeId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> direction = const Value.absent(),
            Value<double> lots = const Value.absent(),
            Value<double> units = const Value.absent(),
            Value<double> openPrice = const Value.absent(),
            Value<double> currentPrice = const Value.absent(),
            Value<double?> stopLoss = const Value.absent(),
            Value<double?> takeProfit = const Value.absent(),
            Value<double> floatingPnl = const Value.absent(),
            Value<double> swap = const Value.absent(),
            Value<double> commission = const Value.absent(),
            Value<double> marginUsed = const Value.absent(),
            Value<int> openTimeUs = const Value.absent(),
            Value<int> magicNumber = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<bool> isModifying = const Value.absent(),
          }) =>
              PositionsCompanion(
            id: id,
            oandaTradeId: oandaTradeId,
            symbol: symbol,
            direction: direction,
            lots: lots,
            units: units,
            openPrice: openPrice,
            currentPrice: currentPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            floatingPnl: floatingPnl,
            swap: swap,
            commission: commission,
            marginUsed: marginUsed,
            openTimeUs: openTimeUs,
            magicNumber: magicNumber,
            comment: comment,
            isModifying: isModifying,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String oandaTradeId,
            required String symbol,
            required String direction,
            required double lots,
            required double units,
            required double openPrice,
            Value<double> currentPrice = const Value.absent(),
            Value<double?> stopLoss = const Value.absent(),
            Value<double?> takeProfit = const Value.absent(),
            Value<double> floatingPnl = const Value.absent(),
            Value<double> swap = const Value.absent(),
            Value<double> commission = const Value.absent(),
            Value<double> marginUsed = const Value.absent(),
            required int openTimeUs,
            Value<int> magicNumber = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<bool> isModifying = const Value.absent(),
          }) =>
              PositionsCompanion.insert(
            id: id,
            oandaTradeId: oandaTradeId,
            symbol: symbol,
            direction: direction,
            lots: lots,
            units: units,
            openPrice: openPrice,
            currentPrice: currentPrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            floatingPnl: floatingPnl,
            swap: swap,
            commission: commission,
            marginUsed: marginUsed,
            openTimeUs: openTimeUs,
            magicNumber: magicNumber,
            comment: comment,
            isModifying: isModifying,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PositionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PositionsTable,
    Position,
    $$PositionsTableFilterComposer,
    $$PositionsTableOrderingComposer,
    $$PositionsTableAnnotationComposer,
    $$PositionsTableCreateCompanionBuilder,
    $$PositionsTableUpdateCompanionBuilder,
    (Position, BaseReferences<_$AppDatabase, $PositionsTable, Position>),
    Position,
    PrefetchHooks Function()>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  required String oandaOrderId,
  required String symbol,
  required String orderType,
  required String direction,
  required double lots,
  required double units,
  required double price,
  Value<double?> priceBound,
  Value<double?> stopLoss,
  Value<double?> takeProfit,
  Value<String> timeInForce,
  Value<String> status,
  required int createTimeUs,
  Value<int?> expiryTimeUs,
  Value<int> magicNumber,
  Value<String> comment,
  Value<int> rowid,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<String> oandaOrderId,
  Value<String> symbol,
  Value<String> orderType,
  Value<String> direction,
  Value<double> lots,
  Value<double> units,
  Value<double> price,
  Value<double?> priceBound,
  Value<double?> stopLoss,
  Value<double?> takeProfit,
  Value<String> timeInForce,
  Value<String> status,
  Value<int> createTimeUs,
  Value<int?> expiryTimeUs,
  Value<int> magicNumber,
  Value<String> comment,
  Value<int> rowid,
});

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get oandaOrderId => $composableBuilder(
      column: $table.oandaOrderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lots => $composableBuilder(
      column: $table.lots, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priceBound => $composableBuilder(
      column: $table.priceBound, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stopLoss => $composableBuilder(
      column: $table.stopLoss, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeInForce => $composableBuilder(
      column: $table.timeInForce, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createTimeUs => $composableBuilder(
      column: $table.createTimeUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expiryTimeUs => $composableBuilder(
      column: $table.expiryTimeUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get oandaOrderId => $composableBuilder(
      column: $table.oandaOrderId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lots => $composableBuilder(
      column: $table.lots, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priceBound => $composableBuilder(
      column: $table.priceBound, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stopLoss => $composableBuilder(
      column: $table.stopLoss, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeInForce => $composableBuilder(
      column: $table.timeInForce, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createTimeUs => $composableBuilder(
      column: $table.createTimeUs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expiryTimeUs => $composableBuilder(
      column: $table.expiryTimeUs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get oandaOrderId => $composableBuilder(
      column: $table.oandaOrderId, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<double> get lots =>
      $composableBuilder(column: $table.lots, builder: (column) => column);

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get priceBound => $composableBuilder(
      column: $table.priceBound, builder: (column) => column);

  GeneratedColumn<double> get stopLoss =>
      $composableBuilder(column: $table.stopLoss, builder: (column) => column);

  GeneratedColumn<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => column);

  GeneratedColumn<String> get timeInForce => $composableBuilder(
      column: $table.timeInForce, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createTimeUs => $composableBuilder(
      column: $table.createTimeUs, builder: (column) => column);

  GeneratedColumn<int> get expiryTimeUs => $composableBuilder(
      column: $table.expiryTimeUs, builder: (column) => column);

  GeneratedColumn<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
    Order,
    PrefetchHooks Function()> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> oandaOrderId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String> direction = const Value.absent(),
            Value<double> lots = const Value.absent(),
            Value<double> units = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> priceBound = const Value.absent(),
            Value<double?> stopLoss = const Value.absent(),
            Value<double?> takeProfit = const Value.absent(),
            Value<String> timeInForce = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> createTimeUs = const Value.absent(),
            Value<int?> expiryTimeUs = const Value.absent(),
            Value<int> magicNumber = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersCompanion(
            oandaOrderId: oandaOrderId,
            symbol: symbol,
            orderType: orderType,
            direction: direction,
            lots: lots,
            units: units,
            price: price,
            priceBound: priceBound,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            timeInForce: timeInForce,
            status: status,
            createTimeUs: createTimeUs,
            expiryTimeUs: expiryTimeUs,
            magicNumber: magicNumber,
            comment: comment,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String oandaOrderId,
            required String symbol,
            required String orderType,
            required String direction,
            required double lots,
            required double units,
            required double price,
            Value<double?> priceBound = const Value.absent(),
            Value<double?> stopLoss = const Value.absent(),
            Value<double?> takeProfit = const Value.absent(),
            Value<String> timeInForce = const Value.absent(),
            Value<String> status = const Value.absent(),
            required int createTimeUs,
            Value<int?> expiryTimeUs = const Value.absent(),
            Value<int> magicNumber = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersCompanion.insert(
            oandaOrderId: oandaOrderId,
            symbol: symbol,
            orderType: orderType,
            direction: direction,
            lots: lots,
            units: units,
            price: price,
            priceBound: priceBound,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            timeInForce: timeInForce,
            status: status,
            createTimeUs: createTimeUs,
            expiryTimeUs: expiryTimeUs,
            magicNumber: magicNumber,
            comment: comment,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, BaseReferences<_$AppDatabase, $OrdersTable, Order>),
    Order,
    PrefetchHooks Function()>;
typedef $$ClosedTradesTableCreateCompanionBuilder = ClosedTradesCompanion
    Function({
  Value<int> id,
  required String oandaTradeId,
  required String symbol,
  required String direction,
  required double lots,
  required double units,
  required double openPrice,
  required double closePrice,
  Value<double?> stopLoss,
  Value<double?> takeProfit,
  required double realizedPnl,
  Value<double> swap,
  Value<double> commission,
  required double netProfit,
  Value<double?> maxProfit,
  Value<double?> maxDrawdown,
  Value<double?> priceDeltaPips,
  Value<String> closeReason,
  required int openTimeUs,
  required int closeTimeUs,
  required int durationSeconds,
  Value<String?> openSession,
  Value<int> magicNumber,
  Value<String> comment,
  required String closeDate,
});
typedef $$ClosedTradesTableUpdateCompanionBuilder = ClosedTradesCompanion
    Function({
  Value<int> id,
  Value<String> oandaTradeId,
  Value<String> symbol,
  Value<String> direction,
  Value<double> lots,
  Value<double> units,
  Value<double> openPrice,
  Value<double> closePrice,
  Value<double?> stopLoss,
  Value<double?> takeProfit,
  Value<double> realizedPnl,
  Value<double> swap,
  Value<double> commission,
  Value<double> netProfit,
  Value<double?> maxProfit,
  Value<double?> maxDrawdown,
  Value<double?> priceDeltaPips,
  Value<String> closeReason,
  Value<int> openTimeUs,
  Value<int> closeTimeUs,
  Value<int> durationSeconds,
  Value<String?> openSession,
  Value<int> magicNumber,
  Value<String> comment,
  Value<String> closeDate,
});

class $$ClosedTradesTableFilterComposer
    extends Composer<_$AppDatabase, $ClosedTradesTable> {
  $$ClosedTradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oandaTradeId => $composableBuilder(
      column: $table.oandaTradeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lots => $composableBuilder(
      column: $table.lots, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get openPrice => $composableBuilder(
      column: $table.openPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stopLoss => $composableBuilder(
      column: $table.stopLoss, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get realizedPnl => $composableBuilder(
      column: $table.realizedPnl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get swap => $composableBuilder(
      column: $table.swap, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get commission => $composableBuilder(
      column: $table.commission, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netProfit => $composableBuilder(
      column: $table.netProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxProfit => $composableBuilder(
      column: $table.maxProfit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priceDeltaPips => $composableBuilder(
      column: $table.priceDeltaPips,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closeReason => $composableBuilder(
      column: $table.closeReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get closeTimeUs => $composableBuilder(
      column: $table.closeTimeUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openSession => $composableBuilder(
      column: $table.openSession, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closeDate => $composableBuilder(
      column: $table.closeDate, builder: (column) => ColumnFilters(column));
}

class $$ClosedTradesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClosedTradesTable> {
  $$ClosedTradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oandaTradeId => $composableBuilder(
      column: $table.oandaTradeId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lots => $composableBuilder(
      column: $table.lots, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get openPrice => $composableBuilder(
      column: $table.openPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stopLoss => $composableBuilder(
      column: $table.stopLoss, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get realizedPnl => $composableBuilder(
      column: $table.realizedPnl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get swap => $composableBuilder(
      column: $table.swap, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get commission => $composableBuilder(
      column: $table.commission, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netProfit => $composableBuilder(
      column: $table.netProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxProfit => $composableBuilder(
      column: $table.maxProfit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priceDeltaPips => $composableBuilder(
      column: $table.priceDeltaPips,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closeReason => $composableBuilder(
      column: $table.closeReason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get closeTimeUs => $composableBuilder(
      column: $table.closeTimeUs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openSession => $composableBuilder(
      column: $table.openSession, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closeDate => $composableBuilder(
      column: $table.closeDate, builder: (column) => ColumnOrderings(column));
}

class $$ClosedTradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClosedTradesTable> {
  $$ClosedTradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get oandaTradeId => $composableBuilder(
      column: $table.oandaTradeId, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<double> get lots =>
      $composableBuilder(column: $table.lots, builder: (column) => column);

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<double> get openPrice =>
      $composableBuilder(column: $table.openPrice, builder: (column) => column);

  GeneratedColumn<double> get closePrice => $composableBuilder(
      column: $table.closePrice, builder: (column) => column);

  GeneratedColumn<double> get stopLoss =>
      $composableBuilder(column: $table.stopLoss, builder: (column) => column);

  GeneratedColumn<double> get takeProfit => $composableBuilder(
      column: $table.takeProfit, builder: (column) => column);

  GeneratedColumn<double> get realizedPnl => $composableBuilder(
      column: $table.realizedPnl, builder: (column) => column);

  GeneratedColumn<double> get swap =>
      $composableBuilder(column: $table.swap, builder: (column) => column);

  GeneratedColumn<double> get commission => $composableBuilder(
      column: $table.commission, builder: (column) => column);

  GeneratedColumn<double> get netProfit =>
      $composableBuilder(column: $table.netProfit, builder: (column) => column);

  GeneratedColumn<double> get maxProfit =>
      $composableBuilder(column: $table.maxProfit, builder: (column) => column);

  GeneratedColumn<double> get maxDrawdown => $composableBuilder(
      column: $table.maxDrawdown, builder: (column) => column);

  GeneratedColumn<double> get priceDeltaPips => $composableBuilder(
      column: $table.priceDeltaPips, builder: (column) => column);

  GeneratedColumn<String> get closeReason => $composableBuilder(
      column: $table.closeReason, builder: (column) => column);

  GeneratedColumn<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => column);

  GeneratedColumn<int> get closeTimeUs => $composableBuilder(
      column: $table.closeTimeUs, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  GeneratedColumn<String> get openSession => $composableBuilder(
      column: $table.openSession, builder: (column) => column);

  GeneratedColumn<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<String> get closeDate =>
      $composableBuilder(column: $table.closeDate, builder: (column) => column);
}

class $$ClosedTradesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClosedTradesTable,
    ClosedTrade,
    $$ClosedTradesTableFilterComposer,
    $$ClosedTradesTableOrderingComposer,
    $$ClosedTradesTableAnnotationComposer,
    $$ClosedTradesTableCreateCompanionBuilder,
    $$ClosedTradesTableUpdateCompanionBuilder,
    (
      ClosedTrade,
      BaseReferences<_$AppDatabase, $ClosedTradesTable, ClosedTrade>
    ),
    ClosedTrade,
    PrefetchHooks Function()> {
  $$ClosedTradesTableTableManager(_$AppDatabase db, $ClosedTradesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClosedTradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClosedTradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClosedTradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> oandaTradeId = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> direction = const Value.absent(),
            Value<double> lots = const Value.absent(),
            Value<double> units = const Value.absent(),
            Value<double> openPrice = const Value.absent(),
            Value<double> closePrice = const Value.absent(),
            Value<double?> stopLoss = const Value.absent(),
            Value<double?> takeProfit = const Value.absent(),
            Value<double> realizedPnl = const Value.absent(),
            Value<double> swap = const Value.absent(),
            Value<double> commission = const Value.absent(),
            Value<double> netProfit = const Value.absent(),
            Value<double?> maxProfit = const Value.absent(),
            Value<double?> maxDrawdown = const Value.absent(),
            Value<double?> priceDeltaPips = const Value.absent(),
            Value<String> closeReason = const Value.absent(),
            Value<int> openTimeUs = const Value.absent(),
            Value<int> closeTimeUs = const Value.absent(),
            Value<int> durationSeconds = const Value.absent(),
            Value<String?> openSession = const Value.absent(),
            Value<int> magicNumber = const Value.absent(),
            Value<String> comment = const Value.absent(),
            Value<String> closeDate = const Value.absent(),
          }) =>
              ClosedTradesCompanion(
            id: id,
            oandaTradeId: oandaTradeId,
            symbol: symbol,
            direction: direction,
            lots: lots,
            units: units,
            openPrice: openPrice,
            closePrice: closePrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            realizedPnl: realizedPnl,
            swap: swap,
            commission: commission,
            netProfit: netProfit,
            maxProfit: maxProfit,
            maxDrawdown: maxDrawdown,
            priceDeltaPips: priceDeltaPips,
            closeReason: closeReason,
            openTimeUs: openTimeUs,
            closeTimeUs: closeTimeUs,
            durationSeconds: durationSeconds,
            openSession: openSession,
            magicNumber: magicNumber,
            comment: comment,
            closeDate: closeDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String oandaTradeId,
            required String symbol,
            required String direction,
            required double lots,
            required double units,
            required double openPrice,
            required double closePrice,
            Value<double?> stopLoss = const Value.absent(),
            Value<double?> takeProfit = const Value.absent(),
            required double realizedPnl,
            Value<double> swap = const Value.absent(),
            Value<double> commission = const Value.absent(),
            required double netProfit,
            Value<double?> maxProfit = const Value.absent(),
            Value<double?> maxDrawdown = const Value.absent(),
            Value<double?> priceDeltaPips = const Value.absent(),
            Value<String> closeReason = const Value.absent(),
            required int openTimeUs,
            required int closeTimeUs,
            required int durationSeconds,
            Value<String?> openSession = const Value.absent(),
            Value<int> magicNumber = const Value.absent(),
            Value<String> comment = const Value.absent(),
            required String closeDate,
          }) =>
              ClosedTradesCompanion.insert(
            id: id,
            oandaTradeId: oandaTradeId,
            symbol: symbol,
            direction: direction,
            lots: lots,
            units: units,
            openPrice: openPrice,
            closePrice: closePrice,
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            realizedPnl: realizedPnl,
            swap: swap,
            commission: commission,
            netProfit: netProfit,
            maxProfit: maxProfit,
            maxDrawdown: maxDrawdown,
            priceDeltaPips: priceDeltaPips,
            closeReason: closeReason,
            openTimeUs: openTimeUs,
            closeTimeUs: closeTimeUs,
            durationSeconds: durationSeconds,
            openSession: openSession,
            magicNumber: magicNumber,
            comment: comment,
            closeDate: closeDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClosedTradesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClosedTradesTable,
    ClosedTrade,
    $$ClosedTradesTableFilterComposer,
    $$ClosedTradesTableOrderingComposer,
    $$ClosedTradesTableAnnotationComposer,
    $$ClosedTradesTableCreateCompanionBuilder,
    $$ClosedTradesTableUpdateCompanionBuilder,
    (
      ClosedTrade,
      BaseReferences<_$AppDatabase, $ClosedTradesTable, ClosedTrade>
    ),
    ClosedTrade,
    PrefetchHooks Function()>;
typedef $$AccountSnapshotsTableCreateCompanionBuilder
    = AccountSnapshotsCompanion Function({
  Value<int> id,
  required String accountId,
  required double balance,
  required double equity,
  required double marginUsed,
  required double marginAvailable,
  Value<double?> marginLevel,
  Value<double?> nav,
  Value<int> openPositionCount,
  Value<double> unrealizedPnl,
  Value<double> dailyRealizedPnl,
  Value<String> snapshotTrigger,
  required int timestampUs,
  required String date,
});
typedef $$AccountSnapshotsTableUpdateCompanionBuilder
    = AccountSnapshotsCompanion Function({
  Value<int> id,
  Value<String> accountId,
  Value<double> balance,
  Value<double> equity,
  Value<double> marginUsed,
  Value<double> marginAvailable,
  Value<double?> marginLevel,
  Value<double?> nav,
  Value<int> openPositionCount,
  Value<double> unrealizedPnl,
  Value<double> dailyRealizedPnl,
  Value<String> snapshotTrigger,
  Value<int> timestampUs,
  Value<String> date,
});

class $$AccountSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountSnapshotsTable> {
  $$AccountSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get equity => $composableBuilder(
      column: $table.equity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marginUsed => $composableBuilder(
      column: $table.marginUsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marginAvailable => $composableBuilder(
      column: $table.marginAvailable,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marginLevel => $composableBuilder(
      column: $table.marginLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get nav => $composableBuilder(
      column: $table.nav, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openPositionCount => $composableBuilder(
      column: $table.openPositionCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unrealizedPnl => $composableBuilder(
      column: $table.unrealizedPnl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dailyRealizedPnl => $composableBuilder(
      column: $table.dailyRealizedPnl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotTrigger => $composableBuilder(
      column: $table.snapshotTrigger,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));
}

class $$AccountSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountSnapshotsTable> {
  $$AccountSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get equity => $composableBuilder(
      column: $table.equity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marginUsed => $composableBuilder(
      column: $table.marginUsed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marginAvailable => $composableBuilder(
      column: $table.marginAvailable,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marginLevel => $composableBuilder(
      column: $table.marginLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get nav => $composableBuilder(
      column: $table.nav, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openPositionCount => $composableBuilder(
      column: $table.openPositionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unrealizedPnl => $composableBuilder(
      column: $table.unrealizedPnl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dailyRealizedPnl => $composableBuilder(
      column: $table.dailyRealizedPnl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotTrigger => $composableBuilder(
      column: $table.snapshotTrigger,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));
}

class $$AccountSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountSnapshotsTable> {
  $$AccountSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<double> get equity =>
      $composableBuilder(column: $table.equity, builder: (column) => column);

  GeneratedColumn<double> get marginUsed => $composableBuilder(
      column: $table.marginUsed, builder: (column) => column);

  GeneratedColumn<double> get marginAvailable => $composableBuilder(
      column: $table.marginAvailable, builder: (column) => column);

  GeneratedColumn<double> get marginLevel => $composableBuilder(
      column: $table.marginLevel, builder: (column) => column);

  GeneratedColumn<double> get nav =>
      $composableBuilder(column: $table.nav, builder: (column) => column);

  GeneratedColumn<int> get openPositionCount => $composableBuilder(
      column: $table.openPositionCount, builder: (column) => column);

  GeneratedColumn<double> get unrealizedPnl => $composableBuilder(
      column: $table.unrealizedPnl, builder: (column) => column);

  GeneratedColumn<double> get dailyRealizedPnl => $composableBuilder(
      column: $table.dailyRealizedPnl, builder: (column) => column);

  GeneratedColumn<String> get snapshotTrigger => $composableBuilder(
      column: $table.snapshotTrigger, builder: (column) => column);

  GeneratedColumn<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);
}

class $$AccountSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountSnapshotsTable,
    AccountSnapshot,
    $$AccountSnapshotsTableFilterComposer,
    $$AccountSnapshotsTableOrderingComposer,
    $$AccountSnapshotsTableAnnotationComposer,
    $$AccountSnapshotsTableCreateCompanionBuilder,
    $$AccountSnapshotsTableUpdateCompanionBuilder,
    (
      AccountSnapshot,
      BaseReferences<_$AppDatabase, $AccountSnapshotsTable, AccountSnapshot>
    ),
    AccountSnapshot,
    PrefetchHooks Function()> {
  $$AccountSnapshotsTableTableManager(
      _$AppDatabase db, $AccountSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<double> balance = const Value.absent(),
            Value<double> equity = const Value.absent(),
            Value<double> marginUsed = const Value.absent(),
            Value<double> marginAvailable = const Value.absent(),
            Value<double?> marginLevel = const Value.absent(),
            Value<double?> nav = const Value.absent(),
            Value<int> openPositionCount = const Value.absent(),
            Value<double> unrealizedPnl = const Value.absent(),
            Value<double> dailyRealizedPnl = const Value.absent(),
            Value<String> snapshotTrigger = const Value.absent(),
            Value<int> timestampUs = const Value.absent(),
            Value<String> date = const Value.absent(),
          }) =>
              AccountSnapshotsCompanion(
            id: id,
            accountId: accountId,
            balance: balance,
            equity: equity,
            marginUsed: marginUsed,
            marginAvailable: marginAvailable,
            marginLevel: marginLevel,
            nav: nav,
            openPositionCount: openPositionCount,
            unrealizedPnl: unrealizedPnl,
            dailyRealizedPnl: dailyRealizedPnl,
            snapshotTrigger: snapshotTrigger,
            timestampUs: timestampUs,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String accountId,
            required double balance,
            required double equity,
            required double marginUsed,
            required double marginAvailable,
            Value<double?> marginLevel = const Value.absent(),
            Value<double?> nav = const Value.absent(),
            Value<int> openPositionCount = const Value.absent(),
            Value<double> unrealizedPnl = const Value.absent(),
            Value<double> dailyRealizedPnl = const Value.absent(),
            Value<String> snapshotTrigger = const Value.absent(),
            required int timestampUs,
            required String date,
          }) =>
              AccountSnapshotsCompanion.insert(
            id: id,
            accountId: accountId,
            balance: balance,
            equity: equity,
            marginUsed: marginUsed,
            marginAvailable: marginAvailable,
            marginLevel: marginLevel,
            nav: nav,
            openPositionCount: openPositionCount,
            unrealizedPnl: unrealizedPnl,
            dailyRealizedPnl: dailyRealizedPnl,
            snapshotTrigger: snapshotTrigger,
            timestampUs: timestampUs,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountSnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountSnapshotsTable,
    AccountSnapshot,
    $$AccountSnapshotsTableFilterComposer,
    $$AccountSnapshotsTableOrderingComposer,
    $$AccountSnapshotsTableAnnotationComposer,
    $$AccountSnapshotsTableCreateCompanionBuilder,
    $$AccountSnapshotsTableUpdateCompanionBuilder,
    (
      AccountSnapshot,
      BaseReferences<_$AppDatabase, $AccountSnapshotsTable, AccountSnapshot>
    ),
    AccountSnapshot,
    PrefetchHooks Function()>;
typedef $$EaInstancesTableCreateCompanionBuilder = EaInstancesCompanion
    Function({
  Value<int> id,
  required String name,
  required String symbol,
  required String scriptPath,
  required int magicNumber,
  Value<double> lotSize,
  Value<int> maxPositions,
  Value<int> killSwitchTimeoutSeconds,
  Value<double?> dailyLossLimit,
  Value<bool> autoStartOnBoot,
  Value<String> status,
  required int createdAtUs,
  Value<int?> lastStartedAtUs,
  Value<int?> lastStoppedAtUs,
  Value<int> totalTrades,
  Value<double> netPnl,
  Value<double> winRate,
  Value<String> customParams,
});
typedef $$EaInstancesTableUpdateCompanionBuilder = EaInstancesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> symbol,
  Value<String> scriptPath,
  Value<int> magicNumber,
  Value<double> lotSize,
  Value<int> maxPositions,
  Value<int> killSwitchTimeoutSeconds,
  Value<double?> dailyLossLimit,
  Value<bool> autoStartOnBoot,
  Value<String> status,
  Value<int> createdAtUs,
  Value<int?> lastStartedAtUs,
  Value<int?> lastStoppedAtUs,
  Value<int> totalTrades,
  Value<double> netPnl,
  Value<double> winRate,
  Value<String> customParams,
});

class $$EaInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $EaInstancesTable> {
  $$EaInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scriptPath => $composableBuilder(
      column: $table.scriptPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lotSize => $composableBuilder(
      column: $table.lotSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxPositions => $composableBuilder(
      column: $table.maxPositions, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get killSwitchTimeoutSeconds => $composableBuilder(
      column: $table.killSwitchTimeoutSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dailyLossLimit => $composableBuilder(
      column: $table.dailyLossLimit,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoStartOnBoot => $composableBuilder(
      column: $table.autoStartOnBoot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtUs => $composableBuilder(
      column: $table.createdAtUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastStartedAtUs => $composableBuilder(
      column: $table.lastStartedAtUs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastStoppedAtUs => $composableBuilder(
      column: $table.lastStoppedAtUs,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTrades => $composableBuilder(
      column: $table.totalTrades, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netPnl => $composableBuilder(
      column: $table.netPnl, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get winRate => $composableBuilder(
      column: $table.winRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customParams => $composableBuilder(
      column: $table.customParams, builder: (column) => ColumnFilters(column));
}

class $$EaInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $EaInstancesTable> {
  $$EaInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scriptPath => $composableBuilder(
      column: $table.scriptPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lotSize => $composableBuilder(
      column: $table.lotSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxPositions => $composableBuilder(
      column: $table.maxPositions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get killSwitchTimeoutSeconds => $composableBuilder(
      column: $table.killSwitchTimeoutSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dailyLossLimit => $composableBuilder(
      column: $table.dailyLossLimit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoStartOnBoot => $composableBuilder(
      column: $table.autoStartOnBoot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtUs => $composableBuilder(
      column: $table.createdAtUs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastStartedAtUs => $composableBuilder(
      column: $table.lastStartedAtUs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastStoppedAtUs => $composableBuilder(
      column: $table.lastStoppedAtUs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTrades => $composableBuilder(
      column: $table.totalTrades, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netPnl => $composableBuilder(
      column: $table.netPnl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get winRate => $composableBuilder(
      column: $table.winRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customParams => $composableBuilder(
      column: $table.customParams,
      builder: (column) => ColumnOrderings(column));
}

class $$EaInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EaInstancesTable> {
  $$EaInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get scriptPath => $composableBuilder(
      column: $table.scriptPath, builder: (column) => column);

  GeneratedColumn<int> get magicNumber => $composableBuilder(
      column: $table.magicNumber, builder: (column) => column);

  GeneratedColumn<double> get lotSize =>
      $composableBuilder(column: $table.lotSize, builder: (column) => column);

  GeneratedColumn<int> get maxPositions => $composableBuilder(
      column: $table.maxPositions, builder: (column) => column);

  GeneratedColumn<int> get killSwitchTimeoutSeconds => $composableBuilder(
      column: $table.killSwitchTimeoutSeconds, builder: (column) => column);

  GeneratedColumn<double> get dailyLossLimit => $composableBuilder(
      column: $table.dailyLossLimit, builder: (column) => column);

  GeneratedColumn<bool> get autoStartOnBoot => $composableBuilder(
      column: $table.autoStartOnBoot, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAtUs => $composableBuilder(
      column: $table.createdAtUs, builder: (column) => column);

  GeneratedColumn<int> get lastStartedAtUs => $composableBuilder(
      column: $table.lastStartedAtUs, builder: (column) => column);

  GeneratedColumn<int> get lastStoppedAtUs => $composableBuilder(
      column: $table.lastStoppedAtUs, builder: (column) => column);

  GeneratedColumn<int> get totalTrades => $composableBuilder(
      column: $table.totalTrades, builder: (column) => column);

  GeneratedColumn<double> get netPnl =>
      $composableBuilder(column: $table.netPnl, builder: (column) => column);

  GeneratedColumn<double> get winRate =>
      $composableBuilder(column: $table.winRate, builder: (column) => column);

  GeneratedColumn<String> get customParams => $composableBuilder(
      column: $table.customParams, builder: (column) => column);
}

class $$EaInstancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EaInstancesTable,
    EaInstance,
    $$EaInstancesTableFilterComposer,
    $$EaInstancesTableOrderingComposer,
    $$EaInstancesTableAnnotationComposer,
    $$EaInstancesTableCreateCompanionBuilder,
    $$EaInstancesTableUpdateCompanionBuilder,
    (EaInstance, BaseReferences<_$AppDatabase, $EaInstancesTable, EaInstance>),
    EaInstance,
    PrefetchHooks Function()> {
  $$EaInstancesTableTableManager(_$AppDatabase db, $EaInstancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EaInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EaInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EaInstancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> scriptPath = const Value.absent(),
            Value<int> magicNumber = const Value.absent(),
            Value<double> lotSize = const Value.absent(),
            Value<int> maxPositions = const Value.absent(),
            Value<int> killSwitchTimeoutSeconds = const Value.absent(),
            Value<double?> dailyLossLimit = const Value.absent(),
            Value<bool> autoStartOnBoot = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> createdAtUs = const Value.absent(),
            Value<int?> lastStartedAtUs = const Value.absent(),
            Value<int?> lastStoppedAtUs = const Value.absent(),
            Value<int> totalTrades = const Value.absent(),
            Value<double> netPnl = const Value.absent(),
            Value<double> winRate = const Value.absent(),
            Value<String> customParams = const Value.absent(),
          }) =>
              EaInstancesCompanion(
            id: id,
            name: name,
            symbol: symbol,
            scriptPath: scriptPath,
            magicNumber: magicNumber,
            lotSize: lotSize,
            maxPositions: maxPositions,
            killSwitchTimeoutSeconds: killSwitchTimeoutSeconds,
            dailyLossLimit: dailyLossLimit,
            autoStartOnBoot: autoStartOnBoot,
            status: status,
            createdAtUs: createdAtUs,
            lastStartedAtUs: lastStartedAtUs,
            lastStoppedAtUs: lastStoppedAtUs,
            totalTrades: totalTrades,
            netPnl: netPnl,
            winRate: winRate,
            customParams: customParams,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String symbol,
            required String scriptPath,
            required int magicNumber,
            Value<double> lotSize = const Value.absent(),
            Value<int> maxPositions = const Value.absent(),
            Value<int> killSwitchTimeoutSeconds = const Value.absent(),
            Value<double?> dailyLossLimit = const Value.absent(),
            Value<bool> autoStartOnBoot = const Value.absent(),
            Value<String> status = const Value.absent(),
            required int createdAtUs,
            Value<int?> lastStartedAtUs = const Value.absent(),
            Value<int?> lastStoppedAtUs = const Value.absent(),
            Value<int> totalTrades = const Value.absent(),
            Value<double> netPnl = const Value.absent(),
            Value<double> winRate = const Value.absent(),
            Value<String> customParams = const Value.absent(),
          }) =>
              EaInstancesCompanion.insert(
            id: id,
            name: name,
            symbol: symbol,
            scriptPath: scriptPath,
            magicNumber: magicNumber,
            lotSize: lotSize,
            maxPositions: maxPositions,
            killSwitchTimeoutSeconds: killSwitchTimeoutSeconds,
            dailyLossLimit: dailyLossLimit,
            autoStartOnBoot: autoStartOnBoot,
            status: status,
            createdAtUs: createdAtUs,
            lastStartedAtUs: lastStartedAtUs,
            lastStoppedAtUs: lastStoppedAtUs,
            totalTrades: totalTrades,
            netPnl: netPnl,
            winRate: winRate,
            customParams: customParams,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EaInstancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EaInstancesTable,
    EaInstance,
    $$EaInstancesTableFilterComposer,
    $$EaInstancesTableOrderingComposer,
    $$EaInstancesTableAnnotationComposer,
    $$EaInstancesTableCreateCompanionBuilder,
    $$EaInstancesTableUpdateCompanionBuilder,
    (EaInstance, BaseReferences<_$AppDatabase, $EaInstancesTable, EaInstance>),
    EaInstance,
    PrefetchHooks Function()>;
typedef $$EaLogsTableCreateCompanionBuilder = EaLogsCompanion Function({
  Value<int> id,
  required int eaInstanceId,
  required String level,
  Value<String> source,
  required String message,
  required int timestampUs,
});
typedef $$EaLogsTableUpdateCompanionBuilder = EaLogsCompanion Function({
  Value<int> id,
  Value<int> eaInstanceId,
  Value<String> level,
  Value<String> source,
  Value<String> message,
  Value<int> timestampUs,
});

class $$EaLogsTableFilterComposer
    extends Composer<_$AppDatabase, $EaLogsTable> {
  $$EaLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get eaInstanceId => $composableBuilder(
      column: $table.eaInstanceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => ColumnFilters(column));
}

class $$EaLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $EaLogsTable> {
  $$EaLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get eaInstanceId => $composableBuilder(
      column: $table.eaInstanceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => ColumnOrderings(column));
}

class $$EaLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EaLogsTable> {
  $$EaLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get eaInstanceId => $composableBuilder(
      column: $table.eaInstanceId, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<int> get timestampUs => $composableBuilder(
      column: $table.timestampUs, builder: (column) => column);
}

class $$EaLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EaLogsTable,
    EaLog,
    $$EaLogsTableFilterComposer,
    $$EaLogsTableOrderingComposer,
    $$EaLogsTableAnnotationComposer,
    $$EaLogsTableCreateCompanionBuilder,
    $$EaLogsTableUpdateCompanionBuilder,
    (EaLog, BaseReferences<_$AppDatabase, $EaLogsTable, EaLog>),
    EaLog,
    PrefetchHooks Function()> {
  $$EaLogsTableTableManager(_$AppDatabase db, $EaLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EaLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EaLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EaLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> eaInstanceId = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<int> timestampUs = const Value.absent(),
          }) =>
              EaLogsCompanion(
            id: id,
            eaInstanceId: eaInstanceId,
            level: level,
            source: source,
            message: message,
            timestampUs: timestampUs,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int eaInstanceId,
            required String level,
            Value<String> source = const Value.absent(),
            required String message,
            required int timestampUs,
          }) =>
              EaLogsCompanion.insert(
            id: id,
            eaInstanceId: eaInstanceId,
            level: level,
            source: source,
            message: message,
            timestampUs: timestampUs,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EaLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EaLogsTable,
    EaLog,
    $$EaLogsTableFilterComposer,
    $$EaLogsTableOrderingComposer,
    $$EaLogsTableAnnotationComposer,
    $$EaLogsTableCreateCompanionBuilder,
    $$EaLogsTableUpdateCompanionBuilder,
    (EaLog, BaseReferences<_$AppDatabase, $EaLogsTable, EaLog>),
    EaLog,
    PrefetchHooks Function()>;
typedef $$CandlesTableCreateCompanionBuilder = CandlesCompanion Function({
  Value<int> id,
  required String symbol,
  required String timeframe,
  required int openTimeUs,
  required double open,
  required double high,
  required double low,
  required double close,
  Value<double> volume,
  Value<bool> isComplete,
});
typedef $$CandlesTableUpdateCompanionBuilder = CandlesCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<String> timeframe,
  Value<int> openTimeUs,
  Value<double> open,
  Value<double> high,
  Value<double> low,
  Value<double> close,
  Value<double> volume,
  Value<bool> isComplete,
});

class $$CandlesTableFilterComposer
    extends Composer<_$AppDatabase, $CandlesTable> {
  $$CandlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timeframe => $composableBuilder(
      column: $table.timeframe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get open => $composableBuilder(
      column: $table.open, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get high => $composableBuilder(
      column: $table.high, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get low => $composableBuilder(
      column: $table.low, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get close => $composableBuilder(
      column: $table.close, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get volume => $composableBuilder(
      column: $table.volume, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isComplete => $composableBuilder(
      column: $table.isComplete, builder: (column) => ColumnFilters(column));
}

class $$CandlesTableOrderingComposer
    extends Composer<_$AppDatabase, $CandlesTable> {
  $$CandlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timeframe => $composableBuilder(
      column: $table.timeframe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get open => $composableBuilder(
      column: $table.open, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get high => $composableBuilder(
      column: $table.high, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get low => $composableBuilder(
      column: $table.low, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get close => $composableBuilder(
      column: $table.close, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get volume => $composableBuilder(
      column: $table.volume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isComplete => $composableBuilder(
      column: $table.isComplete, builder: (column) => ColumnOrderings(column));
}

class $$CandlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CandlesTable> {
  $$CandlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get timeframe =>
      $composableBuilder(column: $table.timeframe, builder: (column) => column);

  GeneratedColumn<int> get openTimeUs => $composableBuilder(
      column: $table.openTimeUs, builder: (column) => column);

  GeneratedColumn<double> get open =>
      $composableBuilder(column: $table.open, builder: (column) => column);

  GeneratedColumn<double> get high =>
      $composableBuilder(column: $table.high, builder: (column) => column);

  GeneratedColumn<double> get low =>
      $composableBuilder(column: $table.low, builder: (column) => column);

  GeneratedColumn<double> get close =>
      $composableBuilder(column: $table.close, builder: (column) => column);

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<bool> get isComplete => $composableBuilder(
      column: $table.isComplete, builder: (column) => column);
}

class $$CandlesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CandlesTable,
    Candle,
    $$CandlesTableFilterComposer,
    $$CandlesTableOrderingComposer,
    $$CandlesTableAnnotationComposer,
    $$CandlesTableCreateCompanionBuilder,
    $$CandlesTableUpdateCompanionBuilder,
    (Candle, BaseReferences<_$AppDatabase, $CandlesTable, Candle>),
    Candle,
    PrefetchHooks Function()> {
  $$CandlesTableTableManager(_$AppDatabase db, $CandlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CandlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CandlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CandlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> timeframe = const Value.absent(),
            Value<int> openTimeUs = const Value.absent(),
            Value<double> open = const Value.absent(),
            Value<double> high = const Value.absent(),
            Value<double> low = const Value.absent(),
            Value<double> close = const Value.absent(),
            Value<double> volume = const Value.absent(),
            Value<bool> isComplete = const Value.absent(),
          }) =>
              CandlesCompanion(
            id: id,
            symbol: symbol,
            timeframe: timeframe,
            openTimeUs: openTimeUs,
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
            isComplete: isComplete,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String symbol,
            required String timeframe,
            required int openTimeUs,
            required double open,
            required double high,
            required double low,
            required double close,
            Value<double> volume = const Value.absent(),
            Value<bool> isComplete = const Value.absent(),
          }) =>
              CandlesCompanion.insert(
            id: id,
            symbol: symbol,
            timeframe: timeframe,
            openTimeUs: openTimeUs,
            open: open,
            high: high,
            low: low,
            close: close,
            volume: volume,
            isComplete: isComplete,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CandlesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CandlesTable,
    Candle,
    $$CandlesTableFilterComposer,
    $$CandlesTableOrderingComposer,
    $$CandlesTableAnnotationComposer,
    $$CandlesTableCreateCompanionBuilder,
    $$CandlesTableUpdateCompanionBuilder,
    (Candle, BaseReferences<_$AppDatabase, $CandlesTable, Candle>),
    Candle,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TicksTableTableManager get ticks =>
      $$TicksTableTableManager(_db, _db.ticks);
  $$SymbolsTableTableManager get symbols =>
      $$SymbolsTableTableManager(_db, _db.symbols);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db, _db.positions);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$ClosedTradesTableTableManager get closedTrades =>
      $$ClosedTradesTableTableManager(_db, _db.closedTrades);
  $$AccountSnapshotsTableTableManager get accountSnapshots =>
      $$AccountSnapshotsTableTableManager(_db, _db.accountSnapshots);
  $$EaInstancesTableTableManager get eaInstances =>
      $$EaInstancesTableTableManager(_db, _db.eaInstances);
  $$EaLogsTableTableManager get eaLogs =>
      $$EaLogsTableTableManager(_db, _db.eaLogs);
  $$CandlesTableTableManager get candles =>
      $$CandlesTableTableManager(_db, _db.candles);
}
