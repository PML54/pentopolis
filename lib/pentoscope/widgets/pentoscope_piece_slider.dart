// lib/pentapol/pentoscope/widgets/pentoscope_piece_slider.dart
// Modified: 2512100457
// FIX: Adopter _getDisplayPositionIndex() d'isopento pour rotation paysage stable (-90° compensation)
// CHANGEMENTS: (1) Ajout fonction _getDisplayPositionIndex() ligne 50, (2) Utilisation ligne 68 au lieu de code inline

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pentapol/common/pentominos.dart';
import 'package:pentapol/providers/settings_provider.dart';
import 'package:pentapol/screens/pentomino_game/widgets/shared/draggable_piece_widget.dart';
import 'package:pentapol/screens/pentomino_game/widgets/shared/piece_renderer.dart';
import 'package:pentapol/pentoscope/pentoscope_provider.dart';

class PentoscopePieceSlider extends ConsumerWidget {
  final bool isLandscape;

  const PentoscopePieceSlider({
    super.key,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pentoscopeProvider);
    final notifier = ref.read(pentoscopeProvider.notifier);
    final settings = ref.read(settingsProvider);

    final pieces = state.availablePieces;

    if (pieces.isEmpty) {
      return const SizedBox.shrink();
    }

    final scrollDirection = isLandscape ? Axis.vertical : Axis.horizontal;
    final padding = isLandscape
        ? const EdgeInsets.symmetric(vertical: 16, horizontal: 8)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: padding,
      itemCount: pieces.length,
      itemBuilder: (context, index) {
        final piece = pieces[index];
        return _buildDraggablePiece(piece, notifier, state, settings, isLandscape);
      },
    );
  }

  /// Convertit positionIndex interne en displayPositionIndex pour l'affichage
  /// En paysage: applique rotation inverse de -90° pour compenser le pivot du plateau
  int _getDisplayPositionIndex(int positionIndex, Pento piece, bool isLandscape) {
    if (isLandscape) {
      // Appliquer rotation inverse de -90° pour compenser le pivot du plateau
      return (positionIndex - 1 + piece.numPositions) % piece.numPositions;

    }
    return positionIndex;
  }

  Widget _buildDraggablePiece(
      Pento piece,
      PentoscopeNotifier notifier,
      PentoscopeState state,
      settings,
      bool isLandscape,
      ) {
    int positionIndex = state.selectedPiece?.id == piece.id
        ? state.selectedPositionIndex
        : state.getPiecePositionIndex(piece.id);

    // Convertir pour l'affichage
    int displayPositionIndex = _getDisplayPositionIndex(positionIndex, piece, isLandscape);

    final isSelected = state.selectedPiece?.id == piece.id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.amber.shade700, width: 3)
              : null,
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: DraggablePieceWidget(
          piece: piece,
          positionIndex: displayPositionIndex,
          isSelected: isSelected,
          selectedPositionIndex: isSelected ? displayPositionIndex : state.selectedPositionIndex,  longPressDuration: Duration(milliseconds: settings.game.longPressDuration),
          onSelect: () {
            if (settings.game.enableHaptics) {
              HapticFeedback.selectionClick();
            }
            notifier.selectPiece(piece);
          },
          onCycle: () {
            if (settings.game.enableHaptics) {
              HapticFeedback.selectionClick();
            }
            notifier.cycleToNextOrientation();
          },
          onCancel: () {
            if (settings.game.enableHaptics) {
              HapticFeedback.lightImpact();
            }
            notifier.cancelSelection();
          },
          childBuilder: (isDragging) => PieceRenderer(
            piece: piece,
            positionIndex: displayPositionIndex,
            isDragging: isDragging,
            getPieceColor: (pieceId) => settings.ui.getPieceColor(pieceId),
          ),
        ),
      ),
    );
  }
}