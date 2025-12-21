# common/pentominos.dart

**Module:** common

## Fonctions

### Pento

```dart
const Pento({
```

### getLetter

```dart
String getLetter(int cellNum) {
```

### getLetterForPosition

```dart
String getLetterForPosition(int positionIndex, int cellNum) {
```

### findRotation90

Ancien nom : rotation 90° anti-horaire (trigo)


```dart
int findRotation90(int currentPositionIndex) => rotationTW(currentPositionIndex);
```

### findSymmetryH

Ancien nom : symétrie horizontale


```dart
int findSymmetryH(int currentPositionIndex) => symmetryH(currentPositionIndex);
```

### findSymmetryV

Ancien nom : symétrie verticale


```dart
int findSymmetryV(int currentPositionIndex) => symmetryV(currentPositionIndex);
```

### rotationCW

```dart
int rotationCW(int currentPositionIndex) => _applyIso(currentPositionIndex, _rotate90TWCoords); // (-y, x)
```

### rotationTW

```dart
int rotationTW(int currentPositionIndex) => _applyIso(currentPositionIndex, _rotate90CWCoords); // (y, -x)
```

### symmetryH

```dart
int symmetryH(int currentPositionIndex) => _applyIso(currentPositionIndex, _flipVCoords);
```

### symmetryV

```dart
int symmetryV(int currentPositionIndex) => _applyIso(currentPositionIndex, _flipHCoords);
```

### rotate180

Rotation 180° (optionnel)


```dart
int rotate180(int currentPositionIndex) => rotationTW(rotationTW(currentPositionIndex));
```

