// lib/isopento/isopento_provider.dart
// Modified: 251213HHMMSS
// CHANGEMENTS: (1) Renommer applyIsometry* → delegateIsometry* (clarité architecture), (2) Ajouter commentaires expliquant la délégation, (3) Garder le reste identique

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentapol/common/isometry_service.dart';
import 'package:pentapol/common/isometry_transforms.dart';
import 'package:pentapol/common/pentominos.dart';
import 'package:pentapol/common/placed_piece.dart';
import 'package:pentapol/common/plateau.dart';
import 'package:pentapol/common/point.dart';
import 'package:pentapol/common/shape_recognizer.dart';
import 'package:pentapol/isopento/isopento_generator.dart';
import 'package:pentapol/isopento/isopento_solver.dart';

// ============================================================================
// ÉTAT
// ============================================================================

final isopentoProvider = NotifierProvider<IsopentoNotifier, IsopentoState>(
  IsopentoNotifier.new,
);

// ============================================================================
// PROVIDER
// ============================================================================

enum IsopentoDifficulty { easy, random, hard }

class IsopentoNotifier extends Notifier<IsopentoState> {
  late final IsopentoGenerator _generator;
  late final IsometryService _isometryService = IsometryService();

  // ==========================================================================
  // ISOMÉTRIES PUBLIQUES - DÉLÉGATION AU SERVICE
  // ==========================================================================
  // Note: Ces méthodes sont des orchestrateurs qui délèguent au service
  // et gèrent la mise à jour du state. Elles ne contiennent PAS la logique métier.

