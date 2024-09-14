import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/data/chess_turn/chess_turn_localization.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/piece/app_piece_widget_extension.dart';
import 'package:localchess/product/data/player_color/player_color.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/service/impl/chess_service.dart';
import 'package:localchess/product/theme/app_color_scheme.dart';
import 'package:localchess/product/util/date_extension.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';

/// The callback when the play button is pressed.
typedef OnPreviewPlayPressed = void Function(PlayerColor chosenColor);

/// The dialog to show the preview of the game. Presents the board and other
/// details of the game.
class GamePreviewDialog extends StatefulWidget {
  /// Create [GamePreviewDialog] instance.
  const GamePreviewDialog({
    required this.save,
    required this.onPlayPressed,
    required this.onRemovePressed,
    required this.defaultColor,
    required this.showColorChooser,
    super.key,
  });

  /// The local game save to preview.
  final GameSaveCacheModel save;

  /// The callback when the play button is pressed.
  final OnPreviewPlayPressed onPlayPressed;

  /// The callback when the remove button is pressed.
  final VoidCallback onRemovePressed;

  /// The default color to choose.
  final PlayerColor defaultColor;

  /// When true the color chooser will be shown. If false the default color
  /// will be used.
  final bool showColorChooser;

  /// Shows a [GamePreviewDialog] with the given [save] and [onPlayPressed].
  static Future<void> show({
    required BuildContext context,
    required GameSaveCacheModel save,
    required OnPreviewPlayPressed onPlayPressed,
    required VoidCallback onRemovePressed,
    PlayerColor defaultColor = PlayerColor.white,
    bool showColorChooser = false,
    bool popAfterPlay = true,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return GamePreviewDialog(
          save: save,
          onPlayPressed: (color) {
            onPlayPressed(color);
            if (popAfterPlay) {
              Navigator.of(context).pop();
            }
          },
          onRemovePressed: onRemovePressed,
          defaultColor: defaultColor,
          showColorChooser: showColorChooser,
        );
      },
    );
  }

  @override
  State<GamePreviewDialog> createState() => _GamePreviewDialogState();
}

class _GamePreviewDialogState extends State<GamePreviewDialog> {
  late final IChessService _chessService;
  late final ValueNotifier<PlayerColor> _chosenColor;

  @override
  void initState() {
    super.initState();
    _chessService = ChessService(save: widget.save, keepSaveUpdated: false);
    _chosenColor = ValueNotifier(widget.defaultColor);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: LayoutBuilder(builder: (context, l) {
        late final double size;
        if (l.maxWidth > 450) {
          size = 450;
        } else {
          size = l.maxWidth;
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The board
            _ChessBoard(
              chessService: _chessService,
              onPlayPressed: () => widget.onPlayPressed(_chosenColor.value),
              size: size,
            ),

            // color chosen
            if (widget.showColorChooser) const SizedBox(height: 8),
            if (widget.showColorChooser)
              const AppPadding.card(vertical: 0).toWidget(
                child: _ColorChooser(chosenColor: _chosenColor),
              ),

            // The game details
            const SizedBox(height: 4),
            const AppPadding.card(vertical: 0).toWidget(
              child: Text(
                widget.save.gameSave.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: 4),
            const AppPadding.card(vertical: 0).toWidget(
              child: Text(
                '${LocaleKeys.dialog_gamePreviewDialog_created.tr()}'
                '${widget.save.metaData?.createAt.toVisualFormat}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const AppPadding.card(vertical: 0).toWidget(
              child: Text(
                '${LocaleKeys.dialog_gamePreviewDialog_lastPlayed.tr()}'
                '${widget.save.metaData?.updateAt.toVisualFormat}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const AppPadding.card(vertical: 0).toWidget(
              child: Text(
                _turnStatusText,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),

            // The play button
            const AppPadding.card(vertical: 0).toWidget(
              child: Row(
                children: [
                  // The delete button
                  ElevatedButton(
                    onPressed: widget.onRemovePressed,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.error,
                      ),
                    ),
                    child: Text(
                      LocaleKeys.dialog_gamePreviewDialog_delete,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ).tr(),
                  ),

                  const Spacer(),

                  // The play button
                  TextButton(
                    onPressed: () => widget.onPlayPressed(_chosenColor.value),
                    child: const Text(
                      LocaleKeys.dialog_gamePreviewDialog_play,
                    ).tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      }),
    );
  }

  String get _turnStatusText {
    final status = _chessService.turnStatus;

    return status.turn?.when(
          black: LocaleKeys.game_chessTurn_black.tr(),
          white: LocaleKeys.game_chessTurn_white.tr(),
        ) ??
        status.localized;
  }
}

class _ColorChooser extends StatelessWidget {
  const _ColorChooser({required this.chosenColor});

  final ValueNotifier<PlayerColor> chosenColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PlayerColor>(
      valueListenable: chosenColor,
      builder: (context, color, child) {
        return Row(
          children: [
            const Spacer(),
            Text(
              color.when(
                black: LocaleKeys.dialog_gamePreviewDialog_playAsBlack,
                white: LocaleKeys.dialog_gamePreviewDialog_playAsWhite,
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ).tr(),
            Switch(
              value: color.when(black: false, white: true),
              onChanged: (isWhite) {
                chosenColor.value =
                    isWhite ? PlayerColor.white : PlayerColor.black;
              },
              activeColor: AppColorScheme.whitePieceColor,
            ),
          ],
        );
      },
    );
  }
}

class _ChessBoard extends StatefulWidget {
  const _ChessBoard({
    required this.chessService,
    required this.onPlayPressed,
    required this.size,
  });

  final IChessService chessService;
  final VoidCallback onPlayPressed;
  final double size;

  @override
  State<_ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<_ChessBoard> {
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) => _isPressed.value = true,
      onTapUp: (_) => _isPressed.value = false,
      onTapCancel: () => _isPressed.value = false,
      onTap: widget.onPlayPressed,
      child: ValueListenableBuilder(
        valueListenable: _isPressed,
        builder: (context, isPressed, child) {
          final scale = isPressed ? 0.9 : 1.0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            curve: Curves.easeInOutCubic,
            transformAlignment: Alignment.center,
            transform: Matrix4.diagonal3Values(scale, scale, 1),
            child: child,
          );
        },
        child: GameBoardWithFrame.portrait(
          size: widget.size,
          squareBuilder: (context, coordinate) {
            return widget.chessService.getPieceAt(coordinate)?.asImage(
                      orientation: BoardOrientationEnum.portrait,
                    ) ??
                const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
