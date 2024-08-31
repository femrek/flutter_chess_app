// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/cache/app_cache.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
import 'package:localchess/product/theme/app_dark_theme.dart';
import 'package:localchess/product/theme/app_light_theme.dart';
import 'package:logger/logger.dart';

/// [G] is the static class to access instances from [GetIt].
abstract final class G {
  static final _getIt = GetIt.I;

  static Logger get logger => _getIt<Logger>();

  static AppDarkTheme get appDarkTheme => _getIt<AppDarkTheme>();

  static AppLightTheme get appLightTheme => _getIt<AppLightTheme>();

  static CacheManager get cacheManager => _getIt<CacheManager>();

  static AppCache get appCache => _getIt<AppCache>();

  static AppViewModel get appViewModel => _getIt<AppViewModel>();

  static SetupLocalViewModel get setupLocalViewModel =>
      _getIt<SetupLocalViewModel>();

  static LocalGameViewModel get localGameViewModel =>
      _getIt<LocalGameViewModel>();
}
