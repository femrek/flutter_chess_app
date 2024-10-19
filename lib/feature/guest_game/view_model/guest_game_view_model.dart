import 'dart:io';

import 'package:localchess/feature/guest_game/view_model/guest_game_state.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/move/app_chess_move.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/network/core/i_socket_client_manager.dart';
import 'package:localchess/product/network/core/model/address_on_network.dart';
import 'package:localchess/product/network/core/model/network_model.dart';
import 'package:localchess/product/network/core/model/sender_information.dart';
import 'package:localchess/product/network/impl/socket_client_manager.dart';
import 'package:localchess/product/network/model/allowing_status_network_model.dart';
import 'package:localchess/product/network/model/disconnect_network_model.dart';
import 'package:localchess/product/network/model/game_introduce_network_model.dart';
import 'package:localchess/product/network/model/game_network_model.dart';
import 'package:localchess/product/network/model/move_network_model.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/service/impl/guest_chess_service.dart';
import 'package:localchess/product/state/base/base_cubit.dart';

/// The view model for the Guest Game Screen.
class GuestGameViewModel extends BaseCubit<GuestGameState> {
  /// Creates the [GuestGameViewModel] instance.
  GuestGameViewModel() : super(const GuestGameState(isAllowedToGame: false));

  final _squareStates = <SquareCoordinate, SquareData>{
    for (var e in SquareCoordinate.boardSquares)
      e: const SquareData.withDefaultValues(),
  };

  late ISocketClientManager _clientManager;

  IChessService? _chessService;
  GameNetworkModel? _snapshot;
  SocketClientOnConnectedListener? _onClientConnectListener;
  SocketClientOnKickedListener? _onClientDisconnectListener;

  /// Initializes the view model. connect the game.
  Future<void> init({
    required AddressOnNetwork address,
    SocketClientOnConnectedListener? onClientConnectListener,
    SocketClientOnKickedListener? onClientKickedListener,
  }) async {
    G.logger.t('GuestGameViewModel.init: start');

    _onClientConnectListener = onClientConnectListener;
    _onClientDisconnectListener = onClientKickedListener;

    try {
      _clientManager = await SocketClientManager.connect(
        address: address,
        onConnectedListener: _onConnectedListener,
        onKickedListener: _onKickedListener,
        onDataListeners: [_onDataListener],
      );
    } on SocketException catch (e) {
      G.logger.d('GuestGameViewModel.init: socket error', error: e);
      emit(const GuestGameNoHostErrorState());
      return;
    }

    G.logger.t('GuestGameViewModel.init: end');
  }

  /// Disconnects the game.
  Future<void> disconnect() async {
    G.logger.t('GuestGameViewModel.disconnect: start');

    if (state is GuestGameNoHostErrorState) {
      G.logger.t('GuestGameViewModel.disconnect: already disconnected');
      return;
    }

    if (!_clientManager.isConnected) {
      G.logger.t('GuestGameViewModel.disconnect: already disconnected');
      return;
    }
    _clientManager.disconnect();

    G.logger.t('GuestGameViewModel.disconnect: end: $_clientManager');
  }

  /// Focuses on the piece at the given coordinate.
  void focus(SquareCoordinate to) {
    G.logger.t('GuestGameViewModel.focus: $to');

    final gameState = state.gameState;
    if (gameState == null) {
      throw Exception('GuestGameViewModel.focus: Invalid state');
    }

    if (gameState.isFocused) {
      G.logger.e('GuestGameViewModel.focus: A piece is already focused');
      return;
    }

    final squareState = gameState.squareStates[to];
    if (squareState == null) {
      throw Exception(
          'GuestGameViewModel.focus: Invalid coordinate when focusing. '
          'No square state found');
    }
    if (!squareState.canMove) {
      G.logger.e(
        'GuestGameViewModel.focus: Invalid coordinate when focusing. '
        'focus coordinate must be contained in movablePiecesCoordinates',
      );
      return;
    }

    _emitFocus(to);
  }

