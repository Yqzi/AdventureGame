import 'dart:math';

import 'package:Questborne/models/ability_scores.dart';
import 'package:Questborne/models/character_class.dart';
import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/skill_check.dart';

/// Client-side D20 skill check engine implementing D&D 5e rules.
///
/// Each player action maps to a D&D ability score. The roll is:
///   D20 + ability modifier + (proficiency bonus if proficient).
/// Natural 1 = critical failure. Natural 20 = critical success.
/// Advantage/disadvantage: roll 2d20, take highest/lowest.
class SkillCheckEngine {
  static final Random _rng = Random();

  // ──────────────────────────────────────────────────────────
  //  ABILITY SCORE MAPPING
  // ──────────────────────────────────────────────────────────

  /// Returns the primary D&D ability type for the given action.
  static AbilityType _primaryAbility(ActionType action, Player player) {
    switch (action) {
      case ActionType.meleeAttack:
        // Rogues/Monks/Rangers use DEX for finesse/unarmed; others use STR.
        if (player.dndClass == DndClass.rogue ||
            player.dndClass == DndClass.monk ||
            player.dndClass == DndClass.ranger) {
          return AbilityType.dexterity;
        }
        return AbilityType.strength;
      case ActionType.rangedAttack:
        return AbilityType.dexterity;
      case ActionType.offensiveMagic:
        return player.dndClass?.data.spellcastingAbility ??
            AbilityType.intelligence;
      case ActionType.defensiveMagic:
        return player.dndClass?.data.spellcastingAbility ?? AbilityType.wisdom;
      case ActionType.stealth:
        return AbilityType.dexterity;
      case ActionType.assassination:
        return AbilityType.dexterity;
      case ActionType.dodge:
        return AbilityType.dexterity;
      case ActionType.parry:
        // Parry is a STR contest in D&D (opposing strength).
        return AbilityType.strength;
      case ActionType.social:
        return AbilityType.charisma;
      case ActionType.throwAttack:
        return AbilityType.strength;
      case ActionType.dexterity:
        return AbilityType.dexterity;
      case ActionType.endurance:
        return AbilityType.constitution;
      case ActionType.flee:
        return AbilityType.dexterity;
      case ActionType.none:
        return AbilityType.dexterity;
    }
  }

  /// The D&D skill or save name for the action (for the summary string).
  static String _skillName(ActionType action, Player player) {
    switch (action) {
      case ActionType.meleeAttack:
        return player.dndClass == DndClass.rogue ||
                player.dndClass == DndClass.monk
            ? 'DEX Attack'
            : 'STR Attack';
      case ActionType.rangedAttack:
        return 'DEX Attack';
      case ActionType.offensiveMagic:
        return 'Spell Attack';
      case ActionType.defensiveMagic:
        return 'Spell DC';
      case ActionType.stealth:
        return 'Stealth (DEX)';
      case ActionType.assassination:
        return 'Assassination (DEX)';
      case ActionType.dodge:
        return 'DEX Save';
      case ActionType.parry:
        return 'Athletics (STR)';
      case ActionType.social:
        return 'Persuasion (CHA)';
      case ActionType.throwAttack:
        return 'Athletics (STR)';
      case ActionType.dexterity:
        return 'Acrobatics (DEX)';
      case ActionType.endurance:
        return 'CON Save';
      case ActionType.flee:
        return 'Acrobatics (DEX)';
      case ActionType.none:
        return '';
    }
  }

  // ──────────────────────────────────────────────────────────
  //  PROFICIENCY CHECK
  // ──────────────────────────────────────────────────────────

