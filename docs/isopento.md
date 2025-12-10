# ISOPENTO - Documentation Module

## 📋 Manifest des fichiers

| Fichier | Chemin | Modified | Lignes | Statut |
|---------|--------|----------|--------|--------|
| isopento_data.dart | lib/isopento/isopento_data.dart | 2512090930 | 50 | ✅ |
| isopento_solver.dart | lib/isopento/isopento_solver.dart | 2512091000 | 405 | ✅ |
| isopento_generator.dart | lib/isopento/isopento_generator.dart | 2512091005 | 196 | ✅ |
| isopento_provider.dart | lib/isopento/isopento_provider.dart | 2512091015 | 1005 | ✅ |
| isopento_config.dart | lib/isopento/isopento_config.dart | 2512092200 | 145 | ✅ |
| isopento_game_screen.dart | lib/isopento/screens/isopento_game_screen.dart | 2512091020 | 355 | ✅ |
| isopento_menu_screen.dart | lib/isopento/screens/isopento_menu_screen.dart | 2512091025 | 221 | ✅ |
| isopento_piece_slider.dart | lib/isopento/widgets/isopento_piece_slider.dart | 2512091030 | 124 | ✅ |
| isopento_board.dart | lib/isopento/widgets/isopento_board.dart | 2512091035 | 528 | ✅ |

**Format timestamp** : YYMMDDHHM (année-mois-jour-heure-minute)
- 25 = 2025
- 12 = décembre
- 09 = jour 9
- 09-10-15-20-25-30-35 = progression horaire pour tracking

**Total** : 9 fichiers, ~3,029 lignes de code production

---

## 📝 En-têtes standardisés

```dart
// Format standard pour tous les fichiers:
// lib/isopento/[module].dart
// Modified: YYMMDDHHM

// Exemple:
// lib/isopento/isopento_solver.dart
// Modified: 2512091000
```

### Headers détaillés

**isopento_data.dart**
```dart
// lib/isopento/isopento_data.dart
// Modified: 2512090930
// Généré automatiquement - Ne pas modifier
// IDs: 1=X, 2=P, 3=T, 4=F, 5=Y, 6=V, 7=U, 8=L, 9=N, 10=W, 11=Z, 12=I
```

**isopento_solver.dart**
```dart
// lib/isopento/isopento_solver.dart
// Modified: 2512091000
// Solver paramétré pour mini-plateaux (3×5, 4×5, 5×5)
// Copie adaptée de pentomino_solver.dart - AUCUN impact sur le mode 6×10
```

**isopento_generator.dart**
```dart
// lib/isopento/isopento_generator.dart
// Modified: 2512091005
// Générateur de puzzles Isopento utilisant les données pré-calculées
```

**isopento_provider.dart**
```dart
// lib/isopento/isopento_provider.dart
// Modified: 2512091015
// Provider Isopento - calqué sur pentomino_game_provider
// MODIFIÉ: Ajout de solutionPlateau pour afficher la solution en semi-transparent
```

**isopento_game_screen.dart**
```dart
// lib/isopento/isopento_game_screen.dart
// Modified: 2512091020
// Modifications: Icones 56px + AppBar vide (pas de sélection) 
// Supprimer actions paysage (pas sélection) + Croix rouge retour 
// Inverser symétries H↔V en paysage
// Écran de jeu Isopento - calqué sur pentomino_game_screen.dart
// MODIFICATION: Drag vers slider = retirer la pièce
```

**isopento_menu_screen.dart**
```dart
// lib/isopento/isopento_menu_screen.dart
// Modified: 2512091025
// Menu principal Isopento - sélection taille et difficulté
```

**isopento_piece_slider.dart**
```dart
// lib/isopento/isopento_piece_slider.dart
// Modified: 2512091030
// Slider de pièces Isopento - calqué sur piece_slider.dart
// FIXÉ: Utilise DraggablePieceWidget pour que le drag fonctionne
```

**isopento_board.dart**
```dart
// lib/isopento/isopento_board.dart
// Modified: 2512091035
// Plateau Isopento - calqué sur game_board.dart
// MODIFIÉ: Affiche la solution en semi-transparent + pièces joueur en opaque
```

---

## 🔄 Historique des modifications

| Timestamp | Fichier | Modification |
|-----------|---------|--------------|
| 2512090930 | isopento_data.dart | Création + headers correction |
| 2512091000 | isopento_solver.dart | Création + headers correction |
| 2512091005 | isopento_generator.dart | Création + headers correction |
| 2512091015 | isopento_provider.dart | Création + headers correction |
| 2512091020 | isopento_game_screen.dart | Création + headers correction |
| 2512091025 | isopento_menu_screen.dart | Création + headers correction |
| 2512091030 | isopento_piece_slider.dart | Création + headers correction |
| 2512091035 | isopento_board.dart | Création + headers correction |

---



Module de puzzle pentomino isométrique. Calcule le nombre d'isométries pour résoudre un puzzle pentomino donné et structure les données pour exploitation réseau.

**Objectif** : Créer une couche réutilisable pour d'autres modules basés sur les isométries géométriques.

---

