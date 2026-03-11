import 'dart:math';

import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/skill_check.dart';

/// Client-side D20 skill check engine.
///
/// Rolls a real random die, applies stat modifiers and situational bonuses,
/// compares against a difficulty class derived from quest difficulty, and
/// produces a [SkillCheckResult] that is injected into the AI prompt.
class SkillCheckEngine {
  static final Random _rng = Random();

  // ─────────────────────────────────────────────────────────
  //  ACTION CLASSIFICATION
  // ─────────────────────────────────────────────────────────

  /// Keyword → ActionType mapping. Order matters — more specific patterns
  /// are checked first (e.g. "backstab" before "stab").
  static final List<_KeywordRule> _rules = [
    // Assassination (must precede generic melee)
    _KeywordRule(ActionType.assassination, [
      'assassinate',
      'backstab',
      'slit throat',
      'kill silently',
      'silent kill',
      'sneak attack',
      'throat',
    ]),
    // Stealth
    _KeywordRule(ActionType.stealth, [
      'sneak',
      'hide',
      'stealth',
      'creep',
      'slip past',
      'skulk',
      'crouch',
      'stay hidden',
      'move quietly',
      'quietly',
      'unseen',
      'undetected',
      'silently',
      'tiptoe',
    ]),
    // Flee
    _KeywordRule(ActionType.flee, [
      'flee',
      'escape',
      'retreat',
      'run away',
      'get away',
      'bolt for',
    ]),
    // Parry / Block
    _KeywordRule(ActionType.parry, [
      'parry',
      'block',
      'deflect',
      'guard',
      'brace',
      'shield bash',
    ]),
    // Dodge
    _KeywordRule(ActionType.dodge, [
      'dodge',
      'evade',
      'sidestep',
      'roll away',
      'duck',
      'dive',
      'leap aside',
      'jump back',
    ]),
    // Ranged attack
    _KeywordRule(ActionType.rangedAttack, [
      'shoot',
      'fire arrow',
      'fire bolt',
      'loose arrow',
      'aim',
      'bow',
      'crossbow',
      'sling',
      'throw knife',
      'throw dagger',
      'hurl',
      'snipe',
    ]),
    // Throw (generic)
    _KeywordRule(ActionType.throwAttack, ['throw', 'toss', 'lob', 'fling']),
    // Offensive magic (cast without "heal"/"shield"/"protect")
    _KeywordRule(ActionType.offensiveMagic, [
      'cast',
      'spell',
      'channel',
      'conjure',
      'summon',
      'hex',
      'curse',
      'blast',
      'fireball',
      'lightning',
      'arcane',
      'unleash',
      'invoke',
    ]),
    // Defensive magic
    _KeywordRule(ActionType.defensiveMagic, [
      'heal',
      'mend',
      'restore',
      'shield spell',
      'ward',
      'barrier',
      'protect',
      'cleanse',
      'purify',
    ]),
    // Dexterity / Acrobatics
    _KeywordRule(ActionType.dexterity, [
      'pick lock',
      'lockpick',
      'disarm trap',
      'disarm',
      'climb',
      'jump',
      'leap',
      'vault',
      'balance',
      'swing across',
      'acrobat',
    ]),
    // Social
    _KeywordRule(ActionType.social, [
      'persuade',
      'convince',
      'intimidate',
      'bluff',
      'deceive',
      'lie',
      'negotiate',
      'charm',
      'bribe',
      'threaten',
      'talk',
      'reason with',
      'plead',
      'beg',
    ]),
    // Endurance
    _KeywordRule(ActionType.endurance, [
      'resist',
      'endure',
      'push through',
      'withstand',
      'survive',
      'hold on',
      'grit',
      'bear the pain',
      'tough it out',
    ]),
    // Melee attack (broadest — checked last)
    _KeywordRule(ActionType.meleeAttack, [
      'attack',
      'strike',
      'hit',
      'slash',
      'stab',
      'swing',
      'punch',
      'kick',
      'cleave',
      'smash',
      'smite',
      'hack',
      'charge',
      'lunge',
      'cut',
      'fight',
      'bash',
      'bludgeon',
    ]),
  ];

  /// Classify a player's text input into an [ActionType].
  ///
  /// Returns [ActionType.none] for non-action inputs (dialogue, looking
  /// around, simple exploration).
  static ActionType classifyAction(String input) {
    final lower = input.toLowerCase();

    // Defensive magic keywords override offensive if present.
    final hasDefensiveKeyword = [
      'heal',
      'mend',
      'restore',
      'protect',
      'cleanse',
      'purify',
      'shield spell',
      'ward',
      'barrier',
    ].any((kw) => lower.contains(kw));
    if (hasDefensiveKeyword) return ActionType.defensiveMagic;

    // Spell commands always start with "I cast" — short-circuit to magic
    // so spell names / effect text never trigger non-magic rules.
    if (lower.startsWith('i cast')) return ActionType.offensiveMagic;

    for (final rule in _rules) {
      if (rule.keywords.any((kw) => lower.contains(kw))) {
        return rule.action;
      }
    }

    return ActionType.none;
  }

  // ─────────────────────────────────────────────────────────
  //  STAT MODIFIERS
  // ─────────────────────────────────────────────────────────

  /// Returns the stat modifier for a roll. Every 5 points of the relevant
  /// stat adds +1 to the roll. Two stats may be blended (primary weight 70%,
  /// secondary 30%).
  static int _statModifier(int primary, [int? secondary]) {
    if (secondary != null) {
      final blended = (primary * 0.7 + secondary * 0.3).round();
      return blended ~/ 5;
    }
    return primary ~/ 5;
  }

