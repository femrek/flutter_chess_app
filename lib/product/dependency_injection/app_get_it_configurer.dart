import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_view_model.dart';
import 'package:localchess/feature/host_game/view_model/host_game_view_model.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_view_model.dart';
import 'package:localchess/feature/setup_join/view_model/setup_join_view_model.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/device_properties/app_device_properties.dart';
import 'package:localchess/product/device_properties/i_device_properties.dart';
import 'package:localchess/product/navigation/app_route.dart';
import 'package:localchess/product/network/core/i_socket_configuration.dart';
import 'package:localchess/product/network/impl/app_socket_configuration.dart';
import 'package:localchess/product/service/core/i_network_game_scanner_service.dart';
import 'package:localchess/product/service/impl/network_game_scanner_service.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
import 'package:localchess/product/storage/app_storage.dart';
import 'package:localchess/product/storage/i_app_storage.dart';
import 'package:localchess/product/theme/app_theme.dart';
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
      ..registerLazySingleton<StorageManager>(HiveStorageManager.new)
      ..registerLazySingleton<IAppStorage>(() => AppStorage(
            storageManager: GetIt.I<StorageManager>(),
            logger: GetIt.I<Logger>(),
          ))

      // network
      ..registerLazySingleton<ISocketConfiguration>(AppSocketConfiguration.new)
      ..registerLazySingleton<INetworkInfoProvider>(NetworkInfoProvider.new)
      ..registerLazySingleton<INetworkGameScannerService>(
          NetworkGameScannerService.new)

      // configuration
      ..registerLazySingleton<IDeviceProperties>(AppDeviceProperties.new)

      // view model
      ..registerLazySingleton<AppViewModel>(AppViewModel.new)
      ..registerLazySingleton<SetupLocalViewModel>(() => SetupLocalViewModel(
            appStorage: GetIt.I<IAppStorage>(),
          ))
      ..registerLazySingleton<SetupHostViewModel>(() => SetupHostViewModel(
            appStorage: GetIt.I<IAppStorage>(),
          ))
      ..registerLazySingleton(SetupJoinViewModel.new)
      ..registerLazySingleton(LocalGameViewModel.new)
      ..registerLazySingleton(HostGameViewModel.new)
      ..registerLazySingleton(GuestGameViewModel.new);
  }
}
