import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/feature/host_game/view_model/host_game_state.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

/// A widget that shows the information of a guest player in the host game.
/// The host can allow or kick the guest player.
class HostGameGuestEntry extends StatelessWidget {
  /// Creates a [HostGameGuestEntry].
  const HostGameGuestEntry({
    required this.state,
    required this.onAllowPressed,
    required this.onKickPressed,
    super.key,
  });

  /// The data about the guest player.
  final HostGameClientState state;

  /// The callback that is called when pressing the allow button.
  final VoidCallback onAllowPressed;

  /// The callback that is called when pressing the kick button.
  final VoidCallback onKickPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const AppPadding.card().toWidget(
        child: Column(
          children: [
            // name of the client
            Text(
              LocaleKeys.screen_hostGame_guestEntry_label.tr(args: [
                state.clientInformation.deviceName,
              ]),
            ),

            const Spacer(),

            // allow button if the client is not allowed
            if (state.isAllowed)
              const Text(
                LocaleKeys.screen_hostGame_guestEntry_currentlyPlaying,
              ).tr()
            else
              AppButton(
                onPressed: onAllowPressed,
                child: const Text(
                  LocaleKeys.screen_hostGame_guestEntry_allowButton,
                ).tr(),
              ),

            const Spacer(),

            // kick button
            AppButton(
              onPressed: onKickPressed,
              child: const Text(
                LocaleKeys.screen_hostGame_guestEntry_kickButton,
              ).tr(),
            ),
          ],
        ),
      ),
    );
  }
}
