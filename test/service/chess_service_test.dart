// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/cache/i_app_cache.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/data/chess_turn/app_chess_turn_status.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/service/impl/chess_service.dart';
import 'package:logger/logger.dart';

import '../test_config/hive/hive_common.dart';
import '../test_config/test_chess_fen_constants.dart';
import '../test_config/test_implementation/test_app_cache.dart';
import '../test_config/test_implementation/test_cache_operator.dart';

void main() async {
  {
    final logger = Logger();
    final cacheOperator = TestCacheOperator<LocalGameSaveCacheModel>();
    final cache = TestCache(localGameSaveOperator: cacheOperator);

    await GetIt.I.reset();
    GetIt.I.registerSingleton<Logger>(logger);
    GetIt.I.registerSingleton<IAppCache>(cache);
  }

  // set logging level
  Logger.level = Level.info;

  // Initialize the cache
  await initHiveTests();
  await G.appCache.init();

  setUp(() {
    G.appCache.localGameSaveOperator.saveAll([
      _saveNew,
      _savePlayed,
      _saveToGetPromotionMove_fromB7_toB8,
      _saveToGetPromotionCapture_fromB7_toA8,
      _saveBlackKingUnderAttack,
      _saveCheckmate_blackLost,
      _saveStalemate,
      _saveDraw,
    ]);
  });

  tearDown(() {
    G.appCache.localGameSaveOperator.removeAll();
  });

  group('Create an ChessService instance and validate status', () {
    test('Create an ChessService instance (new game)', () {
      final chessService = ChessService(save: _saveNew);
      expect(chessService, isNotNull);
    });

    test('Create an ChessService instance (played game)', () {
      final chessService = ChessService(save: _savePlayed);
      expect(chessService, isNotNull);
    });

    test('Create an ChessService instance (promotion move setup)', () {
      final chessService =
          ChessService(save: _saveToGetPromotionMove_fromB7_toB8);
      expect(chessService, isNotNull);
    });

    test('Create an ChessService instance (promotion capture setup)', () {
      final chessService =
          ChessService(save: _saveToGetPromotionCapture_fromB7_toA8);
      expect(chessService, isNotNull);
    });
  });

  group('Perform move operation on ChessService', () {
    test('Get the current board status', () {
      final chessService = ChessService(save: _saveNew);

      // empty tile
      final pieceA3 = chessService.getPieceAt(SquareCoordinate.fromName('a3'));

      // white pieces
      final pieceA1 = chessService.getPieceAt(SquareCoordinate.fromName('a1'));
      final pieceH1 = chessService.getPieceAt(SquareCoordinate.fromName('h1'));
      final pieceA2 = chessService.getPieceAt(SquareCoordinate.fromName('a2'));
      final pieceB1 = chessService.getPieceAt(SquareCoordinate.fromName('b1'));
      final pieceD1 = chessService.getPieceAt(SquareCoordinate.fromName('d1'));
      final pieceE1 = chessService.getPieceAt(SquareCoordinate.fromName('e1'));

      // black pieces
      final pieceA8 = chessService.getPieceAt(SquareCoordinate.fromName('a8'));
      final pieceH8 = chessService.getPieceAt(SquareCoordinate.fromName('h8'));
      final pieceH7 = chessService.getPieceAt(SquareCoordinate.fromName('h7'));
      final pieceB8 = chessService.getPieceAt(SquareCoordinate.fromName('b8'));
      final pieceD8 = chessService.getPieceAt(SquareCoordinate.fromName('d8'));
      final pieceE8 = chessService.getPieceAt(SquareCoordinate.fromName('e8'));

      expect(pieceA3, isNull);
      expect(pieceA1, AppPiece.rookW);
      expect(pieceH1, AppPiece.rookW);
      expect(pieceA2, AppPiece.pawnW);
      expect(pieceB1, AppPiece.knightW);
      expect(pieceD1, AppPiece.queenW);
      expect(pieceE1, AppPiece.kingW);
      expect(pieceA8, AppPiece.rookB);
      expect(pieceH8, AppPiece.rookB);
      expect(pieceH7, AppPiece.pawnB);
      expect(pieceB8, AppPiece.knightB);
      expect(pieceD8, AppPiece.queenB);
      expect(pieceE8, AppPiece.kingB);
    });

    test('Get the current board status after playing some moves', () {
      final chessService = ChessService(save: _savePlayed);

      // first move
      {
        final pieceE2 =
            chessService.getPieceAt(SquareCoordinate.fromName('e2'));
        final pieceE4 =
            chessService.getPieceAt(SquareCoordinate.fromName('e4'));

        expect(pieceE2, isNull);
        expect(pieceE4, AppPiece.pawnW);
      }

      // second move
      {
        final pieceE7 =
            chessService.getPieceAt(SquareCoordinate.fromName('e7'));
        final pieceE5 =
            chessService.getPieceAt(SquareCoordinate.fromName('e5'));

        expect(pieceE7, isNull);
        expect(pieceE5, AppPiece.pawnB);
      }

      // third move
      {
        final pieceF1 =
            chessService.getPieceAt(SquareCoordinate.fromName('f1'));
        final pieceC4 =
            chessService.getPieceAt(SquareCoordinate.fromName('c4'));

        expect(pieceF1, isNull);
        expect(pieceC4, AppPiece.bishopW);
      }
    });

    test('move a piece when the board is in start position', () async {
      final chessService = ChessService(save: _saveNew);

      // get the possible moves for a piece and pick specific one
      final move = chessService
          .moves(from: SquareCoordinate.fromName('e2'))
          .where((e) => e.to == SquareCoordinate.fromName('e4'))
          .first;

      // move a piece
      await chessService.move(move: move);

      // check the board status by move squares
      {
        final pieceE2 =
            chessService.getPieceAt(SquareCoordinate.fromName('e2'));
        final pieceE4 =
            chessService.getPieceAt(SquareCoordinate.fromName('e4'));
        expect(pieceE2, isNull);
        expect(pieceE4, AppPiece.pawnW);
      }
    });

    test('move a piece when the board is in played position', () async {
      final chessService = ChessService(save: _savePlayed);

      // get the possible moves for a piece and pick specific one
      final move = chessService
          .moves(from: SquareCoordinate.fromName('f8'))
          .where((e) => e.to == SquareCoordinate.fromName('c5'))
          .first;

      // move a piece
      await chessService.move(move: move);

      // check the board status by move squares
      {
        final pieceE2 =
            chessService.getPieceAt(SquareCoordinate.fromName('f8'));
        final pieceE4 =
            chessService.getPieceAt(SquareCoordinate.fromName('c5'));
        expect(pieceE2, isNull);
        expect(pieceE4, AppPiece.bishopB);
      }
    });

    test('get a promotion when the board is in promotion move setup', () async {
      final chessService =
          ChessService(save: _saveToGetPromotionMove_fromB7_toB8);

      // get the possible moves for a piece and pick specific one
      final move = chessService
          .moves(from: SquareCoordinate.fromName('b7'))
          .where((e) => e.to == SquareCoordinate.fromName('b8'))
          .first;

      // check if the promotion move marked as has promotion
      expect(move.hasPromotion, isTrue);

      // move a piece
      await chessService.move(
        move: move,
        promotion: AppPiece.queenW.name,
      );

      // check the board status by move squares
      {
        final pieceB7 =
            chessService.getPieceAt(SquareCoordinate.fromName('b7'));
        final pieceB8 =
            chessService.getPieceAt(SquareCoordinate.fromName('b8'));
        expect(pieceB7, isNull);
        expect(pieceB8, AppPiece.queenW);
      }
    });

    test(
        'get a promotion is null error'
        ' when the board is in promotion move setup', () async {
      final chessService =
          ChessService(save: _saveToGetPromotionMove_fromB7_toB8);

      // get the possible moves for a piece and pick specific one
      final move = chessService
          .moves(from: SquareCoordinate.fromName('b7'))
          .where((e) => e.to == SquareCoordinate.fromName('b8'))
          .first;

      // check if the promotion move marked as has promotion
      expect(move.hasPromotion, isTrue);

      // move without promotion
      expect(
        () async => chessService.move(
          move: move,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('get a promotion when the board is in promotion capture setup',
        () async {
      final chessService =
          ChessService(save: _saveToGetPromotionCapture_fromB7_toA8);

      // get the possible moves for a piece and pick specific one
      final move = chessService
          .moves(from: SquareCoordinate.fromName('b7'))
          .where((e) => e.to == SquareCoordinate.fromName('a8'))
          .first;

      // check if the promotion move marked as has promotion
      expect(move.hasPromotion, isTrue);

      // move a piece
      await chessService.move(
        move: move,
        promotion: AppPiece.queenW.name,
      );

      // check the board status by move squares
      {
        final pieceB7 =
            chessService.getPieceAt(SquareCoordinate.fromName('b7'));
        final pieceA8 =
            chessService.getPieceAt(SquareCoordinate.fromName('a8'));
        expect(pieceB7, isNull);
        expect(pieceA8, AppPiece.queenW);
      }
    });
  });

  group('test undo, redo and reset', () {
    test('undo then redo', () async {
      final chessService = ChessService(save: _savePlayed);

      // check initial status
      expect(chessService.canRedo(), isFalse);
      expect(chessService.canUndo(), isTrue);

      // save the status before undo
      final statusBeforeUndo = chessService.save.localGameSave.currentState;

      // undo
      await chessService.undo();
      {
        final currentStatus = chessService.save.localGameSave.currentState;
        expect(chessService.canRedo(), isTrue);
        expect(chessService.canUndo(), isTrue);
        expect(currentStatus, isNot(statusBeforeUndo));
      }

      // redo
      await chessService.redo();
      {
        final currentStatus = chessService.save.localGameSave.currentState;
        expect(chessService.canRedo(), isFalse);
        expect(chessService.canUndo(), isTrue);
        expect(currentStatus, statusBeforeUndo);
      }
    });

    test('reset played game', () async {
      final chessService = ChessService(save: _savePlayed);

      // save status before reset
      final statusBeforeReset = chessService.save.localGameSave.currentState;

      // reset
      await chessService.reset();

      // check the status is changed after reset
      {
        final currentStatus = chessService.save.localGameSave.currentState;
        expect(chessService.canRedo(), isFalse);
        expect(chessService.canUndo(), isFalse);
        expect(currentStatus, isNot(statusBeforeReset));
      }

      // check the board status
      {
        final pieceE2 =
            chessService.getPieceAt(SquareCoordinate.fromName('e2'));
        final pieceE4 =
            chessService.getPieceAt(SquareCoordinate.fromName('e4'));
        final pieceE7 =
            chessService.getPieceAt(SquareCoordinate.fromName('e7'));
        final pieceE5 =
            chessService.getPieceAt(SquareCoordinate.fromName('e5'));
        final pieceF1 =
            chessService.getPieceAt(SquareCoordinate.fromName('f1'));
        final pieceC4 =
            chessService.getPieceAt(SquareCoordinate.fromName('c4'));

        expect(pieceE2, AppPiece.pawnW);
        expect(pieceE4, isNull);
        expect(pieceE7, AppPiece.pawnB);
        expect(pieceE5, isNull);
        expect(pieceF1, AppPiece.bishopW);
        expect(pieceC4, isNull);
      }
    });
  });

  group('test last move', () {
    test('get last move attributes from played save', () {
      final chessService = ChessService(save: _savePlayed);

      final lastMoveFrom = chessService.lastMoveFrom;
      final lastMoveTo = chessService.lastMoveTo;

      expect(lastMoveFrom, SquareCoordinate.fromName('f1'));
      expect(lastMoveTo, SquareCoordinate.fromName('c4'));
    });

    test('get last move attributes when there is no move', () {
      final chessService = ChessService(save: _saveNew);

      final lastMoveFrom = chessService.lastMoveFrom;
      final lastMoveTo = chessService.lastMoveTo;

      expect(lastMoveFrom, isNull);
      expect(lastMoveTo, isNull);
    });

    test('get last move attributes after move', () async {
      final chessService = ChessService(save: _saveNew);

      // get the possible moves for a piece and pick specific one
      final move = chessService
          .moves(from: SquareCoordinate.fromName('a2'))
          .where((e) => e.to == SquareCoordinate.fromName('a3'))
          .first;

      // move a piece
      await chessService.move(move: move);

      final lastMoveFrom = chessService.lastMoveFrom;
      final lastMoveTo = chessService.lastMoveTo;

      expect(lastMoveFrom, SquareCoordinate.fromName('a2'));
      expect(lastMoveTo, SquareCoordinate.fromName('a3'));
    });
  });

  group('test check status', () {
    /*
     AppChessTurnStatus _checkStatus() {
    if (_chess.game_over) {
      // checkmate
      if (_chess.in_checkmate) {
        if (_chess.turn == ch.Color.BLACK) {
          return AppChessTurnStatus.blackKingCheckmate;
        }
        return AppChessTurnStatus.whiteKingCheckmate;
      }

      // stalemate
      if (_chess.in_stalemate) {
        return AppChessTurnStatus.stalemate;
      }

      // draw
      if (_chess.in_draw) {
        return AppChessTurnStatus.draw;
      }
    }

    // check
    if (_chess.in_check) {
      if (_chess.turn == ch.Color.BLACK) {
        return AppChessTurnStatus.blackKingCheck;
      }
      return AppChessTurnStatus.whiteKingCheck;
    }

    // ongoing
    if (_chess.turn == ch.Color.BLACK) {
      return AppChessTurnStatus.black;
    }
    return AppChessTurnStatus.white;
  }


     */
    test('test when the game in checkmate', () {
      final chessService = ChessService(save: _saveCheckmate_blackLost);

      final checkStatus = chessService.turnStatus;

      expect(checkStatus, AppChessTurnStatus.blackKingCheckmate);
    });

    test('test when the game in black king is under attack', () {
      final chessService = ChessService(save: _saveBlackKingUnderAttack);

      final checkStatus = chessService.turnStatus;

      expect(checkStatus, AppChessTurnStatus.blackKingCheck);
    });

    test('test when the game is in stalemate', () {
      final chessService = ChessService(save: _saveStalemate);

      final checkStatus = chessService.turnStatus;

      expect(checkStatus, AppChessTurnStatus.stalemate);
    });

    test('test when the game is in draw', () async {
      final chessService = ChessService(save: _saveDraw);

      // check the status before move
      {
        final turnStatus = chessService.turnStatus;
        expect(
            turnStatus,
            isIn([
              AppChessTurnStatus.white,
              AppChessTurnStatus.black,
            ]));
      }

      // move 100 times in loop
      for (var i = 0; i < 100; i++) {
        final move = chessService.moves().first;
        await chessService.move(move: move);

        if (chessService.turnStatus.isGameOver) break;
      }

      // check the status after move
      {
        final turnStatus = chessService.turnStatus;
        expect(turnStatus, AppChessTurnStatus.draw);
      }
    });

    test('test when the game is ongoing', () async {
      final chessService = ChessService(save: _savePlayed);

      final checkStatus = chessService.turnStatus;
      expect(checkStatus, AppChessTurnStatus.black);

      // move a piece
      final move = chessService
          .moves(from: SquareCoordinate.fromName('f8'))
          .where((e) => e.to == SquareCoordinate.fromName('c5'))
          .first;
      await chessService.move(move: move);

      final checkStatusAfterMove = chessService.turnStatus;
      expect(checkStatusAfterMove, AppChessTurnStatus.white);
    });
  });
}

final _saveNew = LocalGameSaveCacheModel(
  id: 'id1',
  localGameSave: const LocalGameSave(
    name: 'save new',
    history: [],
    defaultPosition: TestChessFenConstants.initialFen,
  ),
);

final _savePlayed = LocalGameSaveCacheModel(
  id: 'id2',
  localGameSave: const LocalGameSave(
    name: 'save played',
    history: [
      BoardStatusAndLastMove(
        fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        lastMoveFrom: 'e2',
        lastMoveTo: 'e4',
      ),
      BoardStatusAndLastMove(
        fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 1',
        lastMoveFrom: 'e7',
        lastMoveTo: 'e5',
      ),
      BoardStatusAndLastMove(
        fen: 'rnbqkbnr/pppp1ppp/8/4p3/2B1P3/8/PPPP1PPP/RNBQK1NR b KQkq - 0 1',
        lastMoveFrom: 'f1',
        lastMoveTo: 'c4',
      ),
    ],
    defaultPosition: TestChessFenConstants.initialFen,
  ),
);

final _saveToGetPromotionMove_fromB7_toB8 = LocalGameSaveCacheModel(
  id: 'id3',
  localGameSave: const LocalGameSave(
    name: 'save to get promotion with move',
    history: [
      BoardStatusAndLastMove(
        fen: TestChessFenConstants.readyToPromotionMoveFen_b7Move,
        lastMoveFrom: 'b7',
        lastMoveTo: 'b8',
      ),
    ],
    defaultPosition: TestChessFenConstants.readyToPromotionMoveFen_b7Move,
  ),
);

final _saveToGetPromotionCapture_fromB7_toA8 = LocalGameSaveCacheModel(
  id: 'id4',
  localGameSave: const LocalGameSave(
    name: 'save to get promotion with capture',
    history: [],
    defaultPosition: TestChessFenConstants.readyToPromotionMoveFen_b7CaptureA8,
  ),
);

final _saveBlackKingUnderAttack = LocalGameSaveCacheModel(
  id: 'id5',
  localGameSave: const LocalGameSave(
    name: 'save black king under attack',
    history: [],
    defaultPosition: TestChessFenConstants.blackKingIsUnderAttackFen,
  ),
);

final _saveCheckmate_blackLost = LocalGameSaveCacheModel(
  id: 'id6',
  localGameSave: const LocalGameSave(
    name: 'save checkmate black lost',
    history: [],
    defaultPosition: TestChessFenConstants.checkmateFen_blackLost,
  ),
);

final _saveStalemate = LocalGameSaveCacheModel(
  id: 'id7',
  localGameSave: const LocalGameSave(
    name: 'save stalemate',
    history: [],
    defaultPosition: TestChessFenConstants.stalemateFen,
  ),
);

final _saveDraw = LocalGameSaveCacheModel(
  id: 'id8',
  localGameSave: const LocalGameSave(
    name: 'save draw',
    history: [],
    defaultPosition: TestChessFenConstants.preDrawFen,
  ),
);
