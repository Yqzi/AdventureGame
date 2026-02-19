class StoryEvent {
  final String narrative;
  final StoryEffects effects;
  final List<String> choices;

  const StoryEvent({
    required this.narrative,
    required this.effects,
    required this.choices,
  });

  factory StoryEvent.fromJson(Map<String, dynamic> json) {
    return StoryEvent(
      narrative: json['narrative'] as String,
      effects: StoryEffects.fromJson(json['effects'] as Map<String, dynamic>),
      choices: List<String>.from(json['choices'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'narrative': narrative,
    'effects': effects.toJson(),
    'choices': choices,
  };
}

class StoryEffects {
  final int damage;
  final int heal;
  final int manaSpent;
  final int manaRestored;
  final int goldGained;
  final int goldLost;
  final int xpGained;
  final String? statusAdded;
  final String? statusRemoved;
  final String? itemGainedId;
  final String? itemLostId;
  final String? newLocation;
  final bool questCompleted;
  final bool questFailed;

  const StoryEffects({
    this.damage = 0,
    this.heal = 0,
    this.manaSpent = 0,
    this.manaRestored = 0,
    this.goldGained = 0,
    this.goldLost = 0,
    this.xpGained = 0,
    this.statusAdded,
    this.statusRemoved,
    this.itemGainedId,
    this.itemLostId,
    this.newLocation,
    this.questCompleted = false,
    this.questFailed = false,
  });

  /// No effects at all — useful as a default.
  static const StoryEffects none = StoryEffects();

  factory StoryEffects.fromJson(Map<String, dynamic> json) {
    return StoryEffects(
      damage: json['damage'] as int? ?? 0,
      heal: json['heal'] as int? ?? 0,
      manaSpent: json['manaSpent'] as int? ?? 0,
      manaRestored: json['manaRestored'] as int? ?? 0,
      goldGained: json['goldGained'] as int? ?? 0,
      goldLost: json['goldLost'] as int? ?? 0,
      xpGained: json['xpGained'] as int? ?? 0,
      statusAdded: json['statusAdded'] as String?,
      statusRemoved: json['statusRemoved'] as String?,
      itemGainedId: json['itemGained'] as String?,
      itemLostId: json['itemLost'] as String?,
      newLocation: json['newLocation'] as String?,
      questCompleted: json['questCompleted'] as bool? ?? false,
      questFailed: json['questFailed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'damage': damage,
    'heal': heal,
    'manaSpent': manaSpent,
    'manaRestored': manaRestored,
    'goldGained': goldGained,
    'goldLost': goldLost,
    'xpGained': xpGained,
    'statusAdded': statusAdded,
    'statusRemoved': statusRemoved,
    'itemGained': itemGainedId,
    'itemLost': itemLostId,
    'newLocation': newLocation,
    'questCompleted': questCompleted,
    'questFailed': questFailed,
  };

  /// Returns true if at least one effect is non-zero / non-null.
  bool get hasAnyEffect =>
      damage > 0 ||
      heal > 0 ||
      manaSpent > 0 ||
      manaRestored > 0 ||
      goldGained > 0 ||
      goldLost > 0 ||
      xpGained > 0 ||
      statusAdded != null ||
      statusRemoved != null ||
      itemGainedId != null ||
      itemLostId != null ||
      newLocation != null ||
      questCompleted ||
      questFailed;
}
