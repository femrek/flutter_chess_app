import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

/// [AppInitializer] is for performing the processes have to be done before the
/// app starts.
abstract final class AppInitializer {
  /// Initializes the app. Call before [runApp] with await.
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _init();
  }

  static Future<void> _init() async {
    await EasyLocalization.ensureInitialized();
  }
}
