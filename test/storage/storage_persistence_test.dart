import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_config/test_chess_fen_constants.dart';

void main() {
  setUp(() {
    // Initialize SharedPreferences with mock data
    WidgetsFlutterBinding.ensureInitialized();
    const gameSave = GameSave(
      name: 'test name',
      history: [
        BoardStatusAndLastMove(
          fen: TestChessFenConstants.initialFen_1stMove_e4,
          lastMoveFrom: 'e2',
          lastMoveTo: 'e4',
        ),
      ],
      defaultPosition: TestChessFenConstants.initialFen,
      isGameOver: false,
    );
    final storageModel = GameSaveStorageModel(
      id: 'test-id',
      gameSave: gameSave,
    );
    final now = DateTime.now();
    final metaData = StorageModelMetaData(
      createAt: now,
      updateAt: now,
    );
    final map = storageModel.toJson();
    map['metaData'] = metaData.toJson();
    SharedPreferences.setMockInitialValues({
      'GameSaveStorageModel': [jsonEncode(map)],
    });

    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 10,
      ),
    );
    GetIt.I.registerSingleton<Logger>(logger);
  });

  group('Storage Persistence Test', () {
    test('Read existing and save persistent data', () async {
      // Initialize the storage manager and operator
      const storageManager = SharedPreferencesStorageManager();
      await storageManager.init();
      storageManager.registerStorageModel(GameSaveStorageModel(
        id: '',
        gameSave: GameSave.empty(),
      ));
      final operator = SharedPreferencesStorageOperator<GameSaveStorageModel>(
        logger: GetIt.I<Logger>(),
      );

      // Retrieve all elements
      final allElements = operator.getAll();

      // Verify the retrieved data
      expect(allElements.length, 1);
      final firstSave = allElements.firstOrNull;
      expect(firstSave, isNotNull);
      expect(firstSave!.id, 'test-id');
      expect(firstSave.gameSave.name, 'test name');
      expect(
          firstSave.gameSave.defaultPosition, TestChessFenConstants.initialFen);
      expect(firstSave.gameSave.isGameOver, false);
      expect(firstSave.gameSave.history.length, 1);
      final historyFirst = firstSave.gameSave.history.first;
      expect(historyFirst.lastMoveFrom, 'e2');
      expect(historyFirst.lastMoveTo, 'e4');
      expect(
        historyFirst.fen,
        TestChessFenConstants.initialFen_1stMove_e4,
      );

      final updatedStorageModel = GameSaveStorageModel(
        id: firstSave.id,
        gameSave: firstSave.gameSave.copyWith(
          name: 'updated name',
        ),
      );

      operator.update(updatedStorageModel);

      final newOperator =
          SharedPreferencesStorageOperator<GameSaveStorageModel>(
        logger: GetIt.I<Logger>(),
      );

      // Retrieve all elements again
      final allElementsAfterUpdate = newOperator.getAll();

      // Verify the retrieved data
      expect(allElementsAfterUpdate.length, 1);
      final updatedSave = allElementsAfterUpdate.firstOrNull;
      expect(updatedSave, isNotNull);
      expect(updatedSave!.id, 'test-id');
      expect(updatedSave.gameSave.name, 'updated name'); // updated name
      expect(updatedSave.gameSave.defaultPosition,
          TestChessFenConstants.initialFen);
      expect(updatedSave.gameSave.isGameOver, false);
      expect(updatedSave.gameSave.history.length, 1);
      final historyUpdatedSave = firstSave.gameSave.history.first;
      expect(historyUpdatedSave.lastMoveFrom, 'e2');
      expect(historyUpdatedSave.lastMoveTo, 'e4');
      expect(
        historyUpdatedSave.fen,
        TestChessFenConstants.initialFen_1stMove_e4,
      );
    });
  });
}
