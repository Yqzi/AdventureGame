import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:Questborne/models/item.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Questborne/models/chat_message.dart';
import 'package:Questborne/models/player.dart';
import 'package:Questborne/blocs/app/app_state.dart';
import 'package:Questborne/models/quest.dart';
import 'package:Questborne/models/story_event.dart';
import 'package:Questborne/utils/apply_story_effects.dart';
import 'package:Questborne/utils/skill_check_engine.dart';
import 'package:Questborne/models/skill_check.dart';
import 'package:uuid/uuid.dart';
import 'package:Questborne/blocs/app/app_event.dart';
import 'package:Questborne/blocs/app/app_state.dart';
import 'package:Questborne/models/game_session.dart';
import 'package:Questborne/services/action_classifier_service.dart';
import 'package:Questborne/services/ai_service.dart';
import 'package:Questborne/services/conversation_memory_manager.dart';
import 'package:Questborne/services/game_session_repository.dart';
import 'package:Questborne/services/subscription_service.dart';
import 'package:Questborne/services/supabase_save_service.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final AIService _aiService;
  final ActionClassifierService _actionClassifier = ActionClassifierService();
  final Uuid _uuid = const Uuid();
  final GameSessionRepository _sessionRepo = GameSessionRepository();
  final SupabaseSaveService _saveService = SupabaseSaveService();
  final ConversationMemoryManager _memoryManager = ConversationMemoryManager();

  Map<String, dynamic> _currentActiveQuest = {};
  List<ChatMessage> _chatHistory = [];
  late Player _player;

  /// Tracks the last action label so we can detect repeated actions.
  String? _lastActionLabel;
  int _repeatCount = 0;

  /// True when enemies are actively in melee range attacking the player.
  /// Makes ranged/magic rolls harder (concentration/aim disrupted).
  bool _underMeleePressure = false;

  /// Last successfully emitted options Ã¢â‚¬â€ used to restore on recoverable errors.
  List<String> _lastOptions = [];

  /// Guard against rapid-fire taps while an AI action is in-flight.
  bool _isProcessingAction = false;

  // ── Pending dice roll state ──────────────────────────────
  /// Set when a skill check is awaiting a player-rolled d20.
  PendingSkillCheck? _pendingSkillCheck;

  /// The original player command text that triggered the pending check.
  String? _pendingCommand;

  /// The spell being cast (non-null when the pending check came from CastSpellEvent).
  Item? _pendingSpell;

  /// True when we're waiting for a death saving throw roll (no skill check).
  bool _pendingIsDeathSave = false;

  GameBloc({required AIService aiService})
    : _aiService = aiService,
      super(
        GameInitial(
          player: Player.create(id: const Uuid().v4(), name: 'Adventurer'),
        ),
      ) {
    // Create the player with defaults Ã¢â‚¬â€ name can come from quest details
    _player = Player.create(id: _uuid.v4(), name: 'Adventurer');

    on<StartNewQuestEvent>(_onStartNewQuest, transformer: droppable());
    on<PlayerCommandEvent>(_onPlayerCommand, transformer: droppable());
    on<CastSpellEvent>(_onCastSpell, transformer: droppable());
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
    on<CompleteCharacterCreationEvent>(_onCompleteCharacterCreation);
    on<MakeDeathSavingThrowEvent>(_onMakeDeathSavingThrow);
    on<PlayerRollDiceEvent>(_onPlayerRollDice);
  }

  /// The current player Ã¢â‚¬â€ exposed for reading outside the bloc if needed.
  Player get player => _player;

  /// Expose the AI service so settings can reload safety thresholds.
  AIService get aiService => _aiService;

  /// Expose chat history so the game page can save sessions.
  List<ChatMessage> get chatHistory => List.unmodifiable(_chatHistory);

  /// Expose active quest details.
  Map<String, dynamic> get activeQuest => Map.unmodifiable(_currentActiveQuest);

  /// Expected total exchanges for a quest, keyed by difficulty.
  int _expectedTurns(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'routine':
        return 5;
      case 'dangerous':
        return 7;
      case 'perilous':
        return 10;
      case 'suicidal':
        return 12;
      default:
        return 7;
    }
  }

  /// Hard turn cap Ã¢â‚¬â€ quest auto-fails if this is reached.
  /// Very generous leeway for exploration, side conversations, and bad rolls.
  int _maxTurns(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'routine':
        return 30;
      case 'dangerous':
        return 45;
      case 'perilous':
        return 65;
      case 'suicidal':
        return 100;
      default:
        return 50;
    }
  }

  /// Track repeated actions and return the prompt tag if repeating.
  String _trackRepeat(String actionLabel) {
    if (actionLabel == _lastActionLabel) {
      _repeatCount++;
    } else {
      _lastActionLabel = actionLabel;
      _repeatCount = 1;
    }
    if (_repeatCount >= 2) {
      return '\n[REPEATED ACTION: Player has used "$actionLabel" $_repeatCount times in a row. Enemies MUST adapt Ã¢â‚¬â€ dodge, counter, resist, or punish the predictability.]';
    }
    return '';
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  //  CLOUD SAVE / LOAD
  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

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
      // If loading fails, keep the default playerÃ¢â‚¬â€don't crash.
      print('Failed to load player from cloud: $e');
    }
    if (_player.needsCharacterCreation) {
      emit(GameNeedsCharacterCreation(player: _player));
    } else {
      emit(GameInitial(player: _player));
    }
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

  /// Remove the last [messageCount] messages from chat history (rollback a
  /// failed turn). Safely handles cases where history has fewer messages.
  void _rollbackFailedTurn({required int messageCount}) {
    final removeCount = messageCount.clamp(0, _chatHistory.length);
    if (removeCount > 0) {
      _chatHistory.removeRange(
        _chatHistory.length - removeCount,
        _chatHistory.length,
      );
    }
  }

  /// Quick credit pre-check Ã¢â‚¬â€ refreshes from Supabase and returns true
  /// only when the user has at least 1 credit remaining.
  Future<bool> _hasCredits() async {
    final sub = await SubscriptionService().fetch();
    return sub.creditsRemaining > 0;
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

      // No full-restore on set completion; only death or level-up restores.
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
    // Only full-restore if the player actually died (HP reached 0).
    if (!_player.isAlive) {
      _player = _player.fullRestore();
    }
    _autoSavePlayer();
    emit(GameInitial(player: _player));
  }

  void _onCompleteCharacterCreation(
    CompleteCharacterCreationEvent event,
    Emitter<GameState> emit,
  ) {
    _player = Player.fromCharacterCreation(
      base: _player,
      dndClass: event.dndClass,
      dndRace: event.dndRace,
      background: event.background,
      abilityScores: event.abilityScores,
      skillProficiencies: event.skillProficiencies,
    );
    _autoSavePlayer();
    emit(GameInitial(player: _player));
  }

  void _onMakeDeathSavingThrow(
    MakeDeathSavingThrowEvent event,
    Emitter<GameState> emit,
  ) {
    // Show the dice prompt — the actual roll happens when the player taps.
    _pendingIsDeathSave = true;
    _pendingSkillCheck = null;
    _pendingCommand = null;
    _pendingSpell = null;
    emit(
      GameWaitingForDiceRoll(
        messages: List.from(_chatHistory),
        activeQuest: _currentActiveQuest,
        player: _player,
        actionType: ActionType.none,
        statModifier: 0,
        dc: 10, // Death saves are always DC 10 in D&D 5e.
        advantageState: 0,
        isDeathSave: true,
      ),
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  //  EFFECTS PARSING
  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

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
    // Extract effects Ã¢â‚¬â€ try primary pattern, then fallback
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

    // Extract options Ã¢â‚¬â€ try primary pattern, then fallback
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

    // Clean narrative Ã¢â‚¬â€ aggressively strip all metadata patterns
    String narrative = raw.replaceAll(_leakedMetadata, '').trim();

    // If the response was truncated (MAX_TOKENS) or is an error message,
    // both metadata tags will be missing. Leave options empty so callers
    // can detect this and emit a recoverable error.
    if (options.isEmpty && effects == null && narrative.isNotEmpty) {
      print(
        'Ã¢Å¡Â Ã¯Â¸Â Truncated AI response detected Ã¢â‚¬â€ no OPTIONS or EFFECTS found',
      );
    }

    return (narrative: narrative, effects: effects, options: options);
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  //  START NEW QUEST
  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

  Future<void> _onStartNewQuest(
    StartNewQuestEvent event,
    Emitter<GameState> emit,
  ) async {
    if (_isProcessingAction) return;
    _isProcessingAction = true;
    try {
      // Ã¢â€â‚¬Ã¢â€â‚¬ Credit pre-check Ã¢â‚¬â€ bail before any AI work Ã¢â€â‚¬Ã¢â€â‚¬
      if (!await _hasCredits()) {
        emit(
          GameErrorRecoverable(
            errorMessage: 'No credits remaining. Credits replenish daily.',
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            previousOptions: _lastOptions,
          ),
        );
        return;
      }

      _currentActiveQuest = event.questDetails;
      _chatHistory = [];
      _memoryManager.reset();
      _lastActionLabel = null;
      _repeatCount = 0;
      _underMeleePressure = false;

      // HP persists across quests Ã¢â‚¬â€ no full restore here.
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

        // Ã¢â€â‚¬Ã¢â€â‚¬ Stream complete Ã¢â‚¬â€ parse effects and apply Ã¢â€â‚¬Ã¢â€â‚¬
        print('=== RAW AI RESPONSE (StartNewQuest) ===');
        print(accumulatedRaw);
        print('=== END RAW AI RESPONSE ===');

        final parsed = _parseResponse(accumulatedRaw);
        _chatHistory.last.text = parsed.narrative;
        _chatHistory.last.isComplete = true;

        // Truncated or error response Ã¢â‚¬â€ rollback and show recoverable error.
        if (parsed.options.isEmpty && parsed.effects == null) {
          _chatHistory.removeLast(); // remove AI placeholder
          emit(
            GameErrorRecoverable(
              errorMessage: parsed.narrative.isNotEmpty
                  ? parsed.narrative
                  : 'Something went wrong. Please try again.',
              messages: List.from(_chatHistory),
              activeQuest: _currentActiveQuest,
              player: _player,
              previousOptions: _lastOptions,
            ),
          );
          return;
        }

        StoryEffects? displayEffects = parsed.effects;
        if (parsed.effects != null) {
          final result = applyStoryEffects(_player, parsed.effects!);
          _player = result.player;
          displayEffects = result.effects;
        }

        _lastOptions = parsed.options;
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
        // Rollback the AI placeholder so the failed turn disappears.
        if (_chatHistory.isNotEmpty &&
            _chatHistory.last.sender == MessageSender.ai) {
          _chatHistory.removeLast();
        }
        emit(
          GameErrorRecoverable(
            errorMessage:
                'Something went wrong starting the quest. Please try again.',
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            previousOptions: _lastOptions,
          ),
        );
      }
    } finally {
      _isProcessingAction = false;
    }
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  //  RESUME QUEST (from a saved session)
  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

  Future<void> _onResumeQuest(
    ResumeQuestEvent event,
    Emitter<GameState> emit,
  ) async {
    _currentActiveQuest = event.questDetails;

    // Use the current global player (HP persists across quests).
    // Don't restore from the session snapshot Ã¢â‚¬â€ it has stale HP.

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
    _lastOptions = event.lastOptions;
    emit(
      GameLoaded(
        messages: List.from(_chatHistory),
        activeQuest: _currentActiveQuest,
        player: _player,
        options: event.lastOptions,
      ),
    );
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  //  PLAYER COMMAND
  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

  Future<void> _onPlayerCommand(
    PlayerCommandEvent event,
    Emitter<GameState> emit,
  ) async {
    if (_isProcessingAction) return;
    _isProcessingAction = true;
    try {
      if (_currentActiveQuest.isEmpty) {
        emit(
          GameError(
            'No active quest. Please start a quest first.',
            player: _player,
          ),
        );
        return;
      }

      // Ã¢â€â‚¬Ã¢â€â‚¬ Credit pre-check Ã¢â‚¬â€ bail before classify / dice roll Ã¢â€â‚¬Ã¢â€â‚¬
      if (!await _hasCredits()) {
        emit(
          GameErrorRecoverable(
            errorMessage: 'No credits remaining. Credits replenish daily.',
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            previousOptions: _lastOptions,
            pendingInput: event.command,
          ),
        );
        return;
      }

      // Hard spellbook enforcement: block cast-intent for spells not in the
      // player's spellbook. This fires before any AI call, so the model never
      // gets a chance to narrate the cast.
      final _castIntentRegex = RegExp(
        r'^(?:cast|use|invoke|channel|conjure)\s+(.+?)(?:\s+on\b|\s+at\b|\s+against\b|$)',
        caseSensitive: false,
      );
      final _castMatch = _castIntentRegex.firstMatch(event.command.trim());
      if (_castMatch != null) {
        final _targetName = _castMatch.group(1)!.trim().toLowerCase();
        final _isOwned = _player.spellItems.any(
          (s) =>
              _targetName == s.name.toLowerCase() ||
              _targetName.startsWith(s.name.toLowerCase()),
        );
        if (!_isOwned) {
          _chatHistory.add(
            ChatMessage(
              id: _uuid.v4(),
              sender: MessageSender.player,
              text: event.command,
              timestamp: DateTime.now(),
              isComplete: true,
            ),
          );
          _chatHistory.add(
            ChatMessage(
              id: _uuid.v4(),
              sender: MessageSender.ai,
              text:
                  'You reach for the arcane threads of that incantation, '
                  'but your mind finds only silence. That spell is not '
                  'within your spellbook.',
              timestamp: DateTime.now(),
              isComplete: true,
            ),
          );
          emit(
            GameLoaded(
              messages: List.from(_chatHistory),
              activeQuest: _currentActiveQuest,
              player: _player,
            ),
          );
          return;
        }
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

      // Ã¢â€â‚¬Ã¢â€â‚¬ Skill check: roll dice BEFORE streaming starts Ã¢â€â‚¬Ã¢â€â‚¬
      final questDifficulty = _currentActiveQuest['difficulty'] as String?;

      // Classify the action via AI.
      final classifiedAction = await _actionClassifier.classify(event.command);

      final pending = SkillCheckEngine.preparePendingCheck(
        playerInput: event.command,
        player: _player,
        questDifficulty: questDifficulty,
        action: classifiedAction,
        repeatCount: _repeatCount,
        underMeleePressure: _underMeleePressure,
      );

      if (pending != null) {
        // Auto-roll the dice — no manual tap required for skill checks.
        final roll = Random().nextInt(20) + 1;
        final skillCheck = SkillCheckEngine.resolveCheck(pending, roll);
        emit(
          GameStreamingNarrative(
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            skillCheck: skillCheck,
          ),
        );
        _isProcessingAction = true;
        try {
          await _streamCommandAI(
            command: event.command,
            skillCheck: skillCheck,
            classifiedAction: classifiedAction,
            emit: emit,
          );
        } finally {
          _isProcessingAction = false;
        }
        return;
      }

      // ActionType.none — no check needed, stream AI response directly.
      _lastActionLabel = null;
      _repeatCount = 0;

      emit(
        GameStreamingNarrative(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          skillCheck: null,
        ),
      );

      await _streamCommandAI(
        command: event.command,
        skillCheck: null,
        classifiedAction: classifiedAction,
        emit: emit,
      );
    } finally {
      _isProcessingAction = false;
    }
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  //  CAST SPELL
  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

  Future<void> _onCastSpell(
    CastSpellEvent event,
    Emitter<GameState> emit,
  ) async {
    if (_isProcessingAction) return;
    _isProcessingAction = true;
    try {
      final spell = event.spell;

      // Guard: must have an active quest and a spell slot at the spell's level.
      if (_currentActiveQuest.isEmpty) {
        emit(GameError('No active quest.', player: _player));
        return;
      }
      if (!_player.canCastAtLevel(spell.manaCost)) {
        emit(
          GameError(
            'No level-${spell.manaCost} spell slot remaining to cast ${spell.name}.',
            player: _player,
          ),
        );
        return;
      }

      // Ã¢â€â‚¬Ã¢â€â‚¬ Credit pre-check Ã¢â‚¬â€ bail before classify / dice roll Ã¢â€â‚¬Ã¢â€â‚¬
      if (!await _hasCredits()) {
        emit(
          GameErrorRecoverable(
            errorMessage: 'No credits remaining. Credits replenish daily.',
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            previousOptions: _lastOptions,
          ),
        );
        return;
      }

      // Consume exactly one spell slot at the spell's level.
      _player = _player.useSpellSlot(spell.manaCost);

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

      final questDifficulty = _currentActiveQuest['difficulty'] as String?;

      // Classify the action via AI.
      final classifiedAction = await _actionClassifier.classify(command);

      final pending = SkillCheckEngine.preparePendingCheck(
        playerInput: command,
        player: _player,
        questDifficulty: questDifficulty,
        action: classifiedAction,
        repeatCount: _repeatCount,
        underMeleePressure: _underMeleePressure,
      );

      if (pending != null) {
        // Auto-roll the dice for spell skill checks.
        final roll = Random().nextInt(20) + 1;
        final skillCheck = SkillCheckEngine.resolveCheck(pending, roll);
        emit(
          GameStreamingNarrative(
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            skillCheck: skillCheck,
          ),
        );
        await _streamSpellAI(
          spell: spell,
          command: command,
          skillCheck: skillCheck,
          emit: emit,
        );
        return;
      }

      // No spell check needed — stream AI response directly.
      emit(
        GameStreamingNarrative(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          skillCheck: null,
        ),
      );

      await _streamSpellAI(
        spell: spell,
        command: command,
        skillCheck: null,
        emit: emit,
      );
    } finally {
      _isProcessingAction = false;
    }
  }

  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬
  //  EQUIP / UNEQUIP
  // Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬Ã¢â€â‚¬

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
      // No active quest Ã¢â‚¬â€ still emit so the inventory page rebuilds
      emit(GameInitial(player: _player));
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  SHARED STREAMING HELPERS
  // ─────────────────────────────────────────────────────────────

  /// Streams an AI response for a player text command, applying skill check
  /// results and story effects. Called from both [_onPlayerCommand] (when no
  /// dice check is needed) and [_onPlayerRollDice] (after the roll is resolved).
  Future<void> _streamCommandAI({
    required String command,
    required SkillCheckResult? skillCheck,
    required ActionType classifiedAction,
    required Emitter<GameState> emit,
  }) async {
    String accumulatedRaw = '';
    try {
      final turnNumber = _chatHistory
          .where((m) => m.sender == MessageSender.player && m.isComplete)
          .length;
      final difficulty =
          _currentActiveQuest['difficulty'] as String? ?? 'Dangerous';
      final expectedTurns = _expectedTurns(difficulty);
      final maxTurns = _maxTurns(difficulty);

      String aiPrompt =
          '$command\n[TURN $turnNumber of ~$expectedTurns, HARD LIMIT $maxTurns]';

      // Spellbook restriction — tell the AI which spells the player actually owns.
      final ownedSpells = _player.spellItems;
      if (ownedSpells.isNotEmpty) {
        final spellList = ownedSpells.map((s) => s.name).join(', ');
        aiPrompt +=
            '\n[SPELLBOOK RESTRICTION: The player\'s spellbook contains ONLY: $spellList. '
            'Never allow the player to cast any spell not in this list. '
            'If the player attempts to use an unlisted spell, refuse in-character and remind them what they know.]';
      } else {
        aiPrompt +=
            '\n[SPELLBOOK RESTRICTION: This player has NO spells in their spellbook and cannot cast any spells.]';
      }

      if (skillCheck != null) {
        aiPrompt +=
            '\n[SKILL CHECK: ${skillCheck.summary}. '
            'You MUST narrate the outcome matching this result. '
            'Do NOT override the dice.]';
        aiPrompt += _trackRepeat(skillCheck.actionType.label);
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

      print('=== RAW AI RESPONSE (PlayerCommand) ===');
      print(accumulatedRaw);
      print('=== END RAW AI RESPONSE ===');

      final parsed = _parseResponse(accumulatedRaw);
      if (_chatHistory.isEmpty) return;
      _chatHistory.last.text = parsed.narrative;
      _chatHistory.last.isComplete = true;

      if (parsed.options.isEmpty && parsed.effects == null) {
        if (_chatHistory.length >= 2) {
          _chatHistory.removeRange(
            _chatHistory.length - 2,
            _chatHistory.length,
          );
        }
        emit(
          GameErrorRecoverable(
            errorMessage: parsed.narrative.isNotEmpty
                ? parsed.narrative
                : 'Something went wrong. Please try again.',
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            previousOptions: _lastOptions,
            pendingInput: command,
          ),
        );
        return;
      }

      StoryEffects? displayEffects = parsed.effects;
      if (parsed.effects != null) {
        final result = applyStoryEffects(_player, parsed.effects!);
        _player = result.player;
        displayEffects = result.effects;
      }

      _underMeleePressure = (displayEffects?.damage ?? 0) > 0;

      if (!_player.isAlive && displayEffects?.questFailed != true) {
        displayEffects = (displayEffects ?? StoryEffects.none).copyWith(
          questFailed: true,
        );
      }

      final turnCount = _chatHistory
          .where((m) => m.sender == MessageSender.player && m.isComplete)
          .length;
      final diff = _currentActiveQuest['difficulty'] as String? ?? 'Dangerous';
      if (turnCount >= _maxTurns(diff) &&
          displayEffects?.questCompleted != true &&
          displayEffects?.questFailed != true) {
        displayEffects = (displayEffects ?? StoryEffects.none).copyWith(
          questFailed: true,
        );
      }

      _lastOptions = parsed.options;
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
      _rollbackFailedTurn(messageCount: 2);
      emit(
        GameErrorRecoverable(
          errorMessage: 'Something went wrong. Please try again.',
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          previousOptions: _lastOptions,
          pendingInput: command,
        ),
      );
    }
  }

  /// Streams an AI response for a cast-spell command. Mirrors [_streamCommandAI]
  /// but handles spell-specific effects (mana refund on truncated response, etc.).
  Future<void> _streamSpellAI({
    required Item spell,
    required String command,
    required SkillCheckResult? skillCheck,
    required Emitter<GameState> emit,
  }) async {
    String accumulatedRaw = '';
    try {
      final turnNumber = _chatHistory
          .where((m) => m.sender == MessageSender.player && m.isComplete)
          .length;
      final difficulty =
          _currentActiveQuest['difficulty'] as String? ?? 'Dangerous';
      final expectedTurns = _expectedTurns(difficulty);
      final maxTurns = _maxTurns(difficulty);

      String aiPrompt =
          '$command\n[TURN $turnNumber of ~$expectedTurns, HARD LIMIT $maxTurns]';
      if (skillCheck != null) {
        aiPrompt +=
            '\n[SKILL CHECK: \. '
            '\n[SKILL CHECK: ${skillCheck.summary}. '
            'Do NOT override the dice.]';
      }
      aiPrompt += _trackRepeat(spell.name);

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

      if (parsed.options.isEmpty && parsed.effects == null) {
        _rollbackFailedTurn(messageCount: 2);
        _player = _player.restoreMana(spell.manaCost);
        emit(
          GameErrorRecoverable(
            errorMessage: parsed.narrative.isNotEmpty
                ? parsed.narrative
                : 'Something went wrong. Please try again.',
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
            player: _player,
            previousOptions: _lastOptions,
          ),
        );
        return;
      }

      StoryEffects? displayEffects = parsed.effects;
      if (parsed.effects != null) {
        final corrected = parsed.effects!.copyWith(manaSpent: 0);
        final result = applyStoryEffects(_player, corrected);
        _player = result.player;
        displayEffects = result.effects.copyWith(manaSpent: spell.manaCost);
      } else {
        displayEffects = StoryEffects(manaSpent: spell.manaCost);
      }

      _underMeleePressure = (parsed.effects?.damage ?? 0) > 0;

      if (!_player.isAlive && displayEffects.questFailed != true) {
        displayEffects = displayEffects.copyWith(questFailed: true);
      }

      final turnCount = _chatHistory
          .where((m) => m.sender == MessageSender.player && m.isComplete)
          .length;
      final diff = _currentActiveQuest['difficulty'] as String? ?? 'Dangerous';
      if (turnCount >= _maxTurns(diff) &&
          displayEffects.questCompleted != true &&
          displayEffects.questFailed != true) {
        displayEffects = displayEffects.copyWith(questFailed: true);
      }

      _lastOptions = parsed.options;
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
      _rollbackFailedTurn(messageCount: 2);
      _player = _player.restoreMana(spell.manaCost);
      emit(
        GameErrorRecoverable(
          errorMessage: 'Something went wrong. Please try again.',
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          previousOptions: _lastOptions,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  //  PLAYER ROLL DICE — resolves a pending dice check
  // ─────────────────────────────────────────────────────────────

  /// Called when the [_DiceRollPrompt] overlay delivers the player's roll.
  /// Reads pending context set by [_onPlayerCommand], [_onCastSpell], or
  /// [_onMakeDeathSavingThrow] and continues the appropriate flow.
  Future<void> _onPlayerRollDice(
    PlayerRollDiceEvent event,
    Emitter<GameState> emit,
  ) async {
    if (_pendingIsDeathSave) {
      // ── Death saving throw path ──
      _pendingIsDeathSave = false;
      _player = _player.makeDeathSavingThrowWithRoll(event.roll);
      _autoSavePlayer();
      if (_player.deathSaveFailures >= 3) {
        _player = _player.fullRestore();
        _autoSavePlayer();
      }
      emit(GameInitial(player: _player));
      return;
    }

    final pending = _pendingSkillCheck;
    if (pending == null) return; // Stale event — ignore.
    _pendingSkillCheck = null;

    // Resolve the skill check with the player's roll.
    final skillCheck = SkillCheckEngine.resolveCheck(pending, event.roll);

    if (_pendingSpell != null) {
      // ── Spell path ──
      final spell = _pendingSpell!;
      _pendingSpell = null;
      _pendingCommand = null;

      final command = 'I cast \. (\)';

      emit(
        GameStreamingNarrative(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          skillCheck: skillCheck,
        ),
      );

      _isProcessingAction = true;
      try {
        await _streamSpellAI(
          spell: spell,
          command: command,
          skillCheck: skillCheck,
          emit: emit,
        );
      } finally {
        _isProcessingAction = false;
      }
    } else {
      // ── Player command path ──
      final command = _pendingCommand ?? '';
      _pendingCommand = null;

      _trackRepeat(skillCheck.actionType.label);

      emit(
        GameStreamingNarrative(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
          player: _player,
          skillCheck: skillCheck,
        ),
      );

      _isProcessingAction = true;
      try {
        await _streamCommandAI(
          command: command,
          skillCheck: skillCheck,
          classifiedAction: pending.action,
          emit: emit,
        );
      } finally {
        _isProcessingAction = false;
      }
    }
  }
}
