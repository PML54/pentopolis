// lib/common/services/puzzle_numbering_service.dart
// Generated: 251226
// Numérotation séquentielle des puzzles (déterministe, pas de hash)
// PRINCIPE: Chaque puzzle reçoit un numero unique incrémental
// Format: "puzzle_001" "puzzle_002" ... "puzzle_999999"

// ============================================================================
// STRATÉGIE: SEED = NUMERO (Simple et traçable)
// ============================================================================

class PuzzleNumberingService {
  /// Convertit un numéro de puzzle en seed déterministe
  ///
  /// Avantage: Pas de hash complexe, juste un numéro
  /// puzzle_001 → seed 1
  /// puzzle_042 → seed 42
  /// puzzle_999 → seed 999
  ///
  static int numberToSeed(int puzzleNumber) {
    return puzzleNumber;
  }

  /// Inverse: seed → numero
  static int seedToNumber(int seed) {
    return seed;
  }

  /// Formate un numéro en string lisible
  /// 1 → "puzzle_001"
  /// 42 → "puzzle_042"
  /// 999 → "puzzle_999"
  static String formatPuzzleId(int number) {
    return 'puzzle_${number.toString().padLeft(6, '0')}';
  }

  /// Parse un ID formaté pour récupérer le numéro
  /// "puzzle_001" → 1
  /// "puzzle_042" → 42
  static int parsePuzzleId(String formattedId) {
    final match = RegExp(r'puzzle_(\d+)').firstMatch(formattedId);
    if (match == null) throw FormatException('Invalid puzzle ID: $formattedId');
    return int.parse(match.group(1)!);
  }

  /// Valide le format d'un ID
  static bool isValidPuzzleId(String id) {
    return RegExp(r'^puzzle_\d{6}$').hasMatch(id);
  }
}

// ============================================================================
// EXEMPLE D'UTILISATION
// ============================================================================

/*
final service = PuzzleNumberingService();

// Créer un puzzle avec le numéro 42
final puzzleNumber = 42;
final seed = service.numberToSeed(puzzleNumber);
final formattedId = service.formatPuzzleId(puzzleNumber);  // "puzzle_000042"

// Générer le puzzle
final puzzle = generator.generatePuzzleFromSeed(seed, difficulty: 'medium');

// À la DB, on stocke juste le numéro:
await db.insertPuzzleMetadata(
  puzzleNumber: puzzleNumber,
  puzzleId: formattedId,
  seed: seed,
  difficulty: 'medium',
);

// Pour rejouer le même puzzle (reconstruction):
final savedNumber = 42;
final reconstructedSeed = service.numberToSeed(savedNumber);
final reconstructed = generator.generatePuzzleFromSeed(reconstructedSeed);
*/

// ============================================================================
// ALTERNATIVE: NUMEROTATION HIERARCHIQUE (Pour organisation)
// ============================================================================
// Si tu veux organiser par niveau/pack, tu peux structurer:
// "classical_easy_001" "classical_medium_042" "isopento_advanced_007"

class HierarchicalPuzzleNumbering {
  /// Structure: {pack}_{difficulty}_{number}
  /// Ex: "classical_easy_001" "classical_medium_042"

  static String formatPuzzleId({
    required String pack,        // 'classical', 'isopento', 'speed', etc.
    required String difficulty,  // 'easy', 'medium', 'hard'
    required int number,         // 1, 2, 3, ...
  }) {
    return '${pack}_${difficulty}_${number.toString().padLeft(3, '0')}';
  }

  /// Parse: "classical_easy_001" → (pack, difficulty, number)
  static ({String pack, String difficulty, int number}) parsePuzzleId(
      String formattedId,
      ) {
    final match = RegExp(r'^(\w+)_(\w+)_(\d+)$').firstMatch(formattedId);
    if (match == null) throw FormatException('Invalid puzzle ID: $formattedId');

    return (
    pack: match.group(1)!,
    difficulty: match.group(2)!,
    number: int.parse(match.group(3)!),
    );
  }

  /// Génère une seed unique à partir de la structure
  /// (pack, difficulty, number) → seed unique et reproductible
  static int generateSeed({
    required String pack,
    required String difficulty,
    required int number,
  }) {
    // Créer un seed unique par combinaison
    // "classical" → 1000, "isopento" → 2000, "speed" → 3000
    final packCode = {
      'classical': 1000,
      'isopento': 2000,
      'speed': 3000,
      'challenge': 4000,
    }[pack] ?? 1000;

    // "easy" → +0, "medium" → +1000, "hard" → +2000
    final difficultyCode = {
      'easy': 0,
      'medium': 1000,
      'hard': 2000,
      'extreme': 3000,
    }[difficulty] ?? 0;

    // Seed final = packCode + difficultyCode + number
    return packCode + difficultyCode + number;
  }
}

// ============================================================================
// EXEMPLE: HIERARCHIQUE
// ============================================================================

/*
// Créer un puzzle "classical, medium, #42"
final id = HierarchicalPuzzleNumbering.formatPuzzleId(
  pack: 'classical',
  difficulty: 'medium',
  number: 42,
);  // → "classical_medium_042"

// Générer la seed
final seed = HierarchicalPuzzleNumbering.generateSeed(
  pack: 'classical',
  difficulty: 'medium',
  number: 42,
);  // → 1000 + 1000 + 42 = 2042

// Parser
final parsed = HierarchicalPuzzleNumbering.parsePuzzleId('classical_medium_042');
// → (pack: 'classical', difficulty: 'medium', number: 42)
*/

// ============================================================================
// TABLE DB SIMPLIFIÉE (Avec numéro au lieu de hash)
// ============================================================================

/*
@DataClassName('PuzzleRecord')
class PuzzlesMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Numéro du puzzle (simple, lisible, unique)
  IntColumn get puzzleNumber => integer().unique()();

  // ID formaté (ex: "puzzle_000042")
  TextColumn get puzzleId => text().unique()();

  // Seed généré (pour régénération)
  IntColumn get seed => integer()();

  // Contexte
  TextColumn get difficulty => text()();
  TextColumn get pack => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('PuzzleSession')
class PuzzleSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Référence simple par numéro (plus lisible que hash)
  IntColumn get puzzleNumber => integer()();

  IntColumn get elapsedSeconds => integer()();
  IntColumn get score => integer().nullable()();
  IntColumn get numMoves => integer().nullable()();

  TextColumn get gameMode => text().withDefault(const Constant('classical'))();
  DateTimeColumn get completedAt => dateTime().withDefault(currentDateAndTime)();
}
*/

// ============================================================================
// STATS: Requêtes DB avec numérotation
// ============================================================================

/*
// Récupérer stats du puzzle #42
Future<Map<String, dynamic>> getPuzzleStats(int puzzleNumber) async {
  final sessions = await (select(puzzleSessions)
      ..where((s) => s.puzzleNumber.equals(puzzleNumber)))
      .get();

  return {
    'attempts': sessions.length,
    'bestTime': sessions.map((s) => s.elapsedSeconds).fold<int>(
      double.infinity.toInt(),
      (a, b) => a < b ? a : b,
    ),
  };
}

// Récupérer les puzzles résolus récemment
Future<List<PuzzleRecord>> getRecentlyCompletedPuzzles({int limit = 10}) {
  final recentNumbers = (select(puzzleSessions)
      ..orderBy([(s) => OrderingTerm.desc(s.completedAt)])
      ..limit(limit)
      ..select((s) => s.puzzleNumber))
      .get();

  return (select(puzzlesMetadata)
      ..where((p) => p.puzzleNumber.isIn(recentNumbers)))
      .get();
}
*/