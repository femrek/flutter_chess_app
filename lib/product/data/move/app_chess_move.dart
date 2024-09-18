import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';

/// The chess move data.
@immutable
class AppChessMove extends Equatable {
  /// Creates a [AppChessMove] with the given [from] and [to].
  const AppChessMove({
    required this.from,
    required this.to,
    required this.hasPromotion,
  });

  /// Creates default [AppChessMove].
  const AppChessMove.empty()
      : from = const SquareCoordinate(0, 0),
        to = const SquareCoordinate(0, 0),
        hasPromotion = false;

  /// Creates a [AppChessMove] from the given [json].
  factory AppChessMove.fromJson(Map<String, dynamic> json) {
    // validate the json
    if (!json.containsKey('from') ||
        !json.containsKey('to') ||
        !json.containsKey('hasPromotion')) {
      throw Exception('Invalid json');
    }

    // validate from
    final fromJson = json['from'];
    if (fromJson == null) {
      throw Exception('from is null');
    }
    if (fromJson is! String) {
      throw Exception('from is not a string');
    }

    // validate to
    final toJson = json['to'];
    if (toJson == null) {
      throw Exception('to is null');
    }
    if (toJson is! String) {
      throw Exception('to is not a string');
    }

    // validate hasPromotion
    final hasPromotionJson = json['hasPromotion'];
    if (hasPromotionJson == null) {
      throw Exception('hasPromotion is null');
    }
    if (hasPromotionJson is! bool) {
      throw Exception('hasPromotion is not a bool');
    }

    return AppChessMove(
      from: SquareCoordinate.fromName(fromJson),
      to: SquareCoordinate.fromName(toJson),
      hasPromotion: hasPromotionJson,
    );
  }

  /// The starting square coordinate of the move.
  final SquareCoordinate from;

  /// The final square coordinate of the move.
  final SquareCoordinate to;

  /// The promotion piece if the move is a promotion move.
  final bool hasPromotion;

  /// Converts the [AppChessMove] to a json.
  Map<String, dynamic> get toJson {
    return {
      'from': from.nameLowerCase,
      'to': to.nameLowerCase,
      'hasPromotion': hasPromotion,
    };
  }

  @override
  String toString() {
    return 'AppChessMove$toJson';
  }

  @override
  List<Object?> get props => [from, to, hasPromotion];
}
