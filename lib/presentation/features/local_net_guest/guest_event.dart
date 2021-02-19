import 'package:equatable/equatable.dart';

class GuestEvent extends Equatable {
  @override
  List<Object> get props => []; 
}

class GuestLoadEvent extends GuestEvent {}

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
