import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// The app bar of the home screen.
class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the home screen app bar.
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        LocaleKeys.screen_home_title.tr(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