## Architecture générale

```
lib/isopento/
├── Core (logique métier)
│   ├── isopento_data.dart          → Table pré-calculée
│   ├── isopento_solver.dart        → Backtracking + comptage
│   ├── isopento_generator.dart     → Génération aléatoire
│   └── isopento_provider.dart      → Orchestration state
├── Config
│   └── isopento_config.dart        → Tailles UI centralisées
├── screens/ (présentation)
│   ├── isopento_game_screen.dart   → Écran principal jeu
│   └── isopento_menu_screen.dart   → Menu sélection
└── widgets/ (composants)
    ├── isopento_piece_slider.dart  → Sélection pièces
    └── isopento_board.dart         → Plateau + affichage
```

---

## Flux de données et dépendances

```
pentominos.dart (référence statique : 12 pièces × orientations)
       ↓
isopento_data.dart (table pré-calculée : configs × solutions)
       ↓
isopento_generator.dart (génération aléatoire avec difficulté)
       ↓
isopento_solver.dart (résolution et comptage)
       ↓
isopento_provider.dart (orchestration + Riverpod state management)
       ↓
UI (screens + widgets)
```

**Dépendances résumées** :
- `isopento_data` → statique, aucune dépendance
- `isopento_generator` → dépend de `isopento_data`
- `isopento_solver` → dépend de `pentominos`
- `isopento_provider` → dépend de `isopento_generator` + `isopento_solver` + `isometry_transforms`
- Screens/Widgets → dépendent de `isopento_provider`

**Flux state management** :
1. Widget appelle `startPuzzle(size, difficulty)` via provider
2. Provider génère puzzle → résout avec Solver → crée solutionPlateau
3. État initial créé → widgets affichent plateau vide + pieces slider
4. Interactions utilisateur → mutations d'état (placement, rotations, etc.)
5. Isométries calculées via BFS → score mis à jour
6. Completion validée → state.isComplete = true

---

## Concepts clés

### 1. **Isométries**
Les 12 pentominos possèdent chacun un ensemble d'orientations distinctes (positions). Une isométrie est une transformation géométrique (rotation 90°, symétrie H/V) qui navigue entre ces orientations.

**Source** : `pentominos.dart` expose les méthodes :
- `findRotation90(posIndex)` → Position après rotation 90° CCW
- `findSymmetryH(posIndex)` → Position après symétrie horizontale
- `findSymmetryV(posIndex)` → Position après symétrie verticale

### 2. **Puzzle**
Ensemble de contraintes définissant quelles pièces doivent être placées et avec quelles orientations autorisées.

### 3. **Solution**
Placement valide de pièces satisfaisant les contraintes du puzzle.

---

## Modules détaillés

### isopento_data.dart
**Rôle** : Table de lookup pré-calculée des configurations de puzzles et leurs solutions.

**Chemin** : `lib/isopento/isopento_data.dart`

**Structure** : `const Map<int, List<(int, int)>> isopentoData`

**Format des données** :
- **Clé** : Niveau de difficulté (0=3×5, 1=4×5, 2=5×5)
- **Valeur** : Liste de tuples `(masque, numSolutions)`
    - `masque` (hex) : Code binaire 12 bits représentant un ensemble de pièces
        - Bit `n` = 1 → pièce `n+1` présente
        - Exemple : 0x04A = 0b001001010 → pièces 2(P), 4(F), 7(U)
    - `numSolutions` (int) : Nombre de placements valides distincts

**Données précalculées** :
```
Niveau 0 (3×5) :  7 configurations →  28 solutions totales
Niveau 1 (4×5) : 26 configurations → 200 solutions totales
Niveau 2 (5×5) : 45 configurations → 856 solutions totales
```

**Caractéristiques** :
- Immuable (`const`) → lookup O(1) ultra-rapide
- Solutions pré-calculées hors-ligne
- Permet au `generator` de sélectionner une config avec difficulté connue

**Dépendances** :
- Aucune (données brutes)

**Utilisé par** :
- `isopento_generator.dart` : Sélection config aléatoire
- `isopento_solver.dart` : Validation et vérification

---

### isopento_solver.dart
**Rôle** : Moteur de backtracking pour résolution et comptage de solutions sur mini-plateaux.

**Chemin** : `lib/isopento/isopento_solver.dart`

**Classes** :

**1. `IsopentoPlacement`**
- Représente un placement unique d'une pièce
- Propriétés : pieceIndex, pieceId, orientation, (offsetX, offsetY), occupiedCells
- Utilisé pour tracer l'historique de résolution

**2. `IsopentoBoard`**
- Plateau indépendant (width × height), dépourvu de dépendances au système principal
- Grid : 0 = libre, >0 = pieceId occupant la cellule
- Conversions : cellIndex(x,y) ↔ cellCoords(index)

**3. `IsopentoSolver`**
- Constructeur : `IsopentoSolver(width, height, pieces, maxSeconds=30)`
- **API publique** :
    - `hasSolution()` → bool (détection rapide)
    - `findSolution()` → List<IsopentoPlacement>? (première solution)
    - `countAllSolutions()` → int (énumération complète)
    - `stopCounting()` → void (arrêt du comptage)

