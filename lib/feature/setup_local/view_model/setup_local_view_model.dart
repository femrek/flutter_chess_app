import 'package:localchess/feature/setup_local/view_model/setup_local_state.dart';
import 'package:localchess/product/cache/app_cache.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the setup local screen.
class SetupLocalViewModel extends BaseCubit<SetupLocalState> {
  /// Creates the setup local view model.
  SetupLocalViewModel({
    required this.appCache,
  }) : super(SetupLocalState(
          saves: [],
        ));

  /// The cache manager for performing cache operations.
  final AppCache appCache;

  /// Loads the local game saves.
  Future<void> loadSaves() async {
    emit(state.copyWith(
      saves: await appCache.localGameSaveOperator.getAll(),
    ));
  }
}
