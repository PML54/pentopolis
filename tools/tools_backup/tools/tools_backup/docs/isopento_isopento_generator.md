# isopento/isopento_generator.dart

**Module:** isopento

## Fonctions

### IsopentoSize

Tailles de plateau disponibles


```dart
const IsopentoSize(this.dataIndex, this.width, this.height, this.numPieces, this.label);
```

### IsopentoPuzzle

Configuration d'un puzzle Isopento


```dart
const IsopentoPuzzle({
```

### toString

Noms des pièces (F, I, L, N, P, T, U, V, W, X, Y, Z)
Retourne les noms des pièces du puzzle
Description lisible


```dart
String toString() => 'IsopentoPuzzle($description)';
```

### generate

Générateur de puzzles Isopento
Génère un puzzle aléatoire pour une taille donnée


```dart
IsopentoPuzzle generate(IsopentoSize size) {
```

### StateError

```dart
throw StateError('Aucune configuration disponible pour ${size.label}');
```

### IsopentoPuzzle

```dart
return IsopentoPuzzle( size: size, bitmask: bitmask, pieceIds: _bitmaskToIds(bitmask), solutionCount: solutionCount, );
```

### generateEasy

Génère un puzzle en favorisant ceux avec plus de solutions (plus faciles)


```dart
IsopentoPuzzle generateEasy(IsopentoSize size) {
```

### StateError

```dart
throw StateError('Aucune configuration disponible pour ${size.label}');
```

### IsopentoPuzzle

```dart
return IsopentoPuzzle( size: size, bitmask: bitmask, pieceIds: _bitmaskToIds(bitmask), solutionCount: solutionCount, );
```

### generate

```dart
return generate(size);
```

### generateHard

Génère un puzzle en favorisant ceux avec moins de solutions (plus durs)


```dart
IsopentoPuzzle generateHard(IsopentoSize size) {
```

### StateError

```dart
throw StateError('Aucune configuration disponible pour ${size.label}');
```

### IsopentoPuzzle

```dart
return IsopentoPuzzle( size: size, bitmask: bitmask, pieceIds: _bitmaskToIds(bitmask), solutionCount: solutionCount, );
```

### generate

```dart
return generate(size);
```

### getAllForSize

Retourne toutes les configurations pour une taille


```dart
List<IsopentoPuzzle> getAllForSize(IsopentoSize size) {
```

### getStats

Statistiques pour une taille


```dart
IsopentoStats getStats(IsopentoSize size) {
```

### IsopentoStats

```dart
return IsopentoStats( size: size, configCount: entries.length, totalSolutions: totalSolutions, minSolutions: minSolutions, maxSolutions: maxSolutions, );
```

### IsopentoStats

Convertit un bitmask en liste d'IDs de pièces
Statistiques pour une taille de plateau


```dart
const IsopentoStats({
```

### toString

```dart
String toString() => '${size.label}: $configCount configs, '
```

