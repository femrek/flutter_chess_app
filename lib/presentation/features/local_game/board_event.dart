import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  BoardFocusEvent({required this.focusCoordinate});

  @override
  List<Object> get props => [focusCoordinate];
}

class BoardMoveEvent extends BoardEvent {
  final String to;
  final BuildContext context;

  BoardMoveEvent({
    required this.context,
    required this.to,
  });

  @override
  List<Object> get props => [to];
}

class BoardRemoveTheFocusEvent extends BoardEvent {}

class BoardUndoEvent extends BoardEvent {}

class BoardRedoEvent extends BoardEvent {}
