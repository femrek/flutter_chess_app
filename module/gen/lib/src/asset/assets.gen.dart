/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetColorGen {
  const $AssetColorGen();

  /// File path: asset/color/colors.xml
  String get colors => 'asset/color/colors.xml';

  /// List of all assets
  List<String> get values => [colors];
}

class $AssetIconGen {
  const $AssetIconGen();

  /// File path: asset/icon/icon_bishop.svg
  SvgGenImage get iconBishop => const SvgGenImage('asset/icon/icon_bishop.svg');

  /// File path: asset/icon/icon_king.svg
  SvgGenImage get iconKing => const SvgGenImage('asset/icon/icon_king.svg');

  /// File path: asset/icon/icon_knight.svg
  SvgGenImage get iconKnight => const SvgGenImage('asset/icon/icon_knight.svg');

  /// File path: asset/icon/icon_pawn.svg
  SvgGenImage get iconPawn => const SvgGenImage('asset/icon/icon_pawn.svg');

  /// File path: asset/icon/icon_queen.svg
  SvgGenImage get iconQueen => const SvgGenImage('asset/icon/icon_queen.svg');

  /// File path: asset/icon/icon_rok.svg
  SvgGenImage get iconRok => const SvgGenImage('asset/icon/icon_rok.svg');

  /// List of all assets
  List<SvgGenImage> get values =>
      [iconBishop, iconKing, iconKnight, iconPawn, iconQueen, iconRok];
}

class Assets {
  Assets._();

  static const $AssetColorGen color = $AssetColorGen();
  static const $AssetIconGen icon = $AssetIconGen();
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
