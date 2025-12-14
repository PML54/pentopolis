# pentoscope/pentoscope_provider.dart

**Module:** pentoscope

## Fonctions

### applyIsometryRotationTW

```dart
void applyIsometryRotationTW() {
```

### applyIsometryRotationCW

```dart
void applyIsometryRotationCW() {
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
PentoscopeState build() {
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
void removePlacedPiece(PlacedPiece placed) {
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
void selectPlacedPiece( PlacedPiece placed, int absoluteX, int absoluteY, ) {
```

### startPuzzle

```dart
void startPuzzle( PentoscopeSize size, {
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

```dart
return Point(rawX - minX, rawY - minY);
```

### PentoscopeState

État du jeu Pentoscope


```dart
const PentoscopeState({
```

### PentoscopeState

```dart
return PentoscopeState(plateau: Plateau.allVisible(5, 5));
```

### canPlacePiece

```dart
bool canPlacePiece(Pento piece, int positionIndex, int gridX, int gridY) {
```

### copyWith

```dart
PentoscopeState copyWith({
```

### PentoscopeState

```dart
return PentoscopeState( puzzle: puzzle ?? this.puzzle, plateau: plateau ?? this.plateau, availablePieces: availablePieces ?? this.availablePieces, placedPieces: placedPieces ?? this.placedPieces, selectedPiece: clearSelectedPiece ? null : (selectedPiece ?? this.selectedPiece), selectedPositionIndex: selectedPositionIndex ?? this.selectedPositionIndex, piecePositionIndices: piecePositionIndices ?? this.piecePositionIndices, selectedPlacedPiece: clearSelectedPlacedPiece ? null : (selectedPlacedPiece ?? this.selectedPlacedPiece), selectedCellInPiece: clearSelectedCellInPiece ? null : (selectedCellInPiece ?? this.selectedCellInPiece), previewX: clearPreview ? null : (previewX ?? this.previewX), previewY: clearPreview ? null : (previewY ?? this.previewY), isPreviewValid: clearPreview ? false : (isPreviewValid ?? this.isPreviewValid), isComplete: isComplete ?? this.isComplete, isometryCount: isometryCount ?? this.isometryCount, translationCount: translationCount ?? this.translationCount, isSnapped: isSnapped ?? this.isSnapped, );
```

### getPiecePositionIndex

```dart
int getPiecePositionIndex(int pieceId) {
```

