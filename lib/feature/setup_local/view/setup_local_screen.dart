import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

/// The screen for setting up the local settings. Game saves are shown here.
/// The user can continue a saved game or start a new one here.
@RoutePage()
class SetupLocalScreen extends StatefulWidget {
  /// Creates the setup local screen.
  const SetupLocalScreen({super.key});

  @override
  State<SetupLocalScreen> createState() => _SetupLocalScreenState();
}

class _SetupLocalScreenState extends State<SetupLocalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Setup Local Screen'),
      ),
    );
  }
}
