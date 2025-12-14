# Pentapol SQL - Documentation

## Vue d'ensemble

**Pentapol SQL** est un système complet d'analyse d'impact du code Pentapol basé sur une base de données SQLite. Il capture l'état du code (fichiers, tailles, dates), les relations entre fichiers (imports), l'exposition des fonctions publiques et identifie les fichiers orphelins/feuilles pour permettre de mesurer l'impact des modifications.

**Objectif principal** : Tracker, analyser et nettoyer le codebase Flutter/Dart de Pentapol.

---

## Architecture

### Structure répertoires

```
pentapol/
├── lib/                           # Code source
├── tools/
│   ├── db/
│   │   ├── schema.sql            # Schéma SQL (DROP/CREATE tables)
│   │   └── pentapol.db           # Base de données SQLite (créée automatiquement)
│   ├── csv/
│   │   ├── pentapol_dart_files.csv       # CSV généré (fichiers .dart)
│   │   ├── pentapol_imports.csv          # CSV généré (imports)
│   │   ├── pentapol_orphan_files.csv     # CSV généré (fichiers orphelins)
│   │   ├── pentapol_end_files.csv        # CSV généré (fichiers sans dépendances)
│   │   └── pentapol_functions.csv        # CSV généré (fonctions publiques)
│   ├── sync_dartfiles.sh         # 🔴 Script principal (lance TOUT)
│   ├── scan_dart_files.dart      # Scanner les fichiers .dart
│   ├── extract_imports.dart      # Extraire les imports
│   ├── check_orphan_files.dart   # Identifier fichiers orphelins
│   ├── check_end_files.dart      # Identifier fichiers sans dépendances
│   ├── check_public_functions.dart # Extraire fonctions publiques
│   └── [autres scripts...]
```

---

## Fichiers clés

### 1. `schema.sql`
Définit la structure complète de la base de données.

**Tables créées :**

#### `scans`
Métadonnées du scan courant.

```sql
scan_id (PK)         -- ID unique auto-incrémenté
scan_date           -- YYMMDD (quand?)
scan_time           -- HHMMSS (à quelle heure?)
total_files         -- Nombre de fichiers .dart
total_size_bytes    -- Taille totale en bytes
notes               -- Commentaires optionnels
```

#### `dartfiles`
Tous les fichiers .dart du projet.

```sql
dart_id (PK)        -- ID unique auto-incrémenté
filename            -- Ex: game.dart
first_dir           -- Ex: classical, isopento, common
relative_path       -- Ex: classical/models/game.dart
size_bytes          -- Taille en bytes
mod_date            -- YYMMDD (dernière modification)
mod_time            -- HHMMSS (dernière modification)
```

#### `imports`
Chaque import = 1 record. Si un fichier a 5 imports → 5 records.

```sql
import_id (PK)      -- ID unique auto-incrémenté
dart_id (FK)        -- Référence à dartfiles.dart_id
import_path         -- Ex: package:pentapol/common/game.dart
```

#### `orphanfiles`
Fichiers qui **ne sont importés par personne** (non utilisés).

```sql
dart_id (PK, FK)    -- Référence à dartfiles.dart_id
relative_path       -- Chemin du fichier
first_dir           -- Premier répertoire
filename            -- Nom du fichier
```

#### `endfiles`
Fichiers qui **n'importent aucun dart du package** (feuilles de l'arbre).

```sql
dart_id (PK, FK)    -- Référence à dartfiles.dart_id
relative_path       -- Chemin du fichier
first_dir           -- Premier répertoire
filename            -- Nom du fichier
```

#### `functions`
Fonctions publiques de chaque fichier.

```sql
function_id (PK)    -- ID unique auto-incrémenté
dart_id (FK)        -- Référence à dartfiles.dart_id
function_name       -- Nom de la fonction publique
```

#### `violations` (futur)
Violations détectées (isolation, imports relatifs, etc.)

