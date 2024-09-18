import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/button/app_button/app_button_state_mixin.dart';

/// The callback when the button is pressed
typedef FutureVoidCallback = FutureOr<void> Function();

/// The button of the app.
class AppButton extends StatefulWidget {
  /// The button of the app.
  const AppButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.fullWidth = false,
    super.key,
  });

  /// Set true if the button should cover the parent
  final bool fullWidth;

  /// The callback when the button is pressed
  final FutureVoidCallback onPressed;

  /// The background color of the button
  final Color? backgroundColor;

  /// The child of the button
  final Widget child;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends BaseState<AppButton> with AppButtonStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: () async {
          if (isLoadingNotifier.value) return;
          isLoadingNotifier.value = true;
          await widget.onPressed();
          isLoadingNotifier.value = false;
        },
        style: ElevatedButton.styleFrom(
          padding: const AppPadding.button(),
          backgroundColor: widget.backgroundColor,
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoadingNotifier,
          builder: (BuildContext context, bool isLoading, Widget? child) {
            return isLoading
                ? const _LoadingIndicator()
                : child ?? widget.child;
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(),
    );
  }
}
