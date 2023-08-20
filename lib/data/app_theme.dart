import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get light {
    ThemeData theme = ThemeData.from(
      colorScheme: ColorScheme(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        background: _backgroundColor,
        error: _errorColor,
        onPrimary: _onPrimaryColor,
        onSecondary: _onSecondaryColor,
        onSurface: _onSurfaceColor,
        onBackground: _onBackgroundColor,
        onError: _onErrorColor,
        brightness: Brightness.light,
      ),
    );
    return theme.copyWith(
      disabledColor: Colors.grey.shade400,
      buttonTheme: theme.buttonTheme.copyWith(
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }

  static const Color _primaryColor = Colors.teal;
  static const Color _secondaryColor = Colors.teal;
  static const Color _surfaceColor = Colors.white;
  static const Color _backgroundColor = Color(0xFFE9E9E9);
  static const Color _errorColor = Colors.red;
  static const Color _onPrimaryColor = Colors.white;
  static const Color _onSecondaryColor = Colors.white;
  static const Color _onSurfaceColor = Colors.black;
  static const Color _onBackgroundColor = Colors.black;
  static const Color _onErrorColor = Colors.white;

  final Color boardBgColor = Colors.teal;
  final Color darkBgColor = Colors.teal;
  final Color lightBgColor = Colors.white;
  final Color blackPiecesColor = Colors.black;
  final Color whitePiecesColor = Colors.orange;
  final Color lastMoveEffect = Colors.blue.withOpacity(0.5);
  final Color attackableToThisBg = Colors.red;
  final Color inCheckBg = Colors.red;
  final Color moveFromBg = Colors.green;
  final Color moveDotsColor = Colors.green;

  // singleton
  static final AppTheme _appTheme = AppTheme._internal();

  factory AppTheme() => _appTheme;

  AppTheme._internal();
}
