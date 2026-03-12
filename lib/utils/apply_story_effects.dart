import 'package:Questborne/models/player.dart';
import 'package:Questborne/models/story_event.dart';
import 'package:Questborne/models/item.dart';

/// Takes the current player and the AI-generated effects,
/// returns a record with the updated player and the effects corrected
/// to reflect actual values (e.g. damage after defense reduction).
({Player player, StoryEffects effects}) applyStoryEffects(
  Player player,
  StoryEffects effects, {
  List<Item> allItems = const [],
}) {
  var correctedEffects = effects;

  // ── Damage & Healing ──
  if (effects.damage > 0) {
    final hpBefore = player.currentHealth;
    player = player.takeDamage(effects.damage);
    final actualDamage = hpBefore - player.currentHealth;
    correctedEffects = correctedEffects.copyWith(damage: actualDamage);
  }
  if (effects.heal > 0) {
    player = player.heal(effects.heal);
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

  // ── Items ──
  if (effects.itemGainedId != null) {
    final item = allItems
        .where((i) => i.id == effects.itemGainedId)
        .firstOrNull;
    if (item != null) {
      player = player.addItem(item);
    }
  }
  if (effects.itemLostId != null) {
    player = player.removeItem(effects.itemLostId!);
  }

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
