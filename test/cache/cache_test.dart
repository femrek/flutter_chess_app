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
  const sampleModel_1 = LocalGameSave(
    id: 'id1',
    name: 'save 1',
    history: [
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2',
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
    ],
  );
  const sampleModel_1_v2 = LocalGameSave(
    id: 'id1',
    name: 'save 1',
    history: [
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2',
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 1 3',
    ],
  );
  const sampleModel_2 = LocalGameSave(
    id: 'id2',
    name: 'save 2',
    history: [
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2',
      'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
    ],
  );

  Logger logger = Logger();
  setUp(() async {
    logger.d('setUp');
    await GetIt.I.reset();
    await initTests();

    GetIt.I.registerSingleton<CacheManager>(
      HiveCacheManager(path: 'test/cache/hive'),
    );
    GetIt.I.registerSingleton<AppCache>(AppCache(
      cacheManager: GetIt.I<CacheManager>(),
    ));

    await G.appCache.init();
  });

  tearDown(() async {
    G.appCache.localGameSaveOperator.removeAll();
  });

  group('local game save caching test', () {
    test('operator exist', () {
      expect(G.appCache.localGameSaveOperator, isNotNull);
    });

    test('save two model and read', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      final secondModel = LocalGameSaveCacheModel(
        localGameSave: sampleModel_2,
      );
      await G.appCache.localGameSaveOperator.save(secondModel);

      final readModels = await G.appCache.localGameSaveOperator.getAll();
      expect(readModels.length, 2);
    });

    test('get saved item by id', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      final readModel = await G.appCache.localGameSaveOperator.get('id1');
      expect(readModel, isNotNull);
    });

    test('remove saved item by id and get null', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      await G.appCache.localGameSaveOperator.remove('id');
      final readModel = await G.appCache.localGameSaveOperator.get('id');
      expect(readModel, isNull);
    });

    test('remove all saved items', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      final secondModel = LocalGameSaveCacheModel(
        localGameSave: sampleModel_2,
      );
      await G.appCache.localGameSaveOperator.save(secondModel);

      await G.appCache.localGameSaveOperator.removeAll();
      final readModels = await G.appCache.localGameSaveOperator.getAll();
      expect(readModels.length, 0);
    });

    test('save duplicated item', () async {
      final model = LocalGameSaveCacheModel(
        localGameSave: sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);

      expect(
        () async {
          await G.appCache.localGameSaveOperator.save(model);
        },
        throwsA(isA<ElementAlreadyExitsError>()),
      );
    });

    test('keep createdAt field correctly', () async {
      final beforeSave = DateTime.now().microsecondsSinceEpoch;
      final model = LocalGameSaveCacheModel(
        localGameSave: sampleModel_1,
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
        localGameSave: sampleModel_1,
      );
      await G.appCache.localGameSaveOperator.save(model);
      final readModel = await G.appCache.localGameSaveOperator.get('id1');
      final createdAt = readModel!.metaData!.createAt.microsecondsSinceEpoch;

      final modelToUpdate = LocalGameSaveCacheModel(
        localGameSave: sampleModel_1_v2,
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
}
