import 'package:equatable/equatable.dart';

class LocalHostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalHostLoadEvent extends LocalHostEvent {
  final bool restart;

  LocalHostLoadEvent({this.restart = false});

  @override
  List<Object> get props => [restart];
}

class LocalHostFocusEvent extends LocalHostEvent {
  final String focusCoor;

  LocalHostFocusEvent({this.focusCoor});

  @override
  List<Object> get props => [focusCoor];
}

class LocalHostMoveEvent extends LocalHostEvent {
  final String to;

  LocalHostMoveEvent({
    this.to,
  });

  @override
  List<Object> get props => [to];
}

class LocalHostUndoEvent extends LocalHostEvent {}

class LocalHostRedoEvent extends LocalHostEvent {}