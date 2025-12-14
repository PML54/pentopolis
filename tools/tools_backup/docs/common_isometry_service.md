# common/isometry_service.dart

**Module:** common

## Fonctions

### applyPlacedPieceTransform

Service centralisé pour ALL transformations d'isométries

Utilisé par Isopento et Pentoscope pour éviter la duplication
Chaque Notifier injecte les callbacks spécifiques à son State
Applique une transformation géométrique à une pièce placée

Parameters:
- selectedPiece: la pièce à transformer
- selectedCellInPiece: mastercase (cellule de rotation)
- plateau: le plateau courant
- placedPieces: liste des pièces déjà placées
- transform: fonction de transformation (ex: rotation, symétrie)
- onSuccess: callback appelé si transformation réussie
reçoit: (newPiece, newPlacedPieces, newSelectedCell)
- onFailure: callback appelé si transformation échoue (optional)


```dart
void applyPlacedPieceTransform({
```

### Function

```dart
required Function(PlacedPiece, List<PlacedPiece>, Point) onSuccess, Function()? onFailure, }) {
```

### applySliderPieceTransform

Applique une transformation à une pièce du slider (non placée)

La pièce reste sélectionnée dans le slider, juste l'orientation change


```dart
void applySliderPieceTransform({
```

### Function

```dart
required Function(int newPositionIndex, Point? newCell) onSuccess, Function()? onFailure, }) {
```

### applyPlacedPieceSymmetryH

Symétrie horizontale sur pièce placée


```dart
void applyPlacedPieceSymmetryH({
```

### Function

```dart
required Function(PlacedPiece, List<PlacedPiece>, Point) onSuccess, Function()? onFailure, }) {
```

### applyPlacedPieceSymmetryV

Symétrie verticale sur pièce placée


```dart
void applyPlacedPieceSymmetryV({
```

### Function

```dart
required Function(PlacedPiece, List<PlacedPiece>, Point) onSuccess, Function()? onFailure, }) {
```

### applySliderPieceSymmetryH

Symétrie horizontale sur pièce slider


```dart
void applySliderPieceSymmetryH({
```

### Function

```dart
required Function(int, Point?) onSuccess, Function()? onFailure, }) {
```

### applySliderPieceSymmetryV

Symétrie verticale sur pièce slider


```dart
void applySliderPieceSymmetryV({
```

### Function

```dart
required Function(int, Point?) onSuccess, Function()? onFailure, }) {
```

### Point

Extrait les coordonnées absolues d'une pièce placée
Vérifie si une pièce peut être placée à une position
Calcule la mastercase par défaut (première cellule normalisée)


```dart
return Point(rawX - minX, rawY - minY);
```

