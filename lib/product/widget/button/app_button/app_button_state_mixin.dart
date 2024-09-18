// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

mixin AppButtonStateMixin on BaseState<AppButton> {
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    isLoadingNotifier.value = false;
  }
}
