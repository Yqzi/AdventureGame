import 'package:Questborne/models/ability_scores.dart';

// ─────────────────────────────────────────────────────────────
//  D&D RACE ENUM
// ─────────────────────────────────────────────────────────────

/// All 9 D&D 5e Basic Rules character races.
enum DndRace {
  dwarf,
  elf,
  halfling,
  human,
  dragonborn,
  gnome,
  halfElf,
  halfOrc,
  tiefling,
}

extension DndRaceLabel on DndRace {
  String get displayName {
    switch (this) {
      case DndRace.dwarf:
        return 'Dwarf';
      case DndRace.elf:
        return 'Elf';
      case DndRace.halfling:
        return 'Halfling';
      case DndRace.human:
        return 'Human';
      case DndRace.dragonborn:
        return 'Dragonborn';
      case DndRace.gnome:
        return 'Gnome';
      case DndRace.halfElf:
        return 'Half-Elf';
      case DndRace.halfOrc:
        return 'Half-Orc';
      case DndRace.tiefling:
        return 'Tiefling';
    }
  }

  /// Data object for this race.
  DndRaceData get data => DndRaceData.of(this);
}

// ─────────────────────────────────────────────────────────────
//  RACE DATA
// ─────────────────────────────────────────────────────────────

/// Static data for a D&D 5e race.
class DndRaceData {
  /// Ability score bonuses granted by this race.
  final Map<AbilityType, int> abilityBonuses;

  /// Racial traits descriptions (for AI context and UI display).
  final List<String> traits;

  /// Lore description for this race.
  final String description;

  /// Walking speed in feet.
  final int speed;

  const DndRaceData({
    required this.abilityBonuses,
    required this.traits,
    required this.description,
    this.speed = 30,
  });

  static DndRaceData of(DndRace race) => _data[race]!;

  static final Map<DndRace, DndRaceData> _data = {
    DndRace.dwarf: const DndRaceData(
      abilityBonuses: {AbilityType.constitution: 2},
      traits: [
        'Darkvision (60 ft)',
        'Dwarven Resilience (advantage on poison saves, resistance to poison damage)',
        'Stonecunning (double proficiency on stonework History checks)',
        'Tool Proficiency (smith, brewer, or mason tools)',
      ],
      description:
          'Stout, resilient folk of the mountains with a deep connection to craftsmanship and stone.',
      speed: 25,
    ),
    DndRace.elf: const DndRaceData(
      abilityBonuses: {AbilityType.dexterity: 2},
      traits: [
        'Darkvision (60 ft)',
        'Keen Senses (Perception proficiency)',
        'Fey Ancestry (advantage vs charm, immune to magic sleep)',
        'Trance (meditate 4 hours instead of sleeping)',
      ],
      description:
          'Graceful and ancient beings attuned to magic and nature, with lifespans spanning centuries.',
    ),
    DndRace.halfling: const DndRaceData(
      abilityBonuses: {AbilityType.dexterity: 2},
      traits: [
        'Lucky (reroll 1s on attack/ability/save rolls)',
        'Brave (advantage on saves vs frightened)',
        'Halfling Nimbleness (move through spaces of larger creatures)',
        'Naturally Stealthy (hide behind creatures larger than you)',
      ],
      description:
          'Small, cheerful folk with extraordinary luck who find comfort in close-knit communities.',
      speed: 25,
    ),
    DndRace.human: const DndRaceData(
      abilityBonuses: {
        AbilityType.strength: 1,
        AbilityType.dexterity: 1,
        AbilityType.constitution: 1,
        AbilityType.intelligence: 1,
        AbilityType.wisdom: 1,
        AbilityType.charisma: 1,
      },
      traits: [
        'Extra Language (know one additional language)',
        'Versatile (bonus to every ability score)',
      ],
      description:
          'Adaptable and ambitious, humans rise to prominence through their diversity and determination.',
    ),
    DndRace.dragonborn: const DndRaceData(
      abilityBonuses: {AbilityType.strength: 2, AbilityType.charisma: 1},
      traits: [
        'Draconic Ancestry (choose dragon type, determines damage type)',
        'Breath Weapon (exhale destructive energy based on ancestry)',
        'Damage Resistance (to damage type of draconic ancestry)',
      ],
      description:
          'Proud draconic humanoids born with the power of dragons flowing through their veins.',
    ),
    DndRace.gnome: const DndRaceData(
      abilityBonuses: {AbilityType.intelligence: 2},
      traits: [
        'Darkvision (60 ft)',
        'Gnome Cunning (advantage on INT/WIS/CHA saves vs magic)',
        'Natural Illusionist or Tinker (based on subrace)',
        'Speak with Small Beasts (basic communication with tiny animals)',
      ],
      description:
          'Curious and inventive, gnomes approach life with infectious enthusiasm and clever ingenuity.',
      speed: 25,
    ),
    DndRace.halfElf: const DndRaceData(
      abilityBonuses: {
        AbilityType.charisma: 2,
        // +1 to any two other ability scores — chosen during character creation
      },
      traits: [
        'Darkvision (60 ft)',
        'Fey Ancestry (advantage vs charm, immune to magic sleep)',
        'Skill Versatility (proficiency in two skills of your choice)',
        'Two ability scores of your choice increase by 1',
      ],
      description:
          'Children of two worlds, half-elves combine human ambition with elven grace and magical attunement.',
    ),
    DndRace.halfOrc: const DndRaceData(
      abilityBonuses: {AbilityType.strength: 2, AbilityType.constitution: 1},
      traits: [
        'Darkvision (60 ft)',
        'Menacing (Intimidation proficiency)',
        'Relentless Endurance (drop to 1 HP instead of 0 once per long rest)',
        'Savage Attacks (add extra weapon die on critical hits)',
      ],
      description:
          'Fierce and formidable, half-orcs carry orcish tenacity and raw strength in a form that bridges two worlds.',
    ),
    DndRace.tiefling: const DndRaceData(
      abilityBonuses: {AbilityType.intelligence: 1, AbilityType.charisma: 2},
      traits: [
        'Darkvision (60 ft)',
        'Hellish Resistance (resistance to fire damage)',
        'Infernal Legacy (Thaumaturgy cantrip; Hellish Rebuke 1/day at L3; Darkness 1/day at L5)',
      ],
      description:
          'Touched by infernal bloodlines, tieflings bear the legacy of a dark pact made by their ancestors.',
    ),
  };
}
