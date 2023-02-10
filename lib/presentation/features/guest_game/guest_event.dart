import 'package:flutter/material.dart';

class GuestEvent {}

class GuestLoadEvent extends GuestEvent {
  final String fen;

  GuestLoadEvent({
    required this.fen,
  });
}

class GuestConnectEvent extends GuestEvent {
  final String host;
  final int port;

  GuestConnectEvent({
    required this.host,
    required this.port,
  });
}

class GuestDisconnectEvent extends GuestEvent {}

class GuestRefreshEvent extends GuestEvent {}

class GuestFocusEvent extends GuestEvent {
  final String focusCoordinate;

  GuestFocusEvent({
    required this.focusCoordinate,
  });
}

class GuestRemoveTheFocusEvent extends GuestEvent {}

class GuestMoveEvent extends GuestEvent {
  final BuildContext context;
  final String to;

  GuestMoveEvent({
    required this.context,
    required this.to,
  });
}

class GuestShowErrorEvent extends GuestEvent {
  final String errorMessage;

  GuestShowErrorEvent({
    required this.errorMessage,
  });
}
