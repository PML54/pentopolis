// lib/pentoscope/pentoscope_provider.dart
// Provider Pentoscope - calqué sur pentomino_game_provider
// CORRIGÉ: Bug de disparition des pièces (sync plateau/placedPieces)
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pentapol/common/pentominos.dart';
import 'package:pentapol/common/plateau.dart';
import 'package:pentapol/common/point.dart';

import 'package:pentapol/pentoscope/pentoscope_generator.dart';
import 'package:pentapol/pentoscope/pentoscope_solver.dart'
    show SolverPlacement, Solution;

// ============================================================================
// ÉTAT
// ============================================================================

final pentoscopeProvider =
NotifierProvider<PentoscopeNotifier, PentoscopeState>(
  PentoscopeNotifier.new,
);

// ============================================================================
// PROVIDER
// ============================================================================

enum PentoscopeDifficulty { easy, random, hard }

class PentoscopeNotifier extends Notifier<PentoscopeState> {
  late final PentoscopeGenerator _generator;

  void applyIsometryRotationCW() {
    _applyIsoUsingLookup((p, idx) => p.rotationCW(idx));
  }

  void applyIsometryRotationTW() {
    _applyIsoUsingLookup((p, idx) => p.rotationTW(idx));
  }

  void applyIsometrySymmetryH() {
    if (state.viewOrientation == ViewOrientation.landscape) {
      _applyIsoUsingLookup((p, idx) => p.symmetryV(idx));
    } else {
      _applyIsoUsingLookup((p, idx) => p.symmetryH(idx));
    }
  }

  void applyIsometrySymmetryV() {
    if (state.viewOrientation == ViewOrientation.landscape) {
      _applyIsoUsingLookup((p, idx) => p.symmetryH(idx));
    } else {
      _applyIsoUsingLookup((p, idx) => p.symmetryV(idx));
    }
  }

  @override
  PentoscopeState build() {
    _generator = PentoscopeGenerator();
    return PentoscopeState.initial();
  }

  // ==========================================================================
  // CORRECTION 1: cancelSelection - reconstruire le plateau
  // ==========================================================================

  void cancelSelection() {
    // Si on avait une pièce placée sélectionnée, il faut la remettre sur le plateau
    if (state.selectedPlacedPiece != null) {
      // Reconstruire le plateau avec TOUTES les pièces y compris celle sélectionnée
      final newPlateau = Plateau.allVisible(
        state.plateau.width,
        state.plateau.height,
      );
      for (final p in state.placedPieces) {
        for (final cell in p.absoluteCells) {
          newPlateau.setCell(cell.x, cell.y, p.piece.id);
        }
      }

      state = state.copyWith(
        plateau: newPlateau,
        clearSelectedPiece: true,
        clearSelectedPlacedPiece: true,
        clearSelectedCellInPiece: true,
        clearPreview: true,
      );
    } else {
      state = state.copyWith(
        clearSelectedPiece: true,
        clearSelectedPlacedPiece: true,
        clearSelectedCellInPiece: true,
        clearPreview: true,
      );
    }
  }

  void clearPreview() {
    state = state.copyWith(clearPreview: true);
  }

  void cycleToNextOrientation() {
    if (state.selectedPiece == null) return;

    final piece = state.selectedPiece!;
    final newIndex = (state.selectedPositionIndex + 1) % piece.numPositions;
    final newCell = _calculateDefaultCell(piece, newIndex);

    final newIndices = Map<int, int>.from(state.piecePositionIndices);
    newIndices[piece.id] = newIndex;

    state = state.copyWith(
      selectedPositionIndex: newIndex,
      piecePositionIndices: newIndices,
      selectedCellInPiece: newCell,
    );
  }

  PentoscopePlacedPiece? getPlacedPieceAt(int x, int y) {
    for (final placed in state.placedPieces) {
      for (final cell in placed.absoluteCells) {
        if (cell.x == x && cell.y == y) {
          return placed;
        }
      }
    }
    return null;
  }

