import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding_constant.dart';

/// Standard padding values for the app. Use this class with named constructors.
class AppPadding extends EdgeInsets {
  /// Creates a new [AppPadding] with the given values.
  const AppPadding({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) : super.fromLTRB(left, top, right, bottom);

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

  /// Default card padding
  const AppPadding.card({double? horizontal, double? vertical})
      : super.symmetric(
          horizontal: horizontal ?? AppPaddingConstant.cardHorizontal,
          vertical: vertical ?? AppPaddingConstant.cardVertical,
        );

  /// Default list tile padding
  const AppPadding.listTile({double? horizontal, double? vertical})
      : super.symmetric(
          horizontal: horizontal ?? AppPaddingConstant.listTileHorizontal,
          vertical: vertical ?? AppPaddingConstant.listTileVertical,
        );

  @override
  AppPadding operator +(EdgeInsets other) {
    return AppPadding(
      left: left + other.left,
      top: top + other.top,
      right: right + other.right,
      bottom: bottom + other.bottom,
    );
  }

  @override
  AppPadding operator -(EdgeInsets other) {
    return AppPadding(
      left: left - other.left,
      top: top - other.top,
      right: right - other.right,
      bottom: bottom - other.bottom,
    );
  }
}
