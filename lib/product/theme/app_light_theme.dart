part of 'app_theme.dart';

/// The light theme configuration for the application.
final class AppLightTheme extends AppTheme {
  @override
  ColorScheme get colorScheme => AppColorScheme.lightColorScheme;

  @override
  Color get scaffoldBackgroundColor =>
      AppColorScheme.lightScaffoldBackgroundColor;

  @override
  CardThemeData get cardTheme => _theme.cardTheme.copyWith(
        color: _theme.colorScheme.surface,
      );

  @override
  AppBarTheme get appBarTheme => _theme.appBarTheme.copyWith(
        backgroundColor: _theme.primaryColor,
        foregroundColor: _theme.colorScheme.onPrimary,
      );

  @override
  DialogThemeData get dialogTheme => _theme.dialogTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppRadiusConstant.dialogCornerRadius,
          ),
        ),
      );

  @override
  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _theme.colorScheme.secondary,
          foregroundColor: _theme.colorScheme.onSecondary,
        ),
      );
}
