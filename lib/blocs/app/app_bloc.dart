import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tes/models/chat_message.dart';
import 'package:uuid/uuid.dart';
import 'package:tes/blocs/app/app_event.dart';
import 'package:tes/blocs/app/app_state.dart';
import 'package:tes/services/ai_service.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final AIService _aiService;
  final Uuid _uuid = const Uuid();

  Map<String, dynamic> _currentActiveQuest =
      {}; // Internal state for the active quest
  List<ChatMessage> _chatHistory = [];

  GameBloc({required AIService aiService})
    : _aiService = aiService,
      super(GameInitial()) {
    on<StartNewQuestEvent>(_onStartNewQuest);
    on<PlayerCommandEvent>(_onPlayerCommand);
    on<GameDisposeEvent>((event, emit) {});
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Future<void> _onStartNewQuest(
    StartNewQuestEvent event,
    Emitter<GameState> emit,
  ) async {
    _currentActiveQuest = event.questDetails; // Set the new active quest
    _chatHistory = [];

    emit(GameLoading(message: 'Starting your quest...'));

    _chatHistory.add(
      ChatMessage.aiStreaming(
        id: _uuid.v4(),
        text: "",
        timestamp: DateTime.now(),
      ),
    );

    String accumulatedNarrative = "";
    try {
      // Use await for to process the stream
      await for (final chunk in _aiService.streamResponse(
        "The player accepts the quest: '${_currentActiveQuest['title']}'. Narrate their immediate surroundings and what happens next.", // Initial prompt for DM
        _currentActiveQuest,
      )) {
        accumulatedNarrative += chunk;
        _chatHistory.last.text =
            accumulatedNarrative; // Update the last AI message
        emit(
          GameStreamingNarrative(
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
          ),
        );
      }
      // Stream completed successfully
      _chatHistory.last.isComplete = true;
      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
        ),
      );
    } catch (error, stackTrace) {
      // Handle error if stream throws one
      print('Error during AI stream for StartNewQuest: $error\n$stackTrace');
      _chatHistory.last.text = 'Error: $error';
      _chatHistory.last.isComplete = true;
      emit(GameError('Failed to start quest: $error'));
    }
  }

  Future<void> _onPlayerCommand(
    PlayerCommandEvent event,
    Emitter<GameState> emit,
  ) async {
    if (_currentActiveQuest.isEmpty) {
      emit(GameError('No active quest. Please start a quest first.'));
      return;
    }

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
      ),
    );

    emit(
      GameStreamingNarrative(
        messages: List.from(_chatHistory),
        activeQuest: _currentActiveQuest,
      ),
    );

    String accumulatedNarrative = "";
    try {
      // Use await for to process the stream
      await for (final chunk in _aiService.streamResponse(
        event.command, // Player's raw command is passed to AI
        _currentActiveQuest,
      )) {
        accumulatedNarrative += chunk;
        _chatHistory.last.text =
            accumulatedNarrative; // Update the last AI message
        emit(
          GameStreamingNarrative(
            messages: List.from(_chatHistory),
            activeQuest: _currentActiveQuest,
          ),
        );
      }
      // Stream completed successfully
      _chatHistory.last.isComplete = true;
      emit(
        GameLoaded(
          messages: List.from(_chatHistory),
          activeQuest: _currentActiveQuest,
        ),
      );
    } catch (error, stackTrace) {
      // Handle error if stream throws one
      print('Error during AI stream for PlayerCommand: $error\n$stackTrace');
      _chatHistory.last.text = 'Error: $error';
      _chatHistory.last.isComplete = true;
      emit(GameError('Failed to process command: $error'));
    }
  }
}
