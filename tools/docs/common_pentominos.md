# common/pentominos.dart

**Module:** common

## Fonctions

### Pento

```dart
const Pento({
```

### getLetter

Retourne la lettre (A-E) pour une case donnée dans baseShape
La lettre est FIXE et basée sur l'ordre dans baseShape


```dart
String getLetter(int cellNum) {
```

### getLetterForPosition

Retourne la lettre (A-E) pour une case dans une position donnée
Grâce à la préservation de l'ordre géométrique, l'index dans positions[positionIndex]
correspond directement à l'index dans baseShape (donc à la même lettre)
[positionIndex] : index de la position actuelle (0 à numPositions-1)
[cellNum] : numéro de cellule dans cette position


```dart
String getLetterForPosition(int positionIndex, int cellNum) {
```

### findRotation90

Trouve l'index de la position qui correspond à une rotation de 90° anti-horaire
depuis la position actuelle
Retourne -1 si aucune rotation n'est trouvée (pièce symétrique)


```dart
int findRotation90(int currentPositionIndex) {
```

### findSymmetryH

Trouve l'index de la position qui correspond à une symétrie horizontale
depuis la position actuelle
Retourne -1 si aucune symétrie n'est trouvée


```dart
int findSymmetryH(int currentPositionIndex) {
```

### findSymmetryV

Trouve l'index de la position qui correspond à une symétrie verticale
depuis la position actuelle
Retourne -1 si aucune symétrie n'est trouvée


```dart
int findSymmetryV(int currentPositionIndex) {
```

