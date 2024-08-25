import 'package:flutter/material.dart';
import 'package:localchess/product/state/app_view_model/app_state.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the app. Be used for app-wide state management.
class AppViewModel extends BaseCubit<AppState> {
  /// The view model for the app.
  AppViewModel() : super(const AppState());

  /// Toggles the theme mode.
  void toggleThemeMode(BuildContext context) {
    late final ThemeMode newThemeMode;
    if (state.themeMode == ThemeMode.system) {
      final systemMode = MediaQuery.of(context).platformBrightness;
      newThemeMode =
          systemMode == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    } else if (state.themeMode == ThemeMode.light) {
      newThemeMode = ThemeMode.dark;
    } else if (state.themeMode == ThemeMode.dark) {
      newThemeMode = ThemeMode.light;
    }
    emit(AppState(themeMode: newThemeMode));
  }

  /// Sets the theme mode.
  void setThemeMode(ThemeMode themeMode) {
    emit(AppState(themeMode: themeMode));
  }
}
