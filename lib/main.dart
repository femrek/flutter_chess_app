import 'package:flutter/material.dart';
import 'package:localchess/product/navigation/app_route.dart';

void main() => runApp(const MyApp());

/// The main application widget.
class MyApp extends StatelessWidget {
  /// The main application widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRoute().config(),
    );
  }
}
