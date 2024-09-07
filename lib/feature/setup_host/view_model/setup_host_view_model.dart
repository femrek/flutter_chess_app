import 'dart:async';

import 'package:chess/chess.dart' as ch;
import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_state.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/state/base/base_cubit.dart';
import 'package:uuid/uuid.dart';

/// View Model for Setup Host Screen
class SetupHostViewModel extends BaseCubit<SetupHostState> {
  /// Creates [SetupHostViewModel] instance.
  SetupHostViewModel({
    required this.appCache,
  }) : super(const SetupHostState(saves: []));

  /// Cache operator for performing operations on saves.
  final IAppCache appCache;

  /// fetch saves and emit state.
  Future<void> loadSaves() async {
    final saves = await appCache.gameSaveOperator.getAll(
      sort: GetAllSortEnum.updateAtDesc,
    );
    emit(state.copyWith(saves: saves));
  }

  /// Creates a new game save and returns the created cache model.
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

    final savedSave = await appCache.gameSaveOperator.save(newSave);

    emit(state.copyWith(
      saves: [savedSave, ...state.saves],
    ));

    unawaited(loadSaves());

    return savedSave;
  }

  /// Removes the save permanently from the cache.
  Future<void> removeSave(GameSaveCacheModel save) async {
    final removed = await appCache.gameSaveOperator.remove(save.id);

    if (removed) await loadSaves();
  }
}
