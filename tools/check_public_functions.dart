#!/usr/bin/env dart

// tools/check_public_functions.dart
// Extrait les fonctions publiques de chaque fichier .dart
// (Fonctions qui ne commencent pas par _)
// Génère un CSV: tools/csv/pentapol_functions.csv
// Format: dart_id,function_name

import 'dart:io';

const String libPath = 'lib';
const String csvPath = 'tools/csv/pentapol_functions.csv';

// ANSI colors
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String red = '\x1B[31m';
const String bold = '\x1B[1m';
const String reset = '\x1B[0m';

class PublicFunctionsExtractor {
  final Map<String, List<String>> functionsByFile = {};
  int totalFunctions = 0;

  Future<void> run() async {
    printf('${bold}=== Extraction des fonctions publiques ===${reset}\n\n');

    final libDir = Directory(libPath);
    if (!libDir.existsSync()) {
      printf('${red}✗ Répertoire lib/ non trouvé${reset}\n');
      exit(1);
    }

    printf('${yellow}Scanning des fichiers .dart...${reset}\n');

    // Scanner tous les fichiers .dart
    final dartFiles = libDir
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    for (final dartFile in dartFiles) {
      await extractFunctionsFromFile(dartFile);
    }

    printf('${green}✓ ${functionsByFile.length} fichiers traités${reset}\n');
    printf('${green}✓ ${totalFunctions} fonctions publiques trouvées${reset}\n\n');

    // Afficher résumé
    _printSummary();

    // Exporter CSV
    await _exportCsv();
  }

  Future<void> extractFunctionsFromFile(File file) async {
    final content = await file.readAsString();
    final lines = content.split('\n');

    final functions = <String>{};

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Sauter les commentaires et lignes vides
      if (line.startsWith('//') || line.isEmpty) continue;

      // Patterns pour fonctions publiques
      // Exclure les lignes privées (commençant par _)

      // Pattern 1: Fonctions standards - returnType functionName(
      final functionPattern = RegExp(
        r'^\s*(static\s+)?(async\s+)?(\w+(<[^>]+>)?)\s+([a-zA-Z][a-zA-Z0-9_]*)\s*\(',
      );

      // Pattern 2: Getters/Setters - returnType get/set functionName
      final getterSetterPattern = RegExp(
        r'^\s*(static\s+)?(async\s+)?(get|set)\s+([a-zA-Z][a-zA-Z0-9_]*)',
      );

      // Pattern 3: Constructors nommés
      final constructorPattern = RegExp(
        r'^\s*\w+\.([a-zA-Z][a-zA-Z0-9_]*)\s*\(',
      );

      // Chercher pattern fonction
      final funcMatch = functionPattern.firstMatch(line);
      if (funcMatch != null) {
        final funcName = funcMatch.group(5);
        if (funcName != null && !funcName.startsWith('_')) {
          functions.add(funcName);
        }
      }

      // Chercher pattern getter/setter
      final getterMatch = getterSetterPattern.firstMatch(line);
      if (getterMatch != null) {
        final funcName = getterMatch.group(4);
        if (funcName != null && !funcName.startsWith('_')) {
          functions.add(funcName);
        }
      }

      // Chercher pattern constructeur nommé
      final constructorMatch = constructorPattern.firstMatch(line);
      if (constructorMatch != null) {
        final funcName = constructorMatch.group(1);
        if (funcName != null && !funcName.startsWith('_')) {
          functions.add('${funcName}()'); // Constructor
        }
      }
    }

    if (functions.isNotEmpty) {
      final fullPath = file.path;
      final relativePath = fullPath.replaceFirst('lib/', '');
      functionsByFile[relativePath] = functions.toList()..sort();
      totalFunctions += functions.length;
    }
  }

  void _printSummary() {
    printf('${bold}=== Résumé des fonctions par fichier ===${reset}\n\n');

    // Trier par nombre de fonctions (descending)
    final sorted = functionsByFile.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    // Afficher top 10
    int count = 0;
    for (final entry in sorted) {
      if (count >= 10) break;
      final filePath = entry.key;
      final functions = entry.value;
      printf('${yellow}$filePath${reset} (${functions.length} fonctions)\n');
      for (final func in functions.take(5)) {
        printf('  • $func\n');
      }
      if (functions.length > 5) {
        printf('  • ... +${functions.length - 5} autres\n');
      }
      printf('\n');
      count++;
    }

    printf('${bold}=== Total ===${reset}\n');
    printf('Fichiers avec fonctions publiques: ${bold}${functionsByFile.length}${reset}\n');
    printf('Fonctions publiques totales: ${bold}$totalFunctions${reset}\n');
    printf('Moyenne par fichier: ${bold}${(totalFunctions / functionsByFile.length).toStringAsFixed(1)}${reset}\n\n');
  }

  Future<void> _exportCsv() async {
    final csvDir = Directory('tools/csv');
    if (!csvDir.existsSync()) {
      csvDir.createSync(recursive: true);
    }

    final csvFile = File(csvPath);
    final buffer = StringBuffer();

    // Header
    buffer.writeln('relative_path,function_name');

    // Données
    for (final entry in functionsByFile.entries) {
      final filePath = entry.key;
      for (final funcName in entry.value) {
        buffer.writeln('"$filePath","$funcName"');
      }
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
    final extractor = PublicFunctionsExtractor();
    await extractor.run();
  } catch (e) {
    printf('${red}✗ Erreur: $e${reset}\n');
    exit(1);
  }
}