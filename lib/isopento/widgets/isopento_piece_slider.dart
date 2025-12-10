// lib/isopento/widgets/isopento_piece_slider.dart
// Modified: 2512091031
// REFACTOR: Remplace +3 par _getDisplayPositionIndex() pour meilleure compréhension

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pentapol/common/pentominos.dart';
import 'package:pentapol/providers/settings_provider.dart';
import 'package:pentapol/screens/pentomino_game/widgets/shared/draggable_piece_widget.dart';
import 'package:pentapol/screens/pentomino_game/widgets/shared/piece_renderer.dart';
import 'package:pentapol/isopento/isopento_provider.dart';

class IsopentoPieceSlider extends ConsumerWidget {
  final bool isLandscape;

  const IsopentoPieceSlider({
    super.key,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(isopentoProvider);
    final notifier = ref.read(isopentoProvider.notifier);
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
      IsopentoNotifier notifier,
      IsopentoState state,
      settings,
      bool isLandscape,
      )
  {
    int positionIndex = state.selectedPiece?.id == piece.id
        ? state.selectedPositionIndex
        : state.getPiecePositionIndex(piece.id);

    // Convertir pour l'affichage
    int displayPositionIndex = _getDisplayPositionIndex(positionIndex, piece, isLandscape);

    final isSelected = state.selectedPiece?.id == piece.id;
    final hasIsometry = isSelected && positionIndex != 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Stack(
        children: [
          Container(
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
              positionIndex: positionIndex,
              isSelected: isSelected,
              selectedPositionIndex: state.selectedPositionIndex,
              longPressDuration: Duration(milliseconds: settings.game.longPressDuration),
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
          // Badge d'isométrie active
          if (hasIsometry)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.orange.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '↻',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}