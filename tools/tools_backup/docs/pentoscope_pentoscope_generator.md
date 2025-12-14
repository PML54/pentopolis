# pentoscope/pentoscope_generator.dart

**Module:** pentoscope

## Fonctions

### generate

Générateur de puzzles Pentoscope
Génère un puzzle aléatoire pour une taille donnée


```dart
PentoscopePuzzle generate(PentoscopeSize size) {
```

### StateError

```dart
throw StateError('Aucune configuration disponible pour ${size.label}');
```

### PentoscopePuzzle

```dart
return PentoscopePuzzle( size: size, bitmask: bitmask, pieceIds: _bitmaskToIds(bitmask), solutionCount: solutionCount, );
```

### generateEasy

Génère un puzzle en favorisant ceux avec plus de solutions (plus faciles)


```dart
PentoscopePuzzle generateEasy(PentoscopeSize size) {
```

### StateError

```dart
throw StateError('Aucune configuration disponible pour ${size.label}');
```

### PentoscopePuzzle

```dart
return PentoscopePuzzle( size: size, bitmask: bitmask, pieceIds: _bitmaskToIds(bitmask), solutionCount: solutionCount, );
```

### generate

```dart
return generate(size);
```

### generateHard

Génère un puzzle en favorisant ceux avec moins de solutions (plus durs)


```dart
PentoscopePuzzle generateHard(PentoscopeSize size) {
```

### StateError

```dart
throw StateError('Aucune configuration disponible pour ${size.label}');
```

### PentoscopePuzzle

```dart
return PentoscopePuzzle( size: size, bitmask: bitmask, pieceIds: _bitmaskToIds(bitmask), solutionCount: solutionCount, );
```

### generate

```dart
return generate(size);
```

### getAllForSize

Retourne toutes les configurations pour une taille


```dart
List<PentoscopePuzzle> getAllForSize(PentoscopeSize size) {
```

### getStats

Statistiques pour une taille


```dart
PentoscopeStats getStats(PentoscopeSize size) {
```

### PentoscopeStats

```dart
return PentoscopeStats( size: size, configCount: entries.length, totalSolutions: totalSolutions, minSolutions: minSolutions, maxSolutions: maxSolutions, );
```

### PentoscopePuzzle

Convertit un bitmask en liste d'IDs de pièces
Configuration d'un puzzle Pentoscope
Noms des pièces (F, I, L, N, P, T, U, V, W, X, Y, Z)


```dart
const PentoscopePuzzle({
```

### toString

Description lisible
Retourne les noms des pièces du puzzle


```dart
String toString() => 'PentoscopePuzzle($description)';
```

### PentoscopeSize

Tailles de plateau disponibles


```dart
const PentoscopeSize( this.dataIndex, this.width, this.height, this.numPieces, this.label, );
```

### PentoscopeStats

Statistiques pour une taille de plateau


```dart
const PentoscopeStats({
```

### toString

```dart
String toString() => '${size.label}: $configCount configs, '
```

