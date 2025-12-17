// lib/pentoscope/pentoscope_solver.dart
// Modified: 2512161100
// Solveur backtracking lazy: cherche première solution vite, puis toutes avec timeout

import 'dart:async';
import 'package:pentapol/common/pentominos.dart';

/// Solution = liste de placements (pieceId, gridX, gridY, positionIndex)
class SolverPlacement {
  final int pieceId;
  final int gridX;
  final int gridY;
  final int positionIndex;

  const SolverPlacement({
    required this.pieceId,
    required this.gridX,
    required this.gridY,
    required this.positionIndex,
  });

  @override
  String toString() =>
      'Placement(id=$pieceId, grid=($gridX,$gridY), pos=$positionIndex)';
}

typedef Solution = List<SolverPlacement>;

class PentoscopeSolver {
  // Map pieceId → Pento object
  late final Map<int, Pento> _pieceMap;

  PentoscopeSolver() {
    _pieceMap = <int, Pento>{};
    for (final pento in pentominos) {
      _pieceMap[pento.id] = pento;
    }
  }

  /// Cherche la PREMIÈRE solution (rapide, arrête dès trouvée)
  /// Retourne true si elle existe
  bool findFirstSolution(
      List<int> pieceIds,
      int width,
      int height,
      ) {
    final plateau = List<List<int>>.generate(
      height,
          (_) => List<int>.filled(width, 0),
    );
    final placedPieces = <int>[]; // IDs des pièces déjà placées

    return _backtrackFirst(
      pieceIds: pieceIds,
      width: width,
      height: height,
      plateau: plateau,
      placedPieces: placedPieces,
      pieceIndex: 0,
    );
  }

  /// Cherche TOUTES les solutions avec timeout (2s max)
  /// Retourne {solutionCount, solutions}
  Future<SolverResult> findAllSolutions(
      List<int> pieceIds,
      int width,
      int height, {
        Duration timeout = const Duration(seconds: 2),
      }) async {
    final stopwatch = Stopwatch()..start();
    final solutions = <Solution>[];

    final plateau = List<List<int>>.generate(
      height,
          (_) => List<int>.filled(width, 0),
    );
    final placedPieces = <SolverPlacement>[];

    void backtrackAll(int pieceIndex) {
      // Timeout check
      if (stopwatch.elapsedMilliseconds > timeout.inMilliseconds) {
        return;
      }

      // Tous les pièces placées
      if (pieceIndex == pieceIds.length) {
        solutions.add(List<SolverPlacement>.from(placedPieces));
        return;
      }

      final pieceId = pieceIds[pieceIndex];
      final pento = _pieceMap[pieceId]!;

      // Essayer chaque position (rotation/symétrie)
      for (int posIndex = 0; posIndex < pento.numPositions; posIndex++) {
        // Essayer chaque (gridX, gridY)
        for (int gridY = 0; gridY < height; gridY++) {
          for (int gridX = 0; gridX < width; gridX++) {
            if (_canPlace(pento, posIndex, gridX, gridY, width, height, plateau)) {
              // Placer
              _placePiece(pento, posIndex, gridX, gridY, pieceId, plateau);
              placedPieces.add(
                SolverPlacement(
                  pieceId: pieceId,
                  gridX: gridX,
                  gridY: gridY,
                  positionIndex: posIndex,
                ),
              );

              // Récurser
              backtrackAll(pieceIndex + 1);

              // Backtrack
              _removePiece(pento, posIndex, gridX, gridY, plateau);
              placedPieces.removeLast();
            }
          }
        }
      }
    }

    backtrackAll(0);

    return SolverResult(
      solutionCount: solutions.length,
      solutions: solutions,
    );
  }

  /// ============================================================================
  /// HELPERS PRIVÉS
  /// ============================================================================

  bool _backtrackFirst({
    required List<int> pieceIds,
    required int width,
    required int height,
    required List<List<int>> plateau,
    required List<int> placedPieces,
    required int pieceIndex,
  }) {
    // Tous les pièces placées
    if (pieceIndex == pieceIds.length) {
      return true; // Trouvé!
    }

    final pieceId = pieceIds[pieceIndex];
    final pento = _pieceMap[pieceId]!;

    // Essayer chaque position (rotation/symétrie)
    for (int posIndex = 0; posIndex < pento.numPositions; posIndex++) {
      // Essayer chaque (gridX, gridY)
      for (int gridY = 0; gridY < height; gridY++) {
        for (int gridX = 0; gridX < width; gridX++) {
          if (_canPlace(pento, posIndex, gridX, gridY, width, height, plateau)) {
            // Placer
            _placePiece(pento, posIndex, gridX, gridY, pieceId, plateau);
            placedPieces.add(pieceId);

            // Récurser
            if (_backtrackFirst(
              pieceIds: pieceIds,
              width: width,
              height: height,
              plateau: plateau,
              placedPieces: placedPieces,
              pieceIndex: pieceIndex + 1,
            )) {
              return true; // Trouvé!
            }

            // Backtrack
            _removePiece(pento, posIndex, gridX, gridY, plateau);
            placedPieces.removeLast();
          }
        }
      }
    }

    return false; // Pas trouvé pour ce branch
  }

  /// Vérifier si placement possible (pas collision, dans limites)
  bool _canPlace(
      Pento pento,
      int positionIndex,
      int gridX,
      int gridY,
      int width,
      int height,
      List<List<int>> plateau,
      ) {
    final coords = pento.cartesianCoords[positionIndex];

    for (final coord in coords) {
      final absX = gridX + coord[0];
      final absY = gridY + coord[1];

      // Hors limites
      if (absX < 0 || absX >= width || absY < 0 || absY >= height) {
        return false;
      }

      // Collision
      if (plateau[absY][absX] != 0) {
        return false;
      }
    }

    return true;
  }

  /// Placer une pièce sur le plateau
  void _placePiece(
      Pento pento,
      int positionIndex,
      int gridX,
      int gridY,
      int pieceId,
      List<List<int>> plateau,
      ) {
    final coords = pento.cartesianCoords[positionIndex];

    for (final coord in coords) {
      final absX = gridX + coord[0];
      final absY = gridY + coord[1];
      plateau[absY][absX] = pieceId;
    }
  }

  /// Retirer une pièce du plateau
  void _removePiece(
      Pento pento,
      int positionIndex,
      int gridX,
      int gridY,
      List<List<int>> plateau,
      ) {
    final coords = pento.cartesianCoords[positionIndex];

    for (final coord in coords) {
      final absX = gridX + coord[0];
      final absY = gridY + coord[1];
      plateau[absY][absX] = 0;
    }
  }
}

/// Résultat du solveur complet (avec timeout)
class SolverResult {
  final int solutionCount;
  final List<Solution> solutions;

  const SolverResult({
    required this.solutionCount,
    required this.solutions,
  });

  @override
  String toString() =>
      'SolverResult(count=$solutionCount, solutions=${solutions.length})';
}