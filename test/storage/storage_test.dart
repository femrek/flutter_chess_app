// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:logger/logger.dart';

import '../test_config/test_chess_fen_constants.dart';
import '../test_config/test_init.dart';

void main() async {
  // set logging level
  Logger.level = Level.info;

  // init
  await TestInit.initWithHiveImpl();

  tearDown(() async {
    G.appStorage.gameSaveOperator.removeAll();
  });

  group('local game save storing test basic crud operations.', () {
    test('operator exist', () {
      expect(G.appStorage.gameSaveOperator, isNotNull);
    });

    test('save two model and read', () async {
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);

      final secondModel = GameSaveStorageModel(
        id: 'id2',
        gameSave: _sampleModel_2,
      );
      G.appStorage.gameSaveOperator.save(secondModel);

      final readModels = G.appStorage.gameSaveOperator.getAll();
      expect(readModels.length, 2);
    });

    test('get saved item by id', () async {
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);

      final readModel = G.appStorage.gameSaveOperator.get('id1');
      expect(readModel, isNotNull);
    });

    test('remove saved item by id and get null', () async {
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);

      G.appStorage.gameSaveOperator.remove('id1');
      final readModel = G.appStorage.gameSaveOperator.get('id1');
      expect(readModel, isNull);
    });

    test('remove all saved items', () async {
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);

      final secondModel = GameSaveStorageModel(
        id: 'id2',
        gameSave: _sampleModel_2,
      );
      G.appStorage.gameSaveOperator.save(secondModel);

      G.appStorage.gameSaveOperator.removeAll();
      final readModels = G.appStorage.gameSaveOperator.getAll();
      expect(readModels.length, 0);
    });

    test('save duplicated item', () async {
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);

      expect(
        () async {
          G.appStorage.gameSaveOperator.save(model);
        },
        throwsA(isA<ElementAlreadyExitsError>()),
      );
    });
  });

  group('test if metadata is stores correctly', () {
    test('keep createdAt field correctly', () async {
      final beforeSave = DateTime.now().microsecondsSinceEpoch;
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);
      final afterSave = DateTime.now().microsecondsSinceEpoch;

      final readModel = G.appStorage.gameSaveOperator.get('id1');

      // Check if the read model is not null
      expect(readModel, isNotNull);
      expect(readModel!.metaData, isNotNull);

      // Check if the createdAt field is in the correct range
      expect(readModel.metaData!.createAt.microsecondsSinceEpoch,
          greaterThanOrEqualTo(beforeSave));
      expect(readModel.metaData!.createAt.microsecondsSinceEpoch,
          lessThanOrEqualTo(afterSave));
    });

    test('keep updateAt field correctly', () async {
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);
      final readModel = G.appStorage.gameSaveOperator.get('id1');
      final createdAt = readModel!.metaData!.createAt.microsecondsSinceEpoch;

      final modelToUpdate = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1_v2,
      );
      final beforeUpdate = DateTime.now().microsecondsSinceEpoch;
      G.appStorage.gameSaveOperator.update(modelToUpdate);
      final afterUpdate = DateTime.now().microsecondsSinceEpoch;

      final readModelAfterUpdate = G.appStorage.gameSaveOperator.get('id1');

      // Check if the read model after update is not null
      expect(readModelAfterUpdate, isNotNull);
      expect(readModelAfterUpdate!.metaData, isNotNull);

      // Check if the crateAt field is not changed
      expect(readModelAfterUpdate.metaData!.createAt.microsecondsSinceEpoch,
          equals(createdAt));

      // Check if the updateAt field is in the correct range
      expect(readModelAfterUpdate.metaData!.updateAt.microsecondsSinceEpoch,
          greaterThanOrEqualTo(beforeUpdate));
      expect(readModelAfterUpdate.metaData!.updateAt.microsecondsSinceEpoch,
          lessThanOrEqualTo(afterUpdate));
    });
  });

  group('local game save storing test with sort', () {
    test('sort by createAtAsc with two elements', () async {
      // Save the first model
      final model = GameSaveStorageModel(id: 'id1', gameSave: _sampleModel_1);
      G.appStorage.gameSaveOperator.save(model);

      // Save the second model
      final secondModel =
          GameSaveStorageModel(id: 'id2', gameSave: _sampleModel_2);
      G.appStorage.gameSaveOperator.save(secondModel);

      // Get all the models with sort by createAtAsc
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtAsc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort by createAtDesc with two elements', () async {
      // Save the first model
      final model = GameSaveStorageModel(id: 'id1', gameSave: _sampleModel_1);
      G.appStorage.gameSaveOperator.save(model);

      // Save the second model
      final secondModel =
          GameSaveStorageModel(id: 'id2', gameSave: _sampleModel_2);
      G.appStorage.gameSaveOperator.save(secondModel);

      // Get all the models with sort by createAtDesc
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }
    });

    test('sort by updateAtAcs with two elements', () async {
      // Save the first model
      final model = GameSaveStorageModel(id: 'id1', gameSave: _sampleModel_1);
      G.appStorage.gameSaveOperator.save(model);

      // Save the second model
      final secondModel =
          GameSaveStorageModel(id: 'id2', gameSave: _sampleModel_2);
      G.appStorage.gameSaveOperator.save(secondModel);

      // Get all the models with sort by updateAtAcs
      {
        final firstRead = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(firstRead.length, 2);
        expect(firstRead[0].id, 'id1');
        expect(firstRead[1].id, 'id2');
      }

      // Update the first model
      G.appStorage.gameSaveOperator.update(
        GameSaveStorageModel(id: 'id1', gameSave: _sampleModel_1_v2),
      );

      // Get all the models with sort by updateAtAcs after update operation.
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }
    });

    test('sort by updateAtDesc with two elements', () async {
      // Save the first model
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);

      // Save the second model
      final secondModel = GameSaveStorageModel(
        id: 'id2',
        gameSave: _sampleModel_2,
      );
      G.appStorage.gameSaveOperator.save(secondModel);

      // Get all the models with sort by updateAtDesc
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }

      // Update the first model
      G.appStorage.gameSaveOperator.update(
        GameSaveStorageModel(id: 'id1', gameSave: _sampleModel_1_v2),
      );

      // Get all the models with sort by updateAtDesc after update operation.
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort by none with two elements', () async {
      // Save the first model
      final model = GameSaveStorageModel(
        id: 'id1',
        gameSave: _sampleModel_1,
      );
      G.appStorage.gameSaveOperator.save(model);

      // Save the second model
      final secondModel = GameSaveStorageModel(
        id: 'id2',
        gameSave: _sampleModel_2,
      );
      G.appStorage.gameSaveOperator.save(secondModel);

      // Get all the models with sort by none
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.none,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort with element list', () async {
      // save all the models
      G.appStorage.gameSaveOperator.saveAll(_sampleModels);

      // Get all the models with sort by updateAtDesc
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 4);
        expect(savedModels[0].id, 'id4');
        expect(savedModels[1].id, 'id3');
        expect(savedModels[2].id, 'id2');
        expect(savedModels[3].id, 'id1');
      }

      // Update the first model
      G.appStorage.gameSaveOperator.update(
        GameSaveStorageModel(id: 'id1', gameSave: _sampleModel_1_v2),
      );

      // Get all the models with sort by updateAtDesc after update operation.
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 4);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id4');
        expect(savedModels[2].id, 'id3');
        expect(savedModels[3].id, 'id2');
      }

      // save fifth model
      G.appStorage.gameSaveOperator.save(
        GameSaveStorageModel(id: 'id5', gameSave: _sampleModel_5),
      );

      // Get all the models with sort by updateAtDesc after save operation.
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].id, 'id5');
        expect(savedModels[1].id, 'id1');
        expect(savedModels[2].id, 'id4');
        expect(savedModels[3].id, 'id3');
        expect(savedModels[4].id, 'id2');
      }

      // Get all the models with sort by updateAtAsc after save operation.
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id3');
        expect(savedModels[2].id, 'id4');
        expect(savedModels[3].id, 'id1');
        expect(savedModels[4].id, 'id5');
      }

      // Get all the models with sort by createAsc after save operation.
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtAsc,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
        expect(savedModels[2].id, 'id3');
        expect(savedModels[3].id, 'id4');
        expect(savedModels[4].id, 'id5');
      }

      // Get all the models with sort by createDesc after save operation.
      {
        final savedModels = G.appStorage.gameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtDesc,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].id, 'id5');
        expect(savedModels[1].id, 'id4');
        expect(savedModels[2].id, 'id3');
        expect(savedModels[3].id, 'id2');
        expect(savedModels[4].id, 'id1');
      }
    });
  });
}