  void removePlacedPiece(PentoscopePlacedPiece placed) {
    final newPlateau = Plateau.allVisible(
      state.plateau.width,
      state.plateau.height,
    );

    for (final p in state.placedPieces) {
      if (p.piece.id == placed.piece.id) continue;
      for (final cell in p.absoluteCells) {
        newPlateau.setCell(cell.x, cell.y, p.piece.id);
      }
    }

    final newPlaced = state.placedPieces
        .where((p) => p.piece.id != placed.piece.id)
        .toList();
    final newAvailable = [...state.availablePieces, placed.piece];

    state = state.copyWith(
      plateau: newPlateau,
      placedPieces: newPlaced,
      availablePieces: newAvailable,
      clearSelectedPiece: true,
      clearSelectedPlacedPiece: true,
      clearSelectedCellInPiece: true,
      isComplete: false,
    );
  }

  // ==========================================================================
  // RESET - génère un nouveau puzzle
  // ==========================================================================

  Future<void> reset() async {
    final puzzle = state.puzzle;
    if (puzzle == null) return;

    // Générer un nouveau puzzle avec la même taille
    final newPuzzle = await _generator.generate(puzzle.size);

    final pieces = newPuzzle.pieceIds
        .map((id) => pentominos.firstWhere((p) => p.id == id))
        .toList();

    final plateau = Plateau.allVisible(puzzle.size.width, puzzle.size.height);

    Solution? firstSolution;
    if (state.showSolution && newPuzzle.solutions.isNotEmpty) {
      firstSolution = newPuzzle.solutions[0];
    }

    state = PentoscopeState(
      viewOrientation: state.viewOrientation,
      puzzle: newPuzzle,
      plateau: plateau,
      availablePieces: pieces,
      placedPieces: [],
      piecePositionIndices: {},
      isComplete: false,
      isometryCount: 0,
      translationCount: 0,
      showSolution: state.showSolution,
      // ✅ Récupérer de state
      currentSolution: firstSolution, // ✅ Stocker la solution
    );
  }

  // ==========================================================================
  // SÉLECTION PIÈCE (SLIDER)
  // ==========================================================================
  void selectPiece(Pento piece) {
    final positionIndex = state.getPiecePositionIndex(piece.id);
    final defaultCell = _calculateDefaultCell(piece, positionIndex);
    _cancelSelectedPlacedPieceIfAny();

    // ✅ RESTAURER LE PLATEAU COMPLET avec TOUTES les pièces placées
    final newPlateau = Plateau.allVisible(
      state.plateau.width,
      state.plateau.height,
    );
    for (final p in state.placedPieces) {
      for (final cell in p.absoluteCells) {
        newPlateau.setCell(cell.x, cell.y, p.piece.id);
      }
    }

    state = state.copyWith(
      plateau: newPlateau,
      // ← CLÉ!
      selectedPiece: piece,
      selectedPositionIndex: positionIndex,
      clearSelectedPlacedPiece: true,
      selectedCellInPiece: defaultCell,
    );
  }

  // ==========================================================================
  // SÉLECTION PIÈCE PLACÉE (avec mastercase)
  // ==========================================================================

  void selectPlacedPiece(
      PentoscopePlacedPiece placed,
      int absoluteX,
      int absoluteY,
      ) {
    // Calculer la cellule locale cliquée (mastercase)
    final localX = absoluteX - placed.gridX;
    final localY = absoluteY - placed.gridY;

    // Retirer la pièce du plateau temporairement
    final newPlateau = Plateau.allVisible(
      state.plateau.width,
      state.plateau.height,
    );
    for (final p in state.placedPieces) {
      if (p.piece.id == placed.piece.id) continue;
      for (final cell in p.absoluteCells) {
        newPlateau.setCell(cell.x, cell.y, p.piece.id);
      }
    }

    state = state.copyWith(
      plateau: newPlateau,
      selectedPiece: placed.piece,
      selectedPlacedPiece: placed,
      selectedPositionIndex: placed.positionIndex,
      selectedCellInPiece: Point(localX, localY),
      clearPreview: true,
    );
  }

