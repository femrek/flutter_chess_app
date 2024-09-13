import 'package:localchess/feature/setup_join/view_model/setup_join_state.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the Setup Join Screen.
class SetupJoinViewModel extends BaseCubit<SetupJoinState> {
  /// Creates the [SetupJoinViewModel] instance.
  SetupJoinViewModel() : super(const SetupJoinState());

  /// Returns the local network address. (inet)
  Future<String?> getLocalAddress() async {
    final networkInfo = await G.networkInfoProvider.inetAddress;
    return networkInfo;
  }
}
