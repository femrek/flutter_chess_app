import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localchess/product/cache/model/local_game_save_cache_model.dart';
import 'package:localchess/product/constant/padding/app_padding.dart';
import 'package:localchess/product/constant/padding/padding_widget_extension.dart';
import 'package:localchess/product/data/coordinate/board_orientation_enum.dart';
import 'package:localchess/product/data/piece/app_piece_widget_extension.dart';
import 'package:localchess/product/localization/locale_keys.g.dart';
import 'package:localchess/product/service/core/i_chess_service.dart';
import 'package:localchess/product/service/impl/chess_service.dart';
import 'package:localchess/product/util/date_extension.dart';
import 'package:localchess/product/widget/board/game_board_with_frame.dart';

/// The dialog to show the preview of the game. Presents the board and other
/// details of the game.
class GamePreviewDialog extends StatefulWidget {
  /// Create [GamePreviewDialog] instance.
  const GamePreviewDialog({
    required this.save,
    required this.onPlayPressed,
    super.key,
  });

  /// The local game save to preview.
  final LocalGameSaveCacheModel save;

  /// The callback when the play button is pressed.
  final VoidCallback onPlayPressed;

  static Future<void> show({
    required BuildContext context,
    required LocalGameSaveCacheModel save,
    required VoidCallback onPlayPressed,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return GamePreviewDialog(
          save: save,
          onPlayPressed: onPlayPressed,
        );
      },
    );
  }

  @override
  State<GamePreviewDialog> createState() => _GamePreviewDialogState();
}

class _GamePreviewDialogState extends State<GamePreviewDialog> {
  late final IChessService _chessService;

  @override
  void initState() {
    super.initState();
    _chessService = ChessService(save: widget.save);
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
            SizedBox(
              height: size,
              width: size,
              child: GameBoardWithFrame.portrait(
                size: size,
                squareBuilder: (context, coordinate) {
                  return _chessService.getPieceAt(coordinate)?.asImage(
                            orientation: BoardOrientationEnum.portrait,
                          ) ??
                      const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 8),
            const AppPadding.card(vertical: 0).toWidget(
              child: Text(
                widget.save.localGameSave.name,
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
            const SizedBox(height: 8),
            const AppPadding.card(vertical: 0).toWidget(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onPlayPressed,
                  child: const Text(
                    LocaleKeys.dialog_gamePreviewDialog_play,
                  ).tr(),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      }),
    );
  }
}
