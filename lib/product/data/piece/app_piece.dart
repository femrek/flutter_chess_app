// ignore_for_file: public_member_api_docs

import 'package:gen/gen.dart';

/// Types of the pieces in the chess game.
enum AppPiece {
  pawnB(isDark: true, name: 'p'),
  rookB(isDark: true, name: 'r'),
  knightB(isDark: true, name: 'n'),
  bishopB(isDark: true, name: 'b'),
  queenB(isDark: true, name: 'q'),
  kingB(isDark: true, name: 'k'),
  pawnW(isDark: false, name: 'p'),
  rookW(isDark: false, name: 'r'),
  knightW(isDark: false, name: 'n'),
  bishopW(isDark: false, name: 'b'),
  queenW(isDark: false, name: 'q'),
  kingW(isDark: false, name: 'k');

  const AppPiece({
    required this.isDark,
    required this.name,
  });

  /// Creates a piece from the name form chess library.
  factory AppPiece.fromName({
    required String name,
    required bool isDark,
  }) {
    switch (name) {
      case 'p':
        return isDark ? pawnB : pawnW;
      case 'n':
        return isDark ? knightB : knightW;
      case 'b':
        return isDark ? bishopB : bishopW;
      case 'r':
        return isDark ? rookB : rookW;
      case 'q':
        return isDark ? queenB : queenW;
      case 'k':
        return isDark ? kingB : kingW;
      default:
        throw Exception('undefined piece name. '
            'Piece name must be one of [ p, n, b, r, q, k ]');
    }
  }

  /// Whether the piece is dark.
  final bool isDark;

  /// The code of the piece. (e.g. 'p', 'n', 'b', 'r', 'q', 'k')
  final String name;

  /// The image of the piece.
  SvgGenImage get image {
    switch (this) {
      case AppPiece.pawnB:
      case AppPiece.pawnW:
        return Assets.icon.iconPawn;
      case AppPiece.rookB:
      case AppPiece.rookW:
        return Assets.icon.iconRok;
      case AppPiece.knightB:
      case AppPiece.knightW:
        return Assets.icon.iconKnight;
      case AppPiece.bishopB:
      case AppPiece.bishopW:
        return Assets.icon.iconBishop;
      case AppPiece.queenB:
      case AppPiece.queenW:
        return Assets.icon.iconQueen;
      case AppPiece.kingB:
      case AppPiece.kingW:
        return Assets.icon.iconKing;
    }
  }

  /// The scale of the piece.
  double get scale {
    switch (this) {
      case AppPiece.pawnB:
      case AppPiece.pawnW:
        return 0.55;
      case AppPiece.rookB:
      case AppPiece.rookW:
      case AppPiece.knightB:
      case AppPiece.knightW:
        return 0.68;
      case AppPiece.bishopB:
      case AppPiece.bishopW:
        return 0.7;
      case AppPiece.queenB:
      case AppPiece.queenW:
      case AppPiece.kingB:
      case AppPiece.kingW:
        return 0.8;
    }
  }
}
