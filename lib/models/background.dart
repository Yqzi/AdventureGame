// ─────────────────────────────────────────────────────────────
//  D&D BACKGROUND ENUM
// ─────────────────────────────────────────────────────────────

/// D&D 5e character backgrounds (from the Basic Rules).
enum DndBackground {
  acolyte,
  charlatan,
  criminal,
  entertainer,
  folkHero,
  guildArtisan,
  hermit,
  noble,
  outlander,
  sage,
  sailor,
  soldier,
  urchin,
}

extension DndBackgroundLabel on DndBackground {
  String get displayName {
    switch (this) {
      case DndBackground.acolyte:
        return 'Acolyte';
      case DndBackground.charlatan:
        return 'Charlatan';
      case DndBackground.criminal:
        return 'Criminal';
      case DndBackground.entertainer:
        return 'Entertainer';
      case DndBackground.folkHero:
        return 'Folk Hero';
      case DndBackground.guildArtisan:
        return 'Guild Artisan';
      case DndBackground.hermit:
        return 'Hermit';
      case DndBackground.noble:
        return 'Noble';
      case DndBackground.outlander:
        return 'Outlander';
      case DndBackground.sage:
        return 'Sage';
      case DndBackground.sailor:
        return 'Sailor';
      case DndBackground.soldier:
        return 'Soldier';
      case DndBackground.urchin:
        return 'Urchin';
    }
  }

  /// Data object for this background.
  DndBackgroundData get data => DndBackgroundData.of(this);
}

// ─────────────────────────────────────────────────────────────
//  BACKGROUND DATA
// ─────────────────────────────────────────────────────────────

/// Static data for a D&D 5e character background.
class DndBackgroundData {
  /// Skills granted by this background.
  final List<String> skillProficiencies;

  /// Notable feature name.
  final String featureName;

  /// Feature description (for AI context and character sheet).
  final String featureDescription;

  /// Lore description of this background.
  final String description;

  const DndBackgroundData({
    required this.skillProficiencies,
    required this.featureName,
    required this.featureDescription,
    required this.description,
  });

  static DndBackgroundData of(DndBackground bg) => _data[bg]!;

  static final Map<DndBackground, DndBackgroundData> _data = {
    DndBackground.acolyte: const DndBackgroundData(
      skillProficiencies: ['Insight', 'Religion'],
      featureName: 'Shelter of the Faithful',
      featureDescription:
          'You command the respect of those who share your faith. You and your companions can receive free healing at temples of your deity, and you have connections to religious networks.',
      description:
          'You have spent your life in service to a temple, learning sacred rites and the tenets of your faith.',
    ),
    DndBackground.charlatan: const DndBackgroundData(
      skillProficiencies: ['Deception', 'Sleight of Hand'],
      featureName: 'False Identity',
      featureDescription:
          'You have created a second identity that includes documentation, established acquaintances, and disguises. You can forge documents and pass yourself off as a different person.',
      description:
          'You have always had a way with people. You know what makes them tick, how to persuade them and how to flatter them.',
    ),
    DndBackground.criminal: const DndBackgroundData(
      skillProficiencies: ['Deception', 'Stealth'],
      featureName: 'Criminal Contact',
      featureDescription:
          'You have a reliable and trustworthy contact in the criminal underworld who acts as your liaison to a network of criminals.',
      description:
          'You are an experienced criminal with a history of breaking the law — a smuggler, thief, or murderer.',
    ),
    DndBackground.entertainer: const DndBackgroundData(
      skillProficiencies: ['Acrobatics', 'Performance'],
      featureName: 'By Popular Demand',
      featureDescription:
          'You can always find a place to perform in an inn or tavern. Your performance earns you free lodging and food for yourself and your companions.',
      description:
          'You thrive in front of an audience. You know how to entrance, entertain, and captivate a crowd.',
    ),
    DndBackground.folkHero: const DndBackgroundData(
      skillProficiencies: ['Animal Handling', 'Survival'],
      featureName: 'Rustic Hospitality',
      featureDescription:
          'Since you come from the ranks of common folk, you fit in among them with ease. They will shield you from authorities and provide simple needs.',
      description:
          'You come from a humble social rank but are destined for so much more. Already the people of your home village regard you as their champion.',
    ),
    DndBackground.guildArtisan: const DndBackgroundData(
      skillProficiencies: ['Insight', 'Persuasion'],
      featureName: 'Guild Membership',
      featureDescription:
          'As an established member of a merchant guild, you can rely on certain benefits. Fellow guild members provide lodging and food, and the guild may bail you out of legal trouble.',
      description:
          'You are a member of an artisan\'s guild, skilled in a particular field and closely associated with other artisans.',
    ),
    DndBackground.hermit: const DndBackgroundData(
      skillProficiencies: ['Medicine', 'Religion'],
      featureName: 'Discovery',
      featureDescription:
          'During your time in seclusion, you made a unique discovery — a truth about a great power, an ancient prophecy, or a forgotten secret that could shake the world.',
      description:
          'You lived in seclusion for a formative part of your life, either in a sheltered community or entirely alone.',
    ),
    DndBackground.noble: const DndBackgroundData(
      skillProficiencies: ['History', 'Persuasion'],
      featureName: 'Position of Privilege',
      featureDescription:
          'Thanks to your noble birth, people are inclined to think the best of you. You are welcome in high society and people assume you have the right to be wherever you are.',
      description:
          'You understand wealth, power, and privilege. You carry a noble title and your family owns land, collects taxes, and wields significant political influence.',
    ),
    DndBackground.outlander: const DndBackgroundData(
      skillProficiencies: ['Athletics', 'Survival'],
      featureName: 'Wanderer',
      featureDescription:
          'You have an excellent memory for maps and geography. You can always recall the general layout of terrain, settlements, and other features around you.',
      description:
          'You grew up in the wilds, far from civilization and the comforts of town and technology.',
    ),
    DndBackground.sage: const DndBackgroundData(
      skillProficiencies: ['Arcana', 'History'],
      featureName: 'Researcher',
      featureDescription:
          'When you attempt to learn or recall a piece of lore, if you don\'t know the information, you often know where and from whom you can obtain it.',
      description:
          'You spent years learning the lore of the multiverse. You scoured manuscripts, studied scrolls, and listened to the greatest experts.',
    ),
    DndBackground.sailor: const DndBackgroundData(
      skillProficiencies: ['Athletics', 'Perception'],
      featureName: 'Ship\'s Passage',
      featureDescription:
          'When you need passage on a sailing ship, you can secure free passage in exchange for working during the voyage. You can also arrange passage for your companions.',
      description:
          'You sailed on a seagoing vessel for years. In that time, you faced down mighty storms, sea monsters, and those who wanted to sink your ship.',
    ),
    DndBackground.soldier: const DndBackgroundData(
      skillProficiencies: ['Athletics', 'Intimidation'],
      featureName: 'Military Rank',
      featureDescription:
          'You have a military rank from your career as a soldier. Soldiers loyal to your former military organization still recognize your authority and defer to you.',
      description:
          'War has been your life for as long as you care to remember. You trained as a youth, studied the use of weapons and armor, and learned basic survival techniques.',
    ),
    DndBackground.urchin: const DndBackgroundData(
      skillProficiencies: ['Sleight of Hand', 'Stealth'],
      featureName: 'City Secrets',
      featureDescription:
          'You know the secret patterns and flow of cities and can find passages through the urban sprawl that others would miss. You can move through a city twice as fast as normal.',
      description:
          'You grew up on the streets alone, orphaned, and poor. You had no one to watch over you and had to learn to provide for yourself.',
    ),
  };
}
