import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/features/local_game/checkmate_cubit.dart';
import 'presentation/features/local_game/board_bloc.dart';
import 'presentation/features/local_game/board_event.dart';
import 'presentation/features/local_game/screen_local_game.dart';
import 'presentation/features/main_screen/screen_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  CheckmateCubit checkmateCubit;
  BoardBloc boardBloc;

  @override
  Widget build(BuildContext context) {
    checkmateCubit = CheckmateCubit();
    boardBloc = BoardBloc(checkmateCubit);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: boardBloc..add(BoardLoadEvent()),
        ),
        BlocProvider.value(
          value: checkmateCubit,
        ),
      ],
      child: MaterialApp(
        title: 'Chess',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ScreenMain(),
      ),
    );
  }
}
