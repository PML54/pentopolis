#!/usr/bin/env dart

// tools/check_public_functions.dart
// Extrait les fonctions publiques de chaque fichier
// Utilise config.dart pour la configuration centralisée

import 'dart:io';
import 'config.dart';

class PublicFunctionsExtractor {
  final Map<String, List<String>> functionsByFile = {};
  int totalFunctions = 0;

  Future<void> run() async {
    printf('${COLOR_BOLD}=== Extraction des fonctions publiques ===${COLOR_RESET}\n\n');

    final libDir = Directory(LIB_PATH);
    if (!libDir.existsSync()) {
      printf('${COLOR_RED}✗ Répertoire $LIB_PATH/ non trouvé${COLOR_RESET}\n');
      exit(1);
    }

    printf('${COLOR_YELLOW}Scanning des fichiers .dart...${COLOR_RESET}\n');

    final dartFiles = libDir
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    for (final dartFile in dartFiles) {
      await extractFunctionsFromFile(dartFile);
    }

    printf('${COLOR_GREEN}✓ ${functionsByFile.length} fichiers traités${COLOR_RESET}\n');
    printf('${COLOR_GREEN}✓ ${totalFunctions} fonctions publiques trouvées${COLOR_RESET}\n\n');

    _printSummary();
    await _exportCsv();
  }

  Future<void> extractFunctionsFromFile(File file) async {
    final content = await file.readAsString();
    final lines = content.split('\n');

    final functions = <String>{};

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.startsWith('//') || line.isEmpty) continue;

      final functionPattern = RegExp(
        r'^\s*(static\s+)?(async\s+)?(\w+(<[^>]+>)?)\s+([a-zA-Z][a-zA-Z0-9_]*)\s*\(',
      );

      final getterSetterPattern = RegExp(
        r'^\s*(static\s+)?(async\s+)?(get|set)\s+([a-zA-Z][a-zA-Z0-9_]*)',
      );

      final constructorPattern = RegExp(
        r'^\s*\w+\.([a-zA-Z][a-zA-Z0-9_]*)\s*\(',
      );

      final funcMatch = functionPattern.firstMatch(line);
      if (funcMatch != null) {
        final funcName = funcMatch.group(5);
        if (funcName != null && !funcName.startsWith('_')) {
          functions.add(funcName);
        }
      }

      final getterMatch = getterSetterPattern.firstMatch(line);
      if (getterMatch != null) {
        final funcName = getterMatch.group(4);
        if (funcName != null && !funcName.startsWith('_')) {
          functions.add(funcName);
        }
      }

      final constructorMatch = constructorPattern.firstMatch(line);
      if (constructorMatch != null) {
        final funcName = constructorMatch.group(1);
        if (funcName != null && !funcName.startsWith('_')) {
          functions.add('${funcName}()');
        }
      }
    }

    if (functions.isNotEmpty) {
      final relativePath = file.path.replaceFirst('$LIB_PATH/', '');
      functionsByFile[relativePath] = functions.toList()..sort();
      totalFunctions += functions.length;
    }
  }

  void _printSummary() {
    printf('${COLOR_BOLD}=== Top 10 des fichiers les plus documentés ===${COLOR_RESET}\n\n');

    final sorted = functionsByFile.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    int count = 0;
    for (final entry in sorted) {
      if (count >= 10) break;
      printf('${COLOR_YELLOW}${entry.key}${COLOR_RESET} (${entry.value.length} fonctions)\n');
      for (final func in entry.value.take(5)) {
        printf('  • $func\n');
      }
      if (entry.value.length > 5) {
        printf('  • ... +${entry.value.length - 5} autres\n');
      }
      printf('\n');
      count++;
    }

    printf('${COLOR_BOLD}=== Total ===${COLOR_RESET}\n');
    printf('Fichiers: ${COLOR_BOLD}${functionsByFile.length}${COLOR_RESET}\n');
    printf('Fonctions: ${COLOR_BOLD}$totalFunctions${COLOR_RESET}\n');
    printf('Moyenne: ${COLOR_BOLD}${(totalFunctions / functionsByFile.length).toStringAsFixed(1)}${COLOR_RESET}\n\n');
  }

  Future<void> _exportCsv() async {
    Directory(CSV_PATH).createSync(recursive: true);

    final buffer = StringBuffer();
    buffer.writeln('relative_path,function_name');

    for (final entry in functionsByFile.entries) {
      for (final funcName in entry.value) {
        buffer.writeln('"${entry.key}","$funcName"');
      }
    }

    await File(CSV_FUNCTIONS).writeAsString(buffer.toString());
    printf('${COLOR_GREEN}✓ Export CSV: ${COLOR_BOLD}$CSV_FUNCTIONS${COLOR_RESET}\n');
  }
}

void printf(String msg) => stdout.write(msg);

Future<void> main(List<String> args) async {
  try {
    await PublicFunctionsExtractor().run();
  } catch (e) {
    printf('${COLOR_RED}✗ Erreur: $e${COLOR_RESET}\n');
    exit(1);
  }
}