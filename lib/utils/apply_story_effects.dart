import 'dart:math' as math;

import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/story_event.dart';
import 'package:Questborne/models/item.dart';

/// Takes the current player and the AI-generated effects,
/// returns a record with the updated player and the effects corrected
/// to reflect actual values (e.g. damage after defense reduction).
///
/// AI damage/heal numbers are treated as **severity percentages (1-100)**
/// of the player's max HP. The engine converts them to actual HP values,
/// then applies stat-based formulas (defense reduction, magic scaling, etc.).
({Player player, StoryEffects effects}) applyStoryEffects(
  Player player,
  StoryEffects effects, {
  List<Item> allItems = const [],
}) {
  var correctedEffects = effects;

  // ── Damage (AI value = % of max HP) ──
  if (effects.damage > 0) {
    final severity = effects.damage.clamp(1, 100);
    final scaledDamage = (severity * player.maxHealth / 100).round();
    final hpBefore = player.currentHealth;
    player = player.takeDamage(scaledDamage);
    final actualDamage = hpBefore - player.currentHealth;
    correctedEffects = correctedEffects.copyWith(damage: actualDamage);
  }

  // ── Healing (AI value = % of max HP, then magic-scaled in heal()) ──
  if (effects.heal > 0) {
    final severity = effects.heal.clamp(1, 100);
    final scaledHeal = (severity * player.maxHealth / 100).round();
    player = player.heal(scaledHeal);
  }

  // ── Mana ──
  if (effects.manaSpent > 0) {
    player = player.spendMana(effects.manaSpent);
  }
  if (effects.manaRestored > 0) {
    player = player.restoreMana(effects.manaRestored);
  }

  // ── Gold ──
  if (effects.goldGained > 0) {
    player = player.gainGold(effects.goldGained);
  }
  if (effects.goldLost > 0) {
    player = player.spendGold(effects.goldLost);
  }

  // ── Experience & auto level-up ──
  int levelsGained = 0;
  if (effects.xpGained > 0) {
    final levelBefore = player.level;
    player = player.gainExperience(effects.xpGained);
    while (player.canLevelUp) {
      player = player.levelUp();
    }
    levelsGained = player.level - levelBefore;
    if (levelsGained > 0) {
      correctedEffects = correctedEffects.copyWith(levelsGained: levelsGained);
    }
  }

  // ── Status Effects ──
  if (effects.statusAdded != null) {
    final status = _parseStatus(effects.statusAdded!);
    if (status != null) {
      player = player.addStatus(status);
    }
  }
  if (effects.statusRemoved != null) {
    final status = _parseStatus(effects.statusRemoved!);
    if (status != null) {
      player = player.removeStatus(status);
    }
  }

  // ── Status Effect Tick Damage ──
  // Poisoned: 3% of max HP per turn.  Burning: 5% of max HP per turn.
  // Applied after all other effects so newly-added statuses tick immediately.
  if (player.hasStatus(StatusEffect.poisoned)) {
    final tick = math.max(1, (player.maxHealth * 0.03).round());
    final hpBefore = player.currentHealth;
    // Bypass takeDamage — ticks ignore armor.
    player = player.copyWith(
      currentHealth: (player.currentHealth - tick).clamp(0, player.maxHealth),
    );
    final tickDamage = hpBefore - player.currentHealth;
    correctedEffects = correctedEffects.copyWith(
      damage: (correctedEffects.damage) + tickDamage,
    );
  }
  if (player.hasStatus(StatusEffect.burning)) {
    final tick = math.max(1, (player.maxHealth * 0.05).round());
    final hpBefore = player.currentHealth;
    player = player.copyWith(
      currentHealth: (player.currentHealth - tick).clamp(0, player.maxHealth),
    );
    final tickDamage = hpBefore - player.currentHealth;
    correctedEffects = correctedEffects.copyWith(
      damage: (correctedEffects.damage) + tickDamage,
    );
  }

  // ── Items are disabled — players acquire items only from the shop. ──
  // AI may narrate finding objects (torches, keys) as story flavor,
  // but itemGained / itemLost in EFFECTS are intentionally ignored.

  // ── Location ──
  if (effects.newLocation != null) {
    player = player.copyWith(currentLocation: effects.newLocation);
  }

  return (player: player, effects: correctedEffects);
}

/// Converts a status name string from the AI into a [StatusEffect] enum.
StatusEffect? _parseStatus(String name) {
  switch (name.toLowerCase()) {
    case 'poisoned':
      return StatusEffect.poisoned;
    case 'burning':
      return StatusEffect.burning;
    case 'frozen':
      return StatusEffect.frozen;
    case 'blessed':
      return StatusEffect.blessed;
    case 'shielded':
      return StatusEffect.shielded;
    case 'weakened':
      return StatusEffect.weakened;
    default:
      return null;
  }
}
