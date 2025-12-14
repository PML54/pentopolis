# isopento/screens/isopento_game_screen.dart

**Module:** isopento

## Fonctions

### IsopentoGameScreen

```dart
const IsopentoGameScreen({super.key});
```

### build

```dart
Widget build(BuildContext context, WidgetRef ref) {
```

### Scaffold

```dart
return Scaffold( backgroundColor: Colors.white, appBar: isLandscape ? null : PreferredSize( preferredSize: const Size.fromHeight(56.0), child: AppBar( toolbarHeight: 56.0, backgroundColor: Colors.white, elevation: 0, leading: isInTransformMode ? IconButton( icon: Icon(Icons.close, color: Colors.red.shade700, size: config.closeIconSize), onPressed: () {
```

### Column

```dart
return Column( children: [ Expanded( flex: 3, child: IsopentoBoard(isLandscape: false), ), _buildSliderWithDragTarget( ref: null, isLandscape: false, sliderChild: const IsopentoPieceSlider(isLandscape: false), height: config.portraitSliderHeight, ), ], );
```

### Row

```dart
return Row( children: [ const Expanded( child: IsopentoBoard(isLandscape: true), ), if (isInTransformMode) Container( width: config.landscapeActionsWidth, color: Colors.grey.shade50, child: Column( mainAxisAlignment: MainAxisAlignment.center, children: _buildTransformActions( state, notifier, settings, config, isLandscape: true, ), ), ), _buildSliderWithDragTarget( ref: null, isLandscape: true, sliderChild: const IsopentoPieceSlider(isLandscape: true), width: config.landscapeSliderWidth, ), ], );
```

### Expanded

```dart
const Expanded( child: IsopentoBoard(isLandscape: true), ), if (isInTransformMode) Container( width: config.landscapeActionsWidth, color: Colors.grey.shade50, child: Column( mainAxisAlignment: MainAxisAlignment.center, children: _buildTransformActions( state, notifier, settings, config, isLandscape: true, ), ), ), _buildSliderWithDragTarget( ref: null, isLandscape: true, sliderChild: const IsopentoPieceSlider(isLandscape: true), width: config.landscapeSliderWidth, ), ], );
```

### AnimatedContainer

```dart
return AnimatedContainer( duration: const Duration(milliseconds: 150), width: width, height: height, decoration: BoxDecoration( color: isHovering ? Colors.red.shade50 : Colors.white, border: Border( left: isLandscape ? BorderSide( color: isHovering ? Colors.red.shade400 : Colors.grey.shade200, width: isHovering ? 3 : 1, ) : BorderSide( color: isHovering ? Colors.red.shade400 : Colors.grey.shade200, width: isHovering ? 3 : 1, ), ), ), child: Stack( children: [ sliderChild, if (isHovering) Positioned.fill( child: IgnorePointer( child: Container( color: Colors.red.withOpacity(0.1), child: Center( child: Container( padding: const EdgeInsets.all(12), decoration: BoxDecoration( color: Colors.red.shade100, shape: BoxShape.circle, ), child: Icon( Icons.delete_outline, color: Colors.red.shade700, size: 32, ), ), ), ), ), ), ], ), );
```

