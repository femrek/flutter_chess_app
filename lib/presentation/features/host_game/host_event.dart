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

class HostStartEvent extends HostEvent {}

class HostStopEvent extends HostEvent {}

class HostFocusEvent extends HostEvent {
  final String focusCoordinate;

  HostFocusEvent({required this.focusCoordinate});

  @override
  List<Object> get props => [focusCoordinate];
}

class HostRemoveTheFocusEvent extends HostEvent {}

class HostMoveEvent extends HostEvent {
  final String from;
  final String to;

  HostMoveEvent({
    this.from = '',
    required this.to,
  });

  @override
  List<Object> get props => [to];
}

class HostUndoEvent extends HostEvent {}

class HostRedoEvent extends HostEvent {}
