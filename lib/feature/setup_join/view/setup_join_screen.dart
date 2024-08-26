import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Join Screen widget
@RoutePage()
class SetupJoinScreen extends StatefulWidget {
  /// Join Screen widget constructor
  const SetupJoinScreen({super.key});

  @override
  State<SetupJoinScreen> createState() => _SetupJoinScreenState();
}

class _SetupJoinScreenState extends State<SetupJoinScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Setup Join Screen'),
      ),
    );
  }
}
