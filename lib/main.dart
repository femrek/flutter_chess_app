import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/init/app_initializer.dart';
import 'package:localchess/product/init/app_view_model_initalizer.dart';
import 'package:localchess/product/localization/app_localization.dart';
import 'package:localchess/product/navigation/app_route.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
import 'package:localchess/product/theme/app_dark_theme.dart';
import 'package:localchess/product/theme/app_light_theme.dart';
import 'package:widget/widget.dart';

void main() async {
  await AppInitializer.init();

  runApp(AppLocalization(
    child: const AppViewModelInitializer(
      child: App(),
    ),
  ));
}

/// The main application widget.
class App extends StatelessWidget {
  /// The main application widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // navigation
      routerConfig: AppRoute().config(),

      // localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // responsive
      builder: CustomResponsive.builder,

      // theme
      theme: GetIt.I<AppLightTheme>().theme,
      darkTheme: GetIt.I<AppDarkTheme>().theme,
      themeMode: GetIt.I<AppViewModel>().state.themeMode,
    );
  }
}
