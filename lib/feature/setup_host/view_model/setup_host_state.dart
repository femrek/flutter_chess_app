// ignore_for_file: public_member_api_docs

import 'package:localchess/product/cache/model/game_save_cache_model.dart';

class SetupHostState {
  const SetupHostState({
    required this.saves,
  });

  final List<GameSaveCacheModel> saves;

  SetupHostState copyWith({
    List<GameSaveCacheModel>? saves,
  }) {
    return SetupHostState(
      saves: saves ?? this.saves,
    );
  }
}
