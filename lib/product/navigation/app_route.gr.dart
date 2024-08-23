// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:localchess/feature/guest_game/view/guest_game_screen.dart'
    as _i1;
import 'package:localchess/feature/home/view/home_screen.dart' as _i2;
import 'package:localchess/feature/host_game/view/host_game_screen.dart' as _i3;
import 'package:localchess/feature/join/view/join_game_screen.dart' as _i4;
import 'package:localchess/feature/local_game/view/local_game_screen.dart'
    as _i5;
import 'package:localchess/feature/setup_host/view/setup_host_screen.dart'
    as _i6;

/// generated route for
/// [_i1.GuestGameScreen]
class GuestGameRoute extends _i7.PageRouteInfo<void> {
  const GuestGameRoute({List<_i7.PageRouteInfo>? children})
      : super(
          GuestGameRoute.name,
          initialChildren: children,
        );

  static const String name = 'GuestGameRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.GuestGameScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeScreen();
    },
  );
}

/// generated route for
/// [_i3.HostGameScreen]
class HostGameRoute extends _i7.PageRouteInfo<void> {
  const HostGameRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HostGameRoute.name,
          initialChildren: children,
        );

  static const String name = 'HostGameRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.HostGameScreen();
    },
  );
}

/// generated route for
/// [_i4.JoinScreen]
class JoinRoute extends _i7.PageRouteInfo<void> {
  const JoinRoute({List<_i7.PageRouteInfo>? children})
      : super(
          JoinRoute.name,
          initialChildren: children,
        );

  static const String name = 'JoinRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.JoinScreen();
    },
  );
}

/// generated route for
/// [_i5.LocalGameScreen]
class LocalGameRoute extends _i7.PageRouteInfo<void> {
  const LocalGameRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LocalGameRoute.name,
          initialChildren: children,
        );

  static const String name = 'LocalGameRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.LocalGameScreen();
    },
  );
}

/// generated route for
/// [_i6.SetupHostScreen]
class SetupHostRoute extends _i7.PageRouteInfo<void> {
  const SetupHostRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SetupHostRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetupHostRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SetupHostScreen();
    },
  );
}