  /// Pick the modifier based on action type and player stats.
  static int getStatModifier(ActionType action, Player player) {
    switch (action) {
      case ActionType.meleeAttack:
        return _statModifier(player.attack, player.agility);
      case ActionType.rangedAttack:
        return _statModifier(player.agility, player.attack);
      case ActionType.offensiveMagic:
        return _statModifier(player.magic);
      case ActionType.defensiveMagic:
        return _statModifier(player.magic);
      case ActionType.stealth:
        return _statModifier(player.agility);
      case ActionType.assassination:
        return _statModifier(player.agility, player.attack);
      case ActionType.dodge:
        return _statModifier(player.agility, player.defense);
      case ActionType.parry:
        return _statModifier(player.defense, player.attack);
      case ActionType.social:
        // Social skill scales with level (experience / worldliness).
        return _statModifier(player.level * 2);
      case ActionType.throwAttack:
        return _statModifier(player.attack, player.agility);
      case ActionType.dexterity:
        return _statModifier(player.agility);
      case ActionType.endurance:
        return _statModifier(player.defense);
      case ActionType.flee:
        return _statModifier(player.agility);
      case ActionType.none:
        return 0;
    }
  }

  // ─────────────────────────────────────────────────────────
  //  SITUATIONAL MODIFIERS
  // ─────────────────────────────────────────────────────────

  /// Calculates bonus/penalty from status effects, HP level, etc.
  static int getSituationalModifier(Player player, ActionType action) {
    int mod = 0;

    // Status effects
    if (player.hasStatus(StatusEffect.weakened)) mod -= 3;
    if (player.hasStatus(StatusEffect.poisoned)) mod -= 2;
    if (player.hasStatus(StatusEffect.frozen)) mod -= 4;
    if (player.hasStatus(StatusEffect.burning)) mod -= 2;
    if (player.hasStatus(StatusEffect.blessed)) mod += 3;
    if (player.hasStatus(StatusEffect.shielded)) {
      // Shield only helps defensive actions.
      if (action == ActionType.dodge ||
          action == ActionType.parry ||
          action == ActionType.endurance ||
          action == ActionType.defensiveMagic) {
        mod += 2;
      }
    }

    // Low HP penalty — you're injured and struggling.
    final hpPercent = player.maxHealth > 0
        ? player.currentHealth / player.maxHealth
        : 0.0;
    if (hpPercent <= 0.10) {
      mod -= 4; // Near death.
    } else if (hpPercent <= 0.25) {
      mod -= 2; // Badly wounded.
    }

    // Low MP penalty for magic actions.
    if (action == ActionType.offensiveMagic ||
        action == ActionType.defensiveMagic) {
      final mpPercent = player.maxMana > 0
          ? player.currentMana / player.maxMana
          : 0.0;
      if (mpPercent <= 0.15) {
        mod -= 2; // Magically exhausted.
      }
    }

    return mod;
  }

  // ─────────────────────────────────────────────────────────
  //  DIFFICULTY CLASS
  // ─────────────────────────────────────────────────────────

  /// Base DC by quest difficulty string.
  static int getDC(String? questDifficulty) {
    switch (questDifficulty?.toLowerCase()) {
      case 'routine':
        return 6;
      case 'dangerous':
        return 10;
      case 'perilous':
        return 14;
      case 'suicidal':
        return 18;
      default:
        return 10; // Default to dangerous.
    }
  }

  // ─────────────────────────────────────────────────────────
  //  ROLL & RESOLVE
  // ─────────────────────────────────────────────────────────

  /// Roll a D20 (1–20 inclusive).
  static int rollD20() => _rng.nextInt(20) + 1;

  /// Performs a full skill check for the given player action.
  ///
  /// Returns `null` if the action is [ActionType.none] (no check needed).
  static SkillCheckResult? performCheck({
    required String playerInput,
    required Player player,
    required String? questDifficulty,
  }) {
    final action = classifyAction(playerInput);
    if (action == ActionType.none) return null;

    final roll = rollD20();
    final statMod = getStatModifier(action, player);
    final sitMod = getSituationalModifier(player, action);
    final dc = getDC(questDifficulty);
    final total = roll + statMod + sitMod;

    // Determine outcome.
    late final CheckOutcome outcome;
    if (roll == 1) {
      outcome = CheckOutcome.criticalFailure;
    } else if (roll == 20) {
      outcome = CheckOutcome.criticalSuccess;
    } else if (total >= dc) {
      outcome = CheckOutcome.success;
    } else if (total >= dc - 3) {
      outcome = CheckOutcome.partialSuccess;
    } else {
      outcome = CheckOutcome.failure;
    }

    // Build human-readable summary for the AI prompt.
    final modParts = <String>[];
    if (statMod != 0) {
      modParts.add('stat ${statMod >= 0 ? "+$statMod" : "$statMod"}');
    }
    if (sitMod != 0) {
      modParts.add('situational ${sitMod >= 0 ? "+$sitMod" : "$sitMod"}');
    }
    final modStr = modParts.isEmpty ? '' : ' (${modParts.join(", ")})';

    final summary =
        '${action.label} check — '
        'D20 rolled $roll$modStr = $total vs DC $dc → '
        '${outcome.label.toUpperCase()}';

    return SkillCheckResult(
      actionType: action,
      naturalRoll: roll,
      statModifier: statMod,
      situationalModifier: sitMod,
      dc: dc,
      outcome: outcome,
      summary: summary,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  INTERNAL HELPERS
// ─────────────────────────────────────────────────────────────

class _KeywordRule {
  final ActionType action;
  final List<String> keywords;
  const _KeywordRule(this.action, this.keywords);
}
