import 'dart:convert';

/// A snapshot of an in-progress quest that can be saved and resumed.
class GameSession {
  final String questId;

  /// Each entry is { 'sender': 'player'|'ai', 'text': '...' }
  final List<Map<String, String>> conversationHistory;

  /// The quest details map so we can re-launch the quest identically.
  final Map<String, dynamic> questDetails;

  /// The last set of options the AI presented, so resume shows them again.
  final List<String> lastOptions;

  /// Serialised player state (HP, mana, gold, inventory, etc.).
  final Map<String, dynamic>? playerState;

  final DateTime savedAt;

  const GameSession({
    required this.questId,
    required this.conversationHistory,
    required this.questDetails,
    this.lastOptions = const [],
    this.playerState,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'questId': questId,
    'conversationHistory': conversationHistory,
    'questDetails': questDetails,
    'lastOptions': lastOptions,
    'playerState': playerState,
    'savedAt': savedAt.toIso8601String(),
  };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
    questId: json['questId'] as String,
    conversationHistory: (json['conversationHistory'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList(),
    questDetails: Map<String, dynamic>.from(json['questDetails'] as Map),
    lastOptions:
        (json['lastOptions'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
    playerState: json['playerState'] != null
        ? Map<String, dynamic>.from(json['playerState'] as Map)
        : null,
    savedAt: DateTime.parse(json['savedAt'] as String),
  );

  String encode() => jsonEncode(toJson());

  factory GameSession.decode(String source) =>
      GameSession.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
