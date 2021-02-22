import 'dart:io';
import 'dart:typed_data';

import 'package:chess/chess.dart' as ch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/data/storage_manager.dart';
import 'package:mychess/presentation/features/local_net_game/host_checkmate_cubit.dart';
import 'package:mychess/presentation/features/local_net_game/host_name_cubit.dart';
import 'package:mychess/presentation/features/local_net_game/host_redoable_cubit.dart';

import 'local_host_event.dart';
import 'local_host_state.dart';

class LocalHostBloc extends Bloc<LocalHostEvent, LocalHostState> {
  LocalHostBloc(this.hostCheckmateCubit, this.hostRedoableCubit, this.hostNameCubit) : super(LocalHostInitialState());

  final HostCheckmateCubit hostCheckmateCubit;
  final HostRedoableCubit hostRedoableCubit;
  final HostNameCubit hostNameCubit;

  ServerSocket serverSocket;
  Socket clientSocket;

  ch.Chess chess;
  List<List<ch.Piece>> pieceBoard = List.generate(8, (index) => List<ch.Piece>(8), growable: false);
  Set<String> movablePiecesCoors = Set();
  String history;
  List<ch.Move> undoHistory = List();

  @override
  Stream<LocalHostState> mapEventToState(LocalHostEvent event) async* {

    if (event is LocalHostLoadEvent) {
      if (event.fen != null) {
        if (chess != null) chess.load(event.fen);
        else chess = ch.Chess.fromFEN(event.fen);
      } else if (event.restart || (await StorageManager().lastHostGameFen) == null) {
        yield LocalHostInitialState();
        await StorageManager().setLastHostGameFen(null);
        chess = ch.Chess();
        undoHistory.clear();
        hostRedoableCubit.nonredoable();
      } else {
        chess = ch.Chess.fromFEN(await StorageManager().lastHostGameFen);
      }
      if (clientSocket != null) clientSocket.write(chess.fen);

      findMovablePiecesCoors();

      convertToPieceBoard();

      setHistoryString();

      print('new loaded state');
      yield LocalHostLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );

      if (!chess.in_checkmate) hostCheckmateCubit.reset();
      else hostCheckmateCubit.checkmate();
    }

    else if (event is LocalHostStartEvent) {
      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
      print('LocalHostConnectEvent event, ip: ${serverSocket.address.toString()}:${serverSocket.port.toString()}');
      hostNameCubit.defineHostName(serverSocket.address.address, serverSocket.port);
      serverSocket.listen((Socket socket) {
        socket.write(chess.fen);
        print('new connection');
        if (clientSocket == null) {
          print('first client socket is setting');
          clientSocket = socket;
        }
        socket.listen((Uint8List dataAsByte) {
          String s = new String.fromCharCodes(dataAsByte);
          //print(s);
          String query;
          try {
            query = s.substring(s.indexOf(' ')+1, s.indexOf(' ', (s.indexOf(' ')+1)));
          } on RangeError {
            query = s;
          }
          print(query);
          final Map<String, String> params = queryToMap(query);
          print('$params');
          if (params.length == 0) return; 
          final String action = params['action'];
          if (action == 'fen') {
            socket.write('${chess.fen}');
            print('sending ${chess.fen}');
          } else if (action == 'move') {
            final String from = params['move_from'];
            final String to = params['move_to'];
            if (chess.turn == ch.Color.BLACK && movablePiecesCoors.contains(from)) {
              add(LocalHostMoveEvent(from: from, to: to));
            }
            socket.write(chess.fen);
          } else if (action == 'disconnect') {
            if (socket == clientSocket) {
              clientSocket.destroy();
              clientSocket = null;
            }
          } else {
            socket.write('unknown action');
          }
        });
      });
    }

    else if (event is LocalHostStopEvent) {
      if (serverSocket != null) serverSocket.close();
      serverSocket = null;
      if (clientSocket != null) clientSocket.destroy();
      clientSocket = null;
      print('server stoped');
    }

    else if (event is LocalHostFocusEvent) {
      final Set<String> movableCoors = Set();
      for (ch.Move move in chess.generate_moves()) {
        //print('from: ${move.from} | fromAlgebraic: ${move.fromAlgebraic} | to: ${move.to} | toAlgebraic: ${move.toAlgebraic} | color: ${move.color} | piece: ${move.piece} | flags: ${move.flags} | promotion: ${move.promotion} | captured: ${move.captured}');
        if (move.fromAlgebraic == event.focusCoor) {
          movableCoors.add(move.toAlgebraic);
        }
      }
      setHistoryString();
      yield LocalHostFocusedState(
        board: pieceBoard,
        focusedCoor: event.focusCoor,
        movableCoors: movableCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );
    }

    else if (event is LocalHostMoveEvent) {
      if (!(state is LocalHostFocusedState || event.from != '')) {
        throw Exception('trying move while state is not focused state. (state is ${state.runtimeType}');
      }

      final String from = event.from == '' ? (state as LocalHostFocusedState).focusedCoor : event.from;
      final String to = event.to;

      if (!(to == null || to == from)) {
        move(from, to);
        convertToPieceBoard();
        findMovablePiecesCoors();
        StorageManager().setLastHostGameFen(chess.fen);
        setHistoryString();
        undoHistory.clear();
        hostRedoableCubit.nonredoable();
        if (clientSocket != null) clientSocket.write(chess.fen);
      }

      yield LocalHostLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );

      if (chess.in_checkmate) hostCheckmateCubit.checkmate();
    }
 
    else if (event is LocalHostUndoEvent) {
      ch.Move move = chess.undo_move();
      if (move != null) {
        undoHistory.add(move);
        hostRedoableCubit.redoable();
      }
      clientSocket.write(chess.fen);
      findMovablePiecesCoors();
      convertToPieceBoard();
      setHistoryString();

      yield LocalHostLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );
      if (!chess.in_checkmate) hostCheckmateCubit.reset();
      else hostCheckmateCubit.checkmate();
    }
 
    else if (event is LocalHostRedoEvent) {
      if (undoHistory.length == 0) {
        print('no undo');
      } else {
        chess.move(undoHistory.removeLast());

        clientSocket.write(chess.fen);

        if (undoHistory.length == 0) {
          hostRedoableCubit.nonredoable();
        }

        findMovablePiecesCoors();
        convertToPieceBoard();
        setHistoryString();

        yield LocalHostLoadedState(
          board: pieceBoard,
          movablePiecesCoors: movablePiecesCoors,
          isWhiteTurn: chess.turn == ch.Color.WHITE,
          inCheck: chess.in_check,
          history: history,
        );
      }

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


  void move(String from, String to) {
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