**Algorithme de backtracking** :
1. Trouve la première case libre (index linéaire)
2. Essaie chaque pièce non-utilisée dans toutes ses orientations
3. Valide le placement avec `_areIsolatedRegionsValid()` (heuristique d'élagage)
4. Backtrack si validation échoue
5. Retour : solution trouvée ou comptage complet

**Conversion de coordonnées (pentomino 5×5 → plateau)** :
```
x = (cell - 1) % 5
y = (cell - 1) ~/ 5
```
Point d'ancrage : cellule minimum de la forme, alignée sur la case cible.

**Heuristique d'isolated regions** :
Détecte les régions libres isolées via flood-fill. Rejette les états où :
- Région < 5 cellules (impossible)
- Région non multiple de 5 (impossible)
- Région == 5 : aucune pièce disponible ne peut la remplir exactement

**Performance** :
- Timeout : maxSeconds protège contre les cas infinis
- `stopCounting()` permet arrêt gracieux des longs comptages
- Heuristique réduit drastiquement l'espace de recherche

**Dépendances** :
- `pentominos.dart` : pour Pento, numPositions, positions

**Utilisé par** :
- `isopento_generator.dart` : validation et comptage des solutions
- `isopento_provider.dart` : résolution en background

---

### isopento_generator.dart
**Rôle** : Génération aléatoire de puzzles avec sélection par difficulté.

**Chemin** : `lib/isopento/isopento_generator.dart`

**Classes** :

**1. `IsopentoSize` (Enum)**
- 3 valeurs : size3x5, size4x5, size5x5
- Chacune mappe :
    - `dataIndex` (0, 1, 2) → clé dans isopentoData
    - `width`, `height` → dimensions du plateau
    - `numPieces` → nombre de pièces à placer
    - `label` → description lisible ("3×5", etc.)
- Propriété : `area` (width × height)

**2. `IsopentoPuzzle`**
- Représente un puzzle généré
- Propriétés : size, bitmask (code 12 bits), pieceIds, solutionCount
- Conversions :
    - `pieceNames` : IDs → lettres (X,P,T,F,Y,V,U,L,N,W,Z,I)
    - `description` : string lisible avec noms et nombre de solutions

**3. `IsopentoGenerator`**
- Constructeur : `IsopentoGenerator([Random? random])`
- **Méthodes de génération** :
    - `generate(size)` : Sélection **uniforme** (chaque config a la même probabilité)
    - `generateEasy(size)` : Pondération par nombre de solutions (configs faciles favorisées)
    - `generateHard(size)` : Pondération inverse (configs dures favorisées)
- **Méthodes utilitaires** :
    - `getAllForSize(size)` : Liste complète de toutes les configs
    - `getStats(size)` : Statistiques globales (min, max, avg solutions)
- **Privé** :
    - `_bitmaskToIds(int)` : Décode bitmask 12 bits en liste d'IDs (1-12)

**4. `IsopentoStats`**
- Statistiques de distribution
- Propriétés : configCount, totalSolutions, minSolutions, maxSolutions
- Propriété calculée : `avgSolutions`

**Stratégies de difficulté** :
```
generateEasy:   P(config) ∝ solutionCount
                → configs avec plus de solutions → plus de placements valides
                
generateHard:   P(config) ∝ 1/solutionCount
                → configs avec peu de solutions → moins de placements, plus strict
```

**Conversion bitmask → pieceIds** :
```
Bitmask (12 bits) : bit i = 1 → pièce (i+1) présente
Exemple : 0x04A = 0b001001010 → bits 1,3,6 → pièces 2,4,7 → P,F,U
```

**Dépendances** :
- `isopento_data.dart` : isopentoData (table pré-calculée)
- `dart:math` : Random, min, max

**Utilisé par** :
- `isopento_provider.dart` : Génération et création de nouveaux puzzles
- `isopento_game_screen.dart` : Sélection difficulté lors du menu

---

### isopento_provider.dart
**Rôle** : Gestion d'état globale via Riverpod. Orchestration complète du jeu Isopento.

**Chemin** : `lib/isopento/isopento_provider.dart`

**Classes** :

**1. `IsopentoPlacedPiece`**
- Représente une pièce placée sur le plateau
- Propriétés : piece (Pento), positionIndex, gridX, gridY, isometriesUsed
- Méthode clé : `absoluteCells` (getter itérable) → coordonnées absolues normalisées
- Méthode : `copyWith()` → immutabilité

**2. `IsopentoState`**
Encapsule l'état complet du jeu avec 4 groupes logiques :

*Puzzle & Plateau* :
- `puzzle` → configuration active (IsopentoPuzzle?)
- `plateau` → état actuel du jeu (Plateau)
- `solutionPlateau` → solution de référence en semi-transparent (NEW)
- `availablePieces` → pièces à placer (List<Pento>)
- `placedPieces` → pièces placées (List<IsopentoPlacedPiece>)

*Sélection Slider* :
- `selectedPiece` → pièce en cours de sélection
- `selectedPositionIndex` → orientation active
- `piecePositionIndices` → Map mémorisant l'orientation de chaque pièce

*Sélection Plateau* :
- `selectedPlacedPiece` → pièce placée sélectionnée pour move/rotation
- `selectedCellInPiece` → "mastercase" (point de référence pour transformations)

*Preview & État* :
- `previewX`, `previewY`, `isPreviewValid` → visualisation avant placement
- `isComplete` → puzzle résolu?
- `isometryCount`, `translationCount` → comptage des transformations
- `isSnapped` → pièce alignée sur grille?

Méthodes utilitaires :
- `getPiecePositionIndex(pieceId)` → orientation d'une pièce donnée
- `canPlacePiece(piece, posIdx, gridX, gridY)` → validation placement
- `copyWith()` → création état immutable avec clears optionnels

**3. `IsopentoDifficulty` (Enum)**
- `easy` : configs avec plus de solutions (pondéré)
- `random` : sélection uniforme
- `hard` : configs avec moins de solutions (pondéré inverse)

**4. `IsopentoNotifier` (Notifier<IsopentoState>)**

**Sections principales** :

*Démarrage* :
- `startPuzzle(size, difficulty)` → génère puzzle, résout avec Solver, initialise plateaux
- `_generateSolutionPlateau(size, pieces)` → appelle IsopentoSolver.findSolution()

*Manipulation pièces slider* :
- `selectPiece(piece)` → sélection d'une pièce du slider
- `cycleToNextOrientation()` → navigue entre orientations disponibles
- `rotatePieceLeft()`, `rotatePieceRight()`, `flipPieceH()`, `flipPieceV()` → isométries
- `cancelSelection()` → désélection

*Placement & Drag* :
- `selectPlacedPiece(placed, absX, absY)` → sélection pièce placée + mastercase
- `updatePreview(gridX, gridY)` → affiche preview (valid ou invalid)
- `placePieceOnGrid()` → placement définitif
- `movePlacedPiece(newGridX, newGridY)` → déplacement pièce placée

*Validation & Helpers* :
- `_canPlacePieceAt(match, excludePiece)` → vérif chevauchements
- `_extractAbsoluteCoords(piece)` → normalisation → coords plateaus
- `_calculateDefaultCell(piece, posIdx)` → calcul mastercase par défaut

*Calcul Isométries* :
- `calculateMinimalIsometries(piece, targetPos)` → BFS pour chemin optimal
- `_findSymmetryHPosition(piece, pos)` → shape recognition symétrie H
- `_findSymmetryVPosition(piece, pos)` → shape recognition symétrie V

*Reset* :
- `reset()` → nouvelle partie même taille, même generator

**Dépendances** :
- `isopento_generator.dart` : génération puzzles aléatoires
- `isopento_solver.dart` : résolution et comptage solutions
- `pentominos.dart` : Pento, numPositions
- `plateau.dart`, `point.dart` : modèles UI
- `isometry_transforms.dart`, `shape_recognizer.dart` : reconnaissance formes
- `flutter_riverpod` : state management

**Provider Export** :
```dart
final isopentoProvider = NotifierProvider<IsopentoNotifier, IsopentoState>(
  IsopentoNotifier.new,
);
```

**Flux d'état** :
1. `startPuzzle()` → création état initial complet
2. Sélection pièce slider → `selectPiece()` / `cycleToNextOrientation()`
3. Drag sur plateau → `updatePreview()` → validation
4. Drop → `placePieceOnGrid()` → update plateau
5. Isométries (rotations/flips) → `calculateMinimalIsometries()` → update compteur
6. Completion check → `isComplete` flag

**Notes** :
- `solutionPlateau` permet affichage solution semi-transparent (mode hint)
- Mastercase (`selectedCellInPiece`) = point d'ancrage pour transformations
- BFS isométries : cherche chemin minimal depuis orientation initiale
- Shape recognition intègre isometric_transforms pour déterminer nouvelle orientation

---

### isopento_game_screen.dart
**Rôle** : Écran principal du jeu Isopento. Gère layout (portrait/paysage), actions de transformation, interactions drag-drop.

**Chemin** : `lib/isopento/screens/isopento_game_screen.dart`

**Type** : `ConsumerWidget` (Riverpod)

**États d'affichage** :
```
2 modes:
- Mode Jeu (plateau vide) : AppBar vide, aucune action
- Mode Transformation : AppBar avec actions isométriques + close button
```

**Structure UI** :

*Portrait Layout* (Column) :
```
┌─────────────────────┐
│   IsopentoBoard     │  ← Plateau (flex: 3)
│   (3×5, 4×5, 5×5)  │
├─────────────────────┤
│  IsopentoPieceSlider│  ← Pièces disponibles (h: 140)
│  (horizontal)       │
└─────────────────────┘
```

*Landscape Layout* (Row) :
```
┌────────────────────┬─────┬──────────┐
│                    │  A  │          │
│ IsopentoBoard      │  C  │ Pièces   │
│                    │  T  │ (vertical)
│                    │     │          │
└────────────────────┴─────┴──────────┘
                      ↑
                    Actions 56px
```

**AppBar Dynamique** :
- **Inactif** (pas de sélection) : aucun bouton, pas de titre
- **Actif** (pièce sélectionnée) :
    - Leading: Croix rouge (close) pour annuler sélection
    - Actions: 4 isométries + supprimer (si pièce placée)

**Actions isométriques** :
1. `applyIsometryRotation()` → rotation 90° CCW
2. `applyIsometryRotationCW()` → rotation 90° CW
3. `applyIsometrySymmetryH()` / `applyIsometrySymmetryV()` → symétries
    - **Important** : En paysage, H ↔ V sont inversées (écran tourné -90°)
    - Code : `if (isLandscape) { appeler_inverse() }`

**Interactions** :
- Tap pièce slider → sélection + preview
- Drag sur plateau → placement avec validation
- Drag pièce placée vers slider → **retrait du plateau** (DragTarget)
- Actions : rotations/symétries
- Close button : annule sélection, vide preview

**Haptic Feedback** :
- Selection click : rotations/symétries
- Medium impact : placements, suppressions, reset

**DragTarget sur Slider** :
- Accepte : Pento (pièces placées)
- Affiche : bordure rouge + icône poubelle au survol
- Effet : retire la pièce via `removePlacedPiece()`

**Widgets Enfants** :
- `IsopentoBoard(isLandscape: bool)` → affichage plateau + pièces placées
- `IsopentoPieceSlider(isLandscape: bool)` → sélection pièces disponibles

**Imports Clés** :
- `isopento_provider.dart` : IsopentoState, IsopentoNotifier
- `isopento_board.dart`, `isopento_piece_slider.dart` : widgets spécialisés
- `game_icons_config.dart` : configuration icônes (taille, couleur, tooltip)
- `settings_provider.dart` : préférences utilisateur

**Responsivité** :
```dart
final isLandscape = MediaQuery.of(context).size.width > height;
// ou via LayoutBuilder constraints.maxWidth > constraints.maxHeight
```

**États gérés via Provider** :
- `state.selectedPiece` / `state.selectedPlacedPiece` → détermine mode
- `state.previewX`, `state.previewY`, `state.isPreviewValid` → aperçu placement
- `state.placedPieces` → affichage plateau
- `state.puzzle?.size.numPieces` → compteur

**Dépendances** :
- `flutter_riverpod` : ConsumerWidget, WidgetRef
- `isopento_provider.dart` : isopentoProvider
- `isopento_board.dart`, `isopento_piece_slider.dart` : widgets spécialisés
- `game_icons_config.dart` : GameIcons enum
- `settings_provider.dart` : paramètres de jeu

---

### isopento_menu_screen.dart
**Rôle** : Menu de sélection difficulté/taille. Point d'entrée principal pour démarrer un puzzle.

**Chemin** : `lib/isopento/screens/isopento_menu_screen.dart`

**Type** : `ConsumerStatefulWidget` (Riverpod + état local)

**État local** :
- `_selectedSize` : IsopentoSize (3×5, 4×5, 5×5)
- `_selectedDifficulty` : IsopentoDifficulty (easy, random, hard)

**Structure UI** (Column) :
```
┌──────────────────────────┐
│  AppBar: "Isopento"      │
├──────────────────────────┤
│ Titre                    │
│ Description              │
├──────────────────────────┤
│ Sélection Taille         │ ← 3 boutons (3×5 | 4×5 | 5×5)
│                          │
│ Sélection Difficulté     │ ← 3 boutons (Facile | Aléatoire | Difficile)
│                          │
│ [Jouer]                  │ ← Bouton d'action
└──────────────────────────┘
```

**Widgets Builders** :

**1. `_buildSizeSelector()`**
- Row de 3 boutons (GestureDetector)
- Affiche pour chaque taille :
    - Label (3×5, 4×5, 5×5)
    - Nombre de pièces (3, 4, 5)
    - Nombre de configs disponibles (via stats)
- Style : couleur primaire si sélectionné, gris sinon
- Sélection : setState → UI update

**2. `_buildDifficultySelector()`**
- Row de 3 boutons (appels à _buildDifficultyButton)
- Espaces (SizedBox 8px) entre boutons
- Difficultés : Easy (vert), Random (bleu), Hard (orange)

**3. `_buildDifficultyButton(difficulty, label, icon, color)`**
- Container avec GestureDetector
- Affiche : icône + label
- Style : couleur spécifique si sélectionné, gris sinon
- Icônes : 😊 (facile), 🔀 (aléatoire), 🔥 (difficile)

**Action de lancement** :

```dart
void _startGame() {
  // 1. Appelle provider pour générer puzzle
  ref.read(isopentoProvider.notifier).startPuzzle(
    _selectedSize,
    difficulty: _selectedDifficulty,
  );
  
  // 2. Navigation vers game screen
  Navigator.push(...IsopentoGameScreen());
}
```

**Étapes déclenchées par _startGame()** :
1. Provider.startPuzzle() :
    - Génère puzzle aléatoire (via IsopentoGenerator)
    - Crée liste de pièces à partir du bitmask
    - Résout le puzzle (via IsopentoSolver)
    - Crée solutionPlateau avec placement solution
    - Initialise état vierge pour le joueur
2. Navigation vers IsopentoGameScreen()

**Dépendances** :
- `flutter_riverpod` : ConsumerStatefulWidget, WidgetRef
- `isopento_generator.dart` : IsopentoSize, IsopentoGenerator (pour stats)
- `isopento_provider.dart` : isopentoProvider, IsopentoDifficulty
- `isopento_game_screen.dart` : navigation vers jeu

**Responsivité** :
- SafeArea + padding 24px
- Row pour tailles (3 colonnes équales via Expanded)
- Row pour difficultés (3 colonnes équales via Expanded)
- Adaptatif : fonctionne en portrait et paysage (pas de LayoutBuilder)

**Statistiques** :
- Utilise `IsopentoGenerator().getStats(size)` pour afficher le nombre de configurations disponibles
- Affichage : `${stats.configCount} configs` sous chaque taille

---

### isopento_piece_slider.dart
**Rôle** : Widget slider vertical/horizontal pour sélectionner et dragger les pièces disponibles.

**Chemin** : `lib/isopento/widgets/isopento_piece_slider.dart`

**Type** : `ConsumerWidget` (Riverpod)

**Propriétés** :
- `isLandscape` : bool → détermine orientation (vertical vs horizontal)

**Structure** :
- ListView.builder avec scrollDirection (vertical si landscape, horizontal sinon)
- Padding adaptatif selon orientation
- Chaque pièce enveloppée dans DraggablePieceWidget

**Items du slider** :
Pour chaque pièce disponible (`state.availablePieces`) :
1. Container avec bordure/fond (différentes si sélectionnée)
2. DraggablePieceWidget :
    - Propriétés : piece, positionIndex, isSelected, selectedPositionIndex
    - Callbacks : onSelect(), onCycle(), onCancel()
3. PieceRenderer (affichage graphique) :
    - Propriété : displayPositionIndex
    - **Important** : En paysage, rotation visuelle -90° = (positionIndex + 3) % numPositions

**Interactions** :
- **Tap simple** : `selectPiece()` → sélection + preview
- **Cycle** : `cycleToNextOrientation()` → navigue orientations
- **Cancel** : `cancelSelection()` → désélection
- **Drag** : via DraggablePieceWidget → commence drag sur plateau

**Styling** :
- Sélectionnée : border ambre (3px), shadow (noir 20% opacity)
- Non-sélectionnée : transparent, aucun shadow
- Padding horizontal : 6px (spacing entre pièces)
- Container padding : 10px

**Haptic Feedback** :
- Selection click : tap, cycle
- Light impact : cancel
- Controllé via `settings.game.enableHaptics`

**Rotation affichage paysage** :
```dart
displayPositionIndex = isLandscape ? (positionIndex + 3) % piece.numPositions : positionIndex;
```
Raison : slider vertical affiché -90°, donc rotations visuelles sont décalées de +3

**Dépendances** :
- `DraggablePieceWidget` : widget réutilisable pour drag
- `PieceRenderer` : affichage graphique des pièces
- `isopento_provider.dart` : state + notifier
- `settings_provider.dart` : couleurs, haptics

**Notes** :
- Le drag fonctionnel grâce à DraggablePieceWidget qui expose Draggable<Pento>
- Slider accepte scroll illimité (ListView)
- Responsive : orientation automatique selon isLandscape

---

### isopento_board.dart
**Rôle** : Affichage du plateau de jeu avec solution, pièces joueur, interactions drag-drop, preview, et détection victoire.

**Chemin** : `lib/isopento/widgets/isopento_board.dart`

**Type** : `ConsumerWidget` (Riverpod)

**Propriétés** :
- `isLandscape` : bool → détermine orientation du plateau

**Architecture** :

**1. LayoutBuilder**
- Calcule taille des cellules pour adapter au viewport
- Formule : `cellSize = (maxWidth / visualCols).clamp(0, maxHeight / visualRows)`
- Centre le plateau : calcul offsetX, offsetY

**2. DragTarget<Pento> (englobant)**
- `onWillAcceptWithDetails()` → accepte tout Pento
- `onMove()` → update preview (updatePreview)
- `onLeave()` → efface preview (clearPreview)
- `onAcceptWithDetails()` → placement + validation (tryPlacePiece)
- Détecte victoire après placement : `state.isComplete` → `_showVictoryDialog()`

**3. GridView.builder**
- Grille affichée : `visualCols × visualRows`
- Orientation : logique (plateau 3×5, 4×5, 5×5) vs affichée (rotate -90° en paysage)
- Conversion :
  ```
  Portrait: logicalX = visualX, logicalY = visualY
  Paysage:  logicalX = (visualRows-1) - visualY, logicalY = visualX
  ```

**4. _buildCell() - Logique affichage cellule**

Layers (du bas vers le haut) :

a) **Solution en arrière-plan** (opacité 0.25) :
- `solutionValue = state.solutionPlateau.getCell(logicalX, logicalY)`
- Couleur semi-transparent pour hint visuel
- Permet au joueur de voir la solution

