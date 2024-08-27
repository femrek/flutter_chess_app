// ignore_for_file: public_member_api_docs

import 'package:get_it/get_it.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
import 'package:localchess/product/theme/app_dark_theme.dart';
import 'package:localchess/product/theme/app_light_theme.dart';
import 'package:logger/logger.dart';

abstract final class G {
  static final _getIt = GetIt.I;

  static Logger get logger => _getIt<Logger>();

  static AppViewModel get appViewModel => _getIt<AppViewModel>();

  static AppDarkTheme get appDarkTheme => _getIt<AppDarkTheme>();

  static AppLightTheme get appLightTheme => _getIt<AppLightTheme>();
}
