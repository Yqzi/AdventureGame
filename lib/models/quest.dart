import 'dart:math';

// ─────────────────────────────────────────────────────────────
//  QUEST DIFFICULTY
// ─────────────────────────────────────────────────────────────

enum QuestDifficulty {
  routine,
  dangerous,
  perilous,
  suicidal;

  String get label {
    switch (this) {
      case QuestDifficulty.routine:
        return 'Routine Task';
      case QuestDifficulty.dangerous:
        return 'Dangerous';
      case QuestDifficulty.perilous:
        return 'Perilous';
      case QuestDifficulty.suicidal:
        return 'Suicidal';
    }
  }

  int get skulls {
    switch (this) {
      case QuestDifficulty.routine:
        return 1;
      case QuestDifficulty.dangerous:
        return 2;
      case QuestDifficulty.perilous:
        return 3;
      case QuestDifficulty.suicidal:
        return 5;
    }
  }
}

// ─────────────────────────────────────────────────────────────
//  QUEST MODEL
// ─────────────────────────────────────────────────────────────

class Quest {
  final String id;
  final String title;
  final String description;
  final String objective;
  final String location;
  final QuestDifficulty difficulty;
  final int goldReward;
  final int xpReward;
  final int recommendedLevel;
  final List<String> keyNPCs;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.objective,
    required this.location,
    required this.difficulty,
    required this.goldReward,
    required this.xpReward,
    required this.recommendedLevel,
    this.keyNPCs = const [],
  });

  String get rewardLabel => '$goldReward Gold  ·  $xpReward XP';

  /// Convert to the Map<String, dynamic> that GameBloc expects.
  Map<String, dynamic> toQuestDetails() => {
    'title': title,
    'objective': objective,
    'location': location,
    'description': description,
    'reward': rewardLabel,
    'keyNPCs': keyNPCs,
  };

  /// Pick 4 daily quests with a (2, 1, 1) location spread.
  /// The "double" location rotates daily: Forest → Cave → Ruins.
  /// Uses a day-based seed so the selection stays the same all day.
  static List<Quest> dailyQuests({required int playerLevel, int count = 4}) {
    final now = DateTime.now();
    final daySeed = now.year * 10000 + now.month * 100 + now.day;
    final rng = Random(daySeed);

    const locations = ['Forest', 'Cave', 'Ruins'];
    // Rotate which location gets 2 quests each day
    final doubleIndex = daySeed % 3;
    final doubleLocation = locations[doubleIndex];
    final singleLocations = [
      locations[(doubleIndex + 1) % 3],
      locations[(doubleIndex + 2) % 3],
    ];

    final low = (playerLevel - 10).clamp(1, 100);
    final high = (playerLevel + 10).clamp(1, 100);

    List<Quest> _pickFromLocation(String loc, int n) {
      var pool = allQuests
          .where(
            (q) =>
                q.location == loc &&
                q.recommendedLevel >= low &&
                q.recommendedLevel <= high,
          )
          .toList();

      // Fallback: if not enough quests in level range, pick closest ones
      if (pool.length < n) {
        pool = allQuests.where((q) => q.location == loc).toList()
          ..sort(
            (a, b) => (a.recommendedLevel - playerLevel).abs().compareTo(
              (b.recommendedLevel - playerLevel).abs(),
            ),
          );
      }

      pool.shuffle(rng);
      return pool.take(n).toList();
    }

    final results = <Quest>[
      ..._pickFromLocation(doubleLocation, 2),
      ..._pickFromLocation(singleLocations[0], 1),
      ..._pickFromLocation(singleLocations[1], 1),
    ];

    results.shuffle(rng);
    return results;
  }
}

// ═════════════════════════════════════════════════════════════
//  ALL GAME QUESTS  —  Three maps: Forest · Cave · Ruins
// ═════════════════════════════════════════════════════════════

