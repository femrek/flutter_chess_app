import 'package:chess/chess.dart' as ch;
import 'package:bloc/bloc.dart';
import 'package:localchess/data/model/last_move_model.dart';
import 'package:localchess/data/storage_manager.dart';
import 'package:localchess/presentation/dialogs/choose_promotion_dialog.dart';
import 'package:localchess/presentation/features/local_game/redoable_cubit.dart';
import 'package:localchess/presentation/features/local_game/turn_cubit.dart';
import 'package:localchess/utils.dart';

import 'board_event.dart';
import 'board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc(this.redoableCubit, this.turnCubit) : super(BoardInitialState()) {
    for (int i = 0; i < 8; i++) {
      pieceBoard.add([]);
      for (int j = 0; j < 8; j++) {
        pieceBoard[i].add(ch.Piece(ch.PieceType.PAWN, ch.Color.WHITE));
      }
    }
  }

  final RedoableCubit redoableCubit;
  final TurnCubit turnCubit;

  ch.Chess? chess;
  List<List<ch.Piece?>> pieceBoard = [];
  Set<String> movablePiecesCoors = {};
  LastMoveModel? lastMove;
  List<String> undoStateHistory = [];

  @override
  Stream<BoardState> mapEventToState(BoardEvent event) async* {

    if (event is BoardLoadEvent) {
      if (event.restart || (await StorageManager().lastGameFen) == null) {
        await StorageManager().setLastGameFen(null);
        lastMove = LastMoveModel(from: '', to: '');
        StorageManager().setLastGameLastMove(lastMove);
        StorageManager().setBoardStateHistory([]);
        chess = ch.Chess();
        undoStateHistory.clear();
        redoableCubit.nonRedoable();
      } else {
        chess = ch.Chess.fromFEN((await StorageManager().lastGameFen)!);
        lastMove = (await StorageManager().lastGameLastMove);
      }

      findMovablePiecesCoors();
      convertToPieceBoard();

      turnCubit.changeState(chess!.turn == ch.Color.WHITE, chess!.in_checkmate);
      yield BoardLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess!.turn == ch.Color.WHITE,
        inCheck: chess!.in_check,
        lastMoveFrom: lastMove?.from,
        lastMoveTo: lastMove?.to,
        fen: chess!.generate_fen(),
      );
    }

    else if (event is BoardFocusEvent) {
      final Set<String> movableCoors = {};
      for (ch.Move move in chess!.generate_moves()) {
        //print('from: ${move.from} | fromAlgebraic: ${move.fromAlgebraic} | to: ${move.to} | toAlgebraic: ${move.toAlgebraic} | color: ${move.color} | piece: ${move.piece} | flags: ${move.flags} | promotion: ${move.promotion} | captured: ${move.captured}');
        if (move.fromAlgebraic == event.focusCoordinate) {
          movableCoors.add(move.toAlgebraic);
        }
      }
      turnCubit.changeState(chess!.turn == ch.Color.WHITE, chess!.in_checkmate);
      yield BoardFocusedState(
        board: pieceBoard,
        focusedCoordinate: event.focusCoordinate,
        movableCoors: movableCoors,
        isWhiteTurn: chess!.turn == ch.Color.WHITE,
        lastMoveFrom: lastMove?.from,
        lastMoveTo: lastMove?.to,
        inCheck: chess!.in_check,
      );
    }

    else if (event is BoardRemoveTheFocusEvent) {
      if (!(state is BoardFocusedState)) {
        throw Exception('trying to remove focus while state is not focused state. (state is ${state.runtimeType}');
      }

      yield BoardLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess!.turn == ch.Color.WHITE,
        lastMoveFrom: lastMove?.from,
        lastMoveTo: lastMove?.to,
        inCheck: chess!.in_check,
      );
    }

    else if (event is BoardMoveEvent) {
      if (!(state is BoardFocusedState)) {
        throw Exception('trying move while state is not focused state. (state is ${state.runtimeType}');
      }
      ch.Move? thisMove;
      Set<ch.Move> possiblyMoves = {};
      List<String> promotions = [];
      if (event.to != (state as BoardFocusedState).focusedCoordinate) {
        for (ch.Move move in chess!.generate_moves()) {
          if (
            move.fromAlgebraic == (state as BoardFocusedState).focusedCoordinate
            && move.toAlgebraic == (event.to)
          ) {
            possiblyMoves.add(move);
          }
        }
        for (ch.Move move in possiblyMoves) {
          if (move.promotion != null) {
            promotions.add(move.promotion!.name);
          }
        }
        if (promotions.isNotEmpty) {
          final String? selectedPieceCode = await showPromotionDialog(event.context, promotions);
          for (ch.Move move in possiblyMoves) {
            if (move.promotion?.name == selectedPieceCode) {
              thisMove = move;
              break;
            }
          }
          if (thisMove == null) {
            return;
          }
        } else if (possiblyMoves.length == 1) {
          thisMove = possiblyMoves.elementAt(0);
        } else {
          throw Exception('unexpected state when move');
        }
        if (thisMove == null) throw Exception('unknown move');
        chess!.move(thisMove);
        convertToPieceBoard();
        findMovablePiecesCoors();
        StorageManager().setLastGameFen(chess!.fen);
        lastMove = LastMoveModel(from: thisMove.fromAlgebraic, to: thisMove.toAlgebraic);
        StorageManager().setLastGameLastMove(lastMove);
        final String stateBundle = fenAndLastMoveToBundleString(chess!.fen, lastMove.toString());
        //print('stateBundle: $stateBundle');
        StorageManager().addBoardStateHistory(stateBundle);
        undoStateHistory.clear();
        redoableCubit.nonRedoable();
      }

      turnCubit.changeState(chess!.turn == ch.Color.WHITE, chess!.in_checkmate);
      yield BoardLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess!.turn == ch.Color.WHITE,
        lastMoveFrom: thisMove?.fromAlgebraic ?? lastMove?.from,
        lastMoveTo: thisMove?.toAlgebraic ?? lastMove?.to,
        inCheck: chess!.in_check,
      );
    }

    else if (event is BoardUndoEvent) {
      if ((await StorageManager().boardStateHistory).length > 0) {
        undoStateHistory.add(await StorageManager().removeLastFromBoardStateHistory());
        String currentState;
        try {
          currentState = (await StorageManager().boardStateHistory).last;
        } on StateError {
          currentState = ch.Chess.DEFAULT_POSITION + '#/';
        }
        redoableCubit.redoable();
        lastMove = getLastMoveFromBundleString(currentState);
        final String fen = getFenFromBundleString(currentState);
        StorageManager().setLastGameLastMove(lastMove);
        StorageManager().setLastGameFen(fen);
        chess!.load(fen);
      }
      findMovablePiecesCoors();
      convertToPieceBoard();

      turnCubit.changeState(chess!.turn == ch.Color.WHITE, chess!.in_checkmate);
      yield BoardLoadedState(
        board: pieceBoard,
        movablePiecesCoors: movablePiecesCoors,
        isWhiteTurn: chess!.turn == ch.Color.WHITE,
        inCheck: chess!.in_check,
        lastMoveFrom: lastMove?.from,
        lastMoveTo: lastMove?.to,
        fen: chess!.generate_fen(),
      );
    }

    else if (event is BoardRedoEvent) {
      if (undoStateHistory.isEmpty) {
        print('no undo');
      } else {
        final String lastUndoState = undoStateHistory.removeLast();
        final String fen = getFenFromBundleString(lastUndoState);
        chess!.load(fen);
        if (undoStateHistory.isEmpty) redoableCubit.nonRedoable();
        lastMove = getLastMoveFromBundleString(lastUndoState);
        StorageManager().setLastGameLastMove(lastMove);
        StorageManager().setLastGameFen(fen);
        StorageManager().addBoardStateHistory(fenAndLastMoveToBundleString(fen, lastMove.toString()));
        findMovablePiecesCoors();
        convertToPieceBoard();

        turnCubit.changeState(chess!.turn == ch.Color.WHITE, chess!.in_checkmate);
        yield BoardLoadedState(
          board: pieceBoard,
          movablePiecesCoors: movablePiecesCoors,
          isWhiteTurn: chess!.turn == ch.Color.WHITE,
          inCheck: chess!.in_check,
          lastMoveFrom: lastMove?.from,
          lastMoveTo: lastMove?.to,
          fen: chess!.generate_fen(),
        );
      }
    }

  }

  void convertToPieceBoard() {
    for(int x = 0; x < 8; x++) {
      for (int y = 0; y < 8; y++) {
        pieceBoard[x][y] = chess!.board[(x + (7-y)*16)];
      }
    }
  }

  void findMovablePiecesCoors() {
    List moves = chess!.generate_moves();
    movablePiecesCoors.clear();
    for (ch.Move move in moves) {
      movablePiecesCoors.add(move.fromAlgebraic);
    }
    //print('movablePiecesCoors: $movablePiecesCoors');
  }
}

