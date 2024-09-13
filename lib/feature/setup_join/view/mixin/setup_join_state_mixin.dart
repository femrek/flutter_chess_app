// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:localchess/feature/setup_join/view/setup_join_screen.dart';
import 'package:localchess/feature/setup_join/view_model/setup_join_view_model.dart';
import 'package:localchess/product/constant/host_constant.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/navigation/app_route.gr.dart';
import 'package:localchess/product/state/base/base_state.dart';

mixin SetupJoinStateMixin on BaseState<SetupJoinScreen> {
  @override
  void initState() {
    super.initState();
    fillAddressFields();
  }

  SetupJoinViewModel get viewModel => G.setupJoinViewModel;

  TextEditingController addressController = TextEditingController();
  TextEditingController portController = TextEditingController();

  Future<void> fillAddressFields() async {
    final address = await viewModel.getLocalAddress();
    if (address != null) {
      addressController.text = address;
    }
    portController.text = HostConstant.addressOnNetwork.port.toString();
  }

  void onPressedJoinWithAddress(String address, int port) {
    context.router.push(GuestGameRoute(
      hostAddress: AddressOnNetwork(
        address: InternetAddress(address),
        port: port,
      ),
    ));
  }
}
