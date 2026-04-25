import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:Questborne/models/ability_scores.dart';
import 'package:Questborne/models/background.dart';
import 'package:Questborne/models/character_class.dart';
import 'package:Questborne/models/character_race.dart';
import 'package:Questborne/models/item.dart';

// ─────────────────────────────────────────────────────────────
//  D&D CONDITIONS
// ─────────────────────────────────────────────────────────────

/// The 14 on/off D&D 5e conditions (exhaustion is tracked separately
/// as an integer level 0–6 via [Player.exhaustionLevel]).
enum DndCondition {
  blinded,
  charmed,
  deafened,
  frightened,
  grappled,
  incapacitated,
  invisible,
  paralyzed,
  petrified,
  poisoned,
  prone,
  restrained,
  stunned,
  unconscious,
}

extension DndConditionExtension on DndCondition {
  String get label {
    switch (this) {
      case DndCondition.blinded:
        return 'BLINDED';
      case DndCondition.charmed:
        return 'CHARMED';
      case DndCondition.deafened:
        return 'DEAFENED';
      case DndCondition.frightened:
        return 'FRIGHTENED';
      case DndCondition.grappled:
        return 'GRAPPLED';
      case DndCondition.incapacitated:
        return 'INCAPACITATED';
      case DndCondition.invisible:
        return 'INVISIBLE';
      case DndCondition.paralyzed:
        return 'PARALYZED';
      case DndCondition.petrified:
        return 'PETRIFIED';
      case DndCondition.poisoned:
        return 'POISONED';
      case DndCondition.prone:
        return 'PRONE';
      case DndCondition.restrained:
        return 'RESTRAINED';
      case DndCondition.stunned:
        return 'STUNNED';
      case DndCondition.unconscious:
        return 'UNCONSCIOUS';
    }
  }

  String get icon {
    switch (this) {
      case DndCondition.blinded:
        return 'BLIND';
      case DndCondition.charmed:
        return 'CHARM';
      case DndCondition.deafened:
        return 'DEAF';
      case DndCondition.frightened:
        return 'FEAR';
      case DndCondition.grappled:
        return 'GRAP';
      case DndCondition.incapacitated:
        return 'INCA';
      case DndCondition.invisible:
        return 'INVIS';
      case DndCondition.paralyzed:
        return 'PARA';
      case DndCondition.petrified:
        return 'PETR';
      case DndCondition.poisoned:
        return 'POI';
      case DndCondition.prone:
        return 'PRONE';
      case DndCondition.restrained:
        return 'REST';
      case DndCondition.stunned:
        return 'STUN';
      case DndCondition.unconscious:
        return 'UNC';
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  EQUIPMENT LOADOUT
// ─────────────────────────────────────────────────────────────

class Equipment extends Equatable {
  final Item? weapon;
  final Item? armor;
  final Item? accessory;
  final Item? relic;
  final Item? spell;

  const Equipment({
    this.weapon,
    this.armor,
    this.accessory,
    this.relic,
    this.spell,
  });

  /// AC bonus from equipped armor. Maps item.defense to armor class bonus.
  int get armorClassBonus => armor?.defense ?? 0;

  /// Weapon attack bonus (+X magic enhancement).
  int get weaponAttackBonus => weapon?.attack ?? 0;

  /// Bonus HP from all equipped items.
  int get bonusHp {
    int total = 0;
    for (final item in [weapon, armor, accessory, relic, spell]) {
      if (item != null) total += item.health;
    }
    return total;
  }

  /// Generic bonus lookup (retained for shop/inventory compatibility).
  int totalBonus(String stat) {
    int total = 0;
    for (final item in [weapon, armor, accessory, relic, spell]) {
      if (item == null) continue;
      switch (stat) {
        case 'attack':
          total += item.attack;
          break;
        case 'defense':
          total += item.defense;
          break;
        case 'magic':
          total += item.magic;
          break;
        case 'agility':
          total += item.agility;
          break;
        case 'health':
          total += item.health;
          break;
      }
    }
    return total;
  }

  /// Returns the equipped item for a given [ItemType] slot.
  Item? getSlot(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return weapon;
      case ItemType.armor:
        return armor;
      case ItemType.accessory:
        return accessory;
      case ItemType.relic:
        return relic;
      case ItemType.spell:
        return spell;
    }
  }

  Equipment equip(Item item) {
    switch (item.type) {
      case ItemType.weapon:
        return copyWith(weapon: item);
      case ItemType.armor:
        return copyWith(armor: item);
      case ItemType.accessory:
        return copyWith(accessory: item);
      case ItemType.relic:
        return copyWith(relic: item);
      case ItemType.spell:
        return copyWith(spell: item);
    }
  }

  Equipment unequip(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Equipment(
          armor: armor,
          accessory: accessory,
          relic: relic,
          spell: spell,
        );
      case ItemType.armor:
        return Equipment(
          weapon: weapon,
          accessory: accessory,
          relic: relic,
          spell: spell,
        );
      case ItemType.accessory:
        return Equipment(
          weapon: weapon,
          armor: armor,
          relic: relic,
          spell: spell,
        );
      case ItemType.relic:
        return Equipment(
          weapon: weapon,
          armor: armor,
          accessory: accessory,
          spell: spell,
        );
      case ItemType.spell:
        return Equipment(
          weapon: weapon,
          armor: armor,
          accessory: accessory,
          relic: relic,
        );
    }
  }

  Equipment copyWith({
    Item? weapon,
    Item? armor,
    Item? accessory,
    Item? relic,
    Item? spell,
  }) {
    return Equipment(
      weapon: weapon ?? this.weapon,
      armor: armor ?? this.armor,
      accessory: accessory ?? this.accessory,
      relic: relic ?? this.relic,
      spell: spell ?? this.spell,
    );
  }

  Map<String, dynamic> toJson() => {
    'weapon': weapon?.id,
    'armor': armor?.id,
    'accessory': accessory?.id,
    'relic': relic?.id,
    'spell': spell?.id,
  };

  factory Equipment.fromJson(
    Map<String, dynamic> json,
    Map<String, Item> itemLookup,
  ) {
    return Equipment(
      weapon: itemLookup[json['weapon']],
      armor: itemLookup[json['armor']],
      accessory: itemLookup[json['accessory']],
      relic: itemLookup[json['relic']],
      spell: itemLookup[json['spell']],
    );
  }

  @override
  List<Object?> get props => [weapon, armor, accessory, relic, spell];
}

// =============================================================
//  PLAYER MODEL
// =============================================================

// Sentinel value for nullable copyWith params (allows explicit null).
const Object _sentinel = Object();

class Player extends Equatable {
  // Identity
  final String id;
  final String name;

