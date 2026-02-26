import 'package:Questborne/models/chat_message.dart';
import 'package:Questborne/models/subscription.dart';

/// Manages conversation context sent to the AI based on the user's
/// subscription tier.
///
/// **Free tier**: keeps the last 3 exchanges fully; older ones are
///  collapsed into a rolling summary paragraph.
///
/// **Adventurer**: keeps 8 exchanges fully; older summarised.
///
/// **Champion**: full memory — nothing is ever summarised.
class ConversationMemoryManager {
  ConversationMemoryManager._();
  static final ConversationMemoryManager _instance =
      ConversationMemoryManager._();
  factory ConversationMemoryManager() => _instance;

  /// Rolling summary of the parts of the story that have been trimmed.
  String _rollingStummary = '';

  /// The last raw conversation that was submitted so we know what's new.
  int _lastSummarisedIndex = 0;

  /// Reset when a new quest starts.
  void reset() {
    _rollingStummary = '';
    _lastSummarisedIndex = 0;
  }

  /// Returns the conversation history formatted for the AI prompt,
  /// respecting the [memoryWindow] from the user's tier.
  ///
  /// Each "exchange" is a player message + AI response pair (2 messages).
  /// - **Free tier**: older messages beyond the window are simply dropped.
  /// - **Adventurer tier**: older messages are folded into [_rollingStummary].
  /// - **Champion tier**: full history — nothing dropped or summarised.
  String buildContextForAI(
    List<ChatMessage> fullHistory,
    SubscriptionTier tier,
  ) {
    final window = tier.memoryWindow;

    // Unlimited memory — send everything.
    if (window == null) {
      return _formatMessages(fullHistory);
    }

    // An "exchange" = 1 player msg + 1 AI msg = 2 messages.
    final windowMsgCount = window * 2;

    if (fullHistory.length <= windowMsgCount) {
      // Nothing to trim yet.
      return _formatMessages(fullHistory);
    }

    // ── Split history into old (to trim) and recent (to keep) ──
    final cutoff = fullHistory.length - windowMsgCount;
    final recentMessages = fullHistory.sublist(cutoff);

    // Free tier: just drop older messages entirely — no summary.
    if (!tier.summarizesOlderTurns) {
      return _formatMessages(recentMessages);
    }

    // Adventurer tier: summarise older messages into a rolling paragraph.
    final oldMessages = fullHistory.sublist(_lastSummarisedIndex, cutoff);

    if (oldMessages.isNotEmpty) {
      final summaryChunk = _summariseLocalChunk(oldMessages);
      if (_rollingStummary.isEmpty) {
        _rollingStummary = summaryChunk;
      } else {
        _rollingStummary = '$_rollingStummary $summaryChunk';
      }
      _lastSummarisedIndex = cutoff;
    }

    // Assemble the final context string.
    final buffer = StringBuffer();
    if (_rollingStummary.isNotEmpty) {
      buffer.writeln('[STORY SO FAR (summarised)]: $_rollingStummary');
      buffer.writeln();
    }
    buffer.write(_formatMessages(recentMessages));
    return buffer.toString();
  }

  // ── Helpers ──────────────────────────────────────────────

  /// Quick local summarisation — no AI call, just condenses the raw text to
  /// key beats. This keeps latency at zero and avoids extra API costs.
  ///
  /// A future improvement could call a cheap model to produce better
  /// summaries, but this is perfectly adequate for context windows.
  String _summariseLocalChunk(List<ChatMessage> messages) {
    final buf = StringBuffer();
    for (final msg in messages) {
      if (msg.sender == MessageSender.player) {
        // Keep the player's action as-is (they're short).
        buf.write('Player: ${msg.text.trim()} → ');
      } else {
        // Truncate AI responses to the first ~120 chars to capture the beat.
        final trimmed = msg.text.trim();
        final snippet = trimmed.length > 120
            ? '${trimmed.substring(0, 120)}…'
            : trimmed;
        buf.write(snippet);
        buf.write(' | ');
      }
    }
    return buf.toString().trimRight().replaceAll(RegExp(r'\s*\|\s*$'), '');
  }

  String _formatMessages(List<ChatMessage> messages) {
    return messages
        .map((m) {
          final role = m.sender == MessageSender.player ? 'Player' : 'Narrator';
          return '$role: ${m.text.trim()}';
        })
        .join('\n\n');
  }
}
