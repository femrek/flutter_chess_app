import 'package:auto_route/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localchess/feature/setup_local/view/mixin/setup_local_state_mixin.dart';
import 'package:localchess/feature/setup_local/view/widget/setup_local_save_list.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_state.dart';
import 'package:localchess/feature/setup_local/view_model/setup_local_view_model.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/state/base/base_state.dart';
import 'package:localchess/product/widget/button/app_button/app_button.dart';
import 'package:localchess/product/widget/list_tile/app_save_list_tile.dart';

/// The screen for setting up the local settings. Game saves are shown here.
/// The user can continue a saved game or start a new one here.
@RoutePage()
class SetupLocalScreen extends StatefulWidget {
  /// Creates the setup local screen.
  const SetupLocalScreen({super.key});

  @override
  State<SetupLocalScreen> createState() => _SetupLocalScreenState();
}

class _SetupLocalScreenState extends BaseState<SetupLocalScreen>
    with SetupLocalStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppPadding.screen(vertical: 0).toWidget(
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.screen_setupLocal_savedGamesListTitle,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                height: 1,
                              ),
                    ).tr(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AppButton(
                          onPressed: onPressedNewGame,
                          child: const Text(
                            LocaleKeys.screen_setupLocal_newGameButton,
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _SaveList(onPressedSave: onPressedSave),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveList extends StatelessWidget {
  const _SaveList({
    required this.onPressedSave,
  });

  final OnSaveSelected onPressedSave;

  @override
  Widget build(BuildContext context) {
    final padding = const AppPadding.scrollable(horizontal: 0) +
        MediaQuery.of(context).padding;

    return BlocSelector<SetupLocalViewModel, SetupLocalState,
        List<LocalGameSaveCacheModel>>(
      selector: (state) => state.saves,
      builder: (context, saveList) {
        return SetupLocalSaveList(
          padding: padding,
          saveList: saveList,
          onSaveSelected: onPressedSave,
        );
      },
    );
  }
}