  // D&D Character Creation
  final DndClass? dndClass;
  final DndRace? dndRace;
  final DndBackground? background;
  final AbilityScores abilityScores;
  final List<String> skillProficiencies;
  final bool needsCharacterCreation;

  // Progression
  final int level;
  final int experience;

  // Hit Points
  final int currentHealth;
  final int maxHealth;

  // Hit Dice remaining (short rest recovery)
  final int hitDiceRemaining;

  // Spell Slots: current available per spell level (9 elements, index = level-1)
  final List<int> currentSpellSlots;

  // D&D Conditions
  final List<DndCondition> conditions;

  // Exhaustion (0 = none, 6 = dead from exhaustion)
  final int exhaustionLevel;

  // Temporary hit points (absorbed before real HP)
  final int tempHp;

  // Death saving throws (at 0 HP)
  final int deathSaveSuccesses;
  final int deathSaveFailures;

  // Inspiration (grants advantage on one roll)
  final bool hasInspiration;

  // Concentration spell (name of the spell being concentrated on, or null)
  final String? concentratingOnSpell;

  // Economy
  final int gold;

  // Gear
  final Equipment equipment;
  final List<Item> inventory;

  // Meta
  final String currentLocation;
  final int questsCompleted;
  final int enemiesDefeated;
  final List<String> completedQuestIds;

  const Player({
    required this.id,
    required this.name,
    this.dndClass,
    this.dndRace,
    this.background,
    required this.abilityScores,
    this.skillProficiencies = const [],
    this.needsCharacterCreation = true,
    this.level = 1,
    this.experience = 0,
    required this.currentHealth,
    required this.maxHealth,
    this.hitDiceRemaining = 1,
    this.currentSpellSlots = const [0, 0, 0, 0, 0, 0, 0, 0, 0],
    this.conditions = const [],
    this.exhaustionLevel = 0,
    this.tempHp = 0,
    this.deathSaveSuccesses = 0,
    this.deathSaveFailures = 0,
    this.hasInspiration = false,
    this.concentratingOnSpell,
    this.gold = 0,
    this.equipment = const Equipment(),
    this.inventory = const [],
    this.currentLocation = 'Unknown',
    this.questsCompleted = 0,
    this.enemiesDefeated = 0,
    this.completedQuestIds = const [],
  });

