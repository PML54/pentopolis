// lib/pentoscope/pentoscope_generator.dart
// Modified: 2512161105
// Générator lazy: cherche solutions en live (pas de data table)
// Dimensions transposées: 3×5 = 3 colonnes × 5 lignes (portrait)

import 'dart:math';
import 'package:pentapol/pentoscope/pentoscope_solver.dart';
import 'package:pentapol/pentoscope/piece_difficulty.dart';

/// Générateur de puzzles Pentoscope (lazy, sans table pré-calculée)
class PentoscopeGenerator {
  final Random _random;
  late final PentoscopeSolver _solver;

  PentoscopeGenerator([Random? random])
      : _random = random ?? Random() {
    _solver = PentoscopeSolver();
  }

  /// Génère un puzzle aléatoire pour une taille donnée
  /// Boucle jusqu'à trouver une combinaison valide (avec 1+ solution)
  Future<PentoscopePuzzle> generate(PentoscopeSize size) async {
    while (true) {
      final pieceIds = _selectRandomPieces(size.numPieces);

      // Étape 2: chercher rapidement si solution existe
      final hasFirst = _solver.findFirstSolution(
        pieceIds,
        size.width,
        size.height,
      );

      if (!hasFirst) {
        continue; // Retry
      }

      // Étape 3: chercher TOUTES les solutions avec timeout 2s
      final result = await _solver.findAllSolutions(
        pieceIds,
        size.width,
        size.height,
        timeout: const Duration(seconds: 2),
      );

      // Étape 4: créer puzzle
      return PentoscopePuzzle(
        size: size,
        pieceIds: pieceIds,
        solutionCount: result.solutionCount,
        solutions: result.solutions,
      );
    }
  }

  /// Génère un puzzle en favorisant ceux avec plus de solutions (faciles)
  /// Boucle jusqu'à solutionCount >= threshold
  Future<PentoscopePuzzle> generateEasy(PentoscopeSize size) async {
    const minSolutions = 4; // Au moins 4 solutions pour être "facile"

    while (true) {
      final pieceIds = _selectRandomPieces(size.numPieces);

      final hasFirst = _solver.findFirstSolution(
        pieceIds,
        size.width,
        size.height,
      );

      if (!hasFirst) {
        continue;
      }

      final result = await _solver.findAllSolutions(
        pieceIds,
        size.width,
        size.height,
        timeout: const Duration(seconds: 2),
      );

      // Garder si assez de solutions
      if (result.solutionCount >= minSolutions) {
        return PentoscopePuzzle(
          size: size,
          pieceIds: pieceIds,
          solutionCount: result.solutionCount,
          solutions: result.solutions,
        );
      }
      // Sinon: retry
    }
  }

  /// Génère un puzzle en favorisant ceux avec peu de solutions (durs)
  /// Boucle jusqu'à solutionCount <= threshold
  Future<PentoscopePuzzle> generateHard(PentoscopeSize size) async {
    const maxSolutions = 2; // Max 2 solutions pour être "difficile"

    while (true) {
      final pieceIds = _selectRandomPieces(size.numPieces);

      final hasFirst = _solver.findFirstSolution(
        pieceIds,
        size.width,
        size.height,
      );

      if (!hasFirst) {
        continue;
      }

      final result = await _solver.findAllSolutions(
        pieceIds,
        size.width,
        size.height,
        timeout: const Duration(seconds: 2),
      );

      // Garder si peu de solutions
      if (result.solutionCount <= maxSolutions) {
        return PentoscopePuzzle(
          size: size,
          pieceIds: pieceIds,
          solutionCount: result.solutionCount,
          solutions: result.solutions,
        );
      }
      // Sinon: retry
    }
  }

  /// Sélectionne N pièces aléatoires parmi les 12 disponibles
  List<int> _selectRandomPieces(int count) {
    final all = List<int>.generate(12, (i) => i + 1); // 1..12
    all.shuffle(_random);
    return all.sublist(0, count);
  }
}

/// Configuration d'un puzzle Pentoscope
class PentoscopePuzzle {
  /// Noms des pièces (X, P, T, F, Y, V, U, L, N, W, Z, I)
  static const _pieceNames = [
    'X',
    'P',
    'T',
    'F',
    'Y',
    'V',
    'U',
    'L',
    'N',
    'W',
    'Z',
    'I',
  ];

  final PentoscopeSize size;
  final List<int> pieceIds;
  final int solutionCount;
  final List<Solution> solutions; // Toutes les solutions trouvées

  const PentoscopePuzzle({
    required this.size,
    required this.pieceIds,
    required this.solutionCount,
    required this.solutions,
  });

  /// Description lisible
  String get description =>
      '${size.label} avec ${pieceNames.join(", ")} ($solutionCount solution${solutionCount > 1 ? "s" : ""})';

  /// Retourne les noms des pièces du puzzle
  List<String> get pieceNames =>
      pieceIds.map((id) => _pieceNames[id - 1]).toList();

  @override
  String toString() => 'PentoscopePuzzle($description)';
}

/// Tailles de plateau disponibles (TRANSPOSÉES pour portrait)
enum PentoscopeSize {
  size3x5(0, 3, 5, 3, '3×5'),   // width=3, height=5 (portrait: 3 col × 5 lignes)
  size4x5(1, 4, 5, 4, '4×5'),   // width=4, height=5
  size5x5(2, 5, 5, 5, '5×5');   // width=5, height=5 (carré inchangé)

  final int dataIndex; // Legacy
  final int width;
  final int height;
  final int numPieces;
  final String label;

  const PentoscopeSize(
      this.dataIndex,
      this.width,
      this.height,
      this.numPieces,
      this.label,
      );

  int get area => width * height;
}

/// Statistiques (optionnel - pas vraiment utilisé en lazy mode)
class PentoscopeStats {
  final PentoscopeSize size;
  final String description;

  const PentoscopeStats({
    required this.size,
    required this.description,
  });

  @override
  String toString() => '$description';
}