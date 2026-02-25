import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Questborne/models/game_session.dart';
import 'package:Questborne/services/supabase_save_service.dart';

/// Session store that persists to Supabase for authenticated users and
/// falls back to an in-memory cache for guests / offline.
class GameSessionRepository {
  // Singleton so all pages share the same instance.
  static final GameSessionRepository _instance = GameSessionRepository._();
  factory GameSessionRepository() => _instance;
  GameSessionRepository._();

  final SupabaseSaveService _remote = SupabaseSaveService();

  /// In-memory cache — used as the source of truth for guests and also
  /// acts as a write-through cache for authenticated users.
  final Map<String, GameSession> _sessions = {};

  bool get _useRemote => Supabase.instance.client.auth.currentUser != null;

  Future<void> saveSession(GameSession session) async {
    _sessions[session.questId] = session;
    if (_useRemote) {
      try {
        await _remote.saveSession(session);
      } catch (_) {
        // Silently fall back to local-only if the network call fails.
      }
    }
  }

  Future<GameSession?> loadSession(String questId) async {
    // Try local cache first.
    if (_sessions.containsKey(questId)) return _sessions[questId];
    // Then try remote.
    if (_useRemote) {
      try {
        final session = await _remote.loadSession(questId);
        if (session != null) _sessions[questId] = session;
        return session;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> deleteSession(String questId) async {
    _sessions.remove(questId);
    if (_useRemote) {
      try {
        await _remote.deleteSession(questId);
      } catch (_) {}
    }
  }

  Future<bool> hasSession(String questId) async {
    if (_sessions.containsKey(questId)) return true;
    if (_useRemote) {
      try {
        return await _remote.hasSession(questId);
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  /// Returns all quest IDs that have a saved session.
  Future<Set<String>> allActiveQuestIds() async {
    if (_useRemote) {
      try {
        final remote = await _remote.allActiveQuestIds();
        return {..._sessions.keys, ...remote};
      } catch (_) {}
    }
    return _sessions.keys.toSet();
  }

  /// Populate local cache from Supabase after login.
  Future<void> syncFromRemote() async {
    if (!_useRemote) return;
    try {
      final ids = await _remote.allActiveQuestIds();
      for (final id in ids) {
        final session = await _remote.loadSession(id);
        if (session != null) _sessions[id] = session;
      }
    } catch (_) {}
  }

  /// Clear the in-memory cache (e.g. on account deletion / sign out).
  void clearLocal() => _sessions.clear();
}
