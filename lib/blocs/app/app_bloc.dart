import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Questborne/models/chat_message.dart';
import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/quest.dart';
import 'package:Questborne/models/story_event.dart';
import 'package:Questborne/utils/apply_story_effects.dart';
import 'package:Questborne/utils/skill_check_engine.dart';
import 'package:Questborne/models/skill_check.dart';
import 'package:uuid/uuid.dart';
import 'package:Questborne/blocs/app/app_event.dart';
import 'package:Questborne/blocs/app/app_state.dart';
import 'package:Questborne/models/game_session.dart';
import 'package:Questborne/services/ai_service.dart';
import 'package:Questborne/services/conversation_memory_manager.dart';
import 'package:Questborne/services/game_session_repository.dart';
import 'package:Questborne/services/subscription_service.dart';
import 'package:Questborne/services/supabase_save_service.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final AIService _aiService;
  final Uuid _uuid = const Uuid();
  final GameSessionRepository _sessionRepo = GameSessionRepository();
  final SupabaseSaveService _saveService = SupabaseSaveService();
  final ConversationMemoryManager _memoryManager = ConversationMemoryManager();

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
    on<CastSpellEvent>(_onCastSpell);
    on<EquipItemEvent>(_onEquipItem);
    on<UnequipSlotEvent>(_onUnequipSlot);
    on<BuyItemEvent>(_onBuyItem);
    on<ResumeQuestEvent>(_onResumeQuest);
    on<GameDisposeEvent>((event, emit) {
      _currentActiveQuest = {};
      _chatHistory = [];
      emit(GameInitial(player: _player));
    });
    on<LoadPlayerFromCloudEvent>(_onLoadPlayer);
    on<SavePlayerToCloudEvent>(_onSavePlayer);
    on<SetPlayerNameEvent>(_onSetPlayerName);
    on<ResetPlayerEvent>(_onResetPlayer);
    on<CompleteQuestEvent>(_onCompleteQuest);
    on<QuestFailedPenaltyEvent>(_onQuestFailedPenalty);
  }

  /// The current player — exposed for reading outside the bloc if needed.
  Player get player => _player;

  /// Expose the AI service so settings can reload safety thresholds.
  AIService get aiService => _aiService;

  /// Expose chat history so the game page can save sessions.
  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  /// Expose active quest details.
  Map<String, dynamic> get activeQuest => Map.unmodifiable(_currentActiveQuest);

  @override
  Future<void> close() {
    return super.close();
  }

  // ─────────────────────────────────────────────────────────
  //  CLOUD SAVE / LOAD
  // ─────────────────────────────────────────────────────────

  Future<void> _onLoadPlayer(
    LoadPlayerFromCloudEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      final json = await _saveService.loadPlayerJson();
      if (json != null) {
        _player = Player.fromJson(json);
      }
      // Also sync cached game sessions from Supabase.
      await _sessionRepo.syncFromRemote();
      // Refresh subscription tier so credit limits and model are up-to-date.
      await SubscriptionService().refresh();
    } catch (e) {
      // If loading fails, keep the default player—don't crash.
      print('Failed to load player from cloud: $e');
    }
    emit(GameInitial(player: _player));
  }

  Future<void> _onSavePlayer(
    SavePlayerToCloudEvent event,
    Emitter<GameState> emit,
  ) async {
    try {
      await _saveService.savePlayer(_player);
    } catch (e) {
      print('Failed to save player to cloud: $e');
    }
  }

  void _onSetPlayerName(SetPlayerNameEvent event, Emitter<GameState> emit) {
    _player = _player.copyWith(name: event.name);
    _autoSavePlayer();
    emit(GameInitial(player: _player));
  }

  /// Fire-and-forget helper to persist the player after every meaningful change.
  void _autoSavePlayer() {
    _saveService.savePlayer(_player).catchError((_) {});
  }

  /// Fire-and-forget helper to persist the current quest session
  /// (conversation history + options) after every AI response.
  void _autoSaveSession({List<String> lastOptions = const []}) {
    final questId = _currentActiveQuest['id'] as String?;
    if (questId == null || _chatHistory.isEmpty) return;
    final history = _chatHistory
        .map(
          (m) => {
            'sender': m.sender == MessageSender.player ? 'player' : 'ai',
            'text': m.text,
          },
        )
        .toList();
    final session = GameSession(
      questId: questId,
      conversationHistory: history,
      questDetails: _currentActiveQuest,
      lastOptions: lastOptions,
      playerState: _player.toJson(),
      savedAt: DateTime.now(),
    );
    _sessionRepo.saveSession(session).catchError((_) {});
  }

  void _onResetPlayer(ResetPlayerEvent event, Emitter<GameState> emit) {
    _player = Player.create(id: _uuid.v4(), name: 'Adventurer');
    _currentActiveQuest = {};
    _chatHistory = [];
    _sessionRepo.clearLocal();
    emit(GameInitial(player: _player));
  }

  void _onCompleteQuest(CompleteQuestEvent event, Emitter<GameState> emit) {
    final quest = repeatableQuests.cast<Quest?>().firstWhere(
      (q) => q!.id == event.questId,
      orElse: () => null,
    );
    if (quest != null && quest.isRepeatable) {
      // Repeatable: award gold/XP but don't track in completedQuestIds.
      _player = _player
          .gainGold(quest.goldReward)
          .gainExperience(quest.xpReward);
      // Auto level-up (restores HP/MP to full on each level gained).
      while (_player.canLevelUp) {
        _player = _player.levelUp();
      }
    } else {
      // Look up the main quest to award its gold/XP.
      final mainQuest = allQuests.cast<Quest?>().firstWhere(
        (q) => q!.id == event.questId,
        orElse: () => null,
      );
      if (mainQuest != null) {
        _player = _player
            .gainGold(mainQuest.goldReward)
            .gainExperience(mainQuest.xpReward);
      }

      // Capture the current set BEFORE marking the quest complete.
      final setBeforeComplete = Quest.currentSetIds(
        _player.completedQuestIds.toSet(),
      );

      _player = _player.completeQuest(event.questId);

      // Auto level-up (restores HP/MP to full on each level gained).
      while (_player.canLevelUp) {
        _player = _player.levelUp();
      }

      // If the set that was in progress is now fully complete, full-restore.
      final completedIds = _player.completedQuestIds.toSet();
      if (setBeforeComplete != null &&
          setBeforeComplete.every((id) => completedIds.contains(id))) {
        _player = _player.fullRestore();
      }
    }
    _autoSavePlayer();
    emit(GameInitial(player: _player));
  }

  void _onQuestFailedPenalty(
    QuestFailedPenaltyEvent event,
    Emitter<GameState> emit,
  ) {
    // Find which set this quest belongs to.
    final setIds = Quest.setContaining(event.questId);
    if (setIds != null) {
      // Remove any completed quest IDs from this set.
      final updated = _player.completedQuestIds
          .where((id) => !setIds.contains(id))
          .toList();
      // Recalculate questsCompleted count.
      final removedCount = _player.completedQuestIds.length - updated.length;
      _player = _player.copyWith(
        completedQuestIds: updated,
        questsCompleted: (_player.questsCompleted - removedCount).clamp(
          0,
          99999,
        ),
      );
    }
    // Full-restore HP after death so player can try again.
    _player = _player.fullRestore();
    _autoSavePlayer();
    emit(GameInitial(player: _player));
  }

  // ─────────────────────────────────────────────────────────
  //  EFFECTS PARSING
  // ─────────────────────────────────────────────────────────

  /// The AI appends <!--OPTIONS:[...]-->  and <!--EFFECTS:{...}--> at the end.
  static final RegExp _effectsPattern = RegExp(
    r'<!--\s*EFFECTS\s*:\s*(.*?)\s*-->',
    dotAll: true,
  );

  static final RegExp _optionsPattern = RegExp(
    r'<!--\s*OPTIONS\s*:\s*(.*?)\s*-->',
    dotAll: true,
  );

  /// Fallback patterns for when the AI deviates from the expected format.
  static final RegExp _effectsFallback = RegExp(
    r'EFFECTS\s*:\s*(\{[^}]*\})',
    dotAll: true,
  );
  static final RegExp _optionsFallback = RegExp(
    r'OPTIONS\s*:\s*(\[[^\]]*\])',
    dotAll: true,
  );

  /// Aggressively strip any leaked metadata from the narrative.
  static final RegExp _leakedMetadata = RegExp(
    r'<!--.*?-->|EFFECTS\s*:\s*\{[^}]*\}|OPTIONS\s*:\s*\[[^\]]*\]|```json\s*\{[^}]*\}\s*```|```json\s*\[[^\]]*\]\s*```|```\s*\{[^}]*\}\s*```|```\s*\[[^\]]*\]\s*```',
    dotAll: true,
  );

  /// Splits the raw AI response into (cleanNarrative, StoryEffects?, options).
  ({String narrative, StoryEffects? effects, List<String> options})
  _parseResponse(String raw) {
    // Extract effects — try primary pattern, then fallback
    StoryEffects? effects;
    final effectsMatch =
        _effectsPattern.firstMatch(raw) ?? _effectsFallback.firstMatch(raw);
    if (effectsMatch != null) {
      try {
        final json = jsonDecode(effectsMatch.group(1)!) as Map<String, dynamic>;
        effects = StoryEffects.fromJson(json);
      } catch (e) {
        print('Failed to parse effects JSON: $e');
      }
    }

    // Extract options — try primary pattern, then fallback
    List<String> options = [];
    final optionsMatch =
        _optionsPattern.firstMatch(raw) ?? _optionsFallback.firstMatch(raw);
    if (optionsMatch != null) {
      try {
        final decoded = jsonDecode(optionsMatch.group(1)!) as List<dynamic>;
        options = decoded.map((e) => e.toString()).toList();
      } catch (e) {
        print('Failed to parse options JSON: $e');
      }
    }

    // Clean narrative — aggressively strip all metadata patterns
    String narrative = raw.replaceAll(_leakedMetadata, '').trim();

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
    _memoryManager.reset();

    // HP persists across quests — no full restore here.
    // Player only heals when completing an entire quest set.

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
      // Build conversation context based on subscription tier.
      final tier = SubscriptionService().current.effectiveTier;
      final conversationCtx = _memoryManager.buildContextForAI(
        _chatHistory.where((m) => m.isComplete).toList(),
        tier,
      );

      await for (final chunk in _aiService.streamResponse(
        "The player accepts the quest: '${_currentActiveQuest['title']}'. "
        "Narrate their immediate surroundings and what happens next.",
        _currentActiveQuest,
        player: _player,
        conversationContext: conversationCtx.isNotEmpty
            ? conversationCtx
            : null,
      )) {
        accumulatedRaw += chunk;

        // During streaming, show text but strip the markers if partially visible
        final displayText = accumulatedRaw
            .replaceAll(_leakedMetadata, '')
            .trim();
        if (_chatHistory.isEmpty) continue;
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
      print('=== RAW AI RESPONSE (StartNewQuest) ===');
      print(accumulatedRaw);
      print('=== END RAW AI RESPONSE ===');

      final parsed = _parseResponse(accumulatedRaw);
      _chatHistory.last.text = parsed.narrative;
      _chatHistory.last.isComplete = true;

      StoryEffects? displayEffects = parsed.effects;
      if (parsed.effects != null) {
        final result = applyStoryEffects(_player, parsed.effects!);
        _player = result.player;
        displayEffects = result.effects;
      }

      _autoSavePlayer();

      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          options: parsed.options,
          effects: displayEffects,
        ),
      );

      _autoSaveSession(lastOptions: parsed.options);
    } catch (error, stackTrace) {
      print('Error during AI stream for StartNewQuest: $error\n$stackTrace');
      if (_chatHistory.isNotEmpty) {
        _chatHistory.last.text = 'Error: $error';
        _chatHistory.last.isComplete = true;
      }
      emit(GameError('Failed to start quest: $error', player: _player));
    }
  }

  // ─────────────────────────────────────────────────────────
  //  RESUME QUEST (from a saved session)
  // ─────────────────────────────────────────────────────────

  Future<void> _onResumeQuest(
    ResumeQuestEvent event,
    Emitter<GameState> emit,
  ) async {
    _currentActiveQuest = event.questDetails;

    // Use the current global player (HP persists across quests).
    // Don't restore from the session snapshot — it has stale HP.

    // Reset conversation memory so the rolling summary index doesn't
    // reference the previous session's message count.
    _memoryManager.reset();

    // Rebuild _chatHistory from the saved conversation
    _chatHistory = event.conversationHistory.map((m) {
      final sender = m['sender'] == 'player'
          ? MessageSender.player
          : MessageSender.ai;
      return ChatMessage(
        id: _uuid.v4(),
        sender: sender,
        text: m['text'] ?? '',
        timestamp: DateTime.now(),
        isComplete: true,
      );
    }).toList();

    // Simply restore the previous state without re-generating from the AI.
    // The player will see exactly where they left off with the same options.
    emit(
      GameLoaded(
        messages: List.from(_chatHistory),
        activeQuest: _currentActiveQuest,
        player: _player,
        options: event.lastOptions,
      ),
    );
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

    // ── Skill check: roll dice BEFORE streaming starts ──
    final questDifficulty = _currentActiveQuest['difficulty'] as String?;
    final skillCheck = SkillCheckEngine.performCheck(
      playerInput: event.command,
      player: _player,
      questDifficulty: questDifficulty,
    );

    emit(
      GameStreamingNarrative(
        messages: List.from(_chatHistory),
        activeQuest: _currentActiveQuest,
        player: _player,
        skillCheck: skillCheck,
      ),
    );

    String accumulatedRaw = "";
    try {
      // Build the prompt. If a skill check was triggered, prepend the
      // result so the AI knows the outcome and MUST narrate accordingly.
      String aiPrompt = event.command;
      if (skillCheck != null) {
        aiPrompt =
            '${event.command}\n\n'
            '[SKILL CHECK: ${skillCheck.summary}. '
            'You MUST narrate the outcome matching this result. '
            'Do NOT override the dice.]';
      }

      // Build conversation context based on subscription tier.
      final tier = SubscriptionService().current.effectiveTier;
      final conversationCtx = _memoryManager.buildContextForAI(
        _chatHistory.where((m) => m.isComplete).toList(),
        tier,
      );

      await for (final chunk in _aiService.streamResponse(
        aiPrompt,
        _currentActiveQuest,
        player: _player,
        conversationContext: conversationCtx.isNotEmpty
            ? conversationCtx
            : null,
      )) {
        accumulatedRaw += chunk;

        // Strip markers from display during streaming
        final displayText = accumulatedRaw
            .replaceAll(_leakedMetadata, '')
            .trim();
        if (_chatHistory.isEmpty) continue;
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
      print('=== RAW AI RESPONSE (PlayerCommand) ===');
      print(accumulatedRaw);
      print('=== END RAW AI RESPONSE ===');

      final parsed = _parseResponse(accumulatedRaw);
      if (_chatHistory.isEmpty) return;
      _chatHistory.last.text = parsed.narrative;
      _chatHistory.last.isComplete = true;

      StoryEffects? displayEffects = parsed.effects;
      if (parsed.effects != null) {
        final result = applyStoryEffects(_player, parsed.effects!);
        _player = result.player;
        displayEffects = result.effects;
      }

      _autoSavePlayer();

      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          options: parsed.options,
          effects: displayEffects,
          skillCheck: skillCheck,
        ),
      );

      _autoSaveSession(lastOptions: parsed.options);
    } catch (error, stackTrace) {
      print('Error during AI stream for PlayerCommand: $error\n$stackTrace');
      if (_chatHistory.isNotEmpty) {
        _chatHistory.last.text = 'Error: $error';
        _chatHistory.last.isComplete = true;
      }
      emit(GameError('Failed to process command: $error', player: _player));
    }
  }

  // ─────────────────────────────────────────────────────────
  //  CAST SPELL
  // ─────────────────────────────────────────────────────────

  Future<void> _onCastSpell(
    CastSpellEvent event,
    Emitter<GameState> emit,
  ) async {
    final spell = event.spell;

    // Guard: must have an active quest and enough mana.
    if (_currentActiveQuest.isEmpty) {
      emit(GameError('No active quest.', player: _player));
      return;
    }
    if (_player.currentMana < spell.manaCost) {
      emit(
        GameError('Not enough mana to cast ${spell.name}.', player: _player),
      );
      return;
    }

    // Deduct mana upfront so the AI sees the reduced MP.
    _player = _player.spendMana(spell.manaCost);

    // Build a structured command the AI will narrate.
    final command = 'I cast ${spell.name}. (${spell.effect})';

    // Add the player's "cast" message to chat history.
    _chatHistory.add(
      ChatMessage(
        id: _uuid.v4(),
        sender: MessageSender.player,
        text: 'Cast ${spell.name}',
        timestamp: DateTime.now(),
        isComplete: true,
      ),
    );

    // Add a placeholder for the AI response.
    _chatHistory.add(
      ChatMessage.aiStreaming(
        id: _uuid.v4(),
        text: '',
        timestamp: DateTime.now(),
      ),
    );

    // ── Skill check for spell casting — roll BEFORE streaming starts ──
    final questDifficulty = _currentActiveQuest['difficulty'] as String?;
    final skillCheck = SkillCheckEngine.performCheck(
      playerInput: command,
      player: _player,
      questDifficulty: questDifficulty,
    );

    emit(
      GameStreamingNarrative(
        messages: List.from(_chatHistory),
        activeQuest: _currentActiveQuest,
        player: _player,
        skillCheck: skillCheck,
      ),
    );

    String accumulatedRaw = '';
    try {
      String aiPrompt = command;
      if (skillCheck != null) {
        aiPrompt =
            '$command\n\n'
            '[SKILL CHECK: ${skillCheck.summary}. '
            'You MUST narrate the outcome matching this result. '
            'Do NOT override the dice.]';
      }

      final tier = SubscriptionService().current.effectiveTier;
      final conversationCtx = _memoryManager.buildContextForAI(
        _chatHistory.where((m) => m.isComplete).toList(),
        tier,
      );

      await for (final chunk in _aiService.streamResponse(
        aiPrompt,
        _currentActiveQuest,
        player: _player,
        conversationContext: conversationCtx.isNotEmpty
            ? conversationCtx
            : null,
      )) {
        accumulatedRaw += chunk;

        final displayText = accumulatedRaw
            .replaceAll(_leakedMetadata, '')
            .trim();
        if (_chatHistory.isEmpty) continue;
        _chatHistory.last.text = displayText;

        emit(
          GameStreamingNarrative(
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
          ),
        );
      }

      final parsed = _parseResponse(accumulatedRaw);
      if (_chatHistory.isEmpty) return;
      _chatHistory.last.text = parsed.narrative;
      _chatHistory.last.isComplete = true;

      // Apply effects — note: mana was already deducted, so zero-out
      // any AI-reported manaSpent to avoid double-spending.
      StoryEffects? displayEffects = parsed.effects;
      if (parsed.effects != null) {
        final corrected = parsed.effects!.copyWith(manaSpent: 0);
        final result = applyStoryEffects(_player, corrected);
        _player = result.player;
        // Show the original mana cost in the loot notification.
        displayEffects = result.effects.copyWith(manaSpent: spell.manaCost);
      } else {
        // Even without AI effects, show the mana cost.
        displayEffects = StoryEffects(manaSpent: spell.manaCost);
      }

      _autoSavePlayer();

      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          options: parsed.options,
          effects: displayEffects,
          skillCheck: skillCheck,
        ),
      );

      _autoSaveSession(lastOptions: parsed.options);
    } catch (error, stackTrace) {
      print('Error during AI stream for CastSpell: $error\n$stackTrace');
      if (_chatHistory.isNotEmpty) {
        _chatHistory.last.text = 'Error: $error';
        _chatHistory.last.isComplete = true;
      }
      emit(GameError('Failed to cast spell: $error', player: _player));
    }
  }

  // ─────────────────────────────────────────────────────────
  //  EQUIP / UNEQUIP
  // ─────────────────────────────────────────────────────────

  void _onEquipItem(EquipItemEvent event, Emitter<GameState> emit) {
    _player = _player.equipItem(event.item);
    _autoSavePlayer();
    _emitCurrentWithPlayer(emit);
  }

  void _onUnequipSlot(UnequipSlotEvent event, Emitter<GameState> emit) {
    _player = _player.unequipSlot(event.slotType);
    _autoSavePlayer();
    _emitCurrentWithPlayer(emit);
  }

  void _onBuyItem(BuyItemEvent event, Emitter<GameState> emit) {
    if (!_player.canAfford(event.item.price)) return;
    _player = _player.buyItem(event.item);
    _autoSavePlayer();
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
