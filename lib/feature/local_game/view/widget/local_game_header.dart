import 'package:flutter/material.dart';

class LocalGameHeader extends StatelessWidget implements PreferredSizeWidget {
  const LocalGameHeader({
    required this.gameName,
    super.key,
  });

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
