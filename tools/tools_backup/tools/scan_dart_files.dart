#!/usr/bin/env dart

// tools/scan_dart_files.dart
// Liste tous les fichiers .dart du projet Pentapol avec:
// - Nom du fichier
// - Premier répertoire dans lib/
// - Chemin complet à partir de lib/
// - Taille (bytes)
// - Date de dernière modification

import 'dart:io';

const String libPath = 'lib';

// ANSI colors
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String bold = '\x1B[1m';
const String reset = '\x1B[0m';

class DartFileScanner {
  final List<Map<String, dynamic>> dartFiles = [];

  Future<void> run() async {
    print('$bold=== Scan fichiers .dart Pentapol ===$reset\n');

    final libDir = Directory(libPath);
    if (!libDir.existsSync()) {
      print('Répertoire lib/ non trouvé');
      exit(1);
    }

    // Scanner tous les fichiers .dart
    final files = libDir
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));

    print('Traitement de ${files.length} fichier(s)...\n');

    for (final file in files) {
      final stat = await file.stat();

      // Extraire infos
      final fullPath = file.path;
      final filename = file.uri.pathSegments.last;
      final relativeFromLib = fullPath.replaceFirst('lib/', '');
      final firstDir = relativeFromLib.split('/').first;
      final sizeBytes = stat.size;
      final lastModified = stat.modified;

      // Scinder date et heure
      final dateStr = _formatDate(lastModified);  // YYMMDD
      final timeStr = _formatTime(lastModified);  // HHMMSS

      dartFiles.add({
        'filename': filename,
        'firstDir': firstDir,
        'relativePath': relativeFromLib,
        'sizeBytes': sizeBytes,
        'modDate': dateStr,
        'modTime': timeStr,
      });
    }

    // Trier par répertoire puis par filename
    dartFiles.sort((a, b) {
      final dirCmp = a['firstDir'].compareTo(b['firstDir']);
      if (dirCmp != 0) return dirCmp;
      return a['filename'].compareTo(b['filename']);
    });

    printConsole();
    await exportCsv();
  }

  void printConsole() {
    print('$bold=== Résumé ===$reset\n');

    // Grouper par répertoire
    final byDir = <String, List<Map<String, dynamic>>>{};
    for (final file in dartFiles) {
      final dir = file['firstDir'] as String;
      byDir.putIfAbsent(dir, () => []).add(file);
    }

    int totalSize = 0;
    for (final dir in byDir.keys.toList()..sort()) {
      final files = byDir[dir]!;
      final dirSize = files.fold<int>(0, (sum, f) => sum + (f['sizeBytes'] as int));
      totalSize += dirSize;

      print('$yellow$dir/$reset (${files.length} fichiers, ${_formatSize(dirSize)})');
      for (final file in files) {
        final path = file['relativePath'] as String;
        final size = file['sizeBytes'] as int;
        final modDate = file['modDate'] as String;
        final modTime = file['modTime'] as String;
        print('  • $path (${_formatSize(size)}) - $modDate $modTime');
      }
      print('');
    }

    print('$bold=== Total ===$reset');
    print('Fichiers: ${dartFiles.length}');
    print('Taille: ${_formatSize(totalSize)}');
  }

  Future<void> exportCsv() async {
    // Créer le répertoire tools/csv/ s'il n'existe pas
    final csvDir = Directory('tools/csv');
    if (!csvDir.existsSync()) {
      csvDir.createSync(recursive: true);
    }

    final csvFile = File('tools/csv/pentapol_dart_files.csv');
    final buffer = StringBuffer();

    // Header CSV
    buffer.writeln('filename,firstDir,relativePath,sizeBytes,modDate,modTime');

    // Données
    for (final file in dartFiles) {
      final filename = file['filename'] as String;
      final firstDir = file['firstDir'] as String;
      final relativePath = file['relativePath'] as String;
      final sizeBytes = file['sizeBytes'] as int;
      final modDate = file['modDate'] as String;
      final modTime = file['modTime'] as String;

      // Échapper les guillemets pour CSV
      buffer.writeln(
          '"$filename","$firstDir","$relativePath",$sizeBytes,"$modDate","$modTime"'
      );
    }

    await csvFile.writeAsString(buffer.toString());
    print('$green✓ Export CSV: $bold${csvFile.path}$reset');
    print('  (Prêt pour import SQL Studio)');
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String _formatDate(DateTime dt) {
    // YYMMDD
    final year = dt.year.toString().padLeft(4, '0').substring(2);
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$year$month$day';
  }

  String _formatTime(DateTime dt) {
    // HHMMSS
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    return '$hour$minute$second';
  }
}

Future<void> main(List<String> args) async {
  try {
    final scanner = DartFileScanner();
    await scanner.run();
  } catch (e) {
    print('✗ Erreur: $e');
    exit(1);
  }
}