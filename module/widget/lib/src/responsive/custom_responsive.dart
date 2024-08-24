import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Responsive breakpoints for mobile, tablet, desktop, and 4K.
/// [MOBILE] 0-450
/// [TABLET] 451-800
/// [DESKTOP] 801-1920
/// [4K] 1921-infinity
final class CustomResponsive {
  /// The mobile top breakpoint.
  static const double mobileTop = 450;

  /// The tablet top breakpoint.
  static const double tabletTop = 800;

  /// The desktop top breakpoint.
  static const double desktopTop = 1920;

  /// Initializes the custom responsive.
  static Widget builder(
    BuildContext context,
    Widget? child,
  ) {
    return ResponsiveBreakpoints.builder(
      child: child!,
      breakpoints: [
        const Breakpoint(
          start: 0,
          end: mobileTop,
          name: MOBILE,
        ),
        const Breakpoint(
          start: mobileTop + 1,
          end: tabletTop,
          name: TABLET,
        ),
        const Breakpoint(
          start: tabletTop + 1,
          end: desktopTop,
          name: DESKTOP,
        ),
        const Breakpoint(
          start: desktopTop + 1,
          end: double.infinity,
          name: '4K',
        ),
      ],
    );
  }
}
