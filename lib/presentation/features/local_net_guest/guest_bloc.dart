import 'dart:io';
import 'dart:typed_data';

import 'package:chess/chess.dart' as ch;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'guest_event.dart';
import 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  GuestBloc() : super(GuestInitialState());

  String host = '';
  int port;

  Socket socket;

  ch.Chess chess;
  List<List<ch.Piece>> pieceBoard = List.generate(8, (index) => List<ch.Piece>(8), growable: false);
  Set<String> movablePiecesCoors = Set();
  String history;
  List<ch.Move> undoHistory = List();

  @override
  Stream<GuestState> mapEventToState(GuestEvent event) async* {

    if (event is GuestLoadEvent) {
      chess = ch.Chess.fromFEN(event.fen);
      findMovablePiecesCoors();
      convertToPieceBoard();
      setHistoryString();
      yield GuestLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );
    }

    else if (event is GuestConnectEvent) {
      print('connecting');
      host = event.host;
      port = event.port;

      socket = await Socket.connect(InternetAddress.tryParse(host), port);
      print('socket: ${socket.remoteAddress.address}:${socket.remotePort}');
      socket.listen((Uint8List dataAsByte) {
        final String data = String.fromCharCodes(dataAsByte);
        print(data);
        add(GuestLoadEvent(fen: data));
      });
    }

    else if (event is GuestDisconnectEvent) {
      if (socket != null) socket.destroy();
      socket = null;
    }

    else if (event is GuestRefreshEvent) {
      if (socket != null) {
        socket.write('?action=fen');
      }
    }

    else if (event is GuestFocusEvent) {
      final Set<String> movableCoors = Set();
      for (ch.Move move in chess.generate_moves()) {
        //print('from: ${move.from} | fromAlgebraic: ${move.fromAlgebraic} | to: ${move.to} | toAlgebraic: ${move.toAlgebraic} | color: ${move.color} | piece: ${move.piece} | flags: ${move.flags} | promotion: ${move.promotion} | captured: ${move.captured}');
        if (move.fromAlgebraic == event.focusCoor) {
          movableCoors.add(move.toAlgebraic);
        }
      }
      setHistoryString();
      yield GuestFocusedState(
        board: pieceBoard,
        focusedCoor: event.focusCoor,
        movableCoors: movableCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );
    }

    else if (event is GuestMoveEvent) {
      if (!(state is GuestFocusedState)) {
        throw Exception('trying move while state is not focused state. (state is ${state.runtimeType}');
      }

      final String from = (state as GuestFocusedState).focusedCoor;
      final String to = event.to;

      if (!(to == null || to == from)) {
        socket.write('?action=move&move_from=$from&move_to=$to');
      }
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
    List moves = chess.generate_moves();
    movablePiecesCoors.clear();
    for (ch.Move move in moves) {
      movablePiecesCoors.add(move.fromAlgebraic);
    }
    print('movablePiecesCoors: $movablePiecesCoors');
  }

  void setHistoryString() {
    history = '';
    for (ch.State state in chess.history) {
      history += state.move.fromAlgebraic + state.move.toAlgebraic + '/';
    }
  }

}