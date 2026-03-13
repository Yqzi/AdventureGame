import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:Questborne/models/item.dart';

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

class EquipItemEvent extends GameEvent {
  final Item item;
  EquipItemEvent(this.item);
}

class UnequipSlotEvent extends GameEvent {
  final ItemType slotType;
  UnequipSlotEvent(this.slotType);
}

class BuyItemEvent extends GameEvent {
  final Item item;
  BuyItemEvent(this.item);
}

class GameDisposeEvent extends GameEvent {}

/// Resume an in-progress quest with restored conversation history.
class ResumeQuestEvent extends GameEvent {
  final Map<String, dynamic> questDetails;
  final List<Map<String, String>> conversationHistory;
  final List<String> lastOptions;
  final Map<String, dynamic>? playerState;
  ResumeQuestEvent({
    required this.questDetails,
    required this.conversationHistory,
    this.lastOptions = const [],
    this.playerState,
  });
}

/// Load the player save from Supabase (called after login).
class LoadPlayerFromCloudEvent extends GameEvent {}

/// Manually trigger a player save to Supabase.
class SavePlayerToCloudEvent extends GameEvent {}

/// Set the player's character name (first-time naming).
class SetPlayerNameEvent extends GameEvent {
  final String name;
  SetPlayerNameEvent(this.name);
}

class CompleteQuestEvent extends GameEvent {
  final String questId;
  CompleteQuestEvent(this.questId);
}

/// Reset player and all in-memory state (e.g. on account deletion / sign out).
class ResetPlayerEvent extends GameEvent {}

/// Player died during a quest — penalise by resetting the current set's progress.
class QuestFailedPenaltyEvent extends GameEvent {
  final String questId;
  QuestFailedPenaltyEvent(this.questId);
}

/// Player casts a spell from the hotbar during a quest.
class CastSpellEvent extends GameEvent {
  final Item spell;
  CastSpellEvent(this.spell);
}
