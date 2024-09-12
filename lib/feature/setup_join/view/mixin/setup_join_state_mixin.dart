// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:localchess/feature/setup_join/view/setup_join_screen.dart';
import 'package:localchess/feature/setup_join/view_model/setup_join_view_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/dialog/join_loading_dialog.dart';

mixin SetupJoinStateMixin on BaseState<SetupJoinScreen> {
  @override
  void initState() {
    super.initState();
  }

  SetupJoinViewModel get viewModel => G.setupJoinViewModel;

  Future<void> onPressedJoinWithAddress(String address, int port) async {
    final dummyPromise = Future.delayed(const Duration(seconds: 3), () {});

    await JoinLoadingDialog.show(context: context, promise: dummyPromise);
  }
}
