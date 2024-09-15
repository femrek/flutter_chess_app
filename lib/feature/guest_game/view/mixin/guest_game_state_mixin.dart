// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:localchess/feature/guest_game/view/guest_game_screen.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_view_model.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/dialog/pick_a_promotion_dialog.dart';

mixin GuestGameStateMixin on BaseState<GuestGameScreen> {
  @override
  void initState() {
    super.initState();
    G.logger.t('GuestGameScreenStateMixin.initState');
    viewModel.init(
      address: widget.hostAddress,
      onClientKickedListener: _onKickedListener,
    );
  }

  @override
  void dispose() {
    super.dispose();
    G.logger.t('GuestGameScreenStateMixin.dispose');
    viewModel.disconnect();
  }

  GuestGameViewModel get viewModel => G.guestGameViewModel;

  void disconnectPressed() {
    G.logger.t('GuestGameScreenStateMixin.disconnect');
    viewModel.disconnect();
    if (mounted) context.router.maybePop();
  }

  void onFocusTried(SquareCoordinate coordinate) {
    G.logger.t('GuestGameScreenStateMixin.onFocusTried: $coordinate');

    final gameState = viewModel.state.gameState;
    if (gameState == null) {
      G.logger.w('Invalid state');
      return;
    }

    if (gameState.isFocused) {
      G.logger.w('A piece is already focused');
      return;
    }

    final squareState = gameState.squareStates[coordinate];
    if (squareState == null) {
      throw Exception(
          'Invalid coordinate when focusing. No square state found');
    }
    if (!squareState.canMove) {
      G.logger.d(
        'Invalid coordinate when focusing. focus coordinate must be'
        ' contained in movablePiecesCoordinates',
      );
      return;
    }

    viewModel.focus(coordinate);
  }

  Future<void> onMoveTried(SquareCoordinate target) async {
    G.logger.t('GuestGameScreenStateMixin.onMoveTried to: $target');

    final state = viewModel.state;

    // validate state.
    final gameState = state.gameState;
    if (gameState == null) return;
    if (!gameState.isFocused) return;

    // get square state data
    final squareState = gameState.squareStates[target];

    // cancel if the square could not be found.
    if (squareState == null) {
      G.logger.d('Invalid move. No square state found for $target');
      viewModel.removeFocus();
      G.logger.t('onMoveTried: Removed focus');
      return;
    }

    // get the move to be made.
    final move = squareState.moveToThis ?? squareState.captureToThis;

    // cancel the move if no move is found.
    if (move == null) {
      G.logger.d('Invalid move. No move found for $target');
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
        color: gameState.turnStatus.turn ?? PlayerColor.black,
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

    G.logger.t('onMoveTried: Moved to $target');
  }

  void _onKickedListener() {
    G.logger.t('GuestGameScreenStateMixin._onKickedListener: start');

    if (mounted) {
      G.logger.d('popping the guest game screen, kicked from the game');
      context.router.maybePop();
    } else {
      G.logger.w('GuestGameScreenStateMixin._onKickedListener: '
          'screen is not mounted');
    }

    G.logger.t('GuestGameScreenStateMixin._onKickedListener: end');
  }
}
