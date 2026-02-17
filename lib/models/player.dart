import 'package:equatable/equatable.dart';
import 'package:tes/models/item.dart';

// ─────────────────────────────────────────────────────────────
//  STATUS EFFECTS
// ─────────────────────────────────────────────────────────────

enum StatusEffect { poisoned, burning, frozen, blessed, shielded, weakened }

extension StatusEffectExtension on StatusEffect {
  String get label {
    switch (this) {
      case StatusEffect.poisoned:
        return 'POISONED';
      case StatusEffect.burning:
        return 'BURNING';
      case StatusEffect.frozen:
        return 'FROZEN';
      case StatusEffect.blessed:
        return 'BLESSED';
      case StatusEffect.shielded:
        return 'SHIELDED';
      case StatusEffect.weakened:
        return 'WEAKENED';
    }
  }

  String get icon {
    switch (this) {
      case StatusEffect.poisoned:
        return '☠️';
      case StatusEffect.burning:
        return '🔥';
      case StatusEffect.frozen:
        return '❄️';
      case StatusEffect.blessed:
        return '✨';
      case StatusEffect.shielded:
        return '🛡️';
      case StatusEffect.weakened:
        return '💀';
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

  const Equipment({this.weapon, this.armor, this.accessory, this.relic});

  /// Total bonus for a given stat across all equipped items.
  int totalBonus(String stat) {
    int total = 0;
    for (final item in [weapon, armor, accessory, relic]) {
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
    }
  }

  /// Returns a new [Equipment] with the given item placed in its slot.
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
    }
  }

  /// Returns a new [Equipment] with the given slot cleared.
  Equipment unequip(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Equipment(armor: armor, accessory: accessory, relic: relic);
      case ItemType.armor:
        return Equipment(weapon: weapon, accessory: accessory, relic: relic);
      case ItemType.accessory:
        return Equipment(weapon: weapon, armor: armor, relic: relic);
      case ItemType.relic:
        return Equipment(weapon: weapon, armor: armor, accessory: accessory);
    }
  }

  Equipment copyWith({
    Item? weapon,
    Item? armor,
    Item? accessory,
    Item? relic,
  }) {
    return Equipment(
      weapon: weapon ?? this.weapon,
      armor: armor ?? this.armor,
      accessory: accessory ?? this.accessory,
      relic: relic ?? this.relic,
    );
  }

  Map<String, dynamic> toJson() => {
    'weapon': weapon?.id,
    'armor': armor?.id,
    'accessory': accessory?.id,
    'relic': relic?.id,
  };

  @override
  List<Object?> get props => [weapon, armor, accessory, relic];
}

// ═════════════════════════════════════════════════════════════
//  PLAYER MODEL
// ═════════════════════════════════════════════════════════════

class Player extends Equatable {
  // ── Identity ──
  final String id;
  final String name;

  // ── Progression ──
  final int level;
  final int experience;
  final int skillPoints;

  // ── Vitals ──
  final int currentHealth;
  final int currentMana;

  // ── Base stats (without equipment) ──
  final int baseHealth;
  final int baseMana;
  final int baseAttack;
  final int baseDefense;
  final int baseMagic;
  final int baseAgility;

  // ── Economy ──
  final int gold;

  // ── Gear ──
  final Equipment equipment;
  final List<Item> inventory;

  // ── Status ──
  final List<StatusEffect> statusEffects;
  final String currentLocation;
  final int questsCompleted;
  final int enemiesDefeated;

  const Player({
    required this.id,
    required this.name,
    this.level = 1,
    this.experience = 0,
    this.skillPoints = 0,
    required this.currentHealth,
    required this.currentMana,
    required this.baseHealth,
    required this.baseMana,
    required this.baseAttack,
    required this.baseDefense,
    required this.baseMagic,
    required this.baseAgility,
    this.gold = 0,
    this.equipment = const Equipment(),
    this.inventory = const [],
    this.statusEffects = const [],
    this.currentLocation = 'Unknown',
    this.questsCompleted = 0,
    this.enemiesDefeated = 0,
  });

  // ─────────────────────────────────────────────────────────
  //  FACTORY — Create a fresh player with default starting stats
  // ─────────────────────────────────────────────────────────

  /// Default starting stats for a new adventurer.
  static const int _defaultHealth = 100;
  static const int _defaultMana = 50;
  static const int _defaultAttack = 10;
  static const int _defaultDefense = 8;
  static const int _defaultMagic = 6;
  static const int _defaultAgility = 8;

  factory Player.create({
    required String id,
    required String name,
    int health = _defaultHealth,
    int mana = _defaultMana,
    int attack = _defaultAttack,
    int defense = _defaultDefense,
    int magic = _defaultMagic,
    int agility = _defaultAgility,
    int gold = 100,
  }) {
    return Player(
      id: id,
      name: name,
      baseHealth: health,
      baseMana: mana,
      baseAttack: attack,
      baseDefense: defense,
      baseMagic: magic,
      baseAgility: agility,
      currentHealth: health,
      currentMana: mana,
      gold: gold,
    );
  }

