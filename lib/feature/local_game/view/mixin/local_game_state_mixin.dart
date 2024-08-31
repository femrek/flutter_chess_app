// ignore_for_file: public_member_api_docs

import 'package:localchess/feature/local_game/view/local_game_screen.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';

mixin LocalGameStateMixin on BaseState<LocalGameScreen> {
  @override
  void initState() {
    super.initState();
    viewModel.init(widget.save);
  }

  /// The view model for the local game screen
  LocalGameViewModel get viewModel => G.localGameViewModel;
}
