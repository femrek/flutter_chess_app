import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/widget/list_tile/app_save_list_tile.dart';

/// The widget that displays the list of local game saves.
class SetupHostSaveList extends StatelessWidget {
  /// Creates the setup local save list.
  const SetupHostSaveList({
    required this.saveList,
    required this.bottomPadding,
    required this.onPlayPressed,
    required this.onRemovePressed,
    super.key,
  });

  /// The list of local game saves.
  final List<GameSaveCacheModel> saveList;

  /// The bottom padding of the list.
  final double bottomPadding;

  /// The callback when clicked on play button of a save.
  final OnPressedWithGameSave onPlayPressed;

  /// The callback when clicked on remove button of a save.
  final OnPressedWithGameSave onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppPadding.screen(vertical: 0).toWidget(
          child: Text(
            LocaleKeys.screen_setupHost_listTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ).tr(),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: bottomPadding),
            physics: const BouncingScrollPhysics(),
            itemCount: saveList.length,
            itemBuilder: (_, index) {
              return AppSaveListTile(
                data: saveList[index],
                onPlayPressed: onPlayPressed,
                onRemovePressed: onRemovePressed,
              );
            },
          ),
        ),
      ],
    );
  }
}
