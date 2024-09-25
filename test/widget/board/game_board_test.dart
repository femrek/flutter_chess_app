import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localchess/product/data/piece/app_piece.dart';
import 'package:localchess/product/data/square_data.dart';
import 'package:localchess/product/widget/board/board_square_content.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';
import 'package:logger/logger.dart';

import '../../test_config/test_init.dart';

void main() async {
  Logger.level = Level.info;

  await TestInit.initWithTestCacheImpl();

  group('load game to the board', () {
    testWidgets('create empty board', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: GameBoardWithFrame.portrait(
          size: 100,
          squareBuilder: (context, coordinate, unitSize) {
            return const SizedBox.shrink(key: ValueKey('square'));
          },
        ),
      ));

      // check if there are 2 'A' to 'H' coordinates
      expect(find.text('A'), findsNWidgets(2));
      expect(find.text('B'), findsNWidgets(2));
      expect(find.text('C'), findsNWidgets(2));
      expect(find.text('D'), findsNWidgets(2));
      expect(find.text('E'), findsNWidgets(2));
      expect(find.text('F'), findsNWidgets(2));
      expect(find.text('G'), findsNWidgets(2));
      expect(find.text('H'), findsNWidgets(2));

      // check if there are 2 '1' to '8' coordinates
      expect(find.text('1'), findsNWidgets(2));
      expect(find.text('2'), findsNWidgets(2));
      expect(find.text('3'), findsNWidgets(2));
      expect(find.text('4'), findsNWidgets(2));
      expect(find.text('5'), findsNWidgets(2));
      expect(find.text('6'), findsNWidgets(2));
      expect(find.text('7'), findsNWidgets(2));
      expect(find.text('8'), findsNWidgets(2));

      // check if there are 64 squares
      expect(find.byKey(const ValueKey('square')), findsNWidgets(64));
    });
  });

  group(
      'test square content with square data.'
      ' Validate only if it is created', () {
    testWidgets('create an empty square', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: BoardSquareContent(
          unitSize: 100,
          data: SquareData.withDefaultValues(),
        ),
      ));

      {
        final square = find.byType(BoardSquareContent);
        expect(square, findsOneWidget);
      }
    });

    testWidgets('create a square with a piece', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: BoardSquareContent(
          unitSize: 100,
          data: SquareData(
            canMove: true,
            isThisCheck: true,
            isLastMoveFromThis: true,
            isLastMoveToThis: true,
            isFocusedOnThis: true,
            isSyncInProcess: true,
            piece: AppPiece.pawnW,
          ),
        ),
      ));

      {
        final square = find.byType(BoardSquareContent);
        expect(square, findsOneWidget);
      }
    });
  });
}
