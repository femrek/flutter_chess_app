import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:widget/src/responsive/custom_responsive.dart';

/// Widget that adapts to mobile and tablet screen sizes.
class AdaptWholeScreen extends StatelessWidget {
  /// Initializes the adapt mobile view.
  const AdaptWholeScreen({
    required this.mobile,
    required this.tablet,
    this.overflowColor,
    super.key,
  });

  /// The mobile view.
  final Widget mobile;

  /// The tablet view.
  final Widget tablet;

  /// The color of the side overflow if the screen is bigger than the tablet.
  final Color? overflowColor;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) return mobile;
    if (ResponsiveBreakpoints.of(context).isTablet) return tablet;

    log(
      'AdaptWholeScreen: Unsupported screen size',
      stackTrace: StackTrace.current,
    );
    return ColoredBox(
      color: overflowColor ?? Colors.black,
      child: Row(
        children: [
          const Spacer(),
          SizedBox(
            width: CustomResponsive.tabletTop,
            child: tablet,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
