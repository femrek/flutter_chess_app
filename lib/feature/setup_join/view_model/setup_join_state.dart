// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/network_scan_result.dart';

class SetupJoinState {
  const SetupJoinState({
    this.scanState = const SetupJoinScanState(),
  });

  final SetupJoinScanState scanState;

  SetupJoinState copyWith({
    SetupJoinScanState? scanState,
  }) {
    return SetupJoinState(
      scanState: scanState ?? this.scanState,
    );
  }
}

@immutable
class SetupJoinScanState {
  const SetupJoinScanState({
    this.availableGames = const [],
    this.status = SetupJoinScanStatus.initial,
    this.maxHostCount = 0,
    this.scannedHostCount = 0,
  });

  final List<NetworkScanResult> availableGames;
  final SetupJoinScanStatus status;
  final int maxHostCount;
  final int scannedHostCount;

  int get availableGamesCount => availableGames.length;

  SetupJoinScanState copyWith({
    List<NetworkScanResult>? availableGames,
    SetupJoinScanStatus? status,
    int? maxHostCount,
    int? scannedHostCount,
  }) {
    return SetupJoinScanState(
      availableGames: availableGames ?? this.availableGames,
      status: status ?? this.status,
      maxHostCount: maxHostCount ?? this.maxHostCount,
      scannedHostCount: scannedHostCount ?? this.scannedHostCount,
    );
  }
}

enum SetupJoinScanStatus {
  initial,
  scanning,
  loaded,
  errorNoNetworkConnection,
  errorUnknown,
  ;

  T whenReturn<T>({
    required T Function() initial,
    required T Function() scanning,
    required T Function() loaded,
    required T Function() errorNoNetworkConnection,
    required T Function() errorUnknown,
  }) {
    switch (this) {
      case SetupJoinScanStatus.initial:
        return initial();
      case SetupJoinScanStatus.scanning:
        return scanning();
      case SetupJoinScanStatus.loaded:
        return loaded();
      case SetupJoinScanStatus.errorNoNetworkConnection:
        return errorNoNetworkConnection();
      case SetupJoinScanStatus.errorUnknown:
        return errorUnknown();
    }
  }
}
