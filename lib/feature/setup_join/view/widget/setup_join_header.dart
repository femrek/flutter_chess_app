import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// The header part of the setup_join_screen.
class SetupJoinHeader extends StatelessWidget implements PreferredSizeWidget {
  /// The header part of the setup_join_screen constructor.
  const SetupJoinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        LocaleKeys.screen_setupJoin_title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              height: 1,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
      ).tr(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
