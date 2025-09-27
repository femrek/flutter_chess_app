part of 'app_theme.dart';

/// The dark theme configuration for the application.
final class AppDarkTheme extends AppTheme {
  @override
  ColorScheme get colorScheme => AppColorScheme.darkColorScheme;

  @override
  Color get scaffoldBackgroundColor =>
      AppColorScheme.darkScaffoldBackgroundColor;

  @override
  CardThemeData get cardTheme => _theme.cardTheme.copyWith();

  @override
  AppBarThemeData get appBarTheme => _theme.appBarTheme.copyWith();

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
        style: ElevatedButton.styleFrom(),
      );
}
