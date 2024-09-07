import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';

/// Host Screen widget
@RoutePage()
class HostGameScreen extends StatefulWidget {
  /// Host Screen widget constructor
  const HostGameScreen({
    required this.save,
    super.key,
  });

  /// The save data to play.
  final GameSaveCacheModel save;

  @override
  State<HostGameScreen> createState() => _HostGameScreenState();
}

class _HostGameScreenState extends State<HostGameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
