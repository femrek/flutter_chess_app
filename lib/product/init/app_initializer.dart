import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/dependency_injection/app_get_it_configurer.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// [AppInitializer] is for performing the processes have to be done before the
/// app starts.
abstract final class AppInitializer {
  /// Initializes the app. Call before [runApp] with await.
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _init();
  }

  static Future<void> _init() async {
    // dependency injection
    await AppGetItConfigurer.init();

    // localization
    await EasyLocalization.ensureInitialized();

    // error handling
    FlutterError.onError = (details) {
      G.logger.e(
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      G.logger.e(
        error.toString(),
        error: error,
        stackTrace: stack,
      );
      return true;
    };

    G.logger.d('App initialized.');
  }
}
