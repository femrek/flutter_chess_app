import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localchess/product/dependency_injection/app_get_it_configurer.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/init/app_error_handler.dart';
import 'package:logger/logger.dart';

/// [AppInitializer] is for performing the processes have to be done before the
/// app starts.
abstract final class AppInitializer {
  /// Initializes the app. Call before [runApp] with await.
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _init();
  }

  static Future<void> _init() async {
    // error handling
    AppErrorHandler.init();

    // dependency injection
    await AppGetItConfigurer.init();

    // localization
    await EasyLocalization.ensureInitialized();

    // cache
    await G.appStorage.init();

    // device id
    G.deviceProperties.init();

    // app view model
    G.appViewModel.init();

    // prevent landscape mode
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Logger.level = Level.trace;
    G.logger.d('App initialized.');
  }
}
