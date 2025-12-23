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
  // ✨ NOUVELLE FONCTION: Générer tous les placements valides
  // ==========================================================================

  /// Génère TOUS les placements possibles pour une pièce à une positionIndex donnée
  /// Retourne une liste de Point (gridX, gridY) où la pièce peut être placée
  List<Point> _generateValidPlacements(
      Pento piece,
      int positionIndex,
      ) {
    final validPlacements = <Point>[];

    // Balayer tout le plateau
    for (int gridX = 0; gridX < state.plateau.width; gridX++) {
      for (int gridY = 0; gridY < state.plateau.height; gridY++) {
        if (state.canPlacePiece(piece, positionIndex, gridX, gridY)) {
          validPlacements.add(Point(gridX, gridY));
        }
      }
    }

    return validPlacements;
  }

  // ==========================================================================
  // ✨ NOUVELLE FONCTION: Trouver la position la plus proche
  // ==========================================================================

  /// Trouve la position valide la plus proche du doigt (en tenant compte de la mastercase)
  /// dragGridX/Y = position du doigt
  /// Retourne la position d'ancre valide la plus proche
  Point? _findClosestValidPlacement(int dragGridX, int dragGridY) {
    if (state.validPlacements.isEmpty) return null;

    // 🔑 CRUCIAL: Appliquer la mastercase pour trouver l'ancre théorique
    int theoreticalAnchorX = dragGridX;
    int theoreticalAnchorY = dragGridY;

    if (state.selectedCellInPiece != null) {
      theoreticalAnchorX -= state.selectedCellInPiece!.x;
      theoreticalAnchorY -= state.selectedCellInPiece!.y;
    }

    // Chercher le placement valide le plus proche de cette ancre théorique
    Point closest = state.validPlacements[0];
    double minDistance = double.infinity;

    for (final placement in state.validPlacements) {
      final dx = (theoreticalAnchorX - placement.x).toDouble();
      final dy = (theoreticalAnchorY - placement.y).toDouble();
      final distance = dx * dx + dy * dy;

      if (distance < minDistance) {
        minDistance = distance;
        closest = placement;
      }
    }

    return closest;
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
        validPlacements: [], // ✨ NOUVEAU
      );
    } else {
      state = state.copyWith(
        clearSelectedPiece: true,
        clearSelectedPlacedPiece: true,
        clearSelectedCellInPiece: true,
        clearPreview: true,
        validPlacements: [], // ✨ NOUVEAU
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

    // ✨ NOUVEAU: Régénérer les placements valides après rotation
    final newValidPlacements = _generateValidPlacements(piece, newIndex);

    state = state.copyWith(
      selectedPositionIndex: newIndex,
      piecePositionIndices: newIndices,
      selectedCellInPiece: newCell,
      validPlacements: newValidPlacements, // ✨ Mettre à jour
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
      validPlacements: [], // ✨ Réinitialiser
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
      validPlacements: [], // ✨ NOUVEAU
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

    // ✨ BUGFIX: Mettre à jour le plateau EN PREMIER
    state = state.copyWith(
      plateau: newPlateau,
      // ← CLÉ!
      selectedPiece: piece,
      selectedPositionIndex: positionIndex,
      clearSelectedPlacedPiece: true,
      selectedCellInPiece: defaultCell,
    );

    // ✨ PUIS générer les placements valides avec le NOUVEAU plateau
    final newValidPlacements = _generateValidPlacements(piece, positionIndex);

    state = state.copyWith(
      validPlacements: newValidPlacements,
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
    if (state.isComplete) return;  // ← Bloquer si puzzle complet

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

    // ✨ BUGFIX: Mettre à jour le plateau dans l'état EN PREMIER
    // Sinon _generateValidPlacements() utilise l'ancien plateau!
    state = state.copyWith(
      plateau: newPlateau,
      selectedPiece: placed.piece,
      selectedPlacedPiece: placed,
      selectedPositionIndex: placed.positionIndex,
      selectedCellInPiece: Point(localX, localY),
      clearPreview: true,
    );

    // ✨ PUIS générer les placements valides avec le NOUVEAU plateau
    final validPlacements = _generateValidPlacements(placed.piece, placed.positionIndex);

    state = state.copyWith(
      validPlacements: validPlacements,
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
      debugPrint(
        '🎯 Pièce ${piece.id} position aléatoire: $randomPos/${piece.numPositions}',
      );
    }

    // ✅ TOUJOURS stocker la première solution (pour le calcul du score)
    Solution? firstSolution;
    if (showSolution && puzzle.solutions.isNotEmpty) {
      firstSolution = puzzle.solutions[0];

      int totalMinIsometries = 0;
      for (final placement in firstSolution) {
        final pento = pentominos.firstWhere((p) => p.id == placement.pieceId);
        final initialPos = piecePositionIndices[placement.pieceId] ?? 0;

        final minIso = pento.minIsometriesToReach(
          initialPos,
          placement.positionIndex,
        );
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
      piecePositionIndices: piecePositionIndices,
      isComplete: false,
      isometryCount: 0,
      translationCount: 0,
      showSolution: showSolution,
      // ✅ Flag pour contrôler l'AFFICHAGE
      currentSolution: firstSolution, // ✅ TOUJOURS fournie (pour le SCORE)
      validPlacements: [], // ✨ NOUVEAU
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
    debugPrint(
      '🎯 DEBUG AVANT SCORE: currentSolution != null = ${state.currentSolution != null}',
    );
    if (state.currentSolution != null) {
      debugPrint(
        '🎯 DEBUG AVANT SCORE: solution.length = ${state.currentSolution!.length}',
      );
    }

    if (isComplete && state.currentSolution != null) {
      debugPrint('🎯 CALLING _calculateScore!');
      newScore = _calculateScore(
        newPlacedPieces,
        state.currentSolution!,
        state.isometryCount,
      );
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
      score: newScore,
      // 🎯 NOUVEAU
      currentSolution: state.currentSolution, // 👈 AJOUTER CETTE LIGNE!
      validPlacements: [], // ✨ Réinitialiser après placement
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

    // ✨ CAS 1 - AUCUN PLACEMENT POSSIBLE → ROUGE PARTOUT
    if (state.validPlacements.isEmpty) {
      // Calculer où serait l'ancre si la mastercase était au doigt
      int previewX = gridX;
      int previewY = gridY;

      if (state.selectedCellInPiece != null) {
        previewX -= state.selectedCellInPiece!.x;
        previewY -= state.selectedCellInPiece!.y;
      }

      state = state.copyWith(
        previewX: previewX,
        previewY: previewY,
        isPreviewValid: false, // 🔴 ROUGE
      );
      return;
    }

    // ✨ CAS 2 - PLACEMENTS POSSIBLES → SNAPPING VERT
    final snappedPlacement = _findClosestValidPlacement(gridX, gridY);

    if (snappedPlacement == null) {
      if (state.previewX != null || state.previewY != null) {
        state = state.copyWith(clearPreview: true);
      }
      return;
    }

    // 🔑 Le snappedPlacement est déjà une position d'ancre valide
    // Pas besoin d'appliquer la mastercase, c'est déjà dedans
    state = state.copyWith(
      previewX: snappedPlacement.x,
      previewY: snappedPlacement.y,
      isPreviewValid: true, // 🟢 VERT
    );
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

  // ============================================================================
  // CALCUL DU SCORE - Efficacité isométries
  // ============================================================================
  int _calculateScore(
      List<PentoscopePlacedPiece> placedPieces,
      Solution solution,
      int actualIsometries,
      ) {
    debugPrint('🎯 _calculateScore called');
    debugPrint('  actualIsometries = $actualIsometries');

    if (actualIsometries == 0) {
      debugPrint('  → actualIsometries=0, returning 20');
      return 20;
    }

    int totalMinIsometries = 0;

    for (final placed in placedPieces) {
      final pento = pentominos.firstWhere((p) => p.id == placed.piece.id);
      final optimalPlacement = solution.firstWhere(
            (p) => p.pieceId == placed.piece.id,
      );

// ✅ BON (ce qu'il faut):
      final initialPos = state.piecePositionIndices[placed.piece.id] ?? 0;
      final minIso = pento.minIsometriesToReach(
        initialPos,                      // ← Position INITIALE aléatoire!
        optimalPlacement.positionIndex,
      );

      debugPrint(
        '  Pièce ${placed.piece.id}: ${placed.positionIndex} → ${optimalPlacement.positionIndex}, minIso=$minIso',
      );
      totalMinIsometries += minIso;
    }

    debugPrint('  totalMin=$totalMinIsometries');
    final score = ((totalMinIsometries / actualIsometries) * 20).round().clamp(
      0,
      20,
    );
    debugPrint('  SCORE FINAL = $score/20');
    return score;
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

  // ✨ NOUVEAU: Liste des placements valides pour la pièce sélectionnée
  final List<Point> validPlacements;

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
    this.validPlacements = const [], // ✨ NOUVEAU
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
    List<Point>? validPlacements, // ✨ NOUVEAU
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
      validPlacements: validPlacements ?? this.validPlacements, // ✨ NOUVEAU
      isComplete: isComplete ?? this.isComplete,
      isometryCount: isometryCount ?? this.isometryCount,
      translationCount: translationCount ?? this.translationCount,
      score: score ?? this.score,
      // 🎯 NOUVEAU
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