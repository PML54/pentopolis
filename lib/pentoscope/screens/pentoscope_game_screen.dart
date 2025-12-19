// lib/pentoscope/screens/pentoscope_game_screen.dart
// Modified: 2512191000
// Refactorisation UI: Actions isométrie contextuelles (slider vs plateau)
// CHANGEMENTS: (1) Extraction Widget _buildIsometryActionsBar() lignes 67-110, (2) Portrait: Actions au-dessus slider si pièce sélectionnée (lignes 280-310), (3) Landscape: Actions verticales contextuelles (lignes 312-365)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pentapol/common/pentominos.dart';
import 'package:pentapol/providers/settings_provider.dart';
import 'package:pentapol/config/game_icons_config.dart';
import 'package:pentapol/pentoscope/pentoscope_provider.dart';
import 'package:pentapol/pentoscope/widgets/pentoscope_board.dart';
import 'package:pentapol/pentoscope/widgets/pentoscope_piece_slider.dart';

class PentoscopeGameScreen extends ConsumerWidget {
  const PentoscopeGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pentoscopeProvider);
    final notifier = ref.read(pentoscopeProvider.notifier);
    final settings = ref.watch(settingsProvider);

    if (state.puzzle == null) {
      return const Scaffold(body: Center(child: Text('Aucun puzzle')));
    }

    // Détection du mode transformation
    final isPlacedPieceSelected = state.selectedPlacedPiece != null;
    final isSliderPieceSelected = state.selectedPiece != null;

    // Orientation
    final isLandscape =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isLandscape
          ? null
          : PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          toolbarHeight: 56.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          ),
          // EXCLUSIF:
          // 1. Actions isométrie si pièce PLATEAU sélectionnée
          // 2. Reset si pièce SLIDER sélectionnée
          // 3. Solution count si AUCUNE pièce sélectionnée
          title: isPlacedPieceSelected
              ? null
              : _buildSolutionCountWidget(state),
          actions: isPlacedPieceSelected
              ? [
            _buildIsometryActionsBar(
              state,
              ref.read(pentoscopeProvider.notifier),
              settings,
              Axis.horizontal,
            ),
          ]
              : isSliderPieceSelected
              ? [
            // Rien en AppBar si pièce slider (actions au-dessus slider)
          ]
              : [
            // Reset en mode général
            IconButton(
              icon: const Icon(Icons.games),
              onPressed: () {
                HapticFeedback.mediumImpact();
                notifier.reset();
              },
              tooltip: 'Recommencer',
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;

              if (isLandscape) {
                return _buildLandscapeLayout(
                  context,
                  ref,
                  state,
                  notifier,
                  settings,
                  isSliderPieceSelected,
                  isPlacedPieceSelected,
                );
              } else {
                return _buildPortraitLayout(
                  context,
                  ref,
                  state,
                  notifier,
                  isSliderPieceSelected,
                  isPlacedPieceSelected,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // WIDGET RÉUTILISABLE: Barre d'actions isométrie
  // ============================================================================

  /// Widget réutilisable pour les icônes isométrie (horizontal ou vertical)
  Widget _buildIsometryActionsBar(
      PentoscopeState state,
      PentoscopeNotifier notifier,
      dynamic settings,
      Axis direction,
      ) {
    final children = [
      // Rotation anti-horaire (CCW)
      _buildIconButton(
        GameIcons.isometryRotationTW,
        settings,
            () => notifier.applyIsometryRotationTW(),
      ),

      // Rotation horaire (CW)
      _buildIconButton(
        GameIcons.isometryRotationCW,
        settings,
            () => notifier.applyIsometryRotationCW(),
      ),

      // Symétrie horizontale
      _buildIconButton(
        GameIcons.isometrySymmetryH,
        settings,
            () => notifier.applyIsometrySymmetryH(),
      ),

      // Symétrie verticale
      _buildIconButton(
        GameIcons.isometrySymmetryV,
        settings,
            () => notifier.applyIsometrySymmetryV(),
      ),

      // Supprimer (uniquement si pièce placée sélectionnée)
      if (state.selectedPlacedPiece != null)
        _buildIconButton(
          GameIcons.removePiece,
          settings,
              () => notifier.removePlacedPiece(state.selectedPlacedPiece!),
        ),
    ];

    return direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  /// Helper: bouton d'action isométrie
  Widget _buildIconButton(
      dynamic icon,
      dynamic settings,
      VoidCallback onPressed,
      ) {
    return IconButton(
      icon: Icon(icon.icon, size: settings.ui.iconSize),
      onPressed: () {
        HapticFeedback.selectionClick();
        onPressed();
      },
      tooltip: icon.tooltip,
      color: icon.color,
    );
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Affiche le nombre de solutions
  Widget _buildSolutionCountWidget(PentoscopeState state) {
    final count = state.puzzle?.solutionCount ?? 0;
    return Text(
      '$count solution${count != 1 ? "s" : ""}',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  /// Construit le slider avec DragTarget (drag pièce vers slider = suppression)
  Widget _buildSliderWithDragTarget({
    required WidgetRef ref,
    required bool isLandscape,
    required Widget sliderChild,
    required BoxDecoration decoration,
    double? width,
    double? height,
  }) {
    final state = ref.watch(pentoscopeProvider);
    final notifier = ref.read(pentoscopeProvider.notifier);

    return DragTarget<Pento>(
      onWillAcceptWithDetails: (details) {
        // Accepter seulement si c'est une pièce placée
        return state.selectedPlacedPiece != null;
      },
      onAcceptWithDetails: (details) {
        // Retirer la pièce du plateau
        if (state.selectedPlacedPiece != null) {
          HapticFeedback.mediumImpact();
          notifier.removePlacedPiece(state.selectedPlacedPiece!);
        }
      },
      builder: (context, candidateData, rejectedData) {
        // Highlight visuel au survol
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          height: height,
          decoration: decoration.copyWith(
            border: isHovering
                ? Border.all(color: Colors.red.shade400, width: 3)
                : null,
            color: isHovering ? Colors.red.shade50 : decoration.color,
          ),
          child: Stack(
            children: [
              sliderChild,
              // Icône poubelle au survol
              if (isHovering)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.red.withOpacity(0.1),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade700,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================================
  // LAYOUTS
  // ============================================================================

  /// Layout portrait : plateau en haut, actions + slider en bas
  Widget _buildPortraitLayout(
      BuildContext context,
      WidgetRef ref,
      PentoscopeState state,
      PentoscopeNotifier notifier,
      bool isSliderPieceSelected,
      bool isPlacedPieceSelected,
      ) {
    final settings = ref.read(settingsProvider);

    return Column(
      children: [
        // Plateau de jeu
        const Expanded(flex: 3, child: PentoscopeBoard(isLandscape: false)),

        // 🎯 Actions isométrie UNIQUEMENT si pièce du SLIDER sélectionnée
        // (exclue si pièce plateau sélectionnée)
        if (isSliderPieceSelected && !isPlacedPieceSelected)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildIsometryActionsBar(
              state,
              notifier,
              settings,
              Axis.horizontal,
            ),
          ),

        // Slider de pièces horizontal
        _buildSliderWithDragTarget(
          ref: ref,
          isLandscape: false,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          sliderChild: const PentoscopePieceSlider(isLandscape: false),
        ),
      ],
    );
  }

  /// Layout paysage : plateau à gauche, actions + slider vertical à droite
  Widget _buildLandscapeLayout(
      BuildContext context,
      WidgetRef ref,
      PentoscopeState state,
      PentoscopeNotifier notifier,
      dynamic settings,
      bool isSliderPieceSelected,
      bool isPlacedPieceSelected,
      ) {
    return Row(
      children: [
        // Plateau de jeu
        const Expanded(child: PentoscopeBoard(isLandscape: true)),

        // Colonne de droite : actions + slider
        Row(
          children: [
            // 🎯 Colonne d'actions (contextuelles)
            Container(
              width: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(-1, 0),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isPlacedPieceSelected
                    ? [
                  // Actions isométrie si pièce plateau sélectionnée
                  _buildIsometryActionsBar(
                    state,
                    notifier,
                    settings,
                    Axis.vertical,
                  ),
                ]
                    : [
                  // Actions générales
                  IconButton(
                    icon: const Icon(Icons.games),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      notifier.reset();
                    },
                    tooltip: 'Recommencer',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Retour',
                  ),
                ],
              ),
            ),

            // Slider de pièces vertical
            _buildSliderWithDragTarget(
              ref: ref,
              isLandscape: true,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              sliderChild: const PentoscopePieceSlider(isLandscape: true),
            ),
          ],
        ),
      ],
    );
  }
}