  /// À appeler depuis l'UI (board) quand l'orientation change.
  /// Ne change aucune coordonnée: uniquement l'interprétation des actions
  /// (ex: Sym H/V) en mode paysage.
  void setViewOrientation(bool isLandscape) {
    final next = isLandscape
        ? ViewOrientation.landscape
        : ViewOrientation.portrait;
    if (state.viewOrientation == next) return;
    state = state.copyWith(viewOrientation: next);
  }

  // ==========================================================================
  // DÉMARRAGE
  // ==========================================================================

  Future<void> startPuzzle(
      PentoscopeSize size, {
        PentoscopeDifficulty difficulty = PentoscopeDifficulty.random,
        bool showSolution = false,
      }) async {
    final puzzle = await switch (difficulty) {
      PentoscopeDifficulty.easy => _generator.generateEasy(size),
      PentoscopeDifficulty.hard => _generator.generateHard(size),
      PentoscopeDifficulty.random => _generator.generate(size),
    };

    final pieces = puzzle.pieceIds
        .map((id) => pentominos.firstWhere((p) => p.id == id))
        .toList();

    final plateau = Plateau.allVisible(size.width, size.height);

    // 🎯 INITIALISER ALÉATOIREMENT LES POSITIONS
    final Random random = Random();
    final piecePositionIndices = <int, int>{};

    for (final piece in pieces) {
      final randomPos = random.nextInt(piece.numPositions);
      piecePositionIndices[piece.id] = randomPos;
      debugPrint('🎯 Pièce ${piece.id} position aléatoire: $randomPos/${piece.numPositions}');
    }

    // Calculer le nombre MIN théorique
    Solution? firstSolution;
    if (puzzle.solutions.isNotEmpty) {
      firstSolution = puzzle.solutions[0];

      int totalMinIsometries = 0;
      for (final placement in firstSolution) {
        final pento = pentominos.firstWhere((p) => p.id == placement.pieceId);
        final initialPos = piecePositionIndices[placement.pieceId] ?? 0;

        final minIso = pento.minIsometriesToReach(initialPos, placement.positionIndex);
        totalMinIsometries += minIso;
      }
      debugPrint('🎯 MIN ISOMETRIES THÉORIQUES: $totalMinIsometries');
    }

    state = PentoscopeState(
      viewOrientation: ViewOrientation.portrait,
      puzzle: puzzle,
      plateau: plateau,
      availablePieces: pieces,
      placedPieces: [],
      piecePositionIndices: piecePositionIndices,  // 👈 AVEC POSITIONS ALÉATOIRES!
      isComplete: false,
      isometryCount: 0,
      translationCount: 0,
      showSolution: showSolution,
      currentSolution: firstSolution,
    );
  }

  // ==========================================================================
  // PLACEMENT
  // ==========================================================================

