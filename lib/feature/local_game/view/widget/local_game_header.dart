import 'package:flutter/material.dart';

/// The header of the local game screen.
class LocalGameHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the local game header.
  const LocalGameHeader({
    required this.gameName,
    required this.frontColor,
    super.key,
  });

  /// The name of the game to be displayed.
  final String gameName;

  /// The color of the front elements.
  final Color frontColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(
          color: frontColor,
        ),
        Expanded(
          child: Text(
            gameName,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: frontColor,
                ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
