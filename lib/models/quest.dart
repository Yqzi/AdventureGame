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
  final String aiObjective;
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
    required this.aiObjective,
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
    'aiObjective': aiObjective,
    'location': location,
    'description': description,
    'difficulty': difficulty.label,
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
    title: 'Goblin Camp',
    description:
        'A goblin scouting party has set up a camp along the forest trail. Woodcutters refuse to enter.',
    objective: 'Locate and destroy the goblin camp along the forest trail.',
    aiObjective:
        'There is exactly 1 goblin camp with 4 goblins and 1 goblin leader. The player must kill the goblin leader and burn the camp. Quest completes when the leader is dead and the camp is set ablaze.',
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
    objective:
        'Hunt or drive off the dire wolf pack terrorizing the forest road.',
    aiObjective:
        'There is 1 dire wolf alpha and 3 regular dire wolves. The player must kill the alpha. Quest completes when the alpha is dead — the remaining wolves scatter.',
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
    aiObjective:
        'Following the stream leads to a rotting troll carcass lodged in the water, leaking toxic bile. The player must pull or push the carcass out of the stream and burn it. Quest completes when the carcass is removed from the water.',
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
    aiObjective:
        'Henrik is alive but trapped in a bear\'s den with a broken leg. There is 1 large brown bear guarding the den. The player must drive off or kill the bear and bring Henrik out alive. Quest completes when Henrik is freed from the den.',
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
    aiObjective:
        'There are exactly 5 bandits including Bandit Chief Grath. The player must defeat Grath by killing or capturing him. Quest completes when Grath is dead or captured — the remaining bandits flee.',
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
    aiObjective:
        'The Black Vine has a pulsing root-heart in a clearing protected by 3 vine tendrils that attack. The player must get past the tendrils and burn the root-heart with fire (torch, spell, or oil). Quest completes when the root-heart is set on fire and destroyed.',
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
        'Discover what animates the scarecrows at the forest\'s edge and put a stop to it.',
    aiObjective:
        'There are 5 animated scarecrows and 1 cursed bone idol buried at the base of an oak tree. The scarecrows reanimate until the idol is found and smashed. The player must locate and destroy the idol. Quest completes when the idol is shattered.',
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
        'Seek out the forest witch and find a way to cure the village plague.',
    aiObjective:
        'Witch Morgatha has the cure but demands a human heart as payment. The player must negotiate, trick, or intimidate her into providing the cure without sacrificing anyone. Alternatively the player can find the Moonpetal flower in her garden and brew the cure themselves. Quest completes when the player obtains the cure by any means.',
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
    aiObjective:
        'The beast is a single massive dire bear mutated by dark magic. It has 1 lair deep in the thicket surrounded by claw-marked trees. The player must track it to the lair and kill it. Quest completes when the dire bear is dead.',
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
        'Burn the spider nests in the forest canopy and save any survivors.',
    aiObjective:
        'There is 1 spider queen and 8 giant spiders spread across 1 massive web-nest in the canopy. There are 3 cocooned travelers, 2 alive, 1 dead. The player must kill the spider queen and free the 2 living travelers. Quest completes when the queen is dead and survivors are freed.',
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
        'Cut through the overgrowth and destroy the monstrous plant creature at the forest\'s heart.',
    aiObjective:
        'The Verdant Terror is 1 massive carnivorous plant with vine tendrils guarding its central bulb-core. The core is its weak point. The player must cut through the tendrils and destroy the central bulb. Quest completes when the bulb-core is destroyed (cut, burned, or exploded).',
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
        'Venture into the ancient grove and end whatever has corrupted it.',
    aiObjective:
        'A single corrupted treant is rooted at the grove center. It has a glowing dark crystal embedded in its trunk — the source of corruption. The player must either destroy the crystal directly or kill the treant. Quest completes when the crystal is shattered or the treant falls.',
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
    objective:
        'Track the dragon to its forest lair and put an end to its reign.',
    aiObjective:
        'Dragon Irythas is a young red dragon with a lair in a charred clearing. The player must either slay the dragon in direct combat or collapse the lair entrance to trap it. Quest completes when Irythas is dead or permanently sealed in the collapsed lair.',
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
        'Infiltrate the fire cult\'s forest encampment and bring down their leader.',
    aiObjective:
        'The cult has 12 cultists and High Pyromancer Vex in a camp with 3 pyre-altars. Spy Maren is an inside contact who can help. The player must kill High Pyromancer Vex — the cult collapses without her. Quest completes when Vex is dead.',
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
        'Assault the orc war-camp in the forest and break their siege on the villages.',
    aiObjective:
        'The camp has ~20 orcs led by Warchief Gorak. Commander Hale provides militia support (8 soldiers). The player must kill Warchief Gorak — the warband scatters without their chief. Quest completes when Gorak is dead.',
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
        'Discover why the fey have turned hostile and restore peace to the forest.',
    aiObjective:
        'A Fey Stone in the central glade has been corrupted by a dark sigil carved into it. The player must reach the stone (guarded by 6 hostile sprites) and either cleanse the sigil with light magic or physically chisel it away. Quest completes when the sigil is removed from the Fey Stone.',
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
        'Descend through the World Tree\'s roots and reseal the slumbering wyrm.',
    aiObjective:
        'The Elder Wyrm is coiled beneath the World Tree roots. There are 3 broken seal-stones that must be reactivated by placing them back in their pedestals while the wyrm thrashes. The player must restore all 3 seal-stones to their pedestals. Quest completes when the third seal-stone is placed and the binding reactivates.',
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
    objective: 'Find the Sunstone and restore daylight to the darkened forest.',
    aiObjective:
        'The Sunstone sits in a shrine guarded by a Shadow Lord and 10 shadow creatures. The player must take the Sunstone and place it atop the shrine\'s altar pillar to reignite it. Quest completes when the Sunstone is placed on the pillar and daylight returns.',
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
        'Find and destroy the source of the undead growing from the forest floor.',
    aiObjective:
        'The Necromancer\'s phylactery is a black bone staff buried in a mound at the grove center, guarded by 15+ skeletons that keep regenerating. The player must dig up the bone staff and shatter it. Skeletons stop regenerating once it\'s destroyed. Quest completes when the phylactery staff is broken.',
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
        'Hunt the God-Eater through the sacred groves before it devours the last shrine.',
    aiObjective:
        'The God-Eater is 1 massive eldritch creature moving between 3 shrines. It has already consumed 2 of 3 shrines when the player arrives. The player must intercept it at the 3rd and final shrine and kill it before it feeds. Quest completes when the God-Eater is dead.',
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
    aiObjective:
        'The player must climb the burning World Tree (3 tiers: roots, trunk, crown). Each tier has demonic fire elementals. At the crown is a Hellfire Seed — the source of the fire. The player must destroy or remove the Hellfire Seed. Quest completes when the Hellfire Seed is destroyed.',
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
        'Reach the titan\'s broken chains and reforge them before the forest is flattened.',
    aiObjective:
        'The titan has 2 broken ankle-chains. The Forge Spirit can reforge them but needs the player to hold each chain in place while it welds. Each chain requires the player to survive the titan\'s movement while holding the chain. Quest completes when both chains are reforged and locked.',
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
    aiObjective:
        'Death has planted 1 black sapling in a clearing, guarded by Death himself and the Spirit of the First Hero (who may aid the player). The sapling has roots that fight back when pulled. The player must physically uproot the sapling while Death intervenes. Quest completes when the sapling is fully uprooted from the ground.',
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
        'Clear the creatures infesting the cellar cave beneath the old inn.',
    aiObjective:
        'There are exactly 4 giant rats and 1 rat nest in the cellar. The player must kill all 4 rats and destroy the nest. Quest completes when the last rat is dead and the nest is destroyed.',
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
    aiObjective:
        'A single large glowing fungal mass grows over the underground spring. It is guarded by 2 fungal crawlers. The player must destroy the fungal mass (by cutting, burning, or crushing). Quest completes when the fungal mass is destroyed and the water clears.',
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
        'Enter the cave and deal with the monstrous bat colony terrorizing the shepherds.',
    aiObjective:
        'There is 1 bat matriarch (large, aggressive) and ~12 smaller cave bats in the main chamber. Killing the matriarch scatters the colony. The player must kill the bat matriarch. Quest completes when the matriarch is dead.',
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
        'Infiltrate the smuggler\'s cave tunnel and intercept their operation.',
    aiObjective:
        'There are 6 smugglers and 1 smuggler boss in the cave. A shipment of contraband arrives by cart tonight. The player must intercept the shipment and kill or capture the boss. Quest completes when the boss is dead or captured.',
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
        'Explore the collapsed mine shaft and rescue any survivors trapped within.',
    aiObjective:
        'There are exactly 2 miners trapped behind rubble in the lower shaft. Something dangerous lurks in the darkness beyond the collapse — 3 cave crawlers. The player must clear or bypass the rubble, kill or evade the crawlers, and escort both miners to the surface. Quest completes when both miners reach the surface alive.',
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
    aiObjective:
        'The creature is 1 giant cave eel with armored scales. It hides in the lake and only surfaces to feed. The player must bait it with meat or blood and kill it when it surfaces. Quest completes when the cave eel is dead.',
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
        'Venture into the newly opened iron tunnels and clear whatever killed the miners.',
    aiObjective:
        'The tunnels contain 6 rock-burrowing beetles and 1 beetle queen in the deepest chamber. The queen keeps spawning more until killed. The player must kill the beetle queen. Quest completes when the queen is dead.',
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
        'Reach the source of the mushroom plague deep in the cave and destroy it.',
    aiObjective:
        'A massive fungal heart pulses in the deepest chamber, protected by toxic spore clouds and 4 fungal brutes. The player must reach the heart and destroy it (fire is most effective). Quest completes when the fungal heart is destroyed.',
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
        'Infiltrate the underground flesh market and free the prisoners.',
    aiObjective:
        'There are 8 slavers, 1 flesh market boss, and 6 prisoners in cages. The player must kill or incapacitate the boss and open the prisoner cages. Quest completes when the boss is dead and at least 4 of 6 prisoners are freed.',
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
        'Challenge the undefeated pit champion and uncover the secret of its victories.',
    aiObjective:
        'The Champion is actually a flesh golem controlled by Arena Master Kael through a hidden amulet. The player must either defeat the golem in the pit OR destroy Kael\'s control amulet to deactivate it. Quest completes when the Champion is destroyed or the control amulet is shattered.',
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
        'Silence the humming crystal in the cave\'s depths before the dead fully wake.',
    aiObjective:
        'A single massive resonating crystal hums in the center of the tomb, surrounded by 8 stirring undead. The undead grow stronger the longer the crystal hums. The player must shatter the crystal (requires a heavy strike or explosion). Quest completes when the resonating crystal is shattered.',
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
        'Descend to the deepest cave and destroy the insectoid hive within.',
    aiObjective:
        'The hive has ~20 worker insects and 1 massive hive queen in the lowest chamber. The queen\'s egg sac produces new workers constantly. The player must kill the queen and destroy the egg sac. Quest completes when the queen is dead and the egg sac is destroyed.',
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
        'Navigate the crumbling cave prison and reseal the binding before what\'s inside breaks free.',
    aiObjective:
        'There are 4 broken ward-stones scattered through the prison corridors. The prisoner is an ancient demon that grows more powerful each minute. The Warden\'s Ghost guides the player. The player must find and reactivate all 4 ward-stones by placing them back in their pedestals. Quest completes when the 4th ward-stone is placed and the binding reactivates.',
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
    aiObjective:
        'The volcanic vent is a fissure in the cave floor spewing lava and 3 fire elementals. The player must destroy the 3 fire elementals and then collapse the vent by destroying the support pillars (3 pillars) around it. Quest completes when the vent collapses shut.',
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
    objective: 'Enter the dragon\'s cave lair and face the beast on its hoard.',
    aiObjective:
        'Dragon Irythas sleeps on a gold hoard in the deepest chamber. The player can slay the dragon in direct combat or negotiate by offering a specific treasure (the Dragonheart Gem found in a side tunnel). Quest completes when Irythas is dead or when the player successfully strikes a deal and Irythas agrees to leave.',
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
        'End the underground war between dwarves and goblins before the tunnels collapse.',
    aiObjective:
        'Two armies clash: ~15 dwarves led by Dwarf King Borin and ~20 goblins led by Goblin Warlord Skrit. The tunnels are structurally failing. The player must either negotiate a ceasefire (convince BOTH leaders to stop) or kill one of the two leaders to break that army\'s morale. Quest completes when either both leaders agree to a truce OR one leader is dead and their army retreats.',
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
        'Find the Bone Colossus\'s power source hidden in the cave and destroy it.',
    aiObjective:
        'The Bone Colossus is an enormous skeleton construct marching toward the surface. Its phylactery is a glowing skull embedded in a hidden alcove 2 chambers behind it. The player must get past or through the Colossus, find the alcove, and shatter the phylactery skull. Quest completes when the phylactery is destroyed and the Colossus crumbles.',
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
        'Close the Void Rift in the deepest cave before the breach becomes permanent.',
    aiObjective:
        'A tear in reality in the deepest chamber spawns void creatures continuously. There are 3 anchor crystals around the rift that must be destroyed simultaneously (within seconds of each other) to collapse the rift. Planar Scholar Yth can help. The player must destroy all 3 anchor crystals. Quest completes when the third crystal shatters and the rift closes.',
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
        'Reforge the titan\'s chains in the deepest cave forge before it wakes.',
    aiObjective:
        'The titan has 2 broken chains. The Forge Spirit can reforge them but the player must hold each chain link on the anvil while the titan thrashes. Each chain requires surviving the titan\'s movement for the duration of forging. Quest completes when both chains are reforged and locked onto the titan.',
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
        'Navigate the shapeshifter\'s den of traps and illusions to rescue the true advisor.',
    aiObjective:
        'The shapeshifter has trapped the cave with 3 illusion rooms that try to confuse the player. The real advisor is chained in the final chamber. The shapeshifter will impersonate the advisor to trick the player. The player must identify the real advisor (the shapeshifter cannot replicate a specific scar on the advisor\'s hand) and free them. Quest completes when the real advisor is unchained and the shapeshifter is killed or exposed.',
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
        'Gather the Sealing Stones and reinforce the Devourer\'s prison before it breaks free.',
    aiObjective:
        'There are exactly 3 Sealing Stones, each in a different side-chamber of the prison (guarded by corrupted guardians). The player must collect all 3 and place them in the central binding circle while the Devourer\'s influence tries to stop them. Quest completes when all 3 Sealing Stones are placed in the binding circle and the seal reactivates.',
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
        'Descend to the bottom of the cave and seal the Demon Gate before the invasion.',
    aiObjective:
        'The Demon Gate is a massive portal at the cave\'s lowest point. Demon King Azrathar guards the gate from the other side. The gate has 2 binding pillars that must be reactivated by carving sealing runes into them (requiring the player to stand and carve while demons attack). Quest completes when both binding pillars are reactivated and the gate closes.',
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
        'Track the great serpent through the flooded tunnels and slay it in its lair.',
    aiObjective:
        'The colossal serpent is 1 giant cave serpent that hides in flooded tunnels and ambushes from the water. Its lair is a flooded grotto with one dry island. The player must lure or chase it to the grotto and kill it on the dry island where it can\'t submerge. Quest completes when the serpent is dead.',
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
        'Reach the molten heart at the mountain\'s core and silence it forever.',
    aiObjective:
        'The Heart is a living organ of stone and magma in the cave\'s deepest point, guarded by an ancient fire titan. The Mountain\'s Voice can guide the player to the heart\'s 1 weak point — a crack where cold iron can be driven in. The player must drive a cold iron spike (found in a side forge) into the crack. Quest completes when the spike is driven into the heart and it stops beating.',
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
        'Enter the barrow and lay the restless dead to their final rest.',
    aiObjective:
        'There are exactly 3 skeletons and 1 cracked gravestone that binds them. The skeletons reanimate until the gravestone is smashed. The player must destroy the cracked gravestone. Quest completes when the gravestone is shattered and the skeletons collapse permanently.',
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
    objective:
        'Descend into the ruin cellar and deal with the rat infestation.',
    aiObjective:
        'There is 1 brood mother rat (large, aggressive) and 6 giant rats protecting 1 nest. The player must kill the brood mother and destroy the nest. Quest completes when the brood mother is dead and the nest is destroyed.',
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
        'Find and destroy the cursed idol hidden somewhere in the ruins.',
    aiObjective:
        'The idol sits on an altar in the inner sanctum, guarded by 2 shadow wisps that attack anyone who approaches. The player must reach the altar and shatter the stone idol (requires a strong physical blow or holy magic). Quest completes when the idol is shattered.',
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
        'Stop the tomb robbers before they break the ancient seals within the ruins.',
    aiObjective:
        'There are exactly 3 tomb robbers working on breaking 1 final seal in the sealed chamber. The seal holds back an undead knight. The player must stop the robbers (kill, capture, or scare off all 3) before they break the seal. Quest completes when all 3 robbers are dealt with. If the seal breaks, the player must also kill the undead knight.',
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
        'Find the source of the undead patrols in the ruin corridors and put them to rest.',
    aiObjective:
        'There are 8 skeleton patrols and 1 necromantic anchor stone in the crypt center. The anchor stone is a glowing black obelisk. Skeletons keep reforming until the anchor is destroyed. The player must reach the center and shatter the anchor stone. Quest completes when the anchor stone is destroyed.',
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
        'Enter the sealed library in the ruins and retrieve what lies within.',
    aiObjective:
        'The library is sealed behind a warded door (requires solving a rune puzzle or brute force). Inside is 1 guardian spirit (spectral knight) protecting an ancient codex on a pedestal. The player must defeat the guardian and take the codex. Quest completes when the player holds the codex.',
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
        'Find what creates the maddening whispers in the ruin halls and silence it.',
    aiObjective:
        'A cracked resonance bell hangs in a hidden underground chapel. The bell emits psychic waves that drive people mad. The bell is guarded by 4 maddened thralls (former explorers). The player must reach the bell and destroy it or muffle it (wrapping in cloth or breaking the clapper). Quest completes when the bell is silenced.',
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
        'Free the imprisoned mage from the enchanted mirror deep in the ruins.',
    aiObjective:
        'Mage Lyris is trapped inside a large enchanted mirror in a shrine room. The mirror is guarded by 1 mirror demon that emerges if the player touches the mirror directly. The player must shatter the mirror frame (not the glass itself) by striking the ornate frame. Quest completes when the frame breaks and Lyris is freed.',
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
    aiObjective:
        'The vault contains exactly 5 cursed artifacts on pedestals, each emanating dark energy. Lord Harren\'s butler Simms guards the vault entrance. The player must destroy all 5 artifacts (smash, burn, or disenchant). Each artifact destroyed releases a burst of dark energy (damage). Quest completes when all 5 artifacts are destroyed.',
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
        'Descend into the crypt beneath the ruins and seal the source of the walking plague.',
    aiObjective:
        'A cracked sarcophagus in the deepest crypt chamber leaks plague miasma that reanimates corpses. There are 6 plague zombies wandering the crypt. The player must reach the sarcophagus and seal it (using the stone lid nearby or collapsing the chamber entrance). Quest completes when the sarcophagus is sealed shut.',
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
    objective:
        'Track the shadowy assassin through the ruins and protect the merchant.',
    aiObjective:
        'Merchant Talion is hiding in the ruins\' upper hall. The Shadow (an assassin) stalks through the corridors hunting him. The player must find the assassin before they reach Talion and kill or incapacitate The Shadow. Quest completes when The Shadow is dead or captured and Talion is alive.',
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
    objective:
        'Discover the source of the spreading rot beneath the ruins and destroy it.',
    aiObjective:
        'Beneath the ruin courtyard is a buried necromantic altar fed by 3 corpse-pits. The altar is guarded by 1 bone golem. The player must destroy the altar (requires breaking the runestone at its center). Quest completes when the altar\'s runestone is shattered.',
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
        'Storm the lich\'s sanctum in the ruins and end her before she completes the ritual.',
    aiObjective:
        'Apprentice Morvaine is performing a lichdom ritual in the sanctum\'s inner chamber, protected by 10 undead minions and magical wards. Archmage Cassian provides guidance from outside. The player must reach Morvaine and kill her before the ritual finishes (the ritual completes after ~3 exchanges in the sanctum). If the ritual completes, she becomes a full lich (dramatically harder). Quest completes when Morvaine is dead.',
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
    aiObjective:
        'A Priestess of the Depths is performing a summoning ritual at a submerged altar. The altar is underwater in a partially flooded temple. There are 4 drowned guardians in the water. The player must reach the altar (diving or draining the water) and disrupt the ritual by destroying the altar or killing the Priestess. Quest completes when the Priestess is dead or the altar is destroyed.',
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
        'Destroy the demon altar in the ruins\' throne room before the summoning is complete.',
    aiObjective:
        'There are 8 cultists and High Pyromancer Vex performing a demon summoning at a blood-soaked altar in the throne room. The summoning is nearly complete. The player must destroy the altar (topple it, shatter it, or douse the ritual flames with holy water found in an adjacent room). Quest completes when the altar is destroyed or Vex is killed (which breaks the ritual).',
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
        'Reach the siege engine chamber in the ruins before the orcs can reactivate it.',
    aiObjective:
        'An ancient stone siege engine sits in a large chamber with ~12 orc engineers working on it, commanded by an orc warboss. Commander Hale needs it destroyed. The player must sabotage the engine (destroy the firing mechanism or collapse the chamber ceiling using the cracked support pillars). Quest completes when the siege engine is permanently disabled.',
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
        'Hunt the God-Eater to its nest deep within the ruins and destroy the creature.',
    aiObjective:
        'The God-Eater is 1 large eldritch beast nesting in the inner sanctum, feeding on a divine artifact. Last Cleric Soren knows its weakness — the divine artifact it\'s feeding on can be used as a weapon against it if pulled free. The player must extract the artifact and use it to kill the God-Eater. Quest completes when the God-Eater is dead.',
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
    aiObjective:
        'The Sunstone Altar is buried beneath rubble in the ruins\' central courtyard, guarded by 1 Shadow Lord and 8 shadow creatures. Sun Priestess Amara can perform the restoration ritual but needs the player to protect her for 2 exchanges while she chants. The player must clear enemies and protect Amara during the ritual. Quest completes when Amara finishes the ritual and the eclipse breaks.',
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
    aiObjective:
        'The Forgotten King is a powerful undead warrior-king in the deepest crypt, surrounded by 6 royal guard skeletons. His crown is the source of his power. Historian Korval reveals that removing the crown breaks the enchantment. The player must fight through the guards and rip the crown from the King\'s head. Quest completes when the crown is removed from the Forgotten King.',
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
    aiObjective:
        'Demon King Azrathar sits on a burning throne in the ruins\' great hall, surrounded by 6 demon guards. He is vulnerable only when he steps off the throne (the throne shields him with hellfire). The player must bait him off the throne and strike. Quest completes when Azrathar is dead.',
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
        'Find the power source animating the colossus beneath the ruins and destroy it.',
    aiObjective:
        'The colossus is animated by 1 master control rune carved into its chest. The rune is shielded by stone armor that must be broken first (3 heavy hits to crack the chest plate). The Ancient Guardian can reveal the rune\'s location. Quest completes when the control rune is destroyed and the colossus goes still.',
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
    aiObjective:
        'A massive tear in reality fills the great hall. There are 3 void anchors (black obelisks) keeping the breach open, positioned around the hall. Void abominations pour through continuously. Planar Scholar Yth knows the anchors must be destroyed in sequence (left, center, right) within 30 seconds of each other. Quest completes when all 3 void anchors are destroyed and the breach collapses.',
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
    aiObjective:
        'Death stands at the Divine Gate atop the highest spire. The Spirit of the First Hero can weaken Death by sacrificing itself, giving the player 1 opening. The player must climb the spire (3 tiers of undead), then at the top either accept the First Hero\'s sacrifice to weaken Death and strike, or face Death at full power. Quest completes when Death is defeated or driven back through the Gate.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 15000,
    xpReward: 1000,
    recommendedLevel: 100,
    keyNPCs: ['Death', 'Spirit of the First Hero'],
  ),
];
