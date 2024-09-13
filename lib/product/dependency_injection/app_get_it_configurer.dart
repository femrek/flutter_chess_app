import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_view_model.dart';
import 'package:localchess/feature/host_game/view_model/host_game_view_model.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_view_model.dart';
import 'package:localchess/feature/setup_join/view_model/setup_join_view_model.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/cache/app_cache.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/device_properties/app_device_properties.dart';
import 'package:localchess/product/navigation/app_route.dart';
import 'package:localchess/product/network/impl/app_socket_configuration.dart';
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

      // navigation
      ..registerLazySingleton<AppRoute>(AppRoute.new)

      // theme
      ..registerLazySingleton<AppDarkTheme>(AppDarkTheme.new)
      ..registerLazySingleton<AppLightTheme>(AppLightTheme.new)

      // cache
      ..registerLazySingleton<CacheManager>(HiveCacheManager.new)
      ..registerLazySingleton<IAppCache>(() => AppCache(
            cacheManager: GetIt.I<CacheManager>(),
            logger: GetIt.I<Logger>(),
          ))

      // network
      ..registerLazySingleton<ISocketConfiguration>(AppSocketConfiguration.new)
      ..registerLazySingleton<INetworkInfoProvider>(NetworkInfoProvider.new)

      // configuration
      ..registerLazySingleton<IDeviceProperties>(AppDeviceProperties.new)

      // view model
      ..registerLazySingleton<AppViewModel>(AppViewModel.new)
      ..registerLazySingleton<SetupLocalViewModel>(() => SetupLocalViewModel(
            appCache: GetIt.I<IAppCache>(),
          ))
      ..registerLazySingleton<SetupHostViewModel>(() => SetupHostViewModel(
            appCache: GetIt.I<IAppCache>(),
          ))
      ..registerLazySingleton(SetupJoinViewModel.new)
      ..registerLazySingleton(LocalGameViewModel.new)
      ..registerLazySingleton(HostGameViewModel.new)
      ..registerLazySingleton(GuestGameViewModel.new);
  }
}