const _sampleModel_1 = GameSave(
  name: 'save 1',
  defaultPosition: TestChessFenConstants.initialFen,
  history: [
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_1stMove_e4,
      lastMoveFrom: 'e2',
      lastMoveTo: 'e4',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_2ndMove_e5,
      lastMoveFrom: 'e7',
      lastMoveTo: 'e5',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_3rdMove_c4,
      lastMoveFrom: 'f1',
      lastMoveTo: 'c4',
    ),
  ],
  isGameOver: false,
);
const _sampleModel_1_v2 = GameSave(
  name: 'save 1',
  defaultPosition: TestChessFenConstants.initialFen,
  history: [
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_1stMove_e4,
      lastMoveFrom: 'e2',
      lastMoveTo: 'e4',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_2ndMove_e5,
      lastMoveFrom: 'e7',
      lastMoveTo: 'e5',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_3rdMove_c4,
      lastMoveFrom: 'f1',
      lastMoveTo: 'c4',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_3rdMove_c4,
      lastMoveFrom: 'b7',
      lastMoveTo: 'b5',
    ),
  ],
  isGameOver: false,
);
const _sampleModel_2 = GameSave(
  name: 'save 2',
  defaultPosition: TestChessFenConstants.initialFen,
  history: [
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_1stMove_e4,
      lastMoveFrom: 'e2',
      lastMoveTo: 'e4',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_2ndMove_e5,
      lastMoveFrom: 'e7',
      lastMoveTo: 'e5',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_3rdMove_c4,
      lastMoveFrom: 'f1',
      lastMoveTo: 'c4',
    ),
  ],
  isGameOver: false,
);
const _sampleModel_3 = GameSave(
  name: 'save 3',
  defaultPosition: TestChessFenConstants.initialFen,
  history: [
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_1stMove_e4,
      lastMoveFrom: 'e2',
      lastMoveTo: 'e4',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_2ndMove_e5,
      lastMoveFrom: 'e7',
      lastMoveTo: 'e5',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_3rdMove_c4,
      lastMoveFrom: 'f1',
      lastMoveTo: 'c4',
    ),
  ],
  isGameOver: false,
);
const _sampleModel_4 = GameSave(
  name: 'save 4',
  defaultPosition: TestChessFenConstants.initialFen,
  history: [
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_1stMove_e4,
      lastMoveFrom: 'e2',
      lastMoveTo: 'e4',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_2ndMove_e5,
      lastMoveFrom: 'e7',
      lastMoveTo: 'e5',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_3rdMove_c4,
      lastMoveFrom: 'f1',
      lastMoveTo: 'c4',
    ),
  ],
  isGameOver: false,
);
const _sampleModel_5 = GameSave(
  name: 'save 5',
  defaultPosition: TestChessFenConstants.initialFen,
  history: [
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_1stMove_e4,
      lastMoveFrom: 'e2',
      lastMoveTo: 'e4',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_2ndMove_e5,
      lastMoveFrom: 'e7',
      lastMoveTo: 'e5',
    ),
    BoardStatusAndLastMove(
      fen: TestChessFenConstants.initialFen_3rdMove_c4,
      lastMoveFrom: 'f1',
      lastMoveTo: 'c4',
    ),
  ],
  isGameOver: false,
);

List<GameSaveStorageModel> _sampleModels = [
  GameSaveStorageModel(id: 'id1', gameSave: _sampleModel_1),
  GameSaveStorageModel(id: 'id2', gameSave: _sampleModel_2),
  GameSaveStorageModel(id: 'id3', gameSave: _sampleModel_3),
  GameSaveStorageModel(id: 'id4', gameSave: _sampleModel_4),
];