  // ── Factory: fresh player awaiting character creation ──
  factory Player.create({required String id, required String name}) {
    return Player(
      id: id,
      name: name,
      abilityScores: AbilityScores.defaults(),
      currentHealth: 10,
      maxHealth: 10,
      needsCharacterCreation: true,
      gold: 100,
    );
  }

  /// Factory called after character creation is completed.
  factory Player.fromCharacterCreation({
    required Player base,
    required DndClass dndClass,
    required DndRace dndRace,
    required DndBackground background,
    required AbilityScores abilityScores,
    required List<String> skillProficiencies,
  }) {
    final classData = dndClass.data;
    final conMod = abilityScores.conMod;
    final startHp = (classData.hitDie + conMod).clamp(1, 999);
    final slots = classData.spellSlotsAtLevel(1);

    return base.copyWith(
      dndClass: dndClass,
      dndRace: dndRace,
      background: background,
      abilityScores: abilityScores,
      skillProficiencies: skillProficiencies,
      needsCharacterCreation: false,
      level: 1,
      experience: 0,
      currentHealth: startHp,
      maxHealth: startHp,
      hitDiceRemaining: 1,
      currentSpellSlots: slots,
    );
  }

  // ── Proficiency Bonus ──
  int get proficiencyBonus => proficiencyBonusForLevel(level);

  // ── Ability Score Shortcuts ──
  int get strMod => abilityScores.strMod;
  int get dexMod => abilityScores.dexMod;
  int get conMod => abilityScores.conMod;
  int get intMod => abilityScores.intMod;
  int get wisMod => abilityScores.wisMod;
  int get chaMod => abilityScores.chaMod;

  // ── Passive Perception ──
  int get passivePerception {
    final hasPerceptionProf = skillProficiencies.any(
      (s) => s.toLowerCase().contains('perception'),
    );
    return 10 + wisMod + (hasPerceptionProf ? proficiencyBonus : 0);
  }

  // ── Saving Throws ──
  int savingThrowBonus(AbilityType ability) {
    final abilityMod = abilityScores.getMod(ability);
    final isProf =
        dndClass?.data.savingThrowProficiencies.contains(ability) ?? false;
    return abilityMod + (isProf ? proficiencyBonus : 0);
  }

  String get savingThrowSummary {
    final types = [
      AbilityType.strength,
      AbilityType.dexterity,
      AbilityType.constitution,
      AbilityType.intelligence,
      AbilityType.wisdom,
      AbilityType.charisma,
    ];
    return types
        .map(
          (t) =>
              '${t.shortName} ${AbilityScores.formatMod(savingThrowBonus(t))}',
        )
        .join(' ');
  }

  // ── Armor Class ──
  int get armorClass {
    final dex = dexMod;
    final armorBonus = equipment.armorClassBonus;
    if (armorBonus > 0) {
      return armorBonus + dex;
    }
    if (dndClass == DndClass.barbarian) return 10 + dex + conMod;
    if (dndClass == DndClass.monk) return 10 + dex + wisMod;
    return 10 + dex;
  }

  // ── Spell Save DC & Spell Attack Bonus ──
  int get spellSaveDC {
    final spellAbility = dndClass?.data.spellcastingAbility;
    if (spellAbility == null) return 0;
    return 8 + proficiencyBonus + abilityScores.getMod(spellAbility);
  }

  int get spellAttackBonus {
    final spellAbility = dndClass?.data.spellcastingAbility;
    if (spellAbility == null) return 0;
    return proficiencyBonus + abilityScores.getMod(spellAbility);
  }

  // ── Spell Slots ──
  List<int> get maxSpellSlots =>
      dndClass?.data.spellSlotsAtLevel(level) ?? List.filled(9, 0);

  bool get isSpellcaster => dndClass?.data.isSpellcaster ?? false;

  int get totalCurrentSpellSlots => currentSpellSlots.fold(0, (a, b) => a + b);
  int get totalMaxSpellSlots => maxSpellSlots.fold(0, (a, b) => a + b);

  Player useSpellSlot(int slotLevel) {
    if (slotLevel < 1 || slotLevel > 9) return this;
    final idx = slotLevel - 1;
    if (currentSpellSlots[idx] <= 0) return this;
    final updated = List<int>.from(currentSpellSlots);
    updated[idx]--;
    return copyWith(currentSpellSlots: updated);
  }

