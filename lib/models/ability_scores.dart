import 'package:equatable/equatable.dart';

// ─────────────────────────────────────────────────────────────
//  ABILITY TYPE ENUM
// ─────────────────────────────────────────────────────────────

/// The six D&D 5e ability score types.
enum AbilityType {
  strength,
  dexterity,
  constitution,
  intelligence,
  wisdom,
  charisma,
}

extension AbilityTypeLabel on AbilityType {
  String get shortName {
    switch (this) {
      case AbilityType.strength:
        return 'STR';
      case AbilityType.dexterity:
        return 'DEX';
      case AbilityType.constitution:
        return 'CON';
      case AbilityType.intelligence:
        return 'INT';
      case AbilityType.wisdom:
        return 'WIS';
      case AbilityType.charisma:
        return 'CHA';
    }
  }

  String get fullName {
    switch (this) {
      case AbilityType.strength:
        return 'Strength';
      case AbilityType.dexterity:
        return 'Dexterity';
      case AbilityType.constitution:
        return 'Constitution';
      case AbilityType.intelligence:
        return 'Intelligence';
      case AbilityType.wisdom:
        return 'Wisdom';
      case AbilityType.charisma:
        return 'Charisma';
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  ABILITY SCORES
// ─────────────────────────────────────────────────────────────

/// D&D 5e ability scores for a player character.
///
/// Scores range from 1–20 for normal characters (with 20 being the ASI cap).
/// The modifier for each score is: `floor((score - 10) / 2)`.
class AbilityScores extends Equatable {
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  const AbilityScores({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  /// Default balanced scores for a new character (all 10).
  factory AbilityScores.defaults() => const AbilityScores(
    strength: 10,
    dexterity: 10,
    constitution: 10,
    intelligence: 10,
    wisdom: 10,
    charisma: 10,
  );

  /// Standard array values the player assigns during character creation.
  static const List<int> standardArray = [15, 14, 13, 12, 10, 8];

  /// D&D 5e ability modifier: floor((score - 10) / 2).
  /// Dart's ~/ operator floors towards negative infinity for negatives,
  /// which matches the D&D spec exactly.
  static int modifier(int score) => (score - 10) ~/ 2;

  // ── Per-ability modifiers ──
  int get strMod => modifier(strength);
  int get dexMod => modifier(dexterity);
  int get conMod => modifier(constitution);
  int get intMod => modifier(intelligence);
  int get wisMod => modifier(wisdom);
  int get chaMod => modifier(charisma);

  /// Get the raw score for an [AbilityType].
  int getScore(AbilityType ability) {
    switch (ability) {
      case AbilityType.strength:
        return strength;
      case AbilityType.dexterity:
        return dexterity;
      case AbilityType.constitution:
        return constitution;
      case AbilityType.intelligence:
        return intelligence;
      case AbilityType.wisdom:
        return wisdom;
      case AbilityType.charisma:
        return charisma;
    }
  }

  /// Get the ability modifier for an [AbilityType].
  int getMod(AbilityType ability) => modifier(getScore(ability));

  /// Returns a formatted modifier string like "+2" or "-1".
  static String formatMod(int mod) => mod >= 0 ? '+$mod' : '$mod';

  /// Apply racial ability score bonuses.
  AbilityScores applyBonuses(Map<AbilityType, int> bonuses) {
    return copyWith(
      strength: (strength + (bonuses[AbilityType.strength] ?? 0)).clamp(1, 30),
      dexterity: (dexterity + (bonuses[AbilityType.dexterity] ?? 0)).clamp(
        1,
        30,
      ),
      constitution: (constitution + (bonuses[AbilityType.constitution] ?? 0))
          .clamp(1, 30),
      intelligence: (intelligence + (bonuses[AbilityType.intelligence] ?? 0))
          .clamp(1, 30),
      wisdom: (wisdom + (bonuses[AbilityType.wisdom] ?? 0)).clamp(1, 30),
      charisma: (charisma + (bonuses[AbilityType.charisma] ?? 0)).clamp(1, 30),
    );
  }

  AbilityScores copyWith({
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
  }) {
    return AbilityScores(
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
    );
  }

  Map<String, dynamic> toJson() => {
    'str': strength,
    'dex': dexterity,
    'con': constitution,
    'int': intelligence,
    'wis': wisdom,
    'cha': charisma,
  };

  factory AbilityScores.fromJson(Map<String, dynamic> json) => AbilityScores(
    strength: json['str'] as int? ?? 10,
    dexterity: json['dex'] as int? ?? 10,
    constitution: json['con'] as int? ?? 10,
    intelligence: json['int'] as int? ?? 10,
    wisdom: json['wis'] as int? ?? 10,
    charisma: json['cha'] as int? ?? 10,
  );

  @override
  List<Object?> get props => [
    strength,
    dexterity,
    constitution,
    intelligence,
    wisdom,
    charisma,
  ];
}
