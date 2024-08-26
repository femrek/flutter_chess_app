import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/feature/home/view/mixin/home_state_mixin.dart';
import 'package:localchess/feature/home/view/widget/home_screen_app_bar.dart';
import 'package:localchess/feature/home/view/widget/home_screen_drawer.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

/// Home Screen widget
@RoutePage()
class HomeScreen extends StatefulWidget {
  /// Creates Home Screen widget
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> with HomeStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const HomeScreenDrawer(),
      appBar: const HomeScreenAppBar(),
      body: SafeArea(
        child: const AppPadding.screen().toWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _CardLocal(onPlayPressed: onLocalPlayPressed),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: _CardNetwork(
                  onHostPressed: onHostPressed,
                  onJoinPressed: onJoinPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardLocal extends StatelessWidget {
  const _CardLocal({
    required this.onPlayPressed,
  });

  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const AppPadding.card().toWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              LocaleKeys.screen_home_playTwoPlayer_title,
            ).tr(),
            const Spacer(),
            AppButton(
              onPressed: onPlayPressed,
              fullWidth: true,
              child: const Text(
                LocaleKeys.screen_home_playTwoPlayer_button,
              ).tr(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _CardNetwork extends StatelessWidget {
  const _CardNetwork({
    required this.onHostPressed,
    required this.onJoinPressed,
  });

  final VoidCallback onHostPressed;
  final VoidCallback onJoinPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: const AppPadding.card().toWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // title
            const Text(
              LocaleKeys.screen_home_playOverNetwork_title,
            ).tr(),

            const Spacer(),

            // create game
            Text(
              LocaleKeys.screen_home_playOverNetwork_createGame_description,
              style: Theme.of(context).textTheme.labelMedium,
            ).tr(),
            const SizedBox(height: 8),
            AppButton(
              onPressed: onHostPressed,
              fullWidth: true,
              child: const Text(
                LocaleKeys.screen_home_playOverNetwork_createGame_button,
              ).tr(),
            ),

            const SizedBox(height: 32),

            // join game
            Text(
              LocaleKeys.screen_home_playOverNetwork_joinGame_description,
              style: Theme.of(context).textTheme.labelMedium,
            ).tr(),
            const SizedBox(height: 8),
            AppButton(
              onPressed: onJoinPressed,
              fullWidth: true,
              child: const Text(
                LocaleKeys.screen_home_playOverNetwork_joinGame_button,
              ).tr(),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
