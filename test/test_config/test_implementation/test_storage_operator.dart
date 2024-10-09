import 'package:core/core.dart';

/// A test implementation of [StorageOperator]. Keeps the items in a dart list.
final class TestStorageOperator<T extends StorageModel>
    implements StorageOperator<T> {
  final List<T> _items = [];

  @override
  T? get(String id) {
    return _items.where((element) => element.id == id).firstOrNull;
  }

  @override
  List<T> getAll({GetAllSortEnum? sort}) {
    return _items;
  }

  @override
  bool remove(String id) {
    final item = get(id);
    if (item == null) return false;
    _items.remove(item);
    return true;
  }

  @override
  void removeAll() {
    _items.clear();
  }

  @override
  T save(T item) {
    _items.add(item);
    return item
      ..metaData = StorageModelMetaData(
        createAt: DateTime.now(),
        updateAt: DateTime.now(),
      );
  }

  @override
  List<T> saveAll(List<T> items) {
    _items.addAll(
      items
        ..forEach((e) => e
          ..metaData = StorageModelMetaData(
            createAt: DateTime.now(),
            updateAt: DateTime.now(),
          )),
    );
    return items;
  }

  @override
  T update(T item) {
    final oldItem = get(item.id);
    if (oldItem == null) {
      throw ElementDoesNotExistWhenUpdateError('id: ${item.id}');
    }
    _items
      ..remove(oldItem)
      ..add(item);
    return item
      ..metaData = StorageModelMetaData(
        createAt: oldItem.metaData?.createAt ?? DateTime.now(),
        updateAt: DateTime.now(),
      );
  }

  @override
  List<T> updateAll(List<T> items) {
    final oldItems = <T>[];

    for (final item in items) {
      final oldItem = get(item.id);
      if (oldItem == null) {
        throw ElementDoesNotExistWhenUpdateError('id: ${item.id}');
      }
      oldItems.add(item);
    }

    final updatedItems = <T>[];
    for (var i = 0; i < oldItems.length; i++) {
      final oldItem = oldItems[i];
      final item = items[i];
      _items
        ..remove(oldItem)
        ..add(item);
      updatedItems.add(item
        ..metaData = StorageModelMetaData(
          createAt: oldItem.metaData?.createAt ?? DateTime.now(),
          updateAt: DateTime.now(),
        ));
    }

    return oldItems;
  }
}
