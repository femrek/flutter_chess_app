import 'dart:async';
import 'dart:developer';

import 'package:core/core.dart';
import 'package:hive/hive.dart';

/// [CacheOperator] implementation using Hive
class HiveCacheOperator<T extends CacheModel> implements CacheOperator<T> {
  /// Creates a new [HiveCacheOperator] instance.
  HiveCacheOperator() {
    _box = Hive.box<T>(name: T.toString());
  }

  late final Box<T> _box;

  @override
  FutureOr<T?> get(String id) {
    return _box.get(id);
  }

  @override
  FutureOr<List<T>> getAll() {
    return _box.getAll(_box.keys).where((e) => e != null).cast<T>().toList();
  }

  @override
  FutureOr<bool> remove(String id) {
    return _box.delete(id);
  }

  @override
  FutureOr<void> removeAll() {
    _box.deleteAll(_box.keys);
  }

  @override
  FutureOr<void> save(T item) {
    if (_box.containsKey(item.id)) {
      throw ElementAlreadyExitsError(
          'The item with id ${item.id} already exists in the cache.');
    }
    _box.put(
      item.id,
      item
        ..metaData = CacheModelMetaData(
          createAt: DateTime.now(),
          updateAt: DateTime.now(),
        ),
    );
  }

  @override
  FutureOr<void> saveAll(List<T> items) {
    // validate the items
    final validItems = <String, T>{};
    for (final item in items) {
      // Check if the id is duplicated
      if (validItems.containsKey(item.id)) {
        throw ElementIdDuplicatedError('The id ${item.id} is duplicated.');
      }
      validItems[item.id] = item
        ..metaData = CacheModelMetaData(
          createAt: DateTime.now(),
          updateAt: DateTime.now(),
        );

      // Check if the item already exists
      if (_box.containsKey(item.id)) {
        throw ElementAlreadyExitsError(
            'The item with id ${item.id} already exists in the cache.');
      }
    }

    // Save the items
    _box.putAll(validItems);
  }

  @override
  FutureOr<void> update(T item) {
    final savedItem = _box.get(item.id);
    if (savedItem == null) {
      throw ElementDoesNotExistWhenUpdateError(
          'The item with id ${item.id} does not exist in the cache.');
    }
    if (savedItem.metaData == null) {
      log('The item with id ${item.id} does not have metadata.',
          stackTrace: StackTrace.current);
    }

    if (_box.containsKey(item.id)) {
      _box.put(
        item.id,
        item
          ..metaData = CacheModelMetaData(
            createAt: savedItem.metaData?.createAt ?? DateTime.now(),
            updateAt: DateTime.now(),
          ),
      );
    }
  }

  @override
  FutureOr<void> updateAll(List<T> items) {
    // validate the items
    final validItems = <String, T>{};
    for (final item in items) {
      final savedItem = _box.get(item.id);

      // Check if the item already exists
      if (savedItem == null) {
        throw ElementDoesNotExistWhenUpdateError(
            'The item with id ${item.id} does not exist in the cache.');
      }
      if (savedItem.metaData == null) {
        log('The item with id ${item.id} does not have metadata.',
            stackTrace: StackTrace.current);
      }

      // Check if the id is duplicated
      if (validItems.containsKey(item.id)) {
        throw ElementIdDuplicatedError('The id ${item.id} is duplicated.');
      }
      validItems[item.id] = item
        ..metaData = CacheModelMetaData(
          createAt: savedItem.metaData?.createAt ?? DateTime.now(),
          updateAt: DateTime.now(),
        );
    }

    // Save the items
    _box.putAll(validItems);
  }
}
