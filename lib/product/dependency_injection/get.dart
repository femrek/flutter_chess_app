// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_view_model.dart';
import 'package:localchess/feature/host_game/view_model/host_game_view_model.dart';
import 'package:localchess/feature/local_game/view_model/local_game_view_model.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_view_model.dart';
import 'package:localchess/feature/setup_join/view_model/setup_join_view_model.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/device_properties/i_device_properties.dart';
import 'package:localchess/product/navigation/app_route.dart';
import 'package:localchess/product/network/core/i_socket_configuration.dart';
import 'package:localchess/product/service/core/i_network_game_scanner_service.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
import 'package:localchess/product/theme/app_dark_theme.dart';
import 'package:localchess/product/theme/app_light_theme.dart';
import 'package:logger/logger.dart';

/// [G] is the static class to access instances from [GetIt].
abstract final class G {
  static final _getIt = GetIt.I;

  // logger
  static Logger get logger => _getIt<Logger>();

  // route
  static AppRoute get appRoute => _getIt<AppRoute>();

  // theme
  static AppDarkTheme get appDarkTheme => _getIt<AppDarkTheme>();

  static AppLightTheme get appLightTheme => _getIt<AppLightTheme>();

  static CacheManager get cacheManager => _getIt<CacheManager>();

  // cache
  static IAppCache get appCache => _getIt<IAppCache>();

  // network
  static ISocketConfiguration get socketConfiguration =>
      _getIt<ISocketConfiguration>();

  static INetworkInfoProvider get networkInfoProvider =>
      _getIt<INetworkInfoProvider>();

  static INetworkGameScannerService get networkGameScannerService =>
      _getIt<INetworkGameScannerService>();

  // device properties
  static IDeviceProperties get deviceProperties => _getIt<IDeviceProperties>();

  // view model
  static AppViewModel get appViewModel => _getIt<AppViewModel>();

  static SetupLocalViewModel get setupLocalViewModel =>
      _getIt<SetupLocalViewModel>();

  static SetupHostViewModel get setupHostViewModel =>
      _getIt<SetupHostViewModel>();

  static SetupJoinViewModel get setupJoinViewModel =>
      _getIt<SetupJoinViewModel>();

  static LocalGameViewModel get localGameViewModel =>
      _getIt<LocalGameViewModel>();

  static HostGameViewModel get hostGameViewModel => _getIt<HostGameViewModel>();

  static GuestGameViewModel get guestGameViewModel =>
      _getIt<GuestGameViewModel>();
}
