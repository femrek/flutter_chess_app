import 'package:localchess/feature/setup_join/view_model/setup_join_state.dart';
import 'package:localchess/product/data/network_scan_result.dart';
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

  /// Get the device name from manager component.
  String getDeviceName() {
    return G.deviceProperties.deviceName;
  }

  /// Update the device name in the manager component.
  // ignore: use_setters_to_change_properties
  void updateName(String value) {
    G.deviceProperties.deviceName = value;
  }

  /// Scan the network for available games.
  Future<void> scanNetwork() async {
    G.logger.t('SetupJoinViewModel.scanNetwork: start');

    final inet = await G.networkInfoProvider.inetAddress;
    final submask = await G.networkInfoProvider.submask;

    if (inet == null || submask == null) {
      emit(state.copyWith(
        scanState: const SetupJoinScanState(
          status: SetupJoinScanStatus.errorNoNetworkConnection,
        ),
      ));

      G.logger.t('SetupJoinViewModel.scanNetwork: end: no network connection');
      return;
    }

    final scanStream = G.networkGameScannerService.scan(inet, submask);
    final hostCount =
        G.networkGameScannerService.findHostCountBySubmask(submask);

    emit(state.copyWith(
      scanState: SetupJoinScanState(
        status: SetupJoinScanStatus.scanning,
        maxHostCount: hostCount,
      ),
    ));

    final foundDeviceNames = <NetworkScanResult>[];
    var scannedHostCount = 0;
    await for (final result in scanStream) {
      G.logger.d('SetupJoinViewModel.scanNetwork: found device: $result');
      if (result != null) {
        foundDeviceNames.add(result);
      }
      emit(state.copyWith(
        scanState: state.scanState.copyWith(
          availableGames: foundDeviceNames,
          scannedHostCount: ++scannedHostCount,
        ),
      ));
    }

    G.logger.d('SetupJoinViewModel.scanNetwork: scan end: found device names:'
        ' $foundDeviceNames');

    emit(state.copyWith(
      scanState: state.scanState.copyWith(
        status: SetupJoinScanStatus.loaded,
        availableGames: foundDeviceNames,
      ),
    ));

    G.logger.t('SetupJoinViewModel.scanNetwork: end');
  }
}
