// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:get_it/get_it.dart';
import 'package:localchess/product/cache/app_cache.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:logger/logger.dart';

import 'hive_common.dart';

void main() {
  setUp(() async {
    // Setup GetIt
    await GetIt.I.reset();
    GetIt.I.registerSingleton<Logger>(Logger());
    GetIt.I.registerSingleton<CacheManager>(
      HiveCacheManager(path: 'test/cache/hive'),
    );
    GetIt.I.registerSingleton<AppCache>(AppCache(
      cacheManager: GetIt.I<CacheManager>(),
      logger: GetIt.I<Logger>(),
    ));

    // set logging level
    Logger.level = Level.info;

    // Initialize the cache
    await initTests();
    await G.appCache.init();
  });

  tearDown(() async {
    G.appCache.localGameSaveOperator.removeAll();
  });

  group('local game save caching test basic crud operations.', () {
    test('operator exist', () {
      expect(G.appCache.localGameSaveOperator, isNotNull);
    });

    test('save two model and read', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      final secondModel = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_2,
      );
      await G.appCache.localGameSaveOperator.save(secondModel);

      final readModels = await G.appCache.localGameSaveOperator.getAll();
      expect(readModels.length, 2);
    });

    test('get saved item by id', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      final readModel = await G.appCache.localGameSaveOperator.get('id1');
      expect(readModel, isNotNull);
    });

    test('remove saved item by id and get null', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      await G.appCache.localGameSaveOperator.remove('id1');
      final readModel = await G.appCache.localGameSaveOperator.get('id1');
      expect(readModel, isNull);
    });

    test('remove all saved items', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      final secondModel = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_2,
      );
      await G.appCache.localGameSaveOperator.save(secondModel);

      await G.appCache.localGameSaveOperator.removeAll();
      final readModels = await G.appCache.localGameSaveOperator.getAll();
      expect(readModels.length, 0);
    });

    test('save duplicated item', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      expect(
        () async {
          await G.appCache.localGameSaveOperator.save(model);
        },
        throwsA(isA<ElementAlreadyExitsError>()),
      );
    });
  });

  group('test if metadata is stores correctly', () {
    test('keep createdAt field correctly', () async {
      final beforeSave = DateTime.now().microsecondsSinceEpoch;
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);
      final afterSave = DateTime.now().microsecondsSinceEpoch;

      final readModel = await G.appCache.localGameSaveOperator.get('id1');

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
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);
      final readModel = await G.appCache.localGameSaveOperator.get('id1');
      final createdAt = readModel!.metaData!.createAt.microsecondsSinceEpoch;

      final modelToUpdate = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1_v2,
      );
      final beforeUpdate = DateTime.now().microsecondsSinceEpoch;
      await G.appCache.localGameSaveOperator.update(modelToUpdate);
      final afterUpdate = DateTime.now().microsecondsSinceEpoch;

      final readModelAfterUpdate =
          await G.appCache.localGameSaveOperator.get('id1');

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

  group('local game save caching test with sort', () {
    test('sort by createAtAsc with two elements', () async {
      // Save the first model
      final model = LocalGameSaveCacheModel(localGameSave: _sampleModel_1);
      await G.appCache.localGameSaveOperator.save(model);

      // Save the second model
      final secondModel =
          LocalGameSaveCacheModel(localGameSave: _sampleModel_2);
      await G.appCache.localGameSaveOperator.save(secondModel);

      // Get all the models with sort by createAtAsc
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtAsc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort by createAtDesc with two elements', () async {
      // Save the first model
      final model = LocalGameSaveCacheModel(localGameSave: _sampleModel_1);
      await G.appCache.localGameSaveOperator.save(model);

      // Save the second model
      final secondModel =
          LocalGameSaveCacheModel(localGameSave: _sampleModel_2);
      await G.appCache.localGameSaveOperator.save(secondModel);

      // Get all the models with sort by createAtDesc
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }
    });

    test('sort by updateAtAcs with two elements', () async {
      // Save the first model
      final model = LocalGameSaveCacheModel(localGameSave: _sampleModel_1);
      await G.appCache.localGameSaveOperator.save(model);

      // Save the second model
      final secondModel =
          LocalGameSaveCacheModel(localGameSave: _sampleModel_2);
      await G.appCache.localGameSaveOperator.save(secondModel);

      // Get all the models with sort by updateAtAcs
      {
        final firstRead = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(firstRead.length, 2);
        expect(firstRead[0].id, 'id1');
        expect(firstRead[1].id, 'id2');
      }

      // Update the first model
      await G.appCache.localGameSaveOperator.update(
        LocalGameSaveCacheModel(localGameSave: _sampleModel_1_v2),
      );

      // Get all the models with sort by updateAtAcs after update operation.
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }
    });

    test('sort by updateAtDesc with two elements', () async {
      // Save the first model
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      // Save the second model
      final secondModel = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_2,
      );
      await G.appCache.localGameSaveOperator.save(secondModel);

      // Get all the models with sort by updateAtDesc
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }

      // Update the first model
      await G.appCache.localGameSaveOperator.update(
        LocalGameSaveCacheModel(localGameSave: _sampleModel_1_v2),
      );

      // Get all the models with sort by updateAtDesc after update operation.
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort by none with two elements', () async {
      // Save the first model
      final model = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      // Save the second model
      final secondModel = LocalGameSaveCacheModel(
        localGameSave: _sampleModel_2,
      );
      await G.appCache.localGameSaveOperator.save(secondModel);

      // Get all the models with sort by none
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.none,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort with element list', () async {
      // save all the models
      await G.appCache.localGameSaveOperator.saveAll(_sampleModels);

      // Get all the models with sort by updateAtDesc
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 4);
        expect(savedModels[0].localGameSave.id, 'id4');
        expect(savedModels[1].localGameSave.id, 'id3');
        expect(savedModels[2].localGameSave.id, 'id2');
        expect(savedModels[3].localGameSave.id, 'id1');
      }

      // Update the first model
      await G.appCache.localGameSaveOperator.update(
        LocalGameSaveCacheModel(localGameSave: _sampleModel_1_v2),
      );

      // Get all the models with sort by updateAtDesc after update operation.
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 4);
        expect(savedModels[0].localGameSave.id, 'id1');
        expect(savedModels[1].localGameSave.id, 'id4');
        expect(savedModels[2].localGameSave.id, 'id3');
        expect(savedModels[3].localGameSave.id, 'id2');
      }

      // save fifth model
      await G.appCache.localGameSaveOperator.save(
        LocalGameSaveCacheModel(localGameSave: _sampleModel_5),
      );

      // Get all the models with sort by updateAtDesc after save operation.
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].localGameSave.id, 'id5');
        expect(savedModels[1].localGameSave.id, 'id1');
        expect(savedModels[2].localGameSave.id, 'id4');
        expect(savedModels[3].localGameSave.id, 'id3');
        expect(savedModels[4].localGameSave.id, 'id2');
      }

      // Get all the models with sort by updateAtAsc after save operation.
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].localGameSave.id, 'id2');
        expect(savedModels[1].localGameSave.id, 'id3');
        expect(savedModels[2].localGameSave.id, 'id4');
        expect(savedModels[3].localGameSave.id, 'id1');
        expect(savedModels[4].localGameSave.id, 'id5');
      }

      // Get all the models with sort by createAsc after save operation.
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtAsc,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].localGameSave.id, 'id1');
        expect(savedModels[1].localGameSave.id, 'id2');
        expect(savedModels[2].localGameSave.id, 'id3');
        expect(savedModels[3].localGameSave.id, 'id4');
        expect(savedModels[4].localGameSave.id, 'id5');
      }

      // Get all the models with sort by createDesc after save operation.
      {
        final savedModels = await G.appCache.localGameSaveOperator.getAll(
          sort: GetAllSortEnum.createAtDesc,
        );
        expect(savedModels.length, 5);
        expect(savedModels[0].localGameSave.id, 'id5');
        expect(savedModels[1].localGameSave.id, 'id4');
        expect(savedModels[2].localGameSave.id, 'id3');
        expect(savedModels[3].localGameSave.id, 'id2');
        expect(savedModels[4].localGameSave.id, 'id1');
      }
    });
  });
}

