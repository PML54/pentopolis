#!/usr/bin/env dart

// tools/extract_imports.dart
// Extrait tous les imports de chaque fichier .dart
// Génère un CSV avec: relative_path,import_path

import 'dart:io';

const String libPath = 'lib';

// ANSI colors
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String bold = '\x1B[1m';
const String reset = '\x1B[0m';

class ImportsExtractor {
  final List<Map<String, String>> imports = [];

  Future<void> run() async {
    printf('${bold}=== Extraction des imports ===${reset}\n');

    final libDir = Directory(libPath);
    if (!libDir.existsSync()) {
      printf('${yellow}Répertoire lib/ non trouvé${reset}\n');
      exit(1);
    }

    // Scanner tous les fichiers .dart
    final dartFiles = libDir
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    printf('Traitement de ${dartFiles.length} fichier(s)...\n\n');

    for (final dartFile in dartFiles) {
      await extractImportsFromFile(dartFile);
    }

    await exportCsv();
    printf('${green}✓ ${imports.length} imports extraits${reset}\n');
  }

  Future<void> extractImportsFromFile(File file) async {
    final content = await file.readAsString();
    final lines = content.split('\n');
    final fullPath = file.path;
    final relativePath = fullPath.replaceFirst('lib/', '');

    for (final line in lines) {
      // Sauter commentaires
      if (line.trim().startsWith('//') || line.trim().isEmpty) {
        continue;
      }

      // Extraire imports
      final importMatch = RegExp(
          "^\\s*import\\s+['\"]([^'\"]+)['\"]"
      ).firstMatch(line);

      if (importMatch == null) continue;

      final importPath = importMatch.group(1)!;

      // Garder seulement les imports package:pentapol/
      if (importPath.startsWith('package:pentapol/')) {
        imports.add({
          'relative_path': relativePath,
          'import_path': importPath,
        });
      }
    }
  }

  Future<void> exportCsv() async {
    // Créer le répertoire tools/csv/ s'il n'existe pas
    final csvDir = Directory('tools/csv');
    if (!csvDir.existsSync()) {
      csvDir.createSync(recursive: true);
    }

    final csvFile = File('tools/csv/pentapol_imports.csv');
    final buffer = StringBuffer();

    // Header CSV
    buffer.writeln('relative_path,import_path');

    // Données
    for (final imp in imports) {
      final relativePath = imp['relative_path']!;
      final importPath = imp['import_path']!;

      buffer.writeln('"$relativePath","$importPath"');
    }

    await csvFile.writeAsString(buffer.toString());
    printf('${green}✓ Export CSV: ${bold}${csvFile.path}${reset}\n');
  }
}

void printf(String msg) {
  stdout.write(msg);
}

Future<void> main(List<String> args) async {
  try {
    final extractor = ImportsExtractor();
    await extractor.run();
  } catch (e) {
    printf('${red}✗ Erreur: $e${reset}\n');
    exit(1);
  }
}

const String red = '\x1B[31m';