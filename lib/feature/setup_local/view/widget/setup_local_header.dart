// ignore_for_file: public_member_api_docs

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding_constant.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

/// The header part of the setup_local_screen.
class SetupLocalHeader extends StatelessWidget {
  const SetupLocalHeader({
    required this.onPressedNewGame,
    super.key,
  });

  /// The callback when the new game button is pressed.
  final VoidCallback onPressedNewGame;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BackButton(),
        Expanded(
          child: Text(
            LocaleKeys.screen_setupLocal_savedGamesListTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  height: 1,
                ),
          ).tr(),
        ),
        const SizedBox(width: 12),
        Align(
          alignment: Alignment.centerRight,
          child: AppButton(
            onPressed: onPressedNewGame,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).colorScheme.primary
                : null,
            child: Text(
              LocaleKeys.screen_setupLocal_newGameButton,
              style: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      )
                  : null,
            ).tr(),
          ),
        ),
        const SizedBox(width: AppPaddingConstant.screenHorizontal),
      ],
    );
  }
}