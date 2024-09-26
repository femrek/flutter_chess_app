// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/square_data.dart';

@immutable
abstract class HostGameState {
  const HostGameState();
}

@immutable
class HostGameInitialState extends HostGameState {
  const HostGameInitialState();
}

@immutable
class HostGameLoadedState extends HostGameState {
  const HostGameLoadedState({
    required this.gameState,
    required this.networkState,
  });

  final HostGameGameState gameState;
  final HostGameNetworkState networkState;

  HostGameLoadedState copyWith({
    HostGameGameState? gameState,
    HostGameNetworkState? networkState,
  }) {
    return HostGameLoadedState(
      gameState: gameState ?? this.gameState,
      networkState: networkState ?? this.networkState,
    );
  }
}

@immutable
class HostGameGameState {
  const HostGameGameState({
    required this.squareStates,
    required this.isFocused,
    required this.turnStatus,
    required this.capturedPieces,
    required this.canUndo,
    required this.canRedo,
  });

  final Map<SquareCoordinate, SquareData> squareStates;
  final bool isFocused;
  final AppChessTurnStatus turnStatus;
  final List<AppPiece> capturedPieces;
  final bool canUndo;
  final bool canRedo;

  HostGameGameState copyWith({
    Map<SquareCoordinate, SquareData>? squareStates,
    bool? isFocused,
    AppChessTurnStatus? turnStatus,
    List<AppPiece>? capturedPieces,
    bool? canUndo,
    bool? canRedo,
  }) {
    return HostGameGameState(
      squareStates: squareStates ?? this.squareStates,
      isFocused: isFocused ?? this.isFocused,
      turnStatus: turnStatus ?? this.turnStatus,
      capturedPieces: capturedPieces ?? this.capturedPieces,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
    );
  }
}

@immutable
class HostGameNetworkState {
  const HostGameNetworkState({
    required this.isServerRunning,
    required this.connectedClients,
    required this.runningHost,
    required this.runningPort,
    this.allowedClient,
  });

  const HostGameNetworkState.initial()
      : this(
          isServerRunning: false,
          connectedClients: const [],
          runningHost: 'not initialized',
          runningPort: 0,
        );

  final bool isServerRunning;
  final List<HostGameClientState> connectedClients;
  final String runningHost;
  final int runningPort;
  final HostGameClientState? allowedClient;
}

@immutable
class HostGameClientState {
  const HostGameClientState({
    required this.clientInformation,
    required this.isAllowed,
  });

  /// The information of the guest player.
  final SenderInformation clientInformation;

  /// Whether the guest player is allowed to play the game.
  /// (True if this is the opponent currently)
  final bool isAllowed;

  HostGameClientState copyWith({
    SenderInformation? clientInformation,
    bool? isAllowed,
  }) {
    return HostGameClientState(
      clientInformation: clientInformation ?? this.clientInformation,
      isAllowed: isAllowed ?? this.isAllowed,
    );
  }
}
