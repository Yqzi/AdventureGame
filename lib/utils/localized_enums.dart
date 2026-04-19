import 'package:Questborne/l10n/app_localizations.dart';
import 'package:Questborne/components/cards.dart' show Rarity;
import 'package:Questborne/models/item.dart' show ItemType;
import 'package:Questborne/models/quest.dart' show QuestDifficulty;

String localizedDifficulty(AppLocalizations l10n, QuestDifficulty d) {
  switch (d) {
    case QuestDifficulty.routine:
      return l10n.difficultyRoutine;
    case QuestDifficulty.dangerous:
      return l10n.difficultyDangerous;
    case QuestDifficulty.perilous:
      return l10n.difficultyPerilous;
    case QuestDifficulty.suicidal:
      return l10n.difficultySuicidal;
  }
}

String localizedItemType(AppLocalizations l10n, ItemType t) {
  switch (t) {
    case ItemType.weapon:
      return l10n.itemTypeWeapon;
    case ItemType.armor:
      return l10n.itemTypeArmor;
    case ItemType.accessory:
      return l10n.itemTypeAccessory;
    case ItemType.relic:
      return l10n.itemTypeRelic;
    case ItemType.spell:
      return l10n.itemTypeSpell;
  }
}

String localizedRarity(AppLocalizations l10n, Rarity r) {
  switch (r) {
    case Rarity.common:
      return l10n.rarityCommon;
    case Rarity.rare:
      return l10n.rarityRare;
    case Rarity.epic:
      return l10n.rarityEpic;
    case Rarity.mythic:
      return l10n.rarityMythic;
  }
}

/// Build localized stat summary string like "5 MP  ·  +10 ATK  ·  +5 DEF"
String localizedStatSummary(
  AppLocalizations l10n, {
  int manaCost = 0,
  int attack = 0,
  int defense = 0,
  int magic = 0,
  int agility = 0,
  int health = 0,
  String effect = '',
}) {
  final parts = <String>[];
  if (manaCost > 0) parts.add('$manaCost ${l10n.statMp}');
  if (attack > 0) parts.add('+$attack ${l10n.statAtk}');
  if (defense > 0) parts.add('+$defense ${l10n.statDef}');
  if (magic > 0) parts.add('+$magic ${l10n.statMag}');
  if (agility > 0) parts.add('+$agility ${l10n.statAgi}');
  if (health > 0) parts.add('+$health ${l10n.statHp}');
  if (effect.isNotEmpty) parts.add(effect);
  return parts.join('  ·  ');
}