  // ─────────────────────────────────────────────────────────
  //  COMPUTED STATS (base + equipment bonuses)
  // ─────────────────────────────────────────────────────────

  int get maxHealth => baseHealth + equipment.totalBonus('health');
  int get maxMana => baseMana;
  int get attack => baseAttack + equipment.totalBonus('attack');
  int get defense => baseDefense + equipment.totalBonus('defense');
  int get magic => baseMagic + equipment.totalBonus('magic');
  int get agility => baseAgility + equipment.totalBonus('agility');

  // ─────────────────────────────────────────────────────────
  //  HEALTH & MANA PERCENTAGES (for stat bars)
  // ─────────────────────────────────────────────────────────

  /// 0–100 representing how much health has been **consumed**.
  double get healthConsumed =>
      maxHealth > 0 ? ((1 - currentHealth / maxHealth) * 100) : 100;

  /// 0–100 representing how much mana has been **consumed**.
  double get manaConsumed =>
      maxMana > 0 ? ((1 - currentMana / maxMana) * 100) : 100;

  bool get isAlive => currentHealth > 0;
  bool get hasMana => currentMana > 0;

  // ─────────────────────────────────────────────────────────
  //  LEVELLING
  // ─────────────────────────────────────────────────────────

  /// XP required to reach the next level.
  int get experienceToNextLevel => level * 100 + (level * level * 10);

  /// Whether the player has enough XP to level up.
  bool get canLevelUp => experience >= experienceToNextLevel;

  /// Returns a new [Player] with the level incremented and stats scaled.
  Player levelUp() {
    if (!canLevelUp) return this;
    // Each level adds a percentage of current base stats
    final hpGain = (baseHealth * 0.12).round().clamp(1, 999);
    final manaGain = (baseMana * 0.10).round().clamp(1, 999);
    final atkGain = (baseAttack * 0.08).round().clamp(1, 999);
    final defGain = (baseDefense * 0.08).round().clamp(1, 999);
    final magGain = (baseMagic * 0.08).round().clamp(1, 999);
    final agiGain = (baseAgility * 0.08).round().clamp(1, 999);

    return copyWith(
      level: level + 1,
      experience: experience - experienceToNextLevel,
      skillPoints: skillPoints + 1,
      baseHealth: baseHealth + hpGain,
      baseMana: baseMana + manaGain,
      baseAttack: baseAttack + atkGain,
      baseDefense: baseDefense + defGain,
      baseMagic: baseMagic + magGain,
      baseAgility: baseAgility + agiGain,
      currentHealth:
          baseHealth +
          hpGain +
          equipment.totalBonus('health'), // Full heal on level up
      currentMana: baseMana + manaGain,
    );
  }

  // ─────────────────────────────────────────────────────────
  //  COMBAT HELPERS
  // ─────────────────────────────────────────────────────────

  Player takeDamage(int amount) {
    final reduced = (amount - (defense * 0.3)).round().clamp(1, amount);
    return copyWith(
      currentHealth: (currentHealth - reduced).clamp(0, maxHealth),
    );
  }

  Player heal(int amount) {
    return copyWith(
      currentHealth: (currentHealth + amount).clamp(0, maxHealth),
    );
  }

  Player spendMana(int amount) {
    return copyWith(currentMana: (currentMana - amount).clamp(0, maxMana));
  }

  Player restoreMana(int amount) {
    return copyWith(currentMana: (currentMana + amount).clamp(0, maxMana));
  }

  Player fullRestore() {
    return copyWith(currentHealth: maxHealth, currentMana: maxMana);
  }

  // ─────────────────────────────────────────────────────────
  //  INVENTORY & EQUIPMENT
  // ─────────────────────────────────────────────────────────

  /// Add an item to the inventory.
  Player addItem(Item item) {
    return copyWith(inventory: [...inventory, item]);
  }

  /// Remove an item from the inventory by id.
  Player removeItem(String itemId) {
    return copyWith(inventory: inventory.where((i) => i.id != itemId).toList());
  }

  /// Equip an item from inventory into its corresponding slot.
  /// The previously equipped item (if any) goes back to inventory.
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

  /// Unequip an item from a slot and return it to inventory.
  Player unequipSlot(ItemType type) {
    final item = equipment.getSlot(type);
    if (item == null) return this;
    return copyWith(
      equipment: equipment.unequip(type),
      inventory: [...inventory, item],
    );
  }

  /// Buy an item from the shop (deduct gold, add to inventory).
  Player buyItem(Item item) {
    if (gold < item.price) return this; // Not enough gold
    return copyWith(gold: gold - item.price, inventory: [...inventory, item]);
  }

  /// Sell an item for half its price.
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

  // ─────────────────────────────────────────────────────────
  //  EXPERIENCE & GOLD REWARDS
  // ─────────────────────────────────────────────────────────

  Player gainExperience(int amount) {
    return copyWith(experience: experience + amount);
  }

  Player gainGold(int amount) {
    return copyWith(gold: gold + amount);
  }

  Player spendGold(int amount) {
    return copyWith(gold: (gold - amount).clamp(0, gold));
  }

