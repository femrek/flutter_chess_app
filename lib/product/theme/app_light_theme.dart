import 'package:flutter/material.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/theme/app_theme.dart';

/// The light theme configuration for the application.
final class AppLightTheme implements AppTheme {
  final ThemeData _theme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColorScheme.lightColorScheme,
  );

  @override
  ThemeData get theme => _theme;
}
