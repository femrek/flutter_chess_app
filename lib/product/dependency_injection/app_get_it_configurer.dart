import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/cache/app_cache.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
import 'package:localchess/product/theme/app_dark_theme.dart';
import 'package:localchess/product/theme/app_light_theme.dart';
import 'package:logger/logger.dart';

/// [AppGetItConfigurer] is the configuration class to setup instances with
/// [GetIt].
abstract final class AppGetItConfigurer {
  /// Initializes the dependency injection.
  static Future<void> init() async {
    GetIt.I
      // logger
      ..registerLazySingleton<Logger>(Logger.new)

      // view model
      ..registerLazySingleton<AppViewModel>(AppViewModel.new)

      // theme
      ..registerLazySingleton<AppDarkTheme>(AppDarkTheme.new)
      ..registerLazySingleton<AppLightTheme>(AppLightTheme.new)

      // cache
      ..registerLazySingleton<CacheManager>(HiveCacheManager.new)
      ..registerLazySingleton<AppCache>(() => AppCache(
            cacheManager: GetIt.I<CacheManager>(),
          ));
  }
}
