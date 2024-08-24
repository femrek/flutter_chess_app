import 'package:flutter/material.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/theme/app_theme.dart';

/// The dark theme configuration for the application.
final class AppDarkTheme implements AppTheme {
  final ThemeData _theme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColorScheme.darkColorScheme,
  );

  @override
  ThemeData get theme => _theme;
}
