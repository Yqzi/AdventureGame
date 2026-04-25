import 'dart:math' as math;

import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/story_event.dart';
import 'package:Questborne/models/item.dart';

/// Takes the current player and the AI-generated effects,
/// returns a record with the updated player and the effects corrected
/// to reflect actual values (e.g. actual damage dealt).
///
/// AI damage/heal numbers are treated as severity percentages (1-100)
/// of the player's max HP. In D&D 5e, damage is applied flat (no
/// defence mitigation — the AC-based attack roll already determined
/// the hit). Healing is also flat per D&D rules.
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

  // ── Healing (AI value = % of max HP) ──
  if (effects.heal > 0) {
    final severity = effects.heal.clamp(1, 100);
    final scaledHeal = (severity * player.maxHealth / 100).round();
    player = player.heal(scaledHeal);
  }

  // ── Spell Slot Spending (manaSpent = number of slots to consume) ──
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

  // ── Conditions (D&D 5e) ──
  if (effects.statusAdded != null) {
    final condition = _parseCondition(effects.statusAdded!);
    if (condition != null) {
      player = player.addCondition(condition);
    }
  }
  if (effects.statusRemoved != null) {
    final condition = _parseCondition(effects.statusRemoved!);
    if (condition != null) {
      player = player.removeCondition(condition);
    }
  }

  // ── Condition Tick Damage ──
  // Poisoned: 3% of max HP per turn (bypasses AC — it's a CON save failure).
  // Burning is removed as a distinct status; use poisoned-style for fire DOT.
  if (player.hasCondition(DndCondition.poisoned)) {
    final tick = math.max(1, (player.maxHealth * 0.03).round());
    final hpBefore = player.currentHealth;
    player = player.copyWith(
      currentHealth: (player.currentHealth - tick).clamp(0, player.maxHealth),
    );
    final tickDamage = hpBefore - player.currentHealth;
    correctedEffects = correctedEffects.copyWith(
      damage: correctedEffects.damage + tickDamage,
    );
  }

  // ── Location ──
  if (effects.newLocation != null) {
    player = player.copyWith(currentLocation: effects.newLocation);
  }

  return (player: player, effects: correctedEffects);
}

/// Converts a condition name string from the AI into a [DndCondition].
/// Accepts both the D&D condition names and the legacy status effect names.
DndCondition? _parseCondition(String name) {
  final lower = name.toLowerCase().trim();
  switch (lower) {
    case 'blinded':
      return DndCondition.blinded;
    case 'charmed':
      return DndCondition.charmed;
    case 'deafened':
      return DndCondition.deafened;
    case 'frightened':
      return DndCondition.frightened;
    case 'grappled':
      return DndCondition.grappled;
    case 'incapacitated':
      return DndCondition.incapacitated;
    case 'invisible':
      return DndCondition.invisible;
    case 'paralyzed':
      return DndCondition.paralyzed;
    case 'petrified':
      return DndCondition.petrified;
    case 'poisoned':
      return DndCondition.poisoned;
    case 'prone':
      return DndCondition.prone;
    case 'restrained':
      return DndCondition.restrained;
    case 'stunned':
      return DndCondition.stunned;
    case 'unconscious':
      return DndCondition.unconscious;
    // Legacy name mappings for backward compatibility with old AI prompts.
    case 'burning':
      return DndCondition.poisoned; // Map burning to poisoned (tick damage)
    case 'frozen':
      return DndCondition.restrained;
    case 'blessed':
      return null; // No direct D&D equivalent; AI handles as narrative
    case 'shielded':
      return null; // Not a D&D condition; handle as narrative AC boost
    case 'weakened':
      return DndCondition.stunned;
    default:
      return null;
  }
}
