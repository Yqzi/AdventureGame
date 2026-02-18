import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tes/models/chat_message.dart';
import 'package:tes/models/player.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class GeminiState extends Equatable {
  final List<ChatMessage> messages;
  final bool isTyping;

  const GeminiState({required this.messages, required this.isTyping});

  factory GeminiState.initial() {
    return const GeminiState(messages: [], isTyping: false);
  }

  GeminiState copyWith({List<ChatMessage>? messages, bool? isTyping}) {
    return GeminiState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping];
}

@immutable
abstract class GameState {
  /// Every state carries the current player so the UI can always read it.
  Player get player;
}

class GameInitial extends GameState {
  @override
  final Player player;
  GameInitial({required this.player});
}

class GameLoading extends GameState {
  final String message;
  @override
  final Player player;
  GameLoading({this.message = 'Loading...', required this.player});
}

class GameLoaded extends GameState {
  final List<ChatMessage> messages;
  final Map<String, dynamic> activeQuest;
  final Player player;
  final List<String> options;
  GameLoaded({
    required this.messages,
    required this.activeQuest,
    required this.player,
    this.options = const [],
  });
}

class GameStreamingNarrative extends GameState {
  final List<ChatMessage> messages;
  final Map<String, dynamic> activeQuest;
  final Player player;
  GameStreamingNarrative({
    required this.messages,
    required this.activeQuest,
    required this.player,
  });
}

class GameError extends GameState {
  final String message;
  @override
  final Player player;
  GameError(this.message, {required this.player});
}
