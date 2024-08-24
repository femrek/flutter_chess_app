import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:localchess/product/dependency_injection/app_get_it.dart';

/// [AppInitializer] is for performing the processes have to be done before the
/// app starts.
abstract final class AppInitializer {
  /// Initializes the app. Call before [runApp] with await.
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _init();
  }

  static Future<void> _init() async {
    // localization
    await EasyLocalization.ensureInitialized();

    // dependency injection
    AppGetIt.I.init();
  }
}