  Player restoreAllSpellSlots() =>
      copyWith(currentSpellSlots: List<int>.from(maxSpellSlots));

  Player restorePactMagicSlots() {
    if (dndClass != DndClass.warlock) return this;
    return restoreAllSpellSlots();
  }

  bool canCastAtLevel(int slotLevel) {
    if (slotLevel < 1 || slotLevel > 9) return false;
    return currentSpellSlots[slotLevel - 1] > 0;
  }

  // ── Mana as spell-slot proxy (UI compatibility) ──
  int get currentMana => totalCurrentSpellSlots;
  int get maxMana => totalMaxSpellSlots;
  double get manaConsumed =>
      maxMana > 0 ? ((1 - currentMana / maxMana) * 100) : 100;
  bool get hasMana => totalCurrentSpellSlots > 0;

  // ── HP Percentages ──
  /// Effective max HP — halved at exhaustion level 4+ (D&D rule).
  int get effectiveMaxHp => exhaustionLevel >= 4
      ? (maxHealth / 2).floor().clamp(1, maxHealth)
      : maxHealth;

  double get healthConsumed =>
      effectiveMaxHp > 0 ? ((1 - currentHealth / effectiveMaxHp) * 100) : 100;
  bool get isAlive => currentHealth > 0 && deathSaveFailures < 3;
  bool get isDying =>
      currentHealth == 0 && deathSaveFailures < 3 && deathSaveSuccesses < 3;
  bool get isStable => currentHealth == 0 && deathSaveSuccesses >= 3;

  // ── Conditions ──
  List<DndCondition> get statusEffects => conditions;

  Player addCondition(DndCondition condition) {
    if (conditions.contains(condition)) return this;
    return copyWith(conditions: [...conditions, condition]);
  }

  Player removeCondition(DndCondition condition) =>
      copyWith(conditions: conditions.where((c) => c != condition).toList());

  Player clearAllConditions() => copyWith(conditions: []);
  bool hasCondition(DndCondition condition) => conditions.contains(condition);

  bool hasStatus(DndCondition condition) => hasCondition(condition);
  Player addStatus(DndCondition condition) => addCondition(condition);
  Player removeStatus(DndCondition condition) => removeCondition(condition);
  Player clearAllStatuses() => clearAllConditions();

  // ── Exhaustion ──
  Player addExhaustion() {
    final newLevel = (exhaustionLevel + 1).clamp(0, 6);
    var p = copyWith(exhaustionLevel: newLevel);
    // Level 6 = death (D&D rule)
    if (newLevel >= 6) {
      p = p.copyWith(currentHealth: 0);
    }
    // Level 4 = hit point maximum halved — clamp currentHealth if now over cap
    else if (newLevel >= 4) {
      final cap = p.effectiveMaxHp;
      if (p.currentHealth > cap) {
        p = p.copyWith(currentHealth: cap);
      }
    }
    return p;
  }

  Player removeExhaustion() =>
      copyWith(exhaustionLevel: (exhaustionLevel - 1).clamp(0, 6));

  // ── Spells ──
  List<Item> get spellItems {
    final spells = inventory.where((i) => i.type == ItemType.spell).toList();
    if (equipment.spell != null) spells.insert(0, equipment.spell!);
    return spells;
  }

  bool canCastSpell(Item spell) => hasMana;

  // ── XP Thresholds (D&D 5e) ──
  static const List<int> _xpToNextLevel = [
    300,
    600,
    1800,
    3800,
    7500,
    9000,
    11000,
    14000,
    16000,
    21000,
    15000,
    20000,
    20000,
    25000,
    30000,
    30000,
    40000,
    40000,
    50000,
  ];

  int get experienceToNextLevel {
    if (level >= maxLevel) return 0;
    return _xpToNextLevel[level - 1];
  }

  bool get canLevelUp =>
      level < maxLevel && experience >= experienceToNextLevel;
  static const int maxLevel = 20;

  Player levelUp() {
    if (!canLevelUp || level >= maxLevel) return this;
    final newLevel = level + 1;
    final classData = dndClass?.data;

    final hpIncrease = ((classData?.hpPerLevel ?? 5) + conMod).clamp(1, 999);
    final newMaxHp = maxHealth + hpIncrease;

    final newMaxSlots =
        classData?.spellSlotsAtLevel(newLevel) ?? List.filled(9, 0);
    final currentMax = maxSpellSlots;
    final updatedSlots = List<int>.from(currentSpellSlots);
    for (int i = 0; i < 9; i++) {
      final gained = (newMaxSlots[i] - currentMax[i]).clamp(0, 99);
      updatedSlots[i] = (updatedSlots[i] + gained).clamp(0, newMaxSlots[i]);
    }

    return copyWith(
      level: newLevel,
      experience: experience - experienceToNextLevel,
      maxHealth: newMaxHp,
      currentHealth: newMaxHp,
      hitDiceRemaining: newLevel,
      currentSpellSlots: updatedSlots,
    );
  }

