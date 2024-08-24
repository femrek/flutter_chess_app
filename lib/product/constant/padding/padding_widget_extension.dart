import 'package:flutter/material.dart';

/// Extension for [EdgeInsets] to convert it to a [Widget].
extension PaddingWidgetExtension on EdgeInsets {
  /// Converts the [EdgeInsets] to a [Widget] with the given [child]. [key] is
  /// optional.
  Padding toWidget({required Widget child, Key? key}) {
    return Padding(
      key: key,
      padding: this,
      child: child,
    );
  }
}