```sql
violation_id (PK)
relative_path       -- Référence à dartfiles.relative_path
violation_type      -- Ex: isolation, relative_import
module_from         -- Module qui importe
module_to           -- Module importé
import_path         -- Chemin de l'import
line_number         -- Numéro de ligne
severity            -- error, warning
```

---

## Workflow complet

### ✅ Étape 1: Scanner les fichiers
**Script** : `scan_dart_files.dart`
**Résultat** : CSV `pentapol_dart_files.csv`

### ✅ Étape 2: Initialiser la DB
**Script** : `schema.sql`
**Résultat** : Tables recréées

### ✅ Étape 3: Importer les dartfiles
**Résultat** : Table `dartfiles` remplie

### ✅ Étape 4: Extraire les imports
**Script** : `extract_imports.dart`
**Résultat** : CSV `pentapol_imports.csv`

### ✅ Étape 5: Importer les imports
**Résultat** : Table `imports` remplie

### ✅ Étape 6: Identifier les orphelins
**Script** : `check_orphan_files.dart`
**Résultat** : CSV `pentapol_orphan_files.csv`

### ✅ Étape 7: Importer les orphelins
**Résultat** : Table `orphanfiles` remplie

### ✅ Étape 8: Identifier les endfiles
**Script** : `check_end_files.dart`
**Résultat** : CSV `pentapol_end_files.csv`

### ✅ Étape 9: Importer les endfiles
**Résultat** : Table `endfiles` remplie

### ✅ Étape 10: Extraire les fonctions publiques
**Script** : `check_public_functions.dart`
**Résultat** : CSV `pentapol_functions.csv`

### ✅ Étape 11: Importer les fonctions
**Résultat** : Table `functions` remplie

---

## 🔴 Lancer TOUT automatiquement

**C'est le plus simple** :

```bash
chmod +x tools/sync_dartfiles.sh
./tools/sync_dartfiles.sh
```

Ce script lance les 11 étapes dans l'ordre et affiche un résumé :

```
=== Sync DartFiles & Imports ===

1. Génération du CSV dartfiles...
✓ CSV généré: tools/csv/pentapol_dart_files.csv

2. Recréation des tables...
✓ Tables recréées

3. Import du CSV dartfiles...
✓ Import dartfiles: 100 fichiers

4. Extraction des imports...
✓ CSV imports généré

5. Import du CSV imports...
✓ Import imports: 342 imports

6. Vérification des fichiers orphelins...
✓ 3 fichier(s) orphelin(s) trouvé(s)

7. Import du CSV orphanfiles...
✓ Import orphanfiles: 3 fichier(s)

8. Vérification des fichiers sans dépendances...
✓ 15 fichier(s) sans dépendances trouvé(s)

9. Import du CSV endfiles...
✓ Import endfiles: 15 fichier(s)

10. Extraction des fonctions publiques...
✓ 847 fonctions publiques trouvées

11. Import des fonctions publiques...
✓ Import functions: 847 fonction(s)

=== Succès ===
DB: tools/db/pentapol.db
Fichiers: 100
Imports: 342
Fichiers orphelins: 3
Fichiers sans dépendances: 15
Fonctions publiques: 847
```

---

## Exemples de requêtes SQL

Ouvre `tools/db/pentapol.db` dans SQL Studio et essaie :

### 1. Tous les fichiers
```sql
SELECT dart_id, filename, first_dir, relative_path, size_bytes 
FROM dartfiles 
ORDER BY first_dir, filename;
```

### 2. Fichiers orphelins (non importés)
```sql
SELECT relative_path, first_dir, filename
FROM orphanfiles
ORDER BY first_dir, relative_path;
```

### 3. Fichiers sans dépendances internes (feuilles)
```sql
SELECT relative_path, first_dir, filename
FROM endfiles
ORDER BY first_dir, relative_path;
```

### 4. Fonctions d'un fichier spécifique
```sql
SELECT f.function_name
FROM functions f
JOIN dartfiles df ON f.dart_id = df.dart_id
WHERE df.relative_path = 'classical/game.dart'
ORDER BY f.function_name;
```