  /// Removes the focus from the focused piece.
  void removeFocus() {
    G.logger.t('GuestGameViewModel.removeFocus: start');

    final gameState = state.gameState;
    if (gameState == null) {
      G.logger.e('GuestGameViewModel.removeFocus: Invalid state');
      return;
    }

    if (!gameState.isFocused) {
      G.logger.e('GuestGameViewModel.removeFocus: No piece is focused');
      return;
    }

    final chessService = _chessService;
    if (chessService == null) {
      G.logger.e('GuestGameViewModel.removeFocus: No chess service');
      return;
    }

    _emitGame(chessService: chessService);

    G.logger.t('GuestGameViewModel.removeFocus: end');
  }

  /// Removes the focus from the focused piece.
  Future<void> move({
    required AppChessMove move,
    String? promotion,
  }) async {
    G.logger.t('GuestGameViewModel.move: $move');

    // validate if state is loaded
    final gameState = state.gameState;
    if (gameState == null) {
      throw Exception('GuestGameViewModel.move: Invalid state');
    }

    // validate if chess service is loaded
    final chessService = _chessService;
    if (chessService == null) {
      G.logger.e('GuestGameViewModel.move: No chess service');
      return;
    }

    // show the new state immediately
    await chessService.move(move: move);
    _emitGame(chessService: chessService, fadedCoordinate: move.to);

    // send the move to the host
    _clientManager.send(
      data: MoveNetworkModel(
        move: move,
        promotion: promotion,
      ),
    );
  }

  void _onConnectedListener(SenderInformation serverInformation) {
    G.logger.t('SetupJoinScreen.onConnectedListener: serverInformation = '
        '$serverInformation, '
        'manager = $_clientManager');

    _emitReset(serverInformation);

    _onClientConnectListener?.call(serverInformation);
  }

  void _onKickedListener() {
    G.logger.t('SetupJoinScreen.onKickedListener: manager = $_clientManager');

    _onClientDisconnectListener?.call();
  }

  void _onDataListener(NetworkModel data) {
    G.logger
        .t('GuestGameViewModel._onDataListener: ${data.runtimeType}: $data');

    // process the received data
    if (data is GameNetworkModel) {
      _snapshot = data;
    } else if (data is GameIntroduceNetworkModel) {
      _emitGameMetadata(data);
    } else if (data is AllowingStatusNetworkModel) {
      _emitAllowToPlayStatus(data.allowed);
    } else if (data is DisconnectNetworkModel) {
      _onKickedListener();
    }

    // update the board when data is received
    if (_snapshot != null) {
      G.logger.d('GuestGameViewModel._onDataListener: emit game');
      _emitGameFromNetwork();
    }

    G.logger.t('GuestGameViewModel._onDataListener: end');
  }

  void _emitGameMetadata(GameIntroduceNetworkModel gameIntroduceNetworkModel) {
    emit(state.copyWith(
      gameMetadata: GuestGameGameMetadata(
        gameName: gameIntroduceNetworkModel.gameName,
        playerColor: gameIntroduceNetworkModel.hostColor.opposite,
      ),
    ));
  }

  void _emitGameFromNetwork() {
    G.logger.t('GuestGameViewModel._emitGame: start.'
        ' snapshot = $_snapshot '
        'gameMetadata = ${state.gameMetadata}');

    // validate if snapshot is loaded
    final snapshot = _snapshot;
    if (snapshot == null) {
      G.logger.d('GuestGameViewModel._emitState: no snapshot');
      return;
    }

    // validate if game introduce network model is loaded
    final gameIntroduceNetworkModel = state.gameMetadata;
    if (gameIntroduceNetworkModel == null) {
      G.logger
          .d('GuestGameViewModel._emitState: no game introduce network model');
      return;
    }

    final chessService = _chessService = GuestChessService(
      snapshot: snapshot,
      guestColor: gameIntroduceNetworkModel.playerColor,
      canPlay: state.isAllowedToGame,
    );

    _emitGame(chessService: chessService);
  }

