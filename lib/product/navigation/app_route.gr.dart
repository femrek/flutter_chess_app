// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:core/core.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:localchess/feature/guest_game/view/guest_game_screen.dart'
    as _i1;
import 'package:localchess/feature/home/view/home_screen.dart' as _i2;
import 'package:localchess/feature/host_game/view/host_game_screen.dart' as _i3;
import 'package:localchess/feature/local_game/view/local_game_screen.dart'
    as _i4;
import 'package:localchess/feature/setup_host/view/setup_host_screen.dart'
    as _i5;
import 'package:localchess/feature/setup_join/view/setup_join_screen.dart'
    as _i6;
import 'package:localchess/feature/setup_local/view/setup_local_screen.dart'
    as _i7;
import 'package:localchess/product/cache/model/game_save_cache_model.dart'
    as _i11;
import 'package:localchess/product/data/player_color.dart' as _i12;

/// generated route for
/// [_i1.GuestGameScreen]
class GuestGameRoute extends _i8.PageRouteInfo<GuestGameRouteArgs> {
  GuestGameRoute({
    required _i9.AddressOnNetwork hostAddress,
    _i10.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          GuestGameRoute.name,
          args: GuestGameRouteArgs(
            hostAddress: hostAddress,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'GuestGameRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GuestGameRouteArgs>();
      return _i1.GuestGameScreen(
        hostAddress: args.hostAddress,
        key: args.key,
      );
    },
  );
}

class GuestGameRouteArgs {
  const GuestGameRouteArgs({
    required this.hostAddress,
    this.key,
  });

  final _i9.AddressOnNetwork hostAddress;

  final _i10.Key? key;

  @override
  String toString() {
    return 'GuestGameRouteArgs{hostAddress: $hostAddress, key: $key}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeScreen();
    },
  );
}

/// generated route for
/// [_i3.HostGameScreen]
class HostGameRoute extends _i8.PageRouteInfo<HostGameRouteArgs> {
  HostGameRoute({
    required _i11.GameSaveCacheModel save,
    required _i12.PlayerColor chosenColor,
    _i10.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          HostGameRoute.name,
          args: HostGameRouteArgs(
            save: save,
            chosenColor: chosenColor,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'HostGameRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HostGameRouteArgs>();
      return _i3.HostGameScreen(
        save: args.save,
        chosenColor: args.chosenColor,
        key: args.key,
      );
    },
  );
}

class HostGameRouteArgs {
  const HostGameRouteArgs({
    required this.save,
    required this.chosenColor,
    this.key,
  });

  final _i11.GameSaveCacheModel save;

  final _i12.PlayerColor chosenColor;

  final _i10.Key? key;

  @override
  String toString() {
    return 'HostGameRouteArgs{save: $save, chosenColor: $chosenColor, key: $key}';
  }
}

/// generated route for
/// [_i4.LocalGameScreen]
class LocalGameRoute extends _i8.PageRouteInfo<LocalGameRouteArgs> {
  LocalGameRoute({
    required _i11.GameSaveCacheModel save,
    _i10.Key? key,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          LocalGameRoute.name,
          args: LocalGameRouteArgs(
            save: save,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'LocalGameRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocalGameRouteArgs>();
      return _i4.LocalGameScreen(
        save: args.save,
        key: args.key,
      );
    },
  );
}

class LocalGameRouteArgs {
  const LocalGameRouteArgs({
    required this.save,
    this.key,
  });

  final _i11.GameSaveCacheModel save;

  final _i10.Key? key;

  @override
  String toString() {
    return 'LocalGameRouteArgs{save: $save, key: $key}';
  }
}

/// generated route for
/// [_i5.SetupHostScreen]
class SetupHostRoute extends _i8.PageRouteInfo<void> {
  const SetupHostRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SetupHostRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetupHostRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.SetupHostScreen();
    },
  );
}

/// generated route for
/// [_i6.SetupJoinScreen]
class SetupJoinRoute extends _i8.PageRouteInfo<void> {
  const SetupJoinRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SetupJoinRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetupJoinRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SetupJoinScreen();
    },
  );
}

/// generated route for
/// [_i7.SetupLocalScreen]
class SetupLocalRoute extends _i8.PageRouteInfo<void> {
  const SetupLocalRoute({List<_i8.PageRouteInfo>? children})
      : super(
          SetupLocalRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetupLocalRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SetupLocalScreen();
    },
  );
}