  bool tryPlacePiece(int gridX, int gridY) {
    if (state.selectedPiece == null) return false;

    final piece = state.selectedPiece!;
    final positionIndex = state.selectedPositionIndex;

    int anchorX = gridX;
    int anchorY = gridY;

    if (state.selectedCellInPiece != null) {
      anchorX = gridX - state.selectedCellInPiece!.x;
      anchorY = gridY - state.selectedCellInPiece!.y;
    }

    if (!state.canPlacePiece(piece, positionIndex, anchorX, anchorY)) {
      return false;
    }

    // Créer le nouveau plateau
    final newPlateau = Plateau.allVisible(
      state.plateau.width,
      state.plateau.height,
    );

    // Copier les pièces existantes (sauf celle qu'on déplace si c'est une pièce placée)
    for (final p in state.placedPieces) {
      if (state.selectedPlacedPiece != null &&
          p.piece.id == state.selectedPlacedPiece!.piece.id) {
        continue;
      }
      for (final cell in p.absoluteCells) {
        newPlateau.setCell(cell.x, cell.y, p.piece.id);
      }
    }

    // Placer la nouvelle pièce
    final newPlaced = PentoscopePlacedPiece(
      piece: piece,
      positionIndex: positionIndex,
      gridX: anchorX,
      gridY: anchorY,
    );

    for (final cell in newPlaced.absoluteCells) {
      newPlateau.setCell(cell.x, cell.y, piece.id);
    }

    // Mettre à jour les listes
    List<PentoscopePlacedPiece> newPlacedPieces;
    List<Pento> newAvailable;

    if (state.selectedPlacedPiece != null) {
      // Déplacement d'une pièce existante
      newPlacedPieces = state.placedPieces
          .map((p) => p.piece.id == piece.id ? newPlaced : p)
          .toList();
      newAvailable = state.availablePieces;
    } else {
      // Nouvelle pièce
      newPlacedPieces = [...state.placedPieces, newPlaced];
      newAvailable = state.availablePieces
          .where((p) => p.id != piece.id)
          .toList();
    }

    final isComplete =
        newPlacedPieces.length == (state.puzzle?.size.numPieces ?? 0);

    // Compter les translations (déplacement d'une pièce déjà placée)
    final newTranslationCount = state.selectedPlacedPiece != null
        ? state.translationCount + 1
        : state.translationCount;

// 🎯 NOUVEAU: Calculer le score si victoire
    int newScore = state.score;

    debugPrint('🎯 DEBUG AVANT SCORE: isComplete=$isComplete');
    debugPrint('🎯 DEBUG AVANT SCORE: currentSolution != null = ${state.currentSolution != null}');
    if (state.currentSolution != null) {
      debugPrint('🎯 DEBUG AVANT SCORE: solution.length = ${state.currentSolution!.length}');
    }

    if (isComplete && state.currentSolution != null) {
      debugPrint('🎯 CALLING _calculateScore!');
      newScore = _calculateScore(newPlacedPieces, state.currentSolution!, state.isometryCount);
    } else {
      debugPrint('🎯 NOT CALLING _calculateScore');
    }
    state = state.copyWith(
      plateau: newPlateau,
      availablePieces: newAvailable,
      placedPieces: newPlacedPieces,
      clearSelectedPiece: true,
      clearSelectedPlacedPiece: true,
      clearSelectedCellInPiece: true,
      clearPreview: true,
      isComplete: isComplete,
      translationCount: newTranslationCount,
      score: newScore, // 🎯 NOUVEAU
      currentSolution: state.currentSolution,  // 👈 AJOUTER CETTE LIGNE!
    );

    return true;
  }

  // ==========================================================================
  // PREVIEW
  // ==========================================================================

  void updatePreview(int gridX, int gridY) {
    if (state.selectedPiece == null) {
      if (state.previewX != null || state.previewY != null) {
        state = state.copyWith(clearPreview: true);
      }
      return;
    }

    final piece = state.selectedPiece!;
    final positionIndex = state.selectedPositionIndex;

    int anchorX = gridX;
    int anchorY = gridY;

    if (state.selectedCellInPiece != null) {
      anchorX = gridX - state.selectedCellInPiece!.x;
      anchorY = gridY - state.selectedCellInPiece!.y;
    }

    final isValid = state.canPlacePiece(piece, positionIndex, anchorX, anchorY);

    if (state.previewX != anchorX ||
        state.previewY != anchorY ||
        state.isPreviewValid != isValid) {
      state = state.copyWith(
        previewX: anchorX,
        previewY: anchorY,
        isPreviewValid: isValid,
      );
    }
  }

