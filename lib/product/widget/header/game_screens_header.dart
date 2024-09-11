import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

/// The header of the local game screen.
class GameScreensHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the local game header.
  const GameScreensHeader({
    required this.gameName,
    required this.frontColor,
    required this.undoButtonBuilder,
    required this.redoButtonBuilder,
    required this.onRestartPressed,
    this.showRestartButton = true,
    super.key,
  });

  /// The name of the game to be displayed.
  final String gameName;

  /// The color of the front elements.
  final Color frontColor;

  /// The builder for the undo button.
  final WidgetBuilder undoButtonBuilder;

  /// The builder for the redo button.
  final WidgetBuilder redoButtonBuilder;

  /// The callback when the restart button is pressed.
  final VoidCallback onRestartPressed;

  /// Whether to show the restart button.
  final bool showRestartButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(
          color: frontColor,
        ),

        // the title. The game name
        Expanded(
          child: Text(
            gameName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: frontColor,
                ),
          ),
        ),

        // The restart button
        IconButton(
          tooltip: LocaleKeys.game_restart.tr(),
          onPressed: onRestartPressed,
          icon: Icon(
            Icons.restart_alt,
            color: frontColor,
          ),
        ),

        // The undo button
        undoButtonBuilder(context),

        // The redo button
        redoButtonBuilder(context),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
