// ignore_for_file: public_member_api_docs

import 'package:localchess/product/cache/model/game_save_cache_model.dart';

class SetupLocalState {
  SetupLocalState({
    required this.saves,
  });

  /// The list of local game saves.
  final List<GameSaveCacheModel> saves;

  SetupLocalState copyWith({
    List<GameSaveCacheModel>? saves,
  }) {
    return SetupLocalState(
      saves: saves ?? this.saves,
    );
  }
}
