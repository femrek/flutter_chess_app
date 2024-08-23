// ignore_for_file: sort_constructors_first

import 'package:auto_route/auto_route.dart';
import 'package:localchess/product/navigation/app_route.gr.dart';

/// The main router of the application
@AutoRouterConfig(replaceInRouteName: AppRoute._replaceInRouteName)
class AppRoute extends RootStackRouter {
  static const String _replaceInRouteName = 'Screen,Route';

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: JoinRoute.page),
        AutoRoute(page: SetupHostRoute.page),
        AutoRoute(page: HostGameRoute.page),
        AutoRoute(page: GuestGameRoute.page),
        AutoRoute(page: LocalGameRoute.page),
      ];

  /// factory method to get the singleton instance
  factory AppRoute() => _instance ??= AppRoute._();

  /// singleton instance
  static AppRoute? _instance;

  /// private constructor
  AppRoute._();
}
