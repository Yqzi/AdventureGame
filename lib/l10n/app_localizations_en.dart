// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'QUESTBORNE';

  @override
  String get appTagline => 'POWERED BY AI STORY ENGINE';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonClose => 'Close';

  @override
  String get startEnter => 'ENTER';

  @override
  String get startPremium => 'Premium';

  @override
  String get startSettings => 'SETTINGS';

  @override
  String get startVersion => 'Version 0.0.1 • Shadow-Crest Protocol';

  @override
  String continueWithProvider(String provider) {
    return 'Continue with $provider';
  }

  @override
  String get loginTitle => 'ENTER THE\nREALM';

  @override
  String get loginSubtitle => 'Choose how you wish to proceed';

  @override
  String get loginGoogle => 'Continue with Google';

  @override
  String get loginApple => 'Continue with Apple';

  @override
  String get errorSomethingWentWrong => 'Something Went Wrong';

  @override
  String get labelObjective => 'Objective';

  @override
  String get labelLocation => 'Location';

  @override
  String get labelReward => 'Reward';

  @override
  String get labelKeyFigures => 'Key Figures';

  @override
  String get guildTitle => 'The Notice Board';

  @override
  String get guildSubtitle => 'Quest Progression';

  @override
  String get guildObjective => 'OBJECTIVE';

  @override
  String get guildKeyFigures => 'KEY FIGURES';

  @override
  String get guildReward => 'REWARD';

  @override
  String get guildResume => 'Resume';

  @override
  String get guildAcceptQuest => 'Accept Quest';

  @override
  String get guildDone => 'Done';

  @override
  String get guildCompleted => 'COMPLETED';

  @override
  String get guildSideBounties => 'SIDE BOUNTIES';

  @override
  String get guildMainQuests => 'Main Quests';

  @override
  String get guildRepeatableQuests => 'Repeatable Quests';

  @override
  String guildLevelAbbr(int level) {
    return 'LV $level';
  }

  @override
  String guildGoldDisplay(int amount) {
    return '$amount Gold';
  }

  @override
  String get inventoryTitle => 'INVENTORY';

  @override
  String get inventoryUnequipped => 'UNEQUIPPED';

  @override
  String get shopTitle => 'THE MARKET';

  @override
  String get shopBuy => 'Buy';

  @override
  String get shopSold => 'Sold';

  @override
  String get shopSoldLabel => 'SOLD';

  @override
  String get shopNotEnoughGold => 'Not enough gold';

  @override
  String shopPurchased(String item) {
    return 'Purchased $item!';
  }

  @override
  String get shopClose => 'Close';

  @override
  String get shopMerchantQuote =>
      '\"Choose wisely, traveler. My wares cost more than just gold...\"';

  @override
  String shopGold(int amount) {
    return '$amount Gold';
  }

  @override
  String get shopMerchantWares => 'Merchant\'s Wares';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsProfile => 'PROFILE';

  @override
  String get settingsCharacterName => 'Character Name';

  @override
  String get settingsEmail => 'Email';

  @override
  String get settingsAiSafety => 'AI SAFETY';

  @override
  String get settingsHateSpeech => 'Hate Speech';

  @override
  String get settingsHarassment => 'Harassment';

  @override
  String get settingsDangerousContent => 'Dangerous Content';

  @override
  String get settingsGeneral => 'GENERAL';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsPremiumSubtitle => 'View subscription options';

  @override
  String get settingsRestoreSubscription => 'Restore Subscription';

  @override
  String get settingsRestoreSubtitle => 'Already subscribed? Restore it here';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'Change the app language';

  @override
  String get settingsLanguageSystem => 'System Default';

  @override
  String get settingsAccount => 'ACCOUNT';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteSubtitle =>
      'Permanently delete your account and all data';

  @override
  String get settingsLegal => 'LEGAL';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacySubtitle => 'How we handle your data';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsTermsSubtitle => 'Rules and conditions of use';

  @override
  String get settingsChangeName => 'CHANGE NAME';

  @override
  String get settingsChangeNameDesc => 'Choose a new name for your character';

  @override
  String get settingsEnterNewName => 'Enter new name';

  @override
  String get settingsNameReserved =>
      '\"Adventurer\" is reserved — pick something unique!';

  @override
  String settingsNameChanged(String name) {
    return 'Name changed to $name';
  }

  @override
  String get settingsChooseFilterLevel => 'Choose a filtering level';

  @override
  String get settingsCheckingSubscription =>
      'Checking for existing subscription...';

  @override
  String settingsSubscriptionRestored(String tier) {
    return 'Subscription restored! ($tier)';
  }

  @override
  String get settingsNoSubscription => 'No active subscription found.';

  @override
  String get settingsRestoreFailed =>
      'Could not restore subscription. Try again later.';

  @override
  String get settingsDeleteTitle => 'Delete Account';

  @override
  String get settingsDeleteMessage =>
      'This will permanently delete your account and all saved data. Any active subscription will also be cancelled. This action cannot be undone.';

  @override
  String get settingsDeleteConfirm => 'Delete';

  @override
  String get settingsDeleteFailed => 'Something went wrong. Try again later.';

  @override
  String get safetyLevelLow => 'Low';

  @override
  String get safetyLevelMedium => 'Medium';

  @override
  String get safetyLevelHigh => 'High';

  @override
  String get safetyDescLow => 'Permissive — suited for dark fantasy';

  @override
  String get safetyDescMedium => 'Balanced filtering';

  @override
  String get safetyDescHigh => 'Strict content filtering';

  @override
  String get subscriptionPlans => 'PLANS';

  @override
  String get subscriptionCredits => 'credits';

  @override
  String subscriptionCreditsDaily(int daily) {
    return 'credits (+$daily daily)';
  }

  @override
  String subscriptionCreditsRemaining(int max) {
    return 'credits remaining of $max';
  }

  @override
  String get subscriptionCurrent => 'Current';

  @override
  String subscriptionUpgradedTo(String tier) {
    return 'Upgraded to $tier!';
  }

  @override
  String get subscriptionManageGooglePlay =>
      'Manage Subscriptions on Google Play';

  @override
  String subscriptionMemory(String tag) {
    return '$tag memory';
  }

  @override
  String subscriptionResets(String date) {
    return 'Resets $date';
  }

  @override
  String subscriptionCreditsCount(int count) {
    return '$count credits';
  }

  @override
  String subscriptionCreditsDailyFeature(int max, int daily) {
    return '$max + $daily/day credits';
  }

  @override
  String get expeditionTitle => 'Expedition';

  @override
  String get expeditionOpenWorlds => 'Open Worlds';

  @override
  String get expeditionEnter => 'Enter Expedition';

  @override
  String get expeditionEnterShort => 'Enter';

  @override
  String get expeditionFreeRoam => 'Free Roam';

  @override
  String get expeditionFreeRoamDesc =>
      'No set objective — explore freely and see what awaits.';

  @override
  String get mapDarkwoodForest => 'The Darkwood Forest';

  @override
  String get mapDarkwoodForestDesc =>
      'An ancient woodland shrouded in perpetual twilight. Twisted oaks and gnarled roots hide forgotten paths, strange creatures, and whispers of old magic between the moss-covered stones.';

  @override
  String get mapSunkenCaverns => 'The Sunken Caverns';

  @override
  String get mapSunkenCavernsDesc =>
      'A vast subterranean network of dripping tunnels and glowing crystal chambers. The air is thick with the scent of damp earth, and unknown things skitter just beyond the torchlight.';

  @override
  String get mapAshenRuins => 'The Ashen Ruins';

  @override
  String get mapAshenRuinsDesc =>
      'Crumbling remnants of a once-great civilization, half-swallowed by sand and creeping vines. Collapsed archways lead to forgotten vaults, and the ghosts of the old world linger in every shadow.';

  @override
  String get navWorld => 'World';

  @override
  String get navQuest => 'Quest';

  @override
  String get navMarket => 'Market';

  @override
  String get navHero => 'Hero';

  @override
  String get navSheet => 'Sheet';

  @override
  String get nameDialogAppTitle => 'Questborne';

  @override
  String get nameDialogTitle => 'WHO ARE YOU?';

  @override
  String get nameDialogSubtitle => 'Speak your name, and let it begin.';

  @override
  String get nameDialogHint => 'Speak your name...';

  @override
  String get nameDialogErrorEmpty => 'The Questborne must have a name.';

  @override
  String get nameDialogErrorShort =>
      'Too short. Even a wanderer has two letters.';

  @override
  String get nameDialogErrorLong => 'Keep it under 20 characters.';

  @override
  String get nameDialogErrorReserved => 'That name is not allowed';

  @override
  String get lootObtained => 'OBTAINED';

  @override
  String lootGoldGained(int amount) {
    return '+$amount Gold';
  }

  @override
  String lootXpGained(int amount) {
    return '+$amount XP';
  }

  @override
  String lootHpRestored(int amount) {
    return '+$amount HP Restored';
  }

  @override
  String lootManaRestored(int amount) {
    return '+$amount Mana Restored';
  }

  @override
  String lootGoldLost(int amount) {
    return '-$amount Gold';
  }

  @override
  String lootDamage(int amount) {
    return '-$amount HP';
  }

  @override
  String get lootLevelUp => 'Level Up!';

  @override
  String lootLevelUpMultiple(int levels) {
    return 'Level Up! (+$levels levels)';
  }

  @override
  String diceCheck(String action) {
    return '$action CHECK';
  }

  @override
  String get questCompleteTitle => 'QUEST COMPLETE';

  @override
  String get questCompleteSubtitle => 'Your tale has been written.';

  @override
  String get questCompleteRewards => 'REWARDS';

  @override
  String get questCompleteReturn => 'RETURN TO GUILD';

  @override
  String questCompleteGold(int amount) {
    return '$amount Gold';
  }

  @override
  String questCompleteXp(int amount) {
    return '$amount XP';
  }

  @override
  String get questFailedTitle => 'QUEST FAILED';

  @override
  String get questFailedSubtitle => 'The darkness claims another soul.';

  @override
  String get questFailedReset => 'Your quest set progress has been reset.';

  @override
  String get questFailedReturn => 'RETURN TO GUILD';

  @override
  String spellManaCost(int cost) {
    return '$cost MP';
  }

  @override
  String get itemTypeWeapon => 'WEAPON';

  @override
  String get itemTypeArmor => 'ARMOR';

  @override
  String get itemTypeAccessory => 'ACCESSORY';

  @override
  String get itemTypeRelic => 'RELIC';

  @override
  String get itemTypeSpell => 'SPELL';

  @override
  String get rarityCommon => 'COMMON';

  @override
  String get rarityRare => 'RARE';

  @override
  String get rarityEpic => 'EPIC';

  @override
  String get rarityMythic => 'MYTHIC';

  @override
  String get actionMeleeAttack => 'Melee Attack';

  @override
  String get actionRangedAttack => 'Ranged Attack';

  @override
  String get actionOffensiveMagic => 'Offensive Magic';

  @override
  String get actionDefensiveMagic => 'Defensive Magic';

  @override
  String get actionStealth => 'Stealth';

  @override
  String get actionAssassination => 'Assassination';

  @override
  String get actionDodge => 'Dodge';

  @override
  String get actionParry => 'Parry';

  @override
  String get actionPersuasion => 'Persuasion';

  @override
  String get actionThrow => 'Throw';

  @override
  String get actionDexterity => 'Dexterity';

  @override
  String get actionEndurance => 'Endurance';

  @override
  String get actionFlee => 'Flee';

  @override
  String get outcomeCriticalFailure => 'Critical Failure';

  @override
  String get outcomeFailure => 'Failure';

  @override
  String get outcomePartialSuccess => 'Partial Success';

  @override
  String get outcomeSuccess => 'Success';

  @override
  String get outcomeCriticalSuccess => 'Critical Success';

  @override
  String get difficultyRoutine => 'Routine Task';

  @override
  String get difficultyDangerous => 'Dangerous';

  @override
  String get difficultyPerilous => 'Perilous';

  @override
  String get difficultySuicidal => 'Suicidal';

  @override
  String get statusPoisoned => 'POISONED';

  @override
  String get statusBurning => 'BURNING';

  @override
  String get statusFrozen => 'FROZEN';

  @override
  String get statusBlessed => 'BLESSED';

  @override
  String get statusShielded => 'SHIELDED';

  @override
  String get statusWeakened => 'WEAKENED';

  @override
  String get tierWanderer => 'Wanderer';

  @override
  String get tierAdventurer => 'Adventurer';

  @override
  String get tierChampion => 'Champion';

  @override
  String get tierTaglineFree => 'Begin your journey';

  @override
  String get tierTaglineAdventurer => 'Deeper stories await';

  @override
  String get tierTaglineChampion => 'The ultimate experience';

  @override
  String get statAtk => 'ATK';

  @override
  String get statDef => 'DEF';

  @override
  String get statMag => 'MAG';

  @override
  String get statAgi => 'AGI';

  @override
  String get statHp => 'HP';

  @override
  String get statMp => 'MP';

  @override
  String get labelGold => 'Gold';

  @override
  String get labelXp => 'XP';

  @override
  String labelLevel(int level) {
    return 'Lv $level';
  }

  @override
  String statSummaryFormat(String label, String value) {
    return '$label $value';
  }

  @override
  String priceFormat(int price) {
    return '$price Gold';
  }

  @override
  String rewardFormat(int gold, int xp) {
    return '$gold Gold  ·  $xp XP';
  }

  @override
  String get errorSignInRequired => 'You must be signed in to play.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorSignInToPlay =>
      'Sign in with Google or Apple to play quests.';

  @override
  String get errorTooManyRequests =>
      'Too many requests — please wait a moment and try again.';

  @override
  String get errorServiceUnavailable =>
      'The AI service is temporarily unavailable. Please try again in a moment. Your credit has been refunded.';

  @override
  String get errorServerError =>
      'Something went wrong on our end. Please try again.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetworkError =>
      'Something went wrong. Check your internet connection and try again.';

  @override
  String get locationForest => 'Forest';

  @override
  String get locationCave => 'Cave';

  @override
  String get locationRuins => 'Ruins';

  @override
  String freeRoamTitle(String mapTitle) {
    return '$mapTitle — Free Roam';
  }

  @override
  String get freeRoamObjective =>
      'Explore freely and see what the world has in store.';

  @override
  String get equip => 'Equip';

  @override
  String get unequip => 'Unequip';

  @override
  String get nameDialogContinue => 'CONTINUE';

  @override
  String get cardAcceptQuest => 'ACCEPT QUEST';

  @override
  String get cardInvestigate => 'Investigate';

  @override
  String get cardEnter => 'Enter';

  @override
  String get cardRewardLabel => 'REWARD';

  @override
  String get cardDifficultyPrefix => 'Difficulty: ';

  @override
  String levelPrefix(int level) {
    return 'lvl $level';
  }

  @override
  String get questRepF01Title => 'Goblin Patrol';

  @override
  String get questRepF01Desc =>
      'Goblin scouts have been spotted along the forest edge again. The militia posts a standing bounty â€” clear them out before they raid another farmstead.';

  @override
  String get questRepF01Obj => 'Hunt goblin scouts in the forest outskirts.';

  @override
  String get questRepC01Title => 'Tunnel Vermin';

  @override
  String get questRepC01Desc =>
      'Rats and cave spiders infest the upper Hollows. The miners pay good coin to anyone willing to clear them â€” the creatures breed faster than the tunnels can be sealed.';

  @override
  String get questRepC01Obj =>
      'Clear vermin from the upper Hollows mining tunnels.';

  @override
  String get questRepR01Title => 'Restless Bones';

  @override
  String get questRepR01Desc =>
      'The outer barrows of Valdris never stay quiet. Skeletons claw free of their graves every few days. Historian Korval pays a bounty to keep the camp entrance clear.';

  @override
  String get questRepR01Obj =>
      'Lay restless undead to rest in the outer Valdris barrows.';

  @override
  String get questRepF02Title => 'Bandit Bounty';

  @override
  String get questRepF02Desc =>
      'Bandit scouts patrol the trade roads near the Thornveil. Merchants refuse to travel without armed escort. The bounty board keeps this post pinned permanently.';

  @override
  String get questRepF02Obj =>
      'Hunt bandit scouts along the Thornveil trade roads.';

  @override
  String get questRepC02Title => 'Ore Vein Escort';

  @override
  String get questRepC02Desc =>
      'A new ore vein has been found in the mid-Hollows but the tunnels are prowled by cave creatures. Foreman Brick needs someone to escort miners to the vein and back.';

  @override
  String get questRepC02Obj =>
      'Escort miners safely through dangerous Hollows tunnels.';

  @override
  String get questRepR02Title => 'Artifact Salvage';

  @override
  String get questRepR02Desc =>
      'Scholar Veyra needs cursed artifacts recovered from the upper ruins before the scavengers sell them to collectors who have no idea what they are handling.';

  @override
  String get questRepR02Obj =>
      'Recover cursed artifacts from the upper Valdris ruins.';

  @override
  String get questRepF03Title => 'Corruption Cleansing';

  @override
  String get questRepF03Desc =>
      'Hollow-corrupted undergrowth is spreading through the mid-forest. Druid Theron\'s circle burns it back weekly, but they need someone to clear the creatures that nest in the corrupted groves.';

  @override
  String get questRepF03Obj =>
      'Clear Hollow-corrupted creatures from the mid-forest groves.';

  @override
  String get questRepC03Title => 'Fungal Harvest';

  @override
  String get questRepC03Desc =>
      'The Deep Mother\'s spore blooms keep erupting in the mid-Hollows. Herbalist Nessa needs someone to destroy the blooms before they madden the miners â€” and to bring back samples she can study.';

  @override
  String get questRepC03Obj =>
      'Destroy dangerous fungal blooms in the mid-Hollows.';

  @override
  String get questRepR03Title => 'Tithebound Patrol';

  @override
  String get questRepR03Desc =>
      'Tithebound sentinels wander the mid-depth ruins in endless loops. When they stray too close to the surface camp, someone has to drive them back. The bounty is always posted.';

  @override
  String get questRepR03Obj =>
      'Push back Tithebound patrols from the upper ruins.';

  @override
  String get questRepF04Title => 'Pale Root Skirmish';

  @override
  String get questRepF04Desc =>
      'Pale Root raiders have been ambushing patrols near the Thornwall. The elves disavow them, but the attacks continue. The bounty is high â€” these are no common bandits.';

  @override
  String get questRepF04Obj =>
      'Engage Pale Root raiders near the Thornwall border.';

  @override
  String get questRepC04Title => 'Deep Vein Patrol';

  @override
  String get questRepC04Desc =>
      'Creatures freed by failing ward-stones crawl up from the deep Hollows. The Ossborn ignore anything that doesn\'t threaten their seals. Foreman Brick needs surface folk to keep the mid-tunnels passable.';

  @override
  String get questRepC04Obj =>
      'Patrol the deep Hollows and clear escaped creatures.';

  @override
  String get questRepR04Title => 'Resonance Suppression';

  @override
  String get questRepR04Desc =>
      'The hum in the deep ruins keeps spawning resonance nodes â€” crystals that drive people mad. Scholar Veyra pays well to have them shattered before the sound reaches the surface.';

  @override
  String get questRepR04Obj =>
      'Destroy resonance nodes in the deep Valdris ruins.';

  @override
  String get questRepF05Title => 'Verdant Court Errand';

  @override
  String get questRepF05Desc =>
      'The Verdant Court has tasked mortal champions with purging corruption from sacred groves the elves cannot reach without crossing the Thornwall. The pay is elvish silver â€” worth more than human gold.';

  @override
  String get questRepF05Obj =>
      'Purge corruption from a sacred grove for the Verdant Court.';

  @override
  String get questRepC05Title => 'Binding Repair';

  @override
  String get questRepC05Desc =>
      'The ward-stones in the deep Hollows keep cracking. The Forge Spirit can\'t tend them all. Someone must carry replacement seal-stones to the failing pedestals before what\'s behind them breaks free.';

  @override
  String get questRepC05Obj =>
      'Deliver seal-stones to failing ward-stone pedestals in the deep Hollows.';

  @override
  String get questRepR05Title => 'Dimensional Seal';

  @override
  String get questRepR05Desc =>
      'Minor tears keep opening near the Severance wound â€” reality fraying at the edges. Aware Tithebound elders mark them. Someone must close them before the Nameless Choir leaks through.';

  @override
  String get questRepR05Obj =>
      'Seal minor dimensional tears near the Severance wound.';

  @override
  String get questF001Title => 'Goblin Camp on the Trade Road';

  @override
  String get questF001Desc =>
      'A goblin scouting party has set up a camp where the trade road enters the Thornveil. Woodcutters and merchants refuse to pass.';

  @override
  String get questF001Obj =>
      'Locate and destroy the goblin camp blocking the forest trade road.';

  @override
  String get questF002Title => 'Dire Wolves of the Thornveil';

  @override
  String get questF002Desc =>
      'A pack of dire wolves has claimed the main road through the outer Thornveil. Travelers are being dragged into the underbrush.';

  @override
  String get questF002Obj =>
      'Hunt or drive off the dire wolf pack terrorizing the Thornveil road.';

  @override
  String get questF003Title => 'The Poisoned Stream';

  @override
  String get questF003Desc =>
      'A foul green sludge seeps from somewhere upstream in the Thornveil. Animals that drink from the brook collapse dead. Herbalist Nessa fears it may reach the village water supply.';

  @override
  String get questF003Obj =>
      'Follow the stream through the Thornveil and destroy whatever is poisoning it.';

  @override
  String get questF004Title => 'The Missing Woodcutter';

  @override
  String get questF004Desc =>
      'Old Henrik went to fell timber at the Thornveil\'s edge three days ago. His axe was found embedded in a tree, covered in claw marks.';

  @override
  String get questF004Obj =>
      'Track the missing woodcutter deeper into the outer Thornveil and learn his fate.';

  @override
  String get questF005Title => 'Bandit Ambush';

  @override
  String get questF005Desc =>
      'Bandits have been robbing merchants on the forest road outside the Thornwall. They vanish into the canopy before the militia arrives.';

  @override
  String get questF005Obj =>
      'Set a trap for the forest bandits and take down their leader.';

  @override
  String get questF006Title => 'Curse of the Black Vine';

  @override
  String get questF006Desc =>
      'A thorned blight is creeping across the forest floor near the Thornwall border. It moves on its own at night, strangling trees. The Circle of Thorn druids say they\'ve never seen anything like it.';

  @override
  String get questF006Obj =>
      'Find the heart of the Black Vine deep in the Thornveil and burn it out.';

  @override
  String get questF007Title => 'The Fey Ambush';

  @override
  String get questF007Desc =>
      'Sprites at the Thornveil\'s edge have turned hostile without warning. Travelers report being enchanted and robbed â€” or worse, led off the path and never seen again. The old fey pacts may be fraying.';

  @override
  String get questF007Obj =>
      'Discover why the fey have turned hostile and find a way to stop the attacks.';

  @override
  String get questF008Title => 'The Vaelithi Deserter';

  @override
  String get questF008Desc =>
      'An elf was found unconscious at the Thornwall border, covered in wounds that look self-inflicted â€” as though she clawed through the barrier from the inside. She mutters about a \"pale root\" and begs not to be sent back.';

  @override
  String get questF008Obj =>
      'Protect the elvish deserter from whoever is hunting her and learn what she knows.';

  @override
  String get questF009Title => 'The Beast of the Thicket';

  @override
  String get questF009Desc =>
      'Livestock at the Thornveil\'s edge is being torn apart by something massive. Claw marks are as wide as a man\'s arm. Farmer Gregor says the druids won\'t help â€” they claim the beast is \"the forest\'s answer.\"';

  @override
  String get questF009Obj =>
      'Track and slay the beast lurking in the deepest thicket of the outer Thornveil.';

  @override
  String get questF010Title => 'Spider Nests in the Canopy';

  @override
  String get questF010Desc =>
      'Giant webs span the canopy for miles along the trade road. Cocooned travelers dangle from the branches, some still alive. Ranger Elara says the spiders appeared after the fey pacts weakened.';

  @override
  String get questF010Obj =>
      'Burn the spider nests in the forest canopy and save any survivors.';

  @override
  String get questF011Title => 'The Verdant Terror';

  @override
  String get questF011Desc =>
      'A monstrous plant creature has taken root near the Thornwall border. Druid Theron believes it grew from Hollow-corrupted soil â€” the same blight the Vaelithi refuse to acknowledge.';

  @override
  String get questF011Obj =>
      'Cut through the overgrowth and destroy the monstrous plant creature threatening the Thornwall border.';

  @override
  String get questF012Title => 'Crown of Thorns';

  @override
  String get questF012Desc =>
      'A corrupted treant has claimed the deepest grove outside the Thornwall. The Circle of Thorn druids say a dark crystal was driven into its trunk â€” the same kind of corruption that has been spreading from the Hollows.';

  @override
  String get questF012Obj =>
      'Venture into the ancient grove and destroy the corruption inside the treant.';

  @override
  String get questF013Title => 'The Pyre Cult\'s Altar';

  @override
  String get questF013Desc =>
      'A fanatical fire cult has been building pyre-altars between the trees of the outer Thornveil. Spy Maren says they worship something in the Hollows below and plan to burn a path through the Thornwall to reach Vaelith.';

  @override
  String get questF013Obj =>
      'Infiltrate the fire cult\'s forest encampment and bring down their leader.';

  @override
  String get questF014Title => 'The Dragon\'s Hunting Ground';

  @override
  String get questF014Desc =>
      'A young dragon has claimed the mortal forest as its hunting territory. Charred clearings mark its kills. The Vaelithi have closed the Thornwall tighter â€” they do not intend to help.';

  @override
  String get questF014Obj =>
      'Track the dragon to its forest lair and put an end to its reign.';

  @override
  String get questF015Title => 'Orc War-Camp';

  @override
  String get questF015Desc =>
      'An orc warband has built a fortified camp in the mortal forest. They raid surrounding villages nightly. Commander Hale has militia support but not enough to assault the camp alone.';

  @override
  String get questF015Obj =>
      'Assault the orc war-camp in the forest and break their siege on the villages.';

  @override
  String get questF016Title => 'The Thornwall Breach';

  @override
  String get questF016Desc =>
      'Something has torn a hole in the Thornwall â€” the living barrier that seals Vaelith from the mortal world. Fey creatures and worse are pouring through the gap. The elves have not responded. The druids are overwhelmed.';

  @override
  String get questF016Obj =>
      'Reach the Thornwall breach and seal it before the gap widens further.';

  @override
  String get questF017Title => 'The Pale Root Incursion';

  @override
  String get questF017Desc =>
      'Pale Root agents â€” elves from Vaelith\'s rebel faction â€” have crossed the Thornwall and are sabotaging Circle of Thorn shrines. Druid Theron believes they want the barrier to fall so Vaelith can expand by force.';

  @override
  String get questF017Obj =>
      'Track and stop the Pale Root agents before they destroy the last druidic shrine.';

  @override
  String get questF018Title => 'Shadows in the Canopy';

  @override
  String get questF018Desc =>
      'An eternal twilight has fallen over a vast section of the Thornveil. Shadow creatures roam the darkened canopy. Sun Priestess Amara says the Sunstone â€” an ancient relic that anchors daylight to the forest â€” has been stolen.';

  @override
  String get questF018Obj =>
      'Find the Sunstone and restore daylight to the darkened forest.';

  @override
  String get questF019Title => 'The Blight Beneath Vaelith';

  @override
  String get questF019Desc =>
      'A Vaelithi exile has crossed the Thornwall with desperate news: the blight in the root-hollows beneath Vaelith is spreading faster than the elves can contain it. The Verdant Court refuses to ask mortals for help â€” but this exile is asking anyway.';

  @override
  String get questF019Obj =>
      'Cross through a gap in the Thornwall and descend into the root-hollows to find the source of the blight.';

  @override
  String get questF020Title => 'The God-Eater';

  @override
  String get questF020Desc =>
      'Shrines throughout the Thornveil have gone silent. A creature feeding on divine essence stalks between the trees â€” the druids call it a God-Eater, something that shouldn\'t exist outside the Hollow.';

  @override
  String get questF020Obj =>
      'Hunt the God-Eater through the sacred groves before it devours the last shrine.';

  @override
  String get questF021Title => 'The World Tree Burns';

  @override
  String get questF021Desc =>
      'Demonic fire engulfs the World Tree. The Vaelithi have opened the Thornwall for the first time in three centuries â€” not to help, but to evacuate. If the World Tree falls, the forest and everything beneath it dies.';

  @override
  String get questF021Obj =>
      'Ascend the burning World Tree and extinguish the infernal flame at its crown.';

  @override
  String get questF022Title => 'The Verdant Court\'s Judgment';

  @override
  String get questF022Desc =>
      'Queen Seylith the Undying has summoned the player to Vaelith â€” the first mortal invited through the Thornwall in three centuries. She does not explain why. The Pale Root faction sees this as an opportunity.';

  @override
  String get questF022Obj =>
      'Enter Vaelith, survive the Verdant Court\'s trial, and learn what the elves have been hiding.';

  @override
  String get questF023Title => 'Death\'s Grove';

  @override
  String get questF023Desc =>
      'Death â€” the eldest god â€” has planted a black sapling in the heart of the Thornveil. All who pass it wither to bone. The World Tree shudders. The Vaelithi have gone silent. The druids say this is the end of the forest.';

  @override
  String get questF023Obj =>
      'Uproot Death\'s sapling from the forest clearing and survive what guards it.';

  @override
  String get questC001Title => 'Cellar Dwellers';

  @override
  String get questC001Desc =>
      'Scratching echoes from the cave beneath the old inn. Something has moved up from the Hollows into the upper tunnels.';

  @override
  String get questC001Obj =>
      'Clear the creatures infesting the cellar cave beneath the old inn.';

  @override
  String get questC002Title => 'The Glowing Depths';

  @override
  String get questC002Desc =>
      'A faint green glow pulses from a Hollows entrance. The village well water has started tasting of rot â€” Herbalist Nessa says the Deep Mother\'s fungal growths are spreading upward.';

  @override
  String get questC002Obj =>
      'Descend into the Hollows and purge whatever contaminates the underground water source.';

  @override
  String get questC003Title => 'Bat Swarm in the Hollows';

  @override
  String get questC003Desc =>
      'Enormous cave bats have been erupting from a Hollows entrance at dusk, terrorizing shepherds on the surface.';

  @override
  String get questC003Obj =>
      'Enter the upper Hollows and deal with the monstrous bat colony.';

  @override
  String get questC004Title => 'Smuggler\'s Tunnel';

  @override
  String get questC004Desc =>
      'Illegal goods are flowing through a hidden passage in the upper Hollows. Smugglers use the worked-stone tunnels that miners abandoned after hearing strange sounds deeper in.';

  @override
  String get questC004Obj =>
      'Infiltrate the smuggler\'s Hollows tunnel and intercept their operation.';

  @override
  String get questC005Title => 'The Collapsed Shaft';

  @override
  String get questC005Desc =>
      'Miners broke through into something ancient â€” a passage carved by no human hand. Strange sounds echo from beyond the collapse, and the stone feels warm to the touch.';

  @override
  String get questC005Obj =>
      'Explore the collapsed mine shaft and rescue the miners trapped in the older tunnels.';

  @override
  String get questC006Title => 'The Lurker Below';

  @override
  String get questC006Desc =>
      'Something massive lives in the underground lake where the Hollows meet the water table. Ripples appear where nothing should stir.';

  @override
  String get questC006Obj =>
      'Lure out and slay the creature dwelling in the Hollows\' underground lake.';

  @override
  String get questC007Title => 'The First Trap';

  @override
  String get questC007Desc =>
      'Miners opened a new tunnel and three of them vanished. A survivor crawled back babbling about floor tiles that \"screamed fire\" â€” warden-craft traps from the deep Hollows, far above where they should be.';

  @override
  String get questC007Obj =>
      'Navigate the trapped passage in the mid-Hollows and retrieve the missing miners.';

  @override
  String get questC008Title => 'The Mushroom Plague';

  @override
  String get questC008Desc =>
      'Bioluminescent fungal growths â€” the Deep Mother\'s breath â€” are spreading rapidly through the mid-Hollows. Miners who inhale the spores go mad, clawing at the walls and speaking in voices that aren\'t theirs.';

  @override
  String get questC008Obj =>
      'Reach the source of the mushroom plague deep in the Hollows and destroy it.';

  @override
  String get questC009Title => 'The Flesh Market';

  @override
  String get questC009Desc =>
      'People vanish from the villages above. A black market operates in the lawless upper Hollows, dealing in living bodies. The smugglers have gone deeper than anyone should.';

  @override
  String get questC009Obj =>
      'Infiltrate the underground flesh market in the Hollows and free the prisoners.';

  @override
  String get questC010Title => 'The Underground Arena';

  @override
  String get questC010Desc =>
      'The Hollows fighting pits have a new champion â€” one that never bleeds. Its skin is pale and translucent, and it fights with a stillness that terrifies the crowd. Some say it crawled up from the deep.';

  @override
  String get questC010Obj =>
      'Challenge the undefeated pit champion and uncover the secret of its victories.';

  @override
  String get questC011Title => 'The Bone Chime Corridor';

  @override
  String get questC011Desc =>
      'Explorers found a passage deeper in the Hollows strung with chimes made of bone. The first man who touched one is dead â€” the chime exploded into razor shards. This is warden-craft. Something is sealed beyond.';

  @override
  String get questC011Obj =>
      'Navigate the bone-chime corridor in the deep Hollows without triggering the traps and discover what lies beyond.';

  @override
  String get questC012Title => 'First Contact';

  @override
  String get questC012Desc =>
      'A mining team broke through into a chamber where the stone was carved with symbols no one recognizes. Three of the miners were found dead â€” killed silently, precisely, without struggle. Something is down here. Something that does not want to be found.';

  @override
  String get questC012Obj =>
      'Descend into the newly breached chamber and discover what killed the miners.';

  @override
  String get questC013Title => 'Prison of Echoes';

  @override
  String get questC013Desc =>
      'An ancient prison in the mid-Hollows has begun to crack. The ward-stones are failing â€” Foreman Brick says the stone screams at night. Whatever is sealed inside grows stronger by the hour.';

  @override
  String get questC013Obj =>
      'Navigate the crumbling prison in the Hollows and reseal the binding before what\'s inside breaks free.';

  @override
  String get questC014Title => 'The Lava Veins';

  @override
  String get questC014Desc =>
      'Magma is rising through tunnels that should be cold stone. Fire elementals crawl from the molten rock â€” the Deep Mother\'s blood, boiling up from below. The Ossborn have retreated from this section entirely.';

  @override
  String get questC014Obj =>
      'Reach the volcanic vent in the deep Hollows and seal the breach before the magma reaches the upper tunnels.';

  @override
  String get questC015Title => 'The Drake\'s Hoard';

  @override
  String get questC015Desc =>
      'A cave drake has burrowed into the mid-Hollows and made its nest on a vein of raw ore. Its breath heats the tunnels to scorching. The Ossborn ignore it â€” it hasn\'t breached any seals. The miners cannot.';

  @override
  String get questC015Obj =>
      'Enter the cave drake\'s lair in the Hollows and deal with it.';

  @override
  String get questC016Title => 'The Ward-Stone Thieves';

  @override
  String get questC016Desc =>
      'Someone is stealing ward-stones from the deep Hollows and selling them as magical curiosities on the surface. The Ossborn have responded â€” four traders are dead, killed silently in their beds. The stealing hasn\'t stopped.';

  @override
  String get questC016Obj =>
      'Find the ward-stone thieves in the Hollows before the Ossborn kill everyone involved.';

  @override
  String get questC017Title => 'The Rite of Grafting';

  @override
  String get questC017Desc =>
      'An Ossborn elder has broken from the others. She speaks â€” haltingly, in a voice layered with dead wardens\' echoes â€” and asks for help. The bones in her body are rejecting the graft. If she dies, the knowledge of three wardens dies with her.';

  @override
  String get questC017Obj =>
      'Escort the failing Ossborn elder to the deep forge where the Forge Spirit can stabilize her grafts.';

  @override
  String get questC018Title => 'The Void Rift';

  @override
  String get questC018Desc =>
      'Reality is tearing apart in the deepest known chamber of the Hollows. Void creatures pour through the crack â€” the same Hollow-corruption the global texts describe. Even the Ossborn are retreating.';

  @override
  String get questC018Obj =>
      'Close the Void Rift in the deepest Hollows before the breach becomes permanent.';

  @override
  String get questC019Title => 'The Titan\'s Chains';

  @override
  String get questC019Desc =>
      'A titan sealed during the Sundering has nearly broken free. Its tremors collapse tunnels for miles. The Ossborn carry the memory of how the chains were originally forged â€” but the knowledge is fragmentary, spread across three elders who no longer agree on the sequence.';

  @override
  String get questC019Obj =>
      'Work with the Forge Spirit and the Ossborn to reforge the titan\'s chains before it wakes.';

  @override
  String get questC020Title => 'The Mad Ossborn';

  @override
  String get questC020Desc =>
      'An Ossborn elder has gone mad â€” the weight of a dozen dead wardens\' memories has crushed his own identity. He believes he IS the warden whose bones he carries, and he is systematically deactivating the seals that warden originally set, claiming they are \"his to release.\"';

  @override
  String get questC020Obj =>
      'Track the mad Ossborn through the deep Hollows and stop him before he opens the sealed prisons.';

  @override
  String get questC021Title => 'The Devourer\'s Prison';

  @override
  String get questC021Desc =>
      'The Devourer â€” something that predates even the gods â€” stirs in its vault beneath the deepest Hollows. The Ossborn have gathered in numbers not seen in centuries. The Forge Spirit has gone silent. The ward-stones are failing.';

  @override
  String get questC021Obj =>
      'Gather the Sealing Stones and reinforce the Devourer\'s prison before it breaks free.';

  @override
  String get questC022Title => 'The Demon Gate';

  @override
  String get questC022Desc =>
      'A gate to the abyss has opened at the Hollows\' lowest point â€” a seal that has held since the Sundering, now cracked. Demonic legions amass on the other side. The Ossborn carrying the warden-memory for this seal are dead.';

  @override
  String get questC022Obj =>
      'Descend to the bottom of the Hollows and seal the Demon Gate before the invasion begins.';

  @override
  String get questC023Title => 'The Serpent of the Deep';

  @override
  String get questC023Desc =>
      'A colossal serpent coils through the Hollows\' deepest flooded tunnels. Its venom dissolves ward-stone â€” the Ossborn have lost three sealed passages to its acidic wake. If it reaches the binding circle, the Devourer\'s prison fails.';

  @override
  String get questC023Obj =>
      'Track the great serpent through the flooded tunnels and slay it before it destroys the bindings.';

  @override
  String get questC024Title => 'The Heart of the Mountain';

  @override
  String get questC024Desc =>
      'Something ancient beats at the mountain\'s core â€” the Heart of the Mountain, a living organ of stone and magma that may be the Deep Mother\'s own heart, still beating after the Sundering. It is waking. The Ossborn kneel before it. The Forge Spirit says it must be silenced. The Ossborn say it must not.';

  @override
  String get questC024Obj =>
      'Reach the Heart of the Mountain at the deepest point of the Hollows and decide its fate.';

  @override
  String get questR001Title => 'Haunted Barrow';

  @override
  String get questR001Desc =>
      'Lights flicker inside the oldest barrow of the Valdris ruins at night. The dead do not rest easy in these crumbling halls â€” and Scholar Veyra says the walls hum if you press your ear to them.';

  @override
  String get questR001Obj =>
      'Enter the barrow beneath the Valdris ruins and lay the restless dead to rest.';

  @override
  String get questR002Title => 'Vermin in the Undercroft';

  @override
  String get questR002Desc =>
      'Giant rats have overrun the undercroft beneath the Valdris ruins. They\'ve grown bold enough to attack the researchers camped at the entrance.';

  @override
  String get questR002Obj =>
      'Descend into the ruin undercroft and deal with the rat infestation.';

  @override
  String get questR003Title => 'The Whispering Idol';

  @override
  String get questR003Desc =>
      'A stone idol was unearthed in the Valdris ruins. Anyone who touches it hears whispers in a language they almost understand. Scholar Veyra says the idol predates Valdris itself â€” it shouldn\'t be here.';

  @override
  String get questR003Obj =>
      'Find and destroy the cursed idol hidden in the Valdris ruins.';

  @override
  String get questR004Title => 'Tomb Robbers';

  @override
  String get questR004Desc =>
      'Grave robbers are prying open sealed chambers in the Valdris ruins. Historian Korval is furious â€” every broken seal releases more of whatever lingers here.';

  @override
  String get questR004Obj =>
      'Stop the tomb robbers before they break the wrong seal in the Valdris ruins.';

  @override
  String get questR005Title => 'The Restless Dead';

  @override
  String get questR005Desc =>
      'Skeletons patrol the Valdris ruin corridors at night. They wear armor from the kingdom that once stood here â€” armor that should have rusted to nothing centuries ago.';

  @override
  String get questR005Obj =>
      'Find the source of the undead patrols in the Valdris corridors and put them to rest.';

  @override
  String get questR006Title => 'The Sealed Library';

  @override
  String get questR006Desc =>
      'A sealed library was found in the Valdris ruins. Scholar Veyra says the door responds to touch â€” it\'s warm, and the metal vibrates as if something on the other side is breathing.';

  @override
  String get questR006Obj =>
      'Enter the sealed library in the Valdris ruins and retrieve what lies within.';

  @override
  String get questR007Title => 'The Whispering Halls';

  @override
  String get questR007Desc =>
      'The lower ruins hum with a low, maddening drone. Those who linger too long begin speaking in dead languages. Historian Korval attributes it to \"residual enchantment.\" Scholar Veyra is less certain.';

  @override
  String get questR007Obj =>
      'Find what creates the maddening hum in the lower Valdris halls and silence it.';

  @override
  String get questR008Title => 'The Grey Sentinels';

  @override
  String get questR008Desc =>
      'Explorers report seeing tall, gaunt figures standing motionless in the lower corridors â€” ash-grey skin, angular bones, hollow eyes. They do not respond to speech. They attack without warning when approached too closely.';

  @override
  String get questR008Obj =>
      'Investigate the mysterious grey figures in the deeper Valdris ruins.';

  @override
  String get questR009Title => 'The Cursed Vault';

  @override
  String get questR009Desc =>
      'A vault deeper in the Valdris ruins is leaking dark energy. People nearby sleepwalk toward the entrance. Historian Korval says the artifacts inside predate Valdris by centuries â€” which should be impossible.';

  @override
  String get questR009Obj =>
      'Enter the Valdris vault and destroy the cursed artifact collection.';

  @override
  String get questR010Title => 'Plague Crypt';

  @override
  String get questR010Desc =>
      'An undead caravan emerged from beneath the Valdris ruins. The plague they carry turns flesh grey â€” the same grey as the silent sentinels deeper inside.';

  @override
  String get questR010Obj =>
      'Descend into the crypt beneath the ruins and seal the source of the walking plague.';

  @override
  String get questR011Title => 'The Shadow Stalker';

  @override
  String get questR011Desc =>
      'A shadowy assassin stalks a merchant who ventured into the Valdris ruins looking for treasure. Three guards are dead â€” killed by something that moved through the walls as if they weren\'t there.';

  @override
  String get questR011Obj =>
      'Track the shadowy assassin through the ruins and protect the merchant.';

  @override
  String get questR012Title => 'The Looping Corridor';

  @override
  String get questR012Desc =>
      'Scholar Veyra sent a team into the mid-depth ruins. They returned three days later â€” insisting only an hour had passed. They say every corridor led back to the same room. One of them drew a map. The map is impossible.';

  @override
  String get questR012Obj =>
      'Navigate the looping corridors in the deep Valdris ruins and find out what\'s causing the spatial distortion.';

  @override
  String get questR013Title => 'The Tithebound Awakening';

  @override
  String get questR013Desc =>
      'A Tithebound was captured alive â€” a first. It sits in a cage at Korval\'s camp, rocking and murmuring broken phrases. Then it said something clearly: \"They are coming back.\" It hasn\'t spoken since.';

  @override
  String get questR013Obj =>
      'Descend into the deeper ruins and investigate what the captured Tithebound meant.';

  @override
  String get questR014Title => 'The Sunken Sanctum';

  @override
  String get questR014Desc =>
      'A temple lies half-submerged in the flooded lower ruins. Valdris builders shouldn\'t have built this deep â€” unless the ruins go further down than anyone believed.';

  @override
  String get questR014Obj =>
      'Dive into the flooded sanctum and stop whatever is stirring below.';

  @override
  String get questR015Title => 'The Cult of Valdris';

  @override
  String get questR015Desc =>
      'A cult has formed among the ruin-obsessed â€” mortals who believe Valdris was taken, not destroyed, and that they can follow it wherever it went. They\'ve consecrated a blood altar in the throne room.';

  @override
  String get questR015Obj =>
      'Destroy the cult\'s blood altar in the Valdris throne room before their ritual completes.';

  @override
  String get questR016Title => 'The Wrong Room';

  @override
  String get questR016Desc =>
      'A mapping team found a room that shouldn\'t exist. It\'s not on any plan. The door was sealed from the inside. When they opened it, one of them said, \"This room is bigger than the building it\'s in.\" He was right.';

  @override
  String get questR016Obj =>
      'Enter the impossible room in the Valdris ruins and survive what\'s inside.';

  @override
  String get questR017Title => 'The Tithebound War';

  @override
  String get questR017Desc =>
      'The Tithebound have split into two factions in the deep ruins. One group attacks anyone who enters. The other stands at the edges, watching, making no move to stop them â€” or help. Something has changed below.';

  @override
  String get questR017Obj =>
      'Navigate the Tithebound conflict in the deep ruins and reach the lowest accessible chamber.';

  @override
  String get questR018Title => 'The Sound Returns';

  @override
  String get questR018Desc =>
      'The hum that scholars dismissed has become a sound â€” a layered, shifting noise that strips the edges off your thoughts. Scholar Veyra can no longer enter the deep ruins. She says she forgot her own name for three seconds and that was enough.';

  @override
  String get questR018Obj =>
      'Descend into the deepest ruins where the sound is loudest and discover its source.';

  @override
  String get questR019Title => 'The Elder\'s Confession';

  @override
  String get questR019Desc =>
      'A Tithebound elder â€” more aware than any encountered before â€” has approached the surface camp. She speaks in halting but complete sentences. She says she remembers what happened to her people. She wants to tell someone before the Choir takes it.';

  @override
  String get questR019Obj =>
      'Protect the aware Tithebound elder while she speaks, and learn what happened to her species.';

  @override
  String get questR020Title => 'Through the Choir';

  @override
  String get questR020Desc =>
      'The Severance wound is open. The Nameless Choir fills the deepest chamber â€” a sound that strips everything. Beyond it, through the tear, towers of pale stone are visible. Valdris was not destroyed. It was taken. The player can see it.';

  @override
  String get questR020Obj =>
      'Pass through the Nameless Choir and enter the folded dimension of Valdris.';

  @override
  String get questR021Title => 'The Living Kingdom';

  @override
  String get questR021Desc =>
      'Valdris is alive. The streets are paved in dark glass that reflects no stars. Citizens move in slow processions, smiling too wide, repeating the same words. The architecture bends at the edges. Something is deeply, fundamentally wrong.';

  @override
  String get questR021Obj =>
      'Explore the folded kingdom of Valdris and understand what happened to its people.';

  @override
  String get questR022Title => 'The Throne That Knows Your Name';

  @override
  String get questR022Desc =>
      'The throne room is always visible from any street, as though the city curves inward toward it. Something sits on the throne. It wears a crown. It is not a king. It knows the player\'s name.';

  @override
  String get questR022Obj =>
      'Enter the throne room of Valdris and confront whatever rules the folded kingdom.';

  @override
  String get questR023Title => 'The Severance Undone';

  @override
  String get questR023Desc =>
      'The throne entity has been defied. The kingdom trembles. The Choir screams. The dimensional wound that created this prison is destabilizing â€” if it collapses with the player inside, they are trapped in Valdris forever. But if the wound can be forced wider, Valdris might return to the real world.';

  @override
  String get questR023Obj =>
      'Escape the folding Valdris dimension before the Severance wound closes â€” or find a way to break the Severance entirely.';

  @override
  String get itemWpn001Name => 'Sundering Shard Knife';

  @override
  String get itemWpn001Desc =>
      'A crude knife chipped from stone that fell during the war of the Firstborn Gods. It hums faintly when held â€” an echo of the blow that cracked reality itself.';

  @override
  String get itemWpn002Name => 'Thornveil Stalker Bow';

  @override
  String get itemWpn002Desc =>
      'A short hunting bow of living thornwood, its limbs still bearing green buds that never bloom. The Thornveil gives these willingly to mortal stalkers it tolerates â€” the string hums a note only forest creatures hear, and they run.';

  @override
  String get itemWpn003Name => 'Hollows Warden Blade';

  @override
  String get itemWpn003Desc =>
      'A short, broad-bladed sword of dark iron etched with glowing warden runes along the fuller. Carried by miners who work the upper Hollows â€” where the things in the dark require more than a lantern.';

  @override
  String get itemWpn004Name => 'Tithebound Ritual Blade';

  @override
  String get itemWpn004Desc =>
      'A long, thin blade of grey metal carried by the Tithebound â€” the ash-skinned wardens who patrol the Valdris ruins in loops they cannot explain. This one was dropped by a sentinel who stopped mid-patrol and simply forgot how to move.';

  @override
  String get itemWpn005Name => 'Hollow-Touched Falchion';

  @override
  String get itemWpn005Desc =>
      'A blade left too long near a wound in reality where the Hollow seeps through. The void-stuff has eaten into the steel, making it lighter and impossibly sharp â€” but the metal crumbles a little more each day.';

  @override
  String get itemWpn006Name => 'Pale Root Whisper Crossbow';

  @override
  String get itemWpn006Desc =>
      'A compact crossbow of bleached white wood, its rail inlaid with crushed petals that deaden all sound. The Pale Root use these from the High Canopy â€” two lords fell before anyone heard the bolt. The Verdant Court pretends these don\'t exist.';

  @override
  String get itemWpn007Name => 'Warden-Craft Halberd';

  @override
  String get itemWpn007Desc =>
      'Forged using techniques inherited through the Rite of Grafting â€” patterns no living mind devised, hammered from memory stored in dead wardens\' bones. The rune sequence along the shaft matches a binding prayer that sealed something in the mid-depths.';

  @override
  String get itemWpn008Name => 'Morvaine\'s Staff-Blade';

  @override
  String get itemWpn008Desc =>
      'The walking staff of Morvaine, the apprentice whose pursuit of lichdom shattered Valdris from within â€” or so the histories claim. The wood is petrified, and the crystal at its head shows a kingdom that looks nothing like ruins.';

  @override
  String get itemWpn009Name => 'Death\'s Tithe';

  @override
  String get itemWpn009Desc =>
      'A scythe that belonged to no reaper â€” it simply appeared where Death had recently passed. Death is eldest of the three surviving gods, walks both worlds freely, and answers to no prayer. This blade carries that same cold indifference.';

  @override
  String get itemWpn010Name => 'Sinew of the World Tree';

  @override
  String get itemWpn010Desc =>
      'A longbow strung with root-fiber from the World Tree itself â€” the miles-high titan whose roots pierce the underworld. Arrows fired from this bow bend toward living things, as if the Tree still hungers for what grows beyond its reach.';

  @override
  String get itemWpn011Name => 'Forge Spirit\'s Greathammer';

  @override
  String get itemWpn011Desc =>
      'A hammer that radiates heat from the core of the world. The Forge Spirit who tends the ancient bindings used this to repair ward-stones â€” and to crush anything that emerged when those repairs came too late.';

  @override
  String get itemWpn012Name => 'Severance Edge';

  @override
  String get itemWpn012Desc =>
      'A blade forged from the dark glass that paves the streets of Valdris â€” not the ruins, but the living kingdom folded into a dimension that should not exist. The glass reflects corridors you\'ve never walked and a sky with no stars.';

  @override
  String get itemWpn013Name => 'Seylith\'s Bloom Arc';

  @override
  String get itemWpn013Desc =>
      'A ceremonial bow grown in the World Tree\'s root-hollows during the Bloom Rite â€” the trial that determines Vaelithi succession. Its string sprouts thorn-arrows on its own. Queen Seylith drew this arc for four centuries. It has never missed.';

  @override
  String get itemWpn014Name => 'Deep Mother\'s Fang';

  @override
  String get itemWpn014Desc =>
      'A stalactite ripped from directly above the Heart of the Mountain â€” the living organ of stone and magma that beats in the deepest Hollows. Some scholars believe it is the Deep Mother\'s own heart. This fang still drips with molten spite.';

  @override
  String get itemWpn015Name => 'Azrathar\'s Covenant Blade';

  @override
  String get itemWpn015Desc =>
      'The weapon the demon Azrathar once offered Valdris in exchange for passage into the mortal world. The histories blame Azrathar for the kingdom\'s fall â€” but the blade was never used. Whatever destroyed Valdris was not a demon. It was something far worse.';

  @override
  String get itemArm001Name => 'Sundering-Cloth Wrap';

  @override
  String get itemArm001Desc =>
      'Strips of ancient fabric salvaged from a battlefield older than any kingdom. The cloth was woven before the Firstborn Gods warred â€” when creation was still one piece.';

  @override
  String get itemArm002Name => 'Smuggler\'s Tunnel Leathers';

  @override
  String get itemArm002Desc =>
      'Hardened leather stitched by the smugglers who run contraband through the upper Hollows by torchlight. Stained with bioluminescent fungal residue that never quite washes out.';

  @override
  String get itemArm003Name => 'Thornveil Bark Cuirass';

  @override
  String get itemArm003Desc =>
      'A chestplate shaped from fallen bark of the Thornveil. The forest gave this wood freely â€” a tree struck by lightning, already dead. Even in death, the bark resists rot with stubborn, living defiance.';

  @override
  String get itemArm004Name => 'Valdris Grave-Scavenger\'s Coat';

  @override
  String get itemArm004Desc =>
      'Patched leather worn by those foolish enough to loot the upper ruins of Valdris. Every pocket rattles with pilfered trinkets that whisper when the wind is wrong. Scholar Veyra condemns scavengers. They wear her disapproval like a badge.';

  @override
  String get itemArm005Name => 'Hollow-Scarred Plate';

  @override
  String get itemArm005Desc =>
      'Steel plate warped by proximity to the Hollow â€” the void-corruption that seeps through reality\'s cracks. The metal bends at angles that shouldn\'t hold, yet the armor is lighter and harder than any forge could make it.';

  @override
  String get itemArm006Name => 'Ossborn Grafted Shell';

  @override
  String get itemArm006Desc =>
      'Armor assembled from shed bone-plates of the Ossborn â€” the eyeless monks who carry dead wardens\' memories in their fused skeletons. Each plate hums with a different frequency, as if remembering a different voice.';

  @override
  String get itemArm007Name => 'Verdant Court Ceremonial Mail';

  @override
  String get itemArm007Desc =>
      'Chainmail of green-gold alloy, each ring shaped like a tiny leaf. Worn by the twelve High Canopy lords of Vaelith\'s Verdant Court â€” before two were assassinated by the Pale Root. This set belonged to one of the fallen.';

  @override
  String get itemArm008Name => 'Tithebound Sentinel Plate';

  @override
  String get itemArm008Desc =>
      'Chitinous armor grown â€” not forged â€” by Tithebound sentinels in the deep ruins. Made from their own shed skin, layered over centuries. Ash-grey and warm to the touch, as if something inside it still remembers being alive.';

  @override
  String get itemArm009Name => 'Radiant One\'s Blessed Mail';

  @override
  String get itemArm009Desc =>
      'Plate armor blessed by clerics who maintain the binding seals in the Radiant One\'s name. The god who forged the sun declared dominion over the surface world â€” this armor carries that decree hammered into every rivet.';

  @override
  String get itemArm010Name => 'Deep Mother\'s Carapace';

  @override
  String get itemArm010Desc =>
      'Chitin harvested from creatures born too close to the Heart of the Mountain. The Deep Mother burrowed into the earth\'s core and claimed all beneath stone â€” these shells carry her territorial fury, hardening under pressure.';

  @override
  String get itemArm011Name => 'Thornwall Living Armor';

  @override
  String get itemArm011Desc =>
      'A suit grown from a fragment of the Thornwall itself â€” the enchanted barrier of briar that seals Vaelith from the mortal world. Humans who cross the Thornwall don\'t come back. This armor was pried from the wall\'s edge, and it has not stopped growing.';

  @override
  String get itemArm012Name => 'Death\'s Walking Shroud';

  @override
  String get itemArm012Desc =>
      'A cloak of absolute black that weighs nothing and fits everyone. Death is eldest of the three surviving gods and walks both worlds freely. This shroud once draped something that stood in Death\'s shadow â€” and the shadow never quite left it.';

  @override
  String get itemArm013Name => 'Court Arcanist\'s Vestments';

  @override
  String get itemArm013Desc =>
      'Robes worn by the Valdris Court Arcanists who cast the Severance â€” the spell that pulled an entire kingdom into a folded dimension. The Arcanists were consumed by their own working. The robes remember the incantation in every threaded sigil.';

  @override
  String get itemArm014Name => 'Titan\'s Binding Plate';

  @override
  String get itemArm014Desc =>
      'Armor forged from the actual chains that bound a titan in the mid-depths during the Sundering. The titan still slumbers beneath â€” and the chains still tighten when something stirs in its prison. Wearing them, you feel the weight of holding a god in place.';

  @override
  String get itemArm015Name => 'Netherveil of the Folded Kingdom';

  @override
  String get itemArm015Desc =>
      'A garment woven from the membrane between the mortal world and the folded dimension where Valdris still lives. It smells of still air from a kingdom where time loops, and bends around the wearer like reality bending to avoid the Severance.';

  @override
  String get itemAcc001Name => 'Cracked Binding Seal';

  @override
  String get itemAcc001Desc =>
      'A palm-sized fragment of a ward-stone, worn as a pendant. Clerics maintain these seals across the world â€” this one cracked, and whatever it held is long gone. A reminder that the world needs holding together, one broken seal at a time.';

  @override
  String get itemAcc002Name => 'Fey Pact Charm';

  @override
  String get itemAcc002Desc =>
      'A twisted knot of silver wire and dried petals, given by Fey Court sprites in exchange for a secret. The pact is simple: carry this, and the old trickster-spirits will only trick you gently. When the pacts fray, even this won\'t help.';

  @override
  String get itemAcc003Name => 'Bioluminescent Fungal Lantern';

  @override
  String get itemAcc003Desc =>
      'A caged cluster of cavern fungi that glow with the Deep Mother\'s ambient influence. Miners prize these over torches â€” they never go out, and they pulse faster when something watches from the dark.';

  @override
  String get itemAcc004Name => 'Korval\'s Research Pendant';

  @override
  String get itemAcc004Desc =>
      'A brass locket containing a fragment of Historian Korval\'s notes on Valdris architecture â€” specifically, his confused observations about rooms that seem larger inside than out. He attributed it to residual enchantment. He was wrong.';

  @override
  String get itemAcc005Name => 'Hollow Void Amulet';

  @override
  String get itemAcc005Desc =>
      'A gemstone with a hole in it â€” not a physical hole, but an absence where the Hollow has unmade the crystal\'s center. Light bends around the gap. Staring into it too long makes you forget what you were looking at.';

  @override
  String get itemAcc006Name => 'Circle of Thorn Signet';

  @override
  String get itemAcc006Desc =>
      'A ring of living wood worn by druids of the Circle of Thorn â€” mediators between mortal and Fey. Their numbers thin each decade. This signet still channels the old pacts, though fewer answer its call.';

  @override
  String get itemAcc007Name => 'Ossborn Memory Fragment';

  @override
  String get itemAcc007Desc =>
      'A bone shard from an Ossborn elder â€” a piece that fell during the Rite of Grafting. It carries a single warden memory: the exact rune sequence that held a specific prison sealed for three thousand years. The sequence plays in your dreams.';

  @override
  String get itemAcc008Name => 'Tithebound Resonance Stone';

  @override
  String get itemAcc008Desc =>
      'A smooth grey stone that vibrates at the same frequency as the Tithebound\'s hollow eyes. When held, you hear what they hear â€” a faint sound from deep beneath the ruins that shapes itself into what you most desire. It is not a calling. It is bait.';

  @override
  String get itemAcc009Name => 'Death\'s Walking Band';

  @override
  String get itemAcc009Desc =>
      'A ring of bone-white metal, featureless and cold. Death walks both worlds freely and answers to no prayer â€” but Death notices those who carry artifacts of the divine. This ring ensures you are noticed in return.';

  @override
  String get itemAcc010Name => 'Seylith\'s Moonstone Brooch';

  @override
  String get itemAcc010Desc =>
      'A brooch of elvish craft set with a moonstone that holds four centuries of light â€” one for each year of Queen Seylith the Undying\'s reign. The Vaelithi do not part with these. That it exists outside the Thornwall means someone defected or died.';

  @override
  String get itemAcc011Name => 'Warden Bone Bracers';

  @override
  String get itemAcc011Desc =>
      'Bracers carved from the bones of ancient wardens â€” the originals who chained the titans and sealed the demons. The Ossborn grafted these bones into themselves. These bracers carry what the Ossborn chose not to keep.';

  @override
  String get itemAcc012Name => 'Choir Silence Pendant';

  @override
  String get itemAcc012Desc =>
      'A pendant that generates a sphere of absolute silence â€” crafted by a Tithebound elder who retained enough awareness to understand what the Nameless Choir does. The silence is not peaceful. It is the absence of the sound that unmakes you.';

  @override
  String get itemAcc013Name => 'Firstborn\'s Tear';

  @override
  String get itemAcc013Desc =>
      'A crystallized tear shed during the Sundering â€” from which of the three surviving gods, no scholar agrees. The Radiant One wept for the sun. The Deep Mother wept for the earth. Death, eldest of all, does not weep â€” but something fell from its face.';

  @override
  String get itemAcc014Name => 'Crown of the Bloom Rite';

  @override
  String get itemAcc014Desc =>
      'The crown formed in the root-hollows of the World Tree during the Bloom Rite â€” Vaelithi succession\'s ultimate trial. Candidates descend and return changed, or don\'t return at all. This crown was found beside someone who didn\'t return.';

  @override
  String get itemAcc015Name => 'Eye of the Deep Mother';

  @override
  String get itemAcc015Desc =>
      'Not a metaphor. Not a gem shaped like an eye. An eye â€” milky white, the size of a fist, warm and wet, and it blinks. Pulled from a crevice near the Heart of the Mountain where the rock thinned enough to see through. The Deep Mother sees through it still.';

  @override
  String get itemRel001Name => 'Fractured Binding Seal';

  @override
  String get itemRel001Desc =>
      'A broken ward-stone â€” one of thousands scattered across the crumbling ancient prisons. Druids tend the World Tree\'s roots, clerics maintain the binding seals, and heroes carry blades into the dark. You carry a piece of what they\'re all fighting to hold together.';

  @override
  String get itemRel002Name => 'Hollows Bioluminescent Spore';

  @override
  String get itemRel002Desc =>
      'A living fungal cluster from the upper Hollows, pulsing with the Deep Mother\'s ambient influence. It lights dark places with a sickly green glow and recoils from heat, as if the Deep Mother disapproves of the Radiant One\'s fire.';

  @override
  String get itemRel003Name => 'Scholar Veyra\'s Field Journal';

  @override
  String get itemRel003Desc =>
      'A battered journal belonging to Scholar Veyra, who catalogs the upper Valdris ruins alongside Historian Korval. Her notes are meticulous but confused â€” measurements that contradict themselves, sketches of rooms larger inside than out. She calls it \"residual enchantment.\" She is wrong.';

  @override
  String get itemRel004Name => 'Thornveil Wisp Lantern';

  @override
  String get itemRel004Desc =>
      'A cage of living vines containing a captured wisp from the Fey Courts. The old pacts that bind the fey predate even the elves â€” this wisp agreed to serve in exchange for protection from what happens when those pacts finally break.';

  @override
  String get itemRel005Name => 'Shard of the Hollow';

  @override
  String get itemRel005Desc =>
      'A crystallized fragment of the Hollow itself â€” void-stuff hardened into something almost physical. It unmakes what it touches slowly: wood greys, metal corrodes, skin numbs. The Hollow spreads not as invasion but as erosion. This is what erosion looks like held in your hand.';

  @override
  String get itemRel006Name => 'Forge Spirit\'s Ember';

  @override
  String get itemRel006Desc =>
      'A fragment of living flame from the Forge Spirit â€” the ancient entity that tends the weakening bindings in the Hollows. It considers the Ossborn tools, not allies. It considers you less than that. But the ember burns, and it burns true.';

  @override
  String get itemRel007Name => 'Valdris Ward-Stone Shard';

  @override
  String get itemRel007Desc =>
      'A fragment of the protective wards that once shielded Valdris â€” before Morvaine shattered them from within, or Azrathar breached them from without. The histories disagree. This shard hums at a frequency that makes your teeth ache, and sometimes shows a kingdom that looks nothing like ruins.';

  @override
  String get itemRel008Name => 'World Tree Root Heart';

  @override
  String get itemRel008Desc =>
      'A gnarled heartwood node from deep within the World Tree\'s root system â€” where the roots pierce the underworld. Something stirs in those root-hollows that the Vaelithi will not name: a blight that withers their trees from the inside. This heart still pulses with life, but the edges are grey.';

  @override
  String get itemRel009Name => 'Devourer\'s Prison Keystone';

  @override
  String get itemRel009Desc =>
      'A keystone from the deepest vault in the Hollows â€” the prison that holds the Devourer, something that predates even the gods. The Forge Spirit tends this binding above all others. The Ossborn refuse to approach it. The keystone is warm, and if you press your ear to it, you hear breathing.';

  @override
  String get itemRel010Name => 'Titan\'s Shackle Link';

  @override
  String get itemRel010Desc =>
      'A single link from the chains forged during the Sundering to bind the titans in their prisons. The chains were made to hold gods. A single link still carries that purpose â€” when held, you feel the weight of holding something immeasurably powerful in place.';

  @override
  String get itemRel011Name => 'Nameless Choir Echo';

  @override
  String get itemRel011Desc =>
      'A tuning fork that vibrates at the exact frequency of the Nameless Choir â€” the sound a dimensional wound makes when it refuses to close. Prolonged exposure strips memory: first small things, then larger ones. Holding this, you hear the first note. It sounds like something you forgot.';

  @override
  String get itemRel012Name => 'Heart of the Verdant Court';

  @override
  String get itemRel012Desc =>
      'The emerald core of Vaelith\'s governance â€” a living gemstone grown within the throne of the Verdant Court over centuries. It contains the accumulated will of every Vaelithi monarch who passed the Bloom Rite. Queen Seylith sat beside it for four hundred years. The gem remembers every one of them.';

  @override
  String get itemRel013Name => 'Deep Mother\'s Heartstone';

  @override
  String get itemRel013Desc =>
      'A fragment of the Heart of the Mountain itself â€” the living organ of stone and magma that scholars believe is the Deep Mother\'s own heart, still beating after the Sundering. It pulses in your hand with a rhythm slower than any mortal heart, and the ground trembles in sympathy.';

  @override
  String get itemRel014Name => 'Severance Catalyst';

  @override
  String get itemRel014Desc =>
      'The crystalline focus through which the Valdris Court Arcanists channeled the Severance â€” the spell that folded an entire kingdom into a dimension that should not exist. The Arcanists were consumed. The catalyst survived. It still wants to fold things.';

  @override
  String get itemRel015Name => 'The Sundering Wound';

  @override
  String get itemRel015Desc =>
      'Not an object â€” a scar in reality itself, contained in a sphere of binding glass made by the first wardens. Inside, you see the original wound: the crack the Firstborn Gods tore in creation. It has never healed. The Hollow seeps from wounds like this. Carrying it is carrying the reason the world is broken.';

  @override
  String get itemSpl001Name => 'Shard Bolt';

  @override
  String get itemSpl001Desc =>
      'A jagged bolt of crystallised Sundering energy hurled at the enemy. The fragments hum with the echo of the blow that cracked reality â€” even a sliver carries that ancient violence.';

  @override
  String get itemSpl002Name => 'Thornlash';

  @override
  String get itemSpl002Desc =>
      'The Thornveil responds to those who speak its old names. This invocation calls a whip of living thorns from the forest floor to lash and bind enemies in barbed vine.';

  @override
  String get itemSpl003Name => 'Stoneskin';

  @override
  String get itemSpl003Desc =>
      'The deep stone of the Hollows remembers the Warden-craft â€” the old art of binding earth to flesh. This ward coats the caster in a shell of living rock that turns aside blades.';

  @override
  String get itemSpl004Name => 'Arcane Missile';

  @override
  String get itemSpl004Desc =>
      'The Court Arcanists of Valdris refined raw mana into precise bolts that track their targets through corridors and around cover. The spell is elementary by their standards â€” and devastating by anyone else\'s.';

  @override
  String get itemSpl005Name => 'Hollow Drain';

  @override
  String get itemSpl005Desc =>
      'A forbidden technique that channels the Hollow\'s hunger. The caster opens a hairline crack between worlds and the void drinks from the enemy\'s life force, returning a fraction to the caster.';

  @override
  String get itemSpl006Name => 'Verdant Bloom';

  @override
  String get itemSpl006Desc =>
      'A prayer to the World Tree channelled through living wood. Golden-green light blooms around the caster, knitting wounds and purging corruption. The Vaelithi healers called this the Firstbloom â€” the simplest gift the Tree still gives.';

  @override
  String get itemSpl007Name => 'Molten Surge';

  @override
  String get itemSpl007Desc =>
      'Deep beneath the Hollows, the Forge Spirit still hammers at its eternal anvil. This invocation borrows a breath of its fire â€” liquid stone erupts from the ground in a searing wave that melts armour and flesh alike.';

  @override
  String get itemSpl008Name => 'Soul Tithe';

  @override
  String get itemSpl008Desc =>
      'The Tithebound of Valdris paid their debts in soul-stuff, not coin. This grim enchantment exacts the same price from an enemy â€” tearing away a sliver of their essence to fuel the caster\'s next strike.';

  @override
  String get itemSpl009Name => 'Radiant Judgement';

  @override
  String get itemSpl009Desc =>
      'A column of searing light called down in the Radiant One\'s name. The Firstborn God of light may be diminished, but this echo of divine wrath still burns â€” especially against creatures of the Hollow.';

  @override
  String get itemSpl010Name => 'Fey Mirage';

  @override
  String get itemSpl010Desc =>
      'The Fey Courts deal in glamour and misdirection. This charm wraps the caster in layers of illusory doubles that confuse enemies, causing their attacks to strike at phantoms while the real caster moves unseen.';

  @override
  String get itemSpl011Name => 'Earthen Maw';

  @override
  String get itemSpl011Desc =>
      'The Deep Mother\'s hunger given form. The ground splits open into a jagged maw of stone teeth that clamps shut on the enemy, crushing and trapping them in the earth\'s grip.';

  @override
  String get itemSpl012Name => 'Chorus of Unmaking';

  @override
  String get itemSpl012Desc =>
      'The Nameless Choir sang the walls of Valdris into existence â€” and their imprisoned echoes still know the counter-melody. This spell unleashes a discordant wail that unravels enchantments, wards, and the will to fight.';

  @override
  String get itemSpl013Name => 'Death\'s Whisper';

  @override
  String get itemSpl013Desc =>
      'Death in this world is not an ending but a patient collector. This forbidden invocation borrows Death\'s voice for a single syllable â€” a whisper that makes mortal things remember they are mortal. The strong can resist. The weak simply stop.';

  @override
  String get itemSpl014Name => 'Severance Rift';

  @override
  String get itemSpl014Desc =>
      'A controlled fragment of the Severance â€” the spell that folded the Valdris kingdom into a dimension that should not exist. This tears a brief rift in space that swallows attacks and redirects them back at the attacker.';

  @override
  String get itemSpl015Name => 'Worldbreak';

  @override
  String get itemSpl015Desc =>
      'The ultimate expression of Sundering magic — a spell that reopens the original wound between worlds for a heartbeat. Reality screams. Everything in the blast radius is touched by the raw stuff of creation and un-creation simultaneously. Nothing survives unchanged.';

  @override
  String get itemWpn001Effect =>
      'Shard Resonance: deals 3% bonus damage near areas corrupted by the Hollow.';

  @override
  String get itemWpn002Effect => '+10% damage against Fey creatures.';

  @override
  String get itemWpn003Effect =>
      'Warden Rune: reveals hidden passages in the Hollows. +5% damage to mineral-based enemies.';

  @override
  String get itemWpn004Effect =>
      'Hollow Strike: 15% chance attacks ignore target\'s defense entirely.';

  @override
  String get itemWpn005Effect =>
      'Void Edge: attacks deal 10% bonus damage. The Hollow hungers through the blade.';

  @override
  String get itemWpn006Effect =>
      'Assassination: critical hits deal 35% bonus damage. +12% crit chance from stealth.';

  @override
  String get itemWpn007Effect =>
      'Binding Strike: 20% chance to immobilize target for 1 turn. Deals double damage to escaped prisoners of the deep.';

  @override
  String get itemWpn008Effect =>
      'Lich\'s Ambition: spell attacks deal 15% bonus damage. On kill, restore 5% max HP.';

  @override
  String get itemWpn009Effect =>
      'Inevitability: ignores 15% of target\'s DEF and magic resistance. Cannot be disarmed.';

  @override
  String get itemWpn010Effect =>
      'Rootbound: arrows entangle targets (−15% AGI for 2 turns). Regenerate 2% HP per turn in forest areas.';

  @override
  String get itemWpn011Effect =>
      'Seal Breaker: attacks shatter magical barriers. +25% damage against bound or sealed enemies.';

  @override
  String get itemWpn012Effect =>
      'Dimensional Cut: ignores 25% DEF and magic resistance. 10% chance to tear reality, dealing AoE damage.';

  @override
  String get itemWpn013Effect =>
      'Undying Bloom: the bow regenerates arrows between battles. Crits cause roots to erupt from wounds, dealing 40% bonus damage over 3 turns.';

  @override
  String get itemWpn014Effect =>
      'Magma Vein: attacks deal 20% bonus fire damage and inflict Burn. Costs 2% max HP per hit, but burn damage heals the wielder.';

  @override
  String get itemWpn015Effect =>
      'Covenant: ignores ALL enemy resistances. On kill, absorb the target\'s strongest stat permanently (+1, stacks up to 20).';

  @override
  String get itemArm001Effect =>
      'Ancestral Thread: reduces physical damage taken by 2%.';

  @override
  String get itemArm002Effect =>
      'Cave Runner: +5% evasion in underground areas. Faintly glows in darkness.';

  @override
  String get itemArm003Effect =>
      'Forest\'s Memory: reduces damage from plant and fey creatures by 10%.';

  @override
  String get itemArm004Effect =>
      'Scavenger\'s Luck: +8% gold drop rate. 5% chance to resist curse effects from Valdris relics.';

  @override
  String get itemArm005Effect =>
      'Void Warp: 8% chance to deflect attacks through micro-rifts. Takes 5% extra damage from holy sources.';

  @override
  String get itemArm006Effect =>
      'Grafted Memory: immune to confusion effects. 10% chance to reflexively dodge (inherited warden instinct).';

  @override
  String get itemArm007Effect =>
      'Courtly Grace: immune to Fear effects. +10% magic resistance. Elvish light reveals hidden foes.';

  @override
  String get itemArm008Effect =>
      'Hollow Warden: +15% damage resistance while standing ground. Incoming attacks echo faintly, warning of ambush.';

  @override
  String get itemArm009Effect =>
      'Solar Ward: immune to darkness and shadow effects. Regenerate 2% HP per turn in daylight or surface areas.';

  @override
  String get itemArm010Effect =>
      'Pressure Skin: DEF increases by 1% for each 10% HP lost. Immune to fire and magma damage.';

  @override
  String get itemArm011Effect =>
      'Living Barrier: regenerate 3% max HP per turn. Thorns deal 8% recoil damage to melee attackers.';

  @override
  String get itemArm012Effect =>
      'Death\'s Passage: ignore environmental hazards. 15% chance to negate fatal damage and survive with 1 HP.';

  @override
  String get itemArm013Effect =>
      'Severance Echo: all spell damage reduced by 20%. Once per battle, cast a ward that absorbs damage equal to 30% max HP.';

  @override
  String get itemArm014Effect =>
      'Unyielding Chains: immune to knockback, stun, and forced movement. Reduces all incoming damage by 15%.';

  @override
  String get itemArm015Effect =>
      'Dimensional Phase: 20% chance to phase through attacks entirely. Immune to all status effects. Stats grow by 1% per turn in combat (max 15%).';

  @override
  String get itemAcc001Effect => 'Faint Ward: restores 1% HP per turn.';

  @override
  String get itemAcc002Effect =>
      'Fey Favor: +5% evasion against magical attacks. Wisps ignore the wearer.';

  @override
  String get itemAcc003Effect =>
      'Deep Light: reveals hidden enemies and traps. +5% evasion in underground areas.';

  @override
  String get itemAcc004Effect =>
      'Scholar\'s Eye: reveals enemy weaknesses at battle start. +10% XP from Ruins encounters.';

  @override
  String get itemAcc005Effect =>
      'Void Gaze: spell damage +10%. 5% chance attacks erase one enemy buff.';

  @override
  String get itemAcc006Effect =>
      'Druid\'s Pact: healing effects increased by 15%. Fey creatures will not attack first.';

  @override
  String get itemAcc007Effect =>
      'Inherited Instinct: always act first in the opening turn of battle. +15% evasion against traps.';

  @override
  String get itemAcc008Effect =>
      'Resonance: spell damage +15%. Grants brief precognition — see enemy attacks before they land.';

  @override
  String get itemAcc009Effect =>
      'Death Marked: +10% to all damage. Immune to instant-death and charm effects.';

  @override
  String get itemAcc010Effect =>
      'Undying Light: regenerate 3% HP per turn. +20% resistance to dark and corruption effects.';

  @override
  String get itemAcc011Effect =>
      'Warden\'s Reflex: +18% evasion. Automatically counter-attack once per turn when dodging.';

  @override
  String get itemAcc012Effect =>
      'Silent Ward: immune to all sound-based and mind-affecting attacks. Once per battle, negate a killing blow and heal 25% HP.';

  @override
  String get itemAcc013Effect =>
      'Divine Sorrow: all damage +15%. Healing spells cost 40% less. Immune to divine-type damage.';

  @override
  String get itemAcc014Effect =>
      'Root-Hollow Crown: all stats +8%. Below 25% HP, regenerate 5% max HP per turn and gain +20% to all damage.';

  @override
  String get itemAcc015Effect =>
      'All-Seeing: all enemy stats visible. Spells ignore magic resistance. +20% crit chance. The Deep Mother watches through you.';

  @override
  String get itemRel001Effect =>
      'Faint Resonance: 5% chance to gain an extra action per turn.';

  @override
  String get itemRel002Effect =>
      'Deep Glow: reveals enemy positions in darkness. +5% magic damage in underground areas.';

  @override
  String get itemRel003Effect =>
      'Scholar\'s Record: +10% XP from all encounters. Reveals hidden lore in Ruins areas.';

  @override
  String get itemRel004Effect =>
      'Wisp Light: reveals hidden paths and treasures. +10% evasion against ambushes.';

  @override
  String get itemRel005Effect =>
      'Void Erosion: attacks permanently reduce enemy DEF by 3% per hit (stacks up to 5x). Wielder takes 1% max HP per turn.';

  @override
  String get itemRel006Effect =>
      'Spirit Flame: every 3rd attack deals 50% bonus fire damage. Immune to burn effects.';

  @override
  String get itemRel007Effect =>
      'Ward Echo: reflects 15% of magic damage back at caster. +10% resistance to curse effects.';

  @override
  String get itemRel008Effect =>
      'Root Bond: regenerate 4% HP per turn. Nature spells deal 25% bonus damage. Warns of corruption nearby.';

  @override
  String get itemRel009Effect =>
      'Abyssal Lock: +15% damage against ancient and divine enemies. Grants a shield (10% max HP) at the start of each battle.';

  @override
  String get itemRel010Effect =>
      'Titan\'s Weight: immune to knockback and displacement. +15% damage to targets larger than the wielder.';

  @override
  String get itemRel011Effect =>
      'Memory Thief: spells have 10% chance to strip one random buff from the target. Dark spells deal 30% bonus damage. Costs 1% max HP per spell cast.';

  @override
  String get itemRel012Effect =>
      'Verdant Will: regenerate 5% max HP per turn. Nature and healing effects deal double. Immune to corruption and decay.';

  @override
  String get itemRel013Effect =>
      'Earthen Fury: once per battle, call a tremor dealing AoE damage equal to 300% MAG. Enemies hit lose 20% DEF for 3 turns. Immune to earth and magma damage.';

  @override
  String get itemRel014Effect =>
      'Severance: attacks permanently reduce enemy stats by 5% (stacks). Spells ignore shields. Once per battle, banish one enemy ability.';

  @override
  String get itemRel015Effect =>
      'World Wound: all damage +20%. Once per battle, open a rift that erases one enemy ability permanently. Immune to all debuffs. Nearby enemies lose 3% stats per turn.';

  @override
  String get itemSpl001Effect =>
      'Hurls a Sundering shard dealing damage based on MAG.';

  @override
  String get itemSpl002Effect =>
      'Lashes a target with thorned vine, dealing MAG damage and slowing them for 2 turns.';

  @override
  String get itemSpl003Effect =>
      'Grants a stone shield absorbing damage equal to 50% MAG for 3 turns.';

  @override
  String get itemSpl004Effect =>
      'Fires 3 homing bolts of arcane energy, each dealing MAG-scaled damage.';

  @override
  String get itemSpl005Effect =>
      'Drains enemy HP equal to 80% MAG and heals caster for half the amount.';

  @override
  String get itemSpl006Effect =>
      'Heals caster for 120% MAG and removes one negative status effect.';

  @override
  String get itemSpl007Effect =>
      'Erupts magma dealing heavy MAG damage and reducing enemy DEF by 15% for 3 turns.';

  @override
  String get itemSpl008Effect =>
      'Steals enemy ATK/MAG by 10% for 3 turns and boosts caster\'s next attack by 30%.';

  @override
  String get itemSpl009Effect =>
      'Holy damage dealing 150% MAG. Deals double damage to Hollow-corrupted enemies.';

  @override
  String get itemSpl010Effect =>
      'Creates illusions granting 50% evasion for 3 turns. Next attack from stealth deals +40% damage.';

  @override
  String get itemSpl011Effect =>
      'Traps an enemy for 2 turns dealing 100% MAG each turn. Trapped enemies cannot act.';

  @override
  String get itemSpl012Effect =>
      'AoE sonic damage dealing 120% MAG. Dispels all enemy buffs and silences for 2 turns.';

  @override
  String get itemSpl013Effect =>
      'Chance to instantly kill enemies below 25% HP. Otherwise deals 200% MAG damage.';

  @override
  String get itemSpl014Effect =>
      'Opens a dimensional rift absorbing all damage for 2 turns, then detonates for 250% absorbed damage.';

  @override
  String get itemSpl015Effect =>
      'Cataclysmic damage dealing 400% MAG to all enemies. Reduces all enemy stats by 20% permanently. Once per battle.';
}
