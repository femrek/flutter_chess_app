// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// Supported locales in the app
enum AppLocale {
  en(Locale('en', 'US')),
  tr(Locale('tr', 'TR'));

  const AppLocale(this.locale);

  final Locale locale;
}
