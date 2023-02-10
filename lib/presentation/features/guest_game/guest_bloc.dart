import 'dart:io';
import 'dart:typed_data';

import 'package:chess/chess.dart' as ch;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/last_move_model.dart';
import 'package:localchess/presentation/dialogs/choose_promotion_dialog.dart';
import 'package:localchess/provider/socket_communicator.dart';

import 'guest_event.dart';
import 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  GuestBloc() : super(GuestInitialState()) {
    for (int i = 0; i < 8; i++) {
      pieceBoard.add([]);
      for (int j = 0; j < 8; j++) {
        pieceBoard[i].add(ch.Piece(ch.PieceType.PAWN, ch.Color.WHITE));
      }
    }
  }

  String host = '';
  int? port;

  // ignore: close_sinks
  Socket? socket;

  ch.Chess? chess;
  List<List<ch.Piece?>> pieceBoard = [];
  Set<String> movablePiecesCoors = {};
  LastMoveModel? lastMove;
  List<ch.Move> undoHistory = [];
  String? ghostCoordinate;

  bool get isFocused {
    return state is GuestLoadedState && (state as GuestLoadedState).focusedCoordinate != null;
  }

  GuestLoadedState _loadedState({
    String? focusedCoordinate,
    Set<String>? movableCoors,
  }) {
    return GuestLoadedState(
      board: pieceBoard,
      movablePiecesCoors: movablePiecesCoors,
      isWhiteTurn: chess!.turn == ch.Color.WHITE,
      inCheck: chess!.in_check,
      lastMoveFrom: lastMove?.from,
      lastMoveTo: lastMove?.to,
      fen: chess!.fen,
      ghostCoordinate: ghostCoordinate,
      focusedCoordinate: focusedCoordinate,
      movableCoors: movableCoors ?? const {},
    );
  }

  @override
  Stream<GuestState> mapEventToState(GuestEvent event) async* {

    if (event is GuestLoadEvent) {
      chess = ch.Chess.fromFEN(event.fen);
      findMovablePiecesCoors();
      convertToPieceBoard();
      yield _loadedState();
    }

    else if (event is GuestConnectEvent) {
      //print('connecting');
      host = event.host;
      port = event.port;

      yield GuestInitialState();

      socket = await Socket.connect(InternetAddress.tryParse(host), port!);

      socket!.listen((Uint8List dataAsByte) {
        final String data = String.fromCharCodes(dataAsByte);
        print(data);
        ActionType action = decodeRawData(data);
        if (action is SendBoard) {
          if (ch.Chess.validate_fen(action.fen)['valid']) {
            ghostCoordinate = null;
            lastMove = LastMoveModel(from: action.lastMoveFrom, to: action.lastMoveTo);
            add(GuestLoadEvent(fen: action.fen));
          } else {
            add(GuestRefreshEvent());
            throw 'invalid fen from host';
          }
        } else if (action is SendConnectivityState) {
          if (action.ableToConnect) {
            requestConnection(socket!, RequestConnection());
          } else {
            add(GuestShowErrorEvent(
              errorMessage: 'The host is not able to connect. Another client has connected to this host',
            ));
          }
        } else if (action is SendKick) {
          add(GuestShowErrorEvent(errorMessage: 'Kicked by host'));
        } else {
          throw 'undefined action';
        }
      });
      checkConnectivity(socket!, CheckConnectivity());
    }

    else if (event is GuestDisconnectEvent) {
      if (socket != null) {
        sendDisconnectSignal(socket!, SendDisconnectSignal());
        socket!.destroy();
      }
      socket = null;
    }

    else if (event is GuestRefreshEvent) {
      if (socket != null) {
        requestBoard(socket!, RequestBoard());
      }
    }

    else if (event is GuestFocusEvent) {
      if (chess == null) throw 'chess is not initialized';
      final Set<String> movableCoors = {};
      for (ch.Move move in chess!.generate_moves()) {
        //print('from: ${move.from} | fromAlgebraic: ${move.fromAlgebraic} | to: ${move.to} | toAlgebraic: ${move.toAlgebraic} | color: ${move.color} | piece: ${move.piece} | flags: ${move.flags} | promotion: ${move.promotion} | captured: ${move.captured}');
        if (move.fromAlgebraic == event.focusCoordinate) {
          movableCoors.add(move.toAlgebraic);
        }
      }
      yield _loadedState(
        focusedCoordinate: event.focusCoordinate,
        movableCoors: movableCoors
      );
    }

    else if (event is GuestRemoveTheFocusEvent) {
      yield _loadedState();
    }

    else if (event is GuestMoveEvent) {
      if (!isFocused) {
        throw Exception('trying move while state is not focused state. (state is ${state.runtimeType}');
      }
      if (socket == null) throw 'no connection when move on guest';

      final String from = (state as GuestLoadedState).focusedCoordinate!;
      final String to = event.to;

      if (to != from) {
        sendMove(socket!, SendMove(
          from: from,
          to: to,
          promotion: await move(event.context, from, to),
        ));
        ghostCoordinate = to;
        convertToPieceBoard();
        findMovablePiecesCoors();
      }
      yield _loadedState();
    }

    else if (event is GuestShowErrorEvent) {
      yield GuestErrorState(errorMessage: event.errorMessage);
    }

    else {
      throw 'undefined event: $event';
    }
  }

  Future<String?> move(BuildContext context, String from, String to) async {
    if (chess == null) throw 'chess is not initialized';
    ch.Move? thisMove;
    Set<ch.Move> possibleMoves = {};
    List<String> promotions = [];
    String? selectedPieceCode;
    for (ch.Move move in chess!.generate_moves()) {
      if (
      move.fromAlgebraic == from
          && move.toAlgebraic == to
      ) {
        possibleMoves.add(move);
      }
    }
    for (ch.Move move in possibleMoves) {
      if (move.promotion != null) {
        promotions.add(move.promotion!.name);
      }
    }
    if (promotions.isNotEmpty) {
      selectedPieceCode = await showPromotionDialog(context, promotions);
      for (ch.Move move in possibleMoves) {
        if (move.promotion?.name == selectedPieceCode) {
          thisMove = move;
          break;
        }
      }
    } else if (possibleMoves.length == 1) {
      thisMove = possibleMoves.elementAt(0);
    } else {
      throw Exception('unexpected state when move');
    }
    if (thisMove == null) throw Exception('unknown move');
    chess!.move(thisMove);
    return selectedPieceCode;
  }

  void convertToPieceBoard() {
    if (chess == null) throw 'chess is not initialized';
    for(int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        pieceBoard[x][y] = chess!.board[(x + (7-y)*16)];
      }
    }
  }

  void findMovablePiecesCoors() {
    if (chess == null) throw 'chess is no initialized';
    if (chess!.turn == ch.Color.WHITE) {
      movablePiecesCoors.clear();
      return;
    }
    List moves = chess!.generate_moves();
    movablePiecesCoors.clear();
    for (ch.Move move in moves) {
      movablePiecesCoors.add(move.fromAlgebraic);
    }
    //print('movablePiecesCoors: $movablePiecesCoors');
  }

}