  /// Returns true if the player has proficiency for this action type.
  static bool _hasProficiency(ActionType action, Player player) {
    final classData = player.dndClass?.data;
    if (classData == null) return false;

    switch (action) {
      // Attack rolls: always proficient (you're using your weapon).
      case ActionType.meleeAttack:
      case ActionType.rangedAttack:
      case ActionType.throwAttack:
      case ActionType.offensiveMagic:
      case ActionType.defensiveMagic:
        return true;
      // Saving throws: check class save proficiencies.
      case ActionType.dodge:
        return classData.savingThrowProficiencies.contains(
          AbilityType.dexterity,
        );
      case ActionType.endurance:
        return classData.savingThrowProficiencies.contains(
          AbilityType.constitution,
        );
      // Skills: check player skill proficiency list.
      case ActionType.stealth:
      case ActionType.assassination:
      case ActionType.flee:
        return player.skillProficiencies.any(
          (s) =>
              s.toLowerCase().contains('stealth') ||
              s.toLowerCase().contains('acrobatics'),
        );
      case ActionType.parry:
        return player.skillProficiencies.any(
          (s) => s.toLowerCase().contains('athletics'),
        );
      case ActionType.social:
        return player.skillProficiencies.any(
          (s) =>
              s.toLowerCase().contains('persuasion') ||
              s.toLowerCase().contains('intimidation') ||
              s.toLowerCase().contains('deception'),
        );
      case ActionType.dexterity:
        return player.skillProficiencies.any(
          (s) => s.toLowerCase().contains('acrobatics'),
        );
      case ActionType.none:
        return false;
    }
  }

  // ──────────────────────────────────────────────────────────
  //  TOTAL MODIFIER
  // ──────────────────────────────────────────────────────────

  /// Returns the total bonus to add to the D20 roll (ability mod + proficiency).
  static int getStatModifier(ActionType action, Player player) {
    if (action == ActionType.none) return 0;
    final ability = _primaryAbility(action, player);
    final abilityMod = player.abilityScores.getMod(ability);
    final profBonus = _hasProficiency(action, player)
        ? player.proficiencyBonus
        : 0;
    return abilityMod + profBonus;
  }

  // ──────────────────────────────────────────────────────────
  //  ADVANTAGE / DISADVANTAGE FROM CONDITIONS
  // ──────────────────────────────────────────────────────────

  /// Returns +1 for advantage, -1 for disadvantage, 0 for normal.
  /// Advantage and disadvantage cancel out (D&D rule: they never stack).
  static int _advantageState(ActionType action, Player player) {
    bool hasAdvantage = false;
    bool hasDisadvantage = false;

    // Invisible: advantage on all attack rolls.
    if (player.hasCondition(DndCondition.invisible)) {
      if (action == ActionType.meleeAttack ||
          action == ActionType.rangedAttack ||
          action == ActionType.throwAttack ||
          action == ActionType.assassination) {
        hasAdvantage = true;
      }
    }

    // Blinded: disadvantage on attack rolls.
    if (player.hasCondition(DndCondition.blinded)) {
      if (action == ActionType.meleeAttack ||
          action == ActionType.rangedAttack ||
          action == ActionType.throwAttack ||
          action == ActionType.offensiveMagic ||
          action == ActionType.assassination) {
        hasDisadvantage = true;
      }
    }

    // Frightened: disadvantage on all checks.
    if (player.hasCondition(DndCondition.frightened)) {
      hasDisadvantage = true;
    }

    // Poisoned: disadvantage on attack rolls and ability checks.
    if (player.hasCondition(DndCondition.poisoned)) {
      hasDisadvantage = true;
    }

    // Prone: disadvantage on attack rolls.
    if (player.hasCondition(DndCondition.prone)) {
      if (action == ActionType.meleeAttack ||
          action == ActionType.rangedAttack ||
          action == ActionType.throwAttack) {
        hasDisadvantage = true;
      }
    }

    // Restrained: disadvantage on attack rolls and DEX saves.
    if (player.hasCondition(DndCondition.restrained)) {
      if (action == ActionType.dodge || action == ActionType.flee) {
        hasDisadvantage = true;
      } else if (action == ActionType.meleeAttack ||
          action == ActionType.rangedAttack) {
        hasDisadvantage = true;
      }
    }

    // Exhaustion level 1+: disadvantage on ability checks.
    if (player.exhaustionLevel >= 1) {
      hasDisadvantage = true;
    }

    // Advantage and disadvantage cancel.
    if (hasAdvantage && hasDisadvantage) return 0;
    if (hasAdvantage) return 1;
    if (hasDisadvantage) return -1;
    return 0;
  }

  // ──────────────────────────────────────────────────────────
  //  SITUATIONAL MODIFIERS (no longer from conditions — advantage handles that)
  // ──────────────────────────────────────────────────────────

