// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:localchess/feature/setup_local/view/setup_local_screen.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/navigation/app_route.gr.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/dialog/enter_game_name_dialog.dart';

mixin SetupLocalStateMixin on BaseState<SetupLocalScreen> {
  @override
  void initState() {
    super.initState();
    viewModel.loadSaves();
  }

  SetupLocalViewModel get viewModel => G.setupLocalViewModel;

  void onPressedNewGame() {
    EnterGameNameDialog.show(
      context: context,
      title: LocaleKeys.dialog_createGameDialog_title.tr(),
      hintText: LocaleKeys.dialog_createGameDialog_hint.tr(),
      confirmText: LocaleKeys.dialog_createGameDialog_createButton.tr(),
      cancelText: LocaleKeys.dialog_createGameDialog_cancelButton.tr(),
    ).then((name) async {
      if (name == null) return;
      if (name.isEmpty) return;
      final save = await viewModel.createGame(name);

      if (mounted) await context.router.push(LocalGameRoute(save: save));
    });
  }

  Future<void> onPressedSave(LocalGameSaveCacheModel save) async {
    await context.router.push(LocalGameRoute(save: save));
  }
}
