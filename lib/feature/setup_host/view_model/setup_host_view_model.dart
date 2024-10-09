import 'dart:async';

import 'package:chess/chess.dart' as ch;
import 'package:core/core.dart';
import 'package:gen/gen.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_state.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_cubit.dart';
import 'package:localchess/product/storage/i_app_storage.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:uuid/uuid.dart';

/// View Model for Setup Host Screen
class SetupHostViewModel extends BaseCubit<SetupHostState> {
  /// Creates [SetupHostViewModel] instance.
  SetupHostViewModel({
    required this.appStorage,
  }) : super(const SetupHostState(saves: []));

  /// storage operator for performing operations on saves.
  final IAppStorage appStorage;

  /// fetch saves and emit state.
  Future<void> loadSaves() async {
    final saves = appStorage.gameSaveOperator.getAll(
      sort: GetAllSortEnum.updateAtDesc,
    );
    emit(state.copyWith(saves: saves));
  }

  /// Returns the device name.
  String getDeviceName() {
    return G.deviceProperties.deviceName;
  }

  /// Updates the device name.
  // ignore: use_setters_to_change_properties
  void updateName(String name) {
    G.deviceProperties.deviceName = name;
  }

  /// Creates a new game save and returns the created storage model.
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
