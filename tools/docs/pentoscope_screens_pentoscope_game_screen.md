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
return Scaffold( backgroundColor: Colors.white, appBar: isLandscape ? null : PreferredSize( preferredSize: const Size.fromHeight(56.0), child: AppBar( toolbarHeight: 56.0, backgroundColor: Colors.white, automaticallyImplyLeading: !isPlacedPieceSelected, leading: isPlacedPieceSelected ? null  // Pas de croix quand icônes isométrie actifs : IconButton( icon: const Icon(Icons.close, color: Colors.red), onPressed: () => Navigator.pop(context), ), // EXCLUSIF: // 1. Actions isométrie si pièce PLATEAU sélectionnée // 2. Reset si pièce SLIDER sélectionnée // 3. Solution count si AUCUNE pièce sélectionnée title: isPlacedPieceSelected ? null //       : _buildSolutionCountWidget(state), :null, actions: isPlacedPieceSelected ? [ _buildIsometryActionsBar( state, ref.read(pentoscopeProvider.notifier), settings, Axis.horizontal, ), ] : isSliderPieceSelected ? [ // Rien en AppBar si pièce slider (actions au-dessus slider) ] : [ // Reset en mode général IconButton( icon: const Icon(Icons.games), onPressed: () {
```

### IconButton

Widget réutilisable pour les icônes isométrie (horizontal ou vertical)
Helper: bouton d'action isométrie


```dart
return IconButton( icon: Icon(icon.icon, size: settings.ui.iconSize), onPressed: () {
```

### Text

Affiche le nombre de solutions


```dart
return Text( '$count solution${count != 1 ? "s" : ""}',
```

### AnimatedContainer

Construit le slider avec DragTarget (drag pièce vers slider = suppression)


```dart
return AnimatedContainer( duration: const Duration(milliseconds: 150), width: width, height: height, decoration: decoration.copyWith( border: isHovering ? Border.all(color: Colors.red.shade400, width: 3) : null, color: isHovering ? Colors.red.shade50 : decoration.color, ), child: Stack( children: [ sliderChild, // Icône poubelle au survol if (isHovering) Positioned.fill( child: IgnorePointer( child: Container( color: Colors.red.withOpacity(0.1), child: Center( child: Container( padding: const EdgeInsets.all(12), decoration: BoxDecoration( color: Colors.red.shade100, shape: BoxShape.circle, ), child: Icon( Icons.delete_outline, color: Colors.red.shade700, size: 32, ), ), ), ), ), ), ], ), );
```

### Column

Layout portrait : plateau en haut, actions + slider en bas


```dart
return Column( children: [ // Plateau de jeu const Expanded(flex: 3, child: PentoscopeBoard(isLandscape: false)),  // 🎯 Actions isométrie UNIQUEMENT si pièce du SLIDER sélectionnée // (exclue si pièce plateau sélectionnée) if (isSliderPieceSelected && !isPlacedPieceSelected) Padding( padding: const EdgeInsets.symmetric(vertical: 8), child: _buildIsometryActionsBar( state, notifier, settings, Axis.horizontal, ), ),  // Slider de pièces horizontal _buildSliderWithDragTarget( ref: ref, isLandscape: false, height: 140, decoration: BoxDecoration( color: Colors.grey.shade100, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2), ), ], ), sliderChild: const PentoscopePieceSlider(isLandscape: false), ), ], );
```

### Expanded

```dart
const Expanded(flex: 3, child: PentoscopeBoard(isLandscape: false)),  // 🎯 Actions isométrie UNIQUEMENT si pièce du SLIDER sélectionnée // (exclue si pièce plateau sélectionnée) if (isSliderPieceSelected && !isPlacedPieceSelected) Padding( padding: const EdgeInsets.symmetric(vertical: 8), child: _buildIsometryActionsBar( state, notifier, settings, Axis.horizontal, ), ),  // Slider de pièces horizontal _buildSliderWithDragTarget( ref: ref, isLandscape: false, height: 140, decoration: BoxDecoration( color: Colors.grey.shade100, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2), ), ], ), sliderChild: const PentoscopePieceSlider(isLandscape: false), ), ], );
```

### Row

Layout paysage : plateau à gauche, actions + slider vertical à droite


```dart
return Row( children: [ // Plateau de jeu const Expanded(child: PentoscopeBoard(isLandscape: true)),  // Colonne de droite : actions + slider Row( children: [ // 🎯 Colonne d'actions (contextuelles) Container( width: 44, decoration: BoxDecoration( color: Colors.white, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(-1, 0), ), ], ), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: isPlacedPieceSelected ? [ // Actions isométrie si pièce plateau sélectionnée _buildIsometryActionsBar( state, notifier, settings, Axis.vertical, ), ] : [ // Actions générales IconButton( icon: const Icon(Icons.games), onPressed: () {
```

### Expanded

```dart
const Expanded(child: PentoscopeBoard(isLandscape: true)),  // Colonne de droite : actions + slider Row( children: [ // 🎯 Colonne d'actions (contextuelles) Container( width: 44, decoration: BoxDecoration( color: Colors.white, boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(-1, 0), ), ], ), child: Column( mainAxisAlignment: MainAxisAlignment.center, children: isPlacedPieceSelected ? [ // Actions isométrie si pièce plateau sélectionnée _buildIsometryActionsBar( state, notifier, settings, Axis.vertical, ), ] : [ // Actions générales IconButton( icon: const Icon(Icons.games), onPressed: () {
```

