// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameSessionsTable extends GameSessions
    with TableInfo<$GameSessionsTable, GameSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _solutionNumberMeta = const VerificationMeta(
    'solutionNumber',
  );
  @override
  late final GeneratedColumn<int> solutionNumber = GeneratedColumn<int>(
    'solution_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _piecesPlacedMeta = const VerificationMeta(
    'piecesPlaced',
  );
  @override
  late final GeneratedColumn<int> piecesPlaced = GeneratedColumn<int>(
    'pieces_placed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numUndosMeta = const VerificationMeta(
    'numUndos',
  );
  @override
  late final GeneratedColumn<int> numUndos = GeneratedColumn<int>(
    'num_undos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _playerNotesMeta = const VerificationMeta(
    'playerNotes',
  );
  @override
  late final GeneratedColumn<String> playerNotes = GeneratedColumn<String>(
    'player_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    solutionNumber,
    elapsedSeconds,
    score,
    piecesPlaced,
    numUndos,
    completedAt,
    playerNotes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('solution_number')) {
      context.handle(
        _solutionNumberMeta,
        solutionNumber.isAcceptableOrUnknown(
          data['solution_number']!,
          _solutionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_solutionNumberMeta);
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedSecondsMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('pieces_placed')) {
      context.handle(
        _piecesPlacedMeta,
        piecesPlaced.isAcceptableOrUnknown(
          data['pieces_placed']!,
          _piecesPlacedMeta,
        ),
      );
    }
    if (data.containsKey('num_undos')) {
      context.handle(
        _numUndosMeta,
        numUndos.isAcceptableOrUnknown(data['num_undos']!, _numUndosMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('player_notes')) {
      context.handle(
        _playerNotesMeta,
        playerNotes.isAcceptableOrUnknown(
          data['player_notes']!,
          _playerNotesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      solutionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}solution_number'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      ),
      piecesPlaced: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pieces_placed'],
      ),
      numUndos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}num_undos'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      playerNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_notes'],
      ),
    );
  }

  @override
  $GameSessionsTable createAlias(String alias) {
    return $GameSessionsTable(attachedDatabase, alias);
  }
}

class GameSession extends DataClass implements Insertable<GameSession> {
  final int id;
  final int solutionNumber;
  final int elapsedSeconds;
  final int? score;
  final int? piecesPlaced;
  final int? numUndos;
  final DateTime completedAt;
  final String? playerNotes;
  const GameSession({
    required this.id,
    required this.solutionNumber,
    required this.elapsedSeconds,
    this.score,
    this.piecesPlaced,
    this.numUndos,
    required this.completedAt,
    this.playerNotes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['solution_number'] = Variable<int>(solutionNumber);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    if (!nullToAbsent || piecesPlaced != null) {
      map['pieces_placed'] = Variable<int>(piecesPlaced);
    }
    if (!nullToAbsent || numUndos != null) {
      map['num_undos'] = Variable<int>(numUndos);
    }
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || playerNotes != null) {
      map['player_notes'] = Variable<String>(playerNotes);
    }
    return map;
  }

  GameSessionsCompanion toCompanion(bool nullToAbsent) {
    return GameSessionsCompanion(
      id: Value(id),
      solutionNumber: Value(solutionNumber),
      elapsedSeconds: Value(elapsedSeconds),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      piecesPlaced: piecesPlaced == null && nullToAbsent
          ? const Value.absent()
          : Value(piecesPlaced),
      numUndos: numUndos == null && nullToAbsent
          ? const Value.absent()
          : Value(numUndos),
      completedAt: Value(completedAt),
      playerNotes: playerNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(playerNotes),
    );
  }

