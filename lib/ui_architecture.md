# UI & Navigation Architecture

This document breaks down the new screen structures, user flows, and UI updates required to transform the app into a cohesive RPG, removing the disjointed "menu jumpy" feel.

---

## 1. The Core Navigation Loop

The game will move away from a standard App "Router" with back buttons. Instead, think of the architecture as having **Two Main States**:

1.  **Hub State:** The player is safe in town. They manage gear, start quests, and talk to NPCs.
2.  **Field State:** The player is on an active quest/patrol. This is the AI chat view.

All navigation between these two states should be seamless (e.g., a fade-in or slide-up, rather than pushing a whole new Scaffold onto the navigation stack).

### Navigation Flow Map
`Start Page` -> `Town Hub (Default Screen)`
`Town Hub` -(tap map)-> `World Map` -(select location)-> `Field State (AI Chat)`
`Field State` -(finish/die)-> `Town Hub`
`Town Hub` -(tap shop)-> `Blacksmith Panel (Overlay/Modal)`

---

## 2. Updated Screens & New UI Components

### A. The Town Hub (Replaces `guild_page.dart`)
This is the new "Home Screen". It should feel like a distinct location, not a list.

*   **Visuals:** A dark, atmospheric background image of "Thornwall Gates" or a "Guild Hall".
*   **Persistent Top Bar (Global):**
    *   Player Level & XP Bar on the top left.
    *   HP/MP Bars visible *even when in town*.
    *   Gold and primary premium currency (if any) on the top right.
*   **Interactive Locations (Interactive buttons layered over the background):**
    *   **The Gates (Depart):** Opens the World Map.
    *   **The Blacksmith:** Opens the forge/upgrade screen (Modal overlay).
    *   **The Tavern (Rest/Rumors):** Heals HP/MP over time or for gold. Displays current global World State lore (e.g., "The Forest is corrupted today...").
    *   **The Notice Board:** Opens a modal to review *active/abandoned* quests or special bounties.
*   **Bottom Navigation Bar (Optional):**
    *   Might still exist for quick access to Inventory, Character Stats, Settings, but ideally integrated into the Hub UI.

### B. World Map Selection (New Map UI)
When the player taps "The Gates" from the Hub.

*   **Visuals:** A stylized parchment map.
*   **Regions:** Nodes for `Thornveil Forest`, `The Hollows (Caves)`, and `Valdris Ruins`.
*   **Visual Indicators:** If a region has a special World State (e.g., Forest is Corrupted), the node glows purple or red.
*   **Interaction:** Tapping a region opens the **Region Details Panel** (a bottom sheet).

### C. Region Details Panel (Bottom Sheet on the Map)
When a region is tapped, this slides up.

*   **Content:**
    *   Region Level Range (e.g., Level 5 - 15).
    *   Current Danger Level / Corruption Status.
    *   **Action 1: "Available Quests" List.** Shows the narrative quests available here.
    *   **Action 2: "Patrol / Gather" Button.** (The short-session loop). Starts an endless, lower-stakes text generation mode focusing on finding materials.

### D. The Field State (Updates to `game_page.dart`)
The actual AI Chat interface where gameplay happens. Needs to feel more "gamey".

*   **Persistent Core UI:** The Top Bar (HP/MP/Gold) remains identical to the Hub. Do not change it so the player feels grounded.
*   **Active Skill Hotbar (New Middle Component):**
    *   Located just below the chat output and above the text input.
    *   A row of 3-4 distinct rectangular buttons (e.g., [Flee], [Slash (5 MP)], [Heal (10 MP)]).
    *   Tapping these visually "presses" the button and sends a hardcoded event to the AI Bloc, rather than requiring typing.
*   **Dice Roll Overlay (New Visual Polish):**
    *   When an action is taken that has a chance of failure, briefly show a D20 animation in the center of the screen before the AI text starts generating. "Roll: 14 (Success!)".
*   **Status Effect Gloom (New Visual Polish):**
    *   If poisoned, the edges of the whole screen vignette with a sickly green. If burning, orange.

### E. Crafting & Blacksmith (New Screen / Modal)
Accessed from the Town Hub. Replaces the simple list-based standard shop.

*   **Layout:** Two tabs - `Buy/Sell Items` vs `Forge/Upgrade`.
*   **Forge Tab:**
    *   Left side: List of current gear (e.g., "Rusty Iron Sword").
    *   Right side: Upgrade costs. "To Upgrade to Level 2: Requires 50 Gold + 3 Iron Ore + 1 Wolf Pelt".
    *   If materials are met, a big glowing "FORGE" button. This updates the item's stats and injects a new name.

### F. Post-Quest Transition (New Flow)
When a quest ends (Success or Failure).

*   **No more "Popping" screens:** Do not jump instantly to a menu.
*   **The Flow:**
    1.  The AI prints the final consequence ("You return to the Guild battered...").
    2.  The text input area and skill hotbar slide down and hide.
    3.  A "Loot & Experience Summary" screen fades over the chat area. Shows exactly what was gained or lost (e.g., "Found: 3 Iron Ore, 100 Gold. Level Up!").
    4.  A single button heavily styled at the bottom: "Return to Hub".
    5.  Hitting that fades out the chat background and fades in the `Town Hub` background.

---

## 3. Component Implementation Priorities (What to build first)

1.  **Phase 1: The UI Shell.** Build the `Town Hub` view and the `World Map` view using placeholder images. Connect them so you can click "Hub -> Map -> Region -> Game Page" without touching the underlying game logic yet.
2.  **Phase 2: The Skill Hotbar.** Add the MP-consuming skill buttons to the `game_page.dart` UI before the text input, and wire them to send specific prompts to the AI.
3.  **Phase 3: The Gathering Loop.** Create the "Materials" data model, update the Bloc to handle inventory stacking of materials, and create the "Patrol" option on the Region Panel.
4.  **Phase 4: The Blacksmith UI.** Build the upgrade panel reading from the new Material inventory.