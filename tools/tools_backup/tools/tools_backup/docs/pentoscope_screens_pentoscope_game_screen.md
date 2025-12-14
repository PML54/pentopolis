# pentoscope/screens/pentoscope_game_screen.dart

**Module:** pentoscope

## Fonctions

### PentoscopeGameScreen

```dart
const PentoscopeGameScreen({super.key});
```

### build

```dart
Widget build(BuildContext context, WidgetRef ref) {
```

### Scaffold

```dart
return Scaffold( backgroundColor: Colors.white, appBar: isLandscape ? null : PreferredSize( preferredSize: const Size.fromHeight(56.0), child: AppBar( toolbarHeight: 56.0, backgroundColor: Colors.white, leading: IconButton( icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), ), title: null, // PAS DE TITRE actions: isInTransformMode ? _buildTransformActions(state, notifier, settings) : _buildGeneralActions(state, notifier), ), ), body: Stack( children: [ LayoutBuilder( builder: (context, constraints) {
```

### AnimatedContainer

Actions en mode TRANSFORMATION (pièce sélectionnée)
Actions en mode GÉNÉRAL (aucune pièce sélectionnée)
Construit le slider enveloppé dans un DragTarget
Quand on drag une pièce placée vers le slider, elle est retirée du plateau


```dart
return AnimatedContainer( duration: const Duration(milliseconds: 150), width: width, height: height, decoration: decoration.copyWith( border: isHovering ? Border.all(color: Colors.red.shade400, width: 3) : null, color: isHovering ? Colors.red.shade50 : decoration.color, ), child: Stack( children: [ sliderChild, // Icône poubelle qui apparaît au survol if (isHovering) Positioned.fill( child: IgnorePointer( child: Container( color: Colors.red.withOpacity(0.1), child: Center( child: Container( padding: const EdgeInsets.all(12), decoration: BoxDecoration( color: Colors.red.shade100, shape: BoxShape.circle, ), child: Icon( Icons.delete_outline, color: Colors.red.shade700, size: 32, ), ), ), ), ), ), ], ), );
```

### Column

Layout portrait : plateau en haut, slider en bas


```dart
return Column( children: [ // Plateau de jeu const Expanded( flex: 3, child: PentoscopeBoard(isLandscape: false), ),  // Slider de pièces horizontal avec DragTarget _buildSliderWithDragTarget( ref: ref, isLandscape: false, height: 140, decoration: BoxDecoration( color: Colors.grey.shade100, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2), ), ], ), sliderChild: const PentoscopePieceSlider(isLandscape: false), ), ], );
```

### Expanded

```dart
const Expanded( flex: 3, child: PentoscopeBoard(isLandscape: false), ),  // Slider de pièces horizontal avec DragTarget _buildSliderWithDragTarget( ref: ref, isLandscape: false, height: 140, decoration: BoxDecoration( color: Colors.grey.shade100, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2), ), ], ), sliderChild: const PentoscopePieceSlider(isLandscape: false), ), ], );
```

### Row

Layout paysage : plateau à gauche, actions + slider vertical à droite


```dart
return Row( children: [ // Plateau de jeu const Expanded( child: PentoscopeBoard(isLandscape: true), ),  // Colonne de droite : actions + slider Row( children: [ // Slider d'actions verticales Container( width: 44, decoration: BoxDecoration( color: Colors.white, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(-1, 0), ), ], ), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: isInTransformMode ? _buildTransformActions(state, notifier, settings) : [ // Reset en mode général IconButton( icon: const Icon(Icons.refresh), onPressed: () {
```

### Expanded

```dart
const Expanded( child: PentoscopeBoard(isLandscape: true), ),  // Colonne de droite : actions + slider Row( children: [ // Slider d'actions verticales Container( width: 44, decoration: BoxDecoration( color: Colors.white, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(-1, 0), ), ], ), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: isInTransformMode ? _buildTransformActions(state, notifier, settings) : [ // Reset en mode général IconButton( icon: const Icon(Icons.refresh), onPressed: () {
```

