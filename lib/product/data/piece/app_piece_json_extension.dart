import 'package:localchess/product/data/piece/app_piece.dart';

/// Converts the [AppPiece] to a [String].
extension AppPieceJsonExtensionToJson on List<AppPiece> {
  /// Converts the list of [AppPiece] to a list of [String].
  List<String> toJson() {
    return map((e) => e.nameCaseSensitive).toList();
  }
}

/// Converts the [String] to a [AppPiece].
extension AppPieceJsonExtensionFromJson on List<String> {
  /// Converts the list of [String] to a list of [AppPiece?].
  List<AppPiece> toAppPieceList() {
    return map(AppPiece.fromNameCaseSensitive).toList();
  }
}
