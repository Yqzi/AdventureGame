import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tes/models/chat_message.dart';

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
abstract class GameState {}

class GameInitial extends GameState {}

class GameLoading extends GameState {
  final String message;
  GameLoading({this.message = 'Loading...'});
}

class GameLoaded extends GameState {
  final List<ChatMessage> messages; // Now a list of messages
  final Map<String, dynamic> activeQuest;
  GameLoaded({required this.messages, required this.activeQuest});
}

class GameStreamingNarrative extends GameState {
  final List<ChatMessage>
  messages; // Now a list of messages (with last one being appended)
  final Map<String, dynamic> activeQuest;
  GameStreamingNarrative({required this.messages, required this.activeQuest});
}

class GameError extends GameState {
  final String message;
  GameError(this.message);
}
