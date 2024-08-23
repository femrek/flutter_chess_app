import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Home Screen widget
@RoutePage()
class HomeScreen extends StatefulWidget {
  /// Creates Home Screen widget
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('hello world'),
      ),
    );
  }
}
