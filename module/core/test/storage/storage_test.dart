// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'test_config/hive_common.dart';
import 'test_config/sample_model.dart';
import 'test_config/sample_storage_model.dart';

void main() async {
  // Make it able to use hive in desktop
  await initHiveTests();

  final logger = Logger();
  final manager = HiveStorageManager(path: 'test/storage/hive');
  final operator = HiveStorageOperator<SampleStorageModel>(logger: logger);

  await manager.init();
  manager.registerStorageModel<SampleStorageModel>(SampleStorageModel.empty());

  // ignore: unnecessary_lambdas
  setUp(() {
    operator.removeAll();
  });

  group('Create usable objects', () {
    test('Manager and Operator is not null', () {
      expect(manager, isNotNull);
      expect(operator, isNotNull);
    });
  });

  group('Turn models into storage models.', () {
    <SampleModel, (String id, String data)>{
      SampleModel.empty(): ('', ''),
      SampleModel(id: 'id1', data: 'data1'): ('id1', 'data1'),
    }.forEach((input, expected) {
      final eId = expected.$1;
      final eData = expected.$2;

      test('$input', () {
        final storageModel = SampleStorageModel(data: input);

        expect(storageModel.id, eId);
        expect(storageModel.data.id, eId);
        expect(storageModel.data.data, eData);
      });
    });
  });

  group('Save items, then read correct and there is no missing fields', () {
    <SampleModel>[
      SampleModel(id: 'id1', data: 'data1'),
      SampleModel(id: 'id2', data: 'data2'),
      SampleModel(id: 'id3', data: 'data3'),
      SampleModel(id: 'id4', data: 'data4'),
      // ignore: avoid_function_literals_in_foreach_calls
    ].forEach((input) {
      test('$input', () {
        final storageModel = SampleStorageModel(data: input);
        late final DateTime beforeSave;
        late final DateTime afterSave;

        // Save the item and validate saved correctly
        {
          beforeSave = DateTime.now();
          final saved = operator.save(storageModel);
          afterSave = DateTime.now();

          expect(saved, isNotNull);
          expect(saved.id, input.id);
          expect(saved.data.id, input.id);
          expect(saved.data.data, input.data);
        }

        // Read the saved item and validate
        {
          final read = operator.get(input.id);

          expect(read, isNotNull);
          expect(read!.id, input.id);
          expect(read.data.id, input.id);
          expect(read.data.data, input.data);

          // Check if the createdAt field is in the correct range
          expect(read.metaData!.createAt.microsecondsSinceEpoch,
              greaterThan(beforeSave.microsecondsSinceEpoch));
          expect(read.metaData!.createAt.microsecondsSinceEpoch,
              lessThan(afterSave.microsecondsSinceEpoch));
        }
      });
    });
  });

  group('Save items, then read (a group of elements are saving.)', () {
    final inputs = <SampleModel>[
      SampleModel(id: 'id1', data: 'data1'),
      SampleModel(id: 'id2', data: 'data2'),
      SampleModel(id: 'id3', data: 'data3'),
      SampleModel(id: 'id4', data: 'data4'),
    ];
    test('$inputs', () {
      for (final input in inputs) {
        final storageModel = SampleStorageModel(data: input);
        late final DateTime beforeSave;
        late final DateTime afterSave;

        // Save the item and validate saved correctly
        {
          beforeSave = DateTime.now();
          final saved = operator.save(storageModel);
          afterSave = DateTime.now();

          expect(saved, isNotNull);
          expect(saved.id, input.id);
          expect(saved.data.id, input.id);
          expect(saved.data.data, input.data);
        }

        // Read the saved item and validate
        {
          final read = operator.get(input.id);

          expect(read, isNotNull);
          expect(read!.id, input.id);
          expect(read.data.id, input.id);
          expect(read.data.data, input.data);

          // Check if the createdAt field is in the correct range
          expect(read.metaData!.createAt.microsecondsSinceEpoch,
              greaterThan(beforeSave.microsecondsSinceEpoch));
          expect(read.metaData!.createAt.microsecondsSinceEpoch,
              lessThan(afterSave.microsecondsSinceEpoch));
        }
      }

      // Get all the saved items and validate
      {
        final savedModels = operator.getAll();
        expect(savedModels.length, inputs.length);

        for (var i = 0; i < inputs.length; i++) {
          final input = inputs[i];
          final saved = savedModels[i];

          expect(saved.id, input.id);
          expect(saved.data.id, input.id);
          expect(saved.data.data, input.data);
        }
      }
    });
  });

  group('local game save storing test with sort', () {
    test('sort by createAtAsc with two elements', () async {
      // Save the first model
      final model = SampleStorageModel(
        data: SampleModel(id: 'id1', data: 'data1'),
      );
      operator.save(model);

      // Save the second model
      final secondModel =
          SampleStorageModel(data: SampleModel(id: 'id2', data: 'data2'));
      operator.save(secondModel);

      // Get all the models with sort by createAtAsc
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.createAtAsc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort by createAtDesc with two elements', () async {
      // Save the first model
      final model = SampleStorageModel(
        data: SampleModel(id: 'id1', data: 'data1'),
      );
      operator.save(model);

      // Save the second model
      final secondModel = SampleStorageModel(
        data: SampleModel(id: 'id2', data: 'data2'),
      );
      operator.save(secondModel);

      // Get all the models with sort by createAtDesc
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.createAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }
    });

    test('sort by updateAtAcs with two elements', () async {
      // Save the first model
      final model = SampleStorageModel(
        data: SampleModel(id: 'id1', data: 'data1'),
      );
      operator.save(model);

      // Save the second model
      final secondModel = SampleStorageModel(
        data: SampleModel(id: 'id2', data: 'data2'),
      );
      operator.save(secondModel);

      // Get all the models with sort by updateAtAcs
      {
        final firstRead = operator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(firstRead.length, 2);
        expect(firstRead[0].id, 'id1');
        expect(firstRead[1].id, 'id2');
      }

      // Update the first model
      operator.update(
        SampleStorageModel(data: SampleModel(id: 'id1', data: 'data1_v2')),
      );

      // Get all the models with sort by updateAtAcs after update operation.
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.updateAtAcs,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }
    });

    test('sort by updateAtDesc with two elements', () async {
      // Save the first model
      final model = SampleStorageModel(
        data: SampleModel(id: 'id1', data: 'data1'),
      );
      operator.save(model);

      // Save the second model
      final secondModel = SampleStorageModel(
        data: SampleModel(id: 'id2', data: 'data2'),
      );
      operator.save(secondModel);

      // Get all the models with sort by updateAtDesc
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id2');
        expect(savedModels[1].id, 'id1');
      }

      // Update the first model
      operator.update(
        SampleStorageModel(data: SampleModel(id: 'id1', data: 'data1_v2')),
      );

      // Get all the models with sort by updateAtDesc after update operation.
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort by none with two elements', () async {
      // Save the first model
      final model = SampleStorageModel(
        data: SampleModel(id: 'id1', data: 'data1'),
      );
      operator.save(model);

      // Save the second model
      final secondModel = SampleStorageModel(
        data: SampleModel(id: 'id2', data: 'data2'),
      );
      operator.save(secondModel);

      // Get all the models with sort by none
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.none,
        );
        expect(savedModels.length, 2);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id2');
      }
    });

    test('sort with element list', () async {
      // save all the models
      operator.saveAll([
        SampleStorageModel(data: SampleModel(id: 'id1', data: 'data1')),
        SampleStorageModel(data: SampleModel(id: 'id2', data: 'data2')),
        SampleStorageModel(data: SampleModel(id: 'id3', data: 'data3')),
        SampleStorageModel(data: SampleModel(id: 'id4', data: 'data4')),
      ]);

      // Get all the models with sort by updateAtDesc
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 4);
        expect(savedModels[0].id, 'id4');
        expect(savedModels[1].id, 'id3');
        expect(savedModels[2].id, 'id2');
        expect(savedModels[3].id, 'id1');
      }

      // Update the first model
      operator.update(SampleStorageModel(
        data: SampleModel(id: 'id1', data: 'data1_v2'),
      ));

      // Get all the models with sort by updateAtDesc after update operation.
      {
        final savedModels = operator.getAll(
          sort: GetAllSortEnum.updateAtDesc,
        );
        expect(savedModels.length, 4);
        expect(savedModels[0].id, 'id1');
        expect(savedModels[1].id, 'id4');
        expect(savedModels[2].id, 'id3');
        expect(savedModels[3].id, 'id2');
      }

      // save fifth model
      operator.save(SampleStorageModel(
        data: SampleModel(id: 'id5', data: 'data5'),
      ));

      // Get all the models with sort by updateAtDesc after save operation.
      {
        final savedModels = operator.getAll(
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
        final savedModels = operator.getAll(
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
        final savedModels = operator.getAll(
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
        final savedModels = operator.getAll(
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
