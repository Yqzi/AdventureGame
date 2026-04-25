import 'package:Questborne/models/ability_scores.dart';

// ─────────────────────────────────────────────────────────────
//  D&D CLASS ENUM
// ─────────────────────────────────────────────────────────────

/// All 12 D&D 5e Basic Rules character classes.
enum DndClass {
  barbarian,
  bard,
  cleric,
  druid,
  fighter,
  monk,
  paladin,
  ranger,
  rogue,
  sorcerer,
  warlock,
  wizard,
}

extension DndClassLabel on DndClass {
  String get displayName {
    switch (this) {
      case DndClass.barbarian:
        return 'Barbarian';
      case DndClass.bard:
        return 'Bard';
      case DndClass.cleric:
        return 'Cleric';
      case DndClass.druid:
        return 'Druid';
      case DndClass.fighter:
        return 'Fighter';
      case DndClass.monk:
        return 'Monk';
      case DndClass.paladin:
        return 'Paladin';
      case DndClass.ranger:
        return 'Ranger';
      case DndClass.rogue:
        return 'Rogue';
      case DndClass.sorcerer:
        return 'Sorcerer';
      case DndClass.warlock:
        return 'Warlock';
      case DndClass.wizard:
        return 'Wizard';
    }
  }

  String get description {
    switch (this) {
      case DndClass.barbarian:
        return 'Primal warrior channeling berserker fury';
      case DndClass.bard:
        return 'Versatile performer wielding magic through art';
      case DndClass.cleric:
        return 'Divine champion serving a deity\'s will';
      case DndClass.druid:
        return 'Nature guardian shaping the wild\'s power';
      case DndClass.fighter:
        return 'Master of weapons and combat tactics';
      case DndClass.monk:
        return 'Martial artist harnessing ki energy';
      case DndClass.paladin:
        return 'Holy warrior bound by a sacred oath';
      case DndClass.ranger:
        return 'Hunter and tracker of the wilderness';
      case DndClass.rogue:
        return 'Cunning trickster striking from the shadows';
      case DndClass.sorcerer:
        return 'Innate spellcaster with raw magical blood';
      case DndClass.warlock:
        return 'Wielder of power granted by an otherworldly patron';
      case DndClass.wizard:
        return 'Scholarly arcanist mastering spells through study';
    }
  }

  /// Data object for this class.
  DndClassData get data => DndClassData.of(this);
}

// ─────────────────────────────────────────────────────────────
//  SPELL SLOT TABLES
// ─────────────────────────────────────────────────────────────

/// Spell slot tables indexed by [level - 1] (0-based).
/// Each inner list is [1st-level slots, 2nd, 3rd, ..., 9th].
class _SpellSlotTables {
  // Full-caster progression (Bard, Cleric, Druid, Sorcerer, Wizard).
  static const List<List<int>> fullCaster = [
    [2, 0, 0, 0, 0, 0, 0, 0, 0], // Level 1
    [3, 0, 0, 0, 0, 0, 0, 0, 0], // Level 2
    [4, 2, 0, 0, 0, 0, 0, 0, 0], // Level 3
    [4, 3, 0, 0, 0, 0, 0, 0, 0], // Level 4
    [4, 3, 2, 0, 0, 0, 0, 0, 0], // Level 5
    [4, 3, 3, 0, 0, 0, 0, 0, 0], // Level 6
    [4, 3, 3, 1, 0, 0, 0, 0, 0], // Level 7
    [4, 3, 3, 2, 0, 0, 0, 0, 0], // Level 8
    [4, 3, 3, 3, 1, 0, 0, 0, 0], // Level 9
    [4, 3, 3, 3, 2, 0, 0, 0, 0], // Level 10
    [4, 3, 3, 3, 2, 1, 0, 0, 0], // Level 11
    [4, 3, 3, 3, 2, 1, 0, 0, 0], // Level 12
    [4, 3, 3, 3, 2, 1, 1, 0, 0], // Level 13
    [4, 3, 3, 3, 2, 1, 1, 0, 0], // Level 14
    [4, 3, 3, 3, 2, 1, 1, 1, 0], // Level 15
    [4, 3, 3, 3, 2, 1, 1, 1, 0], // Level 16
    [4, 3, 3, 3, 2, 1, 1, 1, 1], // Level 17
    [4, 3, 3, 3, 3, 1, 1, 1, 1], // Level 18
    [4, 3, 3, 3, 3, 2, 1, 1, 1], // Level 19
    [4, 3, 3, 3, 3, 2, 2, 1, 1], // Level 20
  ];

