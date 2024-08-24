import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/init/app_initializer.dart';
import 'package:localchess/product/localization/app_localization.dart';
import 'package:localchess/product/navigation/app_route.dart';
import 'package:localchess/product/theme/app_light_theme.dart';
import 'package:widget/widget.dart';

void main() async {
  await AppInitializer.init();

  runApp(AppLocalization(
    child: const App(),
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
      routerConfig: AppRoute().config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: CustomResponsive.builder,
      theme: AppLightTheme().theme,
      darkTheme: AppLightTheme().theme,
    );
  }
}
