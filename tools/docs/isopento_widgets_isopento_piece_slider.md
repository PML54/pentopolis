# isopento/widgets/isopento_piece_slider.dart

**Module:** isopento

## Fonctions

### IsopentoPieceSlider

```dart
const IsopentoPieceSlider({
```

### build

```dart
Widget build(BuildContext context, WidgetRef ref) {
```

### Padding

Convertit positionIndex interne en displayPositionIndex pour l'affichage
En paysage: applique rotation inverse de -90° pour compenser le pivot du plateau


```dart
return Padding( padding: const EdgeInsets.symmetric(horizontal: 6), child: Stack( children: [ Container( padding: const EdgeInsets.all(10), decoration: BoxDecoration( color: isSelected ? Colors.amber.shade100 : Colors.transparent, borderRadius: BorderRadius.circular(12), border: isSelected ? Border.all(color: Colors.amber.shade700, width: 3) : null, boxShadow: isSelected ? [ BoxShadow( color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4), ), ] : null, ), child: DraggablePieceWidget( piece: piece, positionIndex: positionIndex, isSelected: isSelected, selectedPositionIndex: state.selectedPositionIndex, longPressDuration: Duration(milliseconds: settings.game.longPressDuration), onSelect: () {
```

