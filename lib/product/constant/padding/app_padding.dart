import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding_constant.dart';

/// Standard padding values for the app. Use this class with named constructors.
class AppPadding extends EdgeInsets {
  /// Default button padding
  const AppPadding.button({double? horizontal, double? vertical})
      : super.symmetric(
          horizontal: horizontal ?? AppPaddingConstant.buttonHorizontal,
          vertical: vertical ?? AppPaddingConstant.buttonVertical,
        );

  /// Default screen padding
  const AppPadding.screen({double? horizontal, double? vertical})
      : super.symmetric(
          horizontal: horizontal ?? AppPaddingConstant.screenHorizontal,
          vertical: vertical ?? AppPaddingConstant.screenVertical,
        );

  /// Default scrollable padding
  const AppPadding.scrollable({double? horizontal, double? vertical})
      : super.symmetric(
          horizontal: horizontal ?? AppPaddingConstant.scrollableHorizontal,
          vertical: vertical ?? AppPaddingConstant.scrollableVertical,
        );
}
