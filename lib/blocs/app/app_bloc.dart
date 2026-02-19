import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tes/models/chat_message.dart';
import 'package:tes/models/player.dart';
import 'package:tes/models/story_event.dart';
import 'package:tes/utils/apply_story_effects.dart';
import 'package:uuid/uuid.dart';
import 'package:tes/blocs/app/app_event.dart';
import 'package:tes/blocs/app/app_state.dart';
import 'package:tes/services/ai_service.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final AIService _aiService;
  final Uuid _uuid = const Uuid();

  Map<String, dynamic> _currentActiveQuest = {};
  List<ChatMessage> _chatHistory = [];
  late Player _player;

  GameBloc({required AIService aiService})
    : _aiService = aiService,
      super(
        GameInitial(
          player: Player.create(id: const Uuid().v4(), name: 'Adventurer'),
        ),
      ) {
    // Create the player with defaults — name can come from quest details
    _player = Player.create(id: _uuid.v4(), name: 'Adventurer');

    on<StartNewQuestEvent>(_onStartNewQuest);
    on<PlayerCommandEvent>(_onPlayerCommand);
    on<EquipItemEvent>(_onEquipItem);
    on<UnequipSlotEvent>(_onUnequipSlot);
    on<BuyItemEvent>(_onBuyItem);
    on<GameDisposeEvent>((event, emit) {
      _currentActiveQuest = {};
      _chatHistory = [];
      emit(GameInitial(player: _player));
    });
  }

  /// The current player — exposed for reading outside the bloc if needed.
  Player get player => _player;

  @override
  Future<void> close() {
    return super.close();
  }

  // ─────────────────────────────────────────────────────────
  //  EFFECTS PARSING
  // ─────────────────────────────────────────────────────────

  /// The AI appends <!--OPTIONS:[...]-->  and <!--EFFECTS:{...}--> at the end.
  static final RegExp _effectsPattern = RegExp(
    r'<!--EFFECTS:(.*?)-->',
    dotAll: true,
  );

  static final RegExp _optionsPattern = RegExp(
    r'<!--OPTIONS:(.*?)-->',
    dotAll: true,
  );

  /// Splits the raw AI response into (cleanNarrative, StoryEffects?, options).
  ({String narrative, StoryEffects? effects, List<String> options})
  _parseResponse(String raw) {
    // Extract effects
    StoryEffects? effects;
    final effectsMatch = _effectsPattern.firstMatch(raw);
    if (effectsMatch != null) {
      try {
        final json = jsonDecode(effectsMatch.group(1)!) as Map<String, dynamic>;
        effects = StoryEffects.fromJson(json);
      } catch (e) {
        print('Failed to parse effects JSON: $e');
      }
    }

    // Extract options
    List<String> options = [];
    final optionsMatch = _optionsPattern.firstMatch(raw);
    if (optionsMatch != null) {
      try {
        final decoded = jsonDecode(optionsMatch.group(1)!) as List<dynamic>;
        options = decoded.map((e) => e.toString()).toList();
      } catch (e) {
        print('Failed to parse options JSON: $e');
      }
    }

    // Clean narrative — remove both markers
    String narrative = raw
        .replaceAll(_effectsPattern, '')
        .replaceAll(_optionsPattern, '')
        .trim();

    return (narrative: narrative, effects: effects, options: options);
  }

  // ─────────────────────────────────────────────────────────
  //  START NEW QUEST
  // ─────────────────────────────────────────────────────────

  Future<void> _onStartNewQuest(
    StartNewQuestEvent event,
    Emitter<GameState> emit,
  ) async {
    _currentActiveQuest = event.questDetails;
    _chatHistory = [];

    // Restore HP & MP for the new quest but keep level, gold, inventory, etc.
    _player = _player.fullRestore();

    emit(GameLoading(message: 'Starting your quest...', player: _player));

    _chatHistory.add(
      ChatMessage.aiStreaming(
        id: _uuid.v4(),
        text: "",
        timestamp: DateTime.now(),
      ),
    );

    String accumulatedRaw = "";
    try {
      await for (final chunk in _aiService.streamResponse(
        "The player accepts the quest: '${_currentActiveQuest['title']}'. "
        "Narrate their immediate surroundings and what happens next.",
        _currentActiveQuest,
        player: _player,
      )) {
        accumulatedRaw += chunk;

        // During streaming, show text but strip the markers if partially visible
        final displayText = accumulatedRaw
            .replaceAll(_effectsPattern, '')
            .replaceAll(_optionsPattern, '')
            .trim();
        _chatHistory.last.text = displayText;

        emit(
          GameStreamingNarrative(
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
          ),
        );
      }

      // ── Stream complete — parse effects and apply ──
      final parsed = _parseResponse(accumulatedRaw);
      _chatHistory.last.text = parsed.narrative;
      _chatHistory.last.isComplete = true;

      if (parsed.effects != null) {
        _player = applyStoryEffects(_player, parsed.effects!);
      }

      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          options: parsed.options,
          effects: parsed.effects,
        ),
      );
    } catch (error, stackTrace) {
      print('Error during AI stream for StartNewQuest: $error\n$stackTrace');
      _chatHistory.last.text = 'Error: $error';
      _chatHistory.last.isComplete = true;
      emit(GameError('Failed to start quest: $error', player: _player));
    }
  }

  // ─────────────────────────────────────────────────────────
  //  PLAYER COMMAND
  // ─────────────────────────────────────────────────────────

  Future<void> _onPlayerCommand(
    PlayerCommandEvent event,
    Emitter<GameState> emit,
  ) async {
    if (_currentActiveQuest.isEmpty) {
      emit(
        GameError(
          'No active quest. Please start a quest first.',
          player: _player,
        ),
      );
      return;
    }

    // Add the player's message to chat history
    _chatHistory.add(
      ChatMessage(
        id: _uuid.v4(),
        sender: MessageSender.player,
        text: event.command,
        timestamp: DateTime.now(),
        isComplete: true,
      ),
    );

    // Add a placeholder for the AI response
    _chatHistory.add(
      ChatMessage.aiStreaming(
        id: _uuid.v4(),
        text: "",
        timestamp: DateTime.now(),
      ),
    );

    emit(
      GameStreamingNarrative(
        messages: List.from(_chatHistory),
        activeQuest: _currentActiveQuest,
        player: _player,
      ),
    );

    String accumulatedRaw = "";
    try {
      await for (final chunk in _aiService.streamResponse(
        event.command,
        _currentActiveQuest,
        player: _player,
      )) {
        accumulatedRaw += chunk;

        // Strip markers from display during streaming
        final displayText = accumulatedRaw
            .replaceAll(_effectsPattern, '')
            .replaceAll(_optionsPattern, '')
            .trim();
        _chatHistory.last.text = displayText;

        emit(
          GameStreamingNarrative(
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
          ),
        );
      }

      // ── Stream complete — parse effects and apply ──
      final parsed = _parseResponse(accumulatedRaw);
      _chatHistory.last.text = parsed.narrative;
      _chatHistory.last.isComplete = true;

      if (parsed.effects != null) {
        _player = applyStoryEffects(_player, parsed.effects!);
      }

      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          options: parsed.options,
          effects: parsed.effects,
        ),
      );
    } catch (error, stackTrace) {
      print('Error during AI stream for PlayerCommand: $error\n$stackTrace');
      _chatHistory.last.text = 'Error: $error';
      _chatHistory.last.isComplete = true;
      emit(GameError('Failed to process command: $error', player: _player));
    }
  }

  // ─────────────────────────────────────────────────────────
  //  EQUIP / UNEQUIP
  // ─────────────────────────────────────────────────────────

  void _onEquipItem(EquipItemEvent event, Emitter<GameState> emit) {
    _player = _player.equipItem(event.item);
    _emitCurrentWithPlayer(emit);
  }

  void _onUnequipSlot(UnequipSlotEvent event, Emitter<GameState> emit) {
    _player = _player.unequipSlot(event.slotType);
    _emitCurrentWithPlayer(emit);
  }

  void _onBuyItem(BuyItemEvent event, Emitter<GameState> emit) {
    if (!_player.canAfford(event.item.price)) return;
    _player = _player.buyItem(event.item);
    _emitCurrentWithPlayer(emit);
  }

  /// Re-emits the current state type so BlocBuilder rebuilds with fresh player.
  void _emitCurrentWithPlayer(Emitter<GameState> emit) {
    final s = state;
    if (s is GameLoaded) {
      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
        ),
      );
    } else if (s is GameStreamingNarrative) {
      emit(
        GameStreamingNarrative(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
        ),
      );
    } else {
      // No active quest — still emit so the inventory page rebuilds
      emit(GameInitial(player: _player));
    }
  }
}
