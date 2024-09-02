import 'package:flutter/material.dart';

/// The header of the local game screen.
class LocalGameHeader extends StatelessWidget implements PreferredSizeWidget {
  /// Creates the local game header.
  const LocalGameHeader({
    required this.gameName,
    super.key,
  });

  /// The name of the game to be displayed.
  final String gameName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BackButton(),
        Expanded(
          child: Text(
            gameName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
