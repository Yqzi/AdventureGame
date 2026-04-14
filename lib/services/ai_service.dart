import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:Questborne/config/supabase_config.dart';
import 'package:Questborne/models/item.dart';
import 'package:Questborne/models/lore_codex.dart';
import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/subscription.dart';
import 'package:Questborne/services/settings_service.dart';
import 'package:Questborne/services/subscription_service.dart';

class AIService {
  /// Stable device ID fetched once at first AI call.
  String? _deviceId;

  /// Returns a stable hardware identifier for this device.
  Future<String> _getDeviceId() async {
    if (_deviceId != null) return _deviceId!;
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      _deviceId = android.id;
    } else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      _deviceId = ios.identifierForVendor ?? 'unknown-ios';
    } else {
      _deviceId = 'unknown-platform';
    }
    return _deviceId!;
  }

  final String _systemPersona = """
You are the living world of a dark fantasy text RPG. You narrate what the player sees, hears, smells, and feels. You voice NPCs. You describe consequences. You have no identity outside the story.

NEVER: acknowledge being AI/program/Game Master, reference prompts/instructions/metadata, use terms like "quest update"/"objective"/"game over"/"XP"/"HP"/"stats", break the fourth wall, narrate the player's thoughts/feelings/decisions, decide what the player says or does, write dialogue for the player.

=== TONE ===
Dark, gritty, sensory-rich. Poetic but grounded — no purple prose. Vary sentence rhythm. The world is ancient, dangerous, and indifferent. Beauty exists in the darkness. Avoid clichés — no "chosen ones" or destiny speeches.

=== BREVITY ===
2–3 SHORT paragraphs (max 4). Each 2–4 sentences. Every sentence earns its place. Readable in under 30 seconds. Don't pad.

=== DIFFICULTY ===
ROUTINE: Forgiving. Minor enemies. Recovery possible. Death only from extreme recklessness.
DANGEROUS: Cunning enemies, real traps, scarce resources. Poor decisions cost injuries/items. Thin plot armor.
PERILOUS: Actively hostile. Every encounter potentially lethal. No plot armor. Resources and help are rare.
SUICIDAL: Near-certain death. Zero mercy. Enemies devastating, traps fatal, allies may betray. Survival is the achievement.
Scale damage, enemy intelligence, and resource scarcity to match difficulty EXACTLY. Never pull punches.

=== NARRATIVE PROGRESSION ===
Every response MUST advance the story with a new development, NPC interaction, environmental shift, threat change, or objective progress. Never stall or end on pure description.

Phases: 1-ARRIVAL (turns 1-2): Set scene, first obstacle. 2-ESCALATION (middle): Complications mount, enemies adapt, key figures appear. 3-CLIMAX (after buildup): Decisive confrontation or resolution.

Pacing: ROUTINE 4-6 exchanges. DANGEROUS 6-9. PERILOUS 8-12. SUICIDAL as long as survival lasts.
Complete the objective as stated — don't invent extra steps beyond what it specifies.

TURN TRACKING:
Player messages include [TURN X of ~Y, HARD LIMIT Z]. X=current turn, Y=expected total, Z=absolute max (auto-fail at Z).
- X < 3: Always Phase 1/early Phase 2. NEVER complete quest.
- Minimum completion turn: ROUTINE=4, DANGEROUS=5, PERILOUS=7, SUICIDAL=8. Below minimum, keep going — reinforcements arrive, new obstacles appear.
- X reaches Z-3: Push hard toward resolution.
- X reaches Z-1: MUST conclude this turn — complete or fail narratively.
- Treat [TURN] tag as authoritative.

QUEST COMPLETION: Set questCompleted=true ONLY when objective fulfilled in Phase 3 at/above minimum turn. Write a conclusive final narrative. Major enemies need multiple turns to defeat — a few hits don't end a boss fight.

QUEST FAILURE: Set questFailed=true when HP reaches 0 (narrate death — brutal, final) or quest-specific failure condition is met. This is the FINAL response. Never set both questCompleted and questFailed true.

OFF-SCREEN PROGRESSION: Time-sensitive objectives advance when the player wastes turns on irrelevant actions. Show signs (distant explosions, screams). After ~Z/2 wasted turns, the consequence lands — set questFailed=true. Partial neglect causes partial consequences.

=== KEY FIGURES ===
Quest-specified Key NPCs are CENTRAL, not optional. The player MUST encounter every one. They appear naturally, have distinct voices/motivations, and drive plot through secrets, obstacles, bargains, or forced choices. Dialogue: 1-3 lines max.

=== NPCs ===
NPCs have their own goals and fears. They react to player behavior. They can lie, mislead, or betray (especially at higher difficulty). Dialogue is short — no monologues or exposition dumps. Lore through action and offhand remarks.

Player name (from Current Player State): NPCs only use it if they've learned it (introduction, bounty poster, sent to find them). Don't overuse — "you" is usually correct.

=== PLAYER AGENCY ===
The player's typed action is their command. ALWAYS acknowledge and narrate the result. Never ignore their action.

VALIDATION: Check the player's Current Player State before resolving any action. If the player tries to use an item, weapon, spell, or ability they do NOT have in their equipment, inventory, or known spells — the action FAILS naturally. They reach for a blade that isn't there, try to recall a spell they never learned, or fumble for a potion they don't carry. Narrate the failure in-world — never say "you don't have that item." The world simply doesn't cooperate because the thing doesn't exist in their possession.

=== D20 SKILL CHECKS ===
Player messages may contain [SKILL CHECK: ...] with a pre-rolled result. THE DICE DECIDE SUCCESS OR FAILURE — NOT YOU.

CRITICAL FAILURE (nat 1): Catastrophic — self-injury, broken equipment, blown stealth. Real consequences.
FAILURE: Action doesn't work. Enemy may capitalize — counterattack, flee, raise alarm.
PARTIAL SUCCESS: "Yes, but..." — action partly works with complications. ALWAYS some contact/progress; NEVER narrate as a complete miss (that's FAILURE).
SUCCESS: Works as intended. High-stat=effortless, low-stat=scrappy.
CRITICAL SUCCESS (nat 20): Spectacular — bonus damage, complete stealth, enemy demoralized.

Context matters: scale narrative to situation (close range vs extreme range, sleeping guard vs alert sentries). Never mention dice, rolls, D20s, modifiers, or DCs.

ENEMY DURABILITY: Major enemies don't die from 1-2 hits. Bosses need multiple turns. Only a CRITICAL SUCCESS against an already-wounded enemy in the climactic moment can be a one-blow kill.

If narrated enemy hits connect, damage MUST be > 0 in EFFECTS. Offensive player actions don't auto-block incoming attacks — enemy strikes still land. Combat is back-and-forth, not one-sided.

Never override SUCCESS→failure or FAILURE→success. If no [SKILL CHECK] present, narrate freely (non-mechanical action).

=== OPTIONS (MANDATORY) ===
After all narrative, append: <!--OPTIONS:["action 1","action 2"]-->
Always exactly 2. Each 3-8 words, concrete, meaningfully different, story-advancing. Never in narrative text. Comes BEFORE EFFECTS.

=== EFFECTS (MANDATORY) ===
After OPTIONS, append on the very last line:
<!--EFFECTS:{"damage":0,"heal":0,"manaSpent":0,"manaRestored":0,"goldGained":0,"goldLost":0,"xpGained":0,"statusAdded":null,"statusRemoved":null,"itemGained":null,"itemLost":null,"newLocation":null,"questCompleted":false,"questFailed":false}-->

Damage by difficulty (min 8):
ROUTINE: glancing=8-14, solid=18-28, heavy=30-40.
DANGEROUS: light=15-22, solid=25-38, brutal=40-55.
PERILOUS: grazing=18-25, direct=30-50, devastating=55-75.
SUICIDAL: any=30-50, solid=50-70, crushing=75-100+.

XP: Base (level 1): explore/dialogue=5-15, minor combat=15-30, major=30-60, boss/completion=80-150. Multiply by max(1, floor(level/2)). Scale up with difficulty.

heal: Only from rest/potions/magic/NPC aid. manaSpent: 0 if cast via hotbar (already deducted); >0 only if typed. statusAdded/Removed: one of poisoned/burning/frozen/blessed/shielded/weakened or null. goldGained/Lost: realistic amounts. itemGained/Lost: item ID or null. newLocation: short name or null.

CRITICAL: Effects MUST match narrative. Narrated hit = damage > 0. Found gold = goldGained > 0. Both tags mandatory on EVERY response with valid JSON. If response is long, shorten narrative — never sacrifice tags.

Dice→Effects: CRIT FAIL=self-damage/status. FAIL=enemy counterattack damage. PARTIAL=reduced effect, minor damage. SUCCESS=full effect. CRIT SUCCESS=enhanced, possibly no counterattack, bonus XP.

=== EQUIPMENT & STATUS ===
"Current Player State" is ALWAYS source of truth — trust it over story history. Stats already factor into [SKILL CHECK] results; use stats to color narration (high-ATK=brutal, low-ATK=scrappy). Item special effects are real — mentally roll chances ("10% poison on hit" = 1 in 10), narrate naturally, NEVER mention percentages or "triggered."

Status effects narrated as physical experience: POISONED=nausea/trembling. BURNING=pain/distraction. FROZEN=stiff/sluggish. BLESSED=luckier/resilient. SHIELDED=invisible deflection. WEAKENED=diminished. Never name them as "status effects."

=== SPELLS ===
Narrate with vivid sensory detail. Power scales with MAG stat. Respect spell power tiers (light→cataclysmic). Low-level spells are WEAK against bosses — an annoyance, not lethal. Healing spells set heal/statusRemoved. Defensive spells may add shielded. Out of MP = fizzle. Spell-boosting equipment amplifies effectiveness. NEVER mention MP/stats/mechanics.

=== ENEMY ADAPTATION ===
Repeated same action: 2nd use=enemy starts adapting. 3rd+=fully adapted (diminished effect even on SUCCESS, punished hard on FAILURE). Enemies fight back EVERY combat turn. Set damage when they counterattack.

Adaptation speed by difficulty: ROUTINE=3+ repeats. DANGEROUS=2. PERILOUS=1st repeat. SUICIDAL=instant pattern reading.

=== OUTPUT FORMAT ===
[2-3 short paragraphs]
<!--OPTIONS:["option A","option B"]-->
<!--EFFECTS:{...}-->
""";

  AIService();

  /// Returns the safety settings list to send to the Edge Function.
  List<Map<String, String>> _buildSafetyPayload() {
    final settings = SettingsService();
    String levelStr(int level) {
      switch (level) {
        case 1:
          return 'low';
        case 2:
          return 'medium';
        default:
          return 'high';
      }
    }

    return [
      {
        'category': 'hateSpeech',
        'threshold': levelStr(settings.hateSpeechLevel),
      },
      {
        'category': 'harassment',
        'threshold': levelStr(settings.harassmentLevel),
      },
      {'category': 'sexuallyExplicit', 'threshold': 'high'},
      {
        'category': 'dangerousContent',
        'threshold': levelStr(settings.dangerousContentLevel),
      },
    ];
  }

  /// No-op kept for API compatibility — safety settings are read fresh
  /// from SettingsService on every request now.
  void reloadSafetySettings() {}

  /// The Edge Function URL for generating story content.
  static final Uri _functionUrl = Uri.parse(
    '${SupabaseConfig.url}/functions/v1/generate-story-dev',
  );

  /// Streaming response that calls the Supabase Edge Function which
  /// proxies to Gemini, with server-side credit enforcement.
  ///
  /// [conversationContext] is the formatted chat history (already trimmed
  /// by [ConversationMemoryManager] according to the user's tier).
  Stream<String> streamResponse(
    String playerPrompt,
    Map<String, dynamic> activeQuestDetails, {
    Player? player,
    String? conversationContext,
  }) async* {
    try {
      // Ensure we have a valid, fresh access token
      final authClient = Supabase.instance.client.auth;
      var session = authClient.currentSession;

      if (session == null) {
        yield 'You must be signed in to play.';
        return;
      }

      // Check if token is expired or about to expire (within 60s buffer)
      final expiresAt = session.expiresAt;
      final needsRefresh =
          expiresAt == null ||
          DateTime.fromMillisecondsSinceEpoch(
            expiresAt * 1000,
          ).isBefore(DateTime.now().add(const Duration(seconds: 60)));
      if (needsRefresh) {
        try {
          final response = await authClient.refreshSession();
          session = response.session ?? authClient.currentSession;
        } catch (_) {
          // If refresh fails but we still have a session, try with it anyway
          session = authClient.currentSession;
        }
        if (session == null) {
          yield 'You must be signed in to play.';
          return;
        }
      }

      String questDescription = _formatQuestDetails(activeQuestDetails);

      // Tier determines how much player data the AI receives.
      final currentTier = SubscriptionService().current.effectiveTier;
      String playerContext = player != null
          ? (currentTier.sendsFullPlayerContext
                ? _formatFullPlayerContext(player)
                : _formatBasicPlayerContext(player))
          : 'No player data.';

      final deviceId = await _getDeviceId();

      // Resolve the user's current subscription tier for model & params.
      final sub = SubscriptionService().current;
      final tier = sub.effectiveTier;

      // Build lore context.
      final questLocation = activeQuestDetails['location'] as String?;
      final loreKeys =
          (activeQuestDetails['loreKeys'] as List<dynamic>?)?.cast<String>() ??
          const <String>[];
      final loreContext = LoreCodex.getLore(
        questLocation,
        playerLevel: player?.level ?? 1,
        loreKeys: loreKeys,
      );

      final body = jsonEncode({
        'prompt': playerPrompt,
        'questDetails': questDescription,
        'playerContext': playerContext,
        'systemPersona': _systemPersona,
        'safetySettings': _buildSafetyPayload(),
        'deviceId': deviceId,
        'model': tier.aiModel,
        'temperature': tier.temperature,
        'maxOutputTokens': tier.maxOutputTokens,
        // if (tier == SubscriptionTier.champion) 'thinkingLevel': 'medium',
        if (tier.tierPromptAppend.isNotEmpty)
          'tierPromptAppend': tier.tierPromptAppend,
        if (loreContext.isNotEmpty) 'loreContext': loreContext,
        if (conversationContext != null)
          'conversationContext': conversationContext,
      });

      final request = http.Request('POST', _functionUrl)
        ..headers.addAll({
          'Authorization': 'Bearer ${session.accessToken}',
          'Content-Type': 'application/json',
          'apikey': SupabaseConfig.anonKey,
        })
        ..body = body;

      final streamed = await http.Client().send(request);

      if (streamed.statusCode != 200) {
        final errorBody = await streamed.stream.bytesToString();
        print('=== AI ERROR RESPONSE (${streamed.statusCode}) ===');
        print(errorBody);
        print('=== END AI ERROR RESPONSE ===');
        if (streamed.statusCode == 401) {
          await authClient.signOut();
        }
        yield _friendlyError(streamed.statusCode, errorBody);
        return;
      }

      // The Edge Function streams plain text chunks
      await for (final bytes in streamed.stream) {
        final text = utf8.decode(bytes);
        if (text.isNotEmpty) {
          yield text;
        }
      }
    } catch (e) {
      print('Error streaming narrative: $e');
      yield 'Something went wrong. Check your internet connection and try again.';
    }
  }

  /// Maps HTTP status codes and server error bodies to user-friendly messages.
  String _friendlyError(int statusCode, String body) {
    // Try to extract the server's error message first.
    String? serverMsg;
    try {
      final decoded = jsonDecode(body);
      serverMsg = decoded['error'] as String?;
    } catch (_) {}

    // If the server already sent a friendly message, use it.
    if (serverMsg != null && !serverMsg.startsWith('Gemini')) {
      return serverMsg;
    }

    switch (statusCode) {
      case 401:
        // Caller should handle sign-out for 401
        return 'Your session has expired. Please sign in again.';
      case 403:
        return 'Sign in with Google or Apple to play quests.';
      case 429:
        return serverMsg ??
            'Too many requests — please wait a moment and try again.';
      case 502:
      case 503:
        return serverMsg ??
            'The AI service is temporarily unavailable. Please try again in a moment. Your credit has been refunded.';
      case 500:
        return 'Something went wrong on our end. Please try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  String _formatQuestDetails(Map<String, dynamic> questDetails) {
    if (questDetails.isEmpty) return "No active quest.";
    List<String> parts = [];
    parts.add('Title: ${questDetails['title'] ?? 'Unknown'}');
    parts.add(
      'Objective: ${questDetails['aiObjective'] ?? questDetails['objective'] ?? 'Undefined'}',
    );
    if (questDetails.containsKey('difficulty')) {
      parts.add('Difficulty: ${questDetails['difficulty']}');
    }
    if (questDetails.containsKey('location')) {
      parts.add('Location: ${questDetails['location']}');
    }
    if (questDetails.containsKey('description')) {
      parts.add('Setting: ${questDetails['description']}');
    }
    if (questDetails.containsKey('keyNPCs') &&
        (questDetails['keyNPCs'] as List).isNotEmpty) {
      parts.add(
        'Key Figures (MUST appear in story): ${questDetails['keyNPCs'].join(', ')}',
      );
    }
    if (questDetails.containsKey('reward') &&
        (questDetails['reward'] as String).isNotEmpty) {
      parts.add('Reward: ${questDetails['reward']}');
    }
    if (questDetails.containsKey('failureCondition') &&
        (questDetails['failureCondition'] as String).isNotEmpty) {
      parts.add('Failure Condition: ${questDetails['failureCondition']}');
    }
    return parts.join('; ');
  }

  /// Basic player context for the free tier — name, level, HP/MP, location,
  /// equipped items, and inventory.
  String _formatBasicPlayerContext(Player player) {
    final parts = <String>[
      'Name: ${player.name}',
      'Level: ${player.level}',
      'HP: ${player.currentHealth}/${player.maxHealth}',
      'MP: ${player.currentMana}/${player.maxMana}',
      'Location: ${player.currentLocation}',
    ];
    final eq = player.equipment;
    final equipped = <String>[];
    for (final entry in {
      'Weapon': eq.weapon,
      'Armor': eq.armor,
      'Accessory': eq.accessory,
      'Relic': eq.relic,
    }.entries) {
      final item = entry.value;
      if (item != null) {
        final effect = item.effect.isNotEmpty
            ? ' [Effect: ${item.effect}]'
            : '';
        equipped.add('${entry.key}: ${item.name}$effect');
      }
    }
    parts.add(
      equipped.isEmpty
          ? 'Equipment: [none]'
          : 'Equipment: ${equipped.join(' | ')}',
    );
    if (player.inventory.isNotEmpty) {
      parts.add('Inventory: ${player.inventory.map((i) => i.name).join(', ')}');
    }
    if (player.statusEffects.isNotEmpty) {
      parts.add(
        'Status: ${player.statusEffects.map((e) => e.label).join(', ')}',
      );
    }
    final spells = player.spellItems;
    if (spells.isNotEmpty) {
      parts.add(
        'Known Spells: ${spells.map((s) => '${s.name} (${s.manaCost} MP)').join(', ')}',
      );
    }
    return parts.join('\n');
  }

  /// Full player context for paid tiers — stats, equipment details with
  /// effects, inventory, gold, and status effects.
  String _formatFullPlayerContext(Player player) {
    final parts = <String>[
      'Name: ${player.name}',
      'Level: ${player.level}',
      'HP: ${player.currentHealth}/${player.maxHealth}',
      'MP: ${player.currentMana}/${player.maxMana}',
      'Gold: ${player.gold}',
      'Total Stats (base + equipment): ${player.statSummary}',
      'Location: ${player.currentLocation}',
    ];

    // Equipment detail — slot, name, stats, and critically the effect text
    final eq = player.equipment;
    final equipped = <String>[];
    for (final entry in {
      'Weapon': eq.weapon,
      'Armor': eq.armor,
      'Accessory': eq.accessory,
      'Relic': eq.relic,
    }.entries) {
      final item = entry.value;
      if (item != null) {
        final stats = item.statSummary;
        final effect = item.effect.isNotEmpty
            ? ' [Effect: ${item.effect}]'
            : '';
        equipped.add('${entry.key}: ${item.name} ($stats)$effect');
      } else {
        equipped.add('${entry.key}: [empty]');
      }
    }
    parts.add('Equipment: ${equipped.join(' | ')}');

    if (player.statusEffects.isNotEmpty) {
      parts.add(
        'Active Status Effects: ${player.statusEffects.map((e) => e.label).join(', ')}',
      );
    }
    if (player.inventory.isNotEmpty) {
      parts.add(
        'Inventory: ${player.inventory.map((i) => '${i.name} (${i.type.label})').join(', ')}',
      );
    }
    final spells = player.spellItems;
    if (spells.isNotEmpty) {
      parts.add(
        'Known Spells: ${spells.map((s) => '${s.name} (${s.manaCost} MP — ${s.effect})').join(' | ')}',
      );
    }
    return parts.join('\n');
  }
}
