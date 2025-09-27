import 'package:flutter/material.dart';
import 'package:localchess/product/constant/radius/app_radius_constant.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';

part 'app_dark_theme.dart';
part 'app_light_theme.dart';

/// Specifies the app theme.
sealed class AppTheme {
  ThemeData get _theme => ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
      );

  /// The theme data have to be specified.
  ThemeData get theme => _theme.copyWith(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        cardTheme: cardTheme,
        appBarTheme: appBarTheme,
        dialogTheme: dialogTheme,
        elevatedButtonTheme: elevatedButtonTheme,
      );

  /// The color scheme have to be specified.
  ColorScheme get colorScheme;

  /// The scaffold background color have to be specified.
  Color get scaffoldBackgroundColor;

  /// The card theme have to be specified.
  CardThemeData get cardTheme;

  /// The app bar theme have to be specified.
  AppBarThemeData get appBarTheme;

  /// The dialog theme have to be specified.
  DialogThemeData get dialogTheme;

  /// The elevated button theme have to be specified.
  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _theme.colorScheme.primary,
          foregroundColor: _theme.colorScheme.onPrimary,
        ),
      );
}