const _sampleModel_1 = LocalGameSave(
  id: 'id1',
  name: 'save 1',
  defaultPosition: 'bbrnqknr/pppppppp/8/8/8/8/PPPPPPPP/BBRNQKNR w - - 0 1',
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
);
const _sampleModel_1_v2 = LocalGameSave(
  id: 'id1',
  name: 'save 1',
  defaultPosition: 'bbrnqknr/pppppppp/8/8/8/8/PPPPPPPP/BBRNQKNR w - - 0 1',
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
    BoardStatusAndLastMove(
      fen: 'rnbqkbnr/p1pp1ppp/8/1p2p3/2B1P3/8/PPPP1PPP/RNBQK1NR w KQkq b6 0 1',
      lastMoveFrom: 'b7',
      lastMoveTo: 'b5',
    ),
  ],
);
const _sampleModel_2 = LocalGameSave(
  id: 'id2',
  name: 'save 2',
  defaultPosition: 'bbrnqknr/pppppppp/8/8/8/8/PPPPPPPP/BBRNQKNR w - - 0 1',
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
);
const _sampleModel_3 = LocalGameSave(
  id: 'id3',
  name: 'save 3',
  defaultPosition: 'bbrnqknr/pppppppp/8/8/8/8/PPPPPPPP/BBRNQKNR w - - 0 1',
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
);
const _sampleModel_4 = LocalGameSave(
  id: 'id4',
  name: 'save 4',
  defaultPosition: 'bbrnqknr/pppppppp/8/8/8/8/PPPPPPPP/BBRNQKNR w - - 0 1',
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
);
const _sampleModel_5 = LocalGameSave(
  id: 'id5',
  name: 'save 5',
  defaultPosition: 'bbrnqknr/pppppppp/8/8/8/8/PPPPPPPP/BBRNQKNR w - - 0 1',
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
);

List<LocalGameSaveCacheModel> _sampleModels = [
  LocalGameSaveCacheModel(localGameSave: _sampleModel_1),
  LocalGameSaveCacheModel(localGameSave: _sampleModel_2),
  LocalGameSaveCacheModel(localGameSave: _sampleModel_3),
  LocalGameSaveCacheModel(localGameSave: _sampleModel_4),
];
