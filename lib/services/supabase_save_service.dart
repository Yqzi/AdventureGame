import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tes/models/game_session.dart';
import 'package:tes/models/player.dart';

/// Persists player progress and game sessions to Supabase.
///
/// Requires two tables in your Supabase project:
///
/// ```sql
/// -- 1) Player saves
/// CREATE TABLE player_saves (
///   user_id   UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
///   player    JSONB NOT NULL,
///   updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
/// );
/// ALTER TABLE player_saves ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "Users can manage own save"
///   ON player_saves FOR ALL
///   USING (auth.uid() = user_id)
///   WITH CHECK (auth.uid() = user_id);
///
/// -- 2) Game sessions (quest progress)
/// CREATE TABLE game_sessions (
///   id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
///   user_id    UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
///   quest_id   TEXT NOT NULL,
///   session    JSONB NOT NULL,
///   updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
///   UNIQUE (user_id, quest_id)
/// );
/// ALTER TABLE game_sessions ENABLE ROW LEVEL SECURITY;
/// CREATE POLICY "Users can manage own sessions"
///   ON game_sessions FOR ALL
///   USING (auth.uid() = user_id)
///   WITH CHECK (auth.uid() = user_id);
/// ```
class SupabaseSaveService {
  // Singleton
  static final SupabaseSaveService _instance = SupabaseSaveService._();
  factory SupabaseSaveService() => _instance;
  SupabaseSaveService._();

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  bool get _hasUser => _userId != null;

  // ═══════════════════════════════════════════════════════════
  //  PLAYER SAVE
  // ═══════════════════════════════════════════════════════════

  /// Upsert the player JSON into `player_saves`.
  Future<void> savePlayer(Player player) async {
    if (!_hasUser) return;
    await _client.from('player_saves').upsert({
      'user_id': _userId,
      'player': player.toJson(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Load the player from `player_saves`. Returns `null` if no save exists.
  Future<Map<String, dynamic>?> loadPlayerJson() async {
    if (!_hasUser) return null;
    final response = await _client
        .from('player_saves')
        .select('player')
        .eq('user_id', _userId!)
        .maybeSingle();
    if (response == null) return null;
    final raw = response['player'];
    if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
    return Map<String, dynamic>.from(raw as Map);
  }

  /// Delete the player save (e.g. on account reset).
  Future<void> deletePlayerSave() async {
    if (!_hasUser) return;
    await _client.from('player_saves').delete().eq('user_id', _userId!);
  }

  // ═══════════════════════════════════════════════════════════
  //  GAME SESSIONS (quest progress)
  // ═══════════════════════════════════════════════════════════

  /// Save / update a quest session.
  Future<void> saveSession(GameSession session) async {
    if (!_hasUser) return;
    await _client.from('game_sessions').upsert({
      'user_id': _userId,
      'quest_id': session.questId,
      'session': session.toJson(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id, quest_id');
  }

  /// Load a single quest session.
  Future<GameSession?> loadSession(String questId) async {
    if (!_hasUser) return null;
    final response = await _client
        .from('game_sessions')
        .select('session')
        .eq('user_id', _userId!)
        .eq('quest_id', questId)
        .maybeSingle();
    if (response == null) return null;
    final raw = response['session'];
    final map = raw is String
        ? jsonDecode(raw) as Map<String, dynamic>
        : Map<String, dynamic>.from(raw as Map);
    return GameSession.fromJson(map);
  }

  /// Delete a quest session (e.g. after quest completes or fails).
  Future<void> deleteSession(String questId) async {
    if (!_hasUser) return;
    await _client
        .from('game_sessions')
        .delete()
        .eq('user_id', _userId!)
        .eq('quest_id', questId);
  }

  /// Check whether a quest session exists.
  Future<bool> hasSession(String questId) async {
    if (!_hasUser) return false;
    final response = await _client
        .from('game_sessions')
        .select('quest_id')
        .eq('user_id', _userId!)
        .eq('quest_id', questId)
        .maybeSingle();
    return response != null;
  }

  /// Return all quest IDs that have a saved session for the current user.
  Future<Set<String>> allActiveQuestIds() async {
    if (!_hasUser) return {};
    final response = await _client
        .from('game_sessions')
        .select('quest_id')
        .eq('user_id', _userId!);
    return (response as List).map((row) => row['quest_id'] as String).toSet();
  }
}
