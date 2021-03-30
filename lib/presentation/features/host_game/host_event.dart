import 'package:equatable/equatable.dart';

class HostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class HostLoadEvent extends HostEvent {
  final bool restart;

  HostLoadEvent({
    this.restart = false,
  });

  @override
  List<Object> get props => [restart];
}

class HostStartEvent extends HostEvent {
  final String ipAddress;

  HostStartEvent({this.ipAddress});

  @override
  List<Object> get props => [ipAddress];
}

class HostStopEvent extends HostEvent {}

class HostFocusEvent extends HostEvent {
  final String focusCoor;

  HostFocusEvent({this.focusCoor});

  @override
  List<Object> get props => [focusCoor];
}

class HostMoveEvent extends HostEvent {
  final String from;
  final String to;

  HostMoveEvent({
    this.from = '',
    this.to,
  });

  @override
  List<Object> get props => [to];
}

class HostUndoEvent extends HostEvent {}

class HostRedoEvent extends HostEvent {}
