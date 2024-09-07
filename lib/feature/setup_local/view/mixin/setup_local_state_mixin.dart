// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:localchess/feature/setup_local/view/setup_local_screen.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/navigation/app_route.gr.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/dialog/confirmation_dialog.dart';
import 'package:localchess/product/widget/dialog/enter_game_name_dialog.dart';

mixin SetupLocalStateMixin on BaseState<SetupLocalScreen> {
  @override
  void initState() {
    super.initState();
    viewModel.loadSaves();
  }

  SetupLocalViewModel get viewModel => G.setupLocalViewModel;

  /// onPressed function of new game button. Do not return [Future], because
  /// the button should not show progress indicator.
  void onPressedNewGame() {
    EnterGameNameDialog.show(context: context).then((name) async {
      if (name == null) return;
      if (name.isEmpty) return;
      final save = await viewModel.createGame(name);

      if (mounted) await context.router.push(LocalGameRoute(save: save));
    });
  }

  Future<void> onPlayPressed(GameSaveCacheModel save) async {
    await context.router.push(LocalGameRoute(save: save));
  }

  Future<void> onRemovePressed(GameSaveCacheModel save) async {
    final removeConfirmed = await ConfirmationDialog.showRemoveConfirmation(
      context: context,
      gameName: save.gameSave.name,
    );

    if (removeConfirmed) await viewModel.removeSave(save);
  }
}
