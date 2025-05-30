import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/storage/model/game_save_storage_model.dart';
import 'package:localchess/product/util/date_extension.dart';
import 'package:localchess/product/widget/dialog/game_preview_dialog.dart';

/// The function definition to trigger when the save list item selected.
typedef OnPressedWithGameSave = void Function(GameSaveStorageModel save);

/// The function definition to trigger when the play button pressed.
typedef OnPressedPlaySave = void Function(
  GameSaveStorageModel save,
  PlayerColor color,
);

/// Component for use for each list element.
class AppSaveListTile extends StatelessWidget {
  /// Create [AppSaveListTile} instance.
  const AppSaveListTile({
    required this.data,
    required this.onPlayPressed,
    required this.onRemovePressed,
    this.defaultColorOfThePlayer = PlayerColor.white,
    this.showColorChooser = false,
    super.key,
  });

  /// The data to present in this tile.
  final GameSaveStorageModel data;

  /// Called when the user tap the save. Gives the save data as parameter.
  final OnPressedPlaySave onPlayPressed;

  /// Called when the user tap the remove button. Gives the save data as
  /// parameter.
  final OnPressedWithGameSave onRemovePressed;

  /// The default side of the player. Default is white.
  final PlayerColor defaultColorOfThePlayer;

  /// When true the color chooser will be shown. If false the default color
  final bool showColorChooser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const AppPadding.listTile(
        horizontal: 12,
        vertical: 4,
      ),
      tileColor: data.gameSave.isGameOver
          ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 25)
          : null,
      title: Text(
        data.gameSave.name,
        style: TextStyle(
          decoration:
              data.gameSave.isGameOver ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        data.metaData?.updateAt == data.metaData?.createAt
            ? LocaleKeys.widget_saveListTile_lastPlayed_created.tr(namedArgs: {
                'dateTime': data.metaData?.createAt.toVisualFormat ?? '',
              })
            : LocaleKeys.widget_saveListTile_lastPlayed_lastPlayed
                .tr(namedArgs: {
                'dateTime': data.metaData?.updateAt.toVisualFormat ?? '',
              }),
      ),
      trailing: IconButton(
        icon: Icon(
          _getIcon(context),
        ),
        onPressed: () {
          if (data.gameSave.isGameOver) {
            onRemovePressed(data);
          } else {
            onPlayPressed(data, PlayerColor.white);
          }
        },
      ),
      onTap: () {
        GamePreviewDialog.show(
          context: context,
          save: data,
          onPlayPressed: (color) {
            onPlayPressed(data, color);
          },
          onRemovePressed: () {
            onRemovePressed(data);
          },
          showColorChooser: showColorChooser,
          defaultColor: defaultColorOfThePlayer,
        );
      },
    );
  }

  IconData _getIcon(BuildContext context) {
    if (data.gameSave.isGameOver) {
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
