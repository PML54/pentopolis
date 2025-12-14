# pentoscope/pentoscope_solver.dart

**Module:** pentoscope

## Fonctions

### toString

Résultat d'un placement de pièce


```dart
String toString() => 'Pièce $pieceId (idx=$pieceIndex), orient=$orientation → cells=$occupiedCells';
```

### isInBounds

Plateau simple pour Pentoscope (sans dépendance au Plateau principal)


```dart
bool isInBounds(int x, int y) => x >= 0 && x < width && y >= 0 && y < height;
```

### getCell

```dart
int getCell(int x, int y) => isInBounds(x, y) ? grid[y][x] : -1;
```

### setCell

```dart
void setCell(int x, int y, int value) {
```

### isFree

```dart
bool isFree(int x, int y) => getCell(x, y) == 0;
```

### copy

```dart
PentoscopeBoard copy() {
```

### cellIndex

Convertit (x, y) en index linéaire


```dart
int cellIndex(int x, int y) => y * width + x;
```

### hasSolution

Convertit index linéaire en (x, y)
Solver paramétré pour Pentoscope
Vérifie si une solution existe (rapide, s'arrête à la première)


```dart
bool hasSolution() {
```

### countAllSolutions

Trouve une solution et la retourne
Compte TOUTES les solutions (peut être long pour 5×5)


```dart
int countAllSolutions() {
```

### stopCounting

Arrête le comptage en cours


```dart
void stopCounting() {
```

