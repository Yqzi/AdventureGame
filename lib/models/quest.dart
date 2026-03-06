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
  final String failureCondition;
  final List<String> loreKeys;

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
    required this.failureCondition,
    this.keyNPCs = const [],
    this.loreKeys = const [],
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
    'failureCondition': failureCondition,
    if (loreKeys.isNotEmpty) 'loreKeys': loreKeys,
  };

  // ───────────────────────────────────────────────────────────
  //  QUEST PROGRESSION ORDER
  // ───────────────────────────────────────────────────────────
  //  Each set contains [Forest, Cave, Ruins].
  //  All 3 quests must be completed before the next set unlocks.
  //  Aligned by recommended level and narrative phase.
  // ───────────────────────────────────────────────────────────

  static const List<List<String>> progressionOrder = [
    // ── Phase 1: First Steps (Lv 1–5) ──
    [
      'f_001',
      'c_001',
      'r_001',
    ], // Goblin Camp · Cellar Dwellers · Haunted Barrow
    [
      'f_004',
      'c_002',
      'r_002',
    ], // Missing Woodcutter · Glowing Depths · Vermin in Undercroft
    [
      'f_003',
      'c_004',
      'r_003',
    ], // Poisoned Stream · Smuggler's Tunnel · Whispering Idol
    ['f_002', 'c_005', 'r_004'], // Dire Wolves · Collapsed Shaft · Tomb Robbers
    // ── Phase 2: Rising Action (Lv 5–10) ──
    ['f_005', 'c_006', 'r_005'], // Bandit Ambush · Lurker Below · Restless Dead
    ['f_006', 'c_007', 'r_006'], // Black Vine · First Trap · Sealed Library
    // ── Phase 3: The Mystery Deepens (Lv 11–20) ──
    [
      'f_007',
      'c_008',
      'r_007',
    ], // Fey Ambush · Mushroom Plague · Whispering Halls
    [
      'f_008',
      'c_009',
      'r_011',
    ], // Vaelithi Deserter · Flesh Market · Shadow Stalker
    [
      'f_009',
      'c_010',
      'r_008',
    ], // Beast of Thicket · Underground Arena · Grey Sentinels (first Tithebound)
    // ── Phase 4: Mid-Game (Lv 20–28) ──
    [
      'f_010',
      'c_011',
      'r_009',
    ], // Spider Nests · Bone Chime Corridor · Cursed Vault
    [
      'f_011',
      'c_012',
      'r_010',
    ], // Verdant Terror · First Contact (Ossborn) · Plague Crypt
    // ── Phase 5: Escalation (Lv 28–40) ──
    [
      'f_016',
      'c_016',
      'r_012',
    ], // Thornwall Breach · Ward-Stone Thieves · Looping Corridor
    [
      'f_012',
      'c_015',
      'r_014',
    ], // Crown of Thorns · Drake's Hoard · Sunken Sanctum
    [
      'f_014',
      'c_013',
      'r_016',
    ], // Dragon's Hunting Ground · Prison of Echoes · The Wrong Room
    // ── Phase 6: High Stakes (Lv 38–52) ──
    [
      'f_015',
      'c_014',
      'r_013',
    ], // Orc War-Camp · Lava Veins · Tithebound Awakening
    [
      'f_013',
      'c_017',
      'r_015',
    ], // Pyre Cult's Altar · Rite of Grafting · Cult of Valdris
    // ── Phase 7: Deep Lore (Lv 55–65) ──
    [
      'f_017',
      'c_020',
      'r_017',
    ], // Pale Root Incursion · Mad Ossborn · Tithebound War
    [
      'f_018',
      'c_018',
      'r_018',
    ], // Shadows in Canopy · Void Rift · The Sound Returns
    // ── Phase 8: Ancient Threats (Lv 68–78) ──
    [
      'f_019',
      'c_019',
      'r_019',
    ], // Blight Beneath Vaelith · Titan's Chains · Elder's Confession
    [
      'f_020',
      'c_023',
      'r_020',
    ], // God-Eater · Serpent of the Deep · Through the Choir
    // ── Phase 9: Endgame (Lv 80–92) ──
    [
      'f_021',
      'c_021',
      'r_021',
    ], // World Tree Burns · Devourer's Prison · Living Kingdom
    [
      'f_022',
      'c_022',
      'r_022',
    ], // Verdant Court's Judgment · Demon Gate · Throne Knows Your Name
    // ── Finale (Lv 100) ──
    [
      'f_023',
      'c_024',
      'r_023',
    ], // Death's Grove · Heart of the Mountain · Severance Undone
  ];

  /// Returns how many quest sets the player has fully completed.
  static int completedSetCount(Set<String> completedQuestIds) {
    int count = 0;
    for (final set in progressionOrder) {
      if (set.every((id) => completedQuestIds.contains(id))) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// Returns the current set of 3 quests (one per location) based on
  /// which quests the player has completed.
  ///
  /// Sets are defined by [progressionOrder]. All 3 quests in a set must
  /// be completed before the next set unlocks.
  static List<Quest> progressionQuests(Set<String> completedQuestIds) {
    final questLookup = {for (final q in allQuests) q.id: q};

    for (final set in progressionOrder) {
      final allDone = set.every((id) => completedQuestIds.contains(id));
      if (!allDone) {
        return set.map((id) => questLookup[id]!).toList();
      }
    }

    // All sets completed — return the last set.
    return progressionOrder.last.map((id) => questLookup[id]!).toList();
  }
}

// ═════════════════════════════════════════════════════════════
//  ALL GAME QUESTS  —  Three maps: Forest · Cave · Ruins
// ═════════════════════════════════════════════════════════════

final List<Quest> allQuests = [
  // ══════════════════════════════════════
  //  FOREST  —  Levels 1–100
  //  Lore: Thornveil Forest, World Tree, Vaelith (elven kingdom),
  //  Fey Courts, Circle of Thorn druids, Pale Root faction,
  //  goblin & bandit threats outside the Thornwall
  // ══════════════════════════════════════

  // ── Forest: Levels 1–10 ──
  const Quest(
    id: 'f_001',
    title: 'Goblin Camp on the Trade Road',
    description:
        'A goblin scouting party has set up a camp where the trade road enters the Thornveil. Woodcutters and merchants refuse to pass.',
    objective:
        'Locate and destroy the goblin camp blocking the forest trade road.',
    aiObjective:
        'There is exactly 1 goblin camp with 4 goblins and 1 goblin leader near the Thornveil trade road entrance. The player must kill the goblin leader and burn the camp. Quest completes when the leader is dead and the camp is set ablaze.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 80,
    xpReward: 40,
    recommendedLevel: 1,
    keyNPCs: ['Village Elder Rowan'],
    failureCondition: '',
  ),
  const Quest(
    id: 'f_002',
    title: 'Dire Wolves of the Thornveil',
    description:
        'A pack of dire wolves has claimed the main road through the outer Thornveil. Travelers are being dragged into the underbrush.',
    objective:
        'Hunt or drive off the dire wolf pack terrorizing the Thornveil road.',
    aiObjective:
        'There is 1 dire wolf alpha and 3 regular dire wolves in the outer Thornveil. The player must kill the alpha. Quest completes when the alpha is dead — the remaining wolves scatter.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 100,
    xpReward: 50,
    recommendedLevel: 3,
    keyNPCs: ['Militia Captain Dara'],
    failureCondition: '',
  ),
  const Quest(
    id: 'f_003',
    title: 'The Poisoned Stream',
    description:
        'A foul green sludge seeps from somewhere upstream in the Thornveil. Animals that drink from the brook collapse dead. Herbalist Nessa fears it may reach the village water supply.',
    objective:
        'Follow the stream through the Thornveil and destroy whatever is poisoning it.',
    aiObjective:
        'Following the stream leads to a rotting troll carcass lodged in the water, leaking toxic bile. The player must pull or push the carcass out of the stream and burn it. Quest completes when the carcass is removed from the water.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 90,
    xpReward: 45,
    recommendedLevel: 2,
    keyNPCs: ['Herbalist Nessa'],
    failureCondition:
        'The carcass breaks apart and washes downstream, spreading the poison to the village water supply.',
  ),
  const Quest(
    id: 'f_004',
    title: 'The Missing Woodcutter',
    description:
        'Old Henrik went to fell timber at the Thornveil\'s edge three days ago. His axe was found embedded in a tree, covered in claw marks.',
    objective:
        'Track the missing woodcutter deeper into the outer Thornveil and learn his fate.',
    aiObjective:
        'Henrik is alive but trapped in a bear\'s den with a broken leg. There is 1 large brown bear guarding the den. The player must drive off or kill the bear and bring Henrik out alive. Quest completes when Henrik is freed from the den.',
    location: 'Forest',
    difficulty: QuestDifficulty.routine,
    goldReward: 70,
    xpReward: 35,
    recommendedLevel: 1,
    keyNPCs: ['Henrik\'s Wife Maren'],
    failureCondition:
        'Henrik succumbs to his injuries in the den before the player can reach him.',
  ),
  const Quest(
    id: 'f_005',
    title: 'Bandit Ambush',
    description:
        'Bandits have been robbing merchants on the forest road outside the Thornwall. They vanish into the canopy before the militia arrives.',
    objective: 'Set a trap for the forest bandits and take down their leader.',
    aiObjective:
        'There are exactly 5 bandits including Bandit Chief Grath. The player must defeat Grath by killing or capturing him. Quest completes when Grath is dead or captured — the remaining bandits flee.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 200,
    xpReward: 70,
    recommendedLevel: 5,
    keyNPCs: ['Merchant Aldric', 'Bandit Chief Grath'],
    failureCondition:
        'Grath spots the ambush and his bandits overwhelm the player, escaping with their stolen goods.',
  ),
  const Quest(
    id: 'f_006',
    title: 'Curse of the Black Vine',
    description:
        'A thorned blight is creeping across the forest floor near the Thornwall border. It moves on its own at night, strangling trees. The Circle of Thorn druids say they\'ve never seen anything like it.',
    objective:
        'Find the heart of the Black Vine deep in the Thornveil and burn it out.',
    aiObjective:
        'The Black Vine has a pulsing root-heart in a clearing protected by 3 vine tendrils that attack. The player must get past the tendrils and burn the root-heart with fire (torch, spell, or oil). Quest completes when the root-heart is set on fire and destroyed.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 250,
    xpReward: 85,
    recommendedLevel: 8,
    keyNPCs: ['Druid Theron'],
    loreKeys: ['hollows'],
    failureCondition:
        'The Black Vine\'s tendrils drag the player away, and the root-heart burrows deeper underground beyond reach.',
  ),

  // ── Forest: Levels 11–25 ──
  const Quest(
    id: 'f_007',
    title: 'The Fey Ambush',
    description:
        'Sprites at the Thornveil\'s edge have turned hostile without warning. Travelers report being enchanted and robbed — or worse, led off the path and never seen again. The old fey pacts may be fraying.',
    objective:
        'Discover why the fey have turned hostile and find a way to stop the attacks.',
    aiObjective:
        'There are 6 hostile sprites guarding a corrupted Fey Stone in a hidden glade. A dark sigil has been carved into the stone, breaking the old pact. The player must locate and destroy the sigil (cleanse with light magic or physically chisel it away). Quest completes when the sigil is removed from the Fey Stone.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 300,
    xpReward: 95,
    recommendedLevel: 11,
    keyNPCs: ['Druid Theron'],
    failureCondition:
        'The dark sigil fully activates and the Fey Stone shatters, turning the fey permanently feral.',
  ),
  const Quest(
    id: 'f_008',
    title: 'The Vaelithi Deserter',
    description:
        'An elf was found unconscious at the Thornwall border, covered in wounds that look self-inflicted — as though she clawed through the barrier from the inside. She mutters about a "pale root" and begs not to be sent back.',
    objective:
        'Protect the elvish deserter from whoever is hunting her and learn what she knows.',
    aiObjective:
        'The elf is a Vaelithi border-crosser named Ilwen who fled the Pale Root faction. 3 Pale Root assassins (elves, armed, fast) are tracking her. They will arrive within the hour. The player must defend Ilwen and kill or drive off all 3 assassins. Quest completes when all 3 assassins are dead or fled and Ilwen is alive. Ilwen reveals that the Pale Root is growing more violent inside Vaelith but cannot say more — she has been away too long and her knowledge is fragmented.',
    location: 'Forest',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 350,
    xpReward: 100,
    recommendedLevel: 13,
    keyNPCs: ['Ilwen', 'Pale Root Assassins'],
    failureCondition:
        'The Pale Root assassins reach Ilwen and drag her back through the Thornwall. She is not seen again.',
  ),
  const Quest(
    id: 'f_009',
    title: 'The Beast of the Thicket',
    description:
        'Livestock at the Thornveil\'s edge is being torn apart by something massive. Claw marks are as wide as a man\'s arm. Farmer Gregor says the druids won\'t help — they claim the beast is "the forest\'s answer."',
    objective:
        'Track and slay the beast lurking in the deepest thicket of the outer Thornveil.',
    aiObjective:
        'The beast is a single massive dire bear mutated by residual corruption from the Hollow. It has 1 lair deep in the thicket surrounded by claw-marked trees. The player must track it to the lair and kill it. Quest completes when the dire bear is dead.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 500,
    xpReward: 120,
    recommendedLevel: 16,
    keyNPCs: ['Farmer Gregor'],
    loreKeys: ['hollows'],
    failureCondition:
        'The dire bear retreats to a new lair deeper in the thicket where it cannot be tracked.',
  ),
  const Quest(
    id: 'f_010',
    title: 'Spider Nests in the Canopy',
    description:
        'Giant webs span the canopy for miles along the trade road. Cocooned travelers dangle from the branches, some still alive. Ranger Elara says the spiders appeared after the fey pacts weakened.',
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
    failureCondition:
        'The cocooned survivors die from spider venom before they can be freed.',
  ),
  const Quest(
    id: 'f_011',
    title: 'The Verdant Terror',
    description:
        'A monstrous plant creature has taken root near the Thornwall border. Druid Theron believes it grew from Hollow-corrupted soil — the same blight the Vaelithi refuse to acknowledge.',
    objective:
        'Cut through the overgrowth and destroy the monstrous plant creature threatening the Thornwall border.',
    aiObjective:
        'The Verdant Terror is 1 massive carnivorous plant with vine tendrils guarding its central bulb-core. The core is its weak point. The player must cut through the tendrils and destroy the central bulb. Quest completes when the bulb-core is destroyed (cut, burned, or exploded).',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 600,
    xpReward: 140,
    recommendedLevel: 22,
    keyNPCs: ['Druid Theron'],
    loreKeys: ['hollows'],
    failureCondition:
        'The Verdant Terror\'s roots spread too deep and the bulb-core becomes unreachable underground.',
  ),

  // ── Forest: Levels 26–50 ──
  const Quest(
    id: 'f_012',
    title: 'Crown of Thorns',
    description:
        'A corrupted treant has claimed the deepest grove outside the Thornwall. The Circle of Thorn druids say a dark crystal was driven into its trunk — the same kind of corruption that has been spreading from the Hollows.',
    objective:
        'Venture into the ancient grove and destroy the corruption inside the treant.',
    aiObjective:
        'A single corrupted treant is rooted at the grove center. It has a glowing dark crystal embedded in its trunk — the source of corruption. The player must either destroy the crystal directly or kill the treant. Quest completes when the crystal is shattered or the treant falls.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1000,
    xpReward: 190,
    recommendedLevel: 30,
    keyNPCs: ['Ranger Elara'],
    loreKeys: ['hollows'],
    failureCondition:
        'The dark crystal pulses and the treant\'s corruption spreads to the surrounding forest, sealing the grove forever.',
  ),
  const Quest(
    id: 'f_013',
    title: 'The Pyre Cult\'s Altar',
    description:
        'A fanatical fire cult has been building pyre-altars between the trees of the outer Thornveil. Spy Maren says they worship something in the Hollows below and plan to burn a path through the Thornwall to reach Vaelith.',
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
    loreKeys: ['hollows', 'deepMother'],
    failureCondition:
        'Vex completes the ritual and the pyre-altars ignite simultaneously, burning a scar through the outer Thornveil.',
  ),
  const Quest(
    id: 'f_014',
    title: 'The Dragon\'s Hunting Ground',
    description:
        'A young dragon has claimed the mortal forest as its hunting territory. Charred clearings mark its kills. The Vaelithi have closed the Thornwall tighter — they do not intend to help.',
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
    failureCondition:
        'Irythas takes flight and razes the surrounding woodland, making its hunting ground ten times larger.',
  ),
  const Quest(
    id: 'f_015',
    title: 'Orc War-Camp',
    description:
        'An orc warband has built a fortified camp in the mortal forest. They raid surrounding villages nightly. Commander Hale has militia support but not enough to assault the camp alone.',
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
    failureCondition:
        'Gorak rallies his orcs for a counterattack, overrunning Commander Hale\'s position and scattering the militia.',
  ),
  const Quest(
    id: 'f_016',
    title: 'The Thornwall Breach',
    description:
        'Something has torn a hole in the Thornwall — the living barrier that seals Vaelith from the mortal world. Fey creatures and worse are pouring through the gap. The elves have not responded. The druids are overwhelmed.',
    objective:
        'Reach the Thornwall breach and seal it before the gap widens further.',
    aiObjective:
        'The breach is a ragged tear in the Thornwall, 30 feet wide, leaking fey energy and hostile creatures (6 feral sprites, 2 vine-beasts). A Circle of Thorn druid named Theron can perform a sealing ritual but needs the player to hold off the creatures for 3 exchanges while he works. Quest completes when Theron finishes the ritual and the breach closes.',
    location: 'Forest',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1200,
    xpReward: 200,
    recommendedLevel: 28,
    keyNPCs: ['Druid Theron'],
    failureCondition:
        'The breach widens beyond repair and the Thornwall begins unraveling, exposing the Vaelithi border to the mortal world.',
  ),

  // ── Forest: Levels 51–75 ──
  const Quest(
    id: 'f_017',
    title: 'The Pale Root Incursion',
    description:
        'Pale Root agents — elves from Vaelith\'s rebel faction — have crossed the Thornwall and are sabotaging Circle of Thorn shrines. Druid Theron believes they want the barrier to fall so Vaelith can expand by force.',
    objective:
        'Track and stop the Pale Root agents before they destroy the last druidic shrine.',
    aiObjective:
        'There are 4 Pale Root elves (armed, magically trained) systematically destroying druidic shrines. 2 shrines are already destroyed. The player must intercept them at the 3rd and final shrine and kill or capture all 4 before they complete the sabotage. Quest completes when all 4 agents are dealt with and the shrine survives.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 3500,
    xpReward: 400,
    recommendedLevel: 55,
    keyNPCs: ['Druid Theron', 'Pale Root Commander'],
    failureCondition:
        'The last shrine falls and the Thornwall destabilizes, creating uncontrolled breaches across the border.',
  ),
  const Quest(
    id: 'f_018',
    title: 'Shadows in the Canopy',
    description:
        'An eternal twilight has fallen over a vast section of the Thornveil. Shadow creatures roam the darkened canopy. Sun Priestess Amara says the Sunstone — an ancient relic that anchors daylight to the forest — has been stolen.',
    objective: 'Find the Sunstone and restore daylight to the darkened forest.',
    aiObjective:
        'The Sunstone sits in a corrupted shrine guarded by a Shadow Lord and 10 shadow creatures. The player must take the Sunstone and place it atop the shrine\'s altar pillar to reignite it. Quest completes when the Sunstone is placed on the pillar and daylight returns.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4000,
    xpReward: 450,
    recommendedLevel: 62,
    keyNPCs: ['Sun Priestess Amara'],
    failureCondition:
        'The Shadow Lord claims the Sunstone, plunging the forest into permanent darkness.',
  ),
  const Quest(
    id: 'f_019',
    title: 'The Blight Beneath Vaelith',
    description:
        'A Vaelithi exile has crossed the Thornwall with desperate news: the blight in the root-hollows beneath Vaelith is spreading faster than the elves can contain it. The Verdant Court refuses to ask mortals for help — but this exile is asking anyway.',
    objective:
        'Cross through a gap in the Thornwall and descend into the root-hollows to find the source of the blight.',
    aiObjective:
        'The exile (Vaelithi herbalist named Caelen) guides the player through a hidden gap in the Thornwall to the root-hollows beneath Vaelith. The blight is a Hollow-corruption: black fungal growths consuming the World Tree\'s roots. At the source is a cracked seal-stone leaking void-stuff. The player must destroy the corrupted roots around the seal-stone and then reseal it by placing the stone back in its pedestal. Quest completes when the seal-stone is restored. The elves will not thank the player for this.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4500,
    xpReward: 480,
    recommendedLevel: 70,
    keyNPCs: ['Caelen', 'Keeper of the World Tree'],
    loreKeys: ['hollows', 'deepMother'],
    failureCondition:
        'The blight consumes the seal-stone entirely and burrows deeper into the World Tree\'s roots.',
  ),

  // ── Forest: Levels 76–100 ──
  const Quest(
    id: 'f_020',
    title: 'The God-Eater',
    description:
        'Shrines throughout the Thornveil have gone silent. A creature feeding on divine essence stalks between the trees — the druids call it a God-Eater, something that shouldn\'t exist outside the Hollow.',
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
    loreKeys: ['hollows'],
    failureCondition:
        'The God-Eater consumes the last shrine and becomes too powerful to stop, leaving the forest godless.',
  ),
  const Quest(
    id: 'f_021',
    title: 'The World Tree Burns',
    description:
        'Demonic fire engulfs the World Tree. The Vaelithi have opened the Thornwall for the first time in three centuries — not to help, but to evacuate. If the World Tree falls, the forest and everything beneath it dies.',
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
    loreKeys: ['hollows'],
    failureCondition:
        'The Hellfire Seed fully ignites and the World Tree collapses, destroying the heart of the Thornveil and severing the root network that sustains the forest.',
  ),
  const Quest(
    id: 'f_022',
    title: 'The Verdant Court\'s Judgment',
    description:
        'Queen Seylith the Undying has summoned the player to Vaelith — the first mortal invited through the Thornwall in three centuries. She does not explain why. The Pale Root faction sees this as an opportunity.',
    objective:
        'Enter Vaelith, survive the Verdant Court\'s trial, and learn what the elves have been hiding.',
    aiObjective:
        'The player enters Vaelith through the Thornwall (escorted by Vaelithi guards). Queen Seylith demands the player undertake the Bloom Rite — the same trial elvish monarchs face — to prove mortals are worthy of the alliance she secretly wants but cannot publicly propose. The Bloom Rite requires descending into the World Tree\'s root-hollows and returning with a Bloom Shard. 3 Pale Root assassins will attempt to kill the player during the trial. Quest completes when the player returns with the Bloom Shard and presents it to the Court.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 12000,
    xpReward: 800,
    recommendedLevel: 95,
    keyNPCs: ['Queen Seylith', 'Pale Root Assassins'],
    failureCondition:
        'The Pale Root assassins kill the player during the Bloom Rite, and Seylith uses the failure to justify sealing the Thornwall permanently.',
  ),
  const Quest(
    id: 'f_023',
    title: 'Death\'s Grove',
    description:
        'Death — the eldest god — has planted a black sapling in the heart of the Thornveil. All who pass it wither to bone. The World Tree shudders. The Vaelithi have gone silent. The druids say this is the end of the forest.',
    objective:
        'Uproot Death\'s sapling from the forest clearing and survive what guards it.',
    aiObjective:
        'Death has planted 1 black sapling in a clearing at the World Tree\'s base, guarded by Death himself and the Spirit of the First Hero (who may aid the player). The sapling has roots that fight back when pulled. The player must physically uproot the sapling while Death intervenes. Quest completes when the sapling is fully uprooted from the ground.',
    location: 'Forest',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 15000,
    xpReward: 1000,
    recommendedLevel: 100,
    keyNPCs: ['Death', 'Spirit of the First Hero'],
    failureCondition:
        'Death\'s sapling takes root permanently, and a zone of death spreads outward from the clearing, consuming the World Tree from below.',
  ),

  // ══════════════════════════════════════
  //  CAVE (The Hollows)  —  Levels 1–100
  //  Lore: Ossborn, Deep Mother, Forge Spirit,
  //  warden-craft traps, Heart of the Mountain,
  //  ancient prisons, the Devourer
  // ══════════════════════════════════════

  // ── Cave: Levels 1–10 ──
  const Quest(
    id: 'c_001',
    title: 'Cellar Dwellers',
    description:
        'Scratching echoes from the cave beneath the old inn. Something has moved up from the Hollows into the upper tunnels.',
    objective:
        'Clear the creatures infesting the cellar cave beneath the old inn.',
    aiObjective:
        'There are exactly 4 giant rats and 1 rat nest in the cellar passage connecting to the upper Hollows. The player must kill all 4 rats and destroy the nest. Quest completes when the last rat is dead and the nest is destroyed.',
    location: 'Cave',
    difficulty: QuestDifficulty.routine,
    goldReward: 60,
    xpReward: 30,
    recommendedLevel: 1,
    keyNPCs: ['Innkeeper Bram'],
    failureCondition:
        'The rats scatter into the inn\'s walls and foundation, making the infestation far worse.',
  ),
  const Quest(
    id: 'c_002',
    title: 'The Glowing Depths',
    description:
        'A faint green glow pulses from a Hollows entrance. The village well water has started tasting of rot — Herbalist Nessa says the Deep Mother\'s fungal growths are spreading upward.',
    objective:
        'Descend into the Hollows and purge whatever contaminates the underground water source.',
    aiObjective:
        'A single large bioluminescent fungal mass — a Deep Mother growth — clings to the underground spring. It is guarded by 2 fungal crawlers. The player must destroy the fungal mass (by cutting, burning, or crushing). Quest completes when the fungal mass is destroyed and the water clears.',
    location: 'Cave',
    difficulty: QuestDifficulty.routine,
    goldReward: 100,
    xpReward: 50,
    recommendedLevel: 4,
    keyNPCs: ['Herbalist Nessa'],
    failureCondition:
        'The fungal mass releases a massive spore cloud that contaminates the entire underground spring.',
  ),
  const Quest(
    id: 'c_003',
    title: 'Bat Swarm in the Hollows',
    description:
        'Enormous cave bats have been erupting from a Hollows entrance at dusk, terrorizing shepherds on the surface.',
    objective:
        'Enter the upper Hollows and deal with the monstrous bat colony.',
    aiObjective:
        'There is 1 bat matriarch (large, aggressive) and ~12 smaller cave bats in the main chamber. Killing the matriarch scatters the colony. The player must kill the bat matriarch. Quest completes when the matriarch is dead.',
    location: 'Cave',
    difficulty: QuestDifficulty.routine,
    goldReward: 70,
    xpReward: 35,
    recommendedLevel: 2,
    keyNPCs: ['Shepherd Kors'],
    failureCondition:
        'The bat matriarch drives the player out and the colony grows bolder, attacking the village at dusk.',
  ),
  const Quest(
    id: 'c_004',
    title: 'Smuggler\'s Tunnel',
    description:
        'Illegal goods are flowing through a hidden passage in the upper Hollows. Smugglers use the worked-stone tunnels that miners abandoned after hearing strange sounds deeper in.',
    objective:
        'Infiltrate the smuggler\'s Hollows tunnel and intercept their operation.',
    aiObjective:
        'There are 6 smugglers and 1 smuggler boss in the tunnel. A shipment of contraband arrives by cart tonight. The player must intercept the shipment and kill or capture the boss. Quest completes when the boss is dead or captured.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 200,
    xpReward: 70,
    recommendedLevel: 6,
    keyNPCs: ['Harbormaster Lira'],
    failureCondition:
        'The smuggler boss is tipped off and relocates the operation deeper into the Hollows where the patrols cannot follow.',
  ),
  const Quest(
    id: 'c_005',
    title: 'The Collapsed Shaft',
    description:
        'Miners broke through into something ancient — a passage carved by no human hand. Strange sounds echo from beyond the collapse, and the stone feels warm to the touch.',
    objective:
        'Explore the collapsed mine shaft and rescue the miners trapped in the older tunnels.',
    aiObjective:
        'There are exactly 2 miners trapped behind rubble in the lower shaft. Beyond the collapse lies an ancient passage predating the mines — 3 cave crawlers lurk in the darkness. The player must clear or bypass the rubble, kill or evade the crawlers, and escort both miners to the surface. Quest completes when both miners reach the surface alive.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 180,
    xpReward: 65,
    recommendedLevel: 7,
    keyNPCs: ['Foreman Brick'],
    failureCondition:
        'A second cave-in seals the miners permanently. Their faint calls go silent.',
  ),
  const Quest(
    id: 'c_006',
    title: 'The Lurker Below',
    description:
        'Something massive lives in the underground lake where the Hollows meet the water table. Ripples appear where nothing should stir.',
    objective:
        'Lure out and slay the creature dwelling in the Hollows\' underground lake.',
    aiObjective:
        'The creature is 1 giant cave eel with armored scales. It hides in the lake and only surfaces to feed. The player must bait it with meat or blood and kill it when it surfaces. Quest completes when the cave eel is dead.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 250,
    xpReward: 85,
    recommendedLevel: 9,
    keyNPCs: ['Foreman Brick'],
    failureCondition:
        'The cave eel drags the player underwater and retreats to deeper waters where it cannot be reached.',
  ),

  // ── Cave: Levels 11–25 ──
  const Quest(
    id: 'c_007',
    title: 'The First Trap',
    description:
        'Miners opened a new tunnel and three of them vanished. A survivor crawled back babbling about floor tiles that "screamed fire" — warden-craft traps from the deep Hollows, far above where they should be.',
    objective:
        'Navigate the trapped passage in the mid-Hollows and retrieve the missing miners.',
    aiObjective:
        'The passage contains warden-craft traps: 2 pressure-plate walls that seal behind intruders and 3 rune-etched floor tiles that release searing heat when stepped on incorrectly. 2 miners are dead (burned). 1 miner is alive, trapped behind a sealed pressure-plate wall. The player must navigate the traps and free the surviving miner. Quest completes when the surviving miner reaches the surface alive.',
    location: 'Cave',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 350,
    xpReward: 100,
    recommendedLevel: 12,
    keyNPCs: ['Foreman Brick'],
    failureCondition:
        'The player triggers a deadfall trap — collapsed rubble seals the passage permanently with the miner still inside.',
  ),
  const Quest(
    id: 'c_008',
    title: 'The Mushroom Plague',
    description:
        'Bioluminescent fungal growths — the Deep Mother\'s breath — are spreading rapidly through the mid-Hollows. Miners who inhale the spores go mad, clawing at the walls and speaking in voices that aren\'t theirs.',
    objective:
        'Reach the source of the mushroom plague deep in the Hollows and destroy it.',
    aiObjective:
        'A massive fungal heart pulses in a deep chamber, protected by toxic spore clouds and 4 fungal brutes. The player must reach the heart and destroy it (fire is most effective). Herbalist Nessa, if present, recognises the spore-blight as kin to the corruption poisoning the forest streams above — "the same sickness, different roots." Quest completes when the fungal heart is destroyed.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 500,
    xpReward: 120,
    recommendedLevel: 15,
    keyNPCs: ['Herbalist Nessa'],
    loreKeys: ['worldTree'],
    failureCondition:
        'The fungal heart detonates a spore burst, infecting the entire tunnel system and driving out all miners.',
  ),
  const Quest(
    id: 'c_009',
    title: 'The Flesh Market',
    description:
        'People vanish from the villages above. A black market operates in the lawless upper Hollows, dealing in living bodies. The smugglers have gone deeper than anyone should.',
    objective:
        'Infiltrate the underground flesh market in the Hollows and free the prisoners.',
    aiObjective:
        'There are 8 slavers, 1 flesh market boss, and 6 prisoners in cages in a worked-stone chamber. The player must kill or incapacitate the boss and open the prisoner cages. Quest completes when the boss is dead and at least 4 of 6 prisoners are freed.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 600,
    xpReward: 140,
    recommendedLevel: 20,
    keyNPCs: ['Informant Whisper'],
    failureCondition:
        'The flesh market boss executes the prisoners and relocates deeper into the Hollows before the player can intervene.',
  ),
  const Quest(
    id: 'c_010',
    title: 'The Underground Arena',
    description:
        'The Hollows fighting pits have a new champion — one that never bleeds. Its skin is pale and translucent, and it fights with a stillness that terrifies the crowd. Some say it crawled up from the deep.',
    objective:
        'Challenge the undefeated pit champion and uncover the secret of its victories.',
    aiObjective:
        'The Champion is actually a flesh golem assembled from pale cave-creatures, controlled by Arena Master Kael through a hidden amulet. The player must either defeat the golem in the pit OR destroy Kael\'s control amulet to deactivate it. Quest completes when the Champion is destroyed or the control amulet is shattered.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 650,
    xpReward: 150,
    recommendedLevel: 22,
    keyNPCs: ['Arena Master Kael', 'The Champion'],
    failureCondition:
        'Kael sends the Champion after the player, forcing a retreat as the golem guards the arena exit.',
  ),
  const Quest(
    id: 'c_011',
    title: 'The Bone Chime Corridor',
    description:
        'Explorers found a passage deeper in the Hollows strung with chimes made of bone. The first man who touched one is dead — the chime exploded into razor shards. This is warden-craft. Something is sealed beyond.',
    objective:
        'Navigate the bone-chime corridor in the deep Hollows without triggering the traps and discover what lies beyond.',
    aiObjective:
        'The corridor has 6 sets of bone chimes strung across it that shatter into razor shrapnel when disturbed. Beyond the corridor is a sealed chamber with a cracked ward-stone holding back 4 stirring undead wardens. The player must pass the chimes without triggering them (careful movement or finding a way to disarm them) and then destroy the cracked ward-stone to release and defeat the undead wardens before they break out on their own. Quest completes when the player reaches the sealed chamber and all 4 undead wardens are destroyed.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 700,
    xpReward: 160,
    recommendedLevel: 25,
    keyNPCs: ['Foreman Brick'],
    failureCondition:
        'A bone chime detonates and the razor-shards collapse the corridor ceiling, sealing the passage.',
  ),

  // ── Cave: Levels 26–50 ──
  const Quest(
    id: 'c_012',
    title: 'First Contact',
    description:
        'A mining team broke through into a chamber where the stone was carved with symbols no one recognizes. Three of the miners were found dead — killed silently, precisely, without struggle. Something is down here. Something that does not want to be found.',
    objective:
        'Descend into the newly breached chamber and discover what killed the miners.',
    aiObjective:
        'The chamber is an Ossborn outpost — a small group of 3 Ossborn monks (translucent skin, sealed eyes, tremorsense) who killed the miners because they cracked a ward-stone while excavating. The Ossborn are not hostile to the player UNLESS the player touches anything in the chamber. The player must either leave peacefully (quest guidance) or fight them (3 Ossborn are extremely fast and fight silently). Quest completes when the player learns the Ossborn exist and returns to the surface with this knowledge. If the player attacks, they must kill all 3 Ossborn.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1000,
    xpReward: 190,
    recommendedLevel: 28,
    keyNPCs: ['Ossborn Watcher'],
    failureCondition:
        'The Ossborn seal the breached passage behind the player, trapping them in the chamber with no way out.',
  ),
  const Quest(
    id: 'c_013',
    title: 'Prison of Echoes',
    description:
        'An ancient prison in the mid-Hollows has begun to crack. The ward-stones are failing — Foreman Brick says the stone screams at night. Whatever is sealed inside grows stronger by the hour.',
    objective:
        'Navigate the crumbling prison in the Hollows and reseal the binding before what\'s inside breaks free.',
    aiObjective:
        'There are 4 broken ward-stones scattered through the prison corridors. The prisoner is an ancient demon sealed during the Sundering. An Ossborn elder watches from the shadows but will not help unless the player proves they understand the wards. The elder may mutter that this is not the only wound the Sundering left — "there are other seals, in other places, failing the same way." The player must find and reactivate all 4 ward-stones by placing them back in their pedestals. Quest completes when the 4th ward-stone is placed and the binding reactivates.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2000,
    xpReward: 300,
    recommendedLevel: 40,
    keyNPCs: ['Ossborn Elder'],
    loreKeys: ['valdrisSeverance'],
    failureCondition:
        'The last ward-stone shatters and the ancient demon breaks free of the prison entirely.',
  ),
  const Quest(
    id: 'c_014',
    title: 'The Lava Veins',
    description:
        'Magma is rising through tunnels that should be cold stone. Fire elementals crawl from the molten rock — the Deep Mother\'s blood, boiling up from below. The Ossborn have retreated from this section entirely.',
    objective:
        'Reach the volcanic vent in the deep Hollows and seal the breach before the magma reaches the upper tunnels.',
    aiObjective:
        'The volcanic vent is a fissure in the cave floor spewing lava and 3 fire elementals. The player must destroy the 3 fire elementals and then collapse the vent by destroying the support pillars (3 pillars) around it. Quest completes when the vent collapses shut.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2200,
    xpReward: 320,
    recommendedLevel: 45,
    keyNPCs: ['Forge Spirit'],
    failureCondition:
        'The volcanic vent widens and lava floods the lower tunnels, cutting off access to the deep Hollows.',
  ),
  const Quest(
    id: 'c_015',
    title: 'The Drake\'s Hoard',
    description:
        'A cave drake has burrowed into the mid-Hollows and made its nest on a vein of raw ore. Its breath heats the tunnels to scorching. The Ossborn ignore it — it hasn\'t breached any seals. The miners cannot.',
    objective: 'Enter the cave drake\'s lair in the Hollows and deal with it.',
    aiObjective:
        'A cave drake (smaller than a true dragon, but armored and brutal) sleeps on an ore hoard in a large chamber. The player can slay the drake in direct combat or lure it out using a Dragonheart Gem embedded in a nearby wall (the gem\'s glow agitates the drake). Quest completes when the drake is dead or driven from the chamber permanently.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 1500,
    xpReward: 250,
    recommendedLevel: 35,
    keyNPCs: ['Foreman Brick'],
    failureCondition:
        'The drake wakes fully enraged and collapses the tunnel entrance, sealing itself and the ore vein away forever.',
  ),
  const Quest(
    id: 'c_016',
    title: 'The Ward-Stone Thieves',
    description:
        'Someone is stealing ward-stones from the deep Hollows and selling them as magical curiosities on the surface. The Ossborn have responded — four traders are dead, killed silently in their beds. The stealing hasn\'t stopped.',
    objective:
        'Find the ward-stone thieves in the Hollows before the Ossborn kill everyone involved.',
    aiObjective:
        'A ring of 5 smugglers led by a fence named Draven is prying ward-stones from the deep tunnels. 2 Ossborn are hunting the smugglers and will kill anyone near the stolen goods. The player must find Draven\'s cache, recover the 3 stolen ward-stones, and return them to the pedestals in the deep tunnels. The Ossborn will allow the player to pass if carrying the stones. Quest completes when all 3 ward-stones are returned to their pedestals.',
    location: 'Cave',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1200,
    xpReward: 200,
    recommendedLevel: 32,
    keyNPCs: ['Fence Draven', 'Ossborn Hunters'],
    failureCondition:
        'The Ossborn reach Draven first and seal the entire upper tunnel section, cutting off mine access for all surface dwellers.',
  ),

  // ── Cave: Levels 51–75 ──
  const Quest(
    id: 'c_017',
    title: 'The Rite of Grafting',
    description:
        'An Ossborn elder has broken from the others. She speaks — haltingly, in a voice layered with dead wardens\' echoes — and asks for help. The bones in her body are rejecting the graft. If she dies, the knowledge of three wardens dies with her.',
    objective:
        'Escort the failing Ossborn elder to the deep forge where the Forge Spirit can stabilize her grafts.',
    aiObjective:
        'Ossborn Elder Voss is deteriorating — her grafted bones are splintering. The Forge Spirit\'s anvil in the deep forge can re-fuse the grafts, but the path is 3 chambers long and passes through active warden-craft traps (1 pressure-plate seal, 1 rune-tile corridor, 1 deadfall passage). Voss can sense the traps but cannot move fast. The player must navigate the traps while protecting Voss. Quest completes when Voss reaches the Forge Spirit\'s anvil alive.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 3500,
    xpReward: 400,
    recommendedLevel: 52,
    keyNPCs: ['Ossborn Elder Voss', 'Forge Spirit'],
    failureCondition:
        'Voss collapses before reaching the forge, and the warden-knowledge in her bones is lost forever.',
  ),
  const Quest(
    id: 'c_018',
    title: 'The Void Rift',
    description:
        'Reality is tearing apart in the deepest known chamber of the Hollows. Void creatures pour through the crack — the same Hollow-corruption the global texts describe. Even the Ossborn are retreating.',
    objective:
        'Close the Void Rift in the deepest Hollows before the breach becomes permanent.',
    aiObjective:
        'A tear in reality spawns void creatures continuously. There are 3 anchor crystals around the rift that must be destroyed simultaneously (within seconds of each other) to collapse the rift. An Ossborn elder can time the strikes using tremorsense. The player must destroy all 3 anchor crystals in rapid succession. Quest completes when the third crystal shatters and the rift closes.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 5000,
    xpReward: 500,
    recommendedLevel: 65,
    keyNPCs: ['Ossborn Elder'],
    loreKeys: ['valdrisSeverance'],
    failureCondition:
        'The rift stabilizes permanently and void creatures establish a beachhead in the deep Hollows.',
  ),
  const Quest(
    id: 'c_019',
    title: 'The Titan\'s Chains',
    description:
        'A titan sealed during the Sundering has nearly broken free. Its tremors collapse tunnels for miles. The Ossborn carry the memory of how the chains were originally forged — but the knowledge is fragmentary, spread across three elders who no longer agree on the sequence.',
    objective:
        'Work with the Forge Spirit and the Ossborn to reforge the titan\'s chains before it wakes.',
    aiObjective:
        'The titan has 2 broken chains. The Forge Spirit can reforge them but needs the player to hold each chain link on the anvil while the titan thrashes. 2 Ossborn elders provide conflicting instructions on the rune sequence — one is correct, one is working from corrupted warden-memory. The player must choose which elder to trust. Quest completes when both chains are reforged and locked onto the titan using the correct rune sequence.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4500,
    xpReward: 480,
    recommendedLevel: 70,
    keyNPCs: ['Forge Spirit', 'Ossborn Elders'],
    failureCondition:
        'The wrong rune sequence is used and the chains shatter upon contact, fully awakening the titan.',
  ),
  const Quest(
    id: 'c_020',
    title: 'The Mad Ossborn',
    description:
        'An Ossborn elder has gone mad — the weight of a dozen dead wardens\' memories has crushed his own identity. He believes he IS the warden whose bones he carries, and he is systematically deactivating the seals that warden originally set, claiming they are "his to release."',
    objective:
        'Track the mad Ossborn through the deep Hollows and stop him before he opens the sealed prisons.',
    aiObjective:
        'The Mad Ossborn (Elder Keth) has already deactivated 2 of 4 seals in his circuit. He is heading for the 3rd. He is extremely fast, fights with inherited warden techniques, and genuinely believes he is freeing "his own" prisoners. The player must intercept and either kill him or restrain him before he reaches the 3rd seal. Quest completes when Keth is dead or restrained.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4000,
    xpReward: 450,
    recommendedLevel: 60,
    keyNPCs: ['Mad Ossborn Elder Keth'],
    failureCondition:
        'Keth reaches the 3rd seal and the prison cracks — something ancient stirs behind the opened ward.',
  ),

  // ── Cave: Levels 76–100 ──
  const Quest(
    id: 'c_021',
    title: 'The Devourer\'s Prison',
    description:
        'The Devourer — something that predates even the gods — stirs in its vault beneath the deepest Hollows. The Ossborn have gathered in numbers not seen in centuries. The Forge Spirit has gone silent. The ward-stones are failing.',
    objective:
        'Gather the Sealing Stones and reinforce the Devourer\'s prison before it breaks free.',
    aiObjective:
        'There are exactly 3 Sealing Stones, each in a different side-chamber of the prison (guarded by corrupted guardians who were once Ossborn). The player must collect all 3 and place them in the central binding circle while the Devourer\'s psychic influence tries to stop them (hallucinations, false paths, whispered promises). Quest completes when all 3 Sealing Stones are placed in the binding circle and the seal reactivates.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 8000,
    xpReward: 600,
    recommendedLevel: 80,
    keyNPCs: ['Ossborn Elders', 'Forge Spirit'],
    failureCondition:
        'The Devourer absorbs the Sealing Stones\' power and its prison begins to crack open.',
  ),
  const Quest(
    id: 'c_022',
    title: 'The Demon Gate',
    description:
        'A gate to the abyss has opened at the Hollows\' lowest point — a seal that has held since the Sundering, now cracked. Demonic legions amass on the other side. The Ossborn carrying the warden-memory for this seal are dead.',
    objective:
        'Descend to the bottom of the Hollows and seal the Demon Gate before the invasion begins.',
    aiObjective:
        'The Demon Gate is a massive portal at the Hollows\' lowest point. A demon lord guards the gate from the other side. The gate has 2 binding pillars that must be reactivated by carving sealing runes into them (the rune sequence is carved into the bones of a dead Ossborn nearby — the player must find and read them). Quest completes when both binding pillars are reactivated and the gate closes.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 10000,
    xpReward: 700,
    recommendedLevel: 88,
    keyNPCs: ['Forge Spirit'],
    loreKeys: ['valdrisSeverance'],
    failureCondition:
        'The demon lord completes the gate\'s expansion and the demonic vanguard pours into the Hollows.',
  ),
  const Quest(
    id: 'c_023',
    title: 'The Serpent of the Deep',
    description:
        'A colossal serpent coils through the Hollows\' deepest flooded tunnels. Its venom dissolves ward-stone — the Ossborn have lost three sealed passages to its acidic wake. If it reaches the binding circle, the Devourer\'s prison fails.',
    objective:
        'Track the great serpent through the flooded tunnels and slay it before it destroys the bindings.',
    aiObjective:
        'The colossal serpent is 1 giant cave serpent that hides in flooded tunnels and ambushes from the water. Its lair is a flooded grotto with one dry island near a critical ward-stone. The player must lure or chase it to the grotto and kill it on the dry island where it can\'t submerge. Quest completes when the serpent is dead.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 7000,
    xpReward: 550,
    recommendedLevel: 76,
    keyNPCs: ['Ossborn Elder Voss'],
    failureCondition:
        'The serpent dissolves the last ward-stone protecting the Devourer\'s binding circle, weakening the seal irreversibly.',
  ),
  const Quest(
    id: 'c_024',
    title: 'The Heart of the Mountain',
    description:
        'Something ancient beats at the mountain\'s core — the Heart of the Mountain, a living organ of stone and magma that may be the Deep Mother\'s own heart, still beating after the Sundering. It is waking. The Ossborn kneel before it. The Forge Spirit says it must be silenced. The Ossborn say it must not.',
    objective:
        'Reach the Heart of the Mountain at the deepest point of the Hollows and decide its fate.',
    aiObjective:
        'The Heart is a living organ of stone and magma in the Hollows\' deepest point, guarded by an ancient fire titan and 6 Ossborn who revere it. The Forge Spirit insists the Heart must be silenced (a cold iron spike from its forge into the Heart\'s crack). The Ossborn elders believe the Heart sustains all the bindings — silencing it may free everything sealed below. The player must choose: drive the spike in (silencing the Heart but risking the bindings) or find another way to calm it without killing it (the Forge Spirit will not help with this path). Quest completes when the Heart is either silenced or stabilized.',
    location: 'Cave',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 15000,
    xpReward: 1000,
    recommendedLevel: 100,
    keyNPCs: ['Forge Spirit', 'Ossborn Elders'],
    loreKeys: ['worldTree'],
    failureCondition:
        'The Heart fully awakens and the mountain begins to erupt from the inside out, collapsing every prison and seal in the Hollows.',
  ),

  // ══════════════════════════════════════
  //  RUINS (Valdris)  —  Levels 1–100
  //  Lore: Tithebound, Nameless Choir (60+),
  //  the Severance, folded Valdris dimension,
  //  Scholar Veyra, Historian Korval
  // ══════════════════════════════════════

  // ── Ruins: Levels 1–10 ──
  //    Mortal-side ruins — undead, grave robbers,
  //    cursed artifacts, wrong architecture.
  //    No Tithebound encounters yet — just hints.
  const Quest(
    id: 'r_001',
    title: 'Haunted Barrow',
    description:
        'Lights flicker inside the oldest barrow of the Valdris ruins at night. The dead do not rest easy in these crumbling halls — and Scholar Veyra says the walls hum if you press your ear to them.',
    objective:
        'Enter the barrow beneath the Valdris ruins and lay the restless dead to rest.',
    aiObjective:
        'There are exactly 3 skeletons and 1 cracked gravestone that binds them. The skeletons reanimate until the gravestone is smashed. The player must destroy the cracked gravestone. Quest completes when the gravestone is shattered and the skeletons collapse permanently.',
    location: 'Ruins',
    difficulty: QuestDifficulty.routine,
    goldReward: 80,
    xpReward: 40,
    recommendedLevel: 1,
    keyNPCs: ['Scholar Veyra'],
    failureCondition:
        'The gravestone repairs itself with dark energy, and more skeletons begin to rise from the barrow.',
  ),
  const Quest(
    id: 'r_002',
    title: 'Vermin in the Undercroft',
    description:
        'Giant rats have overrun the undercroft beneath the Valdris ruins. They\'ve grown bold enough to attack the researchers camped at the entrance.',
    objective:
        'Descend into the ruin undercroft and deal with the rat infestation.',
    aiObjective:
        'There is 1 brood mother rat (large, aggressive) and 6 giant rats protecting 1 nest built in a collapsed archway. The player must kill the brood mother and destroy the nest. Quest completes when the brood mother is dead and the nest is destroyed.',
    location: 'Ruins',
    difficulty: QuestDifficulty.routine,
    goldReward: 60,
    xpReward: 30,
    recommendedLevel: 1,
    keyNPCs: ['Historian Korval'],
    failureCondition:
        'The brood mother escapes into the ruin walls and the infestation spreads through the undercroft.',
  ),
  const Quest(
    id: 'r_003',
    title: 'The Whispering Idol',
    description:
        'A stone idol was unearthed in the Valdris ruins. Anyone who touches it hears whispers in a language they almost understand. Scholar Veyra says the idol predates Valdris itself — it shouldn\'t be here.',
    objective: 'Find and destroy the cursed idol hidden in the Valdris ruins.',
    aiObjective:
        'The idol sits on an altar in the inner sanctum, guarded by 2 shadow wisps that attack anyone who approaches. The player must reach the altar and shatter the stone idol (requires a strong physical blow or holy magic). Quest completes when the idol is shattered.',
    location: 'Ruins',
    difficulty: QuestDifficulty.routine,
    goldReward: 100,
    xpReward: 50,
    recommendedLevel: 3,
    keyNPCs: ['Scholar Veyra'],
    failureCondition:
        'The idol\'s whispers grow stronger and the shadow wisps begin spreading beyond the sanctum.',
  ),
  const Quest(
    id: 'r_004',
    title: 'Tomb Robbers',
    description:
        'Grave robbers are prying open sealed chambers in the Valdris ruins. Historian Korval is furious — every broken seal releases more of whatever lingers here.',
    objective:
        'Stop the tomb robbers before they break the wrong seal in the Valdris ruins.',
    aiObjective:
        'There are exactly 3 tomb robbers working on breaking 1 final seal in a sealed chamber. The seal holds back an undead knight in ancient Valdris armor. The player must stop the robbers (kill, capture, or scare off all 3) before they break the seal. Quest completes when all 3 robbers are dealt with. If the seal breaks, the player must also kill the undead knight.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 180,
    xpReward: 65,
    recommendedLevel: 5,
    keyNPCs: ['Historian Korval'],
    failureCondition:
        'The robbers break the final seal and an undead knight awakens, slaughtering everyone nearby.',
  ),
  const Quest(
    id: 'r_005',
    title: 'The Restless Dead',
    description:
        'Skeletons patrol the Valdris ruin corridors at night. They wear armor from the kingdom that once stood here — armor that should have rusted to nothing centuries ago.',
    objective:
        'Find the source of the undead patrols in the Valdris corridors and put them to rest.',
    aiObjective:
        'There are 8 skeleton patrols and 1 necromantic anchor stone in the crypt center. The anchor stone is a glowing black obelisk. Skeletons keep reforming until the anchor is destroyed. The player must reach the center and shatter the anchor stone. Quest completes when the anchor stone is destroyed.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 220,
    xpReward: 80,
    recommendedLevel: 7,
    keyNPCs: ['Historian Korval'],
    failureCondition:
        'The anchor stone fully charges and the skeleton patrols begin marching out of the ruins.',
  ),
  const Quest(
    id: 'r_006',
    title: 'The Sealed Library',
    description:
        'A sealed library was found in the Valdris ruins. Scholar Veyra says the door responds to touch — it\'s warm, and the metal vibrates as if something on the other side is breathing.',
    objective:
        'Enter the sealed library in the Valdris ruins and retrieve what lies within.',
    aiObjective:
        'The library is sealed behind a warded door (requires solving a rune puzzle or brute force). Inside is 1 guardian spirit (spectral knight in Valdris court armor) protecting an ancient codex on a pedestal. The codex is a fragmentary history of Valdris — it mentions "the night the sky folded" but gives no explanation. The player must defeat the guardian and take the codex. Quest completes when the player holds the codex.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 250,
    xpReward: 85,
    recommendedLevel: 9,
    keyNPCs: ['Scholar Veyra'],
    failureCondition:
        'The guardian spirit seals the library permanently, destroying the codex rather than letting it be taken.',
  ),

  // ── Ruins: Levels 11–25 ──
  //    Deeper ruins. First Tithebound sightings —
  //    broken, hollow figures. Wrong architecture
  //    becomes more pronounced.
  const Quest(
    id: 'r_007',
    title: 'The Whispering Halls',
    description:
        'The lower ruins hum with a low, maddening drone. Those who linger too long begin speaking in dead languages. Historian Korval attributes it to "residual enchantment." Scholar Veyra is less certain.',
    objective:
        'Find what creates the maddening hum in the lower Valdris halls and silence it.',
    aiObjective:
        'A cracked resonance bell hangs in a hidden underground chapel. The bell emits psychic waves that drive people mad. The bell is guarded by 4 maddened thralls (former explorers). The walls in this section of the ruins feel subtly wrong — rooms seem larger inside than outside. The player must reach the bell and destroy it or muffle it (wrapping in cloth or breaking the clapper). Quest completes when the bell is silenced.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 350,
    xpReward: 100,
    recommendedLevel: 12,
    keyNPCs: ['Scholar Veyra'],
    loreKeys: ['wardenCraft'],
    failureCondition:
        'The resonance bell cracks fully and releases a permanent psychic field over this section of the ruins.',
  ),
  const Quest(
    id: 'r_008',
    title: 'The Grey Sentinels',
    description:
        'Explorers report seeing tall, gaunt figures standing motionless in the lower corridors — ash-grey skin, angular bones, hollow eyes. They do not respond to speech. They attack without warning when approached too closely.',
    objective:
        'Investigate the mysterious grey figures in the deeper Valdris ruins.',
    aiObjective:
        'These are Tithebound — 3 of them patrol a section of the lower ruins in a repeating loop they cannot explain. They are hostile if the player enters their patrol path. They speak in broken fragments: "was not... a deal," "the sound... it takes." Scholar Veyra, if consulted, notes their compulsive guarding resembles descriptions of the Ossborn in the Hollows mining records — beings changed by proximity to something ancient. The player must either fight through them (they are resilient but slow) or find an alternate route around their patrol. Quest completes when the player passes through or clears the Tithebound patrol and reaches the chamber beyond, which contains a Valdris mural depicting a sky that appears to fold inward.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 550,
    xpReward: 130,
    recommendedLevel: 18,
    keyNPCs: ['Tithebound Sentinels'],
    loreKeys: ['ossborn'],
    failureCondition:
        'The Tithebound force the player back and seal the corridor with a mechanism they shouldn\'t know how to operate.',
  ),
  const Quest(
    id: 'r_009',
    title: 'The Cursed Vault',
    description:
        'A vault deeper in the Valdris ruins is leaking dark energy. People nearby sleepwalk toward the entrance. Historian Korval says the artifacts inside predate Valdris by centuries — which should be impossible.',
    objective:
        'Enter the Valdris vault and destroy the cursed artifact collection.',
    aiObjective:
        'The vault contains exactly 5 cursed artifacts on pedestals, each emanating dark energy. The architecture in this chamber is subtly wrong — the ceiling is too high, the corners don\'t meet at right angles. The player must destroy all 5 artifacts (smash, burn, or disenchant). Each artifact destroyed releases a burst of dark energy (damage). Quest completes when all 5 artifacts are destroyed.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 650,
    xpReward: 150,
    recommendedLevel: 22,
    keyNPCs: ['Historian Korval'],
    failureCondition:
        'The cursed artifacts resonate together and create a dark barrier, sealing the vault with the player inside.',
  ),
  const Quest(
    id: 'r_010',
    title: 'Plague Crypt',
    description:
        'An undead caravan emerged from beneath the Valdris ruins. The plague they carry turns flesh grey — the same grey as the silent sentinels deeper inside.',
    objective:
        'Descend into the crypt beneath the ruins and seal the source of the walking plague.',
    aiObjective:
        'A cracked sarcophagus in the deepest crypt chamber leaks miasma that reanimates corpses. There are 6 plague zombies wandering the crypt. The player must reach the sarcophagus and seal it (using the stone lid nearby or collapsing the chamber entrance). Quest completes when the sarcophagus is sealed shut.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 700,
    xpReward: 160,
    recommendedLevel: 25,
    keyNPCs: ['Healer Senna'],
    loreKeys: ['hollows'],
    failureCondition:
        'The plague miasma seeps to the surface, spreading the grey plague to the camp above.',
  ),
  const Quest(
    id: 'r_011',
    title: 'The Shadow Stalker',
    description:
        'A shadowy assassin stalks a merchant who ventured into the Valdris ruins looking for treasure. Three guards are dead — killed by something that moved through the walls as if they weren\'t there.',
    objective:
        'Track the shadowy assassin through the ruins and protect the merchant.',
    aiObjective:
        'Merchant Talion is hiding in the upper Valdris halls. The Shadow is an entity — not human — that phases through the wrong-angled walls. It hunts Talion. The player must find the Shadow before it reaches Talion and kill it (it becomes solid when attacking). Quest completes when the Shadow is destroyed and Talion is alive.',
    location: 'Ruins',
    difficulty: QuestDifficulty.dangerous,
    goldReward: 400,
    xpReward: 110,
    recommendedLevel: 14,
    keyNPCs: ['Merchant Talion'],
    failureCondition:
        'The Shadow reaches Talion first and drags him through the wall. He is not seen again.',
  ),

  // ── Ruins: Levels 26–50 ──
  //    Mid-depth ruins. Tithebound become regular
  //    encounters. Architecture grows more wrong.
  //    Scholar Veyra begins to doubt her own theories.
  const Quest(
    id: 'r_012',
    title: 'The Looping Corridor',
    description:
        'Scholar Veyra sent a team into the mid-depth ruins. They returned three days later — insisting only an hour had passed. They say every corridor led back to the same room. One of them drew a map. The map is impossible.',
    objective:
        'Navigate the looping corridors in the deep Valdris ruins and find out what\'s causing the spatial distortion.',
    aiObjective:
        'The corridors genuinely loop — the architecture bends in ways that shouldn\'t be possible. At the center of the loop is a resonance crystal embedded in the floor, humming faintly. Destroying it breaks the loop. 2 Tithebound guard the crystal, patrolling endlessly. The player must navigate the loop (following wall-markings that a previous explorer left), reach the crystal, deal with the Tithebound, and shatter it. Quest completes when the crystal is destroyed and the corridors straighten.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1000,
    xpReward: 190,
    recommendedLevel: 28,
    keyNPCs: ['Scholar Veyra'],
    loreKeys: ['wardenCraft'],
    failureCondition:
        'The loop tightens and the corridors fold in on themselves, sealing the section permanently.',
  ),
  const Quest(
    id: 'r_013',
    title: 'The Tithebound Awakening',
    description:
        'A Tithebound was captured alive — a first. It sits in a cage at Korval\'s camp, rocking and murmuring broken phrases. Then it said something clearly: "They are coming back." It hasn\'t spoken since.',
    objective:
        'Descend into the deeper ruins and investigate what the captured Tithebound meant.',
    aiObjective:
        'In the deeper ruins, 6 Tithebound have gathered in a chamber that shouldn\'t exist — the architecture doesn\'t match any of the maps. They are performing a ritual: standing in a circle, humming in unison, their hollow eyes leaking grey light. The humming is opening something — a crack in the wall that shows darkness beyond. The player must stop the ritual by breaking the circle (kill or scatter the Tithebound) and seal the crack (collapse the wall or destroy the focal point at the circle\'s center). Quest completes when the ritual is stopped and the crack is sealed.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2000,
    xpReward: 300,
    recommendedLevel: 40,
    keyNPCs: ['Historian Korval'],
    failureCondition:
        'The crack widens and something reaches through — a sound, not a creature. Everyone in the chamber forgets why they came.',
  ),
  const Quest(
    id: 'r_014',
    title: 'The Sunken Sanctum',
    description:
        'A temple lies half-submerged in the flooded lower ruins. Valdris builders shouldn\'t have built this deep — unless the ruins go further down than anyone believed.',
    objective:
        'Dive into the flooded sanctum and stop whatever is stirring below.',
    aiObjective:
        'A dark altar sits at the bottom of the flooded temple, guarded by 4 drowned Valdris soldiers (undead in ancient court armor). Something beneath the altar pulses — a sealed chamber. The player must destroy the altar to prevent it from being used as a summoning focus. Quest completes when the altar is destroyed. The sealed chamber beneath remains closed — for now.',
    location: 'Ruins',
    difficulty: QuestDifficulty.perilous,
    goldReward: 1200,
    xpReward: 200,
    recommendedLevel: 32,
    keyNPCs: ['Scholar Veyra'],
    failureCondition:
        'The altar completes its purpose and the sealed chamber beneath cracks open.',
  ),
  const Quest(
    id: 'r_015',
    title: 'The Cult of Valdris',
    description:
        'A cult has formed among the ruin-obsessed — mortals who believe Valdris was taken, not destroyed, and that they can follow it wherever it went. They\'ve consecrated a blood altar in the throne room.',
    objective:
        'Destroy the cult\'s blood altar in the Valdris throne room before their ritual completes.',
    aiObjective:
        'There are 8 cultists and their leader (a former scholar named Morvaine) performing a ritual at a blood-soaked altar in the throne room. They believe the ritual will open a path to wherever Valdris went. The player must destroy the altar (topple it, shatter it, or kill Morvaine to break the ritual). Quest completes when the altar is destroyed or Morvaine is dead. The cult is wrong about the method — but not about Valdris being taken.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 2500,
    xpReward: 350,
    recommendedLevel: 48,
    keyNPCs: ['Cult Leader Morvaine'],
    failureCondition:
        'The ritual fails catastrophically, killing the cultists and releasing a psychic shockwave that destabilizes the ruins above.',
  ),
  const Quest(
    id: 'r_016',
    title: 'The Wrong Room',
    description:
        'A mapping team found a room that shouldn\'t exist. It\'s not on any plan. The door was sealed from the inside. When they opened it, one of them said, "This room is bigger than the building it\'s in." He was right.',
    objective:
        'Enter the impossible room in the Valdris ruins and survive what\'s inside.',
    aiObjective:
        'The room is dimensionally distorted — larger inside than outside, with geometry that bends at the edges. Inside are 4 Tithebound who appear to be guarding something: a stone archway at the back of the room that leads to a wall. The archway hums faintly. The player must clear the Tithebound and examine the archway. The archway is dormant — it doesn\'t lead anywhere yet. Quest completes when the player examines the archway and returns to report to Scholar Veyra. The archway\'s purpose is unknown at this point.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 1800,
    xpReward: 280,
    recommendedLevel: 38,
    keyNPCs: ['Scholar Veyra', 'Tithebound Guardians'],
    failureCondition:
        'The room contracts around the player, and the archway activates briefly — a sound escapes through it that the player cannot forget.',
  ),

  // ── Ruins: Levels 51–59 ──
  //    Deepest mortal-accessible ruins. Tithebound
  //    are organized. The architecture is openly wrong.
  //    The hum grows louder.
  const Quest(
    id: 'r_017',
    title: 'The Tithebound War',
    description:
        'The Tithebound have split into two factions in the deep ruins. One group attacks anyone who enters. The other stands at the edges, watching, making no move to stop them — or help. Something has changed below.',
    objective:
        'Navigate the Tithebound conflict in the deep ruins and reach the lowest accessible chamber.',
    aiObjective:
        'Two Tithebound factions: 5 hostile and 3 passive. The hostile ones attack on sight. The passive ones will let the player pass if not threatened — one of them points deeper and whispers "don\'t go... deeper" but does not stop the player. The lowest accessible chamber contains a mural depicting a kingdom being pulled into the sky — but the sky is dark and the kingdom is intact, not destroyed. In the mural\'s background, a great tree and distant mountains are visible, suggesting whatever happened here touched more than just Valdris. This contradicts everything historians believe about Valdris. Quest completes when the player sees the mural and returns alive.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 3500,
    xpReward: 400,
    recommendedLevel: 55,
    keyNPCs: ['Passive Tithebound'],
    loreKeys: ['ossborn'],
    failureCondition:
        'The hostile Tithebound overwhelm the player and the passive ones seal the passage behind them.',
  ),

  // ── Ruins: Levels 60–75 ──
  //    The Nameless Choir returns. Aware Tithebound
  //    elders. The Severance wound opens. Quests
  //    begin transitioning into the folded Valdris
  //    dimension.
  const Quest(
    id: 'r_018',
    title: 'The Sound Returns',
    description:
        'The hum that scholars dismissed has become a sound — a layered, shifting noise that strips the edges off your thoughts. Scholar Veyra can no longer enter the deep ruins. She says she forgot her own name for three seconds and that was enough.',
    objective:
        'Descend into the deepest ruins where the sound is loudest and discover its source.',
    aiObjective:
        'The Nameless Choir has returned — not creatures, but sound itself, the noise of a dimensional wound waking after centuries of silence. Aware Tithebound elders (2 of them) block the path, speaking in full sentences for the first time: they beg the player not to go deeper. They remember fragments of what happened to their species. If the player pushes past, they encounter the Choir directly — prolonged exposure strips small memories (a face, a name). The player must reach the source: a crack in reality at the ruins\' lowest point, visible as a tear in the air that shows darkness and distant pale towers beyond. Quest completes when the player sees the Severance wound and returns to the surface with the knowledge.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4200,
    xpReward: 460,
    recommendedLevel: 62,
    keyNPCs: ['Aware Tithebound Elders', 'Scholar Veyra'],
    failureCondition:
        'The Choir strips enough of the player\'s memory that they forget how to navigate back and must be rescued, remembering nothing.',
  ),
  const Quest(
    id: 'r_019',
    title: 'The Elder\'s Confession',
    description:
        'A Tithebound elder — more aware than any encountered before — has approached the surface camp. She speaks in halting but complete sentences. She says she remembers what happened to her people. She wants to tell someone before the Choir takes it.',
    objective:
        'Protect the aware Tithebound elder while she speaks, and learn what happened to her species.',
    aiObjective:
        'The Tithebound elder (Ash-Mother, as she calls herself) is deteriorating — the Nameless Choir is actively trying to reclaim her memories. 4 hostile Tithebound are hunting her (sent by the Choir\'s resonance). The player must protect her through 3 waves of Tithebound attacks while she speaks. She reveals: her people came seeking the source of a resonance. The sound shaped itself into what they wanted most. By the time they understood it was not a bargain, it had already taken too much. Their entire species was hollowed out. She says something is on the other side of the wound — intact, vast, alive. Quest completes when the 3 waves are repelled and the Ash-Mother finishes her account. She forgets everything she just said within minutes.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 4500,
    xpReward: 480,
    recommendedLevel: 68,
    keyNPCs: ['Ash-Mother (Tithebound Elder)'],
    failureCondition:
        'The hostile Tithebound reach the Ash-Mother and she is reclaimed — she goes hollow mid-sentence and joins the patrol.',
  ),
  const Quest(
    id: 'r_020',
    title: 'Through the Choir',
    description:
        'The Severance wound is open. The Nameless Choir fills the deepest chamber — a sound that strips everything. Beyond it, through the tear, towers of pale stone are visible. Valdris was not destroyed. It was taken. The player can see it.',
    objective:
        'Pass through the Nameless Choir and enter the folded dimension of Valdris.',
    aiObjective:
        'The passage through the Choir is not a combat encounter — it is an endurance trial. The Choir strips memory with prolonged exposure. The player must push through the Severance wound while the Choir takes pieces: a childhood memory, a friend\'s name, the reason they came. The player emerges on the other side into the folded kingdom of Valdris — towers of pale stone, streets of dark glass, a sky with no stars. The air is too still. The silence after the Choir is almost worse than the sound. Quest completes when the player successfully passes through the wound and enters Valdris.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 5000,
    xpReward: 500,
    recommendedLevel: 72,
    keyNPCs: ['Aware Tithebound Elder'],
    failureCondition:
        'The Choir takes too much and the player collapses at the threshold, dragged back by Tithebound who cannot explain why they helped.',
  ),

  // ── Ruins: Levels 76–100 ──
  //    Inside the folded Valdris dimension.
  //    Looping citizens, wrong geometry, the
  //    throne entity.
  const Quest(
    id: 'r_021',
    title: 'The Living Kingdom',
    description:
        'Valdris is alive. The streets are paved in dark glass that reflects no stars. Citizens move in slow processions, smiling too wide, repeating the same words. The architecture bends at the edges. Something is deeply, fundamentally wrong.',
    objective:
        'Explore the folded kingdom of Valdris and understand what happened to its people.',
    aiObjective:
        'The player explores the folded Valdris: intact towers, looping citizens ("Welcome to Valdris, traveler. We have been expecting you."), streets that curve inward toward the throne room. The citizens are not hostile — they are performing the memory of being alive, endlessly. Some repeat gestures: lifting a cup, turning a page, bowing to an empty chair. The player must reach the outer ring of the city and find 1 citizen who has broken the loop — a court scribe who writes the same sentence over and over but occasionally writes something different: "This is not right." The scribe can point the player toward the throne room. Quest completes when the player speaks to the broken-loop scribe and learns the throne room is the center of everything.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 8000,
    xpReward: 600,
    recommendedLevel: 80,
    keyNPCs: ['Looping Citizens', 'The Broken Scribe'],
    failureCondition:
        'The player begins to loop with the citizens — repeating an action without realizing it until they snap out of it, having lost hours.',
  ),
  const Quest(
    id: 'r_022',
    title: 'The Throne That Knows Your Name',
    description:
        'The throne room is always visible from any street, as though the city curves inward toward it. Something sits on the throne. It wears a crown. It is not a king. It knows the player\'s name.',
    objective:
        'Enter the throne room of Valdris and confront whatever rules the folded kingdom.',
    aiObjective:
        'The throne entity is the dimension\'s own awareness given shape — it wears a crown because the kingdom expects a king. When it speaks, its voice is the Nameless Choir, quieter and directed. It knows the player\'s name. It knows what memories the Choir stripped on the way in. It offers to return them — every stolen face, every lost name. The price is staying in Valdris forever. The player must refuse the offer and survive the entity\'s response (it does not attack physically — it uses the Choir, intensified, to strip more memories and will). Quest completes when the player refuses the entity and maintains their identity despite the Choir\'s assault.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 12000,
    xpReward: 800,
    recommendedLevel: 92,
    keyNPCs: ['The Throne Entity'],
    failureCondition:
        'The player accepts the offer or loses themselves to the Choir. They become another looping citizen of Valdris.',
  ),
  const Quest(
    id: 'r_023',
    title: 'The Severance Undone',
    description:
        'The throne entity has been defied. The kingdom trembles. The Choir screams. The dimensional wound that created this prison is destabilizing — if it collapses with the player inside, they are trapped in Valdris forever. But if the wound can be forced wider, Valdris might return to the real world.',
    objective:
        'Escape the folding Valdris dimension before the Severance wound closes — or find a way to break the Severance entirely.',
    aiObjective:
        'The dimension is collapsing as the throne entity rages. The player has 2 choices: (1) Run — retrace through the city (now hostile, looping citizens grab at the player, streets rearrange) and pass back through the Choir to the mortal ruins. (2) Find the Severance anchor in the throne room (the crown itself) and destroy it, which would undo the Severance and crash Valdris back into reality — with unpredictable consequences. Both paths are valid. The first is survival. The second changes the world permanently. Quest completes when the player either escapes through the wound or destroys the crown.',
    location: 'Ruins',
    difficulty: QuestDifficulty.suicidal,
    goldReward: 15000,
    xpReward: 1000,
    recommendedLevel: 100,
    keyNPCs: ['The Throne Entity', 'The Broken Scribe'],
    failureCondition:
        'The wound closes with the player inside. Valdris seals. Another looping citizen joins the procession.',
  ),
];
