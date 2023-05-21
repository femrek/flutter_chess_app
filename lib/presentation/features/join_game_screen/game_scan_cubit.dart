import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/game_search_information.dart';
import 'package:localchess/provider/game_scanner.dart';
import 'package:localchess/provider/platform/model/local_ip.dart';
import 'package:localchess/provider/platform/platform.dart';

class GameScanCubit extends Cubit<GameScanState> {
  GameScanCubit() : super(GameScanState(
    searchStatus: SearchStatus.init,
    games: const [],
  ));

  startScan() async {
    emit(GameScanState(
      searchStatus: SearchStatus.searching,
      games: [],
    ));
    final LocalIp localIp = await getLocalIp();
    emit(GameScanState(
      searchStatus: SearchStatus.searching,
      games: await GameScanner().scan(localIp.address, localIp.maskLength),
    ));
    finishScan();
  }

  finishScan() {
    emit(GameScanState(
      searchStatus: SearchStatus.searched,
      games: state.games,
    ));
  }
}

class GameScanState {
  final SearchStatus searchStatus;
  final List<GameSearchInformation> games;

  GameScanState({
    required this.searchStatus,
    required this.games,
  });
}

enum SearchStatus {
  init,
  searching,
  searched,
}