b) **Pièce joueur en opaque** (surcharge solution) :
- `placedValue = state.plateau.getCell(logicalX, logicalY)`
- Couleur opaque complète (1.0)
- Masque la solution pour les cellules remplies

c) **Pièce placée sélectionnée** (détection) :
- Boucle sur `state.selectedPlacedPiece.piece.positions[positionIndex]`
- Normalise via `_getMinOffset()`
- Détecte "mastercase" (cellule de référence) → bordure rouge 4px
- Couleur : couleur de la pièce (opaque)

d) **Preview (pièce slider en drag)** :
- Boucle sur `state.selectedPiece.positions[state.selectedPositionIndex]`
- Normalise et calcule position relative à previewX, previewY
- Couleur :
    - Valid + snapped : couleur pièce 0.6 opacité + bordure cyan + glow cyan
    - Valid + exact : couleur pièce 0.4 opacité + bordure verte
    - Invalid : rouge 0.3 opacité + bordure rouge
- Texte : ID pièce (blanc pour valid, rouge pour invalid)

e) **Bordures** (ordre de priorité) :
- Mastercase (sélection) → rouge 4px
- Preview valid (snapped) → cyan 3px + glow
- Preview valid (exact) → vert 3px
- Preview invalid → rouge 3px
- Sélectionné (placé) → ambre 3px
- Normal → PieceBorderCalculator (bordures fusionnées entre pièces)

