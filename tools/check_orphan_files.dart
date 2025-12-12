#!/usr/bin/env dart

// tools/check_orphan_files.dart
// Identifie les fichiers .dart qui ne sont importés par aucun autre fichier
// Génère un CSV: tools/csv/pentapol_orphan_files.csv

import 'dart:io';

const String libPath = 'lib';
const String dbPath = 'tools/db/pentapol.db';
const String csvPath = 'tools/csv/pentapol_orphan_files.csv';

// ANSI colors
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String red = '\x1B[31m';
const String bold = '\x1B[1m';
const String reset = '\x1B[0m';

class OrphanFilesChecker {
  final List<Map<String, String>> orphanFiles = [];

  Future<void> run() async {
    printf('${bold}=== Vérification des fichiers orphelins ===${reset}\n\n');

    // Vérifier que la DB existe
    if (!File(dbPath).existsSync()) {
      printf('${red}✗ Base de données non trouvée: $dbPath${reset}\n');
      exit(1);
    }

    printf('${yellow}Interrogation de la base de données...${reset}\n');

    // Lancer la requête SQL via sqlite3
    final result = await _querySqlite();

    if (result.isEmpty) {
      printf('${green}✓ Aucun fichier orphelin détecté${reset}\n');
      exit(0);
    }

    // Parser les résultats
    for (final line in result.split('\n')) {
      if (line.trim().isEmpty) continue;

      final parts = line.split('|');
      if (parts.length < 4) continue;

      orphanFiles.add({
        'dart_id': parts[0].trim(),
        'relative_path': parts[1].trim(),
        'first_dir': parts[2].trim(),
        'filename': parts[3].trim(),
      });
    }

    printf('${green}✓ ${orphanFiles.length} fichier(s) orphelin(s) trouvé(s)${reset}\n\n');

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
WHERE 'package:pentapol/' || df.relative_path NOT IN (
  SELECT import_path FROM imports
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
    printf('${bold}=== Fichiers orphelins par répertoire ===${reset}\n\n');

    final byDir = <String, List<Map<String, String>>>{};
    for (final file in orphanFiles) {
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
    printf('Fichiers orphelins: ${bold}${orphanFiles.length}${reset}\n\n');
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
    for (final file in orphanFiles) {
      final dartId = file['dart_id']!;
      final relativePath = file['relative_path']!;
      final firstDir = file['first_dir']!;
      final filename = file['filename']!;

      buffer.writeln('$dartId,"$relativePath","$firstDir","$filename"');
    }

    await csvFile.writeAsString(buffer.toString());
    printf('${green}✓ Export CSV: ${bold}$csvPath${reset}\n');
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

void printf(String msg) {
  stdout.write(msg);
}

Future<void> main(List<String> args) async {
  try {
    final checker = OrphanFilesChecker();
    await checker.run();
  } catch (e) {
    printf('${red}✗ Erreur: $e${reset}\n');
    exit(1);
  }
}