  factory GameSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameSession(
      id: serializer.fromJson<int>(json['id']),
      solutionNumber: serializer.fromJson<int>(json['solutionNumber']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      score: serializer.fromJson<int?>(json['score']),
      piecesPlaced: serializer.fromJson<int?>(json['piecesPlaced']),
      numUndos: serializer.fromJson<int?>(json['numUndos']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      playerNotes: serializer.fromJson<String?>(json['playerNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'solutionNumber': serializer.toJson<int>(solutionNumber),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'score': serializer.toJson<int?>(score),
      'piecesPlaced': serializer.toJson<int?>(piecesPlaced),
      'numUndos': serializer.toJson<int?>(numUndos),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'playerNotes': serializer.toJson<String?>(playerNotes),
    };
  }

  GameSession copyWith({
    int? id,
    int? solutionNumber,
    int? elapsedSeconds,
    Value<int?> score = const Value.absent(),
    Value<int?> piecesPlaced = const Value.absent(),
    Value<int?> numUndos = const Value.absent(),
    DateTime? completedAt,
    Value<String?> playerNotes = const Value.absent(),
  }) => GameSession(
    id: id ?? this.id,
    solutionNumber: solutionNumber ?? this.solutionNumber,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    score: score.present ? score.value : this.score,
    piecesPlaced: piecesPlaced.present ? piecesPlaced.value : this.piecesPlaced,
    numUndos: numUndos.present ? numUndos.value : this.numUndos,
    completedAt: completedAt ?? this.completedAt,
    playerNotes: playerNotes.present ? playerNotes.value : this.playerNotes,
  );
  GameSession copyWithCompanion(GameSessionsCompanion data) {
    return GameSession(
      id: data.id.present ? data.id.value : this.id,
      solutionNumber: data.solutionNumber.present
          ? data.solutionNumber.value
          : this.solutionNumber,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      score: data.score.present ? data.score.value : this.score,
      piecesPlaced: data.piecesPlaced.present
          ? data.piecesPlaced.value
          : this.piecesPlaced,
      numUndos: data.numUndos.present ? data.numUndos.value : this.numUndos,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      playerNotes: data.playerNotes.present
          ? data.playerNotes.value
          : this.playerNotes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameSession(')
          ..write('id: $id, ')
          ..write('solutionNumber: $solutionNumber, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('score: $score, ')
          ..write('piecesPlaced: $piecesPlaced, ')
          ..write('numUndos: $numUndos, ')
          ..write('completedAt: $completedAt, ')
          ..write('playerNotes: $playerNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    solutionNumber,
    elapsedSeconds,
    score,
    piecesPlaced,
    numUndos,
    completedAt,
    playerNotes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameSession &&
          other.id == this.id &&
          other.solutionNumber == this.solutionNumber &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.score == this.score &&
          other.piecesPlaced == this.piecesPlaced &&
          other.numUndos == this.numUndos &&
          other.completedAt == this.completedAt &&
          other.playerNotes == this.playerNotes);
}

class GameSessionsCompanion extends UpdateCompanion<GameSession> {
  final Value<int> id;
  final Value<int> solutionNumber;
  final Value<int> elapsedSeconds;
  final Value<int?> score;
  final Value<int?> piecesPlaced;
  final Value<int?> numUndos;
  final Value<DateTime> completedAt;
  final Value<String?> playerNotes;
  const GameSessionsCompanion({
    this.id = const Value.absent(),
    this.solutionNumber = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.score = const Value.absent(),
    this.piecesPlaced = const Value.absent(),
    this.numUndos = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.playerNotes = const Value.absent(),
  });
  GameSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int solutionNumber,
    required int elapsedSeconds,
    this.score = const Value.absent(),
    this.piecesPlaced = const Value.absent(),
    this.numUndos = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.playerNotes = const Value.absent(),
  }) : solutionNumber = Value(solutionNumber),
       elapsedSeconds = Value(elapsedSeconds);
  static Insertable<GameSession> custom({
    Expression<int>? id,
    Expression<int>? solutionNumber,
    Expression<int>? elapsedSeconds,
    Expression<int>? score,
    Expression<int>? piecesPlaced,
    Expression<int>? numUndos,
    Expression<DateTime>? completedAt,
    Expression<String>? playerNotes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (solutionNumber != null) 'solution_number': solutionNumber,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (score != null) 'score': score,
      if (piecesPlaced != null) 'pieces_placed': piecesPlaced,
      if (numUndos != null) 'num_undos': numUndos,
      if (completedAt != null) 'completed_at': completedAt,
      if (playerNotes != null) 'player_notes': playerNotes,
    });
  }

  GameSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? solutionNumber,
    Value<int>? elapsedSeconds,
    Value<int?>? score,
    Value<int?>? piecesPlaced,
    Value<int?>? numUndos,
    Value<DateTime>? completedAt,
    Value<String?>? playerNotes,
  }) {
    return GameSessionsCompanion(
      id: id ?? this.id,
      solutionNumber: solutionNumber ?? this.solutionNumber,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      score: score ?? this.score,
      piecesPlaced: piecesPlaced ?? this.piecesPlaced,
      numUndos: numUndos ?? this.numUndos,
      completedAt: completedAt ?? this.completedAt,
      playerNotes: playerNotes ?? this.playerNotes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (solutionNumber.present) {
      map['solution_number'] = Variable<int>(solutionNumber.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (piecesPlaced.present) {
      map['pieces_placed'] = Variable<int>(piecesPlaced.value);
    }
    if (numUndos.present) {
      map['num_undos'] = Variable<int>(numUndos.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (playerNotes.present) {
      map['player_notes'] = Variable<String>(playerNotes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameSessionsCompanion(')
          ..write('id: $id, ')
          ..write('solutionNumber: $solutionNumber, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('score: $score, ')
          ..write('piecesPlaced: $piecesPlaced, ')
          ..write('numUndos: $numUndos, ')
          ..write('completedAt: $completedAt, ')
          ..write('playerNotes: $playerNotes')
          ..write(')'))
        .toString();
  }
}

class $SolutionStatsTable extends SolutionStats
    with TableInfo<$SolutionStatsTable, SolutionStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SolutionStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _solutionNumberMeta = const VerificationMeta(
    'solutionNumber',
  );
  @override
  late final GeneratedColumn<int> solutionNumber = GeneratedColumn<int>(
    'solution_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _timesPlayedMeta = const VerificationMeta(
    'timesPlayed',
  );
  @override
  late final GeneratedColumn<int> timesPlayed = GeneratedColumn<int>(
    'times_played',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestTimeMeta = const VerificationMeta(
    'bestTime',
  );
  @override
  late final GeneratedColumn<int> bestTime = GeneratedColumn<int>(
    'best_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(-1),
  );
  static const VerificationMeta _averageTimeMeta = const VerificationMeta(
    'averageTime',
  );
  @override
  late final GeneratedColumn<int> averageTime = GeneratedColumn<int>(
    'average_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestScoreMeta = const VerificationMeta(
    'bestScore',
  );
  @override
  late final GeneratedColumn<int> bestScore = GeneratedColumn<int>(
    'best_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstPlayedMeta = const VerificationMeta(
    'firstPlayed',
  );
  @override
  late final GeneratedColumn<DateTime> firstPlayed = GeneratedColumn<DateTime>(
    'first_played',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPlayedMeta = const VerificationMeta(
    'lastPlayed',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayed = GeneratedColumn<DateTime>(
    'last_played',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    solutionNumber,
    timesPlayed,
    bestTime,
    averageTime,
    bestScore,
    firstPlayed,
    lastPlayed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'solution_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<SolutionStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('solution_number')) {
      context.handle(
        _solutionNumberMeta,
        solutionNumber.isAcceptableOrUnknown(
          data['solution_number']!,
          _solutionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_solutionNumberMeta);
    }
    if (data.containsKey('times_played')) {
      context.handle(
        _timesPlayedMeta,
        timesPlayed.isAcceptableOrUnknown(
          data['times_played']!,
          _timesPlayedMeta,
        ),
      );
    }
    if (data.containsKey('best_time')) {
      context.handle(
        _bestTimeMeta,
        bestTime.isAcceptableOrUnknown(data['best_time']!, _bestTimeMeta),
      );
    }
    if (data.containsKey('average_time')) {
      context.handle(
        _averageTimeMeta,
        averageTime.isAcceptableOrUnknown(
          data['average_time']!,
          _averageTimeMeta,
        ),
      );
    }
    if (data.containsKey('best_score')) {
      context.handle(
        _bestScoreMeta,
        bestScore.isAcceptableOrUnknown(data['best_score']!, _bestScoreMeta),
      );
    }
    if (data.containsKey('first_played')) {
      context.handle(
        _firstPlayedMeta,
        firstPlayed.isAcceptableOrUnknown(
          data['first_played']!,
          _firstPlayedMeta,
        ),
      );
    }
    if (data.containsKey('last_played')) {
      context.handle(
        _lastPlayedMeta,
        lastPlayed.isAcceptableOrUnknown(data['last_played']!, _lastPlayedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SolutionStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SolutionStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      solutionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}solution_number'],
      )!,
      timesPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_played'],
      )!,
      bestTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_time'],
      )!,
      averageTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_time'],
      ),
      bestScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_score'],
      ),
      firstPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_played'],
      ),
      lastPlayed: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played'],
      ),
    );
  }

  @override
  $SolutionStatsTable createAlias(String alias) {
    return $SolutionStatsTable(attachedDatabase, alias);
  }
}

class SolutionStat extends DataClass implements Insertable<SolutionStat> {
  final int id;
  final int solutionNumber;
  final int timesPlayed;
  final int bestTime;
  final int? averageTime;
  final int? bestScore;
  final DateTime? firstPlayed;
  final DateTime? lastPlayed;
  const SolutionStat({
    required this.id,
    required this.solutionNumber,
    required this.timesPlayed,
    required this.bestTime,
    this.averageTime,
    this.bestScore,
    this.firstPlayed,
    this.lastPlayed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['solution_number'] = Variable<int>(solutionNumber);
    map['times_played'] = Variable<int>(timesPlayed);
    map['best_time'] = Variable<int>(bestTime);
    if (!nullToAbsent || averageTime != null) {
      map['average_time'] = Variable<int>(averageTime);
    }
    if (!nullToAbsent || bestScore != null) {
      map['best_score'] = Variable<int>(bestScore);
    }
    if (!nullToAbsent || firstPlayed != null) {
      map['first_played'] = Variable<DateTime>(firstPlayed);
    }
    if (!nullToAbsent || lastPlayed != null) {
      map['last_played'] = Variable<DateTime>(lastPlayed);
    }
    return map;
  }

  SolutionStatsCompanion toCompanion(bool nullToAbsent) {
    return SolutionStatsCompanion(
      id: Value(id),
      solutionNumber: Value(solutionNumber),
      timesPlayed: Value(timesPlayed),
      bestTime: Value(bestTime),
      averageTime: averageTime == null && nullToAbsent
          ? const Value.absent()
          : Value(averageTime),
      bestScore: bestScore == null && nullToAbsent
          ? const Value.absent()
          : Value(bestScore),
      firstPlayed: firstPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(firstPlayed),
      lastPlayed: lastPlayed == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayed),
    );
  }

  factory SolutionStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SolutionStat(
      id: serializer.fromJson<int>(json['id']),
      solutionNumber: serializer.fromJson<int>(json['solutionNumber']),
      timesPlayed: serializer.fromJson<int>(json['timesPlayed']),
      bestTime: serializer.fromJson<int>(json['bestTime']),
      averageTime: serializer.fromJson<int?>(json['averageTime']),
      bestScore: serializer.fromJson<int?>(json['bestScore']),
      firstPlayed: serializer.fromJson<DateTime?>(json['firstPlayed']),
      lastPlayed: serializer.fromJson<DateTime?>(json['lastPlayed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'solutionNumber': serializer.toJson<int>(solutionNumber),
      'timesPlayed': serializer.toJson<int>(timesPlayed),
      'bestTime': serializer.toJson<int>(bestTime),
      'averageTime': serializer.toJson<int?>(averageTime),
      'bestScore': serializer.toJson<int?>(bestScore),
      'firstPlayed': serializer.toJson<DateTime?>(firstPlayed),
      'lastPlayed': serializer.toJson<DateTime?>(lastPlayed),
    };
  }

  SolutionStat copyWith({
    int? id,
    int? solutionNumber,
    int? timesPlayed,
    int? bestTime,
    Value<int?> averageTime = const Value.absent(),
    Value<int?> bestScore = const Value.absent(),
    Value<DateTime?> firstPlayed = const Value.absent(),
    Value<DateTime?> lastPlayed = const Value.absent(),
  }) => SolutionStat(
    id: id ?? this.id,
    solutionNumber: solutionNumber ?? this.solutionNumber,
    timesPlayed: timesPlayed ?? this.timesPlayed,
    bestTime: bestTime ?? this.bestTime,
    averageTime: averageTime.present ? averageTime.value : this.averageTime,
    bestScore: bestScore.present ? bestScore.value : this.bestScore,
    firstPlayed: firstPlayed.present ? firstPlayed.value : this.firstPlayed,
    lastPlayed: lastPlayed.present ? lastPlayed.value : this.lastPlayed,
  );
  SolutionStat copyWithCompanion(SolutionStatsCompanion data) {
    return SolutionStat(
      id: data.id.present ? data.id.value : this.id,
      solutionNumber: data.solutionNumber.present
          ? data.solutionNumber.value
          : this.solutionNumber,
      timesPlayed: data.timesPlayed.present
          ? data.timesPlayed.value
          : this.timesPlayed,
      bestTime: data.bestTime.present ? data.bestTime.value : this.bestTime,
      averageTime: data.averageTime.present
          ? data.averageTime.value
          : this.averageTime,
      bestScore: data.bestScore.present ? data.bestScore.value : this.bestScore,
      firstPlayed: data.firstPlayed.present
          ? data.firstPlayed.value
          : this.firstPlayed,
      lastPlayed: data.lastPlayed.present
          ? data.lastPlayed.value
          : this.lastPlayed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SolutionStat(')
          ..write('id: $id, ')
          ..write('solutionNumber: $solutionNumber, ')
          ..write('timesPlayed: $timesPlayed, ')
          ..write('bestTime: $bestTime, ')
          ..write('averageTime: $averageTime, ')
          ..write('bestScore: $bestScore, ')
          ..write('firstPlayed: $firstPlayed, ')
          ..write('lastPlayed: $lastPlayed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    solutionNumber,
    timesPlayed,
    bestTime,
    averageTime,
    bestScore,
    firstPlayed,
    lastPlayed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SolutionStat &&
          other.id == this.id &&
          other.solutionNumber == this.solutionNumber &&
          other.timesPlayed == this.timesPlayed &&
          other.bestTime == this.bestTime &&
          other.averageTime == this.averageTime &&
          other.bestScore == this.bestScore &&
          other.firstPlayed == this.firstPlayed &&
          other.lastPlayed == this.lastPlayed);
}

class SolutionStatsCompanion extends UpdateCompanion<SolutionStat> {
  final Value<int> id;
  final Value<int> solutionNumber;
  final Value<int> timesPlayed;
  final Value<int> bestTime;
  final Value<int?> averageTime;
  final Value<int?> bestScore;
  final Value<DateTime?> firstPlayed;
  final Value<DateTime?> lastPlayed;
  const SolutionStatsCompanion({
    this.id = const Value.absent(),
    this.solutionNumber = const Value.absent(),
    this.timesPlayed = const Value.absent(),
    this.bestTime = const Value.absent(),
    this.averageTime = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.firstPlayed = const Value.absent(),
    this.lastPlayed = const Value.absent(),
  });
  SolutionStatsCompanion.insert({
    this.id = const Value.absent(),
    required int solutionNumber,
    this.timesPlayed = const Value.absent(),
    this.bestTime = const Value.absent(),
    this.averageTime = const Value.absent(),
    this.bestScore = const Value.absent(),
    this.firstPlayed = const Value.absent(),
    this.lastPlayed = const Value.absent(),
  }) : solutionNumber = Value(solutionNumber);
  static Insertable<SolutionStat> custom({
    Expression<int>? id,
    Expression<int>? solutionNumber,
    Expression<int>? timesPlayed,
    Expression<int>? bestTime,
    Expression<int>? averageTime,
    Expression<int>? bestScore,
    Expression<DateTime>? firstPlayed,
    Expression<DateTime>? lastPlayed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (solutionNumber != null) 'solution_number': solutionNumber,
      if (timesPlayed != null) 'times_played': timesPlayed,
      if (bestTime != null) 'best_time': bestTime,
      if (averageTime != null) 'average_time': averageTime,
      if (bestScore != null) 'best_score': bestScore,
      if (firstPlayed != null) 'first_played': firstPlayed,
      if (lastPlayed != null) 'last_played': lastPlayed,
    });
  }

  SolutionStatsCompanion copyWith({
    Value<int>? id,
    Value<int>? solutionNumber,
    Value<int>? timesPlayed,
    Value<int>? bestTime,
    Value<int?>? averageTime,
    Value<int?>? bestScore,
    Value<DateTime?>? firstPlayed,
    Value<DateTime?>? lastPlayed,
  }) {
    return SolutionStatsCompanion(
      id: id ?? this.id,
      solutionNumber: solutionNumber ?? this.solutionNumber,
      timesPlayed: timesPlayed ?? this.timesPlayed,
      bestTime: bestTime ?? this.bestTime,
      averageTime: averageTime ?? this.averageTime,
      bestScore: bestScore ?? this.bestScore,
      firstPlayed: firstPlayed ?? this.firstPlayed,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (solutionNumber.present) {
      map['solution_number'] = Variable<int>(solutionNumber.value);
    }
    if (timesPlayed.present) {
      map['times_played'] = Variable<int>(timesPlayed.value);
    }
    if (bestTime.present) {
      map['best_time'] = Variable<int>(bestTime.value);
    }
    if (averageTime.present) {
      map['average_time'] = Variable<int>(averageTime.value);
    }
    if (bestScore.present) {
      map['best_score'] = Variable<int>(bestScore.value);
    }
    if (firstPlayed.present) {
      map['first_played'] = Variable<DateTime>(firstPlayed.value);
    }
    if (lastPlayed.present) {
      map['last_played'] = Variable<DateTime>(lastPlayed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SolutionStatsCompanion(')
          ..write('id: $id, ')
          ..write('solutionNumber: $solutionNumber, ')
          ..write('timesPlayed: $timesPlayed, ')
          ..write('bestTime: $bestTime, ')
          ..write('averageTime: $averageTime, ')
          ..write('bestScore: $bestScore, ')
          ..write('firstPlayed: $firstPlayed, ')
          ..write('lastPlayed: $lastPlayed')
          ..write(')'))
        .toString();
  }
}

abstract class _$SettingsDatabase extends GeneratedDatabase {
  _$SettingsDatabase(QueryExecutor e) : super(e);
  $SettingsDatabaseManager get managers => $SettingsDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $GameSessionsTable gameSessions = $GameSessionsTable(this);
  late final $SolutionStatsTable solutionStats = $SolutionStatsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    gameSessions,
    solutionStats,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$SettingsDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$SettingsDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$SettingsDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$SettingsDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            Setting,
            BaseReferences<_$SettingsDatabase, $SettingsTable, Setting>,
          ),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$SettingsDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$SettingsDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$SettingsDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$GameSessionsTableCreateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<int> id,
      required int solutionNumber,
      required int elapsedSeconds,
      Value<int?> score,
      Value<int?> piecesPlaced,
      Value<int?> numUndos,
      Value<DateTime> completedAt,
      Value<String?> playerNotes,
    });
typedef $$GameSessionsTableUpdateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<int> id,
      Value<int> solutionNumber,
      Value<int> elapsedSeconds,
      Value<int?> score,
      Value<int?> piecesPlaced,
      Value<int?> numUndos,
      Value<DateTime> completedAt,
      Value<String?> playerNotes,
    });

class $$GameSessionsTableFilterComposer
    extends Composer<_$SettingsDatabase, $GameSessionsTable> {
  $$GameSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get solutionNumber => $composableBuilder(
    column: $table.solutionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get piecesPlaced => $composableBuilder(
    column: $table.piecesPlaced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numUndos => $composableBuilder(
    column: $table.numUndos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerNotes => $composableBuilder(
    column: $table.playerNotes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameSessionsTableOrderingComposer
    extends Composer<_$SettingsDatabase, $GameSessionsTable> {
  $$GameSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get solutionNumber => $composableBuilder(
    column: $table.solutionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get piecesPlaced => $composableBuilder(
    column: $table.piecesPlaced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numUndos => $composableBuilder(
    column: $table.numUndos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerNotes => $composableBuilder(
    column: $table.playerNotes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameSessionsTableAnnotationComposer
    extends Composer<_$SettingsDatabase, $GameSessionsTable> {
  $$GameSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get solutionNumber => $composableBuilder(
    column: $table.solutionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get piecesPlaced => $composableBuilder(
    column: $table.piecesPlaced,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numUndos =>
      $composableBuilder(column: $table.numUndos, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get playerNotes => $composableBuilder(
    column: $table.playerNotes,
    builder: (column) => column,
  );
}

class $$GameSessionsTableTableManager
    extends
        RootTableManager<
          _$SettingsDatabase,
          $GameSessionsTable,
          GameSession,
          $$GameSessionsTableFilterComposer,
          $$GameSessionsTableOrderingComposer,
          $$GameSessionsTableAnnotationComposer,
          $$GameSessionsTableCreateCompanionBuilder,
          $$GameSessionsTableUpdateCompanionBuilder,
          (
            GameSession,
            BaseReferences<_$SettingsDatabase, $GameSessionsTable, GameSession>,
          ),
          GameSession,
          PrefetchHooks Function()
        > {
  $$GameSessionsTableTableManager(
    _$SettingsDatabase db,
    $GameSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> solutionNumber = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<int?> score = const Value.absent(),
                Value<int?> piecesPlaced = const Value.absent(),
                Value<int?> numUndos = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> playerNotes = const Value.absent(),
              }) => GameSessionsCompanion(
                id: id,
                solutionNumber: solutionNumber,
                elapsedSeconds: elapsedSeconds,
                score: score,
                piecesPlaced: piecesPlaced,
                numUndos: numUndos,
                completedAt: completedAt,
                playerNotes: playerNotes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int solutionNumber,
                required int elapsedSeconds,
                Value<int?> score = const Value.absent(),
                Value<int?> piecesPlaced = const Value.absent(),
                Value<int?> numUndos = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String?> playerNotes = const Value.absent(),
              }) => GameSessionsCompanion.insert(
                id: id,
                solutionNumber: solutionNumber,
                elapsedSeconds: elapsedSeconds,
                score: score,
                piecesPlaced: piecesPlaced,
                numUndos: numUndos,
                completedAt: completedAt,
                playerNotes: playerNotes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$SettingsDatabase,
      $GameSessionsTable,
      GameSession,
      $$GameSessionsTableFilterComposer,
      $$GameSessionsTableOrderingComposer,
      $$GameSessionsTableAnnotationComposer,
      $$GameSessionsTableCreateCompanionBuilder,
      $$GameSessionsTableUpdateCompanionBuilder,
      (
        GameSession,
        BaseReferences<_$SettingsDatabase, $GameSessionsTable, GameSession>,
      ),
      GameSession,
      PrefetchHooks Function()
    >;
typedef $$SolutionStatsTableCreateCompanionBuilder =
    SolutionStatsCompanion Function({
      Value<int> id,
      required int solutionNumber,
      Value<int> timesPlayed,
      Value<int> bestTime,
      Value<int?> averageTime,
      Value<int?> bestScore,
      Value<DateTime?> firstPlayed,
      Value<DateTime?> lastPlayed,
    });
typedef $$SolutionStatsTableUpdateCompanionBuilder =
    SolutionStatsCompanion Function({
      Value<int> id,
      Value<int> solutionNumber,
      Value<int> timesPlayed,
      Value<int> bestTime,
      Value<int?> averageTime,
      Value<int?> bestScore,
      Value<DateTime?> firstPlayed,
      Value<DateTime?> lastPlayed,
    });

class $$SolutionStatsTableFilterComposer
    extends Composer<_$SettingsDatabase, $SolutionStatsTable> {
  $$SolutionStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get solutionNumber => $composableBuilder(
    column: $table.solutionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesPlayed => $composableBuilder(
    column: $table.timesPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestTime => $composableBuilder(
    column: $table.bestTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageTime => $composableBuilder(
    column: $table.averageTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstPlayed => $composableBuilder(
    column: $table.firstPlayed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayed => $composableBuilder(
    column: $table.lastPlayed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SolutionStatsTableOrderingComposer
    extends Composer<_$SettingsDatabase, $SolutionStatsTable> {
  $$SolutionStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get solutionNumber => $composableBuilder(
    column: $table.solutionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesPlayed => $composableBuilder(
    column: $table.timesPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestTime => $composableBuilder(
    column: $table.bestTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageTime => $composableBuilder(
    column: $table.averageTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestScore => $composableBuilder(
    column: $table.bestScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstPlayed => $composableBuilder(
    column: $table.firstPlayed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayed => $composableBuilder(
    column: $table.lastPlayed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SolutionStatsTableAnnotationComposer
    extends Composer<_$SettingsDatabase, $SolutionStatsTable> {
  $$SolutionStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get solutionNumber => $composableBuilder(
    column: $table.solutionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesPlayed => $composableBuilder(
    column: $table.timesPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestTime =>
      $composableBuilder(column: $table.bestTime, builder: (column) => column);

  GeneratedColumn<int> get averageTime => $composableBuilder(
    column: $table.averageTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bestScore =>
      $composableBuilder(column: $table.bestScore, builder: (column) => column);

  GeneratedColumn<DateTime> get firstPlayed => $composableBuilder(
    column: $table.firstPlayed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayed => $composableBuilder(
    column: $table.lastPlayed,
    builder: (column) => column,
  );
}

class $$SolutionStatsTableTableManager
    extends
        RootTableManager<
          _$SettingsDatabase,
          $SolutionStatsTable,
          SolutionStat,
          $$SolutionStatsTableFilterComposer,
          $$SolutionStatsTableOrderingComposer,
          $$SolutionStatsTableAnnotationComposer,
          $$SolutionStatsTableCreateCompanionBuilder,
          $$SolutionStatsTableUpdateCompanionBuilder,
          (
            SolutionStat,
            BaseReferences<
              _$SettingsDatabase,
              $SolutionStatsTable,
              SolutionStat
            >,
          ),
          SolutionStat,
          PrefetchHooks Function()
        > {
  $$SolutionStatsTableTableManager(
    _$SettingsDatabase db,
    $SolutionStatsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SolutionStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SolutionStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SolutionStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> solutionNumber = const Value.absent(),
                Value<int> timesPlayed = const Value.absent(),
                Value<int> bestTime = const Value.absent(),
                Value<int?> averageTime = const Value.absent(),
                Value<int?> bestScore = const Value.absent(),
                Value<DateTime?> firstPlayed = const Value.absent(),
                Value<DateTime?> lastPlayed = const Value.absent(),
              }) => SolutionStatsCompanion(
                id: id,
                solutionNumber: solutionNumber,
                timesPlayed: timesPlayed,
                bestTime: bestTime,
                averageTime: averageTime,
                bestScore: bestScore,
                firstPlayed: firstPlayed,
                lastPlayed: lastPlayed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int solutionNumber,
                Value<int> timesPlayed = const Value.absent(),
                Value<int> bestTime = const Value.absent(),
                Value<int?> averageTime = const Value.absent(),
                Value<int?> bestScore = const Value.absent(),
                Value<DateTime?> firstPlayed = const Value.absent(),
                Value<DateTime?> lastPlayed = const Value.absent(),
              }) => SolutionStatsCompanion.insert(
                id: id,
                solutionNumber: solutionNumber,
                timesPlayed: timesPlayed,
                bestTime: bestTime,
                averageTime: averageTime,
                bestScore: bestScore,
                firstPlayed: firstPlayed,
                lastPlayed: lastPlayed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SolutionStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$SettingsDatabase,
      $SolutionStatsTable,
      SolutionStat,
      $$SolutionStatsTableFilterComposer,
      $$SolutionStatsTableOrderingComposer,
      $$SolutionStatsTableAnnotationComposer,
      $$SolutionStatsTableCreateCompanionBuilder,
      $$SolutionStatsTableUpdateCompanionBuilder,
      (
        SolutionStat,
        BaseReferences<_$SettingsDatabase, $SolutionStatsTable, SolutionStat>,
      ),
      SolutionStat,
      PrefetchHooks Function()
    >;

class $SettingsDatabaseManager {
  final _$SettingsDatabase _db;
  $SettingsDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$GameSessionsTableTableManager get gameSessions =>
      $$GameSessionsTableTableManager(_db, _db.gameSessions);
  $$SolutionStatsTableTableManager get solutionStats =>
      $$SolutionStatsTableTableManager(_db, _db.solutionStats);
}
