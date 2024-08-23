import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Guest Game Screen widget
@RoutePage()
class GuestGameScreen extends StatefulWidget {
  /// Guest Game Screen widget constructor
  const GuestGameScreen({super.key});

  @override
  State<GuestGameScreen> createState() => _GuestGameScreenState();
}

class _GuestGameScreenState extends State<GuestGameScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
