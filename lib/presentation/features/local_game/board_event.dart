import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

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
  final String focusCoordinate;

  BoardFocusEvent({this.focusCoordinate});

  @override
  List<Object> get props => [focusCoordinate];
}

class BoardMoveEvent extends BoardEvent {
  final String to;
  final BuildContext context;

  BoardMoveEvent({
    this.context,
    this.to,
  });

  @override
  List<Object> get props => [to];
}

class BoardUndoEvent extends BoardEvent {}

class BoardRedoEvent extends BoardEvent {}
