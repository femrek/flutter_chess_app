import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The state model for app general view model
class AppState extends Equatable {
  /// The state model for app general view model
  const AppState({this.themeMode = ThemeMode.system});

  /// The theme mode
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode.index];
}
