// ignore_for_file: public_member_api_docs

import 'package:localchess/feature/setup_local/view/setup_local_screen.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';

mixin SetupLocalStateMixin on BaseState<SetupLocalScreen> {
  @override
  void initState() {
    super.initState();
    viewModel.loadSaves();
  }

  SetupLocalViewModel get viewModel => G.setupLocalViewModel;
}
