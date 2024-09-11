import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/setup_host/view/mixin/setup_host_state_mixin.dart';
import 'package:localchess/feature/setup_host/view/widget/setup_host_header.dart';
import 'package:localchess/feature/setup_host/view/widget/setup_host_save_list.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_state.dart';
import 'package:localchess/feature/setup_host/view_model/setup_host_view_model.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/list_tile/app_save_list_tile.dart';

/// Setup Host Screen widget
@RoutePage()
class SetupHostScreen extends StatefulWidget {
  /// Setup Host Screen widget constructor
  const SetupHostScreen({super.key});

  @override
  State<SetupHostScreen> createState() => _SetupHostScreenState();
}

class _SetupHostScreenState extends BaseState<SetupHostScreen>
    with SetupHostStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SetupHostHeader(onPressedNewGame: onPressedNewGame),
              const SizedBox(height: 8),
              Expanded(
                child: _SaveList(
                  onPlayPressed: onPlayPressed,
                  onRemovePressed: onRemovePressed,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveList extends StatelessWidget {
  const _SaveList({
    required this.onPlayPressed,
    required this.onRemovePressed,
  });

  final OnPressedPlaySave onPlayPressed;
  final OnPressedWithGameSave onRemovePressed;

  @override
  Widget build(BuildContext context) {
    final padding = const AppPadding.scrollable(horizontal: 0) +
        MediaQuery.of(context).padding;

    return BlocSelector<SetupHostViewModel, SetupHostState,
        List<GameSaveCacheModel>>(
      selector: (state) {
        return state.saves;
      },
      builder: (context, list) {
        return SetupHostSaveList(
          saveList: list,
          bottomPadding: padding.bottom,
          onPlayPressed: onPlayPressed,
          onRemovePressed: onRemovePressed,
        );
      },
    );
  }
}
