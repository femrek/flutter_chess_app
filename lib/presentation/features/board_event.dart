import 'package:equatable/equatable.dart';

class BoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BoardLoadEvent extends BoardEvent {}

class BoardFocusEvent extends BoardEvent {
  final String focusCoor;

  BoardFocusEvent({this.focusCoor});
}

class BoardMoveEvent extends BoardEvent {
  final String to;

  BoardMoveEvent({
    this.to,
  });
}

class BoardUndoEvent extends BoardEvent {}
