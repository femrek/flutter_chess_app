import 'package:flutter/material.dart';

/// Converts the [ThemeMode] to and from JSON.
extension ThemeModeJsonConverter on ThemeMode {
  /// Converts the [ThemeMode] to a string.
  String toJson() {
    switch (this) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  /// Converts the string to a [ThemeMode].
  static ThemeMode fromJson(String? json) {
    switch (json) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
