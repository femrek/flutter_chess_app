import 'package:get_it/get_it.dart';

/// [AppGetItConfigurer] is the configuration class to setup instances with
/// [GetIt].
abstract final class AppGetItConfigurer {
  /// Initializes the dependency injection.
  static Future<void> init() async {}
}
