import 'dart:async';

import 'package:chess/chess.dart' as ch;
import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_state.dart';
import 'package:localchess/product/state/base/base_cubit.dart';
import 'package:localchess/product/storage/i_app_storage.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:uuid/uuid.dart';

/// The view model for the setup local screen.
class SetupLocalViewModel extends BaseCubit<SetupLocalState> {
  /// Creates the setup local view model.
  SetupLocalViewModel({
    required this.appStorage,
  }) : super(SetupLocalState(
          saves: [],
        ));

  /// The storage manager for performing storage operations.
  final IAppStorage appStorage;

  /// Loads the local game saves.
  Future<void> loadSaves() async {
    emit(state.copyWith(
      saves: appStorage.gameSaveOperator.getAll(
        sort: GetAllSortEnum.updateAtDesc,
      ),
    ));
  }

  /// Creates a new game and save it to the storage.
  Future<GameSaveStorageModel> createGame(String name) async {
    final newSave = GameSaveStorageModel(
      id: const Uuid().v4(),
      gameSave: GameSave(
        name: name,
        history: [],
        defaultPosition: ch.Chess.DEFAULT_POSITION,
        isGameOver: false,
      ),
    );

    final savedSave = appStorage.gameSaveOperator.save(newSave);

    emit(state.copyWith(
      saves: [savedSave, ...state.saves],
    ));

    unawaited(loadSaves());

    return savedSave;
  }

  /// Removes the save permanently from the storage.
  Future<void> removeSave(GameSaveStorageModel save) async {
    final removed = appStorage.gameSaveOperator.remove(save.id);

    if (removed) await loadSaves();
  }
}