  // ── Combat ──
  Player takeDamage(int amount) {
    if (amount <= 0) return this;
    var remaining = amount;
    var newTempHp = tempHp;
    if (newTempHp > 0) {
      final absorbed = remaining.clamp(0, newTempHp);
      newTempHp -= absorbed;
      remaining -= absorbed;
    }
    final newHp = (currentHealth - remaining).clamp(0, effectiveMaxHp);
    // Reset death saves if damage knocks to 0 while already at 0 (new damage restarts counters)
    if (newHp == 0 && currentHealth > 0) {
      return copyWith(
        currentHealth: newHp,
        tempHp: newTempHp,
        deathSaveSuccesses: 0,
        deathSaveFailures: 0,
      );
    }
    return copyWith(currentHealth: newHp, tempHp: newTempHp);
  }

  Player heal(int amount) {
    if (amount <= 0) return this;
    var scaled = amount;
    if (hasCondition(DndCondition.poisoned)) {
      scaled = (amount * 0.5).round();
    }
    return copyWith(
      currentHealth: (currentHealth + scaled).clamp(0, effectiveMaxHp),
    );
  }

  /// Grant temporary hit points. Per D&D rules, temp HP doesn't stack —
  /// keep the higher value.
  Player addTempHp(int amount) =>
      copyWith(tempHp: amount > tempHp ? amount : tempHp);

  Player longRest() {
    // Recover up to half total hit dice (rounded up, min 1) per D&D rules.
    final recover = math.max(1, (level / 2).ceil());
    final newHitDice = (hitDiceRemaining + recover).clamp(0, level);
    return copyWith(
      currentHealth: effectiveMaxHp,
      currentSpellSlots: List<int>.from(maxSpellSlots),
      hitDiceRemaining: newHitDice,
      exhaustionLevel: (exhaustionLevel - 1).clamp(0, 6),
      tempHp: 0,
      deathSaveSuccesses: 0,
      deathSaveFailures: 0,
      concentratingOnSpell: null,
    );
  }

  Player shortRest({int hitDiceSpent = 0}) {
    final diceToSpend = hitDiceSpent.clamp(0, hitDiceRemaining);
    var p = this;
    if (diceToSpend > 0) {
      final classData = dndClass?.data;
      final hitDie = classData?.hitDie ?? 8;
      // Use average per die (hitDie/2+1 + conMod) — deterministic for immutable model.
      final healPerDie = (hitDie ~/ 2 + 1 + conMod).clamp(1, 999);
      final totalHeal = healPerDie * diceToSpend;
      p = p.copyWith(
        currentHealth: (p.currentHealth + totalHeal).clamp(0, p.effectiveMaxHp),
        hitDiceRemaining: (p.hitDiceRemaining - diceToSpend).clamp(0, p.level),
      );
    }
    // Warlock recovers pact magic slots on short rest.
    if (dndClass == DndClass.warlock) {
      p = p.restorePactMagicSlots();
    }
    return p;
  }

  /// Apply a death saving throw with a pre-supplied d20 roll value (1–20).
  /// Use this when the player rolls the dice interactively in the UI.
  Player makeDeathSavingThrowWithRoll(int roll) {
    if (currentHealth > 0) return this; // Not dying — no roll needed.
    if (roll == 20) {
      // Nat 20: regain 1 HP and reset death saves.
      return copyWith(
        currentHealth: 1,
        deathSaveSuccesses: 0,
        deathSaveFailures: 0,
      );
    }
    if (roll == 1) {
      // Nat 1: counts as two failures.
      final newFails = (deathSaveFailures + 2).clamp(0, 3);
      return copyWith(deathSaveFailures: newFails);
    }
    if (roll >= 10) {
      final newSucc = (deathSaveSuccesses + 1).clamp(0, 3);
      return copyWith(deathSaveSuccesses: newSucc);
    } else {
      final newFails = (deathSaveFailures + 1).clamp(0, 3);
      return copyWith(deathSaveFailures: newFails);
    }
  }

