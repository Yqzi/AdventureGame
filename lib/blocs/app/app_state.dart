import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:Questborne/models/chat_message.dart';
import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/skill_check.dart';
import 'package:Questborne/models/story_event.dart';
import 'package:Questborne/utils/skill_check_engine.dart';

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
  @override
  final Player player;
  final List<String> options;
  final StoryEffects? effects;
  final SkillCheckResult? skillCheck;
  GameLoaded({
    required this.messages,
    required this.activeQuest,
    required this.player,
    this.options = const [],
    this.effects,
    this.skillCheck,
  });
}

class GameStreamingNarrative extends GameState {
  final List<ChatMessage> messages;
  final Map<String, dynamic> activeQuest;
  @override
  final Player player;
  final SkillCheckResult? skillCheck;
  GameStreamingNarrative({
    required this.messages,
    required this.activeQuest,
    required this.player,
    this.skillCheck,
  });
}

class GameError extends GameState {
  final String message;
  @override
  final Player player;
  GameError(this.message, {required this.player});
}

/// Emitted when the player hasn't completed character creation yet.
/// The UI should navigate to the character creation wizard.
class GameNeedsCharacterCreation extends GameState {
  @override
  final Player player;
  GameNeedsCharacterCreation({required this.player});
}

/// Recoverable error — the failed turn is rolled back so the player can retry.
/// The UI shows a dialog with the error message, restores the text field input,
/// and re-displays the previous turn's option buttons.
class GameErrorRecoverable extends GameState {
  final String errorMessage;
  final List<ChatMessage> messages;
  final Map<String, dynamic> activeQuest;
  @override
  final Player player;
  final List<String> previousOptions;
  final String? pendingInput;
  GameErrorRecoverable({
    required this.errorMessage,
    required this.messages,
    required this.activeQuest,
    required this.player,
    this.previousOptions = const [],
    this.pendingInput,
  });
}

/// Emitted when the action requires a dice roll but we want the player
/// to tap and animate it rather than auto-rolling. The UI shows the
/// [_DiceRollPrompt] overlay; the player taps → roll animates →
/// [PlayerRollDiceEvent] is dispatched with the settled value.
class GameWaitingForDiceRoll extends GameState {
  final List<ChatMessage> messages;
  final Map<String, dynamic> activeQuest;
  @override
  final Player player;

  /// The action being attempted (drives the label shown to the player).
  final ActionType actionType;

  /// Total stat modifier (ability mod + proficiency) to display.
  final int statModifier;

  /// Difficulty class the roll is against.
  final int dc;

  /// +1 = advantage, -1 = disadvantage, 0 = normal.
  final int advantageState;

  /// True when this is a death saving throw (no action label needed).
  final bool isDeathSave;

  GameWaitingForDiceRoll({
    required this.messages,
    required this.activeQuest,
    required this.player,
    required this.actionType,
    required this.statModifier,
    required this.dc,
    required this.advantageState,
    this.isDeathSave = false,
  });
}
