import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/setup_join/view/mixin/setup_join_state_mixin.dart';
import 'package:localchess/feature/setup_join/view/widget/setup_join_header.dart';
import 'package:localchess/feature/setup_join/view/widget/setup_join_host_address.dart';
import 'package:localchess/feature/setup_join/view_model/setup_join_state.dart';
import 'package:localchess/feature/setup_join/view_model/setup_join_view_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/app_padding_constant.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/data/network_scan_result.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';
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
    return BlocProvider.value(
      value: G.setupJoinViewModel,
      child: Scaffold(
        appBar: const SetupJoinHeader(),
        body: const AppPadding.screen(horizontal: 0).toWidget(
          child: SafeArea(
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

                Expanded(
                  child: const AppPadding.screen(vertical: 0).toWidget(
                    child: _ScanGames(
                      onScanPressed: onScanPressed,
                      onJoinPressed: onJoinPressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanGames extends StatelessWidget {
  const _ScanGames({
    required this.onScanPressed,
    required this.onJoinPressed,
  });

  final VoidCallback onScanPressed;
  final void Function(NetworkScanResult) onJoinPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child:
          BlocSelector<SetupJoinViewModel, SetupJoinState, SetupJoinScanState>(
        selector: (state) => state.scanState,
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: AppPaddingConstant.cardVertical),

              // title and scan button
              const AppPadding.card(vertical: 0).toWidget(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.screen_setupJoin_scanNetwork_title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ).tr(),
                    ),
                    AppButton(
                      onPressed: onScanPressed,
                      child: const Text(
                        LocaleKeys.screen_setupJoin_scanNetwork_scanButton,
                      ).tr(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // status message
              const AppPadding.card(vertical: 0).toWidget(
                child: state.status.whenReturn<Widget>(
                  initial: () => const Text(
                    LocaleKeys.screen_setupJoin_scanNetwork_initialState,
                  ).tr(),
                  scanning: () => Column(
                    children: [
                      const Text(
                        LocaleKeys.screen_setupJoin_scanNetwork_scanningState,
                      ).tr(args: [
                        state.scannedHostCount.toString(),
                        state.maxHostCount.toString(),
                      ]),
                      LinearProgressIndicator(
                        value: state.scannedHostCount / state.maxHostCount,
                      ),
                    ],
                  ),
                  errorNoNetworkConnection: () => const Text(
                    LocaleKeys.screen_setupJoin_scanNetwork_noNetworkError,
                  ).tr(),
                  errorUnknown: () => const Text(
                    LocaleKeys.screen_setupJoin_scanNetwork_unknownError,
                  ).tr(),
                  loaded: () => const SizedBox.shrink(),
                ),
              ),

              // found games list
              Expanded(
                child: ListView.builder(
                  itemCount: state.availableGames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: const Text(
                        LocaleKeys.screen_setupJoin_scanNetwork_foundGame_title,
                      ).tr(args: [
                        state.availableGames[index].hostInformation.deviceName,
                      ]),
                      subtitle: const Text(
                        LocaleKeys
                            .screen_setupJoin_scanNetwork_foundGame_description,
                      ).tr(),
                      onTap: () {
                        onJoinPressed(state.availableGames[index]);
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
