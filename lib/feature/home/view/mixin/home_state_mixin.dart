// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:localchess/feature/home/view/home_screen.dart';
import 'package:localchess/product/navigation/app_route.gr.dart';
import 'package:localchess/product/state/base/base_state.dart';

mixin HomeStateMixin<T extends HomeScreen> on BaseState<T> {
  void onLocalPlayPressed() {
    context.router.push(const SetupLocalRoute());
  }

  void onHostPressed() {
    context.router.push(const SetupHostRoute());
  }

  void onJoinPressed() {
    context.router.push(const SetupJoinRoute());
  }
}
