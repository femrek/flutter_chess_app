// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:localchess/feature/setup_host/view/setup_host_screen.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_view_model.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/navigation/app_route.gr.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/widget/dialog/confirmation_dialog.dart';
import 'package:localchess/product/widget/dialog/enter_game_name_dialog.dart';

mixin SetupHostStateMixin on BaseState<SetupHostScreen> {
  SetupHostViewModel get viewModel => G.setupHostViewModel;

  @override
  void initState() {
    super.initState();
    viewModel.loadSaves();
    fillNameField();
  }

  final TextEditingController nameController = TextEditingController();

  /// Fills the address fields at the beginning of the screen.
  void fillNameField() {
    nameController.text = viewModel.getDeviceName();
  }

  /// onChanged function of device name input.
  void onNameChanged(String name) {
    viewModel.updateName(name);
  }

  /// onPressed function of new game button. Do not return [Future], because
  /// the button should not show progress indicator.
  void onPressedNewGame() {
    EnterGameNameDialog.show(context: context).then((name) async {
      if (name == null) return;
      if (name.isEmpty) return;
      await viewModel.createGame(name);
    });
  }

  Future<void> onPlayPressed(
      GameSaveStorageModel save, PlayerColor color) async {
    if (mounted) {
      await context.router.push(HostGameRoute(
        save: save,
        chosenColor: color,
      ));
    }
  }

  Future<void> onRemovePressed(GameSaveStorageModel save) async {
    final removeConfirmed = await ConfirmationDialog.showRemoveConfirmation(
      context: context,
      gameName: save.gameSave.name,
    );

    if (removeConfirmed) await viewModel.removeSave(save);
  }
}
