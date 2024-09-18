// ignore_for_file: public_member_api_docs

import 'package:gen/gen.dart';
import 'package:localchess/product/data/player_color/player_color.dart';

/// Types of the pieces in the chess game.
enum AppPiece {
  pawnB(color: PlayerColor.black, name: 'p'),
  rookB(color: PlayerColor.black, name: 'r'),
  knightB(color: PlayerColor.black, name: 'n'),
  bishopB(color: PlayerColor.black, name: 'b'),
  queenB(color: PlayerColor.black, name: 'q'),
  kingB(color: PlayerColor.black, name: 'k'),
  pawnW(color: PlayerColor.white, name: 'p'),
  rookW(color: PlayerColor.white, name: 'r'),
  knightW(color: PlayerColor.white, name: 'n'),
  bishopW(color: PlayerColor.white, name: 'b'),
  queenW(color: PlayerColor.white, name: 'q'),
  kingW(color: PlayerColor.white, name: 'k');

  const AppPiece({
    required this.color,
    required this.name,
  });

  /// Creates a piece from the name case sensitive. Upper case for white pieces
  /// and lower case for black pieces. (e.g. 'P', 'R', 'N', 'B', 'Q', 'K', 'p',
  /// 'r', 'n', 'b', 'q', 'k')
  factory AppPiece.fromNameCaseSensitive(String name) {
    switch (name) {
      case 'P':
        return pawnW;
      case 'R':
        return rookW;
      case 'N':
        return knightW;
      case 'B':
        return bishopW;
      case 'Q':
        return queenW;
      case 'K':
        return kingW;
      case 'p':
        return pawnB;
      case 'r':
        return rookB;
      case 'n':
        return knightB;
      case 'b':
        return bishopB;
      case 'q':
        return queenB;
      case 'k':
        return kingB;
      default:
        throw Exception('undefined piece name. '
            'Piece name must be one of [ P, R, N, B, Q, K, p, r, n, b, q, k ]');
    }
  }

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
  final PlayerColor color;

  /// The code of the piece. (e.g. 'p', 'n', 'b', 'r', 'q', 'k')
  final String name;

  String get nameCaseSensitive {
    switch (this) {
      case AppPiece.pawnB:
        return 'p';
      case AppPiece.rookB:
        return 'r';
      case AppPiece.knightB:
        return 'n';
      case AppPiece.bishopB:
        return 'b';
      case AppPiece.queenB:
        return 'q';
      case AppPiece.kingB:
        return 'k';
      case AppPiece.pawnW:
        return 'P';
      case AppPiece.rookW:
        return 'R';
      case AppPiece.knightW:
        return 'N';
      case AppPiece.bishopW:
        return 'B';
      case AppPiece.queenW:
        return 'Q';
      case AppPiece.kingW:
        return 'K';
    }
  }

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
