// ignore_for_file: public_member_api_docs

import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';

abstract class LocalGameState {}

class LocalGameInitialState extends LocalGameState {}

class LocalGameLoadedState extends LocalGameState {
  LocalGameLoadedState({
    required this.chessService,
  });

  /// The chess service.
  final IChessService chessService;

  /// The game save data.
  LocalGameSaveCacheModel? get save => chessService.save;
}