  // Half-caster progression (Paladin, Ranger). Only 5 spell levels.
  static const List<List<int>> halfCaster = [
    [0, 0, 0, 0, 0], // Level 1 (no slots)
    [2, 0, 0, 0, 0], // Level 2
    [3, 0, 0, 0, 0], // Level 3
    [3, 0, 0, 0, 0], // Level 4
    [4, 2, 0, 0, 0], // Level 5
    [4, 2, 0, 0, 0], // Level 6
    [4, 3, 0, 0, 0], // Level 7
    [4, 3, 0, 0, 0], // Level 8
    [4, 3, 2, 0, 0], // Level 9
    [4, 3, 2, 0, 0], // Level 10
    [4, 3, 3, 0, 0], // Level 11
    [4, 3, 3, 0, 0], // Level 12
    [4, 3, 3, 1, 0], // Level 13
    [4, 3, 3, 1, 0], // Level 14
    [4, 3, 3, 2, 0], // Level 15
    [4, 3, 3, 2, 0], // Level 16
    [4, 3, 3, 3, 1], // Level 17
    [4, 3, 3, 3, 1], // Level 18
    [4, 3, 3, 3, 2], // Level 19
    [4, 3, 3, 3, 2], // Level 20
  ];

  // Warlock Pact Magic: [slotCount, slotLevel] pairs per character level.
  // Represented as a 2-element list [slots, slotSpellLevel].
  static const List<List<int>> warlockPactMagic = [
    [1, 1], // Level 1
    [2, 1], // Level 2
    [2, 2], // Level 3
    [2, 2], // Level 4
    [2, 3], // Level 5
    [2, 3], // Level 6
    [2, 4], // Level 7
    [2, 4], // Level 8
    [2, 5], // Level 9
    [2, 5], // Level 10
    [3, 5], // Level 11
    [3, 5], // Level 12
    [3, 5], // Level 13
    [3, 5], // Level 14
    [3, 5], // Level 15
    [3, 5], // Level 16
    [4, 5], // Level 17
    [4, 5], // Level 18
    [4, 5], // Level 19
    [4, 5], // Level 20
  ];

  // Non-casters (Barbarian, Fighter, Monk, Rogue): no spell slots.
  static const List<int> none = [0, 0, 0, 0, 0, 0, 0, 0, 0];
}

// ─────────────────────────────────────────────────────────────
//  CLASS DATA
// ─────────────────────────────────────────────────────────────

/// Static data for a D&D 5e class.
class DndClassData {
  /// Hit die sides (e.g. 12 for Barbarian = d12).
  final int hitDie;

  /// Primary ability score(s) for this class.
  final List<AbilityType> primaryAbilities;

  /// Saving throw proficiencies granted at level 1.
  final List<AbilityType> savingThrowProficiencies;

  /// Which ability score drives spellcasting. Null for non-casters.
  final AbilityType? spellcastingAbility;

  /// Whether this class uses Warlock Pact Magic (short-rest slots).
  final bool isWarlockCaster;

  /// Whether this class has spell slots at all.
  final bool isSpellcaster;

  /// Average HP gained per level after 1st (= hitDie/2 + 1).
  int get hpPerLevel => hitDie ~/ 2 + 1;

  /// HP at level 1 = hitDie max + CON modifier.
  int startingHp(int conModifier) => hitDie + conModifier;

  /// Key class features description (for AI context).
  final String keyFeatures;

  /// Skill choices available to this class at creation.
  final int skillChoices;

