// ignore_for_file: public_member_api_docs

import 'package:localchess/product/storage/model/game_save_storage_model.dart';

class SetupLocalState {
  SetupLocalState({
    required this.saves,
  });

  /// The list of local game saves.
  final List<GameSaveStorageModel> saves;

  SetupLocalState copyWith({
    List<GameSaveStorageModel>? saves,
  }) {
    return SetupLocalState(
      saves: saves ?? this.saves,
    );
  }
}
