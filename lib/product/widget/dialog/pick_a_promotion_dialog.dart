import 'package:flutter/material.dart';
import 'package:localchess/product/constant/radius/app_radius_constant.dart';
import 'package:localchess/product/data/app_piece.dart';

/// Dialog for picking a promotion piece. The dialog returns the selected piece
/// code name when pop. [q, r, b, n]
class PickAPromotionDialog extends StatelessWidget {
  /// Create an instance for [PickAPromotionDialog].
  const PickAPromotionDialog({
    required this.isDark,
    super.key,
  });

  /// Whether the pieces are black or white.
  final bool isDark;

  /// Shows the [PickAPromotionDialog] dialog.
  static Future<String?> show({
    required BuildContext context,
    required bool isDark,
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return PickAPromotionDialog(isDark: isDark);
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Pick a promotion piece'),
      contentPadding:
          const EdgeInsets.all(AppRadiusConstant.dialogCornerRadius),
      children: [
        SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final piece = isDark ? _blackPieces[index] : _whitePieces[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop(piece.name);
                },
                child: piece.asImage,
              );
            },
          ),
        ),
      ],
    );
  }

  static const List<AppPiece> _blackPieces = [
    AppPiece.queenB,
    AppPiece.rookB,
    AppPiece.bishopB,
    AppPiece.knightB,
  ];

  static const List<AppPiece> _whitePieces = [
    AppPiece.queenW,
    AppPiece.rookW,
    AppPiece.bishopW,
    AppPiece.knightW,
  ];
}
