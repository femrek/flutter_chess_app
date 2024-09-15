import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:localchess/feature/setup_join/view/mixin/setup_join_state_mixin.dart';
import 'package:localchess/feature/setup_join/view/widget/setup_join_header.dart';
import 'package:localchess/feature/setup_join/view/widget/setup_join_host_address.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/device_name_input/device_name_input.dart';

/// Join Screen widget
@RoutePage()
class SetupJoinScreen extends StatefulWidget {
  /// Join Screen widget constructor
  const SetupJoinScreen({super.key});

  @override
  State<SetupJoinScreen> createState() => _SetupJoinScreenState();
}

class _SetupJoinScreenState extends BaseState<SetupJoinScreen>
    with SetupJoinStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SetupJoinHeader(),
      body: const AppPadding.screen(horizontal: 0).toWidget(
        child: Column(
          children: [
            const AppPadding.screen(vertical: 0).toWidget(
              child: DeviceNameInput(
                controller: nameController,
                onChanged: onNameChanged,
              ),
            ),

            // enter ip address section
            const AppPadding.screen(vertical: 0).toWidget(
              child: SetupJoinHostAddress(
                onPressedJoin: onPressedJoinWithAddress,
                hostController: addressController,
                portController: portController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
