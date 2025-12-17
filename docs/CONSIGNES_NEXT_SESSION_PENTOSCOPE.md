================================================================================
CONSIGNES POUR CONTINUER PENTOSCOPE
================================================================================

À transmettre pour la prochaine conversation

================================================================================
ÉTAT ACTUEL (Commit: bd6f11e)
================================================================================

✅ FONCTIONNEL:
- Placement des pièces (slider → plateau) OK
- Sélection pièce placée OK
- Déplacement pièce placée (remplacer) OK
- Rotations TW/CW OK (portrait + paysage)
- Symétries H/V OK (portrait + paysage)
- Mode paysage: affichage + gestes cohérents
- displayPositionIndex appliqué au slider

🔄 ARCHITECTURE STABLE:
- Plateau = source de vérité
- Synchro strict placedPieces ↔ plateau
- IsometryService avec callbacks
- selectPiece() vs selectPlacedPiece() séparées
- H/V swap pour slider en paysage

================================================================================
CE QUI RESTE À FAIRE (PRIORISER)
================================================================================

COURT TERME (rapide, <1h chacun):
1. [ ] Déplacer la logique selectPiece() vers Isopento (même logique)
2. [ ] Appliquer displayPositionIndex à Isopento slider aussi
3. [ ] Vérifier Isopento H/V swap en paysage (lever le doute si nécessaire)
4. [ ] Documenter le calcul de displayPositionIndex (formule en commentaire)

MOYEN TERME (architecture):
5. [ ] Créer IsoPento_PlacedPiece classe commune avec PlacedPiece
6. [ ] Extraire helpers communs (_extractAbsoluteCoords, _canPlacePieceAt, etc.)
7. [ ] Tester Classical avec la même architecture (proof of concept)

LONG TERME (polish):
8. [ ] Refactoriser Classical/Duel pour utiliser même pattern
9. [ ] Créer service réutilisable générique pour tous les modules
10. [ ] Tests unitaires pour IsometryService

================================================================================
FICHIERS CRITIQUES À CONNAÎTRE
================================================================================

### Core (immuable, stable):
- lib/common/isometry_service.dart → Logique isométries
- lib/common/isometry_transforms.dart → Rotations/flipH/flipV
- lib/common/placed_piece.dart → Structure pièce placée
- lib/common/shape_recognizer.dart → Reconnaissance forme après transfo

### Pentoscope (modèle à suivre):
- lib/pentoscope/pentoscope_provider.dart → Pattern à copier
    * selectPiece() → Restaure plateau complet
    * selectPlacedPiece() → Retire pièce du plateau
    * tryPlacePiece() → Synchro plateau + SKIP logique
    * delegateIsometrySymmetryH/V({bool isLandscape}) → Swap en paysage

- lib/pentoscope/pentoscope_piece_slider.dart → displayPositionIndex
    * _getDisplayPositionIndex() → Applique rotation -90° en paysage
    * DraggablePieceWidget reçoit displayPositionIndex (PAS positionIndex!)

- lib/pentoscope/widgets/pentoscope_board.dart → Interaction plateau

### À adapter ensuite:
- lib/isopento/isopento_provider.dart → Copier pattern Pentoscope
- lib/isopento/widgets/isopento_piece_slider.dart → Ajouter displayPositionIndex
- lib/classical/pentomino_game_provider.dart → Prove of concept

================================================================================
BUGS/PROBLÈMES RÉSOLUS (NE PAS REFAIRE!)
================================================================================

❌ PIÈGE 1: Symétries inversées
CAUSE: flipHorizontal ↔ flipVertical inversés
SOLUTION: H → flipHorizontal, V → flipVertical (logiquement cohérent)
VÉRIFIER: Chaque nouvelle impl de symétrie

❌ PIÈGE 2: Pièces placées disparaissent
CAUSE: selectPiece() n'a pas restauré le plateau complet
SOLUTION: Boucle sur ALL placedPieces dans selectPiece()
VÉRIFIER: Chaque fois qu'on change selectPiece()

❌ PIÈGE 3: Doublon pièces en déplacement
CAUSE: tryPlacePiece() re-ajoute la pièce sélectionnée
SOLUTION: if (state.selectedPlacedPiece != null && ...) continue;
VÉRIFIER: Toujours dans le loop de rebuild plateau

❌ PIÈGE 4: Gestes incohérents en paysage
CAUSE: displayPositionIndex pas passé à DraggablePieceWidget
SOLUTION: Passer displayPositionIndex partout (affichage + gestes)
VÉRIFIER: Tout change en paysage doit utiliser display, pas logique

