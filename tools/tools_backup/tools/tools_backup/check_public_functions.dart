#!/usr/bin/env dart

// tools/check_public_functions.dart
// Extrait les fonctions publiques avec leur TYPE DE RETOUR
// Utilise config.dart pour la configuration centralisée

import 'dart:io';
import 'config.dart';

class PublicFunctionsExtractor {
  final List<Map<String, String>> functions = [];
  int totalFunctions = 0;

  Future<void> run() async {
    printf('${COLOR_BOLD}=== Extraction des fonctions publiques ===${COLOR_RESET}\n\n');

    if (!File(DB_FULL_PATH).existsSync()) {
      printf('${COLOR_RED}✗ Base de données non trouvée: $DB_FULL_PATH${COLOR_RESET}\n');
      exit(1);
    }

    printf('${COLOR_YELLOW}Scanning des fichiers .dart...${COLOR_RESET}\n');

    final libDir = Directory(LIB_PATH);
    if (!libDir.existsSync()) {
      printf('${COLOR_RED}✗ Répertoire $LIB_PATH/ non trouvé${COLOR_RESET}\n');
      exit(1);
    }

    final allFiles = libDir
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    for (final file in allFiles) {
      await extractFunctionsFromFile(file);
    }

    printf('${COLOR_GREEN}✓ ${functions.length} fonction(s) trouvée(s)${COLOR_RESET}\n\n');

    _printSummary();
    await _exportCsv();
  }

  Future<void> extractFunctionsFromFile(File file) async {
    final content = await file.readAsString();
    final lines = content.split('\n');

    final relativePath = file.path.replaceFirst('$LIB_PATH/', '');

    // Regex pour capturer: [type_retour] [nom_fonction]([params])
    // Exemples:
    // - void methodName()
    // - int getValue()
    // - String getText()
    // - Future<bool> async()
    // - List<String> getList()
    // - @override
    //   Widget build(BuildContext context)
    final functionPattern = RegExp(
      r'^\s*(?:@override\s+)?'
      r'([\w<>?\s]+?)\s+'          // Type de retour: void, int, String, Future<T>, etc.
      r'(\w+)\s*\(',               // Nom de fonction + ouverture parenthèse
    );

    for (final line in lines) {
      final trimmed = line.trim();

      // Ignorer les lignes de commentaires et vides
      if (trimmed.isEmpty || trimmed.startsWith('//') || trimmed.startsWith('/*')) {
        continue;
      }

      // Ignorer les constructeurs privés et les méthodes privées
      if (trimmed.startsWith('_')) {
        continue;
      }

      final match = functionPattern.firstMatch(line);
      if (match != null) {
        final returnType = match.group(1)!.trim();
        final functionName = match.group(2)!.trim();

        // Ignorer les mots-clés du langage (class, if, for, etc.)
        if (_isKeyword(returnType)) {
          continue;
        }

        functions.add({
          'relative_path': relativePath,
          'return_type': returnType,
          'function_name': functionName,
        });

        totalFunctions++;
      }
    }
  }

  bool _isKeyword(String word) {
    const keywords = {
      'class', 'enum', 'mixin', 'interface',
      'if', 'else', 'for', 'while', 'do', 'switch', 'case',
      'try', 'catch', 'finally', 'throw',
      'return', 'break', 'continue',
      'const', 'final', 'static', 'abstract', 'override',
      'import', 'export', 'part', 'library',
    };
    return keywords.contains(word.toLowerCase());
  }

  void _printSummary() {
    printf('${COLOR_BOLD}=== Top 15 des fonctions les plus communes ===${COLOR_RESET}\n\n');

    final grouped = <String, int>{};
    for (final func in functions) {
      final key = '${func['return_type']} ${func['function_name']}';
      grouped[key] = (grouped[key] ?? 0) + 1;
    }

    final sorted = grouped.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    int count = 0;
    for (final entry in sorted) {
      if (count >= 15) break;
      printf('${COLOR_YELLOW}${entry.key}${COLOR_RESET} (${entry.value} fichiers)\n');
      count++;
    }

    printf('\n${COLOR_BOLD}=== Statistiques ===${COLOR_RESET}\n');
    printf('Fonctions trouvées: ${COLOR_BOLD}$totalFunctions${COLOR_RESET}\n');
    printf('Fonctions uniques: ${COLOR_BOLD}${grouped.length}${COLOR_RESET}\n\n');
  }

  Future<void> _exportCsv() async {
    Directory(CSV_PATH).createSync(recursive: true);

    // ✅ Filtrer et dédupliquer:
    // - Ignorer les return_type vides/nuls (faux positifs)
    // - Garder une seule ligne par (relative_path, return_type, function_name)
    final seen = <String>{};
    final deduplicatedFunctions = <Map<String, String>>[];

    int nullReturnTypes = 0;
    int duplicates = 0;

    for (final func in functions) {
      final returnType = func['return_type']?.trim() ?? '';

      // Filtrer les return_type vides/nuls
      if (returnType.isEmpty) {
        nullReturnTypes++;
        continue;
      }

      final key = '${func['relative_path']}|$returnType|${func['function_name']}';
      if (!seen.contains(key)) {
        seen.add(key);
        deduplicatedFunctions.add({
          'relative_path': func['relative_path']!,
          'return_type': returnType,
          'function_name': func['function_name']!,
        });
      } else {
        duplicates++;
      }
    }

    // Afficher les statistiques
    if (nullReturnTypes > 0) {
      printf('${COLOR_YELLOW}⚠️  $nullReturnTypes entrée(s) sans return_type (ignorées)${COLOR_RESET}\n');
    }
    if (duplicates > 0) {
      printf('${COLOR_YELLOW}⚠️  $duplicates doublon(s) supprimé(s)${COLOR_RESET}\n');
    }

    // Exporter le CSV
    final buffer = StringBuffer();
    buffer.writeln('relative_path,return_type,function_name');

    for (final func in deduplicatedFunctions) {
      buffer.writeln('"${func['relative_path']}","${func['return_type']}","${func['function_name']}"');
    }

    await File(CSV_FUNCTIONS).writeAsString(buffer.toString());
    printf('${COLOR_GREEN}✓ Export CSV: ${COLOR_BOLD}$CSV_FUNCTIONS${COLOR_RESET}\n');
    printf('${COLOR_GREEN}✓ Fonctions valides exportées: ${COLOR_BOLD}${deduplicatedFunctions.length}${COLOR_RESET}\n');
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