  const DndClassData({
    required this.hitDie,
    required this.primaryAbilities,
    required this.savingThrowProficiencies,
    this.spellcastingAbility,
    this.isWarlockCaster = false,
    required this.isSpellcaster,
    required this.keyFeatures,
    required this.skillChoices,
  });

  /// Returns the spell slot list for a given character [level] (1-based).
  /// Returns a 9-element list of slot counts per spell level.
  /// For Warlocks, converts pact magic into the same format.
  List<int> spellSlotsAtLevel(int level) {
    if (!isSpellcaster) return List.filled(9, 0);
    final idx = (level - 1).clamp(0, 19);

    if (isWarlockCaster) {
      final pact = _SpellSlotTables.warlockPactMagic[idx];
      // pact[0] = slot count, pact[1] = slot spell level (1-based)
      final slots = List.filled(9, 0);
      slots[pact[1] - 1] = pact[0];
      return slots;
    }

    // Half-casters: only 5 spell levels, pad to 9.
    if (identical(this, DndClassData.of(DndClass.paladin)) ||
        identical(this, DndClassData.of(DndClass.ranger))) {
      final halfSlots = _SpellSlotTables.halfCaster[idx];
      return [...halfSlots, 0, 0, 0, 0];
    }

    return _SpellSlotTables.fullCaster[idx];
  }

  /// All static class data, keyed by [DndClass].
  static DndClassData of(DndClass cls) => _data[cls]!;

