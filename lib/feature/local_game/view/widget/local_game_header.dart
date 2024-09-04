import 'package:flutter/material.dart';

/// The header of the local game screen.
class LocalGameHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the local game header.
  const LocalGameHeader({
    required this.gameName,
    required this.frontColor,
    required this.undoButtonBuilder,
    required this.redoButtonBuilder,
    required this.onRestartPressed,
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