  // ============================================================================
  // VALIDATION ISOMÉTRIES - NOUVELLE MÉTHODE
  // ============================================================================

  void _applyIsoUsingLookup(int Function(Pento p, int idx) f) {
    final piece = state.selectedPiece;
    if (piece == null) return;

    final oldIdx = state.selectedPositionIndex;
    final newIdx = f(piece, oldIdx);
    final didChange = oldIdx != newIdx;

    if (!didChange) return;

    // ========================================================================
    // CAS 1: Pièce du SLIDER sélectionnée (pas de validation nécessaire)
    // ========================================================================
    final sp = state.selectedPlacedPiece;
    if (sp == null) {
      state = state.copyWith(
        selectedPositionIndex: newIdx,
        selectedCellInPiece: _remapSelectedCell(
          piece: piece,
          oldIndex: oldIdx,
          newIndex: newIdx,
          oldCell: state.selectedCellInPiece,
        ),
        clearPreview: true,
        isometryCount: state.isometryCount + 1,
      );
      return;
    }

    // ========================================================================
    // CAS 2: Pièce PLACÉE sur plateau (VALIDATION REQUISE!)
    // ========================================================================

    // 1️⃣ Créer la pièce transformée (avec nouveau positionIndex)
    final transformedPiece = sp.copyWith(positionIndex: newIdx);

    // 2️⃣ VÉRIFIER si elle peut se placer (pas de chevauchement)
    if (!_canPlacePieceWithoutChecker(transformedPiece)) {
      HapticFeedback.heavyImpact();
      return; // ← ROLLBACK: aucun changement
    }

    // 3️⃣ ✅ VALIDE: Commiter la transformation

    final updatedPlacedPieces = state.placedPieces.map((p) {
      if (p.piece.id == sp.piece.id) {
        return transformedPiece;
      }
      return p;
    }).toList();

    state = state.copyWith(
      selectedPlacedPiece: transformedPiece,
      placedPieces: updatedPlacedPieces,
      selectedPositionIndex: newIdx,
      selectedCellInPiece: _remapSelectedCell(
        piece: piece,
        oldIndex: oldIdx,
        newIndex: newIdx,
        oldCell: state.selectedCellInPiece,
      ),
      clearPreview: true,
      isometryCount: state.isometryCount + 1,
    );
  }



  // ============================================================================
  // CALCUL DU SCORE - Efficacité isométries
  // ============================================================================
  int _calculateScore(
      List<PentoscopePlacedPiece> placedPieces,
      Solution solution,
      int actualIsometries,
      )
  {
    debugPrint('🎯 _calculateScore called');
    debugPrint('  actualIsometries = $actualIsometries');

    if (actualIsometries == 0) {
      debugPrint('  → actualIsometries=0, returning 20');
      return 20;
    }

    int totalMinIsometries = 0;

    for (final placed in placedPieces) {
      final pento = pentominos.firstWhere((p) => p.id == placed.piece.id);
      final optimalPlacement = solution
          .firstWhere((p) => p.pieceId == placed.piece.id);

      final minIso = pento.minIsometriesToReach(
        placed.positionIndex,
        optimalPlacement.positionIndex,
      );

      debugPrint('  Pièce ${placed.piece.id}: ${placed.positionIndex} → ${optimalPlacement.positionIndex}, minIso=$minIso');
      totalMinIsometries += minIso;
    }

    debugPrint('  totalMin=$totalMinIsometries');
    final score = ((totalMinIsometries / actualIsometries) * 20).round().clamp(0, 20);
    debugPrint('  SCORE FINAL = $score/20');
    return score;
  }
  /// Helper: calcule la mastercase par défaut (première cellule normalisée)
  Point? _calculateDefaultCell(Pento piece, int positionIndex) {
    final position = piece.positions[positionIndex];
    if (position.isEmpty) return null;

    int minX = 5, minY = 5;
    for (final cellNum in position) {
      final x = (cellNum - 1) % 5;
      final y = (cellNum - 1) ~/ 5;
      if (x < minX) minX = x;
      if (y < minY) minY = y;
    }
    final firstCellNum = position[0];
    final rawX = (firstCellNum - 1) % 5;
    final rawY = (firstCellNum - 1) ~/ 5;
    return Point(rawX - minX, rawY - minY);
  }