  /// Roll a death saving throw. Call only when `currentHealth == 0`.
  Player makeDeathSavingThrow() {
    if (currentHealth > 0) return this; // Not dying — no roll needed.
    final roll = math.Random().nextInt(20) + 1;
    if (roll == 20) {
      // Nat 20: regain 1 HP and reset death saves.
      return copyWith(
        currentHealth: 1,
        deathSaveSuccesses: 0,
        deathSaveFailures: 0,
      );
    }
    if (roll == 1) {
      // Nat 1: counts as two failures.
      final newFails = (deathSaveFailures + 2).clamp(0, 3);
      return copyWith(deathSaveFailures: newFails);
    }
    if (roll >= 10) {
      final newSucc = (deathSaveSuccesses + 1).clamp(0, 3);
      return copyWith(deathSaveSuccesses: newSucc);
    } else {
      final newFails = (deathSaveFailures + 1).clamp(0, 3);
      return copyWith(deathSaveFailures: newFails);
    }
  }

  Player fullRestore() => copyWith(
    currentHealth: maxHealth,
    currentSpellSlots: List<int>.from(maxSpellSlots),
    hitDiceRemaining: level,
    exhaustionLevel: 0,
    conditions: [],
    tempHp: 0,
    deathSaveSuccesses: 0,
    deathSaveFailures: 0,
    concentratingOnSpell: null,
  );

  // ── Inspiration ──
  Player grantInspiration() => copyWith(hasInspiration: true);
  Player spendInspiration() => copyWith(hasInspiration: false);

  // ── Concentration ──
  Player beginConcentration(String spellName) =>
      copyWith(concentratingOnSpell: spellName);
  Player endConcentration() => copyWith(concentratingOnSpell: null);

  // ── Mana Compat Stubs ──
  Player spendMana(int amount) {
    var p = this;
    var remaining = amount;
    for (int i = 0; i < 9 && remaining > 0; i++) {
      final toUse = remaining.clamp(0, p.currentSpellSlots[i]);
      if (toUse > 0) {
        final updated = List<int>.from(p.currentSpellSlots);
        updated[i] -= toUse;
        p = p.copyWith(currentSpellSlots: updated);
        remaining -= toUse;
      }
    }
    return p;
  }

  Player restoreMana(int amount) {
    var p = this;
    var remaining = amount;
    final max = p.maxSpellSlots;
    for (int i = 0; i < 9 && remaining > 0; i++) {
      final cap = max[i] - p.currentSpellSlots[i];
      final toRestore = remaining.clamp(0, cap);
      if (toRestore > 0) {
        final updated = List<int>.from(p.currentSpellSlots);
        updated[i] += toRestore;
        p = p.copyWith(currentSpellSlots: updated);
        remaining -= toRestore;
      }
    }
    return p;
  }

  // ── Inventory & Equipment ──
  Player addItem(Item item) => copyWith(inventory: [...inventory, item]);

  Player removeItem(String itemId) =>
      copyWith(inventory: inventory.where((i) => i.id != itemId).toList());

  Player equipItem(Item item) {
    final previousItem = equipment.getSlot(item.type);
    var updatedInventory = inventory.where((i) => i.id != item.id).toList();
    if (previousItem != null) {
      updatedInventory = [...updatedInventory, previousItem];
    }
    return copyWith(
      equipment: equipment.equip(item),
      inventory: updatedInventory,
    );
  }

  Player unequipSlot(ItemType type) {
    final item = equipment.getSlot(type);
    if (item == null) return this;
    return copyWith(
      equipment: equipment.unequip(type),
      inventory: [...inventory, item],
    );
  }

  Player buyItem(Item item) {
    if (gold < item.price) return this;
    return copyWith(gold: gold - item.price, inventory: [...inventory, item]);
  }

  Player sellItem(String itemId) {
    final item = inventory.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw StateError('Item not found'),
    );
    return copyWith(
      gold: gold + (item.price ~/ 2),
      inventory: inventory.where((i) => i.id != itemId).toList(),
    );
  }

  bool canAfford(int price) => gold >= price;

  // ── Experience & Gold ──
  Player gainExperience(int amount) =>
      copyWith(experience: experience + amount);
  Player gainGold(int amount) => copyWith(gold: gold + amount);
  Player spendGold(int amount) =>
      copyWith(gold: (gold - amount).clamp(0, gold));
  Player incrementQuestsCompleted() =>
      copyWith(questsCompleted: questsCompleted + 1);

