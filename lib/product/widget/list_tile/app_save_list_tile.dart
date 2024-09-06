import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/util/date_extension.dart';
import 'package:localchess/product/widget/dialog/game_preview_dialog.dart';

/// The function definition to trigger when the save list item selected.
typedef OnPressedWithGameSave = void Function(LocalGameSaveCacheModel save);

/// Component for use for each list element.
class AppSaveListTile extends StatelessWidget {
  /// Create [AppSaveListTile} instance.
  const AppSaveListTile({
    required this.data,
    required this.onPlayPressed,
    required this.onRemovePressed,
    super.key,
  });

  /// The data to present in this tile.
  final LocalGameSaveCacheModel data;

  /// Called when the user tap the save. Gives the save data as parameter.
  final OnPressedWithGameSave onPlayPressed;

  /// Called when the user tap the remove button. Gives the save data as
  /// parameter.
  final OnPressedWithGameSave onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const AppPadding.listTile(
        horizontal: 12,
        vertical: 4,
      ),
      tileColor: data.localGameSave.isGameOver
          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
          : null,
      title: Text(
        data.localGameSave.name,
        style: TextStyle(
          decoration:
              data.localGameSave.isGameOver ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        LocaleKeys.widget_saveListTile_lastPlayed.tr() +
            (data.metaData?.updateAt.toVisualFormat ?? ''),
      ),
      trailing: IconButton(
        icon: Icon(
          _getIcon(context),
        ),
        onPressed: () {
          if (data.localGameSave.isGameOver) {
            onRemovePressed(data);
          } else {
            onPlayPressed(data);
          }
        },
      ),
      onTap: () {
        GamePreviewDialog.show(
          context: context,
          save: data,
          onPlayPressed: () {
            onPlayPressed(data);
          },
          onRemovePressed: () {
            onRemovePressed(data);
          },
        );
      },
    );
  }

  IconData _getIcon(BuildContext context) {
    if (data.localGameSave.isGameOver) {
      return Icons.delete;
    } else {
      if (Theme.of(context).brightness == Brightness.light) {
        return Icons.play_circle_outline;
      } else {
        return Icons.play_circle_filled;
      }
    }
  }
}
