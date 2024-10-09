import 'package:flutter/material.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/widget/list_tile/app_save_list_tile.dart';

/// The widget that displays the list of local game saves.
class SetupLocalSaveList extends StatelessWidget {
  /// Creates the setup local save list.
  const SetupLocalSaveList({
    required this.saveList,
    required this.padding,
    required this.onPlayPressed,
    required this.onRemovePressed,
    super.key,
  });

  /// The list of local game saves.
  final List<GameSaveStorageModel> saveList;

  /// The padding around the list.
  final EdgeInsets padding;

  /// The callback when clicked on play button of a save.
  final OnPressedPlaySave onPlayPressed;

  /// The callback when clicked on remove button of a save.
  final OnPressedWithGameSave onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: const BouncingScrollPhysics(),
      itemCount: saveList.length,
      itemBuilder: (_, index) {
        return AppSaveListTile(
          data: saveList[index],
          onPlayPressed: onPlayPressed,
          onRemovePressed: onRemovePressed,
        );
      },
    );
  }
}
