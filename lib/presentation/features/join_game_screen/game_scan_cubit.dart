import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/game_search_information.dart';
import 'package:localchess/provider/game_scanner.dart';
import 'package:localchess/provider/network_info_provider.dart';

class GameScanCubit extends Cubit<GameScanState> {
  GameScanCubit() : super(GameScanState(
    searchStatus: SearchStatus.init,
    games: const [],
  ));

  /// return true if scan is successful
  Future<bool> startScan() async {
    emit(GameScanState(
      searchStatus: SearchStatus.searching,
      games: [],
    ));
    final String? inet = await NetworkInfoProvider().getInetAddress();
    final String? submask = await NetworkInfoProvider().getSubmask();
    if (inet == null) return false;
    if (submask == null) return false;
    emit(GameScanState(
      searchStatus: SearchStatus.searching,
      games: await GameScanner().scan(inet, submask),
    ));
    finishScan();
    return true;
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