  void _emitGame({
    required IChessService chessService,
    SquareCoordinate? fadedCoordinate,
  }) {
    final movablePiecesCoordinates =
        chessService.moves().map((e) => e.from).toList();
    final turnStatus = chessService.turnStatus;

    for (final coordinate in _squareStates.keys) {
      final piece = chessService.getPieceAt(coordinate);

      _squareStates[coordinate] = SquareData(
        piece: piece,
        canMove: movablePiecesCoordinates.contains(coordinate),
        isThisCheck: piece != null && turnStatus.isCheckOn(piece),
        isLastMoveFromThis: coordinate == chessService.lastMoveFrom,
        isLastMoveToThis: coordinate == chessService.lastMoveTo,
        isFocusedOnThis: false,
        isSyncInProcess: coordinate == fadedCoordinate,
      );
    }

    final capturedPieces = chessService.capturedPieces;

    emit(state.copyWith(
      gameState: GuestGameGameState(
        squareStates: _squareStates,
        isFocused: false,
        turnStatus: turnStatus,
        capturedPieces: capturedPieces,
        canUndo: chessService.canUndo(),
        canRedo: chessService.canRedo(),
      ),
    ));

    G.logger.t('GuestGameViewModel._emitGame: end');
  }

  void _emitFocus(SquareCoordinate focusedCoordinate) {
    G.logger.t('GuestGameViewModel._emitFocus: $focusedCoordinate');

    // validate if state is loaded
    final gameState = state.gameState;
    if (gameState == null) {
      G.logger.e('GuestGameViewModel._emitFocus: Invalid state');
      return;
    }

    // validate if chess service is loaded
    final chessService = _chessService;
    if (chessService == null) {
      G.logger.e('GuestGameViewModel._emitFocus: no chess service');
      return;
    }

    final turnStatus = chessService.turnStatus;
    {
      final piece = chessService.getPieceAt(focusedCoordinate);
      _squareStates[focusedCoordinate] = SquareData(
        piece: piece,
        canMove: false,
        isThisCheck: piece != null && turnStatus.isCheckOn(piece),
        isLastMoveFromThis: false,
        isLastMoveToThis: false,
        isFocusedOnThis: true,
        isSyncInProcess: false,
      );
    }

    for (final move in chessService.moves(from: focusedCoordinate)) {
      final piece = chessService.getPieceAt(move.to);

      _squareStates[move.to] = SquareData(
        piece: chessService.getPieceAt(move.to),
        canMove: false,
        isThisCheck: false,
        isLastMoveFromThis: chessService.lastMoveFrom == move.to,
        isLastMoveToThis: chessService.lastMoveTo == move.to,
        isFocusedOnThis: false,
        isSyncInProcess: false,
        moveToThis: piece == null ? move : null,
        captureToThis: piece != null ? move : null,
      );
    }

    emit(state.copyWith(
      gameState: gameState.copyWith(
        squareStates: _squareStates,
        isFocused: true,
        turnStatus: turnStatus,
        canUndo: chessService.canUndo(),
        canRedo: chessService.canRedo(),
      ),
    ));

    // after first build set canMove to false for all squares to prevent to
    // start a drag from a square that is not rendered at first build.
    Future.microtask(() {
      G.logger.t('GuestGameViewModel._emitFocus.microTask: Setting canMove to '
          'false for all squares');

      for (final e in _squareStates.entries) {
        if (e.value.canMove == false) continue;

        _squareStates[e.key] = e.value.copyWith(canMove: false);
      }

      emit(state.copyWith(
        gameState: gameState.copyWith(
          squareStates: _squareStates,
          isFocused: true,
          turnStatus: turnStatus,
          canUndo: chessService.canUndo(),
          canRedo: chessService.canRedo(),
        ),
      ));

      G.logger.t('GuestGameViewModel._emitFocus.microTask: '
          'canMove set to false for all squares');
    });

    G.logger.t('GuestGameViewModel._emitFocus: Focused on $focusedCoordinate');
  }

  void _emitAllowToPlayStatus(bool allowed) {
    emit(state.copyWith(
      isAllowedToGame: allowed,
    ));
  }

  void _emitReset(SenderInformation serverInformation) {
    emit(GuestGameState(
      isAllowedToGame: false,
      serverInformation: serverInformation,
    ));
  }
}
