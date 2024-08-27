import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';

/// The widget that displays the list of local game saves.
class SetupLocalSaveList extends StatelessWidget {
  /// Creates the setup local save list.
  const SetupLocalSaveList({
    required this.saveList,
    required this.padding,
    super.key,
  });

  /// The list of local game saves.
  final List<LocalGameSaveCacheModel> saveList;

  /// The padding around the list.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: saveList.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(saveList[index].id),
          subtitle: Text(saveList[index].metaData?.updateAt.toString() ?? ''),
          onTap: () {},
        );
      },
    );
  }
}
