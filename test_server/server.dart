
import 'dart:io';

import 'dart:typed_data';

import 'package:chess/chess.dart' as ch;

ServerSocket serverSocket;
ch.Chess chess;
List<List<ch.Piece>> pieceBoard = List.generate(8, (index) => List<ch.Piece>(8), growable: false);
Set<String> movablePiecesCoors = Set();
Set<String> movableHostPiecesCoors = Set();
Set<String> movableGuestPiecesCoors = Set();
String history;
List<ch.Move> undoHistory = List();

main() async {
  chess = ch.Chess();
  await runServer();
}

Future runServer() async {
  serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
  print('LocalHostConnectEvent event, ip: ${serverSocket.address.toString()}:${serverSocket.port.toString()}');
  serverSocket.listen((Socket socket) {
    socket.listen((Uint8List dataAsByte) {
      String s = new String.fromCharCodes(dataAsByte);
      print(s);
      //socket.write(s);
      String query = s.substring(s.indexOf(' '), s.indexOf(' ', (s.indexOf(' ')+1)));
      print(query);
      final Map<String, String> params = queryToMap(query);
      socket.write(params);
      if (params.length == 0) return; 
      final String action = params['action'];
      if (action == 'fen') {
        socket.write(chess.fen);
      } else if (action == 'move') {
        final String from = params['move_from'];
        final String to = params['move_to'];
        print('movableguestpiecescoors: $movableGuestPiecesCoors');
        if (movableGuestPiecesCoors.contains(from)) {
          move(from, to);
        } else {
          socket.write('error: move not able');
        }
        socket.write(chess.fen);
      } else {
        socket.write('hello chess player | action: $action');
      }
      socket.close();
    }); 
  });
}

stopServer() {
  if (serverSocket != null) serverSocket.close();
  serverSocket = null;
  print('server stoped');
}

move(String from, String to) {
  if (!(to == null || to == from)) {
    ch.Move thisMove; 
    for (ch.Move move in chess.generate_moves()) {
      if (
        move.fromAlgebraic == from
        && move.toAlgebraic == to
      ) {
        thisMove = move;
        break;
      }
    }
    if (thisMove == null) throw Exception('unknown move');
    chess.move(thisMove);
    convertToPieceBoard();
    findMovablePiecesCoors();
    setHistoryString();
    undoHistory.clear();
  }
}

Map<String, String> queryToMap(String query) {
  int keyStartIndex = query.indexOf('?') + 1;
  if (keyStartIndex == 0) return Map();
  int valueStartIndex = query.indexOf('=') + 1;
  int nextKeyStartIndex = query.indexOf('&') + 1;
  Map<String, String> result = Map();
  while(true) {
    result[query.substring(keyStartIndex, valueStartIndex-1)] 
      = query.substring(valueStartIndex, nextKeyStartIndex == 0 ? null : nextKeyStartIndex-1);
    if (nextKeyStartIndex == 0) break;
    keyStartIndex = nextKeyStartIndex;
    valueStartIndex = query.indexOf('=', nextKeyStartIndex) + 1;
    nextKeyStartIndex = query.indexOf('&', valueStartIndex) + 1;
  }
  return result;
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
  movableHostPiecesCoors.clear();
  movableGuestPiecesCoors.clear();
  for (ch.Move move in moves) {
    movablePiecesCoors.add(move.fromAlgebraic);
    if (move.color == ch.Color.WHITE) movableHostPiecesCoors.add(move.fromAlgebraic);
    else movableGuestPiecesCoors.add(move.fromAlgebraic);
  }
  print('movablePiecesCoors: $movablePiecesCoors');
}

void setHistoryString() {
  history = '';
  for (ch.State state in chess.history) {
    history += state.move.fromAlgebraic + state.move.toAlgebraic + '/';
  }
}