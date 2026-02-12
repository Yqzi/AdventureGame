import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

abstract class GeminiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendPrompt extends GeminiEvent {
  final String prompt;

  SendPrompt(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

@immutable
abstract class GameEvent {}

class StartNewQuestEvent extends GameEvent {
  final Map<String, dynamic> questDetails;
  StartNewQuestEvent(this.questDetails);
}

class PlayerCommandEvent extends GameEvent {
  final String command;
  PlayerCommandEvent(this.command);
}

class GameDisposeEvent extends GameEvent {}
