import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// Wrap the main app widget with this widget to initialize the app view model.
class AppViewModelInitializer extends StatelessWidget {
  /// Wrap the main app widget with this widget to initialize the app view
  /// model.
  const AppViewModelInitializer({
    required this.child,
    super.key,
  });

  /// The child widget to wrap.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: G.appViewModel,
      child: child,
    );
  }
}
