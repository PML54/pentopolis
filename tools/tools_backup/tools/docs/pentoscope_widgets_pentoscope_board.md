# pentoscope/widgets/pentoscope_board.dart

**Module:** pentoscope

## Fonctions

### PentoscopeBoard

```dart
const PentoscopeBoard({super.key, required this.isLandscape});
```

### build

```dart
Widget build(BuildContext context, WidgetRef ref) {
```

### LayoutBuilder

```dart
return LayoutBuilder( builder: (context, constraints) {
```

### Center

```dart
return Center( child: Container( width: gridWidth, height: gridHeight, decoration: BoxDecoration( gradient: LinearGradient( begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.grey.shade50, Colors.grey.shade100], ), boxShadow: [ BoxShadow( color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 4), ), ], borderRadius: BorderRadius.circular(16), ), child: ClipRRect( borderRadius: BorderRadius.circular(16), child: GridView.builder( physics: const NeverScrollableScrollPhysics(), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: visualCols, childAspectRatio: 1.0, crossAxisSpacing: 0, mainAxisSpacing: 0, ), itemCount: boardWidth * boardHeight, itemBuilder: (context, index) {
```

### Icon

Calcule le décalage minimum pour normaliser une forme


```dart
const Icon( Icons.emoji_events, color: Colors.amber, size: 24, ), const SizedBox(width: 8), Text( 'Bravo ! ${state.puzzle?.size.label}',
```

### SizedBox

```dart
const SizedBox(width: 8), Text( 'Bravo ! ${state.puzzle?.size.label}',
```

### SizedBox

```dart
const SizedBox(height: 8), Text( 'Isométries: ${state.isometryCount}  Translations: ${state.translationCount}',
```

### SizedBox

```dart
const SizedBox(height: 12), Row( mainAxisSize: MainAxisSize.min, children: [ TextButton( onPressed: () {
```

### SizedBox

```dart
const SizedBox(width: 8), ElevatedButton( onPressed: () {
```

