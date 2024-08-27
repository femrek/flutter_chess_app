// ignore_for_file: public_member_api_docs

import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';

class SetupLocalState {
  SetupLocalState({
    required this.saves,
  });

  /// The list of local game saves.
  final List<LocalGameSaveCacheModel> saves;

  SetupLocalState copyWith({
    List<LocalGameSaveCacheModel>? saves,
  }) {
    return SetupLocalState(
      saves: saves ?? this.saves,
    );
  }
}
