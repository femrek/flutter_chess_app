import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/widget/list_tile/app_save_list_tile.dart';

/// The widget that displays the list of local game saves.
class SetupLocalSaveList extends StatelessWidget {
  /// Creates the setup local save list.
  const SetupLocalSaveList({
    required this.saveList,
    required this.padding,
    required this.onSaveSelected,
    super.key,
  });

  /// The list of local game saves.
  final List<LocalGameSaveCacheModel> saveList;

  /// The padding around the list.
  final EdgeInsets padding;

  /// The callback when a save is selected.
  final OnSaveSelected onSaveSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: const BouncingScrollPhysics(),
      itemCount: saveList.length,
      itemBuilder: (_, index) {
        return AppSaveListTile(
          data: saveList[index],
          onSaveSelected: onSaveSelected,
        );
      },
    );
  }
}
