# Game Design & Feature Roadmap: Evolving from Chat to RPG

This document tracks the steps needed to transform Questborne from a disconnected "AI chat menu" into a cohesive, immersive RPG world. The core goal is to make the player feel like they are inhabiting a living, reacting world, with progression systems that reward exploration and mastery.

## 1. Flow & Navigation: Reducing "Menu Jumps"
Currently, the game feels disjointed because players bounce between a static Guild menu and isolated chat screens.

- [ ] **Unified Hub World / Map view:** Replace the static "Notice Board" list with an interactive regional map (Forest, Caves, Ruins) or a visual "City Hub". You tap on the Tavern to rest/check rumors, the Blacksmith to upgrade, or the World Map to travel.
- [ ] **Seamless Transitions:** When starting a quest, instead of jumping to a completely new screen, slide the map away and fade the chat/narrative view in. Keep the core UI (health, gold, current location) visible at all times to maintain a sense of place.
- [ ] **Remove "Back to Menu" logic:** When a quest ends, the player shouldn't just "pop" back to a menu. The narrative should return them to a safe hub (e.g., "You drag yourself back to the Thornwall gates..."). The hub options should appear naturally below the narrative.

## 2. World State & Consequence System
Quests should not exist in a vacuum; they must feel like a web of events.

- [ ] **Prerequisite Quest Trees:** Instead of unlocking quests simply by character level, build quest chains. (e.g., You cannot get "The Verdant Terror" until you have completed "Curse of the Black Vine").
- [ ] **Global "World Variables" State:** Implement a system to track the world's state globally, managed by the Bloc (e.g., `isVoidRiftOpen`, `isOssbornMad`, `thornveilCorruptionLevel`).
- [ ] **Inject World State into AI Prompts:** The `AIService` system prompt must read the global world variables. If `thornveilCorruptionLevel` is high, the AI should describe twisted, blighted flora even on standard gathering quests.
- [ ] **True Failure Consequences:** If a player fails the "Collapsed Shaft" quest, the next time they visit the Guild, a new "Retrieval" quest appears, or pickaxes in the shop become 3x more expensive because the mine is closed.
- [ ] **World Morphing:** If a major failure occurs (e.g., leaving a Void Rift open), alter the game's UI and subsequent quests for a set time (e.g., Forest turns purple, enemies hit 20% harder).
- [ ] **Stakes & Loss Aversion:** Implement a tangible penalty for dying on a quest (e.g., dropping a percentage of unbanked gold or losing specific gathered materials).

## 3. Dedicated Exploration & Gathering Mode
Give the player things to do outside of intense, narrative-heavy boss fights to make it feel like a classic RPG grind.

- [ ] **"Patrol / Exploration" Action:** On the map, allow players to select "Explore [Region]" without a specific quest objective. This provides a "short session" loop for a 5-minute bus ride.
- [ ] **Random Encounter System:** During exploration, use a stripped-down, faster AI prompt to generate minor events: finding an herb, fighting a single stray wolf, discovering a rusted chest.
- [ ] **Materials & Crafting:** Introduce gathering items (e.g., *Iron Ore*, *Blight-weed*, *Void Dust*). Collect these during Explorations or as minor loot in main quests.
- [ ] **Interlocking Economies:** Ensure gold isn't the only driver. Require specific materials (e.g., 10 Blight-wood) to upgrade the Guild base or craft unique Relics, creating a Russian Doll of ongoing goals (Zeigarnik effect).
- [ ] **The Forge / Upgrade System:** Add a Blacksmith feature where players use gathered materials + gold to upgrade their weapons from "Level 1" to "Level 2", tweaking the stats and generating a new item name.

## 4. Crunchier RPG Mechanics & Combat
Make the player rely on game systems, not just creative typing.

- [ ] **Active Skill Hotbar:** Instead of purely typing commands, give the player 3-4 persistent skill buttons based on their class/equipment (e.g., [Shield Bash - 10 MP], [Fireball - 15 MP], [Flee]). Tapping these sends a structured, guaranteed action to the AI.
- [ ] **Dice Rolls / Stat Checks:** Visually display a D20 or stat check on the screen when a major action is taken. Use their Agility to roll for dodging. If they roll poorly, force the AI to narrate a failure and apply heavy damage. This anchors the AI's randomness to visible game math.
- [ ] **Meaningful Status Effects:** You have status effects—make them visible and critical. If a player is "Burning", the UI should glow red, and they should lose HP every time they send a message until they type a command to extinguish it or use a potion.

## 5. NPC Relationships & Companions
Make the inhabitants of the world persistent.

- [ ] **NPC Affinity Tracking:** Track how much key NPCs (Druid Theron, Foreman Brick) like the player. 
- [ ] **Persistent dialogue memory:** Save specific key facts about the player's interactions with NPCs to inject back into the AI prompt when meeting them again.
- [ ] **Recruitable Companions:** Let the player bring an NPC along. The companion grants a passive buff (e.g., +20% Magic resist) and is actively injected into the system prompt so the AI includes them in the story.

## 6. Meaningful Progression
Leveling up shouldn't just be a number going up; it should unlock choices.

- [ ] **Skill Trees:** When leveling up, give the player a choice between active skills or passive perks to put points into (e.g., "Choose: +5 Max HP or unlock 'Cleave' skill").
- [ ] **Visual Gear Changes:** If the player equips a legendary Relic, ensure the UI updates to show an aura or a specific visual indicator, making their gear feel tangible.


<!-- -user status throguh quests -->
<!-- -user heals after quest progression,  -->
<!-- -dies resets quest progression -->
<!-- -clicking topleft goes back fro some reason -->
<!-- -make anonymous sign ons not allowed to play the ai or just remove anonymous -->
<!-- -fix subsccirption models with actual numbers -->
<!-- -user chances should be not based off ai -->
<!-- -credit spend is not limited on free tier, (check if works) -->
<!-- -add turn limit on quests to fail. -->
<!-- -items can be spammed (i think complete) -->
<!-- -add tpm checks -->

<!-- -remove testing long pause quest complete -->
<!-- -clicked enter fast then it asked me for my name again -->
<!-- -continue with google button looks weird -->
<!-- -authenticate tier and credits with purchase reciept -->
<!-- -add check for subscriptions in settings functionality -->

<!-- -Check if rls policies are good, because created new. -->
<!-- -change the price display depending on currency -->

<!-- -use flash lite free tier maybe (flash lite breaks structure) -->

V2
-image gen
-maybe skill check should be handled by the ai to see what function should run