import 'package:Questborne/components/cards.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  ITEM TYPE
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

enum ItemType { weapon, armor, accessory, relic, spell }

extension ItemTypeExtension on ItemType {
  String get label {
    switch (this) {
      case ItemType.weapon:
        return 'WEAPON';
      case ItemType.armor:
        return 'ARMOR';
      case ItemType.accessory:
        return 'ACCESSORY';
      case ItemType.relic:
        return 'RELIC';
      case ItemType.spell:
        return 'SPELL';
    }
  }

  String get icon {
    switch (this) {
      case ItemType.weapon:
        return 'âš”ï¸';
      case ItemType.armor:
        return 'ðŸ›¡ï¸';
      case ItemType.accessory:
        return 'ðŸ’';
      case ItemType.relic:
        return 'ðŸ”®';
      case ItemType.spell:
        return '✨';
    }
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  ITEM MODEL
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class Item {
  final String id;
  final String name;
  final String description; // Lore / flavor text
  final ItemType type;
  final Rarity rarity;
  final int level; // Required level 1â€“100
  final int price; // Gold cost in the shop

  // â”€â”€ Stat bonuses when equipped â”€â”€
  final int attack;
  final int defense;
  final int magic;
  final int agility;
  final int health; // Bonus HP

  // â”€â”€ Special passive / active effect â”€â”€
  final String effect;

  final int manaCost;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.level,
    required this.price,
    this.attack = 0,
    this.defense = 0,
    this.magic = 0,
    this.agility = 0,
    this.health = 0,
    this.effect = '',
    this.manaCost = 0,
  });

  /// Human-readable stat summary shown on shop cards.
  String get statSummary {
    final parts = <String>[];
    if (manaCost > 0) parts.add('$manaCost MP');
    if (attack > 0) parts.add('+$attack ATK');
    if (defense > 0) parts.add('+$defense DEF');
    if (magic > 0) parts.add('+$magic MAG');
    if (agility > 0) parts.add('+$agility AGI');
    if (health > 0) parts.add('+$health HP');
    if (effect.isNotEmpty) parts.add(effect);
    return parts.join('  ·  ');
  }

  /// Formatted price string.
  String get priceLabel => '$price Gold';

  /// Path to the item's image asset, derived from its id.
  String get imagePath =>
      'assets/images/items/$id.${type == ItemType.spell ? 'jpg' : 'png'}';

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  SHOP PROGRESSION
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  Each entry maps to a quest-progression set index from
  //  Quest.progressionOrder.  When set N is completed the items
  //  in shopProgression[N+1] unlock.  Set 0 is available from
  //  the start.
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  static const List<List<String>> shopProgression = [
    // â”€â”€ Phase 1: First Steps (sets 0-3) â”€â”€
    ['wpn_001', 'arm_001', 'acc_001', 'rel_001', 'spl_001'], // Start â†’ Lv 1
    [
      'wpn_002',
      'arm_002',
      'acc_002',
      'rel_002',
      'spl_002',
    ], // Set 0 done â†’ Lv 5
    [], // Set 1
    [], // Set 2
    // â”€â”€ Phase 2: Rising Action (sets 4-5) â”€â”€
    [
      'wpn_003',
      'arm_003',
      'acc_003',
      'rel_003',
      'spl_003',
    ], // Set 3 done â†’ Lv 10
    [], // Set 4
    // â”€â”€ Phase 3: The Mystery Deepens (sets 6-8) â”€â”€
    [
      'wpn_004',
      'arm_004',
      'acc_004',
      'rel_004',
      'spl_004',
    ], // Set 5 done â†’ Lv 15
    [
      'wpn_005',
      'arm_005',
      'acc_005',
      'rel_005',
      'spl_005',
    ], // Set 6 done â†’ Lv 20
    [], // Set 7
    // â”€â”€ Phase 4: Mid-Game (sets 9-10) â”€â”€
    [
      'wpn_006',
      'arm_006',
      'acc_006',
      'rel_006',
      'spl_006',
    ], // Set 8 done â†’ Lv 25
    [], // Set 9
    // â”€â”€ Phase 5: Escalation (sets 11-13) â”€â”€
    [
      'wpn_007',
      'arm_007',
      'acc_007',
      'rel_007',
      'spl_007',
    ], // Set 10 done â†’ Lv 30
    [
      'wpn_008',
      'arm_008',
      'acc_008',
      'rel_008',
      'spl_008',
    ], // Set 11 done â†’ Lv 35
    [], // Set 12
    // â”€â”€ Phase 6: High Stakes (sets 14-15) â”€â”€
    [
      'wpn_009',
      'arm_009',
      'acc_009',
      'rel_009',
      'spl_009',
    ], // Set 13 done â†’ Lv 40
    [], // Set 14
    // â”€â”€ Phase 7: Deep Lore (sets 16-17) â”€â”€
    [
      'wpn_010',
      'arm_010',
      'acc_010',
      'rel_010',
      'spl_010',
    ], // Set 15 done â†’ Lv 50
    [
      'wpn_011',
      'arm_011',
      'acc_011',
      'rel_011',
      'spl_011',
    ], // Set 16 done â†’ Lv 60
    // â”€â”€ Phase 8: Ancient Threats (sets 18-19) â”€â”€
    [
      'wpn_012',
      'arm_012',
      'acc_012',
      'rel_012',
      'spl_012',
    ], // Set 17 done â†’ Lv 70
    [], // Set 18
    // â”€â”€ Phase 9: Endgame (sets 20-21) â”€â”€
    [
      'wpn_013',
      'arm_013',
      'acc_013',
      'rel_013',
      'spl_013',
    ], // Set 19 done â†’ Lv 80
    [
      'wpn_014',
      'arm_014',
      'acc_014',
      'rel_014',
      'spl_014',
    ], // Set 20 done â†’ Lv 90
    // â”€â”€ Finale (set 22) â”€â”€
    [
      'wpn_015',
      'arm_015',
      'acc_015',
      'rel_015',
      'spl_015',
    ], // Set 21 done â†’ Lv 100
  ];

