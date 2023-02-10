import 'package:flutter/cupertino.dart';

class HostEvent {}

class HostLoadEvent extends HostEvent {
  final bool restart;

  HostLoadEvent({
    this.restart = false,
  });
}

class HostStartEvent extends HostEvent {}

class HostStopEvent extends HostEvent {}

class HostFocusEvent extends HostEvent {
  final String focusCoordinate;

  HostFocusEvent({required this.focusCoordinate});
}

class HostRemoveTheFocusEvent extends HostEvent {}

class HostMoveEvent extends HostEvent {
  final BuildContext? context;
  final String from;
  final String to;
  final String? promotion;

  HostMoveEvent({
    this.context,
    this.from = '',
    required this.to,
    this.promotion,
  });
}

class HostUndoEvent extends HostEvent {}

class HostRedoEvent extends HostEvent {}

class HostKickGuestEvent extends HostEvent {}
