# Pentapol SQL - Documentation

## Vue d'ensemble

**Pentapol SQL** est un système d'analyse d'impact du code Pentapol basé sur une base de données SQLite. Il capture l'état du code (fichiers, tailles, dates) et les relations entre fichiers (imports) pour permettre de mesurer l'impact des modifications.

**Objectif principal** : Tracker et analyser les changements du codebase Flutter/Dart de Pentapol.

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
│   │   ├── pentapol_dart_files.csv    # CSV généré (fichiers .dart)
│   │   └── pentapol_imports.csv       # CSV généré (imports)
│   ├── sync_dartfiles.sh         # 🔴 Script principal (lance TOUT)
│   ├── scan_dart_files.dart      # Scanner les fichiers .dart
│   ├── extract_imports.dart      # Extraire les imports
│   └── [autres scripts...]
```

---

## Fichiers clés

### 1. `schema.sql`
Définit la structure de la base de données.

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

**Résultat** : Génère `tools/csv/pentapol_dart_files.csv`

```csv
filename,firstDir,relativePath,sizeBytes,modDate,modTime
"game.dart","classical","classical/models/game.dart",5120,"251210","143245"
"board.dart","common","common/game.dart",3037,"251210","083129"
```

**Commande manuelle** :
```bash
dart tools/scan_dart_files.dart
```

### ✅ Étape 2: Initialiser la DB

**Script** : `schema.sql`

**Résultat** : Tables recréées (DROP IF EXISTS)

**Commande manuelle** :
```bash
sqlite3 tools/db/pentapol.db < tools/db/schema.sql
```

### ✅ Étape 3: Importer les dartfiles

**Résultat** : Table `dartfiles` remplie avec tous les fichiers

**Commande manuelle** :
```bash
sqlite3 tools/db/pentapol.db <<EOF
CREATE TEMP TABLE temp_dartfiles (
  filename VARCHAR(255),
  first_dir VARCHAR(50),
  relative_path VARCHAR(500),
  size_bytes BIGINT,
  mod_date VARCHAR(6),
  mod_time VARCHAR(6)
);

.mode csv
.import tools/csv/pentapol_dart_files.csv temp_dartfiles

INSERT INTO dartfiles (filename, first_dir, relative_path, size_bytes, mod_date, mod_time)
SELECT filename, first_dir, relative_path, size_bytes, mod_date, mod_time
FROM temp_dartfiles;
EOF
```

### ✅ Étape 4: Extraire les imports

**Script** : `extract_imports.dart`

**Résultat** : Génère `tools/csv/pentapol_imports.csv`

```csv
relative_path,import_path
"classical/game.dart","package:pentapol/common/game.dart"
"classical/game.dart","package:pentapol/utils/helpers.dart"
"common/game.dart","package:pentapol/common/point.dart"
```

**Commande manuelle** :
```bash
dart tools/extract_imports.dart
```

### ✅ Étape 5: Importer les imports

**Résultat** : Table `imports` remplie en joignant avec `dartfiles`

**Commande manuelle** :
```bash
sqlite3 tools/db/pentapol.db <<EOF
CREATE TEMP TABLE temp_imports (
  relative_path VARCHAR(500),
  import_path VARCHAR(500)
);

.mode csv
.import tools/csv/pentapol_imports.csv temp_imports

INSERT INTO imports (dart_id, import_path)
SELECT 
  df.dart_id,
  ti.import_path
FROM temp_imports ti
JOIN dartfiles df ON ti.relative_path = df.relative_path;
EOF
```

---

## 🔴 Lancer TOUT automatiquement

**C'est le plus simple** :

```bash
chmod +x tools/sync_dartfiles.sh
./tools/sync_dartfiles.sh
```

Ce script lance les 5 étapes dans l'ordre et affiche un résumé :

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

=== Succès ===
DB: tools/db/pentapol.db
Fichiers: 100
Imports: 342
Taille: 0.75 MB
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

### 2. Fichiers par répertoire
```sql
SELECT first_dir, COUNT(*) as count, SUM(size_bytes) as total_size
FROM dartfiles
GROUP BY first_dir
ORDER BY total_size DESC;
```

### 3. Imports d'un fichier spécifique
```sql
SELECT df.filename, i.import_path
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
WHERE df.relative_path = 'classical/game.dart';
```

### 4. Fichiers avec le plus d'imports
```sql
SELECT df.relative_path, COUNT(*) as import_count
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
GROUP BY df.dart_id
ORDER BY import_count DESC
LIMIT 10;
```

### 5. Imports provenant d'un module
```sql
SELECT df.relative_path, i.import_path
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
WHERE df.first_dir = 'classical';
```

### 6. Quels fichiers importent un fichier spécifique
```sql
SELECT DISTINCT df.relative_path, df.first_dir
FROM imports i
JOIN dartfiles df ON i.dart_id = df.dart_id
WHERE i.import_path LIKE '%/common/game.dart%';
```

### 7. Dépendances entre modules
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

---

## Points importants

### 🔄 À chaque analyse
- **Toutes les tables sont DROP et RECREATE** → données fraîches
- Les CSVs sont regénérés
- La DB est vidée et remplie

### 📊 Gains d'espace
- Table `imports` utilise `dart_id` (entier) au lieu de stocker `relative_path` (string) → économise de la place
- Les imports sont normalisés

### 🔗 Clés étrangères
- `imports.dart_id` → `dartfiles.dart_id`
- Permet les JOIN rapides

### 🎯 Cas d'usage
✓ Analyser l'impact d'une modification  
✓ Identifier les dépendances circulaires  
✓ Trouver les fichiers orphelins  
✓ Mesurer le couplage entre modules  
✓ Comparer deux versions du codebase

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

---

## Prochaines étapes

1. **Historique** : Ajouter un champ `scan_id` aux tables pour comparer plusieurs scans
2. **Violations** : Remplir la table `violations` avec les résultats des autres scripts
3. **Dashboard** : Créer des vues SQL pour des analyses visuelles
4. **Alertes** : Détecter les violations de l'architecture lors du scan

---

## Contact

Pour questions ou améliorations : utilise les scripts dans `tools/`