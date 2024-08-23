import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Host Screen widget
@RoutePage()
class HostGameScreen extends StatefulWidget {
  /// Host Screen widget constructor
  const HostGameScreen({super.key});

  @override
  State<HostGameScreen> createState() => _HostGameScreenState();
}

class _HostGameScreenState extends State<HostGameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