  /// Annule le mode "pièce placée en main" (sélection sur plateau) en
  /// reconstruisant le plateau complet à partir des pièces placées.
  /// À appeler avant de sélectionner une pièce du slider.
  void _cancelSelectedPlacedPieceIfAny() {
    if (state.selectedPlacedPiece == null) return;

    state = state.copyWith(
      plateau: _rebuildPlateauFromPlacedPieces(),
      clearSelectedPlacedPiece: true,
      clearPreview: true,
    );
  }



  /// Vérifie si une pièce placée peut occuper sa position sans chevauchement
  bool _canPlacePieceWithoutChecker(PentoscopePlacedPiece placed) {
    for (final cell in placed.absoluteCells) {
      if (cell.x < 0 ||
          cell.x >= state.plateau.width ||
          cell.y < 0 ||
          cell.y >= state.plateau.height) {
        return false;
      }

      final cellValue = state.plateau.getCell(cell.x, cell.y);
      if (cellValue != 0 && cellValue != placed.piece.id) {
        return false;
      }
    }
    return true;
  }

  List<List<int>> _extractAbsoluteCoords(PentoscopePlacedPiece piece) {
    final position = piece.piece.positions[piece.positionIndex];

    // Normaliser
    int minLocalX = 5, minLocalY = 5;
    for (final cellNum in position) {
      final localX = (cellNum - 1) % 5;
      final localY = (cellNum - 1) ~/ 5;
      if (localX < minLocalX) minLocalX = localX;
      if (localY < minLocalY) minLocalY = localY;
    }

    return position.map((cellNum) {
      final localX = (cellNum - 1) % 5 - minLocalX;
      final localY = (cellNum - 1) ~/ 5 - minLocalY;
      return [piece.gridX + localX, piece.gridY + localY];
    }).toList();
  }

  Plateau _rebuildPlateauFromPlacedPieces() {
    final newPlateau = Plateau.allVisible(
      state.plateau.width,
      state.plateau.height,
    );
    for (final p in state.placedPieces) {
      for (final cell in p.absoluteCells) {
        newPlateau.setCell(cell.x, cell.y, p.piece.id);
      }
    }
    return newPlateau;
  }

  // ========================================================================
  // ORIENTATION "VUE" (repère écran)
  // ========================================================================

  // ==========================================================================
  // ISOMÉTRIES (lookup robuste via Pento.cartesianCoords)
  // ==========================================================================

  Point? _remapSelectedCell({
    required Pento piece,
    required int oldIndex,
    required int newIndex,
    required Point? oldCell,
  }) {
    if (oldCell == null) return null;

    // Coordonnées normalisées dans l'ordre STABLE des cellules (positions)
    List<Point> coordsInPositionOrder(int posIdx) {
      final cellNums = piece.positions[posIdx];

      final raw = cellNums.map((cellNum) {
        final x = (cellNum - 1) % 5;
        final y = (cellNum - 1) ~/ 5;
        return Point(x, y);
      }).toList();

      final minX = raw.map((p) => p.x).reduce((a, b) => a < b ? a : b);
      final minY = raw.map((p) => p.y).reduce((a, b) => a < b ? a : b);

      // normalisation SANS trier (on garde l'identité géométrique)
      return raw.map((p) => Point(p.x - minX, p.y - minY)).toList();
    }

    final oldCoords = coordsInPositionOrder(oldIndex);

    // retrouve l'indice géométrique stable (0..4)
    final k = oldCoords.indexWhere((p) => p.x == oldCell.x && p.y == oldCell.y);
    if (k < 0) return oldCell; // sécurité

    final newCoords = coordsInPositionOrder(newIndex);
    return newCoords[k];
  }
}

