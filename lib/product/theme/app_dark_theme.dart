import 'package:flutter/material.dart';
import 'package:localchess/product/constant/radius/app_radius_constant.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/theme/app_theme.dart';

/// The dark theme configuration for the application.
final class AppDarkTheme implements AppTheme {
  final ThemeData _theme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColorScheme.darkColorScheme,
  );

  @override
  ThemeData get theme => _theme.copyWith(
        scaffoldBackgroundColor: Colors.grey.shade800,
        cardTheme: cardTheme,
        appBarTheme: appBarTheme,
        dialogTheme: dialogTheme,
      );

  @override
  CardTheme get cardTheme => _theme.cardTheme.copyWith();

  @override
  AppBarTheme get appBarTheme => _theme.appBarTheme.copyWith();

  @override
  DialogTheme get dialogTheme => _theme.dialogTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadiusConstant.dialogCornerRadius,
          ),
        ),
      );
}