import 'package:core/core.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_state.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/impl/socket_client_manager.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the Guest Game Screen.
class GuestGameViewModel extends BaseCubit<GuestGameState> {
  /// Creates the [GuestGameViewModel] instance.
  GuestGameViewModel() : super(const GuestGameState());

  /// The socket manager.
  late ISocketClientManager clientManager;

  /// Initializes the view model. connect the game.
  Future<void> init(AddressOnNetwork address) async {
    clientManager = await SocketClientManager.connect(
      address: address,
      onConnectedListener: _onConnectedListener,
      onDataListeners: [_onDataListener],
    );
  }

  /// Disconnects the game.
  Future<void> disconnect() async {
    G.logger.t('GuestGameViewModel.disconnect: start: $clientManager');
    if (!clientManager.isConnected) {
      G.logger.t('GuestGameViewModel.disconnect: already disconnected');
      return;
    }
    clientManager.disconnect();
    G.logger.t('GuestGameViewModel.disconnect: end: $clientManager');
  }

  void _onConnectedListener(
      SenderInformation serverInformation, String? gameName) {
    G.logger.t('SetupJoinScreen.onConnectedListener: '
        '$serverInformation | $gameName. '
        'manager = $clientManager');

    emit(GuestGameLoadedState(
      serverInformation: serverInformation,
      gameName: gameName ?? 'Unknown',
    ));
  }

  void _onDataListener(NetworkModel data) {
    G.logger.t('GuestGameViewModel._onDataListener: $data');
  }
}
