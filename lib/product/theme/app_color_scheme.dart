// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// The color scheme of the application.
abstract final class AppColorScheme {
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: _primaryLightColor,
    secondary: _secondaryLightColor,
    surface: _surfaceLightColor,
    error: _errorLightColor,
    onPrimary: _onPrimaryLightColor,
    onSecondary: _onSecondaryLightColor,
    onSurface: _onSurfaceLightColor,
    onError: _onErrorLightColor,
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme(
    primary: _primaryDarkColor,
    secondary: _secondaryDarkColor,
    surface: _surfaceDarkColor,
    error: _errorDarkColor,
    onPrimary: _onPrimaryDarkColor,
    onSecondary: _onSecondaryDarkColor,
    onSurface: _onSurfaceDarkColor,
    onError: _onErrorDarkColor,
    brightness: Brightness.dark,
  );

  // Light theme colors
  static const Color _primaryLightColor = Colors.teal;
  static const Color _secondaryLightColor = Colors.teal;
  static const Color _surfaceLightColor = Colors.white;
  static const Color _errorLightColor = Colors.red;
  static const Color _onPrimaryLightColor = Colors.white;
  static const Color _onSecondaryLightColor = Colors.white;
  static const Color _onSurfaceLightColor = Colors.black;
  static const Color _onErrorLightColor = Colors.white;

  // Dark theme colors
  static final Color _primaryDarkColor = Colors.teal.shade300;
  static final Color _secondaryDarkColor = Colors.teal.shade800;
  static const Color _surfaceDarkColor = Colors.black54;
  static const Color _errorDarkColor = Colors.red;
  static const Color _onPrimaryDarkColor = Colors.white;
  static const Color _onSecondaryDarkColor = Colors.white;
  static const Color _onSurfaceDarkColor = Colors.white;
  static const Color _onErrorDarkColor = Colors.white;

  // Chess board colors
  static final Color boardBackgroundColor = Colors.teal.shade800;
  static const Color boardCoordinateTextColor = Colors.white;
  static const Color darkTileColor = Colors.teal;
  static const Color lightTileColor = Colors.white;
  static const Color blackPieceColor = Colors.black;
  static const Color whitePieceColor = Colors.orange;
  static const Color lastMoveEffectColor = Color(0x7F2196F3);
  static const Color attackableToThisBackgroundColor = Colors.red;
  static const Color inCheckBackgroundColor = Colors.red;
  static const Color moveFromBackgroundColor = Colors.green;
  static const Color moveDotsColor = Colors.green;
}
