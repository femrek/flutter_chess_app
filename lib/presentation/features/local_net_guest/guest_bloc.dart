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
        //final HttpClientRequest request = await httpClient.get(host, port, '');
        //final HttpClientResponse response = await request.done;
        //response.listen((event) { })

        //response = await http.get('http://$host:$port?action=move&move_from=a1&move_to=b1');

      chess = ch.Chess.fromFEN(event.fen);
      convertToPieceBoard();
      setHistoryString();
      yield GuestLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );
        //if (!chess.in_checkmate) hostCheckmateCubit.reset();
        //else hostCheckmateCubit.checkmate();
    }

    else if (event is GuestConnectEvent) {
      print('connecting');
      host = event.host;
      port = event.port;

      socket = await Socket.connect(InternetAddress.tryParse(host), port);
      //socket = await Socket.connect(host, port, sourceAddress: '$host');
      print('socket: ${socket.remoteAddress.address}:${socket.remotePort}');
      socket.listen((Uint8List dataAsByte) {
        final String data = String.fromCharCodes(dataAsByte);
        print(data);
        add(GuestLoadEvent(fen: data));
      });
      socket.write('?action=fen');
      socket.close();
    }

    else if (event is GuestDisconnectEvent) {
      if (socket != null) socket.close();
      socket = null;
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