**5. Interactions sur cellules**

- **Pièce placée sélectionnée** :
    - Enveloppée dans Draggable<Pento>
    - feedback : PieceRenderer en drag
    - GestureDetector pour tap/double-tap :
        - Tap : `selectPlacedPiece()` → change mastercase
        - Double-tap : `applyIsometryRotation()` → rotation rapide

- **Pièce placée non-sélectionnée** :
    - Tap : `selectPlacedPiece()` → sélection

- **Case vide avec pièce slider sélectionnée** :
    - Tap : `cancelSelection()` → annule drag

**6. Victory Dialog**

Affiché après placement valide si `state.isComplete`:

- Dialogue bottom-center
- Calcul score isométries :
  ```
  totalMinimal = somme(calculateMinimalIsometries pour chaque pièce)
  totalPlayer = somme(placed.isometriesUsed)
  note = (totalPlayer == 0) ? 20.0 : (totalMinimal / totalPlayer) * 20
  ```
- Affiche : "Isométries: X.X/20"
- Boutons : Rejouer (reset), Menu (pop 2x)

**Helpers** :

- `_getMinOffset(List<int> position)` → (minX, minY) pour normalisation pentomino 5×5

**Haptic Feedback** :
- Success placement : mediumImpact
- Failed placement : heavyImpact

