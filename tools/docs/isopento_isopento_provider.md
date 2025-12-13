# isopento/isopento_provider.dart

**Module:** isopento

## Fonctions

### applyIsometryRotationCW

```dart
void applyIsometryRotationCW() {
```

### applyIsometryRotationTW

```dart
void applyIsometryRotationTW() {
```

### applyIsometrySymmetryH

```dart
void applyIsometrySymmetryH() {
```

### applyIsometrySymmetryV

```dart
void applyIsometrySymmetryV() {
```

### build

```dart
IsopentoState build() {
```

### calculateMinimalIsometries

Calcule le nombre MINIMAL d'isométries pour placer une pièce
en cherchant le chemin optimal depuis orientation initiale


```dart
int calculateMinimalIsometries(Pento piece, int targetPositionIndex) {
```

### cancelSelection

```dart
void cancelSelection() {
```

### clearPreview

```dart
void clearPreview() {
```

### cycleToNextOrientation

```dart
void cycleToNextOrientation() {
```

### removePlacedPiece

```dart
void removePlacedPiece(IsopentoPlacedPiece placed) {
```

### reset

```dart
void reset() {
```

### selectPiece

```dart
void selectPiece(Pento piece) {
```

### selectPlacedPiece

```dart
void selectPlacedPiece(IsopentoPlacedPiece placed, int absoluteX, int absoluteY) {
```

### startPuzzle

```dart
void startPuzzle(IsopentoSize size, {IsopentoDifficulty difficulty = IsopentoDifficulty.random}) {
```

### tryPlacePiece

```dart
bool tryPlacePiece(int gridX, int gridY) {
```

### updatePreview

```dart
void updatePreview(int gridX, int gridY) {
```

### Point

Helper: calcule la mastercase par défaut (première cellule normalisée)


```dart
return Point(rawX - minX, rawY - minY);
```

### IsopentoPlacedPiece

Helper pour trouver symétrie H
Helper pour trouver symétrie V
Génère un plateau avec une solution trouvée par le solver
Pièce placée sur le plateau Isopento


```dart
const IsopentoPlacedPiece({
```

### Point

Coordonnées absolues des cellules occupées (normalisées)


```dart
yield Point(gridX + localX, gridY + localY);
```

### copyWith

```dart
IsopentoPlacedPiece copyWith({
```

### IsopentoPlacedPiece

```dart
return IsopentoPlacedPiece( piece: piece ?? this.piece, positionIndex: positionIndex ?? this.positionIndex, gridX: gridX ?? this.gridX, gridY: gridY ?? this.gridY, isometriesUsed: isometriesUsed ?? this.isometriesUsed, );
```

### IsopentoState

État du jeu Isopento


```dart
const IsopentoState({
```

### IsopentoState

```dart
return IsopentoState( plateau: empty, solutionPlateau: empty, );
```

### canPlacePiece

```dart
bool canPlacePiece(Pento piece, int positionIndex, int gridX, int gridY) {
```

### copyWith

```dart
IsopentoState copyWith({
```

### IsopentoState

```dart
return IsopentoState( puzzle: puzzle ?? this.puzzle, plateau: plateau ?? this.plateau, solutionPlateau: solutionPlateau ?? this.solutionPlateau, availablePieces: availablePieces ?? this.availablePieces, placedPieces: placedPieces ?? this.placedPieces, selectedPiece: clearSelectedPiece ? null : (selectedPiece ?? this.selectedPiece), selectedPositionIndex: selectedPositionIndex ?? this.selectedPositionIndex, piecePositionIndices: piecePositionIndices ?? this.piecePositionIndices, selectedPlacedPiece: clearSelectedPlacedPiece ? null : (selectedPlacedPiece ?? this.selectedPlacedPiece), selectedCellInPiece: clearSelectedCellInPiece ? null : (selectedCellInPiece ?? this.selectedCellInPiece), previewX: clearPreview ? null : (previewX ?? this.previewX), previewY: clearPreview ? null : (previewY ?? this.previewY), isPreviewValid: clearPreview ? false : (isPreviewValid ?? this.isPreviewValid), isComplete: isComplete ?? this.isComplete, isometryCount: isometryCount ?? this.isometryCount, translationCount: translationCount ?? this.translationCount, isSnapped: isSnapped ?? this.isSnapped, );
```

### getPiecePositionIndex

```dart
int getPiecePositionIndex(int pieceId) {
```

