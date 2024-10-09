import 'package:core/src/storage/core/storage_model.dart';
import 'package:core/src/storage/core/storage_model_meta_data.dart';
import 'package:core/src/storage/core/storage_operator.dart';
import 'package:core/src/storage/error/element_already_exits_error.dart';
import 'package:core/src/storage/error/element_does_not_exist_when_update_error.dart';
import 'package:core/src/storage/error/element_id_duplicated_error.dart';
import 'package:core/src/storage/sort/get_all_sort_enum.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

/// [StorageOperator] implementation using Hive
class HiveStorageOperator<T extends StorageModel>
    implements StorageOperator<T> {
  /// Creates a new [HiveStorageOperator] instance.
  HiveStorageOperator({required Logger logger}) : log = logger {
    _box = Hive.box<T>(name: T.toString());
  }

  late final Box<T> _box;

  /// The logger
  final Logger log;

  @override
  T? get(String id) {
    log.t('Getting item <$T> with id $id');
    final item = _box.get(id);
    if (item == null) {
      log.w('Item with id $id does not exist.');
    } else {
      log.t('Item with id $id found.');
    }
    return item;
  }

  @override
  List<T> getAll({GetAllSortEnum sort = GetAllSortEnum.none}) {
    log.t('Getting all items <$T>');

    var result = <T>[];
    if (sort == GetAllSortEnum.none) {
      result =
          _box.getAll(_box.keys).where((e) => e != null).cast<T>().toList();
    } else {
      outer:
      for (final key in _box.keys) {
        final item = _box.get(key)!;
        for (var i = 0; i < result.length; i++) {
          final nth = result[i];
          if (sort.canInsertLeft(checking: item, nthModel: nth)) {
            result.insert(i, item);
            continue outer;
          }
        }
        result.add(item);
      }
    }

    log.t('Found ${result.length} items <$T>');
    return result;
  }

  @override
  bool remove(String id) {
    log.t('Removing item <$T> with id $id');

    final result = _box.delete(id);

    if (result) {
      log.t('Item with id $id removed.');
    } else {
      log.w('Item with id $id does not exist.');
    }
    return result;
  }

  @override
  void removeAll() {
    log.t('Removing all items <$T>');

    _box.deleteAll(_box.keys);

    log.t('All items <$T> removed.');
  }

  @override
  T save(T item) {
    log.t('Saving item <$T> with id ${item.id}');

    // Check if the item already exists
    if (_box.containsKey(item.id)) {
      log.e('The item with id ${item.id} already exists in the cache.');
      throw ElementAlreadyExitsError(
          'The item with id ${item.id} already exists in the cache.');
    }

    // Save the item
    final saveTime = DateTime.now();
    final metaData = StorageModelMetaData(
      createAt: saveTime,
      updateAt: saveTime,
    );
    log.d('Saving item with id ${item.id} and metadata $metaData');
    _box.put(
      item.id,
      item..metaData = metaData,
    );

    log.t('Item with id ${item.id} saved.');

    return item;
  }

  @override
  List<T> saveAll(List<T> items) {
    log.t('Saving ${items.length} items <$T>');

    // validate the items
    final validItems = <String, T>{};
    for (final item in items) {
      // Check if the id is duplicated
      if (validItems.containsKey(item.id)) {
        throw ElementIdDuplicatedError('The id ${item.id} is duplicated.');
      }
      final saveTime = DateTime.now();
      final metaData = StorageModelMetaData(
        createAt: saveTime,
        updateAt: saveTime,
      );
      log.d('Saving item with id ${item.id} and metadata $metaData');
      validItems[item.id] = item..metaData = metaData;

      // Check if the item already exists
      if (_box.containsKey(item.id)) {
        throw ElementAlreadyExitsError(
            'The item with id ${item.id} already exists in the cache.');
      }
    }

    // Save the items
    _box.putAll(validItems);

    log.t('${validItems.length} items <$T> saved.');

    return validItems.values.toList();
  }

  @override
  T update(T item) {
    log.t('Updating item <$T> with id ${item.id}');

    final savedItem = _box.get(item.id);
    if (savedItem == null) {
      log.e('The item with id ${item.id} does not exist in the cache.');
      throw ElementDoesNotExistWhenUpdateError(
          'The item with id ${item.id} does not exist in the cache.');
    }
    if (savedItem.metaData == null) {
      log.w('The item with id ${item.id} had not had metadata.');
    }

    final updateTime = DateTime.now();
    final metaData = StorageModelMetaData(
      createAt: savedItem.metaData?.createAt ?? updateTime,
      updateAt: updateTime,
    );
    log.d('Updating item with id ${item.id} and metadata $metaData');
    _box.put(
      item.id,
      item..metaData = metaData,
    );

    log.t('Item with id ${item.id} updated.');

    return item;
  }

  @override
  List<T> updateAll(List<T> items) {
    log.t('Updating ${items.length} items <$T>');

    // validate the items
    final validItems = <String, T>{};
    for (final item in items) {
      final savedItem = _box.get(item.id);

      // Check if the item already exists
      if (savedItem == null) {
        log.e('The item with id ${item.id} does not exist in the cache.');
        throw ElementDoesNotExistWhenUpdateError(
            'The item with id ${item.id} does not exist in the cache.');
      }
      if (savedItem.metaData == null) {
        log.w('The item with id ${item.id} had not had metadata.');
      }

      // Check if the id is duplicated
      if (validItems.containsKey(item.id)) {
        log.e('The id ${item.id} is duplicated.');
        throw ElementIdDuplicatedError('The id ${item.id} is duplicated.');
      }

      final updateTime = DateTime.now();
      final metaData = StorageModelMetaData(
        createAt: savedItem.metaData?.createAt ?? updateTime,
        updateAt: updateTime,
      );
      log.d('Updating item with id ${item.id} and metadata $metaData');
      validItems[item.id] = item..metaData = metaData;
    }

    // Save the items
    _box.putAll(validItems);

    log.t('${validItems.length} items <$T> updated.');

    return validItems.values.toList();
  }
}
