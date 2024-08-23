import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Local Game Screen widget
@RoutePage()
class LocalGameScreen extends StatefulWidget {
  /// Local Game Screen widget constructor
  const LocalGameScreen({super.key});

  @override
  State<LocalGameScreen> createState() => _LocalGameScreenState();
}

class _LocalGameScreenState extends State<LocalGameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