**Dépendances** :
- `PieceRenderer` : affichage graphique
- `PieceBorderCalculator` : bordures fusionnées
- `isopento_provider.dart` : state + notifier
- `settings_provider.dart` : couleurs, getPieceColor()

**Notes clés** :
- Solution affichée en semi-transparent permet "hint mode"
- Snap avec glow cyan rend la magnétisation visuelle
- Conversion logique↔visuelle gère rotation -90° du plateau en paysage
- Victory check : toutes les pièces placées + plateau rempli
- Score isométries : compare optimal BFS vs. isométries réelles du joueur

---

## Configuration Isopento (NEW)

**Fichier** : `lib/isopento/isopento_config.dart`
**Modified** : 2512092200

Configuration UI centralisée pour tuning tailles icônes et espacements.

### Paramètres disponibles

```dart
// Icônes isométries (AppBar)
static const double isometryIconSize = 56.0;
static const double isometryIconPadding = 8.0;

// Interactions drag
static const double deleteIconSize = 32.0;
static const double deleteCircleSize = 56.0;

// Fermeture
static const double closeIconSize = 56.0;

// Layouts
static const double landscapeActionsWidth = 72.0;
static const double landscapeSliderWidth = 120.0;
static const double portraitSliderHeight = 140.0;
static const double sliderPadding = 12.0;
```

