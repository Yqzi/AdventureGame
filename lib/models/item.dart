import 'package:tes/components/cards.dart';

// ─────────────────────────────────────────────────────────────
//  ITEM TYPE
// ─────────────────────────────────────────────────────────────

enum ItemType { weapon, armor, accessory, relic }

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
    }
  }

  String get icon {
    switch (this) {
      case ItemType.weapon:
        return '⚔️';
      case ItemType.armor:
        return '🛡️';
      case ItemType.accessory:
        return '💍';
      case ItemType.relic:
        return '🔮';
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  ITEM MODEL
// ─────────────────────────────────────────────────────────────

class Item {
  final String id;
  final String name;
  final String description; // Lore / flavor text
  final ItemType type;
  final Rarity rarity;
  final int level; // Required level 1–100
  final int price; // Gold cost in the shop

  // ── Stat bonuses when equipped ──
  final int attack;
  final int defense;
  final int magic;
  final int agility;
  final int health; // Bonus HP

  // ── Special passive / active effect ──
  final String effect;

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
  });

  /// Human-readable stat summary shown on shop cards.
  String get statSummary {
    final parts = <String>[];
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
}

// ═════════════════════════════════════════════════════════════
//  ALL GAME ITEMS
//  Prices scale with level & rarity:
//    base  = level × 50 + 50
//    ×1 Common  ×3 Rare  ×7 Epic  ×15 Mythic
// ═════════════════════════════════════════════════════════════

final List<Item> allItems = [
  // ─────────────────────────────────────────────────────────
  //  W E A P O N S
  // ─────────────────────────────────────────────────────────
  const Item(
    id: 'wpn_001',
    name: 'Rusty Bone Cleaver',
    description:
        'A crude hatchet forged from sharpened bone and corroded iron. '
        'It reeks of old marrow and desperation.',
    type: ItemType.weapon,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    attack: 4,
    agility: 1,
    effect: 'Chance to inflict Tetanus (2% poison per turn for 3 turns).',
  ),

  const Item(
    id: 'wpn_002',
    name: 'Hollow Fang Dagger',
    description:
        'A jagged dagger carved from the fang of a Blight Serpent. '
        'Venom still seeps from its hollow core.',
    type: ItemType.weapon,
    rarity: Rarity.common,
    level: 5,
    price: 300,
    attack: 8,
    agility: 4,
    effect: '8% chance to poison target for 3 turns.',
  ),

  const Item(
    id: 'wpn_003',
    name: 'Gravedigger\'s Spade',
    description:
        'A shovel baptized in gravesoil and restless spirits. '
        'Each swing echoes with the groans of the buried.',
    type: ItemType.weapon,
    rarity: Rarity.common,
    level: 10,
    price: 550,
    attack: 14,
    defense: 3,
    effect: 'Deals 15% bonus damage to Undead enemies.',
  ),

  const Item(
    id: 'wpn_004',
    name: 'Blighted Shortsword',
    description:
        'A cursed blade encrusted with black fungal growth. '
        'Wounds it inflicts fester and refuse to heal.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 15,
    price: 2400,
    attack: 24,
    agility: 6,
    effect:
        'Inflicts Festering Wound: target\'s healing reduced by 30% for 4 turns.',
  ),

  const Item(
    id: 'wpn_005',
    name: 'Wraithbone Axe',
    description:
        'Hewn from the fused spine of a Hollow Wraith. '
        'The air around it grows cold and heavy with sorrow.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 20,
    price: 3150,
    attack: 34,
    magic: 8,
    effect:
        'Attacks have a 15% chance to Chill the target, reducing AGI by 20%.',
  ),

  const Item(
    id: 'wpn_006',
    name: 'Plague Doctor\'s Scalpel',
    description:
        'A surgical instrument used in forbidden autopsies of the still-living. '
        'Inscribed with anatomical runes that expose weakness.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 25,
    price: 3900,
    attack: 38,
    agility: 14,
    effect:
        'Critical hit chance increased by 12%. Crits apply Hemorrhage (bleed 3% HP/turn).',
  ),

  const Item(
    id: 'wpn_007',
    name: 'Nighthowl Glaive',
    description:
        'This polearm screams when swung — a banshee\'s wail trapped in dark steel. '
        'Enemies falter before it even strikes.',
    type: ItemType.weapon,
    rarity: Rarity.rare,
    level: 30,
    price: 4650,
    attack: 50,
    agility: 10,
    effect: '20% chance to inflict Fear on hit (target skips next turn).',
  ),

  const Item(
    id: 'wpn_008',
    name: 'Bloodthorn Whip',
    description:
        'A living tendril ripped from the Abyssal Garden. '
        'Its thorns drink deep, and the whip grows stronger with every lash.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 35,
    price: 12950,
    attack: 58,
    agility: 18,
    health: 30,
    effect: 'Lifesteal: restores HP equal to 10% of damage dealt.',
  ),

  const Item(
    id: 'wpn_009',
    name: 'Soulreaper Scythe',
    description:
        'A scythe of blackened bone and soulfire. '
        'Each kill harvests a sliver of the victim\'s essence, empowering the wielder.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 40,
    price: 14700,
    attack: 72,
    magic: 20,
    effect:
        'On kill: gain +5 ATK for the remainder of the battle (stacks up to 5×).',
  ),

  const Item(
    id: 'wpn_010',
    name: 'Ashen Greatsword',
    description:
        'Forged in the pyre of a burning kingdom, this colossal blade still smolders. '
        'Ash drifts from every devastating cut.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 50,
    price: 18200,
    attack: 95,
    defense: 15,
    effect: 'Attacks deal splash damage to adjacent enemies (40% of base ATK).',
  ),

  const Item(
    id: 'wpn_011',
    name: 'Voidfang Katana',
    description:
        'A blade folded within dimensional rifts — '
        'its edge exists in multiple planes simultaneously. Cuts through armor like shadow.',
    type: ItemType.weapon,
    rarity: Rarity.epic,
    level: 60,
    price: 21700,
    attack: 115,
    agility: 35,
    effect:
        'Ignores 25% of target\'s DEF. 10% chance to phase through counter-attacks.',
  ),

  const Item(
    id: 'wpn_012',
    name: 'Doomhammer of the Fallen King',
    description:
        'The warhammer of King Aldric the Mad, who slaughtered his court in a single night. '
        'The screams of his subjects still ring from the metal.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 70,
    price: 54000,
    attack: 155,
    defense: 30,
    health: 80,
    effect:
        'Concussive Blow: 25% chance to stun for 1 turn. Deals double damage to stunned targets.',
  ),

  const Item(
    id: 'wpn_013',
    name: 'Eclipsebane',
    description:
        'A longsword that devours light itself. Where it swings, '
        'darkness follows — absolute and suffocating. Even the sun fears its edge.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 80,
    price: 61500,
    attack: 185,
    magic: 40,
    agility: 25,
    effect:
        'Eclipse Aura: enemies within range lose 5% ATK per turn. You gain what they lose.',
  ),

  const Item(
    id: 'wpn_014',
    name: 'Malachar\'s Hungering Blade',
    description:
        'A sentient sword that whispers and feeds on its wielder\'s blood. '
        'The more you bleed, the harder it bites. It despises being sheathed.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 90,
    price: 69750,
    attack: 220,
    agility: 40,
    health: -50,
    effect:
        'Costs 3% max HP per attack. In exchange: +50% total damage and guaranteed crit below 30% HP.',
  ),

  const Item(
    id: 'wpn_015',
    name: 'Godslayer, End of All',
    description:
        'The obsidian blade that felled the Last Deity. '
        'Reality warps around its edge. Those who lift it feel the weight of a dead god\'s final scream.',
    type: ItemType.weapon,
    rarity: Rarity.mythic,
    level: 100,
    price: 78000,
    attack: 270,
    magic: 50,
    agility: 30,
    health: 100,
    effect:
        'Deicide: ignores ALL enemy resistances. On kill, fully restores HP and resets all cooldowns.',
  ),

  // ─────────────────────────────────────────────────────────
  //  A R M O R
  // ─────────────────────────────────────────────────────────
  const Item(
    id: 'arm_001',
    name: 'Tattered Hide Wrap',
    description:
        'Scraps of mottled leather held together by dried sinew. '
        'Barely armor — but better than bare flesh in the wastes.',
    type: ItemType.armor,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    defense: 5,
    health: 10,
    effect: 'Reduces physical damage taken by 2%.',
  ),

  const Item(
    id: 'arm_002',
    name: 'Bonecage Vest',
    description:
        'A crude chestplate wired from rib bones of the fallen. '
        'Rattles with every step, as if the dead protest their desecration.',
    type: ItemType.armor,
    rarity: Rarity.common,
    level: 5,
    price: 300,
    defense: 10,
    health: 20,
    effect: '5% chance to deflect melee attacks completely.',
  ),

  const Item(
    id: 'arm_003',
    name: 'Gravewarden\'s Chainmail',
    description:
        'Rusted links salvaged from fallen knights of the Order of Ash. '
        'Stained with old blood that never quite washes out.',
    type: ItemType.armor,
    rarity: Rarity.common,
    level: 10,
    price: 550,
    defense: 18,
    health: 30,
    effect: 'Reduces damage from Undead enemies by 10%.',
  ),

  const Item(
    id: 'arm_004',
    name: 'Flayed Skin Jerkin',
    description:
        'Leather made from something not quite animal — the pores still weep. '
        'Unnervingly warm to the touch, as if still alive.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 15,
    price: 2400,
    defense: 28,
    agility: 8,
    health: 40,
    effect:
        'Regenerate 1% max HP per turn. Enemies have -5% accuracy against you.',
  ),

  const Item(
    id: 'arm_005',
    name: 'Ironblood Cuirass',
    description:
        'Plate armor quenched in sacrificial blood during a crimson moon ritual. '
        'The metal has a wet sheen that never dries.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 20,
    price: 3150,
    defense: 38,
    attack: 8,
    health: 60,
    effect: 'Blood Rage: when hit, gain +3 ATK for 2 turns (stacks up to 3×).',
  ),

  const Item(
    id: 'arm_006',
    name: 'Plaguewalker\'s Vestments',
    description:
        'Thick robes soaked in concentrated miasma from the Rotting Marshes. '
        'The stench alone keeps most threats at bay.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 25,
    price: 3900,
    defense: 35,
    magic: 15,
    health: 70,
    effect:
        'Immune to Poison and Disease. Melee attackers take 5% poison recoil.',
  ),

  const Item(
    id: 'arm_007',
    name: 'Dreadknight Plate',
    description:
        'Black steel forged in the furnaces of the Abyss, worn by those who swore fealty to the Void. '
        'Light bends around it, as if afraid.',
    type: ItemType.armor,
    rarity: Rarity.rare,
    level: 30,
    price: 4650,
    defense: 52,
    attack: 10,
    health: 80,
    effect: 'Dread Aura: adjacent enemies lose 8% ATK. Immune to Fear effects.',
  ),

  const Item(
    id: 'arm_008',
    name: 'Wailing Mantle',
    description:
        'A cloak stitched from the echoes of the damned. '
        'Ghostly faces ripple across its surface, mouths agape in silent screams.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 35,
    price: 12950,
    defense: 55,
    magic: 22,
    agility: 15,
    health: 100,
    effect:
        'Spectral Shroud: 15% chance to phase through physical attacks. +20% magic resistance.',
  ),

  const Item(
    id: 'arm_009',
    name: 'Flesh Golem\'s Carapace',
    description:
        'Armor grown from living, regenerating tissue harvested from an abomination. '
        'It pulses rhythmically, mending its own wounds.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 40,
    price: 14700,
    defense: 70,
    health: 150,
    effect:
        'Living Armor: regenerate 3% max HP per turn. Armor repairs itself after battle.',
  ),

  const Item(
    id: 'arm_010',
    name: 'Abyssal Dragonscale Mail',
    description:
        'Scales from Vorathrex, the dragon who fell into the Abyss and emerged twisted. '
        'Each scale is a window into a screaming void.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 50,
    price: 18200,
    defense: 92,
    magic: 20,
    health: 180,
    effect:
        'Abyssal Ward: reduces all incoming damage by 12%. Immune to fire damage.',
  ),

  const Item(
    id: 'arm_011',
    name: 'Sorrow\'s Embrace',
    description:
        'Armor woven from crystallized grief. The more pain the wearer endures, '
        'the harder the plates become. Suffering is its forge.',
    type: ItemType.armor,
    rarity: Rarity.epic,
    level: 60,
    price: 21700,
    defense: 112,
    attack: 20,
    health: 200,
    effect:
        'Martyrdom: DEF increases by 2% for every 10% HP lost. At below 25% HP, gain +30% ATK.',
  ),

  const Item(
    id: 'arm_012',
    name: 'Titan\'s Ossuary Plate',
    description:
        'Forged from the fossilized bones of a primordial titan. '
        'Mountains were its armor; now you wear a fragment of a god\'s skeleton.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 70,
    price: 54000,
    defense: 155,
    health: 300,
    attack: 20,
    effect:
        'Titanic Fortitude: immune to knockback and stun. Reduces all damage by 15%.',
  ),

  const Item(
    id: 'arm_013',
    name: 'Veil of the Undying',
    description:
        'This armor defies death itself — stitched from the membrane between life and the afterworld. '
        'Its wearer has died before, and the armor simply refused.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 80,
    price: 61500,
    defense: 180,
    health: 350,
    magic: 30,
    effect:
        'Undying: once per battle, survive a killing blow with 1 HP and become invulnerable for 1 turn.',
  ),

  const Item(
    id: 'arm_014',
    name: 'Nethershroud Aegis',
    description:
        'Woven from the fraying fabric between dimensions. '
        'Reality itself becomes your shield. Attacks pass through you like wind through a ghost.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 90,
    price: 69750,
    defense: 210,
    agility: 40,
    health: 300,
    magic: 40,
    effect:
        'Dimensional Shift: 20% chance to negate any attack entirely. Immune to all status effects.',
  ),

  const Item(
    id: 'arm_015',
    name: 'The Eternal Prison',
    description:
        'A living armor that entombs and empowers. It fused with the last warrior who wore it, '
        'consuming their body to become something beyond mortal craft. It hungers for a new host.',
    type: ItemType.armor,
    rarity: Rarity.mythic,
    level: 100,
    price: 78000,
    defense: 260,
    attack: 40,
    health: 500,
    magic: 30,
    effect:
        'Symbiosis: all stats grow by 1% per turn in combat (max 20%). Fully immune to instant-death effects.',
  ),

  // ─────────────────────────────────────────────────────────
  //  A C C E S S O R I E S
  // ─────────────────────────────────────────────────────────
  const Item(
    id: 'acc_001',
    name: 'Cracked Soul Gem',
    description:
        'A dim crystal containing a shrieking fragment of a departed spirit. '
        'It flickers weakly, barely tethered to this realm.',
    type: ItemType.accessory,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    magic: 3,
    health: 5,
    effect: 'Restores 1% MP per turn.',
  ),

  const Item(
    id: 'acc_002',
    name: 'Rat King\'s Tooth Necklace',
    description:
        'A string of yellowed rodent teeth, each from a different plague-bearer. '
        'Faint dark magic clings to the enamel.',
    type: ItemType.accessory,
    rarity: Rarity.common,
    level: 5,
    price: 300,
    attack: 3,
    agility: 5,
    health: 10,
    effect: '+5% gold drop rate from enemies.',
  ),

  const Item(
    id: 'acc_003',
    name: 'Eye of the Blind Seer',
    description:
        'A preserved eye floating in amber resin. It belonged to a prophet who gouged out her own eyes '
        'to see the truth. Now it grants fragments of that terrible foresight.',
    type: ItemType.accessory,
    rarity: Rarity.common,
    level: 10,
    price: 550,
    magic: 10,
    agility: 5,
    effect: '+8% evasion chance. Reveals enemy HP values.',
  ),

  const Item(
    id: 'acc_004',
    name: 'Cursed Wedding Band',
    description:
        'A tarnished ring etched with vows of eternal devotion — '
        'now broken. Its former owner waits somewhere in the dark, still calling.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 15,
    price: 2400,
    defense: 10,
    magic: 12,
    health: 30,
    effect:
        'Bound Fate: when HP drops below 50%, gain a shield equal to 10% max HP once per battle.',
  ),

  const Item(
    id: 'acc_005',
    name: 'Noose of the Hanged Man',
    description:
        'A frayed rope charm taken from a gallows at midnight. '
        'It tightens imperceptibly around the wrist when danger draws near.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 20,
    price: 3150,
    agility: 20,
    defense: 10,
    effect:
        'Death\'s Warning: always act first in the opening turn of battle. +10% evasion.',
  ),

  const Item(
    id: 'acc_006',
    name: 'Bloodstone Pendant',
    description:
        'A deep crimson gem that pulses in rhythm with the wearer\'s heart. '
        'It grows warm when blood is spilled nearby — and it is always warm.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 25,
    price: 3900,
    attack: 12,
    health: 60,
    effect:
        'Sanguine Pulse: lifesteal 5% on all attacks. HP regen doubled when below 40% HP.',
  ),

  const Item(
    id: 'acc_007',
    name: 'Shadowweave Bracers',
    description:
        'Armlets braided from concentrated darkness. '
        'The wearer\'s silhouette bleeds into shadows, making them impossible to pin down.',
    type: ItemType.accessory,
    rarity: Rarity.rare,
    level: 30,
    price: 4650,
    agility: 28,
    attack: 10,
    effect:
        'Shadow Meld: +18% evasion in darkness. Sneak attacks deal 30% bonus damage.',
  ),

  const Item(
    id: 'acc_008',
    name: 'Witch\'s Third Eye',
    description:
        'A crystallized eye pried from the forehead of a dead crone. '
        'It still sees — things you wish it wouldn\'t.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 35,
    price: 12950,
    magic: 35,
    agility: 15,
    effect:
        'True Sight: see through invisibility and illusions. Spell damage increased by 15%.',
  ),

  const Item(
    id: 'acc_009',
    name: 'Heartstring Amulet',
    description:
        'Woven from the literal heartstrings of a greater demon. '
        'It beats against your chest — a second heart, dark and powerful.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 40,
    price: 14700,
    attack: 20,
    magic: 25,
    health: 80,
    effect:
        'Demon Heart: +10% to all damage. Immune to charm and mind control effects.',
  ),

  const Item(
    id: 'acc_010',
    name: 'Crown of Thorns',
    description:
        'A circlet of blackened iron thorns that bites into the brow. '
        'Blood runs freely, but with it comes terrible, holy power.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 50,
    price: 18200,
    attack: 30,
    magic: 30,
    defense: 15,
    health: -30,
    effect:
        'Martyrdom: lose 2% HP per turn. Gain +25% to all damage dealt. Healing spells cost 50% less.',
  ),

  const Item(
    id: 'acc_011',
    name: 'Ring of the Blood Moon',
    description:
        'A signet ring that glows crimson during lunar events. '
        'Its power waxes and wanes, but at its peak, the wearer becomes something inhuman.',
    type: ItemType.accessory,
    rarity: Rarity.epic,
    level: 60,
    price: 21700,
    attack: 35,
    agility: 30,
    magic: 20,
    effect:
        'Blood Moon Frenzy: ATK and AGI increase by 20% at night. Critical hits heal for 8% max HP.',
  ),

  const Item(
    id: 'acc_012',
    name: 'Ouroboros Circlet',
    description:
        'A serpent of dark metal eating its own tail, worn upon the brow. '
        'Death and rebirth spiral endlessly within its coils.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 70,
    price: 54000,
    magic: 50,
    health: 120,
    defense: 25,
    effect:
        'Eternal Cycle: upon dying, revive once with 30% HP. All cooldowns reset on revival.',
  ),

  const Item(
    id: 'acc_013',
    name: 'Soul Chain of the Lich',
    description:
        'A chain of soul-forged links connecting the wearer to a hidden phylactery. '
        'As long as the chain holds, death is merely an inconvenience.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 80,
    price: 61500,
    magic: 55,
    defense: 35,
    health: 150,
    effect:
        'Phylactery Bond: reduce all damage by 10%. Once per battle, negate a killing blow and heal 50% HP.',
  ),

  const Item(
    id: 'acc_014',
    name: 'Eye of the Abyss',
    description:
        'You gazed into the Abyss, and the Abyss gazed back — '
        'then blinked. Now you carry its eye, and nothing is hidden from you.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 90,
    price: 69750,
    magic: 70,
    attack: 30,
    agility: 30,
    effect:
        'Abyssal Gaze: all enemy stats are visible. Spells ignore magic resistance. +20% crit chance.',
  ),

  const Item(
    id: 'acc_015',
    name: 'The First Sin',
    description:
        'The original transgression — the moment the first mortal defied the gods — '
        'crystallized into a black diamond. To wear it is to carry the weight of all rebellion.',
    type: ItemType.accessory,
    rarity: Rarity.mythic,
    level: 100,
    price: 78000,
    attack: 50,
    magic: 50,
    agility: 50,
    health: 100,
    effect:
        'Primordial Defiance: immune to divine damage. All stats +10%. Damage dealt can never be reduced below 50%.',
  ),

  // ─────────────────────────────────────────────────────────
  //  R E L I C S
  // ─────────────────────────────────────────────────────────
  const Item(
    id: 'rel_001',
    name: 'Broken Hourglass Shard',
    description:
        'A fragment of an hourglass that once measured the lifespan of a god. '
        'Time stutters in its presence.',
    type: ItemType.relic,
    rarity: Rarity.common,
    level: 1,
    price: 100,
    agility: 3,
    effect: 'Time Stutter: 5% chance to gain an extra action per turn.',
  ),

  const Item(
    id: 'rel_002',
    name: 'Whispering Skull',
    description:
        'A charred human skull that mutters secrets of the recently dead. '
        'Press your ear close — if you dare.',
    type: ItemType.relic,
    rarity: Rarity.common,
    level: 5,
    price: 300,
    magic: 6,
    effect: 'Dead Whispers: reveals enemy weaknesses at the start of battle.',
  ),

  const Item(
    id: 'rel_003',
    name: 'Candle of the Vigil',
    description:
        'A black wax candle with a pale flame that never extinguishes. '
        'It was lit at the funeral of the world and has burned since.',
    type: ItemType.relic,
    rarity: Rarity.common,
    level: 10,
    price: 550,
    magic: 8,
    health: 20,
    effect:
        'Vigil Light: regenerate 2% HP per turn. Undead enemies deal 10% less damage.',
  ),

  const Item(
    id: 'rel_004',
    name: 'Tome of Forbidden Whispers',
    description:
        'Pages inscribed in blood that shifts and rewrites itself. '
        'Reading it teaches dark arts — but each page read takes something from you.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 15,
    price: 2400,
    magic: 22,
    health: -10,
    effect:
        'Forbidden Knowledge: spell damage +20%. Learning new spells costs 30% less XP.',
  ),

  const Item(
    id: 'rel_005',
    name: 'Chalice of Sorrow',
    description:
        'A goblet that endlessly fills with the tears of the mourning. '
        'Drinking from it grants visions of loss — and terrible clarity.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 20,
    price: 3150,
    magic: 18,
    health: 50,
    defense: 8,
    effect:
        'Grief\'s Clarity: +15% spell accuracy. After an ally falls, gain +25% all stats for 3 turns.',
  ),

  const Item(
    id: 'rel_006',
    name: 'Petrified Demon Heart',
    description:
        'A heart of stone that still beats with malevolent energy. '
        'Hold it long enough and you\'ll feel your own heart try to match its rhythm.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 25,
    price: 3900,
    attack: 15,
    magic: 15,
    health: 40,
    effect: 'Demonic Pulse: every 3rd attack deals 50% bonus dark damage.',
  ),

  const Item(
    id: 'rel_007',
    name: 'Mirror of Lost Souls',
    description:
        'A hand mirror that shows reflections of every soul that died in your vicinity. '
        'The glass is always fogged with spectral breath.',
    type: ItemType.relic,
    rarity: Rarity.rare,
    level: 30,
    price: 4650,
    magic: 25,
    defense: 15,
    effect:
        'Soul Mirror: reflects 15% of magic damage back at the caster. Shows enemy spell cooldowns.',
  ),

  const Item(
    id: 'rel_008',
    name: 'Black Feather of Morrigan',
    description:
        'A single raven\'s feather, impossibly dark, from the war goddess herself. '
        'Battles fought in its presence are longer, bloodier, and more rewarding.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 35,
    price: 12950,
    attack: 20,
    agility: 20,
    magic: 20,
    effect:
        'War Goddess\'s Favor: +25% XP from combat. Critical hits have a 10% chance to instantly kill non-boss enemies.',
  ),

  const Item(
    id: 'rel_009',
    name: 'Lantern of the Ferryman',
    description:
        'The ghostly lantern that once guided dead souls across the River Styx. '
        'It illuminates paths no living eye should see.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 40,
    price: 14700,
    magic: 30,
    agility: 15,
    health: 60,
    effect:
        'Ferryman\'s Light: reveals all hidden enemies and traps. +15% evasion. Opens sealed spirit doors.',
  ),

  const Item(
    id: 'rel_010',
    name: 'Void Shard',
    description:
        'A piece of literal nothingness — a hole in reality shaped like a crystal. '
        'Staring into it, you see forever, and forever stares back hungry.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 50,
    price: 18200,
    magic: 40,
    attack: 15,
    effect:
        'Void Rift: spells have a 10% chance to open a void rift dealing 200% magic damage. Immune to Void damage.',
  ),

  const Item(
    id: 'rel_011',
    name: 'Necronomicon Fragment',
    description:
        'Tattered pages from the Book of the Dead, bound in skin that weeps. '
        'The text rearranges itself to teach you what you most desire — and most fear.',
    type: ItemType.relic,
    rarity: Rarity.epic,
    level: 60,
    price: 21700,
    magic: 55,
    health: 80,
    effect:
        'Necromancy: summon a Skeletal Servant once per battle (stats = 30% of yours). Dark spells cost 40% less.',
  ),

  const Item(
    id: 'rel_012',
    name: 'Heart of the World Tree',
    description:
        'The corrupted core of Yggdrasil — the great tree that once connected all realms. '
        'It beats with a sickly green pulse, leaking primordial energy.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 70,
    price: 54000,
    magic: 60,
    health: 200,
    defense: 30,
    effect:
        'World Root: regenerate 5% max HP per turn. All nature spells deal double damage. Immune to rot and decay.',
  ),

  const Item(
    id: 'rel_013',
    name: 'Ark of Damned Souls',
    description:
        'A small iron chest containing a thousand screaming spirits compressed into a singularity of agony. '
        'Opening it is inadvisable. Carrying it is worse.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 80,
    price: 61500,
    magic: 70,
    attack: 30,
    health: 100,
    effect:
        'Soul Storm: once per battle, release all souls for AoE damage equal to 300% MAG. Enemies hit are Feared for 2 turns.',
  ),

  const Item(
    id: 'rel_014',
    name: 'Philosopher\'s Bane',
    description:
        'The antithesis of the Philosopher\'s Stone — it does not transmute lead to gold, '
        'but unmakes matter entirely. To hold it is to hold annihilation.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 90,
    price: 69750,
    magic: 80,
    attack: 40,
    agility: 20,
    effect:
        'Annihilate: attacks permanently reduce enemy DEF by 5% (stacks infinitely). Spells ignore shields.',
  ),

  const Item(
    id: 'rel_015',
    name: 'The Void Throne Shard',
    description:
        'A fragment of the Seat of Oblivion — the throne upon which Nothing sits. '
        'Whoever possesses it commands a sliver of absolute entropy. '
        'The universe bends to avoid its touch.',
    type: ItemType.relic,
    rarity: Rarity.mythic,
    level: 100,
    price: 78000,
    magic: 100,
    attack: 40,
    defense: 40,
    health: 200,
    effect:
        'Oblivion\'s Will: all damage +20%. Once per battle, erase one enemy ability permanently. Immune to all debuffs.',
  ),
];

// ─────────────────────────────────────────────────────────────
//  HELPER GETTERS
// ─────────────────────────────────────────────────────────────

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

/// Items filtered by level range (inclusive).
List<Item> itemsForLevelRange(int minLevel, int maxLevel) =>
    allItems.where((i) => i.level >= minLevel && i.level <= maxLevel).toList();

/// Items available for a given player level (items at or below that level).
List<Item> itemsAvailableAtLevel(int playerLevel) =>
    allItems.where((i) => i.level <= playerLevel).toList();

/// Items filtered by rarity.
List<Item> itemsByRarity(Rarity rarity) =>
    allItems.where((i) => i.rarity == rarity).toList();
