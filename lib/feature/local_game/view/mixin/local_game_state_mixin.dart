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

    final squareState = state.squareStates[coordinate];
    if (squareState == null) {
      G.logger.w('Invalid coordinate when focusing. No square state found');
      return;
    }

    if (!squareState.canMove) {
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

    // get square state data
    final squareState = state.squareStates[targetCoordinate];

    // cancel if the square could not be found.
    if (squareState == null) {
      G.logger.d('Invalid move. No square state found for $targetCoordinate');
      viewModel.removeFocus();
      G.logger.t('onMoveTried: Removed focus');
      return;
    }

    // get the move to be made.
    final move = squareState.moveToThis ?? squareState.captureToThis;

    // cancel the move if no move is found.
    if (move == null) {
      G.logger.d('Invalid move. No move found for $targetCoordinate');
      viewModel.removeFocus();
      G.logger.t('onMoveTried: Removed focus');
      return;
    }

    // pick a piece for promotion if the move is a promotion move.
    String? promotion;
    if (move.hasPromotion) {
      // pick a promotion piece if the move is a promotion move.
      promotion = await PickAPromotionDialog.show(
        context: context,

        // if the moving piece is null, default to dark.
        isDark: state.turnStatus.isDark ?? true,
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
