#!/usr/bin/env dart

// tools/check_end_files.dart
// Identifie les fichiers .dart qui n'importent AUCUN dart du package pentapol
// Ce sont les "feuilles" de l'arbre de dépendances (aucune dépendance interne)
// Génère un CSV: tools/csv/pentapol_end_files.csv

import 'dart:io';

const String libPath = 'lib';
const String dbPath = 'tools/db/pentapol.db';
const String csvPath = 'tools/csv/pentapol_end_files.csv';

// ANSI colors
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String red = '\x1B[31m';
const String bold = '\x1B[1m';
const String reset = '\x1B[0m';

class EndFilesChecker {
  final List<Map<String, String>> endFiles = [];

  Future<void> run() async {
    printf('${bold}=== Vérification des fichiers sans dépendances internes ===${reset}\n\n');

    // Vérifier que la DB existe
    if (!File(dbPath).existsSync()) {
      printf('${red}✗ Base de données non trouvée: $dbPath${reset}\n');
      exit(1);
    }

    printf('${yellow}Interrogation de la base de données...${reset}\n');

    // Lancer la requête SQL
    final result = await _querySqlite();

    if (result.isEmpty) {
      printf('${green}✓ Tous les fichiers importent au moins un dart de pentapol${reset}\n');
      exit(0);
    }

    // Parser les résultats
    for (final line in result.split('\n')) {
      if (line.trim().isEmpty) continue;

      final parts = line.split('|');
      if (parts.length < 4) continue;

      endFiles.add({
        'dart_id': parts[0].trim(),
        'relative_path': parts[1].trim(),
        'first_dir': parts[2].trim(),
        'filename': parts[3].trim(),
      });
    }

    printf('${green}✓ ${endFiles.length} fichier(s) sans dépendances internes${reset}\n\n');

    // Afficher par répertoire
    _printByDirectory();

    // Exporter CSV
    await _exportCsv();
  }

  Future<String> _querySqlite() async {
    const query = '''
SELECT 
  df.dart_id,
  df.relative_path,
  df.first_dir,
  df.filename
FROM dartfiles df
WHERE df.dart_id NOT IN (
  SELECT DISTINCT i.dart_id FROM imports i
)
  AND df.filename NOT IN ('main.dart', 'bootstrap.dart')
ORDER BY df.first_dir, df.filename;
''';

    try {
      final process = await Process.run(
        'sqlite3',
        [
          '-separator', '|',
          dbPath,
          query,
        ],
      );

      if (process.exitCode != 0) {
        printf('${red}✗ Erreur sqlite3: ${process.stderr}${reset}\n');
        exit(1);
      }

      return process.stdout as String;
    } catch (e) {
      printf('${red}✗ Erreur: $e${reset}\n');
      exit(1);
    }
  }

  void _printByDirectory() {
    printf('${bold}=== Fichiers sans dépendances internes par répertoire ===${reset}\n\n');

    final byDir = <String, List<Map<String, String>>>{};
    for (final file in endFiles) {
      final dir = file['first_dir']!;
      byDir.putIfAbsent(dir, () => []).add(file);
    }

    for (final dir in byDir.keys.toList()..sort()) {
      final files = byDir[dir]!;

      printf('${yellow}$dir${reset} (${files.length} fichiers)\n');
      for (final file in files) {
        final path = file['relative_path'];
        final dartId = file['dart_id'];
        printf('  • [$dartId] $path\n');
      }
      printf('\n');
    }

    printf('${bold}=== Total ===${reset}\n');
    printf('Fichiers sans dépendances: ${bold}${endFiles.length}${reset}\n\n');
  }

  Future<void> _exportCsv() async {
    final csvDir = Directory('tools/csv');
    if (!csvDir.existsSync()) {
      csvDir.createSync(recursive: true);
    }

    final csvFile = File(csvPath);
    final buffer = StringBuffer();

    // Header
    buffer.writeln('dart_id,relative_path,first_dir,filename');

    // Données
    for (final file in endFiles) {
      final dartId = file['dart_id']!;
      final relativePath = file['relative_path']!;
      final firstDir = file['first_dir']!;
      final filename = file['filename']!;

      buffer.writeln('$dartId,"$relativePath","$firstDir","$filename"');
    }

    await csvFile.writeAsString(buffer.toString());
    printf('${green}✓ Export CSV: ${bold}$csvPath${reset}\n');
  }
}

void printf(String msg) {
  stdout.write(msg);
}

Future<void> main(List<String> args) async {
  try {
    final checker = EndFilesChecker();
    await checker.run();
  } catch (e) {
    printf('${red}✗ Erreur: $e${reset}\n');
    exit(1);
  }
}