  Player incrementQuestsCompleted() {
    return copyWith(questsCompleted: questsCompleted + 1);
  }

  Player incrementEnemiesDefeated() {
    return copyWith(enemiesDefeated: enemiesDefeated + 1);
  }

  // ─────────────────────────────────────────────────────────
  //  STATUS EFFECTS
  // ─────────────────────────────────────────────────────────

  Player addStatus(StatusEffect effect) {
    if (statusEffects.contains(effect)) return this;
    return copyWith(statusEffects: [...statusEffects, effect]);
  }

  Player removeStatus(StatusEffect effect) {
    return copyWith(
      statusEffects: statusEffects.where((e) => e != effect).toList(),
    );
  }

  Player clearAllStatuses() {
    return copyWith(statusEffects: []);
  }

  bool hasStatus(StatusEffect effect) => statusEffects.contains(effect);

  // ─────────────────────────────────────────────────────────
  //  STAT SUMMARY (for UI display)
  // ─────────────────────────────────────────────────────────

  String get statSummary {
    return 'ATK $attack · DEF $defense · MAG $magic · AGI $agility';
  }

  String get vitalsSummary {
    return 'HP $currentHealth/$maxHealth · MP $currentMana/$maxMana';
  }

  // ─────────────────────────────────────────────────────────
  //  SERIALISATION
  // ─────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'level': level,
    'experience': experience,
    'skillPoints': skillPoints,
    'currentHealth': currentHealth,
    'currentMana': currentMana,
    'baseHealth': baseHealth,
    'baseMana': baseMana,
    'baseAttack': baseAttack,
    'baseDefense': baseDefense,
    'baseMagic': baseMagic,
    'baseAgility': baseAgility,
    'gold': gold,
    'equipment': equipment.toJson(),
    'inventory': inventory.map((i) => i.id).toList(),
    'statusEffects': statusEffects.map((e) => e.index).toList(),
    'currentLocation': currentLocation,
    'questsCompleted': questsCompleted,
    'enemiesDefeated': enemiesDefeated,
  };

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      experience: json['experience'] as int,
      skillPoints: json['skillPoints'] as int? ?? 0,
      currentHealth: json['currentHealth'] as int,
      currentMana: json['currentMana'] as int,
      baseHealth: json['baseHealth'] as int,
      baseMana: json['baseMana'] as int,
      baseAttack: json['baseAttack'] as int,
      baseDefense: json['baseDefense'] as int,
      baseMagic: json['baseMagic'] as int,
      baseAgility: json['baseAgility'] as int,
      gold: json['gold'] as int? ?? 0,
      statusEffects:
          (json['statusEffects'] as List<dynamic>?)
              ?.map((e) => StatusEffect.values[e as int])
              .toList() ??
          [],
      currentLocation: json['currentLocation'] as String? ?? 'Unknown',
      questsCompleted: json['questsCompleted'] as int? ?? 0,
      enemiesDefeated: json['enemiesDefeated'] as int? ?? 0,
      // NOTE: equipment & inventory must be resolved separately
      //       using item IDs + your allItems list.
    );
  }

  // ─────────────────────────────────────────────────────────
  //  COPY-WITH (immutable updates for BLoC)
  // ─────────────────────────────────────────────────────────

  Player copyWith({
    String? id,
    String? name,
    int? level,
    int? experience,
    int? skillPoints,
    int? currentHealth,
    int? currentMana,
    int? baseHealth,
    int? baseMana,
    int? baseAttack,
    int? baseDefense,
    int? baseMagic,
    int? baseAgility,
    int? gold,
    Equipment? equipment,
    List<Item>? inventory,
    List<StatusEffect>? statusEffects,
    String? currentLocation,
    int? questsCompleted,
    int? enemiesDefeated,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      skillPoints: skillPoints ?? this.skillPoints,
      currentHealth: currentHealth ?? this.currentHealth,
      currentMana: currentMana ?? this.currentMana,
      baseHealth: baseHealth ?? this.baseHealth,
      baseMana: baseMana ?? this.baseMana,
      baseAttack: baseAttack ?? this.baseAttack,
      baseDefense: baseDefense ?? this.baseDefense,
      baseMagic: baseMagic ?? this.baseMagic,
      baseAgility: baseAgility ?? this.baseAgility,
      gold: gold ?? this.gold,
      equipment: equipment ?? this.equipment,
      inventory: inventory ?? this.inventory,
      statusEffects: statusEffects ?? this.statusEffects,
      currentLocation: currentLocation ?? this.currentLocation,
      questsCompleted: questsCompleted ?? this.questsCompleted,
      enemiesDefeated: enemiesDefeated ?? this.enemiesDefeated,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    level,
    experience,
    skillPoints,
    currentHealth,
    currentMana,
    baseHealth,
    baseMana,
    baseAttack,
    baseDefense,
    baseMagic,
    baseAgility,
    gold,
    equipment,
    inventory,
    statusEffects,
    currentLocation,
    questsCompleted,
    enemiesDefeated,
  ];

  @override
  String toString() => 'Player($name, Lv$level, HP $currentHealth/$maxHealth)';
}