### Utilisation

```dart
import '../isopento_config.dart';

// Dans game_screen
final config = isopentoConfig;

Icon(GameIcons.isometryRotation.icon, size: config.isometryIconSize),
Container(width: config.landscapeActionsWidth, ...),
```

Voir **ISOPENTO_CONFIG_GUIDE.md** pour guide complet.

---

### Modules terminés
✅ **Core** : Data, Solver, Generator, Provider (1005 lignes)
✅ **UI** : GameScreen, MenuScreen (576 lignes)
✅ **Widgets** : Board (528 lignes), PieceSlider (124 lignes)

**Total** : ~2300 lignes de code production

### Caractéristiques clés implémentées

**Résolution & Calcul** :
- ✅ Backtracking complet avec heuristique isolated regions
- ✅ Comptage de toutes les solutions
- ✅ Calcul minimal isométries via BFS
- ✅ Validation placement en temps réel

**UI/UX** :
- ✅ Layout responsive portrait/paysage
- ✅ Drag-drop pièces slider → plateau
- ✅ Drag-drop pièces placées → slider (retrait)
- ✅ Preview avec validation (vert/rouge) + snap cyan
- ✅ Sélection pièces avec 4 isométries (rotations + symétries)
- ✅ Affichage solution semi-transparent (hint mode)
- ✅ Victory dialog avec score isométries /20