final List<Quest> allQuests = [
  // ══════════════════════════════════════
  //  FOREST  —  Levels 1–100
  // ══════════════════════════════════════

  // ── Forest: Levels 1–10 ──
  const Quest(
    id: 'f_001',
    title: 'Goblin Camps',
    description:
        'Goblin scouts have set up camps along the forest trails. Woodcutters refuse to enter.',
    objective:
        'Locate and destroy the goblin camps scattered through the forest.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 80,
    xpReward: 40,
    recommendedLevel: 1,
    keyNPCs: ['Village Elder Rowan'],
  ),
  const Quest(
    id: 'f_002',
    title: 'Wolves on the Path',
    description:
        'A pack of dire wolves has claimed the main forest road. Travelers are being dragged into the underbrush.',
    objective: 'Hunt or drive off the dire wolf pack along the forest path.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 100,
    xpReward: 50,
    recommendedLevel: 3,
    keyNPCs: ['Militia Captain Dara'],
  ),
  const Quest(
    id: 'f_003',
    title: 'The Poisoned Stream',
    description:
        'A foul green sludge seeps from somewhere upstream. Animals that drink from the brook collapse dead.',
    objective:
        'Follow the stream through the forest and destroy whatever is poisoning it.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 90,
    xpReward: 45,
    recommendedLevel: 2,
    keyNPCs: ['Herbalist Nessa'],
  ),
  const Quest(
    id: 'f_004',
    title: 'The Missing Woodcutter',
    description:
        'Old Henrik went to fell timber three days ago. His axe was found embedded in a tree, covered in claw marks.',
    objective:
        'Track the missing woodcutter deeper into the forest and learn his fate.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 70,
    xpReward: 35,
    recommendedLevel: 1,
    keyNPCs: ['Henrik\'s Wife Maren'],
  ),
  const Quest(
    id: 'f_005',
    title: 'Bandit Ambush',
    description:
        'Bandits have been robbing merchants on the forest road. They vanish into the canopy before the guard arrives.',
    objective: 'Set a trap for the forest bandits and take down their leader.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 200,
    xpReward: 70,
    recommendedLevel: 5,
    keyNPCs: ['Merchant Aldric', 'Bandit Chief Grath'],
  ),
  const Quest(
    id: 'f_006',
    title: 'Curse of the Black Vine',
    description:
        'A thorned blight is creeping across the forest floor. It moves on its own at night, strangling trees.',
    objective:
        'Find the heart of the Black Vine deep in the forest and burn it out.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 250,
    xpReward: 85,
    recommendedLevel: 8,
  ),

  // ── Forest: Levels 11–25 ──
  const Quest(
    id: 'f_007',
    title: 'The Scarecrow Harvest',
    description:
        'Scarecrows at the forest\'s edge have blood on their hands. Something animates them at sunset.',
    objective:
        'Destroy the cursed idol hidden in the tree line that animates the scarecrows.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 300,
    xpReward: 95,
    recommendedLevel: 11,
    keyNPCs: ['Farmer\'s Son Pieter'],
  ),
  const Quest(
    id: 'f_008',
    title: 'The Witch\'s Bargain',
    description:
        'A forest witch offers cures for the village plague — but her price is a living heart.',
    objective:
        'Venture to the witch\'s grove and find another way to cure the plague.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 350,
    xpReward: 100,
    recommendedLevel: 13,
    keyNPCs: ['Witch Morgatha'],
  ),
  const Quest(
    id: 'f_009',
    title: 'The Beast of the Thicket',
    description:
        'Livestock at the forest\'s edge is being torn apart by something massive. Claw marks are as wide as a man\'s arm.',
    objective:
        'Track and slay the beast lurking in the deepest thicket of the forest.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 500,
    xpReward: 120,
    recommendedLevel: 16,
    keyNPCs: ['Farmer Gregor'],
  ),
  const Quest(
    id: 'f_010',
    title: 'Spider Nests',
    description:
        'Giant webs span the canopy for miles. Cocooned travelers dangle from the branches, some still alive.',
    objective:
        'Burn the spider queen\'s nest in the forest canopy and save the trapped travelers.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 550,
    xpReward: 130,
    recommendedLevel: 19,
    keyNPCs: ['Ranger Elara'],
  ),
  const Quest(
    id: 'f_011',
    title: 'The Verdant Terror',
    description:
        'A monstrous plant creature has taken root at the forest\'s heart. It lashes out at anything that moves.',
    objective:
        'Cut through the forest overgrowth to reach and destroy the Verdant Terror.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 600,
    xpReward: 140,
    recommendedLevel: 22,
    keyNPCs: ['Druid Theron'],
  ),

  // ── Forest: Levels 26–50 ──
  const Quest(
    id: 'f_012',
    title: 'Crown of Thorns',
    description:
        'A corrupted treant has claimed the deepest grove. The forest itself attacks any who enter.',
    objective:
        'Find and destroy the corrupted treant at the heart of the ancient grove.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1000,
    xpReward: 190,
    recommendedLevel: 30,
    keyNPCs: ['Ranger Elara'],
  ),
  const Quest(
    id: 'f_013',
    title: 'The Dragon\'s Hunting Ground',
    description:
        'A young dragon has claimed the forest as its hunting territory. Charred clearings mark its kills.',
    objective: 'Track the dragon to its forest lair and slay or drive it away.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 1500,
    xpReward: 250,
    recommendedLevel: 35,
    keyNPCs: ['Dragon Irythas'],
  ),
  const Quest(
    id: 'f_014',
    title: 'The Burning Cult',
    description:
        'A fanatical fire cult is burning the forest from within. Their pyre-altars glow between the trees.',
    objective:
        'Infiltrate the cult\'s forest encampment and assassinate their pyromancer leader.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2000,
    xpReward: 300,
    recommendedLevel: 42,
    keyNPCs: ['High Pyromancer Vex', 'Spy Maren'],
  ),
  const Quest(
    id: 'f_015',
    title: 'Orc War-Camp',
    description:
        'An orc warband has built a fortified camp in the forest. They raid surrounding villages nightly.',
    objective:
        'Storm the orc war-camp hidden in the forest and break their siege.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 1800,
    xpReward: 280,
    recommendedLevel: 38,
    keyNPCs: ['Commander Hale', 'Warchief Gorak'],
  ),
  const Quest(
    id: 'f_016',
    title: 'The Fey Uprising',
    description:
        'Fey creatures have turned hostile. The once-peaceful sprites now ambush and enchant anyone entering the canopy.',
    objective:
        'Find the corrupted Fey Stone in the forest glade and cleanse it.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1200,
    xpReward: 200,
    recommendedLevel: 28,
    keyNPCs: ['Druid Theron'],
  ),

  // ── Forest: Levels 51–75 ──
  const Quest(
    id: 'f_017',
    title: 'The Elder Wyrm',
    description:
        'An ancient wyrm slumbers beneath the roots of the World Tree. Earthquakes grow stronger each day.',
    objective:
        'Descend through the World Tree\'s roots in the forest and reseal the wyrm.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 3500,
    xpReward: 400,
    recommendedLevel: 55,
    keyNPCs: ['Keeper of the World Tree'],
  ),
  const Quest(
    id: 'f_018',
    title: 'Shadows in the Canopy',
    description:
        'An eternal twilight has fallen over the forest. Shadow creatures roam freely under the darkened canopy.',
    objective:
        'Find the Sunstone hidden in the forest shrine and restore daylight to the canopy.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4000,
    xpReward: 450,
    recommendedLevel: 62,
    keyNPCs: ['Sun Priestess Amara'],
  ),
  const Quest(
    id: 'f_019',
    title: 'The Bone Garden',
    description:
        'Skeletons grow from the forest floor like weeds. A necromancer has turned the grove into an army nursery.',
    objective:
        'Locate the necromancer\'s phylactery buried under the forest and shatter it.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4500,
    xpReward: 480,
    recommendedLevel: 70,
    keyNPCs: ['Necromancer\'s Shade'],
  ),

  // ── Forest: Levels 76–100 ──
  const Quest(
    id: 'f_020',
    title: 'The God-Eater',
    description:
        'Shrines throughout the forest have gone silent. A creature feeding on divine essence stalks between the trees.',
    objective:
        'Hunt the God-Eater through the sacred forest groves before it devours the last shrine\'s power.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 7000,
    xpReward: 550,
    recommendedLevel: 78,
    keyNPCs: ['Last Cleric Soren'],
  ),
  const Quest(
    id: 'f_021',
    title: 'The World Tree Burns',
    description:
        'Demonic fire engulfs the World Tree. If it falls, the forest — and everything it sustains — dies.',
    objective:
        'Ascend the burning World Tree and extinguish the infernal flame at its crown.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 10000,
    xpReward: 700,
    recommendedLevel: 90,
    keyNPCs: ['Spirit of the World Tree'],
  ),
  const Quest(
    id: 'f_022',
    title: 'The Titan\'s Stride',
    description:
        'A titan walks through the forest, each footstep flattening acres of ancient woodland.',
    objective:
        'Reach the titan\'s ankle-chains in the forest depths and reforge them before the forest is flattened.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 12000,
    xpReward: 800,
    recommendedLevel: 95,
    keyNPCs: ['Forge Spirit'],
  ),
  const Quest(
    id: 'f_023',
    title: 'Death\'s Grove',
    description:
        'The God of Death has planted a sapling in the forest. All who pass it wither to bone.',
    objective:
        'Uproot Death\'s sapling from the forest clearing and survive what guards it.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 15000,
    xpReward: 1000,
    recommendedLevel: 100,
    keyNPCs: ['Death', 'Spirit of the First Hero'],
  ),

  // ══════════════════════════════════════
  //  CAVE  —  Levels 1–100
  // ══════════════════════════════════════

  // ── Cave: Levels 1–10 ──
  const Quest(
    id: 'c_001',
    title: 'Cellar Dwellers',
    description:
        'Scratching echoes from the cave beneath the old inn. Something has moved into the upper tunnels.',
    objective:
        'Clear the creatures infesting the shallow cave system near the village.',
    location: 'Cave',
    difficulty: QuestDifficulty.routine,
    goldReward: 60,
    xpReward: 30,
    recommendedLevel: 1,
    keyNPCs: ['Innkeeper Bram'],
  ),
  const Quest(
    id: 'c_002',
    title: 'The Glowing Depths',
    description:
        'A faint green glow pulses from a cave mouth. The village well water has started tasting of rot.',
    objective:
        'Descend into the cave and purge whatever contaminates the underground water source.',
    location: 'Cave',
    difficulty: QuestDifficulty.routine,
    goldReward: 100,
    xpReward: 50,
    recommendedLevel: 4,
    keyNPCs: ['Herbalist Nessa'],
  ),
  const Quest(
    id: 'c_003',
    title: 'Bat Swarm',
    description:
        'Enormous cave bats have been swooping from a cavern entrance at dusk, terrorizing shepherds.',
    objective:
        'Enter the cave at dawn and clear out the bat colony before nightfall.',
    location: 'Cave',
    difficulty: QuestDifficulty.routine,
    goldReward: 70,
    xpReward: 35,
    recommendedLevel: 2,
    keyNPCs: ['Shepherd\'s Wife Maren'],
  ),
  const Quest(
    id: 'c_004',
    title: 'Smuggler\'s Tunnel',
    description:
        'Illegal goods are flowing through a hidden cave network. Dark cargo arrives by torchlight.',
    objective:
        'Infiltrate the smuggler\'s cave and intercept the next shipment.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 200,
    xpReward: 70,
    recommendedLevel: 6,
    keyNPCs: ['Harbormaster Lira'],
  ),
  const Quest(
    id: 'c_005',
    title: 'The Collapsed Shaft',
    description:
        'Miners broke through into something ancient. Strange sounds echo from the collapsed tunnel.',
    objective:
        'Explore the collapsed mine shaft in the cave and rescue any survivors.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 180,
    xpReward: 65,
    recommendedLevel: 7,
    keyNPCs: ['Foreman Brick'],
  ),
  const Quest(
    id: 'c_006',
    title: 'The Lurker Below',
    description:
        'Something massive lives in the cave lake. Ripples appear where nothing should stir.',
    objective:
        'Lure out and slay the creature dwelling in the cave\'s underground lake.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 250,
    xpReward: 85,
    recommendedLevel: 9,
  ),

  // ── Cave: Levels 11–25 ──
  const Quest(
    id: 'c_007',
    title: 'The Iron Veins',
    description:
        'Miners opened a new tunnel and found it already occupied. Picks and screams echoed, then silence.',
    objective:
        'Clear the hostile creatures from the newly opened iron vein tunnels.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 350,
    xpReward: 100,
    recommendedLevel: 12,
    keyNPCs: ['Foreman Brick'],
  ),
  const Quest(
    id: 'c_008',
    title: 'The Mushroom Plague',
    description:
        'Glowing fungal growths are spreading rapidly through the cave system. Miners who breathe the spores go mad.',
    objective:
        'Reach the fungal heart deep in the cave and destroy it before the spores reach the surface.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 500,
    xpReward: 120,
    recommendedLevel: 15,
    keyNPCs: ['Herbalist Nessa'],
  ),
  const Quest(
    id: 'c_009',
    title: 'The Flesh Market',
    description:
        'People vanish from the villages above. A black market operates in the caves, dealing in living bodies.',
    objective:
        'Infiltrate the underground flesh market in the cave and free the prisoners.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 600,
    xpReward: 140,
    recommendedLevel: 20,
    keyNPCs: ['Informant Whisper'],
  ),
  const Quest(
    id: 'c_010',
    title: 'The Underground Arena',
    description:
        'The cave fighting pits have a new champion — one that never bleeds. Fighters are terrified.',
    objective:
        'Challenge the undefeated pit champion in the cave arena and uncover its secret.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 650,
    xpReward: 150,
    recommendedLevel: 22,
    keyNPCs: ['Arena Master Kael', 'The Champion'],
  ),
  const Quest(
    id: 'c_011',
    title: 'The Crystal Tomb',
    description:
        'A massive crystal formation in the cave\'s depths emits a low hum. The dead buried within are stirring.',
    objective:
        'Shatter the resonating crystal in the cave tomb to stop the undead from waking.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 700,
    xpReward: 160,
    recommendedLevel: 25,
    keyNPCs: ['Grave Warden Thom'],
  ),

  // ── Cave: Levels 26–50 ──
  const Quest(
    id: 'c_012',
    title: 'The Deep Hive',
    description:
        'Insectoid creatures boil up from a cave rift. Their acidic secretions melt stone and steel.',
    objective:
        'Descend to the hive queen\'s chamber in the deepest cave and destroy the colony.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1000,
    xpReward: 190,
    recommendedLevel: 28,
    keyNPCs: ['Scholar Veyra'],
  ),
  const Quest(
    id: 'c_013',
    title: 'Prison of Echoes',
    description:
        'An ancient prison built into the cave rock has begun to crack. Something inside is screaming.',
    objective:
        'Navigate the cave prison and reseal the binding wards before the prisoner escapes.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2000,
    xpReward: 300,
    recommendedLevel: 40,
    keyNPCs: ['Warden\'s Ghost'],
  ),
  const Quest(
    id: 'c_014',
    title: 'The Lava Veins',
    description:
        'Magma is rising through the cave tunnels. Fire elementals emerge from the molten rock.',
    objective:
        'Reach the volcanic vent in the cave\'s lowest level and seal the breach.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2200,
    xpReward: 320,
    recommendedLevel: 45,
  ),
  const Quest(
    id: 'c_015',
    title: 'The Dragon\'s Lair',
    description:
        'A dragon sleeps on a hoard of gold deep in the cave. Its mere breathing heats the tunnels to scorching.',
    objective:
        'Enter the dragon\'s cave lair and slay or negotiate with the beast.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 1500,
    xpReward: 250,
    recommendedLevel: 35,
    keyNPCs: ['Dragon Irythas'],
  ),
  const Quest(
    id: 'c_016',
    title: 'War Beneath the Earth',
    description:
        'Dwarven and goblin armies clash in the mid-caves. The fighting has destabilized the tunnels above.',
    objective:
        'Broker peace or crush both factions to stop the cave from collapsing on the settlements above.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1200,
    xpReward: 200,
    recommendedLevel: 32,
    keyNPCs: ['Dwarf King Borin', 'Goblin Warlord Skrit'],
  ),

  // ── Cave: Levels 51–75 ──
  const Quest(
    id: 'c_017',
    title: 'The Bone Colossus',
    description:
        'An enormous construct of fused skeletons marches through the caverns toward the surface.',
    objective:
        'Find the Bone Colossus\'s phylactery hidden in the cave and shatter it.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4000,
    xpReward: 450,
    recommendedLevel: 60,
    keyNPCs: ['Necromancer\'s Shade'],
  ),
  const Quest(
    id: 'c_018',
    title: 'The Void Rift',
    description:
        'Reality is tearing apart in the cave\'s deepest chamber. Creatures from another plane pour through the crack.',
    objective:
        'Close the Void Rift in the cave before the breach becomes permanent.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 5000,
    xpReward: 500,
    recommendedLevel: 65,
    keyNPCs: ['Planar Scholar Yth'],
  ),
  const Quest(
    id: 'c_019',
    title: 'The Titan\'s Chains',
    description:
        'A titan sealed beneath the cave has nearly broken free. Its tremors collapse tunnels for miles.',
    objective:
        'Reforge the titan\'s chains in the deepest cave forge before it fully awakens.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4500,
    xpReward: 480,
    recommendedLevel: 70,
    keyNPCs: ['Forge Spirit'],
  ),
  const Quest(
    id: 'c_020',
    title: 'The Shapeshifter\'s Den',
    description:
        'The king\'s advisor was replaced by a shapeshifter. The real one is chained somewhere in the caves.',
    objective:
        'Navigate the shapeshifter\'s trapped cave den and rescue the true advisor.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 3000,
    xpReward: 380,
    recommendedLevel: 52,
    keyNPCs: ['King Aldren', 'Shapeshifter'],
  ),

  // ── Cave: Levels 76–100 ──
  const Quest(
    id: 'c_021',
    title: 'The Devourer\'s Prison',
    description:
        'The Devourer — a world-ending horror sealed millennia ago — stirs in its cave prison beneath the earth.',
    objective:
        'Gather the three Sealing Stones and reinforce the Devourer\'s cave prison.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 8000,
    xpReward: 600,
    recommendedLevel: 80,
    keyNPCs: ['Ancient Guardian'],
  ),
  const Quest(
    id: 'c_022',
    title: 'The Demon Gate',
    description:
        'A gate to the abyss has opened in the lowest cave. Demonic legions amass on the other side.',
    objective:
        'Descend to the bottom of the cave and seal the Demon Gate before the invasion begins.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 10000,
    xpReward: 700,
    recommendedLevel: 88,
    keyNPCs: ['Demon King Azrathar'],
  ),
  const Quest(
    id: 'c_023',
    title: 'The Serpent of the Deep',
    description:
        'A colossal serpent coils through the cave\'s lowest rivers. Its venom dissolves solid rock.',
    objective:
        'Track the serpent through the flooded cave tunnels and slay it in its lair.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 7000,
    xpReward: 550,
    recommendedLevel: 76,
    keyNPCs: ['Caravan Master Zafir'],
  ),
  const Quest(
    id: 'c_024',
    title: 'The Heart of the Mountain',
    description:
        'Something ancient beats at the mountain\'s core — a living heart of stone and fire. It is waking.',
    objective:
        'Reach the molten heart at the cave\'s absolute bottom and silence it forever.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 15000,
    xpReward: 1000,
    recommendedLevel: 100,
    keyNPCs: ['The Mountain\'s Voice'],
  ),

  // ══════════════════════════════════════
  //  RUINS  —  Levels 1–100
  // ══════════════════════════════════════

  // ── Ruins: Levels 1–10 ──
  const Quest(
    id: 'r_001',
    title: 'Haunted Barrow',
    description:
        'Lights flicker inside the old ruin at night. The dead do not rest easy in these crumbling halls.',
    objective:
        'Enter the ruins and find the source of the undead stirring within.',
    location: 'Ruins',
    difficulty: QuestDifficulty.routine,
    goldReward: 80,
    xpReward: 40,
    recommendedLevel: 1,
    keyNPCs: ['Grave Warden Thom'],
  ),
  const Quest(
    id: 'r_002',
    title: 'Rat Infestation',
    description:
        'Giant rats have overrun the old ruin cellars. They\'ve grown bold enough to attack anyone who enters.',
    objective: 'Clear the giant rat nests from the lower levels of the ruins.',
    location: 'Ruins',
    difficulty: QuestDifficulty.routine,
    goldReward: 60,
    xpReward: 30,
    recommendedLevel: 1,
    keyNPCs: ['Innkeeper Bram'],
  ),
  const Quest(
    id: 'r_003',
    title: 'The Cursed Idol',
    description:
        'A stone idol was unearthed in the ruins. Anyone who touches it hears whispers and loses sleep.',
    objective:
        'Find and destroy the cursed idol hidden in the ruins\' inner sanctum.',
    location: 'Ruins',
    difficulty: QuestDifficulty.routine,
    goldReward: 100,
    xpReward: 50,
    recommendedLevel: 3,
    keyNPCs: ['Village Elder Rowan'],
  ),
  const Quest(
    id: 'r_004',
    title: 'Tomb Robbers',
    description:
        'Grave robbers are looting the ruins. Worse, they\'re breaking ancient seals that should stay closed.',
    objective:
        'Stop the tomb robbers in the ruins before they unleash something sealed within.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 180,
    xpReward: 65,
    recommendedLevel: 5,
    keyNPCs: ['Historian Korval'],
  ),
  const Quest(
    id: 'r_005',
    title: 'The Restless Dead',
    description:
        'Skeletons patrol the ruin corridors at night. They wear armor from a war fought centuries ago.',
    objective:
        'Find the necromantic anchor in the ruins and destroy it to lay the dead to rest.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 220,
    xpReward: 80,
    recommendedLevel: 7,
    keyNPCs: ['Grave Warden Thom'],
  ),
  const Quest(
    id: 'r_006',
    title: 'The Forgotten Library',
    description:
        'A sealed library was found in the ruins. Something guards the books — and it does not share.',
    objective:
        'Enter the ruins\' sealed library and retrieve the lost texts within.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 250,
    xpReward: 85,
    recommendedLevel: 9,
    keyNPCs: ['Scholar Veyra'],
  ),

  // ── Ruins: Levels 11–25 ──
  const Quest(
    id: 'r_007',
    title: 'The Whispering Halls',
    description:
        'The ruins hum with a low, maddening drone. Those who linger too long begin speaking in dead languages.',
    objective:
        'Find and silence the resonance source deep within the ruin halls.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 350,
    xpReward: 100,
    recommendedLevel: 12,
    keyNPCs: ['Scholar Veyra'],
  ),
  const Quest(
    id: 'r_008',
    title: 'The Glass Prison',
    description:
        'An enchanted mirror in the ruins holds a mage prisoner. She screams when moonlight hits the surface.',
    objective:
        'Free the mage from the enchanted mirror in the ruins without releasing what guards her.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 550,
    xpReward: 130,
    recommendedLevel: 18,
    keyNPCs: ['Imprisoned Mage Lyris'],
  ),
  const Quest(
    id: 'r_009',
    title: 'The Collector\'s Vault',
    description:
        'A noble stored cursed artifacts in the ruins\' vault. People nearby sleepwalk toward the entrance.',
    objective:
        'Enter the ruins vault and destroy the cursed artifact collection.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 650,
    xpReward: 150,
    recommendedLevel: 22,
    keyNPCs: ['Lord Harren', 'Butler Simms'],
  ),
  const Quest(
    id: 'r_010',
    title: 'Plague Crypt',
    description:
        'An undead caravan emerged from beneath the ruins. The plague they carry turns flesh grey.',
    objective:
        'Descend into the ruins\' crypt and seal the source of the walking plague.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 700,
    xpReward: 160,
    recommendedLevel: 25,
    keyNPCs: ['Healer Senna'],
  ),
  const Quest(
    id: 'r_011',
    title: 'The Merchant\'s Shadow',
    description:
        'A shadowy assassin stalks a merchant who ventured into the ruins looking for treasure. Three guards are dead.',
    objective: 'Track the assassin through the ruins and protect the merchant.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 400,
    xpReward: 110,
    recommendedLevel: 14,
    keyNPCs: ['Merchant Talion', 'The Shadow'],
  ),

  // ── Ruins: Levels 26–50 ──
  const Quest(
    id: 'r_012',
    title: 'Rot and Ruin',
    description:
        'New graves appear in the ruin courtyard each morning. The ground expands on its own.',
    objective: 'Find the necromantic source beneath the ruins and destroy it.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1000,
    xpReward: 190,
    recommendedLevel: 28,
    keyNPCs: ['Gravedigger Erno'],
  ),
  const Quest(
    id: 'r_013',
    title: 'The Lich\'s Sanctum',
    description:
        'A former mage has turned to necromancy within the ruins. Her undead army grows each night.',
    objective:
        'Storm the lich\'s sanctum in the ruins and end her before she achieves full lichdom.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2000,
    xpReward: 300,
    recommendedLevel: 40,
    keyNPCs: ['Archmage Cassian', 'Apprentice Morvaine'],
  ),
  const Quest(
    id: 'r_014',
    title: 'The Sunken Sanctum',
    description:
        'A temple to a forgotten god lies half-submerged in the ruins\' flooded underbelly.',
    objective:
        'Dive into the flooded ruins and stop the ritual pulling ancient power to the surface.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1200,
    xpReward: 200,
    recommendedLevel: 32,
    keyNPCs: ['Priestess of the Depths'],
  ),
  const Quest(
    id: 'r_015',
    title: 'The Demon\'s Altar',
    description:
        'Cultists have consecrated an altar in the ruin\'s throne room. The air smells of brimstone and blood.',
    objective:
        'Destroy the demon altar and slay the cultists performing the summoning ritual.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2500,
    xpReward: 350,
    recommendedLevel: 48,
    keyNPCs: ['High Pyromancer Vex'],
  ),
  const Quest(
    id: 'r_016',
    title: 'The Siege Engine',
    description:
        'An ancient war machine lies dormant in the ruins. Orcs are trying to reactivate it.',
    objective:
        'Reach the siege engine chamber in the ruins and destroy it before orcs complete repairs.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 1800,
    xpReward: 280,
    recommendedLevel: 38,
    keyNPCs: ['Commander Hale'],
  ),

  // ── Ruins: Levels 51–75 ──
  const Quest(
    id: 'r_017',
    title: 'The God-Eater\'s Nest',
    description:
        'Ruin temples have gone silent. A creature feeding on divine essence has made its nest in the inner sanctum.',
    objective:
        'Hunt the God-Eater to its nest within the ruins and destroy it.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 3500,
    xpReward: 400,
    recommendedLevel: 55,
    keyNPCs: ['Last Cleric Soren'],
  ),
  const Quest(
    id: 'r_018',
    title: 'Eclipse Over the Ruins',
    description:
        'An eternal eclipse darkens the ruins. Shadow creatures swarm through every corridor.',
    objective:
        'Find the Sunstone Altar buried in the ruins and restore the light.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4200,
    xpReward: 460,
    recommendedLevel: 68,
    keyNPCs: ['Sun Priestess Amara'],
  ),
  const Quest(
    id: 'r_019',
    title: 'The Forgotten King',
    description:
        'An ancient king stirs in the deepest crypt. His rage echoes through every stone of the ruins.',
    objective:
        'Enter the royal crypt beneath the ruins and put the Forgotten King to rest.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4500,
    xpReward: 480,
    recommendedLevel: 72,
    keyNPCs: ['Historian Korval'],
  ),

  // ── Ruins: Levels 76–100 ──
  const Quest(
    id: 'r_020',
    title: 'Throne of Ashes',
    description:
        'The Demon King has resurrected within the ruin\'s throne room. Hellfire rains from the broken ceiling.',
    objective:
        'Storm the Demon King\'s throne in the ruins and slay him once and for all.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 10000,
    xpReward: 700,
    recommendedLevel: 90,
    keyNPCs: ['Demon King Azrathar'],
  ),
  const Quest(
    id: 'r_021',
    title: 'The Awakening Colossus',
    description:
        'A colossal stone guardian buried in the ruins has begun to move. Each step cracks the foundation.',
    objective:
        'Find and destroy the control rune animating the colossus beneath the ruins.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 8000,
    xpReward: 600,
    recommendedLevel: 82,
    keyNPCs: ['Ancient Guardian'],
  ),
  const Quest(
    id: 'r_022',
    title: 'The Void Breach',
    description:
        'Reality has torn open in the ruins\' great hall. Abominations from beyond pour through the wound.',
    objective:
        'Close the Void Breach in the ruins\' great hall before reality collapses entirely.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 12000,
    xpReward: 800,
    recommendedLevel: 95,
    keyNPCs: ['Planar Scholar Yth'],
  ),
  const Quest(
    id: 'r_023',
    title: 'The Last Dawn',
    description:
        'The God of Death has claimed the ruins as his seat. Every soul within a mile is being pulled toward the gate.',
    objective:
        'Ascend to the ruins\' highest spire and challenge Death at the Divine Gate.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 15000,
    xpReward: 1000,
    recommendedLevel: 100,
    keyNPCs: ['Death', 'Spirit of the First Hero'],
  ),
];