  /// Returns all shop items unlocked for the given number of completed
  /// quest sets.  Set 0 items are always available.
  static List<Item> progressionShopItems(int completedSets) {
    final itemLookup = {for (final i in allItems) i.id: i};
    final available = <Item>[];
    final limit = (completedSets + 1).clamp(0, shopProgression.length);
    for (int i = 0; i < limit; i++) {
      for (final id in shopProgression[i]) {
        final item = itemLookup[id];
        if (item != null) available.add(item);
      }
    }
    return available;
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  ALL GAME ITEMS  â€”  Lore-rooted across four sources:
//    GLOBAL  (Sundering Â· Hollow Â· Radiant One Â· Deep Mother Â· Death)
//    FOREST  (Thornveil Â· Vaelithi Â· World Tree Â· Fey Courts Â· Pale Root)
//    CAVE    (Hollows Â· Ossborn Â· Forge Spirit Â· Warden-craft Â· Devourer)
//    RUINS   (Valdris Â· Tithebound Â· Nameless Choir Â· Severance Â· Morvaine)
//
//  Prices set so questline gold alone covers ~2 of 4 items per tier.
//  Players grind repeatable side quests for the rest.
//  Total items: ~286,800g. Total questline: 199,320g. Deficit from repeatables.
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

final List<Item> allItems = [
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  W E A P O N S
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  // â”€â”€ wpn_001 Â· GLOBAL Â· The Sundering â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_001',
    name: 'Sundering Shard Knife',
    description:
        'A crude knife chipped from stone that fell during the war of the '
        'Firstborn Gods. It hums faintly when held â€” an echo of the blow '
        'that cracked reality itself.',
    type: ItemType.weapon,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    attack: 8,
    effect:
        'Shard Resonance: deals 3% bonus damage near areas corrupted by the Hollow.',
  ),

  // â”€â”€ wpn_002 Â· FOREST Â· Thornveil â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_002',
    name: 'Thornveil Stalker Bow',
    description:
        'A short hunting bow of living thornwood, its limbs still bearing '
        'green buds that never bloom. The Thornveil gives these willingly '
        'to mortal stalkers it tolerates â€” the string hums a note only '
        'forest creatures hear, and they run.',
    type: ItemType.weapon,
    rarity: Rarity.common,
    level: 5,
    price: 100,
    attack: 12,
    agility: 5,
    effect: '+10% damage against Fey creatures.',
  ),

