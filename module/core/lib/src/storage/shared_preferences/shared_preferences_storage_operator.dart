import 'dart:convert';

import 'package:core/src/storage/core/storage_model.dart';
import 'package:core/src/storage/core/storage_model_meta_data.dart';
import 'package:core/src/storage/core/storage_operator.dart';
import 'package:core/src/storage/error/element_already_exits_error.dart';
import 'package:core/src/storage/error/element_does_not_exist_when_update_error.dart';
import 'package:core/src/storage/error/element_id_duplicated_error.dart';
import 'package:core/src/storage/sort/get_all_sort_enum.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [StorageOperator] implementation using [SharedPreferences]
class SharedPreferencesStorageOperator<T extends StorageModel>
    implements StorageOperator<T> {
  /// Creates a new [SharedPreferencesStorageOperator] instance.
  SharedPreferencesStorageOperator({required Logger logger}) : log = logger;

  /// The box for storing the items
  static late final SharedPreferences sp;

  /// The mapping of type to sample storage model
  static final Map<Type, StorageModel> typeKeyMap = {};

  /// The logger
  final Logger log;

  List<T>? _elementsCache;

  List<T> get _cache {
    _initCache();
    return _elementsCache!;
  }

  void _initCache() {
    if (_elementsCache != null) return;

    final sampleModel = typeKeyMap[T];
    if (sampleModel == null) {
      throw Exception(
          'Type $T is not registered in SharedPreferencesStorageOperator.');
    } else if (sampleModel is! T) {
      throw Exception(
          'Type $T is registered in SharedPreferencesStorageOperator, '
          'but the sample model is not of type $T.');
    }

    final jsonStrings = sp.getStringList(T.toString());
    if (jsonStrings != null) {
      _elementsCache = jsonStrings.map<T>((s) {
        final json = jsonEncode(s);
        final model = sampleModel.fromJson(json);
        if (model is! T) {
          throw Exception('Decoded model is not of type $T. '
              'Actual type: ${model.runtimeType}');
        }
        return model;
      }).toList();
    } else {
      _elementsCache = [];
    }
  }

  void _postPersistCache() {
    if (_elementsCache == null) {
      throw Exception(
          'Cache for type $T is not initialized afeter persisting.');
    }

    final sampleModel = typeKeyMap[T];
    if (sampleModel == null) {
      throw Exception(
          'Type $T is not registered in SharedPreferencesStorageOperator.');
    } else if (sampleModel is! T) {
      throw Exception(
          'Type $T is registered in SharedPreferencesStorageOperator, '
          'but the sample model is not of type $T.');
    }

    final jsonStrings = _elementsCache!.map((s) {
      final json = s.toJson();
      return jsonEncode(json);
    }).toList();

    sp.setStringList(T.toString(), jsonStrings);
  }

  @override
  T? get(String id) {
    log.t('Getting item <$T> with id $id');
    final results = _cache.where(
      (element) => element.id == id,
    );
    final item = results.isNotEmpty ? results.first : null;
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
      result = List<T>.from(_cache);
    } else {
      outer:
      for (final item in _cache) {
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

    final beforeCount = _cache.length;
    _cache.removeWhere(
      (element) => element.id == id,
    );
    final afterCount = _cache.length;
    final removed = beforeCount > afterCount;

    _postPersistCache();

    if (removed) {
      log.t('Item with id $id removed.');
    } else {
      log.w('Item with id $id does not exist.');
    }
    return removed;
  }

  @override
  void removeAll() {
    log.t('Removing all items <$T>');

    _cache.clear();

    _postPersistCache();

    log.t('All items <$T> removed.');
  }

  @override
  T save(T item) {
    log.t('Saving item <$T> with id ${item.id}');

    // Check if the item already exists
    if (_cache.where((e) => e.id == item.id).isNotEmpty) {
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
    _cache.add(item..metaData = metaData);

    _postPersistCache();

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
      if (_cache.where((e) => e.id == item.id).isNotEmpty) {
        throw ElementAlreadyExitsError(
            'The item with id ${item.id} already exists in the cache.');
      }
    }

    // Save the items
    _cache.addAll(validItems.values);

    _postPersistCache();

    log.t('${validItems.length} items <$T> saved.');

    return validItems.values.toList();
  }

  @override
  T update(T item) {
    log.t('Updating item <$T> with id ${item.id}');

    final results = _cache.where((element) => element.id == item.id);
    final savedItem = results.isNotEmpty ? results.first : null;
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
    final index = _cache.indexOf(savedItem..metaData = metaData);
    _cache[index] = item..metaData = metaData;

    _postPersistCache();

    log.t('Item with id ${item.id} updated.');

    return item;
  }

  @override
  List<T> updateAll(List<T> items) {
    log.t('Updating ${items.length} items <$T>');

    // validate the items
    final validItems = <T>[];
    for (final item in items) {
      final results = _cache.where((element) => element.id == item.id);
      final savedItem = results.isNotEmpty ? results.first : null;

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
      if (validItems.where((e) => e.id == item.id).isNotEmpty) {
        log.e('The id ${item.id} is duplicated.');
        throw ElementIdDuplicatedError('The id ${item.id} is duplicated.');
      }

      final updateTime = DateTime.now();
      final metaData = StorageModelMetaData(
        createAt: savedItem.metaData?.createAt ?? updateTime,
        updateAt: updateTime,
      );
      log.d('Updating item with id ${item.id} and metadata $metaData');
      validItems.add(item..metaData = metaData);
    }

    // Save the items
    for (final item in validItems) {
      final results = _cache.where((element) => element.id == item.id);
      final savedItem = results.isNotEmpty ? results.first : null;
      if (savedItem != null) {
        final index = _cache.indexOf(savedItem);
        _cache[index] = item;
      }
    }

    _postPersistCache();

    log.t('${validItems.length} items <$T> updated.');
    return validItems;
  }
}
