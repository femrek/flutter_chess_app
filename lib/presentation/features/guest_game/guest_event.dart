import 'package:equatable/equatable.dart';

class GuestEvent extends Equatable {
  @override
  List<Object> get props => []; 
}

class GuestLoadEvent extends GuestEvent {
  final String fen;

  GuestLoadEvent({
    this.fen,
  });

  @override
  List<Object> get props => [fen];
}

class GuestConnectEvent extends GuestEvent {
  final String host;
  final int port;

  GuestConnectEvent({
    this.host,
    this.port,
  });

  @override
  List<Object> get props => [host, port];
}

class GuestDisconnectEvent extends GuestEvent {}

class GuestRefreshEvent extends GuestEvent {}

class GuestFocusEvent extends GuestEvent {
  final String focusCoordinate;

  GuestFocusEvent({
    this.focusCoordinate,
  });

  @override
  List<Object> get props => [focusCoordinate];
}

class GuestMoveEvent extends GuestEvent {
  final String to;

  GuestMoveEvent({
    this.to,
  });

  @override
  List<Object> get props => [to];
}
