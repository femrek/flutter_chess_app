import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/util/date_extension.dart';
import 'package:localchess/product/widget/dialog/game_preview_dialog.dart';

/// The function definition to trigger when the save list item selected.
typedef OnSaveSelected = void Function(LocalGameSaveCacheModel save);

/// Component for use for each list element.
class AppSaveListTile extends StatelessWidget {
  /// Create [AppSaveListTile} instance.
  const AppSaveListTile({
    required this.data,
    required this.onSaveSelected,
    super.key,
  });

  /// The data to present in this tile.
  final LocalGameSaveCacheModel data;

  /// Called when the user tap the save. Gives the save data as parameter.
  final OnSaveSelected onSaveSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const AppPadding.listTile(
        horizontal: 12,
        vertical: 4,
      ),
      title: Text(data.localGameSave.name),
      subtitle: Text(
        LocaleKeys.widget_saveListTile_lastPlayed.tr() +
            (data.metaData?.updateAt.toVisualFormat ?? ''),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.preview),
        onPressed: () {
          GamePreviewDialog.show(
            context: context,
            save: data,
            onPlayPressed: () => onSaveSelected(data),
          );
        },
      ),
      onTap: () {
        onSaveSelected(data);
      },
    );
  }
}
