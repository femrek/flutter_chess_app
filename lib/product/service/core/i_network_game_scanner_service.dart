import 'package:core/core.dart';
import 'package:localchess/product/data/network_scan_result.dart';

/// Interface for network game scanner service. Provides methods for scanning
/// the network for available games and checking the host if runs a game.
abstract interface class INetworkGameScannerService {
  /// Scans the network for available games. Returns a [Stream] of a list of
  /// [NetworkScanResult] objects for each available game. Null for unavailable
  /// hosts.
  Stream<NetworkScanResult?> scan(String inet, String mask);

  /// Checks the host if runs a game at the [address] and returns a [Future] of
  /// [NetworkScanResult] if the host is available. Null for unavailable hosts.
  Future<NetworkScanResult?> checkHost(AddressOnNetwork address);

  /// Finds the length of the network by the [mask].
  int findHostCountBySubmask(String mask);
}
