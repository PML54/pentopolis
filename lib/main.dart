// Modified: 2025-12-06 16:00 → 251226 (Avec numérotation)
// lib/main.dart
// Version adaptée avec pré-chargement des solutions BigInt + Numérotation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentapol/classical/pentomino_game_screen.dart';

import 'package:pentapol/screens/home_screen.dart';
import 'package:pentapol/services/pentapol_solutions_loader.dart';
import 'package:pentapol/services/solution_matcher.dart';

// ✨ NOUVEAUX IMPORTS (À AJOUTER)
import 'package:pentapol/common/services/puzzle_solutions_service.dart';
import 'package:pentapol/common/services/puzzle_numbering_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✨ PRÉ-CHARGEMENT des solutions en arrière-plan
  debugPrint('🔄 Pré-chargement des solutions pentomino (BigInt)...');

  Future.microtask(() async {
    final startTime = DateTime.now();
    try {
      // 1) Charger et décoder les solutions normalisées depuis le .bin
      final solutionsBigInt = await loadNormalizedSolutionsAsBigInt();

      // 2) Initialiser le matcher global avec ces solutions
      solutionMatcher.initWithBigIntSolutions(solutionsBigInt);

      // ✨ NOUVELLE: Initialiser le service de numérotation
      // (Cela charge aussi les solutions en cache pour accès rapide par puzzle #)
      final solutionsService = PuzzleSolutionsService();
      final baseSolutions = await solutionsService.getBaseSolutionCount();
      final totalPuzzles = await solutionsService.getTotalPuzzleCount();
      debugPrint('✨ Solutions de base: $baseSolutions');
      debugPrint('✨ Total avec variantes (×4): $totalPuzzles puzzles disponibles');

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final count = solutionMatcher.totalSolutions;
      debugPrint('✅ $count solutions BigInt chargées en ${duration}ms');
    } catch (e, st) {
      debugPrint('❌ Erreur lors du pré-chargement des solutions: $e');
      debugPrint('$st');
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pentapol',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomeScreen(),

      routes: {'/game': (context) => const PentominoGameScreen()},
    );
  }
}

// ============================================================================
// UTILISATION DANS LES AUTRES FICHIERS
// ============================================================================

// Quand tu veux générer un puzzle avec numéro:
//
// final puzzleNumber = 42;
// final seed = PuzzleNumberingService.numberToSeed(puzzleNumber);  // → 42
// final puzzleId = PuzzleNumberingService.formatPuzzleId(puzzleNumber);  // → "puzzle_000042"
//
// // Générer le plateau avec la seed
// final puzzle = generator.generateFromSeed(seed);
//
// // Optionnel: récupérer la solution
// final solutionsService = PuzzleSolutionsService();
// final solution = await solutionsService.getSolutionForPuzzle(puzzleNumber);