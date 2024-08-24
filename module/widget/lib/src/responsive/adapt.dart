import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Widget that adapts to mobile and tablet screen sizes.
class Adapt extends StatelessWidget {
  /// Initializes the adapt mobile view.
  const Adapt({
    required this.mobile,
    required this.tablet,
    super.key,
  });

  /// The mobile view.
  final Widget mobile;

  /// The tablet view.
  final Widget tablet;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) return mobile;
    if (ResponsiveBreakpoints.of(context).isTablet) return tablet;

    log(
      'Adapt: Unsupported screen size',
      stackTrace: StackTrace.current,
    );
    return tablet;
  }
}