  // â”€â”€ wpn_003 Â· CAVE Â· The Hollows â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_003',
    name: 'Hollows Warden Blade',
    description:
        'A short, broad-bladed sword of dark iron etched with glowing '
        'warden runes along the fuller. Carried by miners who work the '
        'upper Hollows â€” where the things in the dark require more than '
        'a lantern.',
    type: ItemType.weapon,
    rarity: Rarity.common,
    level: 10,
    price: 200,
    attack: 15,
    defense: 5,
    effect:
        'Warden Rune: reveals hidden passages in the Hollows. +5% damage to mineral-based enemies.',
  ),

  // â”€â”€ wpn_004 Â· RUINS Â· Tithebound â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_004',
    name: 'Tithebound Ritual Blade',
    description:
        'A long, thin blade of grey metal carried by the Tithebound â€” the '
        'ash-skinned wardens who patrol the Valdris ruins in loops they '
        'cannot explain. This one was dropped by a sentinel who stopped '
        'mid-patrol and simply forgot how to move.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 15,
    price: 400,
    attack: 25,
    agility: 10,
    effect:
        'Hollow Strike: 15% chance attacks ignore target\'s defense entirely.',
  ),

  // â”€â”€ wpn_005 Â· GLOBAL Â· The Hollow â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_005',
    name: 'Hollow-Touched Falchion',
    description:
        'A blade left too long near a wound in reality where the Hollow '
        'seeps through. The void-stuff has eaten into the steel, making it '
        'lighter and impossibly sharp â€” but the metal crumbles a little '
        'more each day.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 20,
    price: 500,
    attack: 32,
    agility: 12,
    effect:
        'Void Edge: attacks deal 10% bonus damage. The Hollow hungers through the blade.',
  ),

  // â”€â”€ wpn_006 Â· FOREST Â· Pale Root â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_006',
    name: 'Pale Root Whisper Crossbow',
    description:
        'A compact crossbow of bleached white wood, its rail inlaid with '
        'crushed petals that deaden all sound. The Pale Root use these '
        'from the High Canopy â€” two lords fell before anyone heard '
        'the bolt. The Verdant Court pretends these don\'t exist.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 25,
    price: 800,
    attack: 30,
    agility: 18,
    effect:
        'Assassination: critical hits deal 35% bonus damage. +12% crit chance from stealth.',
  ),

  // â”€â”€ wpn_007 Â· CAVE Â· Warden-Craft â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_007',
    name: 'Warden-Craft Halberd',
    description:
        'Forged using techniques inherited through the Rite of Grafting â€” '
        'patterns no living mind devised, hammered from memory stored in '
        'dead wardens\' bones. The rune sequence along the shaft matches '
        'a binding prayer that sealed something in the mid-depths.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 30,
    price: 1200,
    attack: 50,
    defense: 10,
    effect:
        'Binding Strike: 20% chance to immobilize target for 1 turn. Deals double damage to escaped prisoners of the deep.',
  ),

  // â”€â”€ wpn_008 Â· RUINS Â· Morvaine â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_008',
    name: 'Morvaine\'s Staff-Blade',
    description:
        'The walking staff of Morvaine, the apprentice whose pursuit of '
        'lichdom shattered Valdris from within â€” or so the histories claim. '
        'The wood is petrified, and the crystal at its head shows a kingdom '
        'that looks nothing like ruins.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 35,
    price: 1600,
    attack: 40,
    magic: 30,
    effect:
        'Lich\'s Ambition: spell attacks deal 15% bonus damage. On kill, restore 5% max HP.',
  ),

  // â”€â”€ wpn_009 Â· GLOBAL Â· Death â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_009',
    name: 'Death\'s Tithe',
    description:
        'A scythe that belonged to no reaper â€” it simply appeared where '
        'Death had recently passed. Death is eldest of the three surviving '
        'gods, walks both worlds freely, and answers to no prayer. This '
        'blade carries that same cold indifference.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 40,
    price: 2000,
    attack: 72,
    magic: 20,
    effect:
        'Inevitability: ignores 15% of target\'s DEF and magic resistance. Cannot be disarmed.',
  ),

  // â”€â”€ wpn_010 Â· FOREST Â· World Tree â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_010',
    name: 'Sinew of the World Tree',
    description:
        'A longbow strung with root-fiber from the World Tree itself â€” '
        'the miles-high titan whose roots pierce the underworld. Arrows '
        'fired from this bow bend toward living things, as if the Tree '
        'still hungers for what grows beyond its reach.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 50,
    price: 2800,
    attack: 85,
    magic: 25,
    health: 30,
    effect:
        'Rootbound: arrows entangle targets (âˆ’15% AGI for 2 turns). Regenerate 2% HP per turn in forest areas.',
  ),

  // â”€â”€ wpn_011 Â· CAVE Â· Forge Spirit â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_011',
    name: 'Forge Spirit\'s Greathammer',
    description:
        'A hammer that radiates heat from the core of the world. The Forge '
        'Spirit who tends the ancient bindings used this to repair '
        'ward-stones â€” and to crush anything that emerged when those '
        'repairs came too late.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 60,
    price: 5000,
    attack: 115,
    defense: 20,
    effect:
        'Seal Breaker: attacks shatter magical barriers. +25% damage against bound or sealed enemies.',
  ),

  // â”€â”€ wpn_012 Â· RUINS Â· Severance â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_012',
    name: 'Severance Edge',
    description:
        'A blade forged from the dark glass that paves the streets of '
        'Valdris â€” not the ruins, but the living kingdom folded into a '
        'dimension that should not exist. The glass reflects corridors '
        'you\'ve never walked and a sky with no stars.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 70,
    price: 7000,
    attack: 155,
    magic: 40,
    effect:
        'Dimensional Cut: ignores 25% DEF and magic resistance. 10% chance to tear reality, dealing AoE damage.',
  ),

  // â”€â”€ wpn_013 Â· FOREST Â· Bloom Rite / Vaelithi â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_013',
    name: 'Seylith\'s Bloom Arc',
    description:
        'A ceremonial bow grown in the World Tree\'s root-hollows during '
        'the Bloom Rite â€” the trial that determines Vaelithi succession. '
        'Its string sprouts thorn-arrows on its own. Queen Seylith drew '
        'this arc for four centuries. It has never missed.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 80,
    price: 10000,
    attack: 185,
    agility: 35,
    magic: 20,
    effect:
        'Undying Bloom: the bow regenerates arrows between battles. Crits cause roots to erupt from wounds, dealing 40% bonus damage over 3 turns.',
  ),

  // â”€â”€ wpn_014 Â· CAVE Â· Deep Mother â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_014',
    name: 'Deep Mother\'s Fang',
    description:
        'A stalactite ripped from directly above the Heart of the '
        'Mountain â€” the living organ of stone and magma that beats in the '
        'deepest Hollows. Some scholars believe it is the Deep Mother\'s '
        'own heart. This fang still drips with molten spite.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 90,
    price: 16000,
    attack: 220,
    defense: 30,
    health: -40,
    effect:
        'Magma Vein: attacks deal 20% bonus fire damage and inflict Burn. Costs 2% max HP per hit, but burn damage heals the wielder.',
  ),

  // â”€â”€ wpn_015 Â· RUINS Â· Azrathar / Valdris â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'wpn_015',
    name: 'Azrathar\'s Covenant Blade',
    description:
        'The weapon the demon Azrathar once offered Valdris in exchange '
        'for passage into the mortal world. The histories blame Azrathar '
        'for the kingdom\'s fall â€” but the blade was never used. Whatever '
        'destroyed Valdris was not a demon. It was something far worse.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 100,
    price: 24000,
    attack: 270,
    magic: 50,
    agility: 30,
    health: 100,
    effect:
        'Covenant: ignores ALL enemy resistances. On kill, absorb the target\'s strongest stat permanently (+1, stacks up to 20).',
  ),

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  A R M O R
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  // â”€â”€ arm_001 Â· GLOBAL Â· The Sundering â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_001',
    name: 'Sundering-Cloth Wrap',
    description:
        'Strips of ancient fabric salvaged from a battlefield older than '
        'any kingdom. The cloth was woven before the Firstborn Gods '
        'warred â€” when creation was still one piece.',
    type: ItemType.armor,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    defense: 5,
    health: 10,
    effect: 'Ancestral Thread: reduces physical damage taken by 2%.',
  ),

  // â”€â”€ arm_002 Â· CAVE Â· Smugglers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_002',
    name: 'Smuggler\'s Tunnel Leathers',
    description:
        'Hardened leather stitched by the smugglers who run contraband '
        'through the upper Hollows by torchlight. Stained with '
        'bioluminescent fungal residue that never quite washes out.',
    type: ItemType.armor,
    rarity: Rarity.common,
    level: 5,
    price: 100,
    defense: 10,
    agility: 8,
    effect:
        'Cave Runner: +5% evasion in underground areas. Faintly glows in darkness.',
  ),

  // â”€â”€ arm_003 Â· FOREST Â· Thornveil â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_003',
    name: 'Thornveil Bark Cuirass',
    description:
        'A chestplate shaped from fallen bark of the Thornveil. The forest '
        'gave this wood freely â€” a tree struck by lightning, already dead. '
        'Even in death, the bark resists rot with stubborn, living defiance.',
    type: ItemType.armor,
    rarity: Rarity.common,
    level: 10,
    price: 200,
    defense: 18,
    health: 30,
    effect:
        'Forest\'s Memory: reduces damage from plant and fey creatures by 10%.',
  ),

  // â”€â”€ arm_004 Â· RUINS Â· Valdris Upper â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_004',
    name: 'Valdris Grave-Scavenger\'s Coat',
    description:
        'Patched leather worn by those foolish enough to loot the upper '
        'ruins of Valdris. Every pocket rattles with pilfered trinkets '
        'that whisper when the wind is wrong. Scholar Veyra condemns '
        'scavengers. They wear her disapproval like a badge.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 15,
    price: 400,
    defense: 28,
    agility: 8,
    health: 40,
    effect:
        'Scavenger\'s Luck: +8% gold drop rate. 5% chance to resist curse effects from Valdris relics.',
  ),

  // â”€â”€ arm_005 Â· GLOBAL Â· The Hollow â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_005',
    name: 'Hollow-Scarred Plate',
    description:
        'Steel plate warped by proximity to the Hollow â€” the '
        'void-corruption that seeps through reality\'s cracks. The metal '
        'bends at angles that shouldn\'t hold, yet the armor is lighter '
        'and harder than any forge could make it.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 20,
    price: 500,
    defense: 38,
    attack: 8,
    health: 60,
    effect:
        'Void Warp: 8% chance to deflect attacks through micro-rifts. Takes 5% extra damage from holy sources.',
  ),

  // â”€â”€ arm_006 Â· CAVE Â· Ossborn â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_006',
    name: 'Ossborn Grafted Shell',
    description:
        'Armor assembled from shed bone-plates of the Ossborn â€” the '
        'eyeless monks who carry dead wardens\' memories in their fused '
        'skeletons. Each plate hums with a different frequency, as if '
        'remembering a different voice.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 25,
    price: 800,
    defense: 35,
    magic: 15,
    health: 70,
    effect:
        'Grafted Memory: immune to confusion effects. 10% chance to reflexively dodge (inherited warden instinct).',
  ),

  // â”€â”€ arm_007 Â· FOREST Â· Verdant Court â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_007',
    name: 'Verdant Court Ceremonial Mail',
    description:
        'Chainmail of green-gold alloy, each ring shaped like a tiny leaf. '
        'Worn by the twelve High Canopy lords of Vaelith\'s Verdant '
        'Court â€” before two were assassinated by the Pale Root. This set '
        'belonged to one of the fallen.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 30,
    price: 1200,
    defense: 52,
    agility: 12,
    health: 80,
    effect:
        'Courtly Grace: immune to Fear effects. +10% magic resistance. Elvish light reveals hidden foes.',
  ),

  // â”€â”€ arm_008 Â· RUINS Â· Tithebound â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_008',
    name: 'Tithebound Sentinel Plate',
    description:
        'Chitinous armor grown â€” not forged â€” by Tithebound sentinels in '
        'the deep ruins. Made from their own shed skin, layered over '
        'centuries. Ash-grey and warm to the touch, as if something inside '
        'it still remembers being alive.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 35,
    price: 1600,
    defense: 55,
    health: 100,
    agility: 15,
    effect:
        'Hollow Warden: +15% damage resistance while standing ground. Incoming attacks echo faintly, warning of ambush.',
  ),

  // â”€â”€ arm_009 Â· GLOBAL Â· Radiant One â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_009',
    name: 'Radiant One\'s Blessed Mail',
    description:
        'Plate armor blessed by clerics who maintain the binding seals in '
        'the Radiant One\'s name. The god who forged the sun declared '
        'dominion over the surface world â€” this armor carries that decree '
        'hammered into every rivet.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 40,
    price: 2000,
    defense: 70,
    health: 150,
    attack: 10,
    effect:
        'Solar Ward: immune to darkness and shadow effects. Regenerate 2% HP per turn in daylight or surface areas.',
  ),

  // â”€â”€ arm_010 Â· CAVE Â· Deep Mother â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_010',
    name: 'Deep Mother\'s Carapace',
    description:
        'Chitin harvested from creatures born too close to the Heart of '
        'the Mountain. The Deep Mother burrowed into the earth\'s core and '
        'claimed all beneath stone â€” these shells carry her territorial '
        'fury, hardening under pressure.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 50,
    price: 2800,
    defense: 92,
    health: 180,
    magic: 20,
    effect:
        'Pressure Skin: DEF increases by 1% for each 10% HP lost. Immune to fire and magma damage.',
  ),

  // â”€â”€ arm_011 Â· FOREST Â· Thornwall â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_011',
    name: 'Thornwall Living Armor',
    description:
        'A suit grown from a fragment of the Thornwall itself â€” the '
        'enchanted barrier of briar that seals Vaelith from the mortal '
        'world. Humans who cross the Thornwall don\'t come back. This '
        'armor was pried from the wall\'s edge, and it has not stopped '
        'growing.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 60,
    price: 5000,
    defense: 112,
    health: 200,
    attack: 20,
    effect:
        'Living Barrier: regenerate 3% max HP per turn. Thorns deal 8% recoil damage to melee attackers.',
  ),

  // â”€â”€ arm_012 Â· GLOBAL Â· Death â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_012',
    name: 'Death\'s Walking Shroud',
    description:
        'A cloak of absolute black that weighs nothing and fits everyone. '
        'Death is eldest of the three surviving gods and walks both worlds '
        'freely. This shroud once draped something that stood in Death\'s '
        'shadow â€” and the shadow never quite left it.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 70,
    price: 7000,
    defense: 155,
    health: 300,
    agility: 25,
    effect:
        'Death\'s Passage: ignore environmental hazards. 15% chance to negate fatal damage and survive with 1 HP.',
  ),

  // â”€â”€ arm_013 Â· RUINS Â· Court Arcanists â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_013',
    name: 'Court Arcanist\'s Vestments',
    description:
        'Robes worn by the Valdris Court Arcanists who cast the '
        'Severance â€” the spell that pulled an entire kingdom into a '
        'folded dimension. The Arcanists were consumed by their own '
        'working. The robes remember the incantation in every threaded '
        'sigil.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 80,
    price: 10000,
    defense: 180,
    magic: 45,
    health: 350,
    effect:
        'Severance Echo: all spell damage reduced by 20%. Once per battle, cast a ward that absorbs damage equal to 30% max HP.',
  ),

  // â”€â”€ arm_014 Â· CAVE Â· Titans â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_014',
    name: 'Titan\'s Binding Plate',
    description:
        'Armor forged from the actual chains that bound a titan in the '
        'mid-depths during the Sundering. The titan still slumbers '
        'beneath â€” and the chains still tighten when something stirs in '
        'its prison. Wearing them, you feel the weight of holding a god '
        'in place.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 90,
    price: 16000,
    defense: 210,
    health: 400,
    attack: 30,
    effect:
        'Unyielding Chains: immune to knockback, stun, and forced movement. Reduces all incoming damage by 15%.',
  ),

  // â”€â”€ arm_015 Â· RUINS Â· Folded Dimension â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'arm_015',
    name: 'Netherveil of the Folded Kingdom',
    description:
        'A garment woven from the membrane between the mortal world and '
        'the folded dimension where Valdris still lives. It smells of '
        'still air from a kingdom where time loops, and bends around the '
        'wearer like reality bending to avoid the Severance.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 100,
    price: 24000,
    defense: 260,
    health: 500,
    magic: 40,
    agility: 30,
    effect:
        'Dimensional Phase: 20% chance to phase through attacks entirely. Immune to all status effects. Stats grow by 1% per turn in combat (max 15%).',
  ),

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  A C C E S S O R I E S
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  // â”€â”€ acc_001 Â· GLOBAL Â· Binding Seals â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_001',
    name: 'Cracked Binding Seal',
    description:
        'A palm-sized fragment of a ward-stone, worn as a pendant. '
        'Clerics maintain these seals across the world â€” this one cracked, '
        'and whatever it held is long gone. A reminder that the world '
        'needs holding together, one broken seal at a time.',
    type: ItemType.accessory,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    magic: 3,
    health: 5,
    effect: 'Faint Ward: restores 1% HP per turn.',
  ),

  // â”€â”€ acc_002 Â· FOREST Â· Fey Courts â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_002',
    name: 'Fey Pact Charm',
    description:
        'A twisted knot of silver wire and dried petals, given by Fey '
        'Court sprites in exchange for a secret. The pact is simple: '
        'carry this, and the old trickster-spirits will only trick you '
        'gently. When the pacts fray, even this won\'t help.',
    type: ItemType.accessory,
    rarity: Rarity.common,
    level: 5,
    price: 100,
    agility: 5,
    magic: 5,
    effect:
        'Fey Favor: +5% evasion against magical attacks. Wisps ignore the wearer.',
  ),

  // â”€â”€ acc_003 Â· CAVE Â· Upper Hollows â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_003',
    name: 'Bioluminescent Fungal Lantern',
    description:
        'A caged cluster of cavern fungi that glow with the Deep '
        'Mother\'s ambient influence. Miners prize these over torches â€” '
        'they never go out, and they pulse faster when something watches '
        'from the dark.',
    type: ItemType.accessory,
    rarity: Rarity.common,
    level: 10,
    price: 200,
    magic: 10,
    agility: 5,
    effect:
        'Deep Light: reveals hidden enemies and traps. +5% evasion in underground areas.',
  ),

  // â”€â”€ acc_004 Â· RUINS Â· Korval â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_004',
    name: 'Korval\'s Research Pendant',
    description:
        'A brass locket containing a fragment of Historian Korval\'s '
        'notes on Valdris architecture â€” specifically, his confused '
        'observations about rooms that seem larger inside than out. He '
        'attributed it to residual enchantment. He was wrong.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 15,
    price: 400,
    magic: 12,
    defense: 10,
    health: 30,
    effect:
        'Scholar\'s Eye: reveals enemy weaknesses at battle start. +10% XP from Ruins encounters.',
  ),

  // â”€â”€ acc_005 Â· GLOBAL Â· The Hollow â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_005',
    name: 'Hollow Void Amulet',
    description:
        'A gemstone with a hole in it â€” not a physical hole, but an '
        'absence where the Hollow has unmade the crystal\'s center. '
        'Light bends around the gap. Staring into it too long makes '
        'you forget what you were looking at.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 20,
    price: 500,
    magic: 18,
    attack: 10,
    effect:
        'Void Gaze: spell damage +10%. 5% chance attacks erase one enemy buff.',
  ),

  // â”€â”€ acc_006 Â· FOREST Â· Circle of Thorn â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_006',
    name: 'Circle of Thorn Signet',
    description:
        'A ring of living wood worn by druids of the Circle of Thorn â€” '
        'mediators between mortal and Fey. Their numbers thin each '
        'decade. This signet still channels the old pacts, though fewer '
        'answer its call.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 25,
    price: 800,
    magic: 15,
    health: 60,
    defense: 5,
    effect:
        'Druid\'s Pact: healing effects increased by 15%. Fey creatures will not attack first.',
  ),

  // â”€â”€ acc_007 Â· CAVE Â· Ossborn â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_007',
    name: 'Ossborn Memory Fragment',
    description:
        'A bone shard from an Ossborn elder â€” a piece that fell during '
        'the Rite of Grafting. It carries a single warden memory: the '
        'exact rune sequence that held a specific prison sealed for '
        'three thousand years. The sequence plays in your dreams.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 30,
    price: 1200,
    agility: 28,
    defense: 10,
    effect:
        'Inherited Instinct: always act first in the opening turn of battle. +15% evasion against traps.',
  ),

  // â”€â”€ acc_008 Â· RUINS Â· Tithebound â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_008',
    name: 'Tithebound Resonance Stone',
    description:
        'A smooth grey stone that vibrates at the same frequency as the '
        'Tithebound\'s hollow eyes. When held, you hear what they hear â€” '
        'a faint sound from deep beneath the ruins that shapes itself '
        'into what you most desire. It is not a calling. It is bait.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 35,
    price: 1600,
    magic: 35,
    agility: 15,
    effect:
        'Resonance: spell damage +15%. Grants brief precognition â€” see enemy attacks before they land.',
  ),

  // â”€â”€ acc_009 Â· GLOBAL Â· Death â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_009',
    name: 'Death\'s Walking Band',
    description:
        'A ring of bone-white metal, featureless and cold. Death walks '
        'both worlds freely and answers to no prayer â€” but Death notices '
        'those who carry artifacts of the divine. This ring ensures you '
        'are noticed in return.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 40,
    price: 2000,
    attack: 20,
    magic: 25,
    health: 80,
    effect:
        'Death Marked: +10% to all damage. Immune to instant-death and charm effects.',
  ),

  // â”€â”€ acc_010 Â· FOREST Â· Vaelithi / Seylith â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_010',
    name: 'Seylith\'s Moonstone Brooch',
    description:
        'A brooch of elvish craft set with a moonstone that holds four '
        'centuries of light â€” one for each year of Queen Seylith the '
        'Undying\'s reign. The Vaelithi do not part with these. That it '
        'exists outside the Thornwall means someone defected or died.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 50,
    price: 2800,
    magic: 30,
    defense: 15,
    agility: 20,
    effect:
        'Undying Light: regenerate 3% HP per turn. +20% resistance to dark and corruption effects.',
  ),

  // â”€â”€ acc_011 Â· CAVE Â· Warden Bones â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_011',
    name: 'Warden Bone Bracers',
    description:
        'Bracers carved from the bones of ancient wardens â€” the '
        'originals who chained the titans and sealed the demons. The '
        'Ossborn grafted these bones into themselves. These bracers '
        'carry what the Ossborn chose not to keep.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 60,
    price: 5000,
    defense: 30,
    attack: 25,
    agility: 25,
    effect:
        'Warden\'s Reflex: +18% evasion. Automatically counter-attack once per turn when dodging.',
  ),

  // â”€â”€ acc_012 Â· RUINS Â· Nameless Choir â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_012',
    name: 'Choir Silence Pendant',
    description:
        'A pendant that generates a sphere of absolute silence â€” crafted '
        'by a Tithebound elder who retained enough awareness to '
        'understand what the Nameless Choir does. The silence is not '
        'peaceful. It is the absence of the sound that unmakes you.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 70,
    price: 7000,
    magic: 50,
    health: 120,
    defense: 25,
    effect:
        'Silent Ward: immune to all sound-based and mind-affecting attacks. Once per battle, negate a killing blow and heal 25% HP.',
  ),

  // â”€â”€ acc_013 Â· GLOBAL Â· Firstborn Gods â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_013',
    name: 'Firstborn\'s Tear',
    description:
        'A crystallized tear shed during the Sundering â€” from which of '
        'the three surviving gods, no scholar agrees. The Radiant One '
        'wept for the sun. The Deep Mother wept for the earth. Death, '
        'eldest of all, does not weep â€” but something fell from its face.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 80,
    price: 10000,
    magic: 55,
    attack: 30,
    health: 150,
    effect:
        'Divine Sorrow: all damage +15%. Healing spells cost 40% less. Immune to divine-type damage.',
  ),

  // â”€â”€ acc_014 Â· FOREST Â· Bloom Rite â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_014',
    name: 'Crown of the Bloom Rite',
    description:
        'The crown formed in the root-hollows of the World Tree during '
        'the Bloom Rite â€” Vaelithi succession\'s ultimate trial. '
        'Candidates descend and return changed, or don\'t return at all. '
        'This crown was found beside someone who didn\'t return.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 90,
    price: 16000,
    attack: 40,
    magic: 40,
    agility: 30,
    effect:
        'Root-Hollow Crown: all stats +8%. Below 25% HP, regenerate 5% max HP per turn and gain +20% to all damage.',
  ),

  // â”€â”€ acc_015 Â· CAVE Â· Deep Mother â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'acc_015',
    name: 'Eye of the Deep Mother',
    description:
        'Not a metaphor. Not a gem shaped like an eye. An eye â€” milky '
        'white, the size of a fist, warm and wet, and it blinks. Pulled '
        'from a crevice near the Heart of the Mountain where the rock '
        'thinned enough to see through. The Deep Mother sees through it '
        'still.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 100,
    price: 24000,
    magic: 70,
    attack: 40,
    agility: 30,
    effect:
        'All-Seeing: all enemy stats visible. Spells ignore magic resistance. +20% crit chance. The Deep Mother watches through you.',
  ),

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  R E L I C S
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

  // â”€â”€ rel_001 Â· GLOBAL Â· Binding Seals â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_001',
    name: 'Fractured Binding Seal',
    description:
        'A broken ward-stone â€” one of thousands scattered across the '
        'crumbling ancient prisons. Druids tend the World Tree\'s roots, '
        'clerics maintain the binding seals, and heroes carry blades '
        'into the dark. You carry a piece of what they\'re all fighting '
        'to hold together.',
    type: ItemType.relic,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    agility: 3,
    effect: 'Faint Resonance: 5% chance to gain an extra action per turn.',
  ),

  // â”€â”€ rel_002 Â· CAVE Â· Upper Hollows â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_002',
    name: 'Hollows Bioluminescent Spore',
    description:
        'A living fungal cluster from the upper Hollows, pulsing with '
        'the Deep Mother\'s ambient influence. It lights dark places '
        'with a sickly green glow and recoils from heat, as if the Deep '
        'Mother disapproves of the Radiant One\'s fire.',
    type: ItemType.relic,
    rarity: Rarity.common,
    level: 5,
    price: 100,
    magic: 6,
    health: 5,
    effect:
        'Deep Glow: reveals enemy positions in darkness. +5% magic damage in underground areas.',
  ),

  // â”€â”€ rel_003 Â· RUINS Â· Scholar Veyra â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_003',
    name: 'Scholar Veyra\'s Field Journal',
    description:
        'A battered journal belonging to Scholar Veyra, who catalogs the '
        'upper Valdris ruins alongside Historian Korval. Her notes are '
        'meticulous but confused â€” measurements that contradict '
        'themselves, sketches of rooms larger inside than out. She calls '
        'it "residual enchantment." She is wrong.',
    type: ItemType.relic,
    rarity: Rarity.common,
    level: 10,
    price: 200,
    magic: 8,
    health: 20,
    effect:
        'Scholar\'s Record: +10% XP from all encounters. Reveals hidden lore in Ruins areas.',
  ),

  // â”€â”€ rel_004 Â· FOREST Â· Fey Courts â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_004',
    name: 'Thornveil Wisp Lantern',
    description:
        'A cage of living vines containing a captured wisp from the Fey '
        'Courts. The old pacts that bind the fey predate even the elves '
        'â€” this wisp agreed to serve in exchange for protection from '
        'what happens when those pacts finally break.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 15,
    price: 400,
    magic: 22,
    agility: 8,
    effect:
        'Wisp Light: reveals hidden paths and treasures. +10% evasion against ambushes.',
  ),

  // â”€â”€ rel_005 Â· GLOBAL Â· The Hollow â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_005',
    name: 'Shard of the Hollow',
    description:
        'A crystallized fragment of the Hollow itself â€” void-stuff '
        'hardened into something almost physical. It unmakes what it '
        'touches slowly: wood greys, metal corrodes, skin numbs. The '
        'Hollow spreads not as invasion but as erosion. This is what '
        'erosion looks like held in your hand.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 20,
    price: 500,
    magic: 18,
    attack: 10,
    effect:
        'Void Erosion: attacks permanently reduce enemy DEF by 3% per hit (stacks up to 5x). Wielder takes 1% max HP per turn.',
  ),

  // â”€â”€ rel_006 Â· CAVE Â· Forge Spirit â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_006',
    name: 'Forge Spirit\'s Ember',
    description:
        'A fragment of living flame from the Forge Spirit â€” the ancient '
        'entity that tends the weakening bindings in the Hollows. It '
        'considers the Ossborn tools, not allies. It considers you less '
        'than that. But the ember burns, and it burns true.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 25,
    price: 800,
    attack: 15,
    magic: 15,
    health: 40,
    effect:
        'Spirit Flame: every 3rd attack deals 50% bonus fire damage. Immune to burn effects.',
  ),

  // â”€â”€ rel_007 Â· RUINS Â· Valdris Wards â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_007',
    name: 'Valdris Ward-Stone Shard',
    description:
        'A fragment of the protective wards that once shielded '
        'Valdris â€” before Morvaine shattered them from within, or '
        'Azrathar breached them from without. The histories disagree. '
        'This shard hums at a frequency that makes your teeth ache, '
        'and sometimes shows a kingdom that looks nothing like ruins.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 30,
    price: 1200,
    magic: 25,
    defense: 15,
    effect:
        'Ward Echo: reflects 15% of magic damage back at caster. +10% resistance to curse effects.',
  ),

  // â”€â”€ rel_008 Â· FOREST Â· World Tree Root â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_008',
    name: 'World Tree Root Heart',
    description:
        'A gnarled heartwood node from deep within the World Tree\'s '
        'root system â€” where the roots pierce the underworld. Something '
        'stirs in those root-hollows that the Vaelithi will not name: '
        'a blight that withers their trees from the inside. This heart '
        'still pulses with life, but the edges are grey.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 35,
    price: 1600,
    magic: 30,
    health: 80,
    defense: 10,
    effect:
        'Root Bond: regenerate 4% HP per turn. Nature spells deal 25% bonus damage. Warns of corruption nearby.',
  ),

  // â”€â”€ rel_009 Â· CAVE Â· The Devourer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_009',
    name: 'Devourer\'s Prison Keystone',
    description:
        'A keystone from the deepest vault in the Hollows â€” the prison '
        'that holds the Devourer, something that predates even the gods. '
        'The Forge Spirit tends this binding above all others. The '
        'Ossborn refuse to approach it. The keystone is warm, and if '
        'you press your ear to it, you hear breathing.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 40,
    price: 2000,
    attack: 20,
    magic: 30,
    health: 60,
    effect:
        'Abyssal Lock: +15% damage against ancient and divine enemies. Grants a shield (10% max HP) at the start of each battle.',
  ),

  // â”€â”€ rel_010 Â· GLOBAL Â· Titans â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_010',
    name: 'Titan\'s Shackle Link',
    description:
        'A single link from the chains forged during the Sundering to '
        'bind the titans in their prisons. The chains were made to hold '
        'gods. A single link still carries that purpose â€” when held, you '
        'feel the weight of holding something immeasurably powerful in '
        'place.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 50,
    price: 2800,
    defense: 25,
    attack: 20,
    magic: 20,
    effect:
        'Titan\'s Weight: immune to knockback and displacement. +15% damage to targets larger than the wielder.',
  ),

  // â”€â”€ rel_011 Â· RUINS Â· Nameless Choir â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_011',
    name: 'Nameless Choir Echo',
    description:
        'A tuning fork that vibrates at the exact frequency of the '
        'Nameless Choir â€” the sound a dimensional wound makes when it '
        'refuses to close. Prolonged exposure strips memory: first '
        'small things, then larger ones. Holding this, you hear the '
        'first note. It sounds like something you forgot.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 60,
    price: 5000,
    magic: 55,
    health: 80,
    effect:
        'Memory Thief: spells have 10% chance to strip one random buff from the target. Dark spells deal 30% bonus damage. Costs 1% max HP per spell cast.',
  ),

  // â”€â”€ rel_012 Â· FOREST Â· Verdant Court â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_012',
    name: 'Heart of the Verdant Court',
    description:
        'The emerald core of Vaelith\'s governance â€” a living gemstone '
        'grown within the throne of the Verdant Court over centuries. '
        'It contains the accumulated will of every Vaelithi monarch who '
        'passed the Bloom Rite. Queen Seylith sat beside it for four '
        'hundred years. The gem remembers every one of them.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 70,
    price: 7000,
    magic: 60,
    health: 200,
    defense: 30,
    effect:
        'Verdant Will: regenerate 5% max HP per turn. Nature and healing effects deal double. Immune to corruption and decay.',
  ),

  // â”€â”€ rel_013 Â· CAVE Â· Deep Mother's Heart â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_013',
    name: 'Deep Mother\'s Heartstone',
    description:
        'A fragment of the Heart of the Mountain itself â€” the living '
        'organ of stone and magma that scholars believe is the Deep '
        'Mother\'s own heart, still beating after the Sundering. It '
        'pulses in your hand with a rhythm slower than any mortal heart, '
        'and the ground trembles in sympathy.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 80,
    price: 10000,
    magic: 70,
    attack: 30,
    health: 100,
    effect:
        'Earthen Fury: once per battle, call a tremor dealing AoE damage equal to 300% MAG. Enemies hit lose 20% DEF for 3 turns. Immune to earth and magma damage.',
  ),

  // â”€â”€ rel_014 Â· RUINS Â· Severance Catalyst â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_014',
    name: 'Severance Catalyst',
    description:
        'The crystalline focus through which the Valdris Court Arcanists '
        'channeled the Severance â€” the spell that folded an entire '
        'kingdom into a dimension that should not exist. The Arcanists '
        'were consumed. The catalyst survived. It still wants to fold '
        'things.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 90,
    price: 16000,
    magic: 80,
    attack: 40,
    agility: 20,
    effect:
        'Severance: attacks permanently reduce enemy stats by 5% (stacks). Spells ignore shields. Once per battle, banish one enemy ability.',
  ),

  // â”€â”€ rel_015 Â· GLOBAL Â· The Sundering Wound â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  const Item(
    id: 'rel_015',
    name: 'The Sundering Wound',
    description:
        'Not an object â€” a scar in reality itself, contained in a '
        'sphere of binding glass made by the first wardens. Inside, you '
        'see the original wound: the crack the Firstborn Gods tore in '
        'creation. It has never healed. The Hollow seeps from wounds '
        'like this. Carrying it is carrying the reason the world is '
        'broken.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 100,
    price: 24000,
    magic: 100,
    attack: 40,
    defense: 40,
    health: 200,
    effect:
        'World Wound: all damage +20%. Once per battle, open a rift that erases one enemy ability permanently. Immune to all debuffs. Nearby enemies lose 3% stats per turn.',
  ),

  // ═══════════════════════════════════════════════════════════
  //  S P E L L S
  // ═══════════════════════════════════════════════════════════

  // ── spl_001 · GLOBAL · The Sundering ──────────────────
  const Item(
    id: 'spl_001',
    name: 'Shard Bolt',
    description:
        'A jagged bolt of crystallised Sundering energy hurled at the '
        'enemy. The fragments hum with the echo of the blow that cracked '
        'reality — even a sliver carries that ancient violence.',
    type: ItemType.spell,
    rarity: Rarity.common,
    level: 1,
    price: 80,
    magic: 3,
    manaCost: 5,
    effect: 'Hurls a Sundering shard dealing damage based on MAG.',
  ),

  // ── spl_002 · FOREST · Thornveil ──────────────────────
  const Item(
    id: 'spl_002',
    name: 'Thornlash',
    description:
        'The Thornveil responds to those who speak its old names. This '
        'invocation calls a whip of living thorns from the forest floor '
        'to lash and bind enemies in barbed vine.',
    type: ItemType.spell,
    rarity: Rarity.common,
    level: 5,
    price: 120,
    magic: 4,
    manaCost: 8,
    effect:
        'Lashes a target with thorned vine, dealing MAG damage and slowing them for 2 turns.',
  ),

  // ── spl_003 · CAVE · The Hollows ──────────────────────
  const Item(
    id: 'spl_003',
    name: 'Stoneskin',
    description:
        'The deep stone of the Hollows remembers the Warden-craft — the '
        'old art of binding earth to flesh. This ward coats the caster '
        'in a shell of living rock that turns aside blades.',
    type: ItemType.spell,
    rarity: Rarity.common,
    level: 10,
    price: 200,
    magic: 5,
    defense: 3,
    manaCost: 10,
    effect:
        'Grants a stone shield absorbing damage equal to 50% MAG for 3 turns.',
  ),

  // ── spl_004 · RUINS · Valdris ─────────────────────────
  const Item(
    id: 'spl_004',
    name: 'Arcane Missile',
    description:
        'The Court Arcanists of Valdris refined raw mana into precise '
        'bolts that track their targets through corridors and around '
        'cover. The spell is elementary by their standards — and '
        'devastating by anyone else\'s.',
    type: ItemType.spell,
    rarity: Rarity.rare,
    level: 15,
    price: 350,
    magic: 8,
    manaCost: 12,
    effect:
        'Fires 3 homing bolts of arcane energy, each dealing MAG-scaled damage.',
  ),

  // ── spl_005 · GLOBAL · The Hollow ─────────────────────
  const Item(
    id: 'spl_005',
    name: 'Hollow Drain',
    description:
        'A forbidden technique that channels the Hollow\'s hunger. The '
        'caster opens a hairline crack between worlds and the void drinks '
        'from the enemy\'s life force, returning a fraction to the caster.',
    type: ItemType.spell,
    rarity: Rarity.rare,
    level: 20,
    price: 500,
    magic: 10,
    manaCost: 15,
    effect:
        'Drains enemy HP equal to 80% MAG and heals caster for half the amount.',
  ),

  // ── spl_006 · FOREST · World Tree ─────────────────────
  const Item(
    id: 'spl_006',
    name: 'Verdant Bloom',
    description:
        'A prayer to the World Tree channelled through living wood. '
        'Golden-green light blooms around the caster, knitting wounds '
        'and purging corruption. The Vaelithi healers called this the '
        'Firstbloom — the simplest gift the Tree still gives.',
    type: ItemType.spell,
    rarity: Rarity.rare,
    level: 25,
    price: 700,
    magic: 12,
    manaCost: 18,
    effect: 'Heals caster for 120% MAG and removes one negative status effect.',
  ),

  // ── spl_007 · CAVE · Forge Spirit ─────────────────────
  const Item(
    id: 'spl_007',
    name: 'Molten Surge',
    description:
        'Deep beneath the Hollows, the Forge Spirit still hammers at '
        'its eternal anvil. This invocation borrows a breath of its '
        'fire — liquid stone erupts from the ground in a searing wave '
        'that melts armour and flesh alike.',
    type: ItemType.spell,
    rarity: Rarity.rare,
    level: 30,
    price: 1000,
    magic: 15,
    attack: 5,
    manaCost: 22,
    effect:
        'Erupts magma dealing heavy MAG damage and reducing enemy DEF by 15% for 3 turns.',
  ),

  // ── spl_008 · RUINS · Tithebound ──────────────────────
  const Item(
    id: 'spl_008',
    name: 'Soul Tithe',
    description:
        'The Tithebound of Valdris paid their debts in soul-stuff, not '
        'coin. This grim enchantment exacts the same price from an enemy '
        '— tearing away a sliver of their essence to fuel the caster\'s '
        'next strike.',
    type: ItemType.spell,
    rarity: Rarity.rare,
    level: 35,
    price: 1400,
    magic: 18,
    manaCost: 25,
    effect:
        'Steals enemy ATK/MAG by 10% for 3 turns and boosts caster\'s next attack by 30%.',
  ),

  // ── spl_009 · GLOBAL · The Radiant One ────────────────
  const Item(
    id: 'spl_009',
    name: 'Radiant Judgement',
    description:
        'A column of searing light called down in the Radiant One\'s '
        'name. The Firstborn God of light may be diminished, but this '
        'echo of divine wrath still burns — especially against creatures '
        'of the Hollow.',
    type: ItemType.spell,
    rarity: Rarity.epic,
    level: 40,
    price: 2000,
    magic: 22,
    manaCost: 30,
    effect:
        'Holy damage dealing 150% MAG. Deals double damage to Hollow-corrupted enemies.',
  ),

  // ── spl_010 · FOREST · Fey Courts ─────────────────────
  const Item(
    id: 'spl_010',
    name: 'Fey Mirage',
    description:
        'The Fey Courts deal in glamour and misdirection. This charm '
        'wraps the caster in layers of illusory doubles that confuse '
        'enemies, causing their attacks to strike at phantoms while the '
        'real caster moves unseen.',
    type: ItemType.spell,
    rarity: Rarity.epic,
    level: 50,
    price: 3000,
    magic: 25,
    agility: 10,
    manaCost: 35,
    effect:
        'Creates illusions granting 50% evasion for 3 turns. Next attack from stealth deals +40% damage.',
  ),

  // ── spl_011 · CAVE · Deep Mother ──────────────────────
  const Item(
    id: 'spl_011',
    name: 'Earthen Maw',
    description:
        'The Deep Mother\'s hunger given form. The ground splits open '
        'into a jagged maw of stone teeth that clamps shut on the enemy, '
        'crushing and trapping them in the earth\'s grip.',
    type: ItemType.spell,
    rarity: Rarity.epic,
    level: 60,
    price: 4500,
    magic: 30,
    attack: 10,
    manaCost: 40,
    effect:
        'Traps an enemy for 2 turns dealing 100% MAG each turn. Trapped enemies cannot act.',
  ),

  // ── spl_012 · RUINS · Nameless Choir ──────────────────
  const Item(
    id: 'spl_012',
    name: 'Chorus of Unmaking',
    description:
        'The Nameless Choir sang the walls of Valdris into existence — '
        'and their imprisoned echoes still know the counter-melody. This '
        'spell unleashes a discordant wail that unravels enchantments, '
        'wards, and the will to fight.',
    type: ItemType.spell,
    rarity: Rarity.epic,
    level: 70,
    price: 6500,
    magic: 35,
    manaCost: 45,
    effect:
        'AoE sonic damage dealing 120% MAG. Dispels all enemy buffs and silences for 2 turns.',
  ),

  // ── spl_013 · GLOBAL · Death ──────────────────────────
  const Item(
    id: 'spl_013',
    name: 'Death\'s Whisper',
    description:
        'Death in this world is not an ending but a patient collector. '
        'This forbidden invocation borrows Death\'s voice for a single '
        'syllable — a whisper that makes mortal things remember they '
        'are mortal. The strong can resist. The weak simply stop.',
    type: ItemType.spell,
    rarity: Rarity.mythic,
    level: 80,
    price: 10000,
    magic: 45,
    manaCost: 55,
    effect:
        'Chance to instantly kill enemies below 25% HP. Otherwise deals 200% MAG damage.',
  ),

  // ── spl_014 · RUINS · Severance ───────────────────────
  const Item(
    id: 'spl_014',
    name: 'Severance Rift',
    description:
        'A controlled fragment of the Severance — the spell that folded '
        'the Valdris kingdom into a dimension that should not exist. '
        'This tears a brief rift in space that swallows attacks and '
        'redirects them back at the attacker.',
    type: ItemType.spell,
    rarity: Rarity.mythic,
    level: 90,
    price: 16000,
    magic: 55,
    defense: 15,
    manaCost: 65,
    effect:
        'Opens a dimensional rift absorbing all damage for 2 turns, then detonates for 250% absorbed damage.',
  ),

  // ── spl_015 · GLOBAL · The Sundering Wound ────────────
  const Item(
    id: 'spl_015',
    name: 'Worldbreak',
    description:
        'The ultimate expression of Sundering magic — a spell that '
        'reopens the original wound between worlds for a heartbeat. '
        'Reality screams. Everything in the blast radius is touched by '
        'the raw stuff of creation and un-creation simultaneously. '
        'Nothing survives unchanged.',
    type: ItemType.spell,
    rarity: Rarity.mythic,
    level: 100,
    price: 24000,
    magic: 70,
    attack: 25,
    manaCost: 80,
    effect:
        'Cataclysmic damage dealing 400% MAG to all enemies. Reduces all enemy stats by 20% permanently. Once per battle.',
  ),
];

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  HELPER GETTERS
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

/// All weapons in the game.
List<Item> get allWeapons =>
    allItems.where((i) => i.type == ItemType.weapon).toList();

/// All armor in the game.
List<Item> get allArmor =>
    allItems.where((i) => i.type == ItemType.armor).toList();

/// All accessories in the game.
List<Item> get allAccessories =>
    allItems.where((i) => i.type == ItemType.accessory).toList();

/// All relics in the game.
List<Item> get allRelics =>
    allItems.where((i) => i.type == ItemType.relic).toList();

/// All spells in the game.
List<Item> get allSpellItems =>
    allItems.where((i) => i.type == ItemType.spell).toList();

/// Items filtered by level range (inclusive).
List<Item> itemsForLevelRange(int minLevel, int maxLevel) =>
    allItems.where((i) => i.level >= minLevel && i.level <= maxLevel).toList();

/// Items available for a given player level (items at or below that level).
List<Item> itemsAvailableAtLevel(int playerLevel) =>
    allItems.where((i) => i.level <= playerLevel).toList();

/// Items filtered by rarity.
List<Item> itemsByRarity(Rarity rarity) =>
    allItems.where((i) => i.rarity == rarity).toList();