**Isométries** :
- ✅ Rotation 90° CCW/CW
- ✅ Symétrie horizontale/verticale
- ✅ Inversion H↔V en mode paysage
- ✅ Shape recognition pour validation
- ✅ Comptage minimal pour score

**Données** :
- ✅ 78 configurations pré-calculées (3×5 à 5×5)
- ✅ Bitmask 12 bits pour encodage pièces
- ✅ Pondération facile/hard par nombre de solutions
- ✅ Statistiques par taille de plateau

---

## Points d'attention / Notes d'architecture

### Rotation paysage (-90°)
- **Visuellement** : board tourne, slider tourne, actions isométriques inversent H↔V
- **Calcul** : conversion logicalX/Y ↔ visualX/Y via (visualRows - 1) - visualY
- **Orientations** : displayPositionIndex = (positionIndex + 3) % numPositions

### Normalisation pentomino 5×5
Toutes les pièces encoder en grille 5×5 interne (cellules 1-25).
Conversion locale → absolue via calcul du min offset :
```dart
minX = min(x de tous les cellNum - 1) % 5
minY = min(y de tous les cellNum - 1) ~/ 5
absX = minX + offsetX
absY = minY + offsetY
```

### Mastercase (point d'ancrage)
Première cellule normalisée d'une pièce. Permet transformations isométriques autour d'un point fixe.
Sélectionnable en plateau : bordure rouge 4px.

### Snap "magnétique"
Preview avec couleur cyan + bordure cyan + glow : indique que snap est actif.
Différencie placement exact (vert) de placement snappé (cyan).

### Solution semi-transparent
Layer 0.25 opacité montre solution. Couche joueur (opaque) surcharge.
Permet mode "hint" sans gâcher le plaisir.

### Score isométries /20
Formula : score = (minimalIsometries / playerIsometries) * 20
- Si 0 isométries jouées → score = 20 (parfait)
- Si isométries jouées > optimal → score baisse
- Encourage efficacité géométrique

---

## Dépendances externes (réutilisées de Pentapol)

### Widgets partagés
- `DraggablePieceWidget` → gestion drag/tap pièces
- `PieceRenderer` → dessin graphique pièces
- `PieceBorderCalculator` → bordures intelligentes

### Services
- `isometry_transforms.dart` → flipH, flipV, rotations
- `shape_recognizer.dart` → reconnaissance formes

### Modèles
- `Pento` → pentomino avec orientations
- `Plateau` → grille générique
- `Point` → coordonnées
- `GameIcons` → config icônes

### Providers
- `settingsProvider` → couleurs, haptics, durées
- `pentominos` → liste statique des 12 pièces

---

## Flux de session utilisateur

```
IsopentoMenuScreen
  │ (sélection taille + difficulté)
  ├─ IsopentoGenerator.generate(size, difficulty)
  ├─ IsopentoSolver.findSolution() → solutionPlateau
  │
  ↓ startPuzzle() → initialise provider
  │
IsopentoGameScreen
  │
  ├─ Affiche plateau vide + slider pièces disponibles
  ├─ SelectPiece(pièce) → preview
  ├─ Drag sur plateau → updatePreview() → validation
  ├─ Drop → tryPlacePiece() → plateau.setCell()
  ├─ Isométries (rotations/symétries) → calculateMinimalIsometries()
  │
  ├─ (repeat: drag, place, transform)
  │
  └─ Tous les pièces placées?
     ├─ state.isComplete = true
     └─ showVictoryDialog()
        ├─ Affiche score isométries /20
        ├─ Bouton Rejouer → reset()
        └─ Bouton Menu → pop(2x)
```

---

## Checklist pour intégration finale

- [ ] Vérifier imports (pentapol package paths)
- [ ] Tester drag-drop bidirectionnel (slider ↔ plateau)
- [ ] Tester rotation paysage (H↔V inversions, preview snap)
- [ ] Tester victoire + score isométries
- [ ] Vérifier couleurs (solution 0.25, preview 0.4/0.6, joueur opaque)
- [ ] Tester haptic feedback (settings.game.enableHaptics)
- [ ] Vérifier responsive (portrait 3:1 plateau:slider, paysage plateau:actions:slider)
- [ ] Timeout solver (5 secondes pour find first solution)
- [ ] Menu : afficher stats configs (totalSolutions, avgSolutions)
- [ ] Diag : vérifier aucune dépendance vers pentomino_game (mode 6×10)

---

## Pour aller plus loin

**Améliorations possibles** :
- Mode "training" avec hints progressifs
- Leaderboard local (scores isométries)
- Replay avec animation solution
- Tutoriel interactif des 4 isométries
- Mode "speed puzzle" avec chronomètre
- Export solutions en format texte

**Optimisations** :
- Cache BFS minimal isometries (par piece)
- Parallel counting si > 1000 solutions
- WebGL rendering pour très gros plateaux

---