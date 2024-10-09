// ignore_for_file: public_member_api_docs

import 'package:localchess/product/storage/model/game_save_storage_model.dart';

class SetupHostState {
  const SetupHostState({
    required this.saves,
  });

  final List<GameSaveStorageModel> saves;

  SetupHostState copyWith({
    List<GameSaveStorageModel>? saves,
  }) {
    return SetupHostState(
      saves: saves ?? this.saves,
    );
  }
}
