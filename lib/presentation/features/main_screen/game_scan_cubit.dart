import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/game_search_information.dart';
import 'package:localchess/provider/game_scanner.dart';
import 'package:localchess/provider/platform/model/local_ip.dart';
import 'package:localchess/provider/platform/platform.dart';

class GameScanCubit extends Cubit<GameScanState> {
  GameScanCubit() : super(GameScanState(searching: false, games: const []));

  startScan() async {
    emit(GameScanState(searching: true, games: []));
    final LocalIp localIp = await getLocalIp();
    emit(GameScanState(
      searching: true,
      games: await GameScanner().scan(localIp.address, localIp.maskLength),
    ));
    stopScan();
  }

  stopScan() {
    emit(GameScanState(searching: false, games: state.games));
  }
}

class GameScanState {
  final bool searching;
  final List<GameSearchInformation> games;

  GameScanState({
    required this.searching,
    required this.games,
  });
}