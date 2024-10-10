// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/util/date_extension.dart';
import 'package:localchess/product/widget/list_tile/app_save_list_tile.dart';

void main() {
  final now = DateTime.now();

  final newGameSave = GameSaveStorageModel.fromJson({
    'id': 'id1',
    'metaData': StorageModelMetaData(
      createAt: now,
      updateAt: now,
    ).toJson(),
    'data': const GameSave(
      isGameOver: false,
      defaultPosition: '',
      history: [],
      name: 'name1',
    ).toJson(),
  });

  final updatedGameSave = GameSaveStorageModel.fromJson({
    'id': 'id2',
    'metaData': StorageModelMetaData(
      createAt: now,
      updateAt: now.add(const Duration(seconds: 1)),
    ).toJson(),
    'data': const GameSave(
      isGameOver: false,
      defaultPosition: '',
      history: [],
      name: 'name2',
    ).toJson(),
  });

  final newGameSave_v2 = GameSaveStorageModel.fromJson({
    'id': 'id1',
    'metaData': StorageModelMetaData(
      createAt: now,
      updateAt: now,
    ).toJson(),
    'data': const GameSave(
      isGameOver: false,
      defaultPosition: '',
      history: [],
      name: 'name1_2',
    ).toJson(),
  });

  final endGameSave = GameSaveStorageModel.fromJson({
    'id': 'id3',
    'metaData': StorageModelMetaData(
      createAt: now,
      updateAt: now.add(const Duration(seconds: 1)),
    ).toJson(),
    'data': const GameSave(
      isGameOver: true,
      defaultPosition: '',
      history: [],
      name: 'name3',
    ).toJson(),
  });

  group(
    'AppSaveListTile shows the name and last played or created at correct',
    () {
      <GameSaveStorageModel, (bool showCreated, bool showUpdated)>{
        newGameSave: (true, false),
        updatedGameSave: (false, true),
        newGameSave_v2: (true, false),
      }.forEach((input, expected) {
        final eShowCreated = expected.$1;
        final eShowUpdated = expected.$2;

        testWidgets('$input => $expected', (tester) async {
          await tester.pumpWidget(MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: AppSaveListTile(
                data: input,
                onPlayPressed: (_, __) {},
                onRemovePressed: (_) {},
              ),
            ),
          ));

          // check if the name is shown
          expect(find.text(input.gameSave.name), findsOneWidget);

          // check if the created is shown
          if (eShowCreated) {
            expect(
              find.text(
                LocaleKeys.widget_saveListTile_lastPlayed_created.tr(
                  namedArgs: {
                    'dateTime': input.metaData?.createAt.toVisualFormat ?? '',
                  },
                ),
              ),
              findsOneWidget,
            );
          }

          // check if the last played is shown
          if (eShowUpdated) {
            expect(
              find.text(
                LocaleKeys.widget_saveListTile_lastPlayed_lastPlayed.tr(
                  namedArgs: {
                    'dateTime': input.metaData?.updateAt.toVisualFormat ?? '',
                  },
                ),
              ),
              findsOneWidget,
            );
          }
        });
      });
    },
  );

  group('AppSaveListTile buttons are able to click', () {
    testWidgets('onPlayPressed is called when the game is not over',
        (tester) async {
      var isOnPlayPressedCalled = false;
      var isOnRemovePressedCalled = false;

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: AppSaveListTile(
            data: newGameSave,
            onPlayPressed: (_, __) {
              isOnPlayPressedCalled = true;
            },
            onRemovePressed: (_) {
              isOnRemovePressedCalled = true;
            },
          ),
        ),
      ));

      // check if the play button is shown
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);

      // check if the remove button is not shown
      expect(find.byIcon(Icons.delete), findsNothing);

      // click the play button
      await tester.tap(find.byIcon(Icons.play_circle_outline));
      await tester.pump();

      // check if the onPlayPressed is called
      expect(isOnPlayPressedCalled, isTrue);
      expect(isOnRemovePressedCalled, isFalse);
    });

    testWidgets('onRemovePressed is called when the game is over',
        (tester) async {
      var isOnPlayPressedCalled = false;
      var isOnRemovePressedCalled = false;

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: AppSaveListTile(
            data: endGameSave,
            onPlayPressed: (_, __) {
              isOnPlayPressedCalled = true;
            },
            onRemovePressed: (_) {
              isOnRemovePressedCalled = true;
            },
          ),
        ),
      ));

      // check if the play button is not shown
      expect(find.byIcon(Icons.play_circle_outline), findsNothing);

      // check if the remove button is shown
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // click the remove button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // check if the onRemovePressed is called
      expect(isOnPlayPressedCalled, isFalse);
      expect(isOnRemovePressedCalled, isTrue);
    });
  });
}
