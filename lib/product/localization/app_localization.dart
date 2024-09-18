import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/localization/app_locale.dart';

/// For wrapping the whole application with localization support.
class AppLocalization extends EasyLocalization {
  /// Constructor for AppLocalization
  /// [child] is the child widget to wrap with localization support.
  AppLocalization({
    required super.child,
    super.key,
  }) : super(
          supportedLocales: _supportedLocales,
          path: _path,
          useOnlyLangCode: true,
          fallbackLocale: AppLocale.en.locale,
        );

  static final List<Locale> _supportedLocales =
      AppLocale.values.map((e) => e.locale).toList();

  static const String _path = 'asset/translation';

  /// Method to update the language of the application.
  static void updateLanguage({
    required BuildContext context,
    required AppLocale locale,
  }) {
    context.setLocale(locale.locale);
  }
}
