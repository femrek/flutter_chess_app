import 'package:get_it/get_it.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
import 'package:localchess/product/theme/app_dark_theme.dart';
import 'package:localchess/product/theme/app_light_theme.dart';

/// [AppGetItConfigurer] is the configuration class to setup instances with
/// [GetIt].
abstract final class AppGetItConfigurer {
  /// Initializes the dependency injection.
  static Future<void> init() async {
    GetIt.I
      // view model
      ..registerLazySingleton<AppViewModel>(AppViewModel.new)

      // theme
      ..registerLazySingleton<AppDarkTheme>(AppDarkTheme.new)
      ..registerLazySingleton<AppLightTheme>(AppLightTheme.new);
  }
}
