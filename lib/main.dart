import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/presentation/features/local_game/redoable_cubit.dart';
import 'package:mychess/presentation/features/local_net_game/host_checkmate_cubit.dart';
import 'package:mychess/presentation/features/local_net_game/local_host_bloc.dart';
import 'package:mychess/presentation/features/local_net_game/local_host_event.dart';
import 'package:mychess/presentation/features/local_net_game/screen_local_network_game.dart';

import 'presentation/features/local_game/checkmate_cubit.dart';
import 'presentation/features/local_game/board_bloc.dart';
import 'presentation/features/local_game/board_event.dart';
import 'presentation/features/local_game/screen_local_game.dart';
import 'presentation/features/main_screen/screen_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  CheckmateCubit checkmateCubit;
  RedoableCubit redoableCubit;
  BoardBloc boardBloc;
  HostCheckmateCubit hostCheckmateCubit;
  LocalHostBloc localHostBloc;

  @override
  Widget build(BuildContext context) {
    checkmateCubit = CheckmateCubit();
    redoableCubit = RedoableCubit();
    boardBloc = BoardBloc(checkmateCubit, redoableCubit);
    hostCheckmateCubit = HostCheckmateCubit();
    localHostBloc = LocalHostBloc(hostCheckmateCubit);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: boardBloc..add(BoardLoadEvent()),
        ),
        BlocProvider.value(
          value: checkmateCubit,
        ),
        BlocProvider.value(
          value: redoableCubit,
        ),
        BlocProvider.value(
          value: localHostBloc..add(LocalHostLoadEvent()),
        ),
        BlocProvider.value(
          value: hostCheckmateCubit,
        ),
      ],
      child: MaterialApp(
        title: 'Chess',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (_) => ScreenMain(),
          '/local_game': (_) => ScreenLocalGame(),
          '/local_net_game': (_) => ScreenLocalNetGame(),
        },
      ),
    );
  }
}