  Player completeQuest(String questId) {
    if (completedQuestIds.contains(questId)) return this;
    return copyWith(
      questsCompleted: questsCompleted + 1,
      completedQuestIds: [...completedQuestIds, questId],
    );
  }

  Player incrementEnemiesDefeated() =>
      copyWith(enemiesDefeated: enemiesDefeated + 1);

  // ── Stat Summaries ──
  String get statSummary {
    final cls = dndClass?.displayName ?? 'Unknown';
    final race = dndRace?.displayName ?? '';
    return '$race $cls · AC $armorClass · Lvl $level';
  }

  String get abilitySummary {
    return 'STR ${abilityScores.strength}(${AbilityScores.formatMod(strMod)}) '
        'DEX ${abilityScores.dexterity}(${AbilityScores.formatMod(dexMod)}) '
        'CON ${abilityScores.constitution}(${AbilityScores.formatMod(conMod)}) '
        'INT ${abilityScores.intelligence}(${AbilityScores.formatMod(intMod)}) '
        'WIS ${abilityScores.wisdom}(${AbilityScores.formatMod(wisMod)}) '
        'CHA ${abilityScores.charisma}(${AbilityScores.formatMod(chaMod)})';
  }

  String get vitalsSummary =>
      'HP $currentHealth/$maxHealth · AC $armorClass · Slots ${totalCurrentSpellSlots}/${totalMaxSpellSlots}';

