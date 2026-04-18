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
  //  STAT MODIFIERS
  // ─────────────────────────────────────────────────────────

  /// Returns the stat modifier for a roll using **logarithmic scaling**.
  ///
  /// `log(stat) / log(1.3)` compresses exponential stat growth into a
  /// manageable modifier range:
  ///   stat 10 → ~8,  stat 42 → ~14,  stat 100 → ~18,
  ///   stat 434 → ~23,  stat 21k → ~38.
  ///
  /// Two stats may be blended (primary weight 70%, secondary 30%).
  static int _statModifier(int primary, [int? secondary]) {
    final stat = secondary != null
        ? (primary * 0.7 + secondary * 0.3).round()
        : primary;
    if (stat <= 0) return 0;
    return (log(stat.clamp(1, 99999)) / log(1.3)).round();
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

  /// Returns the primary stat value used for the given action (for display
  /// in the skill check summary so the AI can see the player's power level).
  static int _primaryStatValue(ActionType action, Player player) {
    switch (action) {
      case ActionType.meleeAttack:
      case ActionType.throwAttack:
        return player.attack;
      case ActionType.rangedAttack:
      case ActionType.stealth:
      case ActionType.assassination:
      case ActionType.dodge:
      case ActionType.dexterity:
      case ActionType.flee:
        return player.agility;
      case ActionType.offensiveMagic:
      case ActionType.defensiveMagic:
        return player.magic;
      case ActionType.parry:
      case ActionType.endurance:
        return player.defense;
      case ActionType.social:
        return player.level * 2;
      case ActionType.none:
        return 0;
    }
  }

  /// Label for the primary stat of the given action.
  static String _primaryStatLabel(ActionType action) {
    switch (action) {
      case ActionType.meleeAttack:
      case ActionType.throwAttack:
        return 'ATK';
      case ActionType.rangedAttack:
      case ActionType.stealth:
      case ActionType.assassination:
      case ActionType.dodge:
      case ActionType.dexterity:
      case ActionType.flee:
        return 'AGI';
      case ActionType.offensiveMagic:
      case ActionType.defensiveMagic:
        return 'MAG';
      case ActionType.parry:
      case ActionType.endurance:
        return 'DEF';
      case ActionType.social:
        return 'SOC';
      case ActionType.none:
        return '';
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

  /// Penalty for repeating the same action type multiple times in a row.
  /// -2 per consecutive repeat after the first (repeat 2 = -2, 3 = -4, etc.).
  static int getRepetitionPenalty(int repeatCount) {
    if (repeatCount < 2) return 0;
    return -2 * (repeatCount - 1);
  }

  /// Penalty for attempting ranged or magic actions while under melee pressure.
  /// Enemies closing in makes it hard to aim or concentrate.
  static int getMeleePressurePenalty(
    ActionType action,
    bool underMeleePressure,
  ) {
    if (!underMeleePressure) return 0;
    if (action == ActionType.rangedAttack ||
        action == ActionType.offensiveMagic ||
        action == ActionType.defensiveMagic) {
      return -3;
    }
    return 0;
  }

  // ─────────────────────────────────────────────────────────
  //  DIFFICULTY CLASS
  // ─────────────────────────────────────────────────────────

  /// DC scales with player level: `baseDC + playerLevel ~/ 3`.
  ///
  /// This keeps checks meaningful at all levels rather than becoming
  /// trivial once stat modifiers outgrow fixed DCs.
  static int getDC(String? questDifficulty, {int playerLevel = 1}) {
    final base = switch (questDifficulty?.toLowerCase()) {
      'routine' => 6,
      'dangerous' => 10,
      'perilous' => 14,
      'suicidal' => 18,
      _ => 10,
    };
    return base + (playerLevel ~/ 3);
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
    required ActionType action,
    int repeatCount = 0,
    bool underMeleePressure = false,
    String? lastPlayerInput,
  }) {
    if (action == ActionType.none) return null;

    final roll = rollD20();
    final statMod = getStatModifier(action, player);
    final sitMod = getSituationalModifier(player, action);
    final repPenalty = getRepetitionPenalty(repeatCount);
    final pressurePenalty = getMeleePressurePenalty(action, underMeleePressure);
    final dc = getDC(questDifficulty, playerLevel: player.level);
    final total = roll + statMod + sitMod + repPenalty + pressurePenalty;

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
    // Includes the player's primary stat value so the AI can gauge power.
    final statLabel = _primaryStatLabel(action);
    final statValue = _primaryStatValue(action, player);
    final modParts = <String>[];
    if (statMod != 0) {
      modParts.add('stat ${statMod >= 0 ? "+$statMod" : "$statMod"}');
    }
    if (sitMod != 0) {
      modParts.add('situational ${sitMod >= 0 ? "+$sitMod" : "$sitMod"}');
    }
    if (repPenalty != 0) {
      modParts.add('repetition $repPenalty');
    }
    if (pressurePenalty != 0) {
      modParts.add('melee pressure $pressurePenalty');
    }
    final modStr = modParts.isEmpty ? '' : ' (${modParts.join(", ")})';

    final summary =
        '${action.label} check ($statLabel $statValue) — '
        'D20 rolled $roll$modStr = $total vs DC $dc → '
        '${outcome.label.toUpperCase()}';

    return SkillCheckResult(
      actionType: action,
      naturalRoll: roll,
      statModifier: statMod,
      situationalModifier: sitMod + repPenalty + pressurePenalty,
      dc: dc,
      outcome: outcome,
      summary: summary,
    );
  }
}
