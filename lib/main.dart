import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// The main application widget.
class MyApp extends StatelessWidget {
  /// The main application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