  // ── Serialisation ──
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dndClass': dndClass?.name,
    'dndRace': dndRace?.name,
    'background': background?.name,
    'abilityScores': abilityScores.toJson(),
    'skillProficiencies': skillProficiencies,
    'needsCharacterCreation': needsCharacterCreation,
    'level': level,
    'experience': experience,
    'currentHealth': currentHealth,
    'maxHealth': maxHealth,
    'hitDiceRemaining': hitDiceRemaining,
    'currentSpellSlots': currentSpellSlots,
    'conditions': conditions.map((c) => c.name).toList(),
    'exhaustionLevel': exhaustionLevel,
    'tempHp': tempHp,
    'deathSaveSuccesses': deathSaveSuccesses,
    'deathSaveFailures': deathSaveFailures,
    'hasInspiration': hasInspiration,
    'concentratingOnSpell': concentratingOnSpell,
    'gold': gold,
    'equipment': equipment.toJson(),
    'inventory': inventory.map((i) => i.id).toList(),
    'currentLocation': currentLocation,
    'questsCompleted': questsCompleted,
    'enemiesDefeated': enemiesDefeated,
    'completedQuestIds': completedQuestIds,
  };

  factory Player.fromJson(Map<String, dynamic> json) {
    final itemLookup = {for (final item in allItems) item.id: item};

    final inventoryIds = (json['inventory'] as List<dynamic>?) ?? [];
    final inventory = inventoryIds
        .map((id) => itemLookup[id as String])
        .whereType<Item>()
        .toList();

    final equipmentJson = json['equipment'] as Map<String, dynamic>?;
    final equipment = equipmentJson != null
        ? Equipment.fromJson(equipmentJson, itemLookup)
        : const Equipment();

    final abJson = json['abilityScores'] as Map<String, dynamic>?;
    final abilityScores = abJson != null
        ? AbilityScores.fromJson(abJson)
        : AbilityScores.defaults();

    final className = json['dndClass'] as String?;
    final dndClass = className != null
        ? DndClass.values.where((c) => c.name == className).firstOrNull
        : null;

    final raceName = json['dndRace'] as String?;
    final dndRace = raceName != null
        ? DndRace.values.where((r) => r.name == raceName).firstOrNull
        : null;

    final bgName = json['background'] as String?;
    final background = bgName != null
        ? DndBackground.values.where((b) => b.name == bgName).firstOrNull
        : null;

    final condNames = (json['conditions'] as List<dynamic>?) ?? [];
    final conditions = condNames
        .map((n) => DndCondition.values.where((c) => c.name == n).firstOrNull)
        .whereType<DndCondition>()
        .toList();

    final slotList = json['currentSpellSlots'] as List<dynamic>?;
    final spellSlots = slotList != null
        ? List<int>.from(slotList.map((e) => e as int))
        : List.filled(9, 0);
    while (spellSlots.length < 9) spellSlots.add(0);

    final bool needsCreation =
        json['needsCharacterCreation'] as bool? ?? dndClass == null;

    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      dndClass: dndClass,
      dndRace: dndRace,
      background: background,
      abilityScores: abilityScores,
      skillProficiencies:
          (json['skillProficiencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      needsCharacterCreation: needsCreation,
      level: json['level'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      currentHealth: json['currentHealth'] as int? ?? 10,
      maxHealth: json['maxHealth'] as int? ?? 10,
      hitDiceRemaining: json['hitDiceRemaining'] as int? ?? 1,
      currentSpellSlots: spellSlots,
      conditions: conditions,
      exhaustionLevel: json['exhaustionLevel'] as int? ?? 0,
      tempHp: json['tempHp'] as int? ?? 0,
      deathSaveSuccesses: json['deathSaveSuccesses'] as int? ?? 0,
      deathSaveFailures: json['deathSaveFailures'] as int? ?? 0,
      hasInspiration: json['hasInspiration'] as bool? ?? false,
      concentratingOnSpell: json['concentratingOnSpell'] as String?,
      gold: json['gold'] as int? ?? 0,
      equipment: equipment,
      inventory: inventory,
      currentLocation: json['currentLocation'] as String? ?? 'Unknown',
      questsCompleted: json['questsCompleted'] as int? ?? 0,
      enemiesDefeated: json['enemiesDefeated'] as int? ?? 0,
      completedQuestIds:
          (json['completedQuestIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  // ── Copy-With ──
  Player copyWith({
    String? id,
    String? name,
    DndClass? dndClass,
    DndRace? dndRace,
    DndBackground? background,
    AbilityScores? abilityScores,
    List<String>? skillProficiencies,
    bool? needsCharacterCreation,
    int? level,
    int? experience,
    int? currentHealth,
    int? maxHealth,
    int? hitDiceRemaining,
    List<int>? currentSpellSlots,
    List<DndCondition>? conditions,
    int? exhaustionLevel,
    int? tempHp,
    int? deathSaveSuccesses,
    int? deathSaveFailures,
    bool? hasInspiration,
    Object? concentratingOnSpell = _sentinel,
    int? gold,
    Equipment? equipment,
    List<Item>? inventory,
    String? currentLocation,
    int? questsCompleted,
    int? enemiesDefeated,
    List<String>? completedQuestIds,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      dndClass: dndClass ?? this.dndClass,
      dndRace: dndRace ?? this.dndRace,
      background: background ?? this.background,
      abilityScores: abilityScores ?? this.abilityScores,
      skillProficiencies: skillProficiencies ?? this.skillProficiencies,
      needsCharacterCreation:
          needsCharacterCreation ?? this.needsCharacterCreation,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      currentHealth: currentHealth ?? this.currentHealth,
      maxHealth: maxHealth ?? this.maxHealth,
      hitDiceRemaining: hitDiceRemaining ?? this.hitDiceRemaining,
      currentSpellSlots: currentSpellSlots ?? this.currentSpellSlots,
      conditions: conditions ?? this.conditions,
      exhaustionLevel: exhaustionLevel ?? this.exhaustionLevel,
      tempHp: tempHp ?? this.tempHp,
      deathSaveSuccesses: deathSaveSuccesses ?? this.deathSaveSuccesses,
      deathSaveFailures: deathSaveFailures ?? this.deathSaveFailures,
      hasInspiration: hasInspiration ?? this.hasInspiration,
      concentratingOnSpell: concentratingOnSpell == _sentinel
          ? this.concentratingOnSpell
          : concentratingOnSpell as String?,
      gold: gold ?? this.gold,
      equipment: equipment ?? this.equipment,
      inventory: inventory ?? this.inventory,
      currentLocation: currentLocation ?? this.currentLocation,
      questsCompleted: questsCompleted ?? this.questsCompleted,
      enemiesDefeated: enemiesDefeated ?? this.enemiesDefeated,
      completedQuestIds: completedQuestIds ?? this.completedQuestIds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    dndClass,
    dndRace,
    background,
    abilityScores,
    skillProficiencies,
    needsCharacterCreation,
    level,
    experience,
    currentHealth,
    maxHealth,
    hitDiceRemaining,
    currentSpellSlots,
    conditions,
    exhaustionLevel,
    tempHp,
    deathSaveSuccesses,
    deathSaveFailures,
    hasInspiration,
    concentratingOnSpell,
    gold,
    equipment,
    inventory,
    currentLocation,
    questsCompleted,
    enemiesDefeated,
    completedQuestIds,
  ];
}
