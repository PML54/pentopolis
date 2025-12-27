// lib/common/services/puzzle_solutions_service.dart
// Generated: 251226
// Gestion des solutions pré-calculées avec numérotation des puzzles
// PRINCIPES: (1) Cache solutions en mémoire, (2) Lazy loading par puzzle, (3) Index = numéro

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

const int _boardCells = 60;
const int _bytesPerSolution = 45;

/// Service centralisé pour les solutions pré-calculées
class PuzzleSolutionsService {
  // Cache en mémoire (lazy-loaded)
  static List<BigInt>? _cachedSolutions;
  bool _isLoading = false;

  /// Charger TOUTES les solutions (appelé une seule fois)
  Future<List<BigInt>> loadAllSolutions() async {
    // Double-check locking pour éviter les chargements multiples
    if (_cachedSolutions != null) {
      return _cachedSolutions!;
    }

    if (_isLoading) {
      // Attendre que le chargement en cours se termine
      while (_cachedSolutions == null && _isLoading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _cachedSolutions!;
    }

    _isLoading = true;
    try {
      final data =
      await rootBundle.load('assets/data/solutions_6x10_normalisees.bin');
      final bytes = data.buffer.asUint8List();

      if (bytes.length % _bytesPerSolution != 0) {
        throw StateError(
          'Taille de fichier invalide: ${bytes.length} octets, '
              'pas multiple de $_bytesPerSolution.',
        );
      }

      final solutionCount = bytes.length ~/ _bytesPerSolution;
      _cachedSolutions = <BigInt>[];

      int offset = 0;
      for (int i = 0; i < solutionCount; i++) {
        final boardBit6 = _bytesToBit6Board(bytes, offset);
        offset += _bytesPerSolution;
        final big = _bit6BoardToBigInt(boardBit6);
        _cachedSolutions!.add(big);
      }

      print('✅ Solutions chargées: ${_cachedSolutions!.length} solutions');
      return _cachedSolutions!;
    } finally {
      _isLoading = false;
    }
  }

  /// Récupérer la solution pour un puzzle spécifique par son numéro
  /// puzzleNumber 1 → index 0
  /// puzzleNumber 42 → index 41
  Future<BigInt?> getSolutionForPuzzle(int puzzleNumber) async {
    final solutions = await loadAllSolutions();
    final index = puzzleNumber - 1; // Conversion 1-indexed → 0-indexed

    if (index < 0 || index >= solutions.length) {
      print('⚠️  Puzzle #$puzzleNumber n\'a pas de solution (total: ${solutions.length})');
      return null;
    }

    return solutions[index];
  }

  /// Récupérer les solutions pour plusieurs puzzles
  Future<Map<int, BigInt>> getSolutionsForPuzzles(
      List<int> puzzleNumbers) async {
    final solutions = await loadAllSolutions();
    final result = <int, BigInt>{};

    for (final number in puzzleNumbers) {
      final index = number - 1;
      if (index >= 0 && index < solutions.length) {
        result[number] = solutions[index];
      }
    }

    return result;
  }

  /// Nombre TOTAL de puzzles disponibles (solutions × 4 variantes)
  /// 1 solution de base → 4 puzzles (rotation 0, 90, 180, 270 + miroirs)
  Future<int> getTotalPuzzleCount() async {
    final solutions = await loadAllSolutions();
    return solutions.length * 4;  // ← ×4 variantes par solution
  }

  /// Nombre de solutions de BASE (avant variantes)
  Future<int> getBaseSolutionCount() async {
    final solutions = await loadAllSolutions();
    return solutions.length;
  }

  /// Convertit un numéro de puzzle en (solution, variante)
  /// puzzleNumber 1-4 → solution 0, variantes 0-3
  /// puzzleNumber 5-8 → solution 1, variantes 0-3
  /// puzzleNumber 9-12 → solution 2, variantes 0-3
  ({int solutionIndex, int variant}) decodePuzzleNumber(int puzzleNumber) {
    final index = puzzleNumber - 1;  // 0-indexed
    final solutionIndex = index ~/ 4;  // Quelle solution de base
    final variant = index % 4;  // Quelle variante (0-3)
    return (solutionIndex: solutionIndex, variant: variant);
  }

  /// Vérifie si un puzzle a une solution pré-calculée
  Future<bool> hasSolution(int puzzleNumber) async {
    final count = await getTotalPuzzleCount();
    return puzzleNumber > 0 && puzzleNumber <= count;
  }

  /// Réinitialiser le cache (utile pour tests ou changement de fichier)
  void clearCache() {
    _cachedSolutions = null;
    _isLoading = false;
  }
}

// ============================================================================
// FONCTIONS UTILITAIRES (Identiques à l'original)
// ============================================================================

List<int> _bytesToBit6Board(Uint8List bytes, int offset) {
  final board = List<int>.filled(_boardCells, 0);

  int byteIndex = offset;
  int currentByte = 0;
  int bitsLeft = 0;

  for (int cell = 0; cell < _boardCells; cell++) {
    int code = 0;
    for (int i = 0; i < 6; i++) {
      if (bitsLeft == 0) {
        currentByte = bytes[byteIndex++];
        bitsLeft = 8;
      }
      final bit = (currentByte >> (bitsLeft - 1)) & 1;
      bitsLeft--;
      code = (code << 1) | bit;
    }
    board[cell] = code;
  }

  return board;
}

BigInt _bit6BoardToBigInt(List<int> boardBit6) {
  BigInt acc = BigInt.zero;
  for (final code in boardBit6) {
    acc = (acc << 6) | BigInt.from(code);
  }
  return acc;
}

// ============================================================================
// PROVIDER RIVERPOD (Singleton)
// ============================================================================

/*
import 'package:flutter_riverpod/flutter_riverpod.dart';

final puzzleSolutionsProvider = Provider<PuzzleSolutionsService>((ref) {
  return PuzzleSolutionsService();
});

// Usage:
final solutionService = ref.read(puzzleSolutionsProvider);
final solution = await solutionService.getSolutionForPuzzle(42);
*/