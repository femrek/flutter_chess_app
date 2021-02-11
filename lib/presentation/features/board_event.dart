import 'package:equatable/equatable.dart';

class BoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BoardLoadEvent extends BoardEvent {
  final bool restart;

  BoardLoadEvent({this.restart = false});

  @override
  List<Object> get props => [restart];
}

class BoardFocusEvent extends BoardEvent {
  final String focusCoor;

  BoardFocusEvent({this.focusCoor});

  @override
  List<Object> get props => [focusCoor];
}

class BoardMoveEvent extends BoardEvent {
  final String to;

  BoardMoveEvent({
    this.to,
  });

  @override
  List<Object> get props => [to];
}

class BoardUndoEvent extends BoardEvent {}