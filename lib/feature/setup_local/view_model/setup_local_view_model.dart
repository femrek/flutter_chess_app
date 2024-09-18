import 'dart:async';

import 'package:chess/chess.dart' as ch;
import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_state.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/state/base/base_cubit.dart';
import 'package:uuid/uuid.dart';

/// The view model for the setup local screen.
class SetupLocalViewModel extends BaseCubit<SetupLocalState> {
  /// Creates the setup local view model.
  SetupLocalViewModel({
    required this.appCache,
  }) : super(SetupLocalState(
          saves: [],
        ));

  /// The cache manager for performing cache operations.
  final IAppCache appCache;

  /// Loads the local game saves.
  Future<void> loadSaves() async {
    emit(state.copyWith(
      saves: appCache.gameSaveOperator.getAll(
        sort: GetAllSortEnum.updateAtDesc,
      ),
    ));
  }

  /// Creates a new game and save it to the cache.
  Future<GameSaveCacheModel> createGame(String name) async {
    final newSave = GameSaveCacheModel(
      id: const Uuid().v4(),
      gameSave: GameSave(
        name: name,
        history: [],
        defaultPosition: ch.Chess.DEFAULT_POSITION,
        isGameOver: false,
      ),
    );

    final savedSave = appCache.gameSaveOperator.save(newSave);

    emit(state.copyWith(
      saves: [savedSave, ...state.saves],
    ));

    unawaited(loadSaves());

    return savedSave;
  }

  /// Removes the save permanently from the cache.
  Future<void> removeSave(GameSaveCacheModel save) async {
    final removed = appCache.gameSaveOperator.remove(save.id);

    if (removed) await loadSaves();
  }
}
