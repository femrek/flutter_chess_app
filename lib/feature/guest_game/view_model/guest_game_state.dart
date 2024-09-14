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
    this.gameState,
    this.networkState,
    this.gameMetadata,
  });

  final GuestGameGameState? gameState;
  final GuestGameNetworkState? networkState;
  final GuestGameGameMetadata? gameMetadata;

  GuestGameState copyWith({
    GuestGameGameState? gameState,
    GuestGameNetworkState? networkState,
    GuestGameGameMetadata? gameMetadata,
  }) {
    return GuestGameState(
      gameState: gameState ?? this.gameState,
      networkState: networkState ?? this.networkState,
      gameMetadata: gameMetadata ?? this.gameMetadata,
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

@immutable
class GuestGameNetworkState {
  const GuestGameNetworkState({
    required this.serverInformation,
  });

  const GuestGameNetworkState.initial() : serverInformation = null;

  final SenderInformation? serverInformation;
}