/// Pièce placée sur le plateau Pentoscope
class PentoscopePlacedPiece {
  final Pento piece;
  final int positionIndex;
  final int gridX;
  final int gridY;

  const PentoscopePlacedPiece({
    required this.piece,
    required this.positionIndex,
    required this.gridX,
    required this.gridY,
  });

  /// Coordonnées absolues des cellules occupées (normalisées)
  Iterable<Point> get absoluteCells sync* {
    final position = piece.positions[positionIndex];

    // Trouver le décalage minimum pour normaliser
    int minLocalX = 5, minLocalY = 5;
    for (final cellNum in position) {
      final localX = (cellNum - 1) % 5;
      final localY = (cellNum - 1) ~/ 5;
      if (localX < minLocalX) minLocalX = localX;
      if (localY < minLocalY) minLocalY = localY;
    }

    for (final cellNum in position) {
      final localX = (cellNum - 1) % 5 - minLocalX;
      final localY = (cellNum - 1) ~/ 5 - minLocalY;
      yield Point(gridX + localX, gridY + localY);
    }
  }

  PentoscopePlacedPiece copyWith({
    Pento? piece,
    int? positionIndex,
    int? gridX,
    int? gridY,
  }) {
    return PentoscopePlacedPiece(
      piece: piece ?? this.piece,
      positionIndex: positionIndex ?? this.positionIndex,
      gridX: gridX ?? this.gridX,
      gridY: gridY ?? this.gridY,
    );
  }
}

/// État du jeu Pentoscope
class PentoscopeState {
  /// Orientation "vue" (repère écran). Ne change pas la logique.
  /// Sert à interpréter des actions (ex: Sym H/V) en paysage.
  final ViewOrientation viewOrientation;
  final PentoscopePuzzle? puzzle;
  final Plateau plateau;
  final List<Pento> availablePieces;
  final List<PentoscopePlacedPiece> placedPieces;

  // Sélection pièce du slider
  final Pento? selectedPiece;
  final int selectedPositionIndex;
  final Map<int, int> piecePositionIndices;

  // Sélection pièce placée
  final PentoscopePlacedPiece? selectedPlacedPiece;
  final Point? selectedCellInPiece; // Mastercase

  // Preview
  final int? previewX;
  final int? previewY;
  final bool isPreviewValid;

  // État du jeu
  final bool isComplete;
  final int isometryCount;
  final int translationCount;
  final int score; // 🎯 NOUVEAU: Score basé sur efficacité (0-20)

  final bool isSnapped;
  final bool showSolution;
  final Solution? currentSolution;

  const PentoscopeState({
    this.viewOrientation = ViewOrientation.portrait,
    this.puzzle,
    required this.plateau,
    this.availablePieces = const [],
    this.placedPieces = const [],
    this.selectedPiece,
    this.selectedPositionIndex = 0,
    this.piecePositionIndices = const {},
    this.selectedPlacedPiece,
    this.selectedCellInPiece,
    this.previewX,
    this.previewY,
    this.isPreviewValid = false,
    this.isComplete = false,
    this.isometryCount = 0,
    this.translationCount = 0,
    this.score = 0, // 🎯 NOUVEAU
    this.isSnapped = false,
    this.showSolution = false,
    this.currentSolution,
  });

  factory PentoscopeState.initial() {
    return PentoscopeState(
      plateau: Plateau.allVisible(5, 5),
      showSolution: false, // ✅ NOUVEAU
      currentSolution: null, // ✅ NOUVEAU
    );
  }