  static int getSituationalModifier(Player player, ActionType action) {
    int mod = 0;

    // Stunned: -2 to STR/DEX saves (simplified from full disadvantage rule).
    if (player.hasCondition(DndCondition.stunned)) {
      if (action == ActionType.dodge ||
          action == ActionType.flee ||
          action == ActionType.parry) {
        mod -= 2;
      }
    }

    // Low HP penalty (exhaustion-like effect, narrative rule).
    final hpPercent = player.maxHealth > 0
        ? player.currentHealth / player.maxHealth
        : 0.0;
    if (hpPercent <= 0.10) {
      mod -= 3; // Near death.
    } else if (hpPercent <= 0.25) {
      mod -= 1; // Badly wounded.
    }

    return mod;
  }

  /// Repetition penalty: -2 per consecutive repeat (same action, no variety).
  static int getRepetitionPenalty(int repeatCount) {
    if (repeatCount < 2) return 0;
    return -2 * (repeatCount - 1);
  }

  // ──────────────────────────────────────────────────────────
  //  DIFFICULTY CLASS
  // ──────────────────────────────────────────────────────────

  /// Fixed D&D-style DCs based on quest difficulty.
  /// DCs do not scale with player level — the player's growing
  /// proficiency bonus and ability scores make them better over time.
  static int getDC(String? questDifficulty, {int playerLevel = 1}) {
    return switch (questDifficulty?.toLowerCase()) {
      'routine' => 10,
      'dangerous' => 15,
      'perilous' => 20,
      'suicidal' => 25,
      _ => 15,
    };
  }

  // ──────────────────────────────────────────────────────────
  //  ROLL & RESOLVE
  // ──────────────────────────────────────────────────────────

  static int rollD20() => _rng.nextInt(20) + 1;

  /// Roll with advantage (2d20, take highest) or disadvantage (take lowest).
  static int rollD20WithAdvantage(int advantageState) {
    if (advantageState == 0) return rollD20();
    final r1 = rollD20();
    final r2 = rollD20();
    return advantageState > 0 ? max(r1, r2) : min(r1, r2);
  }

  /// Performs a full D&D skill check.
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

    final advState = _advantageState(action, player);
    final roll = rollD20WithAdvantage(advState);
    final statMod = getStatModifier(action, player);
    final sitMod = getSituationalModifier(player, action);
    final repPenalty = getRepetitionPenalty(repeatCount);

    // Melee pressure: -2 to ranged/magic concentration (narrative rule).
    final pressurePenalty =
        underMeleePressure &&
            (action == ActionType.rangedAttack ||
                action == ActionType.offensiveMagic ||
                action == ActionType.defensiveMagic)
        ? -2
        : 0;

    final dc = getDC(questDifficulty, playerLevel: player.level);
    final total = roll + statMod + sitMod + repPenalty + pressurePenalty;

    // Determine outcome (natural 1/20 override as per D&D rules).
    final CheckOutcome outcome;
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

    // Human-readable summary for the AI prompt.
    final skillName = _skillName(action, player);
    final ability = _primaryAbility(action, player);
    final abilityScore = player.abilityScores.getScore(ability);
    final abilityMod = player.abilityScores.getMod(ability);
    final profBonus = _hasProficiency(action, player)
        ? player.proficiencyBonus
        : 0;

    final modParts = <String>[];
    if (abilityMod != 0) {
      modParts.add(
        '${ability.shortName} ${abilityMod >= 0 ? "+$abilityMod" : "$abilityMod"}',
      );
    }
    if (profBonus != 0) modParts.add('prof +$profBonus');
    if (sitMod != 0) {
      modParts.add('situation ${sitMod >= 0 ? "+$sitMod" : "$sitMod"}');
    }
    if (repPenalty != 0) modParts.add('repetition $repPenalty');
    if (pressurePenalty != 0) modParts.add('melee pressure $pressurePenalty');

    final advNote = advState > 0
        ? ' [ADV]'
        : advState < 0
        ? ' [DIS]'
        : '';
    final modStr = modParts.isEmpty ? '' : ' (${modParts.join(", ")})';

    final summary =
        '$skillName check — '
        '${ability.shortName} $abilityScore · '
        'D20$advNote rolled $roll$modStr = $total vs DC $dc → '
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

  // ──────────────────────────────────────────────────────────
  //  INTERACTIVE DICE ROLL SUPPORT
  // ──────────────────────────────────────────────────────────

