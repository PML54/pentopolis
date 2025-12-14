// lib/common/isometry_service.dart
// Modified: 251213HHMMSS
// Service de transformation complète pour isométries (rotations, symétries)
// Utilisé par: IsopentoNotifier et PentoscopeNotifier
// CHANGEMENTS: (1) Extraction complète de la logique des transformations, (2) Callbacks génériques pour state update, (3) Support pièces placées et slider

import 'package:pentapol/common/placed_piece.dart';
import 'package:pentapol/common/pentominos.dart';
import 'package:pentapol/common/plateau.dart';
import 'package:pentapol/common/point.dart';
import 'package:pentapol/common/shape_recognizer.dart';
import 'package:pentapol/common/isometry_transforms.dart';

/// Service centralisé pour ALL transformations d'isométries
///
/// Utilisé par Isopento et Pentoscope pour éviter la duplication
/// Chaque Notifier injecte les callbacks spécifiques à son State
class IsometryService {

  // =========================================================================
  // PIÈCE PLACÉE - Transformations avec fonction personnalisée
  // =========================================================================

  /// Applique une transformation géométrique à une pièce placée
  ///
  /// Parameters:
  /// - selectedPiece: la pièce à transformer
  /// - selectedCellInPiece: mastercase (cellule de rotation)
  /// - plateau: le plateau courant
  /// - placedPieces: liste des pièces déjà placées
  /// - transform: fonction de transformation (ex: rotation, symétrie)
  /// - onSuccess: callback appelé si transformation réussie
  ///   reçoit: (newPiece, newPlacedPieces, newSelectedCell)
  /// - onFailure: callback appelé si transformation échoue (optional)
  void applyPlacedPieceTransform({
    required PlacedPiece selectedPiece,
    required Point? selectedCellInPiece,
    required Plateau plateau,
    required List<PlacedPiece> placedPieces,
    required List<List<int>> Function(List<List<int>>, int, int) transform,
    required Function(PlacedPiece, List<PlacedPiece>, Point) onSuccess,
    Function()? onFailure,
  }) {
    try {
      // 1. Extraire les coordonnées absolues
      final currentCoords = _extractAbsoluteCoords(selectedPiece);

      // 2. Centre de rotation = mastercase
      final refX = (selectedCellInPiece?.x ?? 0);
      final refY = (selectedCellInPiece?.y ?? 0);
      final centerX = selectedPiece.gridX + refX;
      final centerY = selectedPiece.gridY + refY;

      // 3. Appliquer la transformation
      final transformedCoords = transform(currentCoords, centerX, centerY);

      // 4. Reconnaître la forme
      final match = recognizeShape(transformedCoords);
      if (match == null) {
        onFailure?.call();
        return;
      }

      // 5. Vérifier placement valide
      if (!_canPlacePieceAt(match, plateau, selectedPiece)) {
        onFailure?.call();
        return;
      }

      // 6. Créer la pièce transformée
      final transformedPiece = PlacedPiece(
        piece: match.piece,
        positionIndex: match.positionIndex,
        gridX: match.gridX,
        gridY: match.gridY,
        isometriesUsed: selectedPiece.isometriesUsed,
      );

      // 7. Nouvelle mastercase
      final newSelectedCell = Point(centerX - match.gridX, centerY - match.gridY);

      // 8. Mettre à jour placedPieces
      final newPlacedPieces = placedPieces
          .map((p) => p.piece.id == selectedPiece.piece.id ? transformedPiece : p)
          .toList();

      // 9. Callback avec les résultats
      onSuccess(transformedPiece, newPlacedPieces, newSelectedCell);
    } catch (e) {
      print('Erreur applyPlacedPieceTransform: $e');
      onFailure?.call();
    }
  }

  // =========================================================================
  // PIÈCE SLIDER - Transformations (pas de placement)
  // =========================================================================

