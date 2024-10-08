import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/init/app_initializer.dart';
import 'package:localchess/product/init/app_view_model_initalizer.dart';
import 'package:localchess/product/localization/app_localization.dart';
import 'package:localchess/product/state/app_view_model/app_view_model.dart';
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
      routerConfig: G.appRoute.config(),

      // localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // responsive
      builder: CustomResponsive.builder,

      // theme
      theme: G.appLightTheme.theme,
      darkTheme: G.appDarkTheme.theme,
      themeMode: context.watch<AppViewModel>().state.themeMode,
    );
  }
}
