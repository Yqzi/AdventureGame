import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tes/models/item.dart';
import 'package:tes/models/player.dart';

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
