import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/feature/host_game/view_model/host_game_state.dart';
import 'package:localchess/product/constant/padding/app_padding_constant.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// A widget that shows the information of a guest player in the host game.
/// The host can allow or kick the guest player.
class HostGameGuestEntry extends StatelessWidget {
  /// Creates a [HostGameGuestEntry].
  const HostGameGuestEntry({
    required this.client,
    required this.onPlayWithGuestPressed,
    required this.onMakeSpecPressed,
    required this.onKickGuestPressed,
    super.key,
  });

  /// The data about the guest player.
  final HostGameClientState client;

  /// The callback that is called when pressing the allow button.
  final VoidCallback onPlayWithGuestPressed;

  /// The callback that is called when pressing the make spec button.
  final VoidCallback onMakeSpecPressed;

  /// The callback that is called when pressing the kick button.
  final VoidCallback onKickGuestPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: AppPaddingConstant.cardHorizontal,
      ),
      title: Text(client.clientInformation.deviceName),
      subtitle: client.isAllowed
          ? const Text(
              LocaleKeys.screen_hostGame_guestEntry_currentlyPlaying,
            ).tr()
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // allow button or make spec button
          if (client.isAllowed)
            IconButton(
              onPressed: onMakeSpecPressed,
              tooltip:
                  LocaleKeys.screen_hostGame_guestEntry_makeSpecButton.tr(),
              icon: const Icon(Icons.remove_red_eye),
            )
          else
            IconButton(
              onPressed: onPlayWithGuestPressed,
              tooltip: LocaleKeys.screen_hostGame_guestEntry_allowButton.tr(),
              icon: const Icon(Icons.play_arrow),
            ),

          const SizedBox(width: 8),

          // kick button
          IconButton(
            onPressed: onKickGuestPressed,
            tooltip: LocaleKeys.screen_hostGame_guestEntry_kickButton.tr(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
