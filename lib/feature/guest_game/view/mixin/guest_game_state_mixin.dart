// ignore_for_file: public_member_api_docs

import 'package:localchess/feature/guest_game/view/guest_game_screen.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_view_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';

mixin GuestGameStateMixin on BaseState<GuestGameScreen> {
  @override
  void initState() {
    super.initState();
    G.logger.t('GuestGameScreenStateMixin.initState');
    viewModel.init(widget.hostAddress);
  }

  @override
  void dispose() {
    super.dispose();
    G.logger.t('GuestGameScreenStateMixin.dispose');
    viewModel.disconnect();
  }

  void disconnect() {
    G.logger.t('GuestGameScreenStateMixin.disconnect');
    viewModel.disconnect();
  }

  GuestGameViewModel get viewModel => G.guestGameViewModel;
}
