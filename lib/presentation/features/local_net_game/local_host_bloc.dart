import 'package:chess/chess.dart' as ch;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mychess/data/storage_manager.dart';
import 'package:mychess/presentation/features/local_net_game/host_checkmate_cubit.dart';

import 'local_host_event.dart';
import 'local_host_state.dart';

class LocalHostBloc extends Bloc<LocalHostEvent, LocalHostState> {
  LocalHostBloc(this.hostCheckmateCubit) : super(LocalHostInitialState());

  HostCheckmateCubit hostCheckmateCubit;

  ch.Chess chess;
  List<List<ch.Piece>> pieceBoard = List.generate(8, (index) => List<ch.Piece>(8), growable: false);
  Set<String> movablePiecesCoors = Set();
  String history;
  List<ch.Move> undoHistory = List();

  @override
  Stream<LocalHostState> mapEventToState(LocalHostEvent event) async* {

   if (event is LocalHostLoadEvent) {
     if (event.restart || (await StorageManager().lastHostGameFen) == null) {
        await StorageManager().setLastHostGameFen(null);
        chess = ch.Chess();
        undoHistory.clear();
        //redoableCubit.nonredoable();
      } else {
        chess = ch.Chess.fromFEN(await StorageManager().lastHostGameFen);
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

      if (!chess.in_checkmate) hostCheckmateCubit.reset();
      else hostCheckmateCubit.checkmate();
   }

   else if (event is LocalHostFocusEvent) {

   }

   else if (event is LocalHostMoveEvent) {

   }

   else if (event is LocalHostUndoEvent) {

   }

   else if (event is LocalHostRedoEvent) {
     
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