import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Setup Host Screen widget
@RoutePage()
class SetupHostScreen extends StatefulWidget {
  /// Setup Host Screen widget constructor
  const SetupHostScreen({super.key});

  @override
  State<SetupHostScreen> createState() => _SetupHostScreenState();
}

class _SetupHostScreenState extends State<SetupHostScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Setup Host Screen'),
      ),
    );
  }
}
