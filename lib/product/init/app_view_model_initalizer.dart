import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';

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
      value: GetIt.I<AppViewModel>(),
      child: child,
    );
  }
}
