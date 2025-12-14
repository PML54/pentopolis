# isopento/screens/isopento_menu_screen.dart

**Module:** isopento

## Fonctions

### IsopentoMenuScreen

```dart
const IsopentoMenuScreen({super.key});
```

### createState

```dart
ConsumerState<IsopentoMenuScreen> createState() => _IsopentoMenuScreenState();
```

### build

```dart
Widget build(BuildContext context) {
```

### Scaffold

```dart
return Scaffold( appBar: AppBar( title: const Text('Isopento'), centerTitle: true, elevation: 0, ), body: SafeArea( child: Padding( padding: const EdgeInsets.all(16.0), child: Column( crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [ // Titre   // SECTION TAILLE Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text( 'Taille du plateau', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 12), _buildSizeOption(IsopentoSize.size3x5, '3 × 5'), const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size4x5, '4 × 5'), const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size5x5, '5 × 5'), ], ),  // SECTION DIFFICULTÉ Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text( 'Difficulté', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 10), _buildDifficultyOption( IsopentoDifficulty.easy, '😊 Facile', Colors.green, ),  const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### Text

```dart
const Text( 'Taille du plateau', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 12), _buildSizeOption(IsopentoSize.size3x5, '3 × 5'), const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size4x5, '4 × 5'), const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size5x5, '5 × 5'), ], ),  // SECTION DIFFICULTÉ Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text( 'Difficulté', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 10), _buildDifficultyOption( IsopentoDifficulty.easy, '😊 Facile', Colors.green, ),  const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### SizedBox

```dart
const SizedBox(height: 12), _buildSizeOption(IsopentoSize.size3x5, '3 × 5'), const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size4x5, '4 × 5'), const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size5x5, '5 × 5'), ], ),  // SECTION DIFFICULTÉ Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text( 'Difficulté', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 10), _buildDifficultyOption( IsopentoDifficulty.easy, '😊 Facile', Colors.green, ),  const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### SizedBox

```dart
const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size4x5, '4 × 5'), const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size5x5, '5 × 5'), ], ),  // SECTION DIFFICULTÉ Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text( 'Difficulté', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 10), _buildDifficultyOption( IsopentoDifficulty.easy, '😊 Facile', Colors.green, ),  const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### SizedBox

```dart
const SizedBox(height: 8), _buildSizeOption(IsopentoSize.size5x5, '5 × 5'), ], ),  // SECTION DIFFICULTÉ Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text( 'Difficulté', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 10), _buildDifficultyOption( IsopentoDifficulty.easy, '😊 Facile', Colors.green, ),  const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### Text

```dart
const Text( 'Difficulté', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600), ), const SizedBox(height: 10), _buildDifficultyOption( IsopentoDifficulty.easy, '😊 Facile', Colors.green, ),  const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### SizedBox

```dart
const SizedBox(height: 10), _buildDifficultyOption( IsopentoDifficulty.easy, '😊 Facile', Colors.green, ),  const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### SizedBox

```dart
const SizedBox(height: 8), _buildDifficultyOption( IsopentoDifficulty.hard, '🔥 Difficile', Colors.orange, ), ], ),  // BOUTON JOUER ElevatedButton( style: ElevatedButton.styleFrom( backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), onPressed: _startGame, child: const Text( 'Jouer', style: TextStyle( fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, ), ), ), ], ), ), ), );
```

### GestureDetector

```dart
return GestureDetector( onTap: () {
```

### SizedBox

```dart
const SizedBox(height: 4), Text( '${size.numPieces} pièces • ${stats.configCount} configs',
```

### GestureDetector

```dart
return GestureDetector( onTap: () {
```

