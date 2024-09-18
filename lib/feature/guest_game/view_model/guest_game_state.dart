// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/data/square_data.dart';

@immutable
class GuestGameState {
  const GuestGameState({
    required this.isAllowedToGame,
    this.gameState,
    this.gameMetadata,
    this.serverInformation,
  });

  /// The status of the game. (board, turn, etc.)
  final GuestGameGameState? gameState;

  /// The mata information about the game.
  final GuestGameGameMetadata? gameMetadata;

  /// The information about the server.
  final SenderInformation? serverInformation;

  /// Whether the guest player is allowed to play the game.
  final bool isAllowedToGame;

  GuestGameState copyWith({
    GuestGameGameState? gameState,
    GuestGameGameMetadata? gameMetadata,
    SenderInformation? serverInformation,
    bool? isAllowedToGame,
  }) {
    return GuestGameState(
      gameState: gameState ?? this.gameState,
      gameMetadata: gameMetadata ?? this.gameMetadata,
      serverInformation: serverInformation ?? this.serverInformation,
      isAllowedToGame: isAllowedToGame ?? this.isAllowedToGame,
    );
  }
}

@immutable
class GuestGameGameMetadata extends Equatable {
  const GuestGameGameMetadata({
    required this.gameName,
    required this.playerColor,
  });

  final String gameName;
  final PlayerColor playerColor;

  @override
  List<Object?> get props => [gameName, playerColor];
}

@immutable
class GuestGameGameState {
  const GuestGameGameState({
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

  GuestGameGameState copyWith({
    Map<SquareCoordinate, SquareData>? squareStates,
    bool? isFocused,
    AppChessTurnStatus? turnStatus,
    List<AppPiece>? capturedPieces,
    bool? canUndo,
    bool? canRedo,
  }) {
    return GuestGameGameState(
      squareStates: squareStates ?? this.squareStates,
      isFocused: isFocused ?? this.isFocused,
      turnStatus: turnStatus ?? this.turnStatus,
      capturedPieces: capturedPieces ?? this.capturedPieces,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
    );
  }
}

class GuestGameNoHostErrorState extends GuestGameState {
  const GuestGameNoHostErrorState()
      : super(
          isAllowedToGame: false,
        );
}