❌ PIÈGE 5: H/V inversés en paysage
CAUSE: Service ne sait pas si c'est paysage ou portrait
SOLUTION: Passer isLandscape au Notifier, swap au niveau Notifier
VÉRIFIER: Méthodes symétries prennent {bool isLandscape}

================================================================================
APPROCHE À SUIVRE (LEARN FROM EXPERIENCE)
================================================================================

🚫 NE PAS:
- Deviner ("je parie que...")
- Faire des sed complexes sans vérification
- Faire des git rebase/cherry-pick compliqués
- Proposer des solutions sans comprendre le problème
- Refactoriser 5 fichiers en même temps

✅ À LA PLACE:
1. Lire le code avec attention (5 min)
2. Comprendre le pattern existant (établi par Pentoscope)
3. Identifier la différence avec le nouveau module (2 min)
4. Proposer l'adaptation minimale (copier-coller + 2-3 lignes)
5. Tester IMMÉDIATEMENT (1 min)
6. Si bug → analyser le code (pas deviner!)
7. Si trop compliqué → demander au user un diagnostic

CHECKLISTE AVANT CHAQUE MODIF:
- [ ] J'ai lu tout le code concerné?
- [ ] Je comprends pourquoi ça marche actuellement?
- [ ] Mon changement est minimal (copier-coller pattern)?
- [ ] Ai-je testé avant de proposer suite?
- [ ] Ai-je identifié les pièges spécifiques?

================================================================================
PRIORITÉ: ISOPENTO (pas Classical!)
================================================================================

Pentoscope: ✅ STABLE

Isopento: ⚠️ À METTRE À JOUR
- [ ] selectPiece() sans restoration plateau? → AJOUTER
- [ ] displayPositionIndex dans slider? → AJOUTER
- [ ] H/V swap en paysage? → VÉRIFIER d'abord (possible que ce soit bon)

Classical: ❌ À faire après (autre conversation)

================================================================================
TESTS MINIMAUX À FAIRE (chaque modif)
================================================================================

```bash
flutter clean && rm -rf .dart_tool && flutter pub get && flutter run
```

Pour chaque module (Isopento, Pentoscope):

PORTRAIT:
- [ ] Place pièce A: elle apparaît
- [ ] Sélectionne pièce B du slider: A reste visible
- [ ] Sélectionne pièce A (placée): elle peut se déplacer
- [ ] Rotation TW: OK
- [ ] Symétrie H: OK (pièce flip horizontalement)
- [ ] Symétrie V: OK (pièce flip verticalement)

PAYSAGE:
- [ ] Idem portrait
- [ ] Rotation TW: OK (doit être légèrement "rotée" visuellement)
- [ ] Symétrie H: OK (visuelle H = logique V?)
- [ ] Symétrie V: OK (visuelle V = logique H?)

================================================================================
GIT WORKFLOW (SIMPLE!)
================================================================================

Avant de commencer:
```bash
git status  # Must be "clean"
git log --oneline -3  # Voir où on est
```

Après chaque feature (5-10 min de code):
```bash
git add lib/
git commit -m "feat: [module] description concise"
git push origin main
```

✅ SIMPLE, ATOMIQUE, TRACEABLE

================================================================================
QUESTIONS À POSER SI DOUTE
================================================================================

"Donne-moi le résultat de ce grep:" → code exact
"Montre-moi la screenshot:" → voir le bug réel
"Peux-tu vérifier ce test:" → compilation exact
"Compare ces 2 lignes:" → voir différences précises

NE PAS accepter les réponses vagues!

================================================================================
RESSOURCES
================================================================================

Documentation créée:
- /mnt/user-data/outputs/MEMO_ARCHITECTURE_PIECES_REUSABLE.md
  → Lire AVANT de toucher à Isopento/Classical
  → Reference patterns établis

Code en outputs/:
- isopento_provider_v3_DELEGATE.dart
- pentoscope_provider_v3_DELEGATE.dart
- isometry_service_COMPLETE.dart

Commits stables à connaître:
- bd6f11e (actuel) → Pentoscope stabilisé
- e0aa310 → Étape 1 avant refactoring
- 255213a → Avant les problèmes (si besoin revert)

================================================================================
SUCCÈS CRITÈRES
================================================================================

✅ Fin de session réussie si:
1. Isopento marche comme Pentoscope (portrait + paysage)
2. 0 compilation errors
3. Tous les tests minimaux passent
4. Code change < 100 lignes (pas de refactoring massive)
5. Git history propre (commits atomiques)

================================================================================