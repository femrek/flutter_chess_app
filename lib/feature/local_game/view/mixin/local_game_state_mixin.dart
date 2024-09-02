// ignore_for_file: public_member_api_docs

import 'package:localchess/feature/local_game/view/local_game_screen.dart';
import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/dialog/pick_a_promotion_dialog.dart';

mixin LocalGameStateMixin on BaseState<LocalGameScreen> {
  @override
  void initState() {
    super.initState();
    viewModel.init(widget.save);
  }

  @override
  void dispose() {
    super.dispose();
    G.setupLocalViewModel.loadSaves();
  }

  /// The view model for the local game screen
  LocalGameViewModel get viewModel => G.localGameViewModel;

  void onFocusTried(SquareCoordinate coordinate) {
    G.logger.t('onFocusTried: $coordinate');
    final state = viewModel.state;
    if (state is! LocalGameLoadedState) {
      G.logger.w('Invalid state');
      return;
    }
    if (state.isFocused) {
      G.logger.w('A piece is already focused');
      return;
    }
    if (!state.movablePiecesCoordinates.contains(coordinate)) {
      G.logger.d(
        'Invalid coordinate when focusing. focus coordinate must be'
        ' contained in movablePiecesCoordinates',
      );
      return;
    }

    viewModel.focus(coordinate);

    G.logger.t('onFocusTried: Focused on $coordinate');
  }

  Future<void> onMoveTried(SquareCoordinate targetCoordinate) async {
    G.logger.t('onMoveTried: $targetCoordinate');

    final state = viewModel.state;

    // validate state.
    if (state is! LocalGameLoadedState) return;
    if (!state.isFocused) return;

    // find and validate the move.
    final moves = state.moves;
    if (moves == null) throw Exception('moves is null');
    final move = moves[targetCoordinate];
    if (move == null) {
      G.logger.d('Invalid move. No move found for $targetCoordinate');
      viewModel.removeFocus();
      G.logger.t('onMoveTried: Removed focus');
      return;
    }

    // pick a piece for promotion if the move is a promotion move.
    String? promotion;
    if (move.hasPromotion) {
      // get the moving piece to determine the promotion piece color.
      final movingPiece = state.getPieceAt(move.from);
      if (movingPiece == null) {
        G.logger.w('movingPiece is null when move has promotion');
      }

      // pick a promotion piece if the move is a promotion move.
      promotion = await PickAPromotionDialog.show(
        context: context,
        isDark: state.getPieceAt(move.from)?.isDark ?? true,
      );

      // cancel the move if dialog is dismissed.
      if (promotion == null) {
        G.logger.d('Promotion dialog is dismissed. '
            'When move has promotion, no promotion is selected');
        return;
      }
    }

    await viewModel.move(
      move: move,
      promotion: promotion,
    );

    G.logger.t('onMoveTried: Moved to $targetCoordinate');
  }
}
