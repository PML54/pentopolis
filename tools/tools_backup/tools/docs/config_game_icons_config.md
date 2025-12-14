# config/game_icons_config.dart

**Module:** config

## Fonctions

### GameIconConfig

Modes de jeu
Configuration d'une icône avec ses propriétés


```dart
const GameIconConfig({
```

### isVisibleIn

Vérifie si l'icône est visible dans un mode donné


```dart
bool isVisibleIn(GameMode mode) => visibleInModes.contains(mode);
```

### getIconsForMode

Catalogue complet des icônes de l'application
Paramètres de l'application
Mode Isométries (depuis mode normal)
Retour au jeu (depuis mode isométries)
Voir les solutions possibles
Indicateur de solutions (coupe/trophée)
Rotation de pièce (en jeu normal)
Retirer une pièce du plateau
Annuler le dernier placement
Rotation 90° anti-horaire (transformation isométrique)
Rotation 90° horaire (transformation isométrique)
Symétrie horizontale
Symétrie verticale
Retirer une pièce (en mode isométries)
Retourne toutes les icônes pour un mode donné


```dart
static List<GameIconConfig> getIconsForMode(GameMode mode) {
```

### printIconsForMode

Affiche la liste des icônes dans la console (debug)


```dart
static void printIconsForMode(GameMode mode) {
```