  /// Applique une rotation trigonométrique (CCW - 1 étape)
  /// Délègue au service et met à jour l'état
  void delegateIsometryRotationTW() {
    if (state.selectedPlacedPiece != null) {
      _isometryService.applyPlacedPieceTransform(
        selectedPiece: state.selectedPlacedPiece!,
        selectedCellInPiece: state.selectedCellInPiece,
        plateau: state.plateau,
        placedPieces: state.placedPieces,
        transform: (coords, cx, cy) => rotateAroundPoint(coords, cx, cy, 1),
        onSuccess: (newPiece, newPlaced, newCell) {
          state = state.copyWith(
            placedPieces: newPlaced,
            selectedPlacedPiece: newPiece,
            selectedPositionIndex: newPiece.positionIndex,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    } else if (state.selectedPiece != null) {
      _isometryService.applySliderPieceTransform(
        selectedPiece: state.selectedPiece!,
        currentPositionIndex: state.selectedPositionIndex,
        selectedCellInPiece: state.selectedCellInPiece,
        transform: (coords, cx, cy) => rotateAroundPoint(coords, cx, cy, 1),
        onSuccess: (newIndex, newCell) {
          final newIndices = Map<int, int>.from(state.piecePositionIndices);
          newIndices[state.selectedPiece!.id] = newIndex;
          state = state.copyWith(
            selectedPositionIndex: newIndex,
            piecePositionIndices: newIndices,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    }
  }

  /// Applique une rotation horaire (CW - 3 étapes)
  /// Délègue au service et met à jour l'état
  void delegateIsometryRotationCW() {
    if (state.selectedPlacedPiece != null) {
      _isometryService.applyPlacedPieceTransform(
        selectedPiece: state.selectedPlacedPiece!,
        selectedCellInPiece: state.selectedCellInPiece,
        plateau: state.plateau,
        placedPieces: state.placedPieces,
        transform: (coords, cx, cy) => rotateAroundPoint(coords, cx, cy, 3),
        onSuccess: (newPiece, newPlaced, newCell) {
          state = state.copyWith(
            placedPieces: newPlaced,
            selectedPlacedPiece: newPiece,
            selectedPositionIndex: newPiece.positionIndex,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    } else if (state.selectedPiece != null) {
      _isometryService.applySliderPieceTransform(
        selectedPiece: state.selectedPiece!,
        currentPositionIndex: state.selectedPositionIndex,
        selectedCellInPiece: state.selectedCellInPiece,
        transform: (coords, cx, cy) => rotateAroundPoint(coords, cx, cy, 3),
        onSuccess: (newIndex, newCell) {
          final newIndices = Map<int, int>.from(state.piecePositionIndices);
          newIndices[state.selectedPiece!.id] = newIndex;
          state = state.copyWith(
            selectedPositionIndex: newIndex,
            piecePositionIndices: newIndices,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    }
  }

  /// Applique une symétrie horizontale
  /// Délègue au service et met à jour l'état
  void delegateIsometrySymmetryH() {
    if (state.selectedPlacedPiece != null) {
      _isometryService.applyPlacedPieceSymmetryH(
        selectedPiece: state.selectedPlacedPiece!,
        selectedCellInPiece: state.selectedCellInPiece,
        plateau: state.plateau,
        placedPieces: state.placedPieces,
        onSuccess: (newPiece, newPlaced, newCell) {
          state = state.copyWith(
            placedPieces: newPlaced,
            selectedPlacedPiece: newPiece,
            selectedPositionIndex: newPiece.positionIndex,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    } else if (state.selectedPiece != null) {
      _isometryService.applySliderPieceSymmetryH(
        selectedPiece: state.selectedPiece!,
        currentPositionIndex: state.selectedPositionIndex,
        selectedCellInPiece: state.selectedCellInPiece,
        onSuccess: (newIndex, newCell) {
          final newIndices = Map<int, int>.from(state.piecePositionIndices);
          newIndices[state.selectedPiece!.id] = newIndex;
          state = state.copyWith(
            selectedPositionIndex: newIndex,
            piecePositionIndices: newIndices,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    }
  }

  /// Applique une symétrie verticale
  /// Délègue au service et met à jour l'état
  void delegateIsometrySymmetryV() {
    if (state.selectedPlacedPiece != null) {
      _isometryService.applyPlacedPieceSymmetryV(
        selectedPiece: state.selectedPlacedPiece!,
        selectedCellInPiece: state.selectedCellInPiece,
        plateau: state.plateau,
        placedPieces: state.placedPieces,
        onSuccess: (newPiece, newPlaced, newCell) {
          state = state.copyWith(
            placedPieces: newPlaced,
            selectedPlacedPiece: newPiece,
            selectedPositionIndex: newPiece.positionIndex,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    } else if (state.selectedPiece != null) {
      _isometryService.applySliderPieceSymmetryV(
        selectedPiece: state.selectedPiece!,
        currentPositionIndex: state.selectedPositionIndex,
        selectedCellInPiece: state.selectedCellInPiece,
        onSuccess: (newIndex, newCell) {
          final newIndices = Map<int, int>.from(state.piecePositionIndices);
          newIndices[state.selectedPiece!.id] = newIndex;
          state = state.copyWith(
            selectedPositionIndex: newIndex,
            piecePositionIndices: newIndices,
            selectedCellInPiece: newCell,
            isometryCount: state.isometryCount + 1,
          );
        },
      );
    }
  }

  @override
  IsopentoState build() {
    _generator = IsopentoGenerator();
    return IsopentoState.initial();
  }

  /// Calcule le nombre MINIMAL d'isométries pour placer une pièce
  /// en cherchant le chemin optimal depuis orientation initiale
  int calculateMinimalIsometries(Pento piece, int targetPositionIndex) {
    final initialPosition = 0;

    if (initialPosition == targetPositionIndex) {
      return 0;
    }

    final queue = <(int position, int steps)>[];
    final visited = <int>{initialPosition};

    queue.add((initialPosition, 0));

    while (queue.isNotEmpty) {
      final (currentPos, steps) = queue.removeAt(0);

      for (int i = 1; i <= 4; i++) {
        int nextPos = currentPos;

        switch (i) {
          case 1:
            nextPos = (currentPos + 1) % piece.numPositions;
          case 2:
            nextPos = (currentPos + piece.numPositions - 1) % piece.numPositions;
          case 3:
            nextPos = _findSymmetryHPosition(piece, currentPos) ?? currentPos;
          case 4:
            nextPos = _findSymmetryVPosition(piece, currentPos) ?? currentPos;
        }

        if (nextPos == targetPositionIndex) {
          return steps + 1;
        }

        if (!visited.contains(nextPos)) {
          visited.add(nextPos);
          queue.add((nextPos, steps + 1));
        }
      }
    }

    return piece.numPositions;
  }

  void cancelSelection() {
    if (state.selectedPlacedPiece != null) {
      final newPlateau = Plateau.allVisible(state.plateau.width, state.plateau.height);
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

  PlacedPiece? getPlacedPieceAt(int x, int y) {
    for (final placed in state.placedPieces) {
      for (final cell in placed.absoluteCells) {
        if (cell.x == x && cell.y == y) {
          return placed;
        }
      }
    }
    return null;
  }

  void removePlacedPiece(PlacedPiece placed) {
    final newPlateau = Plateau.allVisible(state.plateau.width, state.plateau.height);

    for (final p in state.placedPieces) {
      if (p.piece.id == placed.piece.id) continue;
      for (final cell in p.absoluteCells) {
        newPlateau.setCell(cell.x, cell.y, p.piece.id);
      }
    }

    final newPlaced = state.placedPieces.where((p) => p.piece.id != placed.piece.id).toList();
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

  void reset() {
    final puzzle = state.puzzle;
    if (puzzle == null) return;

    final newPuzzle = _generator.generate(puzzle.size);

    final pieces = newPuzzle.pieceIds
        .map((id) => pentominos.firstWhere((p) => p.id == id))
        .toList();

    final newSolutionPlateau = _generateSolutionPlateau(newPuzzle.size, pieces);

    final emptyPlateau = Plateau.allVisible(newPuzzle.size.width, newPuzzle.size.height);

    state = IsopentoState(
      puzzle: newPuzzle,
      plateau: emptyPlateau,
      solutionPlateau: newSolutionPlateau,
      availablePieces: pieces,
      placedPieces: [],
      piecePositionIndices: {},
      isComplete: false,
      isometryCount: 0,
      translationCount: 0,
    );
  }

  void selectPiece(Pento piece) {
    final positionIndex = state.getPiecePositionIndex(piece.id);
    final defaultCell = _calculateDefaultCell(piece, positionIndex);

    state = state.copyWith(
      selectedPiece: piece,
      selectedPositionIndex: positionIndex,
      clearSelectedPlacedPiece: true,
      selectedCellInPiece: defaultCell,
    );
  }

  void selectPlacedPiece(
      PlacedPiece placed,
      int absoluteX,
      int absoluteY,
      ) {
    final localX = absoluteX - placed.gridX;
    final localY = absoluteY - placed.gridY;

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

  void startPuzzle(IsopentoSize size, {IsopentoDifficulty difficulty = IsopentoDifficulty.random}) {
    final puzzle = switch (difficulty) {
      IsopentoDifficulty.easy => _generator.generateEasy(size),
      IsopentoDifficulty.hard => _generator.generateHard(size),
      IsopentoDifficulty.random => _generator.generate(size),
    };

    final pieces = puzzle.pieceIds
        .map((id) => pentominos.firstWhere((p) => p.id == id))
        .toList();

    final newSolutionPlateau = _generateSolutionPlateau(size, pieces);

    final emptyPlateau = Plateau.allVisible(size.width, size.height);

    state = IsopentoState(
      puzzle: puzzle,
      plateau: emptyPlateau,
      solutionPlateau: newSolutionPlateau,
      availablePieces: pieces,
      placedPieces: [],
      piecePositionIndices: {},
      isComplete: false,
      isometryCount: 0,
      translationCount: 0,
    );
  }

  bool tryPlacePiece(int gridX, int gridY) {
    final selectedPiece = state.selectedPiece;
    if (selectedPiece == null) return false;

    final positionIndex = state.selectedPositionIndex;

    if (!state.canPlacePiece(selectedPiece, positionIndex, gridX, gridY)) {
      return false;
    }

    final placed = PlacedPiece(
      piece: selectedPiece,
      positionIndex: positionIndex,
      gridX: gridX,
      gridY: gridY,
      isometriesUsed: 0,
    );

    final newPlateau = Plateau.allVisible(state.plateau.width, state.plateau.height);

    // Ajouter la NOUVELLE pièce
    for (final cell in placed.absoluteCells) {
      newPlateau.setCell(cell.x, cell.y, selectedPiece.id);
    }

    // Ajouter les autres pièces (SKIP la pièce sélectionnée!)
    for (final p in state.placedPieces) {
      if (state.selectedPlacedPiece != null && p.piece.id == state.selectedPlacedPiece!.piece.id) {
        continue;  // ← SKIP si on remplace
      }
      for (final cell in p.absoluteCells) {
        newPlateau.setCell(cell.x, cell.y, p.piece.id);
      }
    }

    final newAvailable = state.availablePieces
        .where((p) => p.id != selectedPiece.id)
        .toList();

    final newPlaced = state.selectedPlacedPiece != null
        ? state.placedPieces.map((p) =>
    p.piece.id == state.selectedPlacedPiece!.piece.id ? placed : p).toList()
        : [...state.placedPieces, placed];

    final isComplete = newAvailable.isEmpty;

    state = state.copyWith(
      plateau: newPlateau,
      availablePieces: newAvailable,
      placedPieces: newPlaced,
      clearSelectedPiece: true,
      clearSelectedPlacedPiece: true,
      clearSelectedCellInPiece: true,
      clearPreview: true,
      isComplete: isComplete,
    );

    return true;
  }

  void updatePreview(int gridX, int gridY) {
    final selectedPiece = state.selectedPiece;
    final selectedPlaced = state.selectedPlacedPiece;

    if (selectedPiece == null && selectedPlaced == null) {
      state = state.copyWith(clearPreview: true);
      return;
    }

    if (selectedPlaced != null) {
      state = state.copyWith(clearPreview: true);
      return;
    }

    final positionIndex = state.selectedPositionIndex;
    final isValid = state.canPlacePiece(selectedPiece!, positionIndex, gridX, gridY);

    state = state.copyWith(
      previewX: gridX,
      previewY: gridY,
      isPreviewValid: isValid,
    );
  }

  // ==========================================================================
  // HELPERS PRIVÉS
  // ==========================================================================

  int? _findSymmetryHPosition(Pento piece, int currentPos) {
    try {
      final currentCoords = piece.cartesianCoords[currentPos];
      final flipped = flipVertical(currentCoords, 0);
      final match = recognizeShape(flipped);

      if (match?.piece.id == piece.id) {
        return match?.positionIndex;
      }
    } catch (e) {
      //
    }
    return null;
  }

  int? _findSymmetryVPosition(Pento piece, int currentPos) {
    try {
      final currentCoords = piece.cartesianCoords[currentPos];
      final flipped = flipHorizontal(currentCoords, 0);
      final match = recognizeShape(flipped);

      if (match?.piece.id == piece.id) {
        return match?.positionIndex;
      }
    } catch (e) {
      //
    }
    return null;
  }

  Plateau _generateSolutionPlateau(IsopentoSize size, List<Pento> pieces) {
    final solver = IsopentoSolver(
      width: size.width,
      height: size.height,
      pieces: pieces,
      maxSeconds: 5,
    );

    final solution = solver.findSolution();

    final plateau = Plateau.allVisible(size.width, size.height);

    if (solution != null) {
      for (final placement in solution) {
        final piece = pieces.firstWhere((p) => p.id == placement.pieceId);
        final shape = piece.positions[placement.orientation];

        final minShapeCell = shape.reduce((a, b) => a < b ? a : b);
        final shapeAnchorX = (minShapeCell - 1) % 5;
        final shapeAnchorY = (minShapeCell - 1) ~/ 5;

        final offsetX = (placement.offsetX - shapeAnchorX).toInt();
        final offsetY = (placement.offsetY - shapeAnchorY).toInt();

        for (final shapeCell in shape) {
          final sx = (shapeCell - 1) % 5;
          final sy = (shapeCell - 1) ~/ 5;
          plateau.setCell(sx + offsetX, sy + offsetY, placement.pieceId);
        }
      }
    }

    return plateau;
  }

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
}

/// État du jeu Isopento
class IsopentoState {
  final IsopentoPuzzle? puzzle;
  final Plateau plateau;
  final Plateau solutionPlateau;
  final List<Pento> availablePieces;
  final List<PlacedPiece> placedPieces;

  final Pento? selectedPiece;
  final int selectedPositionIndex;
  final Map<int, int> piecePositionIndices;

  final PlacedPiece? selectedPlacedPiece;
  final Point? selectedCellInPiece;

  final int? previewX;
  final int? previewY;
  final bool isPreviewValid;

  final bool isComplete;
  final int isometryCount;
  final int translationCount;
  final bool isSnapped;

  const IsopentoState({
    this.puzzle,
    required this.plateau,
    required this.solutionPlateau,
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
    this.isSnapped = false,
  });

  factory IsopentoState.initial() {
    final empty = Plateau.allVisible(5, 5);
    return IsopentoState(
      plateau: empty,
      solutionPlateau: empty,
    );
  }

  bool canPlacePiece(Pento piece, int positionIndex, int gridX, int gridY) {
    final position = piece.positions[positionIndex];

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

  IsopentoState copyWith({
    IsopentoPuzzle? puzzle,
    Plateau? plateau,
    Plateau? solutionPlateau,
    List<Pento>? availablePieces,
    List<PlacedPiece>? placedPieces,
    Pento? selectedPiece,
    bool clearSelectedPiece = false,
    int? selectedPositionIndex,
    Map<int, int>? piecePositionIndices,
    PlacedPiece? selectedPlacedPiece,
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
    bool? isSnapped,
  }) {
    return IsopentoState(
      puzzle: puzzle ?? this.puzzle,
      plateau: plateau ?? this.plateau,
      solutionPlateau: solutionPlateau ?? this.solutionPlateau,
      availablePieces: availablePieces ?? this.availablePieces,
      placedPieces: placedPieces ?? this.placedPieces,
      selectedPiece: clearSelectedPiece ? null : (selectedPiece ?? this.selectedPiece),
      selectedPositionIndex: selectedPositionIndex ?? this.selectedPositionIndex,
      piecePositionIndices: piecePositionIndices ?? this.piecePositionIndices,
      selectedPlacedPiece: clearSelectedPlacedPiece ? null : (selectedPlacedPiece ?? this.selectedPlacedPiece),
      selectedCellInPiece: clearSelectedCellInPiece ? null : (selectedCellInPiece ?? this.selectedCellInPiece),
      previewX: clearPreview ? null : (previewX ?? this.previewX),
      previewY: clearPreview ? null : (previewY ?? this.previewY),
      isPreviewValid: clearPreview ? false : (isPreviewValid ?? this.isPreviewValid),
      isComplete: isComplete ?? this.isComplete,
      isometryCount: isometryCount ?? this.isometryCount,
      translationCount: translationCount ?? this.translationCount,
      isSnapped: isSnapped ?? this.isSnapped,
    );
  }

  int getPiecePositionIndex(int pieceId) {
    return piecePositionIndices[pieceId] ?? 0;
  }
}