  /// Applique une transformation à une pièce du slider (non placée)
  ///
  /// La pièce reste sélectionnée dans le slider, juste l'orientation change
  void applySliderPieceTransform({
    required Pento selectedPiece,
    required int currentPositionIndex,
    required Point? selectedCellInPiece,
    required List<List<int>> Function(List<List<int>>, int, int) transform,
    required Function(int newPositionIndex, Point? newCell) onSuccess,
    Function()? onFailure,
  }) {
    try {
      // 1. Coordonnées actuelles
      final currentCoords = selectedPiece.cartesianCoords[currentPositionIndex];

      // 2. Centre de rotation
      final refX = (selectedCellInPiece?.x ?? 0);
      final refY = (selectedCellInPiece?.y ?? 0);

      // 3. Appliquer la transformation
      final transformedCoords = transform(currentCoords, refX, refY);

      // 4. Reconnaître
      final match = recognizeShape(transformedCoords);
      if (match == null || match.piece.id != selectedPiece.id) {
        onFailure?.call();
        return;
      }

      // 5. Calculer la nouvelle mastercase
      final newCell = _calculateDefaultCell(selectedPiece, match.positionIndex);

      // 6. Callback avec les résultats
      onSuccess(match.positionIndex, newCell);
    } catch (e) {
      print('Erreur applySliderPieceTransform: $e');
      onFailure?.call();
    }
  }

  // =========================================================================
  // SYMÉTRIES (spécialisées, pas besoin de transform function)
  // =========================================================================

  /// Symétrie horizontale sur pièce placée
  void applyPlacedPieceSymmetryH({
    required PlacedPiece selectedPiece,
    required Point? selectedCellInPiece,
    required Plateau plateau,
    required List<PlacedPiece> placedPieces,
    required Function(PlacedPiece, List<PlacedPiece>, Point) onSuccess,
    Function()? onFailure,
  }) {
    applyPlacedPieceTransform(
      selectedPiece: selectedPiece,
      selectedCellInPiece: selectedCellInPiece,
      plateau: plateau,
      placedPieces: placedPieces,
      transform: (coords, cx, cy) => flipVertical(coords, cx),
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
  }

  /// Symétrie verticale sur pièce placée
  void applyPlacedPieceSymmetryV({
    required PlacedPiece selectedPiece,
    required Point? selectedCellInPiece,
    required Plateau plateau,
    required List<PlacedPiece> placedPieces,
    required Function(PlacedPiece, List<PlacedPiece>, Point) onSuccess,
    Function()? onFailure,
  }) {
    applyPlacedPieceTransform(
      selectedPiece: selectedPiece,
      selectedCellInPiece: selectedCellInPiece,
      plateau: plateau,
      placedPieces: placedPieces,
      transform: (coords, cx, cy) => flipHorizontal(coords, cy),  // ✅
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
  }

  /// Symétrie horizontale sur pièce slider
  void applySliderPieceSymmetryH({
    required Pento selectedPiece,
    required int currentPositionIndex,
    required Point? selectedCellInPiece,
    required Function(int, Point?) onSuccess,
    Function()? onFailure,
  }) {
    applySliderPieceTransform(
      selectedPiece: selectedPiece,
      currentPositionIndex: currentPositionIndex,
      selectedCellInPiece: selectedCellInPiece,
      transform: (coords, cx, cy) => flipVertical(coords, cx),  // ✅
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
  }

  /// Symétrie verticale sur pièce slider
  void applySliderPieceSymmetryV({
    required Pento selectedPiece,
    required int currentPositionIndex,
    required Point? selectedCellInPiece,
    required Function(int, Point?) onSuccess,
    Function()? onFailure,
  }) {
    applySliderPieceTransform(
      selectedPiece: selectedPiece,
      currentPositionIndex: currentPositionIndex,
      selectedCellInPiece: selectedCellInPiece,
      transform: (coords, cx, cy) => flipHorizontal(coords, cy),
      onSuccess: onSuccess,
      onFailure: onFailure,
    );
  }

  // =========================================================================
  // HELPERS PRIVÉS
  // =========================================================================

  /// Extrait les coordonnées absolues d'une pièce placée
  List<List<int>> _extractAbsoluteCoords(PlacedPiece piece) {
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

  /// Vérifie si une pièce peut être placée à une position
  bool _canPlacePieceAt(ShapeMatch match, Plateau plateau, PlacedPiece? excludePiece) {
    final position = match.piece.positions[match.positionIndex];

    // Normaliser les coordonnées
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
      final absX = match.gridX + localX;
      final absY = match.gridY + localY;

      if (!plateau.isInBounds(absX, absY)) {
        return false;
      }

      final cell = plateau.getCell(absX, absY);
      if (cell != 0 && (excludePiece == null || cell != excludePiece.piece.id)) {
        return false;
      }
    }

    return true;
  }

  /// Calcule la mastercase par défaut (première cellule normalisée)
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