  static final Map<DndClass, DndClassData> _data = {
    DndClass.barbarian: const DndClassData(
      hitDie: 12,
      primaryAbilities: [AbilityType.strength],
      savingThrowProficiencies: [
        AbilityType.strength,
        AbilityType.constitution,
      ],
      isSpellcaster: false,
      skillChoices: 2,
      keyFeatures:
          'Rage (bonus damage, resistance to physical damage), Unarmored Defense (10+DEX+CON AC), Reckless Attack (advantage on STR attacks), Danger Sense (advantage on DEX saves)',
    ),
    DndClass.bard: const DndClassData(
      hitDie: 8,
      primaryAbilities: [AbilityType.charisma],
      savingThrowProficiencies: [AbilityType.dexterity, AbilityType.charisma],
      spellcastingAbility: AbilityType.charisma,
      isSpellcaster: true,
      skillChoices: 3,
      keyFeatures:
          'Bardic Inspiration (d6 die to add to others\' rolls), Jack of All Trades (half proficiency to unproficient skills), Song of Rest (extra HP on short rest)',
    ),
    DndClass.cleric: const DndClassData(
      hitDie: 8,
      primaryAbilities: [AbilityType.wisdom],
      savingThrowProficiencies: [AbilityType.wisdom, AbilityType.charisma],
      spellcastingAbility: AbilityType.wisdom,
      isSpellcaster: true,
      skillChoices: 2,
      keyFeatures:
          'Divine Domain subclass, Channel Divinity (Turn Undead, Divine Strike), prepared spells from full list, can prepare all healing spells',
    ),
    DndClass.druid: const DndClassData(
      hitDie: 8,
      primaryAbilities: [AbilityType.wisdom],
      savingThrowProficiencies: [AbilityType.intelligence, AbilityType.wisdom],
      spellcastingAbility: AbilityType.wisdom,
      isSpellcaster: true,
      skillChoices: 2,
      keyFeatures:
          'Wild Shape (transform into beasts), Druid Circle subclass, prepared spells from druid list, nature magic and elemental control',
    ),
    DndClass.fighter: const DndClassData(
      hitDie: 10,
      primaryAbilities: [AbilityType.strength, AbilityType.dexterity],
      savingThrowProficiencies: [
        AbilityType.strength,
        AbilityType.constitution,
      ],
      isSpellcaster: false,
      skillChoices: 2,
      keyFeatures:
          'Fighting Style, Second Wind (1d10+level HP recovery), Action Surge (extra action 1/rest), Extra Attack at level 5',
    ),
    DndClass.monk: const DndClassData(
      hitDie: 8,
      primaryAbilities: [AbilityType.dexterity, AbilityType.wisdom],
      savingThrowProficiencies: [AbilityType.strength, AbilityType.dexterity],
      isSpellcaster: false,
      skillChoices: 2,
      keyFeatures:
          'Unarmored Defense (10+DEX+WIS AC), Martial Arts (unarmed strikes), Ki points (Flurry of Blows, Patient Defense, Step of the Wind), Stunning Strike',
    ),
    DndClass.paladin: const DndClassData(
      hitDie: 10,
      primaryAbilities: [AbilityType.strength, AbilityType.charisma],
      savingThrowProficiencies: [AbilityType.wisdom, AbilityType.charisma],
      spellcastingAbility: AbilityType.charisma,
      isSpellcaster: true,
      skillChoices: 2,
      keyFeatures:
          'Divine Smite (extra radiant damage on hit), Lay on Hands (HP pool), Sacred Oath subclass, Aura of Protection (+CHA to saves within 10ft)',
    ),
    DndClass.ranger: const DndClassData(
      hitDie: 10,
      primaryAbilities: [AbilityType.dexterity, AbilityType.wisdom],
      savingThrowProficiencies: [AbilityType.strength, AbilityType.dexterity],
      spellcastingAbility: AbilityType.wisdom,
      isSpellcaster: true,
      skillChoices: 3,
      keyFeatures:
          'Favored Enemy, Natural Explorer (favored terrain), Primeval Awareness, Extra Attack, Ranger subclass (Hunter, Beast Master)',
    ),
    DndClass.rogue: const DndClassData(
      hitDie: 8,
      primaryAbilities: [AbilityType.dexterity],
      savingThrowProficiencies: [
        AbilityType.dexterity,
        AbilityType.intelligence,
      ],
      isSpellcaster: false,
      skillChoices: 4,
      keyFeatures:
          'Sneak Attack (extra damage when advantaged or flanking), Thieves\' Cant, Cunning Action (dash/disengage/hide as bonus), Uncanny Dodge, Evasion',
    ),
    DndClass.sorcerer: const DndClassData(
      hitDie: 6,
      primaryAbilities: [AbilityType.charisma],
      savingThrowProficiencies: [
        AbilityType.constitution,
        AbilityType.charisma,
      ],
      spellcastingAbility: AbilityType.charisma,
      isSpellcaster: true,
      skillChoices: 2,
      keyFeatures:
          'Sorcerous Origin (innate magic source), Sorcery Points, Metamagic (modify spells: Quicken, Twin, Empower, etc.), Font of Magic',
    ),
    DndClass.warlock: const DndClassData(
      hitDie: 8,
      primaryAbilities: [AbilityType.charisma],
      savingThrowProficiencies: [AbilityType.wisdom, AbilityType.charisma],
      spellcastingAbility: AbilityType.charisma,
      isWarlockCaster: true,
      isSpellcaster: true,
      skillChoices: 2,
      keyFeatures:
          'Otherworldly Patron, Pact Magic (short-rest spell slots, always highest level), Eldritch Invocations, Pact Boon (Chain/Blade/Tome), Mystic Arcanum',
    ),
    DndClass.wizard: const DndClassData(
      hitDie: 6,
      primaryAbilities: [AbilityType.intelligence],
      savingThrowProficiencies: [AbilityType.intelligence, AbilityType.wisdom],
      spellcastingAbility: AbilityType.intelligence,
      isSpellcaster: true,
      skillChoices: 2,
      keyFeatures:
          'Spellbook (learn and prepare spells), Arcane Recovery (recover slots on short rest), Arcane Tradition subclass, Spell Mastery at level 18',
    ),
  };
}

// ─────────────────────────────────────────────────────────────
//  PROFICIENCY BONUS TABLE
// ─────────────────────────────────────────────────────────────

/// Returns the D&D 5e proficiency bonus for a given character level (1–20).
int proficiencyBonusForLevel(int level) {
  if (level <= 4) return 2;
  if (level <= 8) return 3;
  if (level <= 12) return 4;
  if (level <= 16) return 5;
  return 6;
}
