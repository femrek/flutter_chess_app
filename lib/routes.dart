import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/presentation/features/host_game/find_ip_cubit.dart';

import 'presentation/features/host_game/screen_host_game.dart';
import 'presentation/features/local_game/screen_local_game.dart';
import 'presentation/features/local_game/board_bloc.dart';
import 'presentation/features/local_game/board_event.dart';
import 'presentation/features/local_game/redoable_cubit.dart';
import 'presentation/features/local_game/turn_cubit.dart';
import 'presentation/features/host_game/host_redoable_cubit.dart';
import 'presentation/features/host_game/host_turn_cubit.dart';
import 'presentation/features/host_game/host_bloc.dart';
import 'presentation/features/host_game/host_event.dart';
import 'presentation/features/guest_game/guest_bloc.dart';
import 'presentation/features/guest_game/guest_event.dart';
import 'presentation/features/guest_game/screen_guest_game.dart';
import 'presentation/features/main_screen/screen_main.dart';

const String screenMain = '/';
const String screenLocalGame = '/local_game';
const String screenHostGame = '/local_net_game';
const String screenGuestGame = '/local_guest_game';

RedoableCubit _redoableCubit = RedoableCubit();
TurnCubit _turnCubit = TurnCubit();
BoardBloc _boardBloc = BoardBloc(_redoableCubit, _turnCubit);
HostRedoableCubit _hostRedoableCubit = HostRedoableCubit();
FindIpCubit _findIpCubit = FindIpCubit();
HostTurnCubit _hostTurnCubit = HostTurnCubit();
HostBloc _localHostBloc = HostBloc(_hostRedoableCubit, _findIpCubit, _hostTurnCubit);
GuestBloc _guestBloc = GuestBloc();



class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case screenMain:
        return MaterialPageRoute(builder: (_) => ScreenMain());
      case screenLocalGame:
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: _boardBloc..add(BoardLoadEvent()),
            ),
            BlocProvider.value(
              value: _redoableCubit,
            ),
            BlocProvider.value(
              value: _turnCubit,
            ),
          ],
          child: ScreenLocalGame(),
        ));
      case screenHostGame:
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: _localHostBloc..add(HostLoadEvent()),
            ),
            BlocProvider.value(
              value: _hostRedoableCubit,
            ),
            BlocProvider.value(
              value: _findIpCubit,
            ),
            BlocProvider.value(
              value: _hostTurnCubit,
            ),
          ],
          child: ScreenHostGame(),
        ));
      case screenGuestGame:
        final List arg = settings.arguments; // [String host, int port]
        _guestBloc.add(GuestConnectEvent(
          host: arg[0],
          port: arg[1],
        ));
        return MaterialPageRoute(builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: _guestBloc,
            ),
          ],
          child: ScreenGuestGame(),
        ));
      default:
        throw Exception('route not found');
    }
  }
}
