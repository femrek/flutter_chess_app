import 'dart:io';

import 'package:chess/chess.dart' as ch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'guest_event.dart';
import 'guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  GuestBloc() : super(GuestInitialState());

  http.Response response;
  String host = '';
  int port;

  ch.Chess chess;
  List<List<ch.Piece>> pieceBoard = List.generate(8, (index) => List<ch.Piece>(8), growable: false);
  Set<String> movablePiecesCoors = Set();
  String history;
  List<ch.Move> undoHistory = List();

  @override
  Stream<GuestState> mapEventToState(GuestEvent event) async* {

    if (event is GuestLoadEvent) {
      if (host == '' || port == null) {
        yield GuestInitialState();
      } else {
        //final HttpClientRequest request = await httpClient.get(host, port, '');
        //final HttpClientResponse response = await request.done;
        //response.listen((event) { })

        response = await http.get('http://$host:$port?action=move&move_from=a1&move_to=b1');

        if (response.statusCode == 200) {
          print('${response.body}');
          chess = ch.Chess.fromFEN(response.body);
          //findMovablePiecesCoors();
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
        } else {
          print('not ok status code: ${response.statusCode}');
        }
      }
    }

    else if (event is GuestConnectEvent) {
      host = '192.168.0.11'; // event.host;
      port = 6523; // event.port;
      add(GuestLoadEvent());
    }

    else if (event is GuestDisconnectEvent) {

    }

  }

  void convertToPieceBoard() {
    for(int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        pieceBoard[x][y] = chess.board[(x + (7-y)*16)];
      }
    }
  }

  void setHistoryString() {
    history = '';
    for (ch.State state in chess.history) {
      history += state.move.fromAlgebraic + state.move.toAlgebraic + '/';
    }
  }

}