  bool canPlacePiece(Pento piece, int positionIndex, int gridX, int gridY) {
    final position = piece.positions[positionIndex];

    // Trouver le décalage minimum pour normaliser la forme
    int minLocalX = 5, minLocalY = 5;
    for (final cellNum in position) {
      final localX = (cellNum - 1) % 5;
      final localY = (cellNum - 1) ~/ 5;
      if (localX < minLocalX) minLocalX = localX;
      if (localY < minLocalY) minLocalY = localY;
    }

    for (final cellNum in position) {
      final localX = (cellNum - 1) % 5 - minLocalX; // Normalisé
      final localY = (cellNum - 1) ~/ 5 - minLocalY; // Normalisé
      final x = gridX + localX;
      final y = gridY + localY;

      if (x < 0 || x >= plateau.width || y < 0 || y >= plateau.height) {
        return false;
      }

      final cellValue = plateau.getCell(x, y);
      if (cellValue != 0) {
        return false;
      }
    }

    return true;
  }

  PentoscopeState copyWith({
    ViewOrientation? viewOrientation,
    PentoscopePuzzle? puzzle,
    Plateau? plateau,
    List<Pento>? availablePieces,
    List<PentoscopePlacedPiece>? placedPieces,
    Pento? selectedPiece,
    bool clearSelectedPiece = false,
    int? selectedPositionIndex,
    Map<int, int>? piecePositionIndices,
    PentoscopePlacedPiece? selectedPlacedPiece,
    bool clearSelectedPlacedPiece = false,
    Point? selectedCellInPiece,
    bool clearSelectedCellInPiece = false,
    int? previewX,
    int? previewY,
    bool? isPreviewValid,
    bool clearPreview = false,
    bool? isComplete,
    int? isometryCount,
    int? translationCount,
    int? score, // 🎯 NOUVEAU
    bool? isSnapped,
    bool? showSolution, // ✅ NOUVEAU
    Solution? currentSolution, // ✅ NOUVEAU
  }) {
    return PentoscopeState(
      viewOrientation: viewOrientation ?? this.viewOrientation,
      puzzle: puzzle ?? this.puzzle,
      plateau: plateau ?? this.plateau,
      availablePieces: availablePieces ?? this.availablePieces,
      placedPieces: placedPieces ?? this.placedPieces,
      selectedPiece: clearSelectedPiece
          ? null
          : (selectedPiece ?? this.selectedPiece),
      selectedPositionIndex:
      selectedPositionIndex ?? this.selectedPositionIndex,
      piecePositionIndices: piecePositionIndices ?? this.piecePositionIndices,
      selectedPlacedPiece: clearSelectedPlacedPiece
          ? null
          : (selectedPlacedPiece ?? this.selectedPlacedPiece),
      selectedCellInPiece: clearSelectedCellInPiece
          ? null
          : (selectedCellInPiece ?? this.selectedCellInPiece),
      previewX: clearPreview ? null : (previewX ?? this.previewX),
      previewY: clearPreview ? null : (previewY ?? this.previewY),
      isPreviewValid: clearPreview
          ? false
          : (isPreviewValid ?? this.isPreviewValid),
      isComplete: isComplete ?? this.isComplete,
      isometryCount: isometryCount ?? this.isometryCount,
      translationCount: translationCount ?? this.translationCount,
      score: score ?? this.score, // 🎯 NOUVEAU
      isSnapped: isSnapped ?? this.isSnapped,
      showSolution: showSolution ?? this.showSolution,
      // ✅ NOUVEAU
      currentSolution: currentSolution ?? this.currentSolution, // ✅ NOUVEAU
    );
  }

  int getPiecePositionIndex(int pieceId) {
    return piecePositionIndices[pieceId] ?? 0;
  }
}

/// Orientation "vue" (repère écran).
///
/// Important: le provider reste en coordonnées logiques. Cette info sert
/// uniquement à interpréter les actions utilisateur (ex: Sym H/V) pour que
/// le ressenti soit cohérent en paysage.
enum ViewOrientation { portrait, landscape }