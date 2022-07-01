import 'dart:io';
import 'dart:typed_data';

import 'package:chess/chess.dart' as ch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/data/model/last_move_model.dart';
import 'package:localchess/utils.dart';

import 'guest_event.dart';
import 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  GuestBloc() : super(GuestInitialState());

  String host = '';
  int port;

  Socket socket;

  ch.Chess chess;
  List<List<ch.Piece>> pieceBoard = List.generate(8, (index) => List<ch.Piece>(8), growable: false);
  Set<String> movablePiecesCoors = {};
  LastMoveModel lastMove;
  List<ch.Move> undoHistory = [];

  @override
  Stream<GuestState> mapEventToState(GuestEvent event) async* {

    if (event is GuestLoadEvent) {
      chess = ch.Chess.fromFEN(event.fen);
      findMovablePiecesCoors();
      convertToPieceBoard();
      yield GuestLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        lastMoveFrom: lastMove.from,
        lastMoveTo: lastMove.to,
        fen: chess.fen,
      );
    }

    else if (event is GuestConnectEvent) {
      //print('connecting');
      host = event.host;
      port = event.port;

      yield GuestInitialState();

      socket = await Socket.connect(InternetAddress.tryParse(host), port);
      //print('socket: ${socket.remoteAddress.address}:${socket.remotePort}');
      socket.listen((Uint8List dataAsByte) {
        final String data = String.fromCharCodes(dataAsByte);
        final String fenData = getFenFromBundleString(data);
        //print('data: $data');
        //print('fenData: $fenData');
        if (ch.Chess.validate_fen(fenData)['valid']) {
          lastMove = getLastMoveFromBundleString(data);
          //print('last move from host: $lastMove');
          add(GuestLoadEvent(fen: fenData));
        } else {
          add(GuestRefreshEvent());
        }
      });
    }

    else if (event is GuestDisconnectEvent) {
      if (socket != null) {
        socket.write('?action=disconnect');
        socket.destroy();
      }
      socket = null;
    }

    else if (event is GuestRefreshEvent) {
      if (socket != null) {
        socket.write('?action=fen');
      }
    }

    else if (event is GuestFocusEvent) {
      final Set<String> movableCoors = {};
      for (ch.Move move in chess.generate_moves()) {
        //print('from: ${move.from} | fromAlgebraic: ${move.fromAlgebraic} | to: ${move.to} | toAlgebraic: ${move.toAlgebraic} | color: ${move.color} | piece: ${move.piece} | flags: ${move.flags} | promotion: ${move.promotion} | captured: ${move.captured}');
        if (move.fromAlgebraic == event.focusCoordinate) {
          movableCoors.add(move.toAlgebraic);
        }
      }
      yield GuestFocusedState(
        board: pieceBoard,
        focusedCoordinate: event.focusCoordinate,
        movableCoors: movableCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        lastMoveFrom: lastMove.from,
        lastMoveTo: lastMove.to,
        fen: chess.fen,
      );
    }

    else if (event is GuestMoveEvent) {
      if (state is! GuestFocusedState) {
        throw Exception('trying move while state is not focused state. (state is ${state.runtimeType}');
      }

      final String from = (state as GuestFocusedState).focusedCoordinate;
      final String to = event.to;
      bool whiteTurn = false;

      if (!(to == null || to == from)) {
        socket.write('?action=move&move_from=$from&move_to=$to');
        whiteTurn = true;
      }
      
      // ignore: curly_braces_in_flow_control_structures
      else yield GuestLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: whiteTurn,
        inCheck: chess.in_check,
        lastMoveFrom: lastMove.from,
        lastMoveTo: lastMove.to,
        fen: chess.fen,
      );
    }

  }

  void convertToPieceBoard() {
    for(int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        pieceBoard[x][y] = chess.board[(x + (7-y)*16)];
      }
    }
  }

  void findMovablePiecesCoors() {
    if (chess.turn == ch.Color.WHITE) {
      movablePiecesCoors.clear();
      return;
    }
    List moves = chess.generate_moves();
    movablePiecesCoors.clear();
    for (ch.Move move in moves) {
      movablePiecesCoors.add(move.fromAlgebraic);
    }
    //print('movablePiecesCoors: $movablePiecesCoors');
  }

}