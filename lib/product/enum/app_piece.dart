// ignore_for_file: public_member_api_docs

import 'package:gen/gen.dart';

/// Types of the pieces in the chess game.
enum AppPiece {
  pawn,
  rook,
  knight,
  bishop,
  queen,
  king,
  ;

  /// Creates a piece from the name form chess library.
  static AppPiece fromName(String name) {
    switch (name) {
      case 'p':
        return pawn;
      case 'n':
        return knight;
      case 'b':
        return bishop;
      case 'r':
        return rook;
      case 'q':
        return queen;
      case 'k':
        return king;
      default:
        throw Exception('undefined piece name. '
            'Piece name must be one of [ p, n, b, r, q, k ]');
    }
  }

  /// The image of the piece.
  SvgGenImage get image {
    switch (this) {
      case AppPiece.pawn:
        return Assets.icon.iconPawn;
      case AppPiece.rook:
        return Assets.icon.iconRok;
      case AppPiece.knight:
        return Assets.icon.iconKnight;
      case AppPiece.bishop:
        return Assets.icon.iconBishop;
      case AppPiece.queen:
        return Assets.icon.iconQueen;
      case AppPiece.king:
        return Assets.icon.iconKing;
    }
  }

  /// The scale of the piece.
  double get scale {
    switch (this) {
      case AppPiece.pawn:
        return 0.55;
      case AppPiece.rook:
        return 0.68;
      case AppPiece.knight:
        return 0.68;
      case AppPiece.bishop:
        return 0.7;
      case AppPiece.queen:
        return 0.8;
      case AppPiece.king:
        return 0.8;
    }
  }
}
