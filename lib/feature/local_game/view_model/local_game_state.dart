// ignore_for_file: public_member_api_docs

import 'package:chess/chess.dart' as ch;
import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';

class LocalGameState {
  LocalGameState({
    LocalGameSaveCacheModel? save,
  }) {
    _save = save;
    if (save == null) return;
    final currentState = save.localGameSave.currentState;
    if (currentState == null) {
      chess = ch.Chess();
    } else {
      chess = ch.Chess.fromFEN(currentState);
    }
  }

  late final LocalGameSaveCacheModel? _save;
  late final ch.Chess chess;

  CacheModelMetaData? get saveMetaData => _save?.metaData;

  LocalGameSave? get save => _save?.localGameSave;
}
