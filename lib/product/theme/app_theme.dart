import 'package:flutter/material.dart';

/// Specifies the app theme.
abstract interface class AppTheme {
  /// The theme data have to be specified.
  ThemeData get theme;

  /// The card theme have to be specified.
  CardTheme get cardTheme;

  /// The app bar theme have to be specified.
  AppBarTheme get appBarTheme;

  /// The dialog theme have to be specified.
  DialogTheme get dialogTheme;
}
