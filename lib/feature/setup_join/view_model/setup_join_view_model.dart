import 'package:localchess/feature/setup_join/view_model/setup_join_state.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the Setup Join Screen.
class SetupJoinViewModel extends BaseCubit<SetupJoinState> {
  /// Creates the [SetupJoinViewModel] instance.
  SetupJoinViewModel() : super(const SetupJoinState());
}