  /// Computes everything needed for a skill check EXCEPT the actual d20 roll.
  /// Returns null when the action is [ActionType.none] (no check needed).
  /// Use [resolveCheck] to finish the check once the player has rolled.
  static PendingSkillCheck? preparePendingCheck({
    required String playerInput,
    required Player player,
    required String? questDifficulty,
    required ActionType action,
    int repeatCount = 0,
    bool underMeleePressure = false,
  }) {
    if (action == ActionType.none) return null;

    final advState = _advantageState(action, player);
    final statMod = getStatModifier(action, player);
    final sitMod = getSituationalModifier(player, action);
    final repPenalty = getRepetitionPenalty(repeatCount);
    final pressurePenalty =
        underMeleePressure &&
            (action == ActionType.rangedAttack ||
                action == ActionType.offensiveMagic ||
                action == ActionType.defensiveMagic)
        ? -2
        : 0;
    final dc = getDC(questDifficulty, playerLevel: player.level);
    final skillName = _skillName(action, player);

    return PendingSkillCheck(
      action: action,
      player: player,
      playerInput: playerInput,
      questDifficulty: questDifficulty,
      statModifier: statMod,
      situationalModifier: sitMod,
      repetitionPenalty: repPenalty,
      pressurePenalty: pressurePenalty,
      advantageState: advState,
      dc: dc,
      skillName: skillName,
    );
  }

  /// Finish a [PendingSkillCheck] using a player-supplied d20 roll value.
  static SkillCheckResult resolveCheck(PendingSkillCheck pending, int roll) {
    final action = pending.action;
    final player = pending.player;
    final statMod = pending.statModifier;
    final sitMod = pending.situationalModifier;
    final repPenalty = pending.repetitionPenalty;
    final pressurePenalty = pending.pressurePenalty;
    final dc = pending.dc;

    final total = roll + statMod + sitMod + repPenalty + pressurePenalty;

    final CheckOutcome outcome;
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

    final ability = _primaryAbility(action, player);
    final abilityScore = player.abilityScores.getScore(ability);
    final abilityMod = player.abilityScores.getMod(ability);
    final profBonus = _hasProficiency(action, player)
        ? player.proficiencyBonus
        : 0;

    final modParts = <String>[];
    if (abilityMod != 0) {
      modParts.add(
        '${ability.shortName} ${abilityMod >= 0 ? "+$abilityMod" : "$abilityMod"}',
      );
    }
    if (profBonus != 0) modParts.add('prof +$profBonus');
    if (sitMod != 0) {
      modParts.add('situation ${sitMod >= 0 ? "+$sitMod" : "$sitMod"}');
    }
    if (repPenalty != 0) modParts.add('repetition $repPenalty');
    if (pressurePenalty != 0) modParts.add('melee pressure $pressurePenalty');

    final advNote = pending.advantageState > 0
        ? ' [ADV]'
        : pending.advantageState < 0
        ? ' [DIS]'
        : '';
    final modStr = modParts.isEmpty ? '' : ' (${modParts.join(", ")})';

    final summary =
        '${pending.skillName} check — '
        '${ability.shortName} $abilityScore · '
        'D20$advNote rolled $roll$modStr = $total vs DC $dc → '
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

// ──────────────────────────────────────────────────────────
//  PENDING SKILL CHECK
// ──────────────────────────────────────────────────────────

/// Holds all pre-computed state for a skill check that is awaiting
/// a player-supplied d20 roll. Created by [SkillCheckEngine.preparePendingCheck]
/// and resolved by [SkillCheckEngine.resolveCheck].
class PendingSkillCheck {
  final ActionType action;
  final Player player;
  final String playerInput;
  final String? questDifficulty;
  final int statModifier;
  final int situationalModifier;
  final int repetitionPenalty;
  final int pressurePenalty;
  final int advantageState;
  final int dc;
  final String skillName;

  const PendingSkillCheck({
    required this.action,
    required this.player,
    required this.playerInput,
    required this.questDifficulty,
    required this.statModifier,
    required this.situationalModifier,
    required this.repetitionPenalty,
    required this.pressurePenalty,
    required this.advantageState,
    required this.dc,
    required this.skillName,
  });
}
