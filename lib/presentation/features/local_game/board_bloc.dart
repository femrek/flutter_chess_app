import 'package:chess/chess.dart' as ch;
import 'package:bloc/bloc.dart';
import 'package:mychess/data/storage_manager.dart';
import 'package:mychess/presentation/features/local_game/redoable_cubit.dart';
import 'package:mychess/presentation/features/local_game/turn_cubit.dart';

import 'board_event.dart';
import 'board_state.dart';



class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc(this.redoableCubit, this.turnCubit) : super(BoardInitialState());

  final RedoableCubit redoableCubit;
  final TurnCubit turnCubit;

  ch.Chess chess;
  List<List<ch.Piece>> pieceBoard = List.generate(8, (index) => List<ch.Piece>(8), growable: false);
  Set<String> movablePiecesCoors = Set();
  String history;
  List<ch.Move> undoHistory = List();

  @override
  Stream<BoardState> mapEventToState(BoardEvent event) async* {

    if (event is BoardLoadEvent) {
      if (event.restart || (await StorageManager().lastGameFen) == null) {
        await StorageManager().setLastGameFen(null);
        chess = ch.Chess();
        undoHistory.clear();
        redoableCubit.nonredoable();
      } else {
        chess = ch.Chess.fromFEN(await StorageManager().lastGameFen);
      }

      findMovablePiecesCoors();

      convertToPieceBoard();

      setHistoryString();

      turnCubit.changeState(chess.turn == ch.Color.WHITE, chess.in_checkmate);
      yield BoardLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );
    }

    else if (event is BoardFocusEvent) {
      final Set<String> movableCoors = Set();
      for (ch.Move move in chess.generate_moves()) {
        //print('from: ${move.from} | fromAlgebraic: ${move.fromAlgebraic} | to: ${move.to} | toAlgebraic: ${move.toAlgebraic} | color: ${move.color} | piece: ${move.piece} | flags: ${move.flags} | promotion: ${move.promotion} | captured: ${move.captured}');
        if (move.fromAlgebraic == event.focusCoor) {
          movableCoors.add(move.toAlgebraic);
        }
      }
      turnCubit.changeState(chess.turn == ch.Color.WHITE, chess.in_checkmate);
      yield BoardFocusedState(
        board: pieceBoard,
        focusedCoor: event.focusCoor,
        movableCoors: movableCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
      );
    }

    else if (event is BoardMoveEvent) {
      if (!(state is BoardFocusedState)) {
        throw Exception('trying move while state is not focused state. (state is ${state.runtimeType}');
      }

      if (!(event.to == null || event.to == (state as BoardFocusedState).focusedCoor)) {
        ch.Move thisMove; 
        for (ch.Move move in chess.generate_moves()) {
          if (
            move.fromAlgebraic == (state as BoardFocusedState).focusedCoor
            && move.toAlgebraic == (event.to)
          ) {
            thisMove = move;
            break;
          }
        }
        if (thisMove == null) throw Exception('unknown move');
        chess.move(thisMove);
        convertToPieceBoard();
        findMovablePiecesCoors();
        StorageManager().setLastGameFen(chess.fen);
        setHistoryString();
        undoHistory.clear();
        redoableCubit.nonredoable();
      }

      turnCubit.changeState(chess.turn == ch.Color.WHITE, chess.in_checkmate);
      yield BoardLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
      );
    }

    else if (event is BoardUndoEvent) {
      ch.Move move = chess.undo_move();
      if (move != null) {
        undoHistory.add(move);
        redoableCubit.redoable();
      }
      findMovablePiecesCoors();
      convertToPieceBoard();
      setHistoryString();

      turnCubit.changeState(chess.turn == ch.Color.WHITE, chess.in_checkmate);
      yield BoardLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess.turn == ch.Color.WHITE,
        inCheck: chess.in_check,
        history: history,
      );
    }

    else if (event is BoardRedoEvent) {
      if (undoHistory.length == 0) {
        print('no undo');
      } else {
        chess.move(undoHistory.removeLast());

        if (undoHistory.length == 0) {
          redoableCubit.nonredoable();
        }

        findMovablePiecesCoors();
        convertToPieceBoard();
        setHistoryString();

        turnCubit.changeState(chess.turn == ch.Color.WHITE, chess.in_checkmate);
        yield BoardLoadedState(
          board: pieceBoard,
          movablePiecesCoors: movablePiecesCoors,
          isWhiteTurn: chess.turn == ch.Color.WHITE,
          inCheck: chess.in_check,
          history: history,
        );
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

