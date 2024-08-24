import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';

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
    return Scaffold(
      body: Center(
        child: Text(LocaleKeys.screen_home_title.tr()),
      ),
    );
  }
}
