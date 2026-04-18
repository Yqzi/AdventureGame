import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:Questborne/config/supabase_config.dart';
import 'package:Questborne/models/skill_check.dart';

/// Classifies player input into an [ActionType] using an AI edge function.
class ActionClassifierService {
  static final Uri _functionUrl = Uri.parse(
    '${SupabaseConfig.url}/functions/v1/classify-action',
  );

  /// Rich descriptions for each action type so the AI can classify accurately.
  static const _actionDescriptions = <ActionType, String>{
    ActionType.meleeAttack:
        'Melee strikes, weapon swings, punches, kicks — physical close-range combat',
    ActionType.rangedAttack:
        'Bow shots, thrown daggers, crossbow bolts — ranged weapon attacks',
    ActionType.offensiveMagic:
        'Offensive spell casting, fireballs, lightning, curses — magical attacks',
    ActionType.defensiveMagic:
        'Defensive or healing spells, wards, shields, barriers — protective magic',
    ActionType.stealth:
        'Sneaking, hiding, moving unseen, staying quiet — stealth actions',
    ActionType.assassination:
        'Silent kills, backstabs, throat slitting — lethal stealth attacks',
    ActionType.dodge:
        'Dodging, evading, rolling away — avoiding incoming attacks',
    ActionType.parry:
        'Blocking, parrying with weapon or shield — deflecting attacks',
    ActionType.social:
        'Persuasion, intimidation, deception, negotiation, bluffing, pleading, taunting — any social interaction meant to influence',
    ActionType.throwAttack: 'Throwing a weapon or object at a target',
    ActionType.dexterity:
        'Lock-picking, trap disarming, climbing, acrobatics, sleight of hand — dexterous tasks',
    ActionType.endurance:
        'Resisting poison, enduring pain, surviving harsh conditions — physical resilience',
    ActionType.flee: 'Running away, escaping, retreating from danger',
    ActionType.none:
        'No action — pure dialogue, looking around, asking questions, resting, exploring',
  };

  /// Ordered list for stable numbered mapping (excludes `none` which is 0).
  static final List<ActionType> _indexed = ActionType.values.toList();

  /// Builds a numbered map: { "0": "none: No action...", "1": "meleeAttack: ..." }
  static Map<String, String> _buildNumberedMap() {
    return {
      for (var i = 0; i < _indexed.length; i++)
        '$i':
            '${_indexed[i].name}: ${_actionDescriptions[_indexed[i]] ?? _indexed[i].label}',
    };
  }

  /// Asks the AI to classify [playerInput] and returns the matching
  /// [ActionType]. On failure, returns [ActionType.none].
  Future<ActionType> classify(String playerInput) async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        return ActionType.none;
      }

      final numberedMap = _buildNumberedMap();

      final response = await http
          .post(
            _functionUrl,
            headers: {
              'Authorization': 'Bearer ${session.accessToken}',
              'Content-Type': 'application/json',
              'apikey': SupabaseConfig.anonKey,
            },
            body: jsonEncode({
              'prompt': playerInput,
              'actionTypes': numberedMap,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        return ActionType.none;
      }

      // print(response.body);
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = decoded['actionType'] as String? ?? '0';

      // The AI returns a number — map it back to an ActionType.
      final index = int.tryParse(raw);
      if (index != null && index >= 0 && index < _indexed.length) {
        return _indexed[index];
      }

      // If it returned a key name instead of a number, try matching.
      return ActionType.values.firstWhere(
        (t) => t.name == raw,
        orElse: () => ActionType.none,
      );
    } catch (_) {
      return ActionType.none;
    }
  }
}
