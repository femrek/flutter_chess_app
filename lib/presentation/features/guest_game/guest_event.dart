import 'package:equatable/equatable.dart';

class GuestEvent extends Equatable {
  @override
  List<Object> get props => []; 
}

class GuestLoadEvent extends GuestEvent {
  final String fen;

  GuestLoadEvent({
    required this.fen,
  });

  @override
  List<Object> get props => [fen];
}

class GuestConnectEvent extends GuestEvent {
  final String host;
  final int port;

  GuestConnectEvent({
    required this.host,
    required this.port,
  });

  @override
  List<Object> get props => [host, port];
}

class GuestDisconnectEvent extends GuestEvent {}

class GuestRefreshEvent extends GuestEvent {}

class GuestFocusEvent extends GuestEvent {
  final String focusCoordinate;

  GuestFocusEvent({
    required this.focusCoordinate,
  });

  @override
  List<Object> get props => [focusCoordinate];
}

class GuestRemoveTheFocusEvent extends GuestEvent {}

class GuestMoveEvent extends GuestEvent {
  final String to;

  GuestMoveEvent({
    required this.to,
  });

  @override
  List<Object> get props => [to];
}
