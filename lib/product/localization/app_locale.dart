// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// Supported locales in the app
enum AppLocale {
  en(Locale('en', 'US')),
  tr(Locale('tr', 'TR'));

  const AppLocale(this.locale);

  static AppLocale? fromLocale(Locale locale) {
    return AppLocale.values.where((e) => e.locale == locale).firstOrNull;
  }

  final Locale locale;

  String get languageName {
    switch (this) {
      case AppLocale.en:
        return 'English';
      case AppLocale.tr:
        return 'Türkçe';
    }
  }
}
