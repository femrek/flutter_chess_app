import 'package:flutter/material.dart';
import 'package:localchess/product/data/coordinate/square_coordinate.dart';

/// The function type for handling drag enter event. Used to show the dragging
/// piece on the target square. Typically passes to onMove callback of the
/// [DragTarget].
typedef OnDragEnter = void Function(
  BuildContext,
  SquareCoordinate,
  WidgetBuilder,
  GlobalKey,
  Offset,
);

/// The function type for handling drag leave event. Used to remove the dragging
/// piece from the target square. Typically passes to onWillAccept callback of
/// the [DragTarget].
typedef OnDragLeave = void Function(BuildContext, SquareCoordinate, GlobalKey);
