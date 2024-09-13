import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/guest_game/view/mixin/guest_game_state_mixin.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_state.dart';
import 'package:localchess/feature/guest_game/view_model/guest_game_view_model.dart';
import 'package:localchess/product/dependency_injection/get.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';

/// Guest Game Screen widget
@RoutePage()
class GuestGameScreen extends StatefulWidget {
  /// Guest Game Screen widget constructor
  const GuestGameScreen({
    required this.hostAddress,
    super.key,
  });

  /// The host address to connect to the game.
  final AddressOnNetwork hostAddress;

  @override
  State<GuestGameScreen> createState() => _GuestGameScreenState();
}

class _GuestGameScreenState extends BaseState<GuestGameScreen>
    with GuestGameStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: G.guestGameViewModel,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ConnectionManageSection(
              onPressedDisconnect: disconnect,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionManageSection extends StatelessWidget {
  const _ConnectionManageSection({
    required this.onPressedDisconnect,
  });

  final VoidCallback onPressedDisconnect;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuestGameViewModel, GuestGameState>(
      builder: (context, state) {
        if (state is! GuestGameLoadedState) {
          return const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Column(
          children: [
            const Text('Connection Manage Section'),
            Text('Server Information: ${state.serverInformation}'),
            Text('Game Name: ${state.gameName}'),
            AppButton(
              onPressed: onPressedDisconnect,
              child: const Text('disconnect'),
            ),
          ],
        );
      },
    );
  }
}
