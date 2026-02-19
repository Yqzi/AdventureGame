import 'package:tes/models/game_session.dart';

/// In-memory session store. Lives for the duration of the app process.
/// Swap this implementation for Supabase later — same interface.
class GameSessionRepository {
  // Singleton so all pages share the same in-memory cache.
  static final GameSessionRepository _instance = GameSessionRepository._();
  factory GameSessionRepository() => _instance;
  GameSessionRepository._();

  final Map<String, GameSession> _sessions = {};

  Future<void> saveSession(GameSession session) async {
    _sessions[session.questId] = session;
  }

  Future<GameSession?> loadSession(String questId) async {
    return _sessions[questId];
  }

  Future<void> deleteSession(String questId) async {
    _sessions.remove(questId);
  }

  Future<bool> hasSession(String questId) async {
    return _sessions.containsKey(questId);
  }

  /// Returns all quest IDs that have a saved session.
  Future<Set<String>> allActiveQuestIds() async {
    return _sessions.keys.toSet();
  }
}
