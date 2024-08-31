import 'package:localchess/feature/local_game/view_model/local_game_state.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the local game screen
class LocalGameViewModel extends BaseCubit<LocalGameState> {
  /// The view model for the local game screen
  LocalGameViewModel() : super(LocalGameState());

  /// Initializes the view model
  Future<void> init(LocalGameSaveCacheModel save) async {
    emit(LocalGameState(save: save));
  }
}
