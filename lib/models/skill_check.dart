/// Dice-based skill check system.
///
/// Every meaningful player action (attack, sneak, dodge, cast, etc.) triggers
/// a D20 roll on the client. The player's stats modify the roll, status effects
/// apply penalties/bonuses, and quest difficulty sets the DC. The result is
/// injected into the AI prompt so the Game Master narrates accordingly — but
/// the OUTCOME is determined here, not by the AI.
library;

// ─────────────────────────────────────────────────────────────
//  ACTION TYPES
// ─────────────────────────────────────────────────────────────

/// The category of action the player is attempting.
enum ActionType {
  /// Melee strikes, weapon swings, punches, kicks.
  meleeAttack,

  /// Bow shots, thrown daggers, ranged weapon use.
  rangedAttack,

  /// Offensive spell casting.
  offensiveMagic,

  /// Defensive / healing spell casting.
  defensiveMagic,

  /// Sneaking, hiding, moving unseen.
  stealth,

  /// Silent kills, backstabs.
  assassination,

  /// Dodging, evading incoming attacks.
  dodge,

  /// Blocking, parrying with weapon/shield.
  parry,

  /// Persuasion, intimidation, deception, negotiation.
  social,

  /// Throwing a weapon or object.
  throwAttack,

  /// Lock-picking, trap disarming, climbing, acrobatics.
  dexterity,

  /// Resisting poison, enduring pain, surviving harsh conditions.
  endurance,

  /// Running away, escaping.
  flee,

  /// No skill check needed (dialogue, exploration, non-action).
  none,
}

extension ActionTypeLabel on ActionType {
  String get label {
    switch (this) {
      case ActionType.meleeAttack:
        return 'Melee Attack';
      case ActionType.rangedAttack:
        return 'Ranged Attack';
      case ActionType.offensiveMagic:
        return 'Offensive Magic';
      case ActionType.defensiveMagic:
        return 'Defensive Magic';
      case ActionType.stealth:
        return 'Stealth';
      case ActionType.assassination:
        return 'Assassination';
      case ActionType.dodge:
        return 'Dodge';
      case ActionType.parry:
        return 'Parry';
      case ActionType.social:
        return 'Persuasion';
      case ActionType.throwAttack:
        return 'Throw';
      case ActionType.dexterity:
        return 'Dexterity';
      case ActionType.endurance:
        return 'Endurance';
      case ActionType.flee:
        return 'Flee';
      case ActionType.none:
        return '';
    }
  }

  String get icon {
    switch (this) {
      case ActionType.meleeAttack:
        return '⚔️';
      case ActionType.rangedAttack:
        return '🏹';
      case ActionType.offensiveMagic:
        return '🔮';
      case ActionType.defensiveMagic:
        return '🛡️';
      case ActionType.stealth:
        return '🤫';
      case ActionType.assassination:
        return '🗡️';
      case ActionType.dodge:
        return '💨';
      case ActionType.parry:
        return '🛡️';
      case ActionType.social:
        return '🗣️';
      case ActionType.throwAttack:
        return '🎯';
      case ActionType.dexterity:
        return '🤸';
      case ActionType.endurance:
        return '💪';
      case ActionType.flee:
        return '🏃';
      case ActionType.none:
        return '';
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  CHECK OUTCOME
// ─────────────────────────────────────────────────────────────

enum CheckOutcome {
  /// Natural 1 — catastrophic failure regardless of stats.
  criticalFailure,

  /// Roll + modifiers fell well below the DC.
  failure,

  /// Roll + modifiers were close to DC (within 3 below).
  partialSuccess,

  /// Roll + modifiers met or exceeded DC.
  success,

  /// Natural 20 — spectacular success regardless of DC.
  criticalSuccess,
}

extension CheckOutcomeLabel on CheckOutcome {
  String get label {
    switch (this) {
      case CheckOutcome.criticalFailure:
        return 'Critical Failure';
      case CheckOutcome.failure:
        return 'Failure';
      case CheckOutcome.partialSuccess:
        return 'Partial Success';
      case CheckOutcome.success:
        return 'Success';
      case CheckOutcome.criticalSuccess:
        return 'Critical Success';
    }
  }

  String get icon {
    switch (this) {
      case CheckOutcome.criticalFailure:
        return '💀';
      case CheckOutcome.failure:
        return '✖️';
      case CheckOutcome.partialSuccess:
        return '⚠️';
      case CheckOutcome.success:
        return '✔️';
      case CheckOutcome.criticalSuccess:
        return '🌟';
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  SKILL CHECK RESULT
// ─────────────────────────────────────────────────────────────

/// The complete result of a D20 skill check, carried through to the AI prompt
/// and optionally displayed in the UI.
class SkillCheckResult {
  /// What the player was attempting.
  final ActionType actionType;

  /// The raw D20 roll (1–20).
  final int naturalRoll;

  /// Bonus from the player's relevant stat(s).
  final int statModifier;

  /// Bonus/penalty from status effects, injuries, etc.
  final int situationalModifier;

  /// The total: naturalRoll + statModifier + situationalModifier.
  int get total => naturalRoll + statModifier + situationalModifier;

  /// The difficulty class the player needed to meet.
  final int dc;

  /// The final outcome.
  final CheckOutcome outcome;

  /// Human-readable breakdown for the AI prompt.
  final String summary;

  const SkillCheckResult({
    required this.actionType,
    required this.naturalRoll,
    required this.statModifier,
    required this.situationalModifier,
    required this.dc,
    required this.outcome,
    required this.summary,
  });
}
