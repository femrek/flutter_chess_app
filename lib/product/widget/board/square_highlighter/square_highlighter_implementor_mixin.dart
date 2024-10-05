import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';
import 'package:localchess/product/dependency_injection/get.dart';

/// A bundle of components that are used to implement the square highlighter
/// feature to a screen.
mixin SquareHighlighterImplementorMixin {
  /// The overlay entry to mark the dragging target square.
  OverlayEntry? draggingSquareOverlayEntry;

  /// The last square coordinate that the dragging square overlay was added to
  /// to prevent unnecessary rebuilds.
  SquareCoordinate? _lastSquareCoordinate;

  /// Removes the dragging square overlay from the screen.
  void removeDraggingSquareOverlay() {
    G.logger.t('SquareHighlighterImplementorMixin.removeDraggingSquareOverlay');

    draggingSquareOverlayEntry?.remove();
    draggingSquareOverlayEntry?.dispose();
    draggingSquareOverlayEntry = null;

    G.logger.t('SquareHighlighterImplementorMixin.removeDraggingSquareOverlay:'
        ' Removed overlay');
  }

  /// Callback function to handle the drag enter event.
  ///
  /// Positions the overlay by the global offset of the [squareKey] then
  /// transforms by the [offset].
  void onSquareDragEnter(
    BuildContext context,
    SquareCoordinate coordinate,
    WidgetBuilder builder,
    GlobalKey squareKey,
    Offset offset,
  ) {
    G.logger
        .t('SquareHighlighterImplementorMixin.onSquareDragEnter: $coordinate');

    // prevent unnecessary rebuilds
    if (_lastSquareCoordinate == coordinate) {
      G.logger.t('SquareHighlighterImplementorMixin.onSquareDragEnter:'
          ' Same coordinate');
      return;
    }
    _lastSquareCoordinate = coordinate;

    // calculate the offset of the overlay
    final squareRenderBox =
        squareKey.currentContext?.findRenderObject() as RenderBox?;
    if (squareRenderBox == null) {
      G.logger.w('Square render box is null');
      return;
    }
    final squarePosition = squareRenderBox.localToGlobal(Offset.zero);
    final overlayOffset = Offset(
      squarePosition.dx,
      squarePosition.dy,
    );

    // remove the previous overlay if exists
    removeDraggingSquareOverlay();

    // create a new overlay
    final overlayEntry = draggingSquareOverlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: overlayOffset.dx + offset.dx,
          top: overlayOffset.dy + offset.dy,
          child: builder(context),
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);

    G.logger.t(
        'SquareHighlighterImplementorMixin.onSquareDragEnter: Added overlay');
  }

  /// Callback function to handle the drag leave event.
  void onSquareDragLeave(
    BuildContext context,
    SquareCoordinate coordinate,
    GlobalKey squareKey,
  ) {
    G.logger
        .t('SquareHighlighterImplementorMixin.onSquareDragLeave: $coordinate');

    _lastSquareCoordinate = null;
    removeDraggingSquareOverlay();

    G.logger.t(
        'SquareHighlighterImplementorMixin.onSquareDragLeave: Removed overlay');
  }
}
