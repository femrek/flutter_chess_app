import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/app_padding_constant.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/localization/app_locale.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';

/// The drawer menu of the home screen.
class HomeScreenDrawer extends StatelessWidget {
  /// Creates the home screen drawer.
  const HomeScreenDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          AppPadding(
            top: MediaQuery.of(context).padding.top,
            left: AppPaddingConstant.scrollableHorizontal,
            right: AppPaddingConstant.scrollableHorizontal,
          ).toWidget(
            child: Text(
              LocaleKeys.screen_home_drawer_title.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text(LocaleKeys.screen_home_drawer_toggleTheme).tr(),
            onTap: () {
              context.read<AppViewModel>().toggleThemeMode(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              LocaleKeys.screen_home_drawer_privacyPolicy,
            ).tr(),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          const AppPadding.scrollable(vertical: 0).toWidget(
            child: DropdownMenu<AppLocale>(
              width: double.infinity,
              leadingIcon: const Icon(Icons.language),
              label: const Text(
                LocaleKeys.screen_home_drawer_language_title,
              ).tr(),
              onSelected: (l) {
                if (l == null) return;
                context.setLocale(l.locale);
              },
              initialSelection: AppLocale.fromLocale(context.locale),
              dropdownMenuEntries: AppLocale.values
                  .map<DropdownMenuEntry<AppLocale>>(
                      (l) => DropdownMenuEntry<AppLocale>(
                            value: l,
                            label: l.languageName,
                          ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