### 5. Fichiers avec le plus de fonctions
```sql
SELECT df.relative_path, COUNT(*) as function_count
FROM functions f
JOIN dartfiles df ON f.dart_id = df.dart_id
GROUP BY f.dart_id
ORDER BY function_count DESC
LIMIT 10;
```

### 6. Fichiers par répertoire
```sql
SELECT first_dir, COUNT(*) as count, SUM(size_bytes) as total_size
FROM dartfiles
GROUP BY first_dir
ORDER BY total_size DESC;
```

### 7. Imports d'un fichier spécifique
```sql
SELECT df.filename, i.import_path
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
WHERE df.relative_path = 'classical/game.dart';
```

### 8. Qui importe un fichier spécifique
```sql
SELECT DISTINCT df.relative_path, df.first_dir
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
WHERE i.import_path LIKE '%/common/game.dart%';
```

### 9. Fichiers avec le plus d'imports
```sql
SELECT df.relative_path, COUNT(*) as import_count
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
GROUP BY df.dart_id
ORDER BY import_count DESC
LIMIT 10;
```

### 10. Dépendances entre modules
```sql
SELECT 
  df.first_dir as from_module,
  SUBSTR(i.import_path, 21, INSTR(SUBSTR(i.import_path, 21), '/') - 1) as to_module,
  COUNT(*) as count
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
WHERE i.import_path LIKE 'package:pentapol/%'
GROUP BY df.first_dir, to_module
ORDER BY count DESC;
```

### 11. API complète d'un module
```sql
SELECT df.first_dir, df.relative_path, f.function_name
FROM functions f
JOIN dartfiles df ON f.dart_id = df.dart_id
WHERE df.first_dir = 'common'
ORDER BY df.relative_path, f.function_name;
```

### 12. Fichiers orphelins par répertoire
```sql
SELECT first_dir, COUNT(*) as orphan_count
FROM orphanfiles
GROUP BY first_dir
ORDER BY orphan_count DESC;
```

---

## Points importants

### 🔄 À chaque analyse
- **Toutes les tables sont DROP et RECREATE** → données fraîches
- Les CSVs sont regénérés
- La DB est vidée et remplie

### 📊 Optimisations
- Table `imports` utilise `dart_id` (entier) au lieu de `relative_path` (string) → économise de la place
- Table `functions` normalise les noms de fonctions

### 🔗 Clés étrangères
- `imports.dart_id` → `dartfiles.dart_id`
- `orphanfiles.dart_id` → `dartfiles.dart_id`
- `endfiles.dart_id` → `dartfiles.dart_id`
- `functions.dart_id` → `dartfiles.dart_id`
- Permet les JOIN rapides

### 🎯 Cas d'usage
✓ **Nettoyer** : Identifier et supprimer les fichiers orphelins  
✓ **Analyser** : Mesurer l'impact d'une modification  
✓ **Documenter** : Exposer l'API publique de chaque module  
✓ **Dépendances** : Identifier les cycles et couplages  
✓ **Architecture** : Vérifier l'isolation des modules  
✓ **Qualité** : Trouver les fichiers critiques (beaucoup d'imports)

---

## Dépannage

### ❌ Erreur "datatype mismatch"
Le CSV a un format différent de la table. Vérifiez que le header CSV match les colonnes SQL.

### ❌ Erreur "file not found"
Assurez-vous de lancer depuis la racine du projet `pentapol/`.

### ❌ Imports manquants
Assurez-vous que les imports sont en adressage absolu (`package:pentapol/...`).

### ❌ Erreur "table already exists"
Assurez-vous que `schema.sql` a les DROP TABLE IF EXISTS pour toutes les tables.

### ❌ Fonctions manquantes
Assurez-vous que la syntaxe des fonctions match les patterns du script (pas de commentaires entre nom et parenthèses).

---



## Contact

Pour questions ou améliorations : utilise les scripts dans `tools/`