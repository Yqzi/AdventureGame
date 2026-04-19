import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'QUESTBORNE'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'POWERED BY AI STORY ENGINE'**
  String get appTagline;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get buttonClose;

  /// No description provided for @startEnter.
  ///
  /// In en, this message translates to:
  /// **'ENTER'**
  String get startEnter;

  /// No description provided for @startPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get startPremium;

  /// No description provided for @startSettings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get startSettings;

  /// No description provided for @startVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 0.0.1 • Shadow-Crest Protocol'**
  String get startVersion;

  /// No description provided for @continueWithProvider.
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String continueWithProvider(String provider);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'ENTER THE\nREALM'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you wish to proceed'**
  String get loginSubtitle;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginGoogle;

  /// No description provided for @loginApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginApple;

  /// No description provided for @errorSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get errorSomethingWentWrong;

  /// No description provided for @labelObjective.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get labelObjective;

  /// No description provided for @labelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get labelLocation;

  /// No description provided for @labelReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get labelReward;

  /// No description provided for @labelKeyFigures.
  ///
  /// In en, this message translates to:
  /// **'Key Figures'**
  String get labelKeyFigures;

  /// No description provided for @guildTitle.
  ///
  /// In en, this message translates to:
  /// **'The Notice Board'**
  String get guildTitle;

  /// No description provided for @guildSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quest Progression'**
  String get guildSubtitle;

  /// No description provided for @guildObjective.
  ///
  /// In en, this message translates to:
  /// **'OBJECTIVE'**
  String get guildObjective;

  /// No description provided for @guildKeyFigures.
  ///
  /// In en, this message translates to:
  /// **'KEY FIGURES'**
  String get guildKeyFigures;

  /// No description provided for @guildReward.
  ///
  /// In en, this message translates to:
  /// **'REWARD'**
  String get guildReward;

  /// No description provided for @guildResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get guildResume;

  /// No description provided for @guildAcceptQuest.
  ///
  /// In en, this message translates to:
  /// **'Accept Quest'**
  String get guildAcceptQuest;

  /// No description provided for @guildDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get guildDone;

  /// No description provided for @guildCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get guildCompleted;

  /// No description provided for @guildSideBounties.
  ///
  /// In en, this message translates to:
  /// **'SIDE BOUNTIES'**
  String get guildSideBounties;

  /// No description provided for @guildMainQuests.
  ///
  /// In en, this message translates to:
  /// **'Main Quests'**
  String get guildMainQuests;

  /// No description provided for @guildRepeatableQuests.
  ///
  /// In en, this message translates to:
  /// **'Repeatable Quests'**
  String get guildRepeatableQuests;

  /// No description provided for @guildLevelAbbr.
  ///
  /// In en, this message translates to:
  /// **'LV {level}'**
  String guildLevelAbbr(int level);

  /// No description provided for @guildGoldDisplay.
  ///
  /// In en, this message translates to:
  /// **'{amount} Gold'**
  String guildGoldDisplay(int amount);

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'INVENTORY'**
  String get inventoryTitle;

  /// No description provided for @inventoryUnequipped.
  ///
  /// In en, this message translates to:
  /// **'UNEQUIPPED'**
  String get inventoryUnequipped;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'THE MARKET'**
  String get shopTitle;

  /// No description provided for @shopBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get shopBuy;

  /// No description provided for @shopSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get shopSold;

  /// No description provided for @shopSoldLabel.
  ///
  /// In en, this message translates to:
  /// **'SOLD'**
  String get shopSoldLabel;

  /// No description provided for @shopNotEnoughGold.
  ///
  /// In en, this message translates to:
  /// **'Not enough gold'**
  String get shopNotEnoughGold;

  /// No description provided for @shopPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased {item}!'**
  String shopPurchased(String item);

  /// No description provided for @shopClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get shopClose;

  /// No description provided for @shopMerchantQuote.
  ///
  /// In en, this message translates to:
  /// **'\"Choose wisely, traveler. My wares cost more than just gold...\"'**
  String get shopMerchantQuote;

  /// No description provided for @shopGold.
  ///
  /// In en, this message translates to:
  /// **'{amount} Gold'**
  String shopGold(int amount);

  /// No description provided for @shopMerchantWares.
  ///
  /// In en, this message translates to:
  /// **'Merchant\'s Wares'**
  String get shopMerchantWares;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get settingsProfile;

  /// No description provided for @settingsCharacterName.
  ///
  /// In en, this message translates to:
  /// **'Character Name'**
  String get settingsCharacterName;

  /// No description provided for @settingsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get settingsEmail;

  /// No description provided for @settingsAiSafety.
  ///
  /// In en, this message translates to:
  /// **'AI SAFETY'**
  String get settingsAiSafety;

  /// No description provided for @settingsHateSpeech.
  ///
  /// In en, this message translates to:
  /// **'Hate Speech'**
  String get settingsHateSpeech;

  /// No description provided for @settingsHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment'**
  String get settingsHarassment;

  /// No description provided for @settingsDangerousContent.
  ///
  /// In en, this message translates to:
  /// **'Dangerous Content'**
  String get settingsDangerousContent;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get settingsGeneral;

  /// No description provided for @settingsPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get settingsPremium;

  /// No description provided for @settingsPremiumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View subscription options'**
  String get settingsPremiumSubtitle;

  /// No description provided for @settingsRestoreSubscription.
  ///
  /// In en, this message translates to:
  /// **'Restore Subscription'**
  String get settingsRestoreSubscription;

  /// No description provided for @settingsRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Already subscribed? Restore it here'**
  String get settingsRestoreSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the app language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get settingsAccount;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get settingsDeleteSubtitle;

  /// No description provided for @settingsLegal.
  ///
  /// In en, this message translates to:
  /// **'LEGAL'**
  String get settingsLegal;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get settingsPrivacySubtitle;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// No description provided for @settingsTermsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rules and conditions of use'**
  String get settingsTermsSubtitle;

  /// No description provided for @settingsChangeName.
  ///
  /// In en, this message translates to:
  /// **'CHANGE NAME'**
  String get settingsChangeName;

  /// No description provided for @settingsChangeNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a new name for your character'**
  String get settingsChangeNameDesc;

  /// No description provided for @settingsEnterNewName.
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get settingsEnterNewName;

  /// No description provided for @settingsNameReserved.
  ///
  /// In en, this message translates to:
  /// **'\"Adventurer\" is reserved — pick something unique!'**
  String get settingsNameReserved;

  /// No description provided for @settingsNameChanged.
  ///
  /// In en, this message translates to:
  /// **'Name changed to {name}'**
  String settingsNameChanged(String name);

  /// No description provided for @settingsChooseFilterLevel.
  ///
  /// In en, this message translates to:
  /// **'Choose a filtering level'**
  String get settingsChooseFilterLevel;

  /// No description provided for @settingsCheckingSubscription.
  ///
  /// In en, this message translates to:
  /// **'Checking for existing subscription...'**
  String get settingsCheckingSubscription;

  /// No description provided for @settingsSubscriptionRestored.
  ///
  /// In en, this message translates to:
  /// **'Subscription restored! ({tier})'**
  String settingsSubscriptionRestored(String tier);

  /// No description provided for @settingsNoSubscription.
  ///
  /// In en, this message translates to:
  /// **'No active subscription found.'**
  String get settingsNoSubscription;

  /// No description provided for @settingsRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore subscription. Try again later.'**
  String get settingsRestoreFailed;

  /// No description provided for @settingsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteTitle;

  /// No description provided for @settingsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all saved data. Any active subscription will also be cancelled. This action cannot be undone.'**
  String get settingsDeleteMessage;

  /// No description provided for @settingsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDeleteConfirm;

  /// No description provided for @settingsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again later.'**
  String get settingsDeleteFailed;

  /// No description provided for @safetyLevelLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get safetyLevelLow;

  /// No description provided for @safetyLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get safetyLevelMedium;

  /// No description provided for @safetyLevelHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get safetyLevelHigh;

  /// No description provided for @safetyDescLow.
  ///
  /// In en, this message translates to:
  /// **'Permissive — suited for dark fantasy'**
  String get safetyDescLow;

  /// No description provided for @safetyDescMedium.
  ///
  /// In en, this message translates to:
  /// **'Balanced filtering'**
  String get safetyDescMedium;

  /// No description provided for @safetyDescHigh.
  ///
  /// In en, this message translates to:
  /// **'Strict content filtering'**
  String get safetyDescHigh;

  /// No description provided for @subscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'PLANS'**
  String get subscriptionPlans;

  /// No description provided for @subscriptionCredits.
  ///
  /// In en, this message translates to:
  /// **'credits'**
  String get subscriptionCredits;

  /// No description provided for @subscriptionCreditsDaily.
  ///
  /// In en, this message translates to:
  /// **'credits (+{daily} daily)'**
  String subscriptionCreditsDaily(int daily);

  /// No description provided for @subscriptionCreditsRemaining.
  ///
  /// In en, this message translates to:
  /// **'credits remaining of {max}'**
  String subscriptionCreditsRemaining(int max);

  /// No description provided for @subscriptionCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get subscriptionCurrent;

  /// No description provided for @subscriptionUpgradedTo.
  ///
  /// In en, this message translates to:
  /// **'Upgraded to {tier}!'**
  String subscriptionUpgradedTo(String tier);

  /// No description provided for @subscriptionManageGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscriptions on Google Play'**
  String get subscriptionManageGooglePlay;

  /// No description provided for @subscriptionMemory.
  ///
  /// In en, this message translates to:
  /// **'{tag} memory'**
  String subscriptionMemory(String tag);

  /// No description provided for @subscriptionResets.
  ///
  /// In en, this message translates to:
  /// **'Resets {date}'**
  String subscriptionResets(String date);

  /// No description provided for @subscriptionCreditsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} credits'**
  String subscriptionCreditsCount(int count);

  /// No description provided for @subscriptionCreditsDailyFeature.
  ///
  /// In en, this message translates to:
  /// **'{max} + {daily}/day credits'**
  String subscriptionCreditsDailyFeature(int max, int daily);

  /// No description provided for @expeditionTitle.
  ///
  /// In en, this message translates to:
  /// **'Expedition'**
  String get expeditionTitle;

  /// No description provided for @expeditionOpenWorlds.
  ///
  /// In en, this message translates to:
  /// **'Open Worlds'**
  String get expeditionOpenWorlds;

  /// No description provided for @expeditionEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter Expedition'**
  String get expeditionEnter;

  /// No description provided for @expeditionEnterShort.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get expeditionEnterShort;

  /// No description provided for @expeditionFreeRoam.
  ///
  /// In en, this message translates to:
  /// **'Free Roam'**
  String get expeditionFreeRoam;

  /// No description provided for @expeditionFreeRoamDesc.
  ///
  /// In en, this message translates to:
  /// **'No set objective — explore freely and see what awaits.'**
  String get expeditionFreeRoamDesc;

  /// No description provided for @mapDarkwoodForest.
  ///
  /// In en, this message translates to:
  /// **'The Darkwood Forest'**
  String get mapDarkwoodForest;

  /// No description provided for @mapDarkwoodForestDesc.
  ///
  /// In en, this message translates to:
  /// **'An ancient woodland shrouded in perpetual twilight. Twisted oaks and gnarled roots hide forgotten paths, strange creatures, and whispers of old magic between the moss-covered stones.'**
  String get mapDarkwoodForestDesc;

  /// No description provided for @mapSunkenCaverns.
  ///
  /// In en, this message translates to:
  /// **'The Sunken Caverns'**
  String get mapSunkenCaverns;

  /// No description provided for @mapSunkenCavernsDesc.
  ///
  /// In en, this message translates to:
  /// **'A vast subterranean network of dripping tunnels and glowing crystal chambers. The air is thick with the scent of damp earth, and unknown things skitter just beyond the torchlight.'**
  String get mapSunkenCavernsDesc;

  /// No description provided for @mapAshenRuins.
  ///
  /// In en, this message translates to:
  /// **'The Ashen Ruins'**
  String get mapAshenRuins;

  /// No description provided for @mapAshenRuinsDesc.
  ///
  /// In en, this message translates to:
  /// **'Crumbling remnants of a once-great civilization, half-swallowed by sand and creeping vines. Collapsed archways lead to forgotten vaults, and the ghosts of the old world linger in every shadow.'**
  String get mapAshenRuinsDesc;

  /// No description provided for @navWorld.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get navWorld;

  /// No description provided for @navQuest.
  ///
  /// In en, this message translates to:
  /// **'Quest'**
  String get navQuest;

  /// No description provided for @navMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMarket;

  /// No description provided for @navHero.
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get navHero;

  /// No description provided for @nameDialogAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Questborne'**
  String get nameDialogAppTitle;

  /// No description provided for @nameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'WHO ARE YOU?'**
  String get nameDialogTitle;

  /// No description provided for @nameDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Speak your name, and let it begin.'**
  String get nameDialogSubtitle;

  /// No description provided for @nameDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Speak your name...'**
  String get nameDialogHint;

  /// No description provided for @nameDialogErrorEmpty.
  ///
  /// In en, this message translates to:
  /// **'The Questborne must have a name.'**
  String get nameDialogErrorEmpty;

  /// No description provided for @nameDialogErrorShort.
  ///
  /// In en, this message translates to:
  /// **'Too short. Even a wanderer has two letters.'**
  String get nameDialogErrorShort;

  /// No description provided for @nameDialogErrorLong.
  ///
  /// In en, this message translates to:
  /// **'Keep it under 20 characters.'**
  String get nameDialogErrorLong;

  /// No description provided for @nameDialogErrorReserved.
  ///
  /// In en, this message translates to:
  /// **'That name is not allowed'**
  String get nameDialogErrorReserved;

  /// No description provided for @lootObtained.
  ///
  /// In en, this message translates to:
  /// **'OBTAINED'**
  String get lootObtained;

  /// No description provided for @lootGoldGained.
  ///
  /// In en, this message translates to:
  /// **'+{amount} Gold'**
  String lootGoldGained(int amount);

  /// No description provided for @lootXpGained.
  ///
  /// In en, this message translates to:
  /// **'+{amount} XP'**
  String lootXpGained(int amount);

  /// No description provided for @lootHpRestored.
  ///
  /// In en, this message translates to:
  /// **'+{amount} HP Restored'**
  String lootHpRestored(int amount);

  /// No description provided for @lootManaRestored.
  ///
  /// In en, this message translates to:
  /// **'+{amount} Mana Restored'**
  String lootManaRestored(int amount);

  /// No description provided for @lootGoldLost.
  ///
  /// In en, this message translates to:
  /// **'-{amount} Gold'**
  String lootGoldLost(int amount);

  /// No description provided for @lootDamage.
  ///
  /// In en, this message translates to:
  /// **'-{amount} HP'**
  String lootDamage(int amount);

  /// No description provided for @lootLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get lootLevelUp;

  /// No description provided for @lootLevelUpMultiple.
  ///
  /// In en, this message translates to:
  /// **'Level Up! (+{levels} levels)'**
  String lootLevelUpMultiple(int levels);

  /// No description provided for @diceCheck.
  ///
  /// In en, this message translates to:
  /// **'{action} CHECK'**
  String diceCheck(String action);

  /// No description provided for @questCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'QUEST COMPLETE'**
  String get questCompleteTitle;

  /// No description provided for @questCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your tale has been written.'**
  String get questCompleteSubtitle;

  /// No description provided for @questCompleteRewards.
  ///
  /// In en, this message translates to:
  /// **'REWARDS'**
  String get questCompleteRewards;

  /// No description provided for @questCompleteReturn.
  ///
  /// In en, this message translates to:
  /// **'RETURN TO GUILD'**
  String get questCompleteReturn;

  /// No description provided for @questCompleteGold.
  ///
  /// In en, this message translates to:
  /// **'{amount} Gold'**
  String questCompleteGold(int amount);

  /// No description provided for @questCompleteXp.
  ///
  /// In en, this message translates to:
  /// **'{amount} XP'**
  String questCompleteXp(int amount);

  /// No description provided for @questFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'QUEST FAILED'**
  String get questFailedTitle;

  /// No description provided for @questFailedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The darkness claims another soul.'**
  String get questFailedSubtitle;

  /// No description provided for @questFailedReset.
  ///
  /// In en, this message translates to:
  /// **'Your quest set progress has been reset.'**
  String get questFailedReset;

  /// No description provided for @questFailedReturn.
  ///
  /// In en, this message translates to:
  /// **'RETURN TO GUILD'**
  String get questFailedReturn;

  /// No description provided for @spellManaCost.
  ///
  /// In en, this message translates to:
  /// **'{cost} MP'**
  String spellManaCost(int cost);

  /// No description provided for @itemTypeWeapon.
  ///
  /// In en, this message translates to:
  /// **'WEAPON'**
  String get itemTypeWeapon;

  /// No description provided for @itemTypeArmor.
  ///
  /// In en, this message translates to:
  /// **'ARMOR'**
  String get itemTypeArmor;

  /// No description provided for @itemTypeAccessory.
  ///
  /// In en, this message translates to:
  /// **'ACCESSORY'**
  String get itemTypeAccessory;

  /// No description provided for @itemTypeRelic.
  ///
  /// In en, this message translates to:
  /// **'RELIC'**
  String get itemTypeRelic;

  /// No description provided for @itemTypeSpell.
  ///
  /// In en, this message translates to:
  /// **'SPELL'**
  String get itemTypeSpell;

  /// No description provided for @rarityCommon.
  ///
  /// In en, this message translates to:
  /// **'COMMON'**
  String get rarityCommon;

  /// No description provided for @rarityRare.
  ///
  /// In en, this message translates to:
  /// **'RARE'**
  String get rarityRare;

  /// No description provided for @rarityEpic.
  ///
  /// In en, this message translates to:
  /// **'EPIC'**
  String get rarityEpic;

  /// No description provided for @rarityMythic.
  ///
  /// In en, this message translates to:
  /// **'MYTHIC'**
  String get rarityMythic;

  /// No description provided for @actionMeleeAttack.
  ///
  /// In en, this message translates to:
  /// **'Melee Attack'**
  String get actionMeleeAttack;

  /// No description provided for @actionRangedAttack.
  ///
  /// In en, this message translates to:
  /// **'Ranged Attack'**
  String get actionRangedAttack;

  /// No description provided for @actionOffensiveMagic.
  ///
  /// In en, this message translates to:
  /// **'Offensive Magic'**
  String get actionOffensiveMagic;

  /// No description provided for @actionDefensiveMagic.
  ///
  /// In en, this message translates to:
  /// **'Defensive Magic'**
  String get actionDefensiveMagic;

  /// No description provided for @actionStealth.
  ///
  /// In en, this message translates to:
  /// **'Stealth'**
  String get actionStealth;

  /// No description provided for @actionAssassination.
  ///
  /// In en, this message translates to:
  /// **'Assassination'**
  String get actionAssassination;

  /// No description provided for @actionDodge.
  ///
  /// In en, this message translates to:
  /// **'Dodge'**
  String get actionDodge;

  /// No description provided for @actionParry.
  ///
  /// In en, this message translates to:
  /// **'Parry'**
  String get actionParry;

  /// No description provided for @actionPersuasion.
  ///
  /// In en, this message translates to:
  /// **'Persuasion'**
  String get actionPersuasion;

  /// No description provided for @actionThrow.
  ///
  /// In en, this message translates to:
  /// **'Throw'**
  String get actionThrow;

  /// No description provided for @actionDexterity.
  ///
  /// In en, this message translates to:
  /// **'Dexterity'**
  String get actionDexterity;

  /// No description provided for @actionEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get actionEndurance;

  /// No description provided for @actionFlee.
  ///
  /// In en, this message translates to:
  /// **'Flee'**
  String get actionFlee;

  /// No description provided for @outcomeCriticalFailure.
  ///
  /// In en, this message translates to:
  /// **'Critical Failure'**
  String get outcomeCriticalFailure;

  /// No description provided for @outcomeFailure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get outcomeFailure;

  /// No description provided for @outcomePartialSuccess.
  ///
  /// In en, this message translates to:
  /// **'Partial Success'**
  String get outcomePartialSuccess;

  /// No description provided for @outcomeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get outcomeSuccess;

  /// No description provided for @outcomeCriticalSuccess.
  ///
  /// In en, this message translates to:
  /// **'Critical Success'**
  String get outcomeCriticalSuccess;

  /// No description provided for @difficultyRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine Task'**
  String get difficultyRoutine;

  /// No description provided for @difficultyDangerous.
  ///
  /// In en, this message translates to:
  /// **'Dangerous'**
  String get difficultyDangerous;

  /// No description provided for @difficultyPerilous.
  ///
  /// In en, this message translates to:
  /// **'Perilous'**
  String get difficultyPerilous;

  /// No description provided for @difficultySuicidal.
  ///
  /// In en, this message translates to:
  /// **'Suicidal'**
  String get difficultySuicidal;

  /// No description provided for @statusPoisoned.
  ///
  /// In en, this message translates to:
  /// **'POISONED'**
  String get statusPoisoned;

  /// No description provided for @statusBurning.
  ///
  /// In en, this message translates to:
  /// **'BURNING'**
  String get statusBurning;

  /// No description provided for @statusFrozen.
  ///
  /// In en, this message translates to:
  /// **'FROZEN'**
  String get statusFrozen;

  /// No description provided for @statusBlessed.
  ///
  /// In en, this message translates to:
  /// **'BLESSED'**
  String get statusBlessed;

  /// No description provided for @statusShielded.
  ///
  /// In en, this message translates to:
  /// **'SHIELDED'**
  String get statusShielded;

  /// No description provided for @statusWeakened.
  ///
  /// In en, this message translates to:
  /// **'WEAKENED'**
  String get statusWeakened;

  /// No description provided for @tierWanderer.
  ///
  /// In en, this message translates to:
  /// **'Wanderer'**
  String get tierWanderer;

  /// No description provided for @tierAdventurer.
  ///
  /// In en, this message translates to:
  /// **'Adventurer'**
  String get tierAdventurer;

  /// No description provided for @tierChampion.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get tierChampion;

  /// No description provided for @tierTaglineFree.
  ///
  /// In en, this message translates to:
  /// **'Begin your journey'**
  String get tierTaglineFree;

  /// No description provided for @tierTaglineAdventurer.
  ///
  /// In en, this message translates to:
  /// **'Deeper stories await'**
  String get tierTaglineAdventurer;

  /// No description provided for @tierTaglineChampion.
  ///
  /// In en, this message translates to:
  /// **'The ultimate experience'**
  String get tierTaglineChampion;

  /// No description provided for @statAtk.
  ///
  /// In en, this message translates to:
  /// **'ATK'**
  String get statAtk;

  /// No description provided for @statDef.
  ///
  /// In en, this message translates to:
  /// **'DEF'**
  String get statDef;

  /// No description provided for @statMag.
  ///
  /// In en, this message translates to:
  /// **'MAG'**
  String get statMag;

  /// No description provided for @statAgi.
  ///
  /// In en, this message translates to:
  /// **'AGI'**
  String get statAgi;

  /// No description provided for @statHp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get statHp;

  /// No description provided for @statMp.
  ///
  /// In en, this message translates to:
  /// **'MP'**
  String get statMp;

  /// No description provided for @labelGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get labelGold;

  /// No description provided for @labelXp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get labelXp;

  /// No description provided for @labelLevel.
  ///
  /// In en, this message translates to:
  /// **'Lv {level}'**
  String labelLevel(int level);

  /// No description provided for @statSummaryFormat.
  ///
  /// In en, this message translates to:
  /// **'{label} {value}'**
  String statSummaryFormat(String label, String value);

  /// No description provided for @priceFormat.
  ///
  /// In en, this message translates to:
  /// **'{price} Gold'**
  String priceFormat(int price);

  /// No description provided for @rewardFormat.
  ///
  /// In en, this message translates to:
  /// **'{gold} Gold  ·  {xp} XP'**
  String rewardFormat(int gold, int xp);

  /// No description provided for @errorSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to play.'**
  String get errorSignInRequired;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorSignInToPlay.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google or Apple to play quests.'**
  String get errorSignInToPlay;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests — please wait a moment and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The AI service is temporarily unavailable. Please try again in a moment. Your credit has been refunded.'**
  String get errorServiceUnavailable;

  /// No description provided for @errorServerError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again.'**
  String get errorServerError;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Check your internet connection and try again.'**
  String get errorNetworkError;

  /// No description provided for @locationForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get locationForest;

  /// No description provided for @locationCave.
  ///
  /// In en, this message translates to:
  /// **'Cave'**
  String get locationCave;

  /// No description provided for @locationRuins.
  ///
  /// In en, this message translates to:
  /// **'Ruins'**
  String get locationRuins;

  /// No description provided for @freeRoamTitle.
  ///
  /// In en, this message translates to:
  /// **'{mapTitle} — Free Roam'**
  String freeRoamTitle(String mapTitle);

  /// No description provided for @freeRoamObjective.
  ///
  /// In en, this message translates to:
  /// **'Explore freely and see what the world has in store.'**
  String get freeRoamObjective;

  /// No description provided for @equip.
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get equip;

  /// No description provided for @unequip.
  ///
  /// In en, this message translates to:
  /// **'Unequip'**
  String get unequip;

  /// No description provided for @nameDialogContinue.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get nameDialogContinue;

  /// No description provided for @cardAcceptQuest.
  ///
  /// In en, this message translates to:
  /// **'ACCEPT QUEST'**
  String get cardAcceptQuest;

  /// No description provided for @cardInvestigate.
  ///
  /// In en, this message translates to:
  /// **'Investigate'**
  String get cardInvestigate;

  /// No description provided for @cardEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get cardEnter;

  /// No description provided for @cardRewardLabel.
  ///
  /// In en, this message translates to:
  /// **'REWARD'**
  String get cardRewardLabel;

  /// No description provided for @cardDifficultyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Difficulty: '**
  String get cardDifficultyPrefix;

  /// No description provided for @levelPrefix.
  ///
  /// In en, this message translates to:
  /// **'lvl {level}'**
  String levelPrefix(int level);

  /// No description provided for @questRepF01Title.
  ///
  /// In en, this message translates to:
  /// **'Goblin Patrol'**
  String get questRepF01Title;

  /// No description provided for @questRepF01Desc.
  ///
  /// In en, this message translates to:
  /// **'Goblin scouts have been spotted along the forest edge again. The militia posts a standing bounty â€” clear them out before they raid another farmstead.'**
  String get questRepF01Desc;

  /// No description provided for @questRepF01Obj.
  ///
  /// In en, this message translates to:
  /// **'Hunt goblin scouts in the forest outskirts.'**
  String get questRepF01Obj;

  /// No description provided for @questRepC01Title.
  ///
  /// In en, this message translates to:
  /// **'Tunnel Vermin'**
  String get questRepC01Title;

  /// No description provided for @questRepC01Desc.
  ///
  /// In en, this message translates to:
  /// **'Rats and cave spiders infest the upper Hollows. The miners pay good coin to anyone willing to clear them â€” the creatures breed faster than the tunnels can be sealed.'**
  String get questRepC01Desc;

  /// No description provided for @questRepC01Obj.
  ///
  /// In en, this message translates to:
  /// **'Clear vermin from the upper Hollows mining tunnels.'**
  String get questRepC01Obj;

  /// No description provided for @questRepR01Title.
  ///
  /// In en, this message translates to:
  /// **'Restless Bones'**
  String get questRepR01Title;

  /// No description provided for @questRepR01Desc.
  ///
  /// In en, this message translates to:
  /// **'The outer barrows of Valdris never stay quiet. Skeletons claw free of their graves every few days. Historian Korval pays a bounty to keep the camp entrance clear.'**
  String get questRepR01Desc;

  /// No description provided for @questRepR01Obj.
  ///
  /// In en, this message translates to:
  /// **'Lay restless undead to rest in the outer Valdris barrows.'**
  String get questRepR01Obj;

  /// No description provided for @questRepF02Title.
  ///
  /// In en, this message translates to:
  /// **'Bandit Bounty'**
  String get questRepF02Title;

  /// No description provided for @questRepF02Desc.
  ///
  /// In en, this message translates to:
  /// **'Bandit scouts patrol the trade roads near the Thornveil. Merchants refuse to travel without armed escort. The bounty board keeps this post pinned permanently.'**
  String get questRepF02Desc;

  /// No description provided for @questRepF02Obj.
  ///
  /// In en, this message translates to:
  /// **'Hunt bandit scouts along the Thornveil trade roads.'**
  String get questRepF02Obj;

  /// No description provided for @questRepC02Title.
  ///
  /// In en, this message translates to:
  /// **'Ore Vein Escort'**
  String get questRepC02Title;

  /// No description provided for @questRepC02Desc.
  ///
  /// In en, this message translates to:
  /// **'A new ore vein has been found in the mid-Hollows but the tunnels are prowled by cave creatures. Foreman Brick needs someone to escort miners to the vein and back.'**
  String get questRepC02Desc;

  /// No description provided for @questRepC02Obj.
  ///
  /// In en, this message translates to:
  /// **'Escort miners safely through dangerous Hollows tunnels.'**
  String get questRepC02Obj;

  /// No description provided for @questRepR02Title.
  ///
  /// In en, this message translates to:
  /// **'Artifact Salvage'**
  String get questRepR02Title;

  /// No description provided for @questRepR02Desc.
  ///
  /// In en, this message translates to:
  /// **'Scholar Veyra needs cursed artifacts recovered from the upper ruins before the scavengers sell them to collectors who have no idea what they are handling.'**
  String get questRepR02Desc;

  /// No description provided for @questRepR02Obj.
  ///
  /// In en, this message translates to:
  /// **'Recover cursed artifacts from the upper Valdris ruins.'**
  String get questRepR02Obj;

  /// No description provided for @questRepF03Title.
  ///
  /// In en, this message translates to:
  /// **'Corruption Cleansing'**
  String get questRepF03Title;

  /// No description provided for @questRepF03Desc.
  ///
  /// In en, this message translates to:
  /// **'Hollow-corrupted undergrowth is spreading through the mid-forest. Druid Theron\'s circle burns it back weekly, but they need someone to clear the creatures that nest in the corrupted groves.'**
  String get questRepF03Desc;

  /// No description provided for @questRepF03Obj.
  ///
  /// In en, this message translates to:
  /// **'Clear Hollow-corrupted creatures from the mid-forest groves.'**
  String get questRepF03Obj;

  /// No description provided for @questRepC03Title.
  ///
  /// In en, this message translates to:
  /// **'Fungal Harvest'**
  String get questRepC03Title;

  /// No description provided for @questRepC03Desc.
  ///
  /// In en, this message translates to:
  /// **'The Deep Mother\'s spore blooms keep erupting in the mid-Hollows. Herbalist Nessa needs someone to destroy the blooms before they madden the miners â€” and to bring back samples she can study.'**
  String get questRepC03Desc;

  /// No description provided for @questRepC03Obj.
  ///
  /// In en, this message translates to:
  /// **'Destroy dangerous fungal blooms in the mid-Hollows.'**
  String get questRepC03Obj;

  /// No description provided for @questRepR03Title.
  ///
  /// In en, this message translates to:
  /// **'Tithebound Patrol'**
  String get questRepR03Title;

  /// No description provided for @questRepR03Desc.
  ///
  /// In en, this message translates to:
  /// **'Tithebound sentinels wander the mid-depth ruins in endless loops. When they stray too close to the surface camp, someone has to drive them back. The bounty is always posted.'**
  String get questRepR03Desc;

  /// No description provided for @questRepR03Obj.
  ///
  /// In en, this message translates to:
  /// **'Push back Tithebound patrols from the upper ruins.'**
  String get questRepR03Obj;

  /// No description provided for @questRepF04Title.
  ///
  /// In en, this message translates to:
  /// **'Pale Root Skirmish'**
  String get questRepF04Title;

  /// No description provided for @questRepF04Desc.
  ///
  /// In en, this message translates to:
  /// **'Pale Root raiders have been ambushing patrols near the Thornwall. The elves disavow them, but the attacks continue. The bounty is high â€” these are no common bandits.'**
  String get questRepF04Desc;

  /// No description provided for @questRepF04Obj.
  ///
  /// In en, this message translates to:
  /// **'Engage Pale Root raiders near the Thornwall border.'**
  String get questRepF04Obj;

  /// No description provided for @questRepC04Title.
  ///
  /// In en, this message translates to:
  /// **'Deep Vein Patrol'**
  String get questRepC04Title;

  /// No description provided for @questRepC04Desc.
  ///
  /// In en, this message translates to:
  /// **'Creatures freed by failing ward-stones crawl up from the deep Hollows. The Ossborn ignore anything that doesn\'t threaten their seals. Foreman Brick needs surface folk to keep the mid-tunnels passable.'**
  String get questRepC04Desc;

  /// No description provided for @questRepC04Obj.
  ///
  /// In en, this message translates to:
  /// **'Patrol the deep Hollows and clear escaped creatures.'**
  String get questRepC04Obj;

  /// No description provided for @questRepR04Title.
  ///
  /// In en, this message translates to:
  /// **'Resonance Suppression'**
  String get questRepR04Title;

  /// No description provided for @questRepR04Desc.
  ///
  /// In en, this message translates to:
  /// **'The hum in the deep ruins keeps spawning resonance nodes â€” crystals that drive people mad. Scholar Veyra pays well to have them shattered before the sound reaches the surface.'**
  String get questRepR04Desc;

  /// No description provided for @questRepR04Obj.
  ///
  /// In en, this message translates to:
  /// **'Destroy resonance nodes in the deep Valdris ruins.'**
  String get questRepR04Obj;

  /// No description provided for @questRepF05Title.
  ///
  /// In en, this message translates to:
  /// **'Verdant Court Errand'**
  String get questRepF05Title;

  /// No description provided for @questRepF05Desc.
  ///
  /// In en, this message translates to:
  /// **'The Verdant Court has tasked mortal champions with purging corruption from sacred groves the elves cannot reach without crossing the Thornwall. The pay is elvish silver â€” worth more than human gold.'**
  String get questRepF05Desc;

  /// No description provided for @questRepF05Obj.
  ///
  /// In en, this message translates to:
  /// **'Purge corruption from a sacred grove for the Verdant Court.'**
  String get questRepF05Obj;

  /// No description provided for @questRepC05Title.
  ///
  /// In en, this message translates to:
  /// **'Binding Repair'**
  String get questRepC05Title;

  /// No description provided for @questRepC05Desc.
  ///
  /// In en, this message translates to:
  /// **'The ward-stones in the deep Hollows keep cracking. The Forge Spirit can\'t tend them all. Someone must carry replacement seal-stones to the failing pedestals before what\'s behind them breaks free.'**
  String get questRepC05Desc;

  /// No description provided for @questRepC05Obj.
  ///
  /// In en, this message translates to:
  /// **'Deliver seal-stones to failing ward-stone pedestals in the deep Hollows.'**
  String get questRepC05Obj;

  /// No description provided for @questRepR05Title.
  ///
  /// In en, this message translates to:
  /// **'Dimensional Seal'**
  String get questRepR05Title;

  /// No description provided for @questRepR05Desc.
  ///
  /// In en, this message translates to:
  /// **'Minor tears keep opening near the Severance wound â€” reality fraying at the edges. Aware Tithebound elders mark them. Someone must close them before the Nameless Choir leaks through.'**
  String get questRepR05Desc;

  /// No description provided for @questRepR05Obj.
  ///
  /// In en, this message translates to:
  /// **'Seal minor dimensional tears near the Severance wound.'**
  String get questRepR05Obj;

  /// No description provided for @questF001Title.
  ///
  /// In en, this message translates to:
  /// **'Goblin Camp on the Trade Road'**
  String get questF001Title;

  /// No description provided for @questF001Desc.
  ///
  /// In en, this message translates to:
  /// **'A goblin scouting party has set up a camp where the trade road enters the Thornveil. Woodcutters and merchants refuse to pass.'**
  String get questF001Desc;

  /// No description provided for @questF001Obj.
  ///
  /// In en, this message translates to:
  /// **'Locate and destroy the goblin camp blocking the forest trade road.'**
  String get questF001Obj;

  /// No description provided for @questF002Title.
  ///
  /// In en, this message translates to:
  /// **'Dire Wolves of the Thornveil'**
  String get questF002Title;

  /// No description provided for @questF002Desc.
  ///
  /// In en, this message translates to:
  /// **'A pack of dire wolves has claimed the main road through the outer Thornveil. Travelers are being dragged into the underbrush.'**
  String get questF002Desc;

  /// No description provided for @questF002Obj.
  ///
  /// In en, this message translates to:
  /// **'Hunt or drive off the dire wolf pack terrorizing the Thornveil road.'**
  String get questF002Obj;

  /// No description provided for @questF003Title.
  ///
  /// In en, this message translates to:
  /// **'The Poisoned Stream'**
  String get questF003Title;

  /// No description provided for @questF003Desc.
  ///
  /// In en, this message translates to:
  /// **'A foul green sludge seeps from somewhere upstream in the Thornveil. Animals that drink from the brook collapse dead. Herbalist Nessa fears it may reach the village water supply.'**
  String get questF003Desc;

  /// No description provided for @questF003Obj.
  ///
  /// In en, this message translates to:
  /// **'Follow the stream through the Thornveil and destroy whatever is poisoning it.'**
  String get questF003Obj;

  /// No description provided for @questF004Title.
  ///
  /// In en, this message translates to:
  /// **'The Missing Woodcutter'**
  String get questF004Title;

  /// No description provided for @questF004Desc.
  ///
  /// In en, this message translates to:
  /// **'Old Henrik went to fell timber at the Thornveil\'s edge three days ago. His axe was found embedded in a tree, covered in claw marks.'**
  String get questF004Desc;

  /// No description provided for @questF004Obj.
  ///
  /// In en, this message translates to:
  /// **'Track the missing woodcutter deeper into the outer Thornveil and learn his fate.'**
  String get questF004Obj;

  /// No description provided for @questF005Title.
  ///
  /// In en, this message translates to:
  /// **'Bandit Ambush'**
  String get questF005Title;

  /// No description provided for @questF005Desc.
  ///
  /// In en, this message translates to:
  /// **'Bandits have been robbing merchants on the forest road outside the Thornwall. They vanish into the canopy before the militia arrives.'**
  String get questF005Desc;

  /// No description provided for @questF005Obj.
  ///
  /// In en, this message translates to:
  /// **'Set a trap for the forest bandits and take down their leader.'**
  String get questF005Obj;

  /// No description provided for @questF006Title.
  ///
  /// In en, this message translates to:
  /// **'Curse of the Black Vine'**
  String get questF006Title;

  /// No description provided for @questF006Desc.
  ///
  /// In en, this message translates to:
  /// **'A thorned blight is creeping across the forest floor near the Thornwall border. It moves on its own at night, strangling trees. The Circle of Thorn druids say they\'ve never seen anything like it.'**
  String get questF006Desc;

  /// No description provided for @questF006Obj.
  ///
  /// In en, this message translates to:
  /// **'Find the heart of the Black Vine deep in the Thornveil and burn it out.'**
  String get questF006Obj;

  /// No description provided for @questF007Title.
  ///
  /// In en, this message translates to:
  /// **'The Fey Ambush'**
  String get questF007Title;

  /// No description provided for @questF007Desc.
  ///
  /// In en, this message translates to:
  /// **'Sprites at the Thornveil\'s edge have turned hostile without warning. Travelers report being enchanted and robbed â€” or worse, led off the path and never seen again. The old fey pacts may be fraying.'**
  String get questF007Desc;

  /// No description provided for @questF007Obj.
  ///
  /// In en, this message translates to:
  /// **'Discover why the fey have turned hostile and find a way to stop the attacks.'**
  String get questF007Obj;

  /// No description provided for @questF008Title.
  ///
  /// In en, this message translates to:
  /// **'The Vaelithi Deserter'**
  String get questF008Title;

  /// No description provided for @questF008Desc.
  ///
  /// In en, this message translates to:
  /// **'An elf was found unconscious at the Thornwall border, covered in wounds that look self-inflicted â€” as though she clawed through the barrier from the inside. She mutters about a \"pale root\" and begs not to be sent back.'**
  String get questF008Desc;

  /// No description provided for @questF008Obj.
  ///
  /// In en, this message translates to:
  /// **'Protect the elvish deserter from whoever is hunting her and learn what she knows.'**
  String get questF008Obj;

  /// No description provided for @questF009Title.
  ///
  /// In en, this message translates to:
  /// **'The Beast of the Thicket'**
  String get questF009Title;

  /// No description provided for @questF009Desc.
  ///
  /// In en, this message translates to:
  /// **'Livestock at the Thornveil\'s edge is being torn apart by something massive. Claw marks are as wide as a man\'s arm. Farmer Gregor says the druids won\'t help â€” they claim the beast is \"the forest\'s answer.\"'**
  String get questF009Desc;

  /// No description provided for @questF009Obj.
  ///
  /// In en, this message translates to:
  /// **'Track and slay the beast lurking in the deepest thicket of the outer Thornveil.'**
  String get questF009Obj;

  /// No description provided for @questF010Title.
  ///
  /// In en, this message translates to:
  /// **'Spider Nests in the Canopy'**
  String get questF010Title;

  /// No description provided for @questF010Desc.
  ///
  /// In en, this message translates to:
  /// **'Giant webs span the canopy for miles along the trade road. Cocooned travelers dangle from the branches, some still alive. Ranger Elara says the spiders appeared after the fey pacts weakened.'**
  String get questF010Desc;

  /// No description provided for @questF010Obj.
  ///
  /// In en, this message translates to:
  /// **'Burn the spider nests in the forest canopy and save any survivors.'**
  String get questF010Obj;

  /// No description provided for @questF011Title.
  ///
  /// In en, this message translates to:
  /// **'The Verdant Terror'**
  String get questF011Title;

  /// No description provided for @questF011Desc.
  ///
  /// In en, this message translates to:
  /// **'A monstrous plant creature has taken root near the Thornwall border. Druid Theron believes it grew from Hollow-corrupted soil â€” the same blight the Vaelithi refuse to acknowledge.'**
  String get questF011Desc;

  /// No description provided for @questF011Obj.
  ///
  /// In en, this message translates to:
  /// **'Cut through the overgrowth and destroy the monstrous plant creature threatening the Thornwall border.'**
  String get questF011Obj;

  /// No description provided for @questF012Title.
  ///
  /// In en, this message translates to:
  /// **'Crown of Thorns'**
  String get questF012Title;

  /// No description provided for @questF012Desc.
  ///
  /// In en, this message translates to:
  /// **'A corrupted treant has claimed the deepest grove outside the Thornwall. The Circle of Thorn druids say a dark crystal was driven into its trunk â€” the same kind of corruption that has been spreading from the Hollows.'**
  String get questF012Desc;

  /// No description provided for @questF012Obj.
  ///
  /// In en, this message translates to:
  /// **'Venture into the ancient grove and destroy the corruption inside the treant.'**
  String get questF012Obj;

  /// No description provided for @questF013Title.
  ///
  /// In en, this message translates to:
  /// **'The Pyre Cult\'s Altar'**
  String get questF013Title;

  /// No description provided for @questF013Desc.
  ///
  /// In en, this message translates to:
  /// **'A fanatical fire cult has been building pyre-altars between the trees of the outer Thornveil. Spy Maren says they worship something in the Hollows below and plan to burn a path through the Thornwall to reach Vaelith.'**
  String get questF013Desc;

  /// No description provided for @questF013Obj.
  ///
  /// In en, this message translates to:
  /// **'Infiltrate the fire cult\'s forest encampment and bring down their leader.'**
  String get questF013Obj;

  /// No description provided for @questF014Title.
  ///
  /// In en, this message translates to:
  /// **'The Dragon\'s Hunting Ground'**
  String get questF014Title;

  /// No description provided for @questF014Desc.
  ///
  /// In en, this message translates to:
  /// **'A young dragon has claimed the mortal forest as its hunting territory. Charred clearings mark its kills. The Vaelithi have closed the Thornwall tighter â€” they do not intend to help.'**
  String get questF014Desc;

  /// No description provided for @questF014Obj.
  ///
  /// In en, this message translates to:
  /// **'Track the dragon to its forest lair and put an end to its reign.'**
  String get questF014Obj;

  /// No description provided for @questF015Title.
  ///
  /// In en, this message translates to:
  /// **'Orc War-Camp'**
  String get questF015Title;

  /// No description provided for @questF015Desc.
  ///
  /// In en, this message translates to:
  /// **'An orc warband has built a fortified camp in the mortal forest. They raid surrounding villages nightly. Commander Hale has militia support but not enough to assault the camp alone.'**
  String get questF015Desc;

  /// No description provided for @questF015Obj.
  ///
  /// In en, this message translates to:
  /// **'Assault the orc war-camp in the forest and break their siege on the villages.'**
  String get questF015Obj;

  /// No description provided for @questF016Title.
  ///
  /// In en, this message translates to:
  /// **'The Thornwall Breach'**
  String get questF016Title;

  /// No description provided for @questF016Desc.
  ///
  /// In en, this message translates to:
  /// **'Something has torn a hole in the Thornwall â€” the living barrier that seals Vaelith from the mortal world. Fey creatures and worse are pouring through the gap. The elves have not responded. The druids are overwhelmed.'**
  String get questF016Desc;

  /// No description provided for @questF016Obj.
  ///
  /// In en, this message translates to:
  /// **'Reach the Thornwall breach and seal it before the gap widens further.'**
  String get questF016Obj;

  /// No description provided for @questF017Title.
  ///
  /// In en, this message translates to:
  /// **'The Pale Root Incursion'**
  String get questF017Title;

  /// No description provided for @questF017Desc.
  ///
  /// In en, this message translates to:
  /// **'Pale Root agents â€” elves from Vaelith\'s rebel faction â€” have crossed the Thornwall and are sabotaging Circle of Thorn shrines. Druid Theron believes they want the barrier to fall so Vaelith can expand by force.'**
  String get questF017Desc;

  /// No description provided for @questF017Obj.
  ///
  /// In en, this message translates to:
  /// **'Track and stop the Pale Root agents before they destroy the last druidic shrine.'**
  String get questF017Obj;

  /// No description provided for @questF018Title.
  ///
  /// In en, this message translates to:
  /// **'Shadows in the Canopy'**
  String get questF018Title;

  /// No description provided for @questF018Desc.
  ///
  /// In en, this message translates to:
  /// **'An eternal twilight has fallen over a vast section of the Thornveil. Shadow creatures roam the darkened canopy. Sun Priestess Amara says the Sunstone â€” an ancient relic that anchors daylight to the forest â€” has been stolen.'**
  String get questF018Desc;

  /// No description provided for @questF018Obj.
  ///
  /// In en, this message translates to:
  /// **'Find the Sunstone and restore daylight to the darkened forest.'**
  String get questF018Obj;

  /// No description provided for @questF019Title.
  ///
  /// In en, this message translates to:
  /// **'The Blight Beneath Vaelith'**
  String get questF019Title;

  /// No description provided for @questF019Desc.
  ///
  /// In en, this message translates to:
  /// **'A Vaelithi exile has crossed the Thornwall with desperate news: the blight in the root-hollows beneath Vaelith is spreading faster than the elves can contain it. The Verdant Court refuses to ask mortals for help â€” but this exile is asking anyway.'**
  String get questF019Desc;

  /// No description provided for @questF019Obj.
  ///
  /// In en, this message translates to:
  /// **'Cross through a gap in the Thornwall and descend into the root-hollows to find the source of the blight.'**
  String get questF019Obj;

  /// No description provided for @questF020Title.
  ///
  /// In en, this message translates to:
  /// **'The God-Eater'**
  String get questF020Title;

  /// No description provided for @questF020Desc.
  ///
  /// In en, this message translates to:
  /// **'Shrines throughout the Thornveil have gone silent. A creature feeding on divine essence stalks between the trees â€” the druids call it a God-Eater, something that shouldn\'t exist outside the Hollow.'**
  String get questF020Desc;

  /// No description provided for @questF020Obj.
  ///
  /// In en, this message translates to:
  /// **'Hunt the God-Eater through the sacred groves before it devours the last shrine.'**
  String get questF020Obj;

  /// No description provided for @questF021Title.
  ///
  /// In en, this message translates to:
  /// **'The World Tree Burns'**
  String get questF021Title;

  /// No description provided for @questF021Desc.
  ///
  /// In en, this message translates to:
  /// **'Demonic fire engulfs the World Tree. The Vaelithi have opened the Thornwall for the first time in three centuries â€” not to help, but to evacuate. If the World Tree falls, the forest and everything beneath it dies.'**
  String get questF021Desc;

  /// No description provided for @questF021Obj.
  ///
  /// In en, this message translates to:
  /// **'Ascend the burning World Tree and extinguish the infernal flame at its crown.'**
  String get questF021Obj;

  /// No description provided for @questF022Title.
  ///
  /// In en, this message translates to:
  /// **'The Verdant Court\'s Judgment'**
  String get questF022Title;

  /// No description provided for @questF022Desc.
  ///
  /// In en, this message translates to:
  /// **'Queen Seylith the Undying has summoned the player to Vaelith â€” the first mortal invited through the Thornwall in three centuries. She does not explain why. The Pale Root faction sees this as an opportunity.'**
  String get questF022Desc;

  /// No description provided for @questF022Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter Vaelith, survive the Verdant Court\'s trial, and learn what the elves have been hiding.'**
  String get questF022Obj;

  /// No description provided for @questF023Title.
  ///
  /// In en, this message translates to:
  /// **'Death\'s Grove'**
  String get questF023Title;

  /// No description provided for @questF023Desc.
  ///
  /// In en, this message translates to:
  /// **'Death â€” the eldest god â€” has planted a black sapling in the heart of the Thornveil. All who pass it wither to bone. The World Tree shudders. The Vaelithi have gone silent. The druids say this is the end of the forest.'**
  String get questF023Desc;

  /// No description provided for @questF023Obj.
  ///
  /// In en, this message translates to:
  /// **'Uproot Death\'s sapling from the forest clearing and survive what guards it.'**
  String get questF023Obj;

  /// No description provided for @questC001Title.
  ///
  /// In en, this message translates to:
  /// **'Cellar Dwellers'**
  String get questC001Title;

  /// No description provided for @questC001Desc.
  ///
  /// In en, this message translates to:
  /// **'Scratching echoes from the cave beneath the old inn. Something has moved up from the Hollows into the upper tunnels.'**
  String get questC001Desc;

  /// No description provided for @questC001Obj.
  ///
  /// In en, this message translates to:
  /// **'Clear the creatures infesting the cellar cave beneath the old inn.'**
  String get questC001Obj;

  /// No description provided for @questC002Title.
  ///
  /// In en, this message translates to:
  /// **'The Glowing Depths'**
  String get questC002Title;

  /// No description provided for @questC002Desc.
  ///
  /// In en, this message translates to:
  /// **'A faint green glow pulses from a Hollows entrance. The village well water has started tasting of rot â€” Herbalist Nessa says the Deep Mother\'s fungal growths are spreading upward.'**
  String get questC002Desc;

  /// No description provided for @questC002Obj.
  ///
  /// In en, this message translates to:
  /// **'Descend into the Hollows and purge whatever contaminates the underground water source.'**
  String get questC002Obj;

  /// No description provided for @questC003Title.
  ///
  /// In en, this message translates to:
  /// **'Bat Swarm in the Hollows'**
  String get questC003Title;

  /// No description provided for @questC003Desc.
  ///
  /// In en, this message translates to:
  /// **'Enormous cave bats have been erupting from a Hollows entrance at dusk, terrorizing shepherds on the surface.'**
  String get questC003Desc;

  /// No description provided for @questC003Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter the upper Hollows and deal with the monstrous bat colony.'**
  String get questC003Obj;

  /// No description provided for @questC004Title.
  ///
  /// In en, this message translates to:
  /// **'Smuggler\'s Tunnel'**
  String get questC004Title;

  /// No description provided for @questC004Desc.
  ///
  /// In en, this message translates to:
  /// **'Illegal goods are flowing through a hidden passage in the upper Hollows. Smugglers use the worked-stone tunnels that miners abandoned after hearing strange sounds deeper in.'**
  String get questC004Desc;

  /// No description provided for @questC004Obj.
  ///
  /// In en, this message translates to:
  /// **'Infiltrate the smuggler\'s Hollows tunnel and intercept their operation.'**
  String get questC004Obj;

  /// No description provided for @questC005Title.
  ///
  /// In en, this message translates to:
  /// **'The Collapsed Shaft'**
  String get questC005Title;

  /// No description provided for @questC005Desc.
  ///
  /// In en, this message translates to:
  /// **'Miners broke through into something ancient â€” a passage carved by no human hand. Strange sounds echo from beyond the collapse, and the stone feels warm to the touch.'**
  String get questC005Desc;

  /// No description provided for @questC005Obj.
  ///
  /// In en, this message translates to:
  /// **'Explore the collapsed mine shaft and rescue the miners trapped in the older tunnels.'**
  String get questC005Obj;

  /// No description provided for @questC006Title.
  ///
  /// In en, this message translates to:
  /// **'The Lurker Below'**
  String get questC006Title;

  /// No description provided for @questC006Desc.
  ///
  /// In en, this message translates to:
  /// **'Something massive lives in the underground lake where the Hollows meet the water table. Ripples appear where nothing should stir.'**
  String get questC006Desc;

  /// No description provided for @questC006Obj.
  ///
  /// In en, this message translates to:
  /// **'Lure out and slay the creature dwelling in the Hollows\' underground lake.'**
  String get questC006Obj;

  /// No description provided for @questC007Title.
  ///
  /// In en, this message translates to:
  /// **'The First Trap'**
  String get questC007Title;

  /// No description provided for @questC007Desc.
  ///
  /// In en, this message translates to:
  /// **'Miners opened a new tunnel and three of them vanished. A survivor crawled back babbling about floor tiles that \"screamed fire\" â€” warden-craft traps from the deep Hollows, far above where they should be.'**
  String get questC007Desc;

  /// No description provided for @questC007Obj.
  ///
  /// In en, this message translates to:
  /// **'Navigate the trapped passage in the mid-Hollows and retrieve the missing miners.'**
  String get questC007Obj;

  /// No description provided for @questC008Title.
  ///
  /// In en, this message translates to:
  /// **'The Mushroom Plague'**
  String get questC008Title;

  /// No description provided for @questC008Desc.
  ///
  /// In en, this message translates to:
  /// **'Bioluminescent fungal growths â€” the Deep Mother\'s breath â€” are spreading rapidly through the mid-Hollows. Miners who inhale the spores go mad, clawing at the walls and speaking in voices that aren\'t theirs.'**
  String get questC008Desc;

  /// No description provided for @questC008Obj.
  ///
  /// In en, this message translates to:
  /// **'Reach the source of the mushroom plague deep in the Hollows and destroy it.'**
  String get questC008Obj;

  /// No description provided for @questC009Title.
  ///
  /// In en, this message translates to:
  /// **'The Flesh Market'**
  String get questC009Title;

  /// No description provided for @questC009Desc.
  ///
  /// In en, this message translates to:
  /// **'People vanish from the villages above. A black market operates in the lawless upper Hollows, dealing in living bodies. The smugglers have gone deeper than anyone should.'**
  String get questC009Desc;

  /// No description provided for @questC009Obj.
  ///
  /// In en, this message translates to:
  /// **'Infiltrate the underground flesh market in the Hollows and free the prisoners.'**
  String get questC009Obj;

  /// No description provided for @questC010Title.
  ///
  /// In en, this message translates to:
  /// **'The Underground Arena'**
  String get questC010Title;

  /// No description provided for @questC010Desc.
  ///
  /// In en, this message translates to:
  /// **'The Hollows fighting pits have a new champion â€” one that never bleeds. Its skin is pale and translucent, and it fights with a stillness that terrifies the crowd. Some say it crawled up from the deep.'**
  String get questC010Desc;

  /// No description provided for @questC010Obj.
  ///
  /// In en, this message translates to:
  /// **'Challenge the undefeated pit champion and uncover the secret of its victories.'**
  String get questC010Obj;

  /// No description provided for @questC011Title.
  ///
  /// In en, this message translates to:
  /// **'The Bone Chime Corridor'**
  String get questC011Title;

  /// No description provided for @questC011Desc.
  ///
  /// In en, this message translates to:
  /// **'Explorers found a passage deeper in the Hollows strung with chimes made of bone. The first man who touched one is dead â€” the chime exploded into razor shards. This is warden-craft. Something is sealed beyond.'**
  String get questC011Desc;

  /// No description provided for @questC011Obj.
  ///
  /// In en, this message translates to:
  /// **'Navigate the bone-chime corridor in the deep Hollows without triggering the traps and discover what lies beyond.'**
  String get questC011Obj;

  /// No description provided for @questC012Title.
  ///
  /// In en, this message translates to:
  /// **'First Contact'**
  String get questC012Title;

  /// No description provided for @questC012Desc.
  ///
  /// In en, this message translates to:
  /// **'A mining team broke through into a chamber where the stone was carved with symbols no one recognizes. Three of the miners were found dead â€” killed silently, precisely, without struggle. Something is down here. Something that does not want to be found.'**
  String get questC012Desc;

  /// No description provided for @questC012Obj.
  ///
  /// In en, this message translates to:
  /// **'Descend into the newly breached chamber and discover what killed the miners.'**
  String get questC012Obj;

  /// No description provided for @questC013Title.
  ///
  /// In en, this message translates to:
  /// **'Prison of Echoes'**
  String get questC013Title;

  /// No description provided for @questC013Desc.
  ///
  /// In en, this message translates to:
  /// **'An ancient prison in the mid-Hollows has begun to crack. The ward-stones are failing â€” Foreman Brick says the stone screams at night. Whatever is sealed inside grows stronger by the hour.'**
  String get questC013Desc;

  /// No description provided for @questC013Obj.
  ///
  /// In en, this message translates to:
  /// **'Navigate the crumbling prison in the Hollows and reseal the binding before what\'s inside breaks free.'**
  String get questC013Obj;

  /// No description provided for @questC014Title.
  ///
  /// In en, this message translates to:
  /// **'The Lava Veins'**
  String get questC014Title;

  /// No description provided for @questC014Desc.
  ///
  /// In en, this message translates to:
  /// **'Magma is rising through tunnels that should be cold stone. Fire elementals crawl from the molten rock â€” the Deep Mother\'s blood, boiling up from below. The Ossborn have retreated from this section entirely.'**
  String get questC014Desc;

  /// No description provided for @questC014Obj.
  ///
  /// In en, this message translates to:
  /// **'Reach the volcanic vent in the deep Hollows and seal the breach before the magma reaches the upper tunnels.'**
  String get questC014Obj;

  /// No description provided for @questC015Title.
  ///
  /// In en, this message translates to:
  /// **'The Drake\'s Hoard'**
  String get questC015Title;

  /// No description provided for @questC015Desc.
  ///
  /// In en, this message translates to:
  /// **'A cave drake has burrowed into the mid-Hollows and made its nest on a vein of raw ore. Its breath heats the tunnels to scorching. The Ossborn ignore it â€” it hasn\'t breached any seals. The miners cannot.'**
  String get questC015Desc;

  /// No description provided for @questC015Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter the cave drake\'s lair in the Hollows and deal with it.'**
  String get questC015Obj;

  /// No description provided for @questC016Title.
  ///
  /// In en, this message translates to:
  /// **'The Ward-Stone Thieves'**
  String get questC016Title;

  /// No description provided for @questC016Desc.
  ///
  /// In en, this message translates to:
  /// **'Someone is stealing ward-stones from the deep Hollows and selling them as magical curiosities on the surface. The Ossborn have responded â€” four traders are dead, killed silently in their beds. The stealing hasn\'t stopped.'**
  String get questC016Desc;

  /// No description provided for @questC016Obj.
  ///
  /// In en, this message translates to:
  /// **'Find the ward-stone thieves in the Hollows before the Ossborn kill everyone involved.'**
  String get questC016Obj;

  /// No description provided for @questC017Title.
  ///
  /// In en, this message translates to:
  /// **'The Rite of Grafting'**
  String get questC017Title;

  /// No description provided for @questC017Desc.
  ///
  /// In en, this message translates to:
  /// **'An Ossborn elder has broken from the others. She speaks â€” haltingly, in a voice layered with dead wardens\' echoes â€” and asks for help. The bones in her body are rejecting the graft. If she dies, the knowledge of three wardens dies with her.'**
  String get questC017Desc;

  /// No description provided for @questC017Obj.
  ///
  /// In en, this message translates to:
  /// **'Escort the failing Ossborn elder to the deep forge where the Forge Spirit can stabilize her grafts.'**
  String get questC017Obj;

  /// No description provided for @questC018Title.
  ///
  /// In en, this message translates to:
  /// **'The Void Rift'**
  String get questC018Title;

  /// No description provided for @questC018Desc.
  ///
  /// In en, this message translates to:
  /// **'Reality is tearing apart in the deepest known chamber of the Hollows. Void creatures pour through the crack â€” the same Hollow-corruption the global texts describe. Even the Ossborn are retreating.'**
  String get questC018Desc;

  /// No description provided for @questC018Obj.
  ///
  /// In en, this message translates to:
  /// **'Close the Void Rift in the deepest Hollows before the breach becomes permanent.'**
  String get questC018Obj;

  /// No description provided for @questC019Title.
  ///
  /// In en, this message translates to:
  /// **'The Titan\'s Chains'**
  String get questC019Title;

  /// No description provided for @questC019Desc.
  ///
  /// In en, this message translates to:
  /// **'A titan sealed during the Sundering has nearly broken free. Its tremors collapse tunnels for miles. The Ossborn carry the memory of how the chains were originally forged â€” but the knowledge is fragmentary, spread across three elders who no longer agree on the sequence.'**
  String get questC019Desc;

  /// No description provided for @questC019Obj.
  ///
  /// In en, this message translates to:
  /// **'Work with the Forge Spirit and the Ossborn to reforge the titan\'s chains before it wakes.'**
  String get questC019Obj;

  /// No description provided for @questC020Title.
  ///
  /// In en, this message translates to:
  /// **'The Mad Ossborn'**
  String get questC020Title;

  /// No description provided for @questC020Desc.
  ///
  /// In en, this message translates to:
  /// **'An Ossborn elder has gone mad â€” the weight of a dozen dead wardens\' memories has crushed his own identity. He believes he IS the warden whose bones he carries, and he is systematically deactivating the seals that warden originally set, claiming they are \"his to release.\"'**
  String get questC020Desc;

  /// No description provided for @questC020Obj.
  ///
  /// In en, this message translates to:
  /// **'Track the mad Ossborn through the deep Hollows and stop him before he opens the sealed prisons.'**
  String get questC020Obj;

  /// No description provided for @questC021Title.
  ///
  /// In en, this message translates to:
  /// **'The Devourer\'s Prison'**
  String get questC021Title;

  /// No description provided for @questC021Desc.
  ///
  /// In en, this message translates to:
  /// **'The Devourer â€” something that predates even the gods â€” stirs in its vault beneath the deepest Hollows. The Ossborn have gathered in numbers not seen in centuries. The Forge Spirit has gone silent. The ward-stones are failing.'**
  String get questC021Desc;

  /// No description provided for @questC021Obj.
  ///
  /// In en, this message translates to:
  /// **'Gather the Sealing Stones and reinforce the Devourer\'s prison before it breaks free.'**
  String get questC021Obj;

  /// No description provided for @questC022Title.
  ///
  /// In en, this message translates to:
  /// **'The Demon Gate'**
  String get questC022Title;

  /// No description provided for @questC022Desc.
  ///
  /// In en, this message translates to:
  /// **'A gate to the abyss has opened at the Hollows\' lowest point â€” a seal that has held since the Sundering, now cracked. Demonic legions amass on the other side. The Ossborn carrying the warden-memory for this seal are dead.'**
  String get questC022Desc;

  /// No description provided for @questC022Obj.
  ///
  /// In en, this message translates to:
  /// **'Descend to the bottom of the Hollows and seal the Demon Gate before the invasion begins.'**
  String get questC022Obj;

  /// No description provided for @questC023Title.
  ///
  /// In en, this message translates to:
  /// **'The Serpent of the Deep'**
  String get questC023Title;

  /// No description provided for @questC023Desc.
  ///
  /// In en, this message translates to:
  /// **'A colossal serpent coils through the Hollows\' deepest flooded tunnels. Its venom dissolves ward-stone â€” the Ossborn have lost three sealed passages to its acidic wake. If it reaches the binding circle, the Devourer\'s prison fails.'**
  String get questC023Desc;

  /// No description provided for @questC023Obj.
  ///
  /// In en, this message translates to:
  /// **'Track the great serpent through the flooded tunnels and slay it before it destroys the bindings.'**
  String get questC023Obj;

  /// No description provided for @questC024Title.
  ///
  /// In en, this message translates to:
  /// **'The Heart of the Mountain'**
  String get questC024Title;

  /// No description provided for @questC024Desc.
  ///
  /// In en, this message translates to:
  /// **'Something ancient beats at the mountain\'s core â€” the Heart of the Mountain, a living organ of stone and magma that may be the Deep Mother\'s own heart, still beating after the Sundering. It is waking. The Ossborn kneel before it. The Forge Spirit says it must be silenced. The Ossborn say it must not.'**
  String get questC024Desc;

  /// No description provided for @questC024Obj.
  ///
  /// In en, this message translates to:
  /// **'Reach the Heart of the Mountain at the deepest point of the Hollows and decide its fate.'**
  String get questC024Obj;

  /// No description provided for @questR001Title.
  ///
  /// In en, this message translates to:
  /// **'Haunted Barrow'**
  String get questR001Title;

  /// No description provided for @questR001Desc.
  ///
  /// In en, this message translates to:
  /// **'Lights flicker inside the oldest barrow of the Valdris ruins at night. The dead do not rest easy in these crumbling halls â€” and Scholar Veyra says the walls hum if you press your ear to them.'**
  String get questR001Desc;

  /// No description provided for @questR001Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter the barrow beneath the Valdris ruins and lay the restless dead to rest.'**
  String get questR001Obj;

  /// No description provided for @questR002Title.
  ///
  /// In en, this message translates to:
  /// **'Vermin in the Undercroft'**
  String get questR002Title;

  /// No description provided for @questR002Desc.
  ///
  /// In en, this message translates to:
  /// **'Giant rats have overrun the undercroft beneath the Valdris ruins. They\'ve grown bold enough to attack the researchers camped at the entrance.'**
  String get questR002Desc;

  /// No description provided for @questR002Obj.
  ///
  /// In en, this message translates to:
  /// **'Descend into the ruin undercroft and deal with the rat infestation.'**
  String get questR002Obj;

  /// No description provided for @questR003Title.
  ///
  /// In en, this message translates to:
  /// **'The Whispering Idol'**
  String get questR003Title;

  /// No description provided for @questR003Desc.
  ///
  /// In en, this message translates to:
  /// **'A stone idol was unearthed in the Valdris ruins. Anyone who touches it hears whispers in a language they almost understand. Scholar Veyra says the idol predates Valdris itself â€” it shouldn\'t be here.'**
  String get questR003Desc;

  /// No description provided for @questR003Obj.
  ///
  /// In en, this message translates to:
  /// **'Find and destroy the cursed idol hidden in the Valdris ruins.'**
  String get questR003Obj;

  /// No description provided for @questR004Title.
  ///
  /// In en, this message translates to:
  /// **'Tomb Robbers'**
  String get questR004Title;

  /// No description provided for @questR004Desc.
  ///
  /// In en, this message translates to:
  /// **'Grave robbers are prying open sealed chambers in the Valdris ruins. Historian Korval is furious â€” every broken seal releases more of whatever lingers here.'**
  String get questR004Desc;

  /// No description provided for @questR004Obj.
  ///
  /// In en, this message translates to:
  /// **'Stop the tomb robbers before they break the wrong seal in the Valdris ruins.'**
  String get questR004Obj;

  /// No description provided for @questR005Title.
  ///
  /// In en, this message translates to:
  /// **'The Restless Dead'**
  String get questR005Title;

  /// No description provided for @questR005Desc.
  ///
  /// In en, this message translates to:
  /// **'Skeletons patrol the Valdris ruin corridors at night. They wear armor from the kingdom that once stood here â€” armor that should have rusted to nothing centuries ago.'**
  String get questR005Desc;

  /// No description provided for @questR005Obj.
  ///
  /// In en, this message translates to:
  /// **'Find the source of the undead patrols in the Valdris corridors and put them to rest.'**
  String get questR005Obj;

  /// No description provided for @questR006Title.
  ///
  /// In en, this message translates to:
  /// **'The Sealed Library'**
  String get questR006Title;

  /// No description provided for @questR006Desc.
  ///
  /// In en, this message translates to:
  /// **'A sealed library was found in the Valdris ruins. Scholar Veyra says the door responds to touch â€” it\'s warm, and the metal vibrates as if something on the other side is breathing.'**
  String get questR006Desc;

  /// No description provided for @questR006Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter the sealed library in the Valdris ruins and retrieve what lies within.'**
  String get questR006Obj;

  /// No description provided for @questR007Title.
  ///
  /// In en, this message translates to:
  /// **'The Whispering Halls'**
  String get questR007Title;

  /// No description provided for @questR007Desc.
  ///
  /// In en, this message translates to:
  /// **'The lower ruins hum with a low, maddening drone. Those who linger too long begin speaking in dead languages. Historian Korval attributes it to \"residual enchantment.\" Scholar Veyra is less certain.'**
  String get questR007Desc;

  /// No description provided for @questR007Obj.
  ///
  /// In en, this message translates to:
  /// **'Find what creates the maddening hum in the lower Valdris halls and silence it.'**
  String get questR007Obj;

  /// No description provided for @questR008Title.
  ///
  /// In en, this message translates to:
  /// **'The Grey Sentinels'**
  String get questR008Title;

  /// No description provided for @questR008Desc.
  ///
  /// In en, this message translates to:
  /// **'Explorers report seeing tall, gaunt figures standing motionless in the lower corridors â€” ash-grey skin, angular bones, hollow eyes. They do not respond to speech. They attack without warning when approached too closely.'**
  String get questR008Desc;

  /// No description provided for @questR008Obj.
  ///
  /// In en, this message translates to:
  /// **'Investigate the mysterious grey figures in the deeper Valdris ruins.'**
  String get questR008Obj;

  /// No description provided for @questR009Title.
  ///
  /// In en, this message translates to:
  /// **'The Cursed Vault'**
  String get questR009Title;

  /// No description provided for @questR009Desc.
  ///
  /// In en, this message translates to:
  /// **'A vault deeper in the Valdris ruins is leaking dark energy. People nearby sleepwalk toward the entrance. Historian Korval says the artifacts inside predate Valdris by centuries â€” which should be impossible.'**
  String get questR009Desc;

  /// No description provided for @questR009Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter the Valdris vault and destroy the cursed artifact collection.'**
  String get questR009Obj;

  /// No description provided for @questR010Title.
  ///
  /// In en, this message translates to:
  /// **'Plague Crypt'**
  String get questR010Title;

  /// No description provided for @questR010Desc.
  ///
  /// In en, this message translates to:
  /// **'An undead caravan emerged from beneath the Valdris ruins. The plague they carry turns flesh grey â€” the same grey as the silent sentinels deeper inside.'**
  String get questR010Desc;

  /// No description provided for @questR010Obj.
  ///
  /// In en, this message translates to:
  /// **'Descend into the crypt beneath the ruins and seal the source of the walking plague.'**
  String get questR010Obj;

  /// No description provided for @questR011Title.
  ///
  /// In en, this message translates to:
  /// **'The Shadow Stalker'**
  String get questR011Title;

  /// No description provided for @questR011Desc.
  ///
  /// In en, this message translates to:
  /// **'A shadowy assassin stalks a merchant who ventured into the Valdris ruins looking for treasure. Three guards are dead â€” killed by something that moved through the walls as if they weren\'t there.'**
  String get questR011Desc;

  /// No description provided for @questR011Obj.
  ///
  /// In en, this message translates to:
  /// **'Track the shadowy assassin through the ruins and protect the merchant.'**
  String get questR011Obj;

  /// No description provided for @questR012Title.
  ///
  /// In en, this message translates to:
  /// **'The Looping Corridor'**
  String get questR012Title;

  /// No description provided for @questR012Desc.
  ///
  /// In en, this message translates to:
  /// **'Scholar Veyra sent a team into the mid-depth ruins. They returned three days later â€” insisting only an hour had passed. They say every corridor led back to the same room. One of them drew a map. The map is impossible.'**
  String get questR012Desc;

  /// No description provided for @questR012Obj.
  ///
  /// In en, this message translates to:
  /// **'Navigate the looping corridors in the deep Valdris ruins and find out what\'s causing the spatial distortion.'**
  String get questR012Obj;

  /// No description provided for @questR013Title.
  ///
  /// In en, this message translates to:
  /// **'The Tithebound Awakening'**
  String get questR013Title;

  /// No description provided for @questR013Desc.
  ///
  /// In en, this message translates to:
  /// **'A Tithebound was captured alive â€” a first. It sits in a cage at Korval\'s camp, rocking and murmuring broken phrases. Then it said something clearly: \"They are coming back.\" It hasn\'t spoken since.'**
  String get questR013Desc;

  /// No description provided for @questR013Obj.
  ///
  /// In en, this message translates to:
  /// **'Descend into the deeper ruins and investigate what the captured Tithebound meant.'**
  String get questR013Obj;

  /// No description provided for @questR014Title.
  ///
  /// In en, this message translates to:
  /// **'The Sunken Sanctum'**
  String get questR014Title;

  /// No description provided for @questR014Desc.
  ///
  /// In en, this message translates to:
  /// **'A temple lies half-submerged in the flooded lower ruins. Valdris builders shouldn\'t have built this deep â€” unless the ruins go further down than anyone believed.'**
  String get questR014Desc;

  /// No description provided for @questR014Obj.
  ///
  /// In en, this message translates to:
  /// **'Dive into the flooded sanctum and stop whatever is stirring below.'**
  String get questR014Obj;

  /// No description provided for @questR015Title.
  ///
  /// In en, this message translates to:
  /// **'The Cult of Valdris'**
  String get questR015Title;

  /// No description provided for @questR015Desc.
  ///
  /// In en, this message translates to:
  /// **'A cult has formed among the ruin-obsessed â€” mortals who believe Valdris was taken, not destroyed, and that they can follow it wherever it went. They\'ve consecrated a blood altar in the throne room.'**
  String get questR015Desc;

  /// No description provided for @questR015Obj.
  ///
  /// In en, this message translates to:
  /// **'Destroy the cult\'s blood altar in the Valdris throne room before their ritual completes.'**
  String get questR015Obj;

  /// No description provided for @questR016Title.
  ///
  /// In en, this message translates to:
  /// **'The Wrong Room'**
  String get questR016Title;

  /// No description provided for @questR016Desc.
  ///
  /// In en, this message translates to:
  /// **'A mapping team found a room that shouldn\'t exist. It\'s not on any plan. The door was sealed from the inside. When they opened it, one of them said, \"This room is bigger than the building it\'s in.\" He was right.'**
  String get questR016Desc;

  /// No description provided for @questR016Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter the impossible room in the Valdris ruins and survive what\'s inside.'**
  String get questR016Obj;

  /// No description provided for @questR017Title.
  ///
  /// In en, this message translates to:
  /// **'The Tithebound War'**
  String get questR017Title;

  /// No description provided for @questR017Desc.
  ///
  /// In en, this message translates to:
  /// **'The Tithebound have split into two factions in the deep ruins. One group attacks anyone who enters. The other stands at the edges, watching, making no move to stop them â€” or help. Something has changed below.'**
  String get questR017Desc;

  /// No description provided for @questR017Obj.
  ///
  /// In en, this message translates to:
  /// **'Navigate the Tithebound conflict in the deep ruins and reach the lowest accessible chamber.'**
  String get questR017Obj;

  /// No description provided for @questR018Title.
  ///
  /// In en, this message translates to:
  /// **'The Sound Returns'**
  String get questR018Title;

  /// No description provided for @questR018Desc.
  ///
  /// In en, this message translates to:
  /// **'The hum that scholars dismissed has become a sound â€” a layered, shifting noise that strips the edges off your thoughts. Scholar Veyra can no longer enter the deep ruins. She says she forgot her own name for three seconds and that was enough.'**
  String get questR018Desc;

  /// No description provided for @questR018Obj.
  ///
  /// In en, this message translates to:
  /// **'Descend into the deepest ruins where the sound is loudest and discover its source.'**
  String get questR018Obj;

  /// No description provided for @questR019Title.
  ///
  /// In en, this message translates to:
  /// **'The Elder\'s Confession'**
  String get questR019Title;

  /// No description provided for @questR019Desc.
  ///
  /// In en, this message translates to:
  /// **'A Tithebound elder â€” more aware than any encountered before â€” has approached the surface camp. She speaks in halting but complete sentences. She says she remembers what happened to her people. She wants to tell someone before the Choir takes it.'**
  String get questR019Desc;

  /// No description provided for @questR019Obj.
  ///
  /// In en, this message translates to:
  /// **'Protect the aware Tithebound elder while she speaks, and learn what happened to her species.'**
  String get questR019Obj;

  /// No description provided for @questR020Title.
  ///
  /// In en, this message translates to:
  /// **'Through the Choir'**
  String get questR020Title;

  /// No description provided for @questR020Desc.
  ///
  /// In en, this message translates to:
  /// **'The Severance wound is open. The Nameless Choir fills the deepest chamber â€” a sound that strips everything. Beyond it, through the tear, towers of pale stone are visible. Valdris was not destroyed. It was taken. The player can see it.'**
  String get questR020Desc;

  /// No description provided for @questR020Obj.
  ///
  /// In en, this message translates to:
  /// **'Pass through the Nameless Choir and enter the folded dimension of Valdris.'**
  String get questR020Obj;

  /// No description provided for @questR021Title.
  ///
  /// In en, this message translates to:
  /// **'The Living Kingdom'**
  String get questR021Title;

  /// No description provided for @questR021Desc.
  ///
  /// In en, this message translates to:
  /// **'Valdris is alive. The streets are paved in dark glass that reflects no stars. Citizens move in slow processions, smiling too wide, repeating the same words. The architecture bends at the edges. Something is deeply, fundamentally wrong.'**
  String get questR021Desc;

  /// No description provided for @questR021Obj.
  ///
  /// In en, this message translates to:
  /// **'Explore the folded kingdom of Valdris and understand what happened to its people.'**
  String get questR021Obj;

  /// No description provided for @questR022Title.
  ///
  /// In en, this message translates to:
  /// **'The Throne That Knows Your Name'**
  String get questR022Title;

  /// No description provided for @questR022Desc.
  ///
  /// In en, this message translates to:
  /// **'The throne room is always visible from any street, as though the city curves inward toward it. Something sits on the throne. It wears a crown. It is not a king. It knows the player\'s name.'**
  String get questR022Desc;

  /// No description provided for @questR022Obj.
  ///
  /// In en, this message translates to:
  /// **'Enter the throne room of Valdris and confront whatever rules the folded kingdom.'**
  String get questR022Obj;

  /// No description provided for @questR023Title.
  ///
  /// In en, this message translates to:
  /// **'The Severance Undone'**
  String get questR023Title;

  /// No description provided for @questR023Desc.
  ///
  /// In en, this message translates to:
  /// **'The throne entity has been defied. The kingdom trembles. The Choir screams. The dimensional wound that created this prison is destabilizing â€” if it collapses with the player inside, they are trapped in Valdris forever. But if the wound can be forced wider, Valdris might return to the real world.'**
  String get questR023Desc;

  /// No description provided for @questR023Obj.
  ///
  /// In en, this message translates to:
  /// **'Escape the folding Valdris dimension before the Severance wound closes â€” or find a way to break the Severance entirely.'**
  String get questR023Obj;

  /// No description provided for @itemWpn001Name.
  ///
  /// In en, this message translates to:
  /// **'Sundering Shard Knife'**
  String get itemWpn001Name;

  /// No description provided for @itemWpn001Desc.
  ///
  /// In en, this message translates to:
  /// **'A crude knife chipped from stone that fell during the war of the Firstborn Gods. It hums faintly when held â€” an echo of the blow that cracked reality itself.'**
  String get itemWpn001Desc;

  /// No description provided for @itemWpn002Name.
  ///
  /// In en, this message translates to:
  /// **'Thornveil Stalker Bow'**
  String get itemWpn002Name;

  /// No description provided for @itemWpn002Desc.
  ///
  /// In en, this message translates to:
  /// **'A short hunting bow of living thornwood, its limbs still bearing green buds that never bloom. The Thornveil gives these willingly to mortal stalkers it tolerates â€” the string hums a note only forest creatures hear, and they run.'**
  String get itemWpn002Desc;

  /// No description provided for @itemWpn003Name.
  ///
  /// In en, this message translates to:
  /// **'Hollows Warden Blade'**
  String get itemWpn003Name;

  /// No description provided for @itemWpn003Desc.
  ///
  /// In en, this message translates to:
  /// **'A short, broad-bladed sword of dark iron etched with glowing warden runes along the fuller. Carried by miners who work the upper Hollows â€” where the things in the dark require more than a lantern.'**
  String get itemWpn003Desc;

  /// No description provided for @itemWpn004Name.
  ///
  /// In en, this message translates to:
  /// **'Tithebound Ritual Blade'**
  String get itemWpn004Name;

  /// No description provided for @itemWpn004Desc.
  ///
  /// In en, this message translates to:
  /// **'A long, thin blade of grey metal carried by the Tithebound â€” the ash-skinned wardens who patrol the Valdris ruins in loops they cannot explain. This one was dropped by a sentinel who stopped mid-patrol and simply forgot how to move.'**
  String get itemWpn004Desc;

  /// No description provided for @itemWpn005Name.
  ///
  /// In en, this message translates to:
  /// **'Hollow-Touched Falchion'**
  String get itemWpn005Name;

  /// No description provided for @itemWpn005Desc.
  ///
  /// In en, this message translates to:
  /// **'A blade left too long near a wound in reality where the Hollow seeps through. The void-stuff has eaten into the steel, making it lighter and impossibly sharp â€” but the metal crumbles a little more each day.'**
  String get itemWpn005Desc;

  /// No description provided for @itemWpn006Name.
  ///
  /// In en, this message translates to:
  /// **'Pale Root Whisper Crossbow'**
  String get itemWpn006Name;

  /// No description provided for @itemWpn006Desc.
  ///
  /// In en, this message translates to:
  /// **'A compact crossbow of bleached white wood, its rail inlaid with crushed petals that deaden all sound. The Pale Root use these from the High Canopy â€” two lords fell before anyone heard the bolt. The Verdant Court pretends these don\'t exist.'**
  String get itemWpn006Desc;

  /// No description provided for @itemWpn007Name.
  ///
  /// In en, this message translates to:
  /// **'Warden-Craft Halberd'**
  String get itemWpn007Name;

  /// No description provided for @itemWpn007Desc.
  ///
  /// In en, this message translates to:
  /// **'Forged using techniques inherited through the Rite of Grafting â€” patterns no living mind devised, hammered from memory stored in dead wardens\' bones. The rune sequence along the shaft matches a binding prayer that sealed something in the mid-depths.'**
  String get itemWpn007Desc;

  /// No description provided for @itemWpn008Name.
  ///
  /// In en, this message translates to:
  /// **'Morvaine\'s Staff-Blade'**
  String get itemWpn008Name;

  /// No description provided for @itemWpn008Desc.
  ///
  /// In en, this message translates to:
  /// **'The walking staff of Morvaine, the apprentice whose pursuit of lichdom shattered Valdris from within â€” or so the histories claim. The wood is petrified, and the crystal at its head shows a kingdom that looks nothing like ruins.'**
  String get itemWpn008Desc;

  /// No description provided for @itemWpn009Name.
  ///
  /// In en, this message translates to:
  /// **'Death\'s Tithe'**
  String get itemWpn009Name;

  /// No description provided for @itemWpn009Desc.
  ///
  /// In en, this message translates to:
  /// **'A scythe that belonged to no reaper â€” it simply appeared where Death had recently passed. Death is eldest of the three surviving gods, walks both worlds freely, and answers to no prayer. This blade carries that same cold indifference.'**
  String get itemWpn009Desc;

  /// No description provided for @itemWpn010Name.
  ///
  /// In en, this message translates to:
  /// **'Sinew of the World Tree'**
  String get itemWpn010Name;

  /// No description provided for @itemWpn010Desc.
  ///
  /// In en, this message translates to:
  /// **'A longbow strung with root-fiber from the World Tree itself â€” the miles-high titan whose roots pierce the underworld. Arrows fired from this bow bend toward living things, as if the Tree still hungers for what grows beyond its reach.'**
  String get itemWpn010Desc;

  /// No description provided for @itemWpn011Name.
  ///
  /// In en, this message translates to:
  /// **'Forge Spirit\'s Greathammer'**
  String get itemWpn011Name;

  /// No description provided for @itemWpn011Desc.
  ///
  /// In en, this message translates to:
  /// **'A hammer that radiates heat from the core of the world. The Forge Spirit who tends the ancient bindings used this to repair ward-stones â€” and to crush anything that emerged when those repairs came too late.'**
  String get itemWpn011Desc;

  /// No description provided for @itemWpn012Name.
  ///
  /// In en, this message translates to:
  /// **'Severance Edge'**
  String get itemWpn012Name;

  /// No description provided for @itemWpn012Desc.
  ///
  /// In en, this message translates to:
  /// **'A blade forged from the dark glass that paves the streets of Valdris â€” not the ruins, but the living kingdom folded into a dimension that should not exist. The glass reflects corridors you\'ve never walked and a sky with no stars.'**
  String get itemWpn012Desc;

  /// No description provided for @itemWpn013Name.
  ///
  /// In en, this message translates to:
  /// **'Seylith\'s Bloom Arc'**
  String get itemWpn013Name;

  /// No description provided for @itemWpn013Desc.
  ///
  /// In en, this message translates to:
  /// **'A ceremonial bow grown in the World Tree\'s root-hollows during the Bloom Rite â€” the trial that determines Vaelithi succession. Its string sprouts thorn-arrows on its own. Queen Seylith drew this arc for four centuries. It has never missed.'**
  String get itemWpn013Desc;

  /// No description provided for @itemWpn014Name.
  ///
  /// In en, this message translates to:
  /// **'Deep Mother\'s Fang'**
  String get itemWpn014Name;

  /// No description provided for @itemWpn014Desc.
  ///
  /// In en, this message translates to:
  /// **'A stalactite ripped from directly above the Heart of the Mountain â€” the living organ of stone and magma that beats in the deepest Hollows. Some scholars believe it is the Deep Mother\'s own heart. This fang still drips with molten spite.'**
  String get itemWpn014Desc;

  /// No description provided for @itemWpn015Name.
  ///
  /// In en, this message translates to:
  /// **'Azrathar\'s Covenant Blade'**
  String get itemWpn015Name;

  /// No description provided for @itemWpn015Desc.
  ///
  /// In en, this message translates to:
  /// **'The weapon the demon Azrathar once offered Valdris in exchange for passage into the mortal world. The histories blame Azrathar for the kingdom\'s fall â€” but the blade was never used. Whatever destroyed Valdris was not a demon. It was something far worse.'**
  String get itemWpn015Desc;

  /// No description provided for @itemArm001Name.
  ///
  /// In en, this message translates to:
  /// **'Sundering-Cloth Wrap'**
  String get itemArm001Name;

  /// No description provided for @itemArm001Desc.
  ///
  /// In en, this message translates to:
  /// **'Strips of ancient fabric salvaged from a battlefield older than any kingdom. The cloth was woven before the Firstborn Gods warred â€” when creation was still one piece.'**
  String get itemArm001Desc;

  /// No description provided for @itemArm002Name.
  ///
  /// In en, this message translates to:
  /// **'Smuggler\'s Tunnel Leathers'**
  String get itemArm002Name;

  /// No description provided for @itemArm002Desc.
  ///
  /// In en, this message translates to:
  /// **'Hardened leather stitched by the smugglers who run contraband through the upper Hollows by torchlight. Stained with bioluminescent fungal residue that never quite washes out.'**
  String get itemArm002Desc;

  /// No description provided for @itemArm003Name.
  ///
  /// In en, this message translates to:
  /// **'Thornveil Bark Cuirass'**
  String get itemArm003Name;

  /// No description provided for @itemArm003Desc.
  ///
  /// In en, this message translates to:
  /// **'A chestplate shaped from fallen bark of the Thornveil. The forest gave this wood freely â€” a tree struck by lightning, already dead. Even in death, the bark resists rot with stubborn, living defiance.'**
  String get itemArm003Desc;

  /// No description provided for @itemArm004Name.
  ///
  /// In en, this message translates to:
  /// **'Valdris Grave-Scavenger\'s Coat'**
  String get itemArm004Name;

  /// No description provided for @itemArm004Desc.
  ///
  /// In en, this message translates to:
  /// **'Patched leather worn by those foolish enough to loot the upper ruins of Valdris. Every pocket rattles with pilfered trinkets that whisper when the wind is wrong. Scholar Veyra condemns scavengers. They wear her disapproval like a badge.'**
  String get itemArm004Desc;

  /// No description provided for @itemArm005Name.
  ///
  /// In en, this message translates to:
  /// **'Hollow-Scarred Plate'**
  String get itemArm005Name;

  /// No description provided for @itemArm005Desc.
  ///
  /// In en, this message translates to:
  /// **'Steel plate warped by proximity to the Hollow â€” the void-corruption that seeps through reality\'s cracks. The metal bends at angles that shouldn\'t hold, yet the armor is lighter and harder than any forge could make it.'**
  String get itemArm005Desc;

  /// No description provided for @itemArm006Name.
  ///
  /// In en, this message translates to:
  /// **'Ossborn Grafted Shell'**
  String get itemArm006Name;

  /// No description provided for @itemArm006Desc.
  ///
  /// In en, this message translates to:
  /// **'Armor assembled from shed bone-plates of the Ossborn â€” the eyeless monks who carry dead wardens\' memories in their fused skeletons. Each plate hums with a different frequency, as if remembering a different voice.'**
  String get itemArm006Desc;

  /// No description provided for @itemArm007Name.
  ///
  /// In en, this message translates to:
  /// **'Verdant Court Ceremonial Mail'**
  String get itemArm007Name;

  /// No description provided for @itemArm007Desc.
  ///
  /// In en, this message translates to:
  /// **'Chainmail of green-gold alloy, each ring shaped like a tiny leaf. Worn by the twelve High Canopy lords of Vaelith\'s Verdant Court â€” before two were assassinated by the Pale Root. This set belonged to one of the fallen.'**
  String get itemArm007Desc;

  /// No description provided for @itemArm008Name.
  ///
  /// In en, this message translates to:
  /// **'Tithebound Sentinel Plate'**
  String get itemArm008Name;

  /// No description provided for @itemArm008Desc.
  ///
  /// In en, this message translates to:
  /// **'Chitinous armor grown â€” not forged â€” by Tithebound sentinels in the deep ruins. Made from their own shed skin, layered over centuries. Ash-grey and warm to the touch, as if something inside it still remembers being alive.'**
  String get itemArm008Desc;

  /// No description provided for @itemArm009Name.
  ///
  /// In en, this message translates to:
  /// **'Radiant One\'s Blessed Mail'**
  String get itemArm009Name;

  /// No description provided for @itemArm009Desc.
  ///
  /// In en, this message translates to:
  /// **'Plate armor blessed by clerics who maintain the binding seals in the Radiant One\'s name. The god who forged the sun declared dominion over the surface world â€” this armor carries that decree hammered into every rivet.'**
  String get itemArm009Desc;

  /// No description provided for @itemArm010Name.
  ///
  /// In en, this message translates to:
  /// **'Deep Mother\'s Carapace'**
  String get itemArm010Name;

  /// No description provided for @itemArm010Desc.
  ///
  /// In en, this message translates to:
  /// **'Chitin harvested from creatures born too close to the Heart of the Mountain. The Deep Mother burrowed into the earth\'s core and claimed all beneath stone â€” these shells carry her territorial fury, hardening under pressure.'**
  String get itemArm010Desc;

  /// No description provided for @itemArm011Name.
  ///
  /// In en, this message translates to:
  /// **'Thornwall Living Armor'**
  String get itemArm011Name;

  /// No description provided for @itemArm011Desc.
  ///
  /// In en, this message translates to:
  /// **'A suit grown from a fragment of the Thornwall itself â€” the enchanted barrier of briar that seals Vaelith from the mortal world. Humans who cross the Thornwall don\'t come back. This armor was pried from the wall\'s edge, and it has not stopped growing.'**
  String get itemArm011Desc;

  /// No description provided for @itemArm012Name.
  ///
  /// In en, this message translates to:
  /// **'Death\'s Walking Shroud'**
  String get itemArm012Name;

  /// No description provided for @itemArm012Desc.
  ///
  /// In en, this message translates to:
  /// **'A cloak of absolute black that weighs nothing and fits everyone. Death is eldest of the three surviving gods and walks both worlds freely. This shroud once draped something that stood in Death\'s shadow â€” and the shadow never quite left it.'**
  String get itemArm012Desc;

  /// No description provided for @itemArm013Name.
  ///
  /// In en, this message translates to:
  /// **'Court Arcanist\'s Vestments'**
  String get itemArm013Name;

  /// No description provided for @itemArm013Desc.
  ///
  /// In en, this message translates to:
  /// **'Robes worn by the Valdris Court Arcanists who cast the Severance â€” the spell that pulled an entire kingdom into a folded dimension. The Arcanists were consumed by their own working. The robes remember the incantation in every threaded sigil.'**
  String get itemArm013Desc;

  /// No description provided for @itemArm014Name.
  ///
  /// In en, this message translates to:
  /// **'Titan\'s Binding Plate'**
  String get itemArm014Name;

  /// No description provided for @itemArm014Desc.
  ///
  /// In en, this message translates to:
  /// **'Armor forged from the actual chains that bound a titan in the mid-depths during the Sundering. The titan still slumbers beneath â€” and the chains still tighten when something stirs in its prison. Wearing them, you feel the weight of holding a god in place.'**
  String get itemArm014Desc;

  /// No description provided for @itemArm015Name.
  ///
  /// In en, this message translates to:
  /// **'Netherveil of the Folded Kingdom'**
  String get itemArm015Name;

  /// No description provided for @itemArm015Desc.
  ///
  /// In en, this message translates to:
  /// **'A garment woven from the membrane between the mortal world and the folded dimension where Valdris still lives. It smells of still air from a kingdom where time loops, and bends around the wearer like reality bending to avoid the Severance.'**
  String get itemArm015Desc;

  /// No description provided for @itemAcc001Name.
  ///
  /// In en, this message translates to:
  /// **'Cracked Binding Seal'**
  String get itemAcc001Name;

  /// No description provided for @itemAcc001Desc.
  ///
  /// In en, this message translates to:
  /// **'A palm-sized fragment of a ward-stone, worn as a pendant. Clerics maintain these seals across the world â€” this one cracked, and whatever it held is long gone. A reminder that the world needs holding together, one broken seal at a time.'**
  String get itemAcc001Desc;

  /// No description provided for @itemAcc002Name.
  ///
  /// In en, this message translates to:
  /// **'Fey Pact Charm'**
  String get itemAcc002Name;

  /// No description provided for @itemAcc002Desc.
  ///
  /// In en, this message translates to:
  /// **'A twisted knot of silver wire and dried petals, given by Fey Court sprites in exchange for a secret. The pact is simple: carry this, and the old trickster-spirits will only trick you gently. When the pacts fray, even this won\'t help.'**
  String get itemAcc002Desc;

  /// No description provided for @itemAcc003Name.
  ///
  /// In en, this message translates to:
  /// **'Bioluminescent Fungal Lantern'**
  String get itemAcc003Name;

  /// No description provided for @itemAcc003Desc.
  ///
  /// In en, this message translates to:
  /// **'A caged cluster of cavern fungi that glow with the Deep Mother\'s ambient influence. Miners prize these over torches â€” they never go out, and they pulse faster when something watches from the dark.'**
  String get itemAcc003Desc;

  /// No description provided for @itemAcc004Name.
  ///
  /// In en, this message translates to:
  /// **'Korval\'s Research Pendant'**
  String get itemAcc004Name;

  /// No description provided for @itemAcc004Desc.
  ///
  /// In en, this message translates to:
  /// **'A brass locket containing a fragment of Historian Korval\'s notes on Valdris architecture â€” specifically, his confused observations about rooms that seem larger inside than out. He attributed it to residual enchantment. He was wrong.'**
  String get itemAcc004Desc;

  /// No description provided for @itemAcc005Name.
  ///
  /// In en, this message translates to:
  /// **'Hollow Void Amulet'**
  String get itemAcc005Name;

  /// No description provided for @itemAcc005Desc.
  ///
  /// In en, this message translates to:
  /// **'A gemstone with a hole in it â€” not a physical hole, but an absence where the Hollow has unmade the crystal\'s center. Light bends around the gap. Staring into it too long makes you forget what you were looking at.'**
  String get itemAcc005Desc;

  /// No description provided for @itemAcc006Name.
  ///
  /// In en, this message translates to:
  /// **'Circle of Thorn Signet'**
  String get itemAcc006Name;

  /// No description provided for @itemAcc006Desc.
  ///
  /// In en, this message translates to:
  /// **'A ring of living wood worn by druids of the Circle of Thorn â€” mediators between mortal and Fey. Their numbers thin each decade. This signet still channels the old pacts, though fewer answer its call.'**
  String get itemAcc006Desc;

  /// No description provided for @itemAcc007Name.
  ///
  /// In en, this message translates to:
  /// **'Ossborn Memory Fragment'**
  String get itemAcc007Name;

  /// No description provided for @itemAcc007Desc.
  ///
  /// In en, this message translates to:
  /// **'A bone shard from an Ossborn elder â€” a piece that fell during the Rite of Grafting. It carries a single warden memory: the exact rune sequence that held a specific prison sealed for three thousand years. The sequence plays in your dreams.'**
  String get itemAcc007Desc;

  /// No description provided for @itemAcc008Name.
  ///
  /// In en, this message translates to:
  /// **'Tithebound Resonance Stone'**
  String get itemAcc008Name;

  /// No description provided for @itemAcc008Desc.
  ///
  /// In en, this message translates to:
  /// **'A smooth grey stone that vibrates at the same frequency as the Tithebound\'s hollow eyes. When held, you hear what they hear â€” a faint sound from deep beneath the ruins that shapes itself into what you most desire. It is not a calling. It is bait.'**
  String get itemAcc008Desc;

  /// No description provided for @itemAcc009Name.
  ///
  /// In en, this message translates to:
  /// **'Death\'s Walking Band'**
  String get itemAcc009Name;

  /// No description provided for @itemAcc009Desc.
  ///
  /// In en, this message translates to:
  /// **'A ring of bone-white metal, featureless and cold. Death walks both worlds freely and answers to no prayer â€” but Death notices those who carry artifacts of the divine. This ring ensures you are noticed in return.'**
  String get itemAcc009Desc;

  /// No description provided for @itemAcc010Name.
  ///
  /// In en, this message translates to:
  /// **'Seylith\'s Moonstone Brooch'**
  String get itemAcc010Name;

  /// No description provided for @itemAcc010Desc.
  ///
  /// In en, this message translates to:
  /// **'A brooch of elvish craft set with a moonstone that holds four centuries of light â€” one for each year of Queen Seylith the Undying\'s reign. The Vaelithi do not part with these. That it exists outside the Thornwall means someone defected or died.'**
  String get itemAcc010Desc;

  /// No description provided for @itemAcc011Name.
  ///
  /// In en, this message translates to:
  /// **'Warden Bone Bracers'**
  String get itemAcc011Name;

  /// No description provided for @itemAcc011Desc.
  ///
  /// In en, this message translates to:
  /// **'Bracers carved from the bones of ancient wardens â€” the originals who chained the titans and sealed the demons. The Ossborn grafted these bones into themselves. These bracers carry what the Ossborn chose not to keep.'**
  String get itemAcc011Desc;

  /// No description provided for @itemAcc012Name.
  ///
  /// In en, this message translates to:
  /// **'Choir Silence Pendant'**
  String get itemAcc012Name;

  /// No description provided for @itemAcc012Desc.
  ///
  /// In en, this message translates to:
  /// **'A pendant that generates a sphere of absolute silence â€” crafted by a Tithebound elder who retained enough awareness to understand what the Nameless Choir does. The silence is not peaceful. It is the absence of the sound that unmakes you.'**
  String get itemAcc012Desc;

  /// No description provided for @itemAcc013Name.
  ///
  /// In en, this message translates to:
  /// **'Firstborn\'s Tear'**
  String get itemAcc013Name;

  /// No description provided for @itemAcc013Desc.
  ///
  /// In en, this message translates to:
  /// **'A crystallized tear shed during the Sundering â€” from which of the three surviving gods, no scholar agrees. The Radiant One wept for the sun. The Deep Mother wept for the earth. Death, eldest of all, does not weep â€” but something fell from its face.'**
  String get itemAcc013Desc;

  /// No description provided for @itemAcc014Name.
  ///
  /// In en, this message translates to:
  /// **'Crown of the Bloom Rite'**
  String get itemAcc014Name;

  /// No description provided for @itemAcc014Desc.
  ///
  /// In en, this message translates to:
  /// **'The crown formed in the root-hollows of the World Tree during the Bloom Rite â€” Vaelithi succession\'s ultimate trial. Candidates descend and return changed, or don\'t return at all. This crown was found beside someone who didn\'t return.'**
  String get itemAcc014Desc;

  /// No description provided for @itemAcc015Name.
  ///
  /// In en, this message translates to:
  /// **'Eye of the Deep Mother'**
  String get itemAcc015Name;

  /// No description provided for @itemAcc015Desc.
  ///
  /// In en, this message translates to:
  /// **'Not a metaphor. Not a gem shaped like an eye. An eye â€” milky white, the size of a fist, warm and wet, and it blinks. Pulled from a crevice near the Heart of the Mountain where the rock thinned enough to see through. The Deep Mother sees through it still.'**
  String get itemAcc015Desc;

  /// No description provided for @itemRel001Name.
  ///
  /// In en, this message translates to:
  /// **'Fractured Binding Seal'**
  String get itemRel001Name;

  /// No description provided for @itemRel001Desc.
  ///
  /// In en, this message translates to:
  /// **'A broken ward-stone â€” one of thousands scattered across the crumbling ancient prisons. Druids tend the World Tree\'s roots, clerics maintain the binding seals, and heroes carry blades into the dark. You carry a piece of what they\'re all fighting to hold together.'**
  String get itemRel001Desc;

  /// No description provided for @itemRel002Name.
  ///
  /// In en, this message translates to:
  /// **'Hollows Bioluminescent Spore'**
  String get itemRel002Name;

  /// No description provided for @itemRel002Desc.
  ///
  /// In en, this message translates to:
  /// **'A living fungal cluster from the upper Hollows, pulsing with the Deep Mother\'s ambient influence. It lights dark places with a sickly green glow and recoils from heat, as if the Deep Mother disapproves of the Radiant One\'s fire.'**
  String get itemRel002Desc;

  /// No description provided for @itemRel003Name.
  ///
  /// In en, this message translates to:
  /// **'Scholar Veyra\'s Field Journal'**
  String get itemRel003Name;

  /// No description provided for @itemRel003Desc.
  ///
  /// In en, this message translates to:
  /// **'A battered journal belonging to Scholar Veyra, who catalogs the upper Valdris ruins alongside Historian Korval. Her notes are meticulous but confused â€” measurements that contradict themselves, sketches of rooms larger inside than out. She calls it \"residual enchantment.\" She is wrong.'**
  String get itemRel003Desc;

  /// No description provided for @itemRel004Name.
  ///
  /// In en, this message translates to:
  /// **'Thornveil Wisp Lantern'**
  String get itemRel004Name;

  /// No description provided for @itemRel004Desc.
  ///
  /// In en, this message translates to:
  /// **'A cage of living vines containing a captured wisp from the Fey Courts. The old pacts that bind the fey predate even the elves â€” this wisp agreed to serve in exchange for protection from what happens when those pacts finally break.'**
  String get itemRel004Desc;

  /// No description provided for @itemRel005Name.
  ///
  /// In en, this message translates to:
  /// **'Shard of the Hollow'**
  String get itemRel005Name;

  /// No description provided for @itemRel005Desc.
  ///
  /// In en, this message translates to:
  /// **'A crystallized fragment of the Hollow itself â€” void-stuff hardened into something almost physical. It unmakes what it touches slowly: wood greys, metal corrodes, skin numbs. The Hollow spreads not as invasion but as erosion. This is what erosion looks like held in your hand.'**
  String get itemRel005Desc;

  /// No description provided for @itemRel006Name.
  ///
  /// In en, this message translates to:
  /// **'Forge Spirit\'s Ember'**
  String get itemRel006Name;

  /// No description provided for @itemRel006Desc.
  ///
  /// In en, this message translates to:
  /// **'A fragment of living flame from the Forge Spirit â€” the ancient entity that tends the weakening bindings in the Hollows. It considers the Ossborn tools, not allies. It considers you less than that. But the ember burns, and it burns true.'**
  String get itemRel006Desc;

  /// No description provided for @itemRel007Name.
  ///
  /// In en, this message translates to:
  /// **'Valdris Ward-Stone Shard'**
  String get itemRel007Name;

  /// No description provided for @itemRel007Desc.
  ///
  /// In en, this message translates to:
  /// **'A fragment of the protective wards that once shielded Valdris â€” before Morvaine shattered them from within, or Azrathar breached them from without. The histories disagree. This shard hums at a frequency that makes your teeth ache, and sometimes shows a kingdom that looks nothing like ruins.'**
  String get itemRel007Desc;

  /// No description provided for @itemRel008Name.
  ///
  /// In en, this message translates to:
  /// **'World Tree Root Heart'**
  String get itemRel008Name;

  /// No description provided for @itemRel008Desc.
  ///
  /// In en, this message translates to:
  /// **'A gnarled heartwood node from deep within the World Tree\'s root system â€” where the roots pierce the underworld. Something stirs in those root-hollows that the Vaelithi will not name: a blight that withers their trees from the inside. This heart still pulses with life, but the edges are grey.'**
  String get itemRel008Desc;

  /// No description provided for @itemRel009Name.
  ///
  /// In en, this message translates to:
  /// **'Devourer\'s Prison Keystone'**
  String get itemRel009Name;

  /// No description provided for @itemRel009Desc.
  ///
  /// In en, this message translates to:
  /// **'A keystone from the deepest vault in the Hollows â€” the prison that holds the Devourer, something that predates even the gods. The Forge Spirit tends this binding above all others. The Ossborn refuse to approach it. The keystone is warm, and if you press your ear to it, you hear breathing.'**
  String get itemRel009Desc;

  /// No description provided for @itemRel010Name.
  ///
  /// In en, this message translates to:
  /// **'Titan\'s Shackle Link'**
  String get itemRel010Name;

  /// No description provided for @itemRel010Desc.
  ///
  /// In en, this message translates to:
  /// **'A single link from the chains forged during the Sundering to bind the titans in their prisons. The chains were made to hold gods. A single link still carries that purpose â€” when held, you feel the weight of holding something immeasurably powerful in place.'**
  String get itemRel010Desc;

  /// No description provided for @itemRel011Name.
  ///
  /// In en, this message translates to:
  /// **'Nameless Choir Echo'**
  String get itemRel011Name;

  /// No description provided for @itemRel011Desc.
  ///
  /// In en, this message translates to:
  /// **'A tuning fork that vibrates at the exact frequency of the Nameless Choir â€” the sound a dimensional wound makes when it refuses to close. Prolonged exposure strips memory: first small things, then larger ones. Holding this, you hear the first note. It sounds like something you forgot.'**
  String get itemRel011Desc;

  /// No description provided for @itemRel012Name.
  ///
  /// In en, this message translates to:
  /// **'Heart of the Verdant Court'**
  String get itemRel012Name;

  /// No description provided for @itemRel012Desc.
  ///
  /// In en, this message translates to:
  /// **'The emerald core of Vaelith\'s governance â€” a living gemstone grown within the throne of the Verdant Court over centuries. It contains the accumulated will of every Vaelithi monarch who passed the Bloom Rite. Queen Seylith sat beside it for four hundred years. The gem remembers every one of them.'**
  String get itemRel012Desc;

  /// No description provided for @itemRel013Name.
  ///
  /// In en, this message translates to:
  /// **'Deep Mother\'s Heartstone'**
  String get itemRel013Name;

  /// No description provided for @itemRel013Desc.
  ///
  /// In en, this message translates to:
  /// **'A fragment of the Heart of the Mountain itself â€” the living organ of stone and magma that scholars believe is the Deep Mother\'s own heart, still beating after the Sundering. It pulses in your hand with a rhythm slower than any mortal heart, and the ground trembles in sympathy.'**
  String get itemRel013Desc;

  /// No description provided for @itemRel014Name.
  ///
  /// In en, this message translates to:
  /// **'Severance Catalyst'**
  String get itemRel014Name;

  /// No description provided for @itemRel014Desc.
  ///
  /// In en, this message translates to:
  /// **'The crystalline focus through which the Valdris Court Arcanists channeled the Severance â€” the spell that folded an entire kingdom into a dimension that should not exist. The Arcanists were consumed. The catalyst survived. It still wants to fold things.'**
  String get itemRel014Desc;

  /// No description provided for @itemRel015Name.
  ///
  /// In en, this message translates to:
  /// **'The Sundering Wound'**
  String get itemRel015Name;

  /// No description provided for @itemRel015Desc.
  ///
  /// In en, this message translates to:
  /// **'Not an object â€” a scar in reality itself, contained in a sphere of binding glass made by the first wardens. Inside, you see the original wound: the crack the Firstborn Gods tore in creation. It has never healed. The Hollow seeps from wounds like this. Carrying it is carrying the reason the world is broken.'**
  String get itemRel015Desc;

  /// No description provided for @itemSpl001Name.
  ///
  /// In en, this message translates to:
  /// **'Shard Bolt'**
  String get itemSpl001Name;

  /// No description provided for @itemSpl001Desc.
  ///
  /// In en, this message translates to:
  /// **'A jagged bolt of crystallised Sundering energy hurled at the enemy. The fragments hum with the echo of the blow that cracked reality â€” even a sliver carries that ancient violence.'**
  String get itemSpl001Desc;

  /// No description provided for @itemSpl002Name.
  ///
  /// In en, this message translates to:
  /// **'Thornlash'**
  String get itemSpl002Name;

  /// No description provided for @itemSpl002Desc.
  ///
  /// In en, this message translates to:
  /// **'The Thornveil responds to those who speak its old names. This invocation calls a whip of living thorns from the forest floor to lash and bind enemies in barbed vine.'**
  String get itemSpl002Desc;

  /// No description provided for @itemSpl003Name.
  ///
  /// In en, this message translates to:
  /// **'Stoneskin'**
  String get itemSpl003Name;

  /// No description provided for @itemSpl003Desc.
  ///
  /// In en, this message translates to:
  /// **'The deep stone of the Hollows remembers the Warden-craft â€” the old art of binding earth to flesh. This ward coats the caster in a shell of living rock that turns aside blades.'**
  String get itemSpl003Desc;

  /// No description provided for @itemSpl004Name.
  ///
  /// In en, this message translates to:
  /// **'Arcane Missile'**
  String get itemSpl004Name;

  /// No description provided for @itemSpl004Desc.
  ///
  /// In en, this message translates to:
  /// **'The Court Arcanists of Valdris refined raw mana into precise bolts that track their targets through corridors and around cover. The spell is elementary by their standards â€” and devastating by anyone else\'s.'**
  String get itemSpl004Desc;

  /// No description provided for @itemSpl005Name.
  ///
  /// In en, this message translates to:
  /// **'Hollow Drain'**
  String get itemSpl005Name;

  /// No description provided for @itemSpl005Desc.
  ///
  /// In en, this message translates to:
  /// **'A forbidden technique that channels the Hollow\'s hunger. The caster opens a hairline crack between worlds and the void drinks from the enemy\'s life force, returning a fraction to the caster.'**
  String get itemSpl005Desc;

  /// No description provided for @itemSpl006Name.
  ///
  /// In en, this message translates to:
  /// **'Verdant Bloom'**
  String get itemSpl006Name;

  /// No description provided for @itemSpl006Desc.
  ///
  /// In en, this message translates to:
  /// **'A prayer to the World Tree channelled through living wood. Golden-green light blooms around the caster, knitting wounds and purging corruption. The Vaelithi healers called this the Firstbloom â€” the simplest gift the Tree still gives.'**
  String get itemSpl006Desc;

  /// No description provided for @itemSpl007Name.
  ///
  /// In en, this message translates to:
  /// **'Molten Surge'**
  String get itemSpl007Name;

  /// No description provided for @itemSpl007Desc.
  ///
  /// In en, this message translates to:
  /// **'Deep beneath the Hollows, the Forge Spirit still hammers at its eternal anvil. This invocation borrows a breath of its fire â€” liquid stone erupts from the ground in a searing wave that melts armour and flesh alike.'**
  String get itemSpl007Desc;

  /// No description provided for @itemSpl008Name.
  ///
  /// In en, this message translates to:
  /// **'Soul Tithe'**
  String get itemSpl008Name;

  /// No description provided for @itemSpl008Desc.
  ///
  /// In en, this message translates to:
  /// **'The Tithebound of Valdris paid their debts in soul-stuff, not coin. This grim enchantment exacts the same price from an enemy â€” tearing away a sliver of their essence to fuel the caster\'s next strike.'**
  String get itemSpl008Desc;

  /// No description provided for @itemSpl009Name.
  ///
  /// In en, this message translates to:
  /// **'Radiant Judgement'**
  String get itemSpl009Name;

  /// No description provided for @itemSpl009Desc.
  ///
  /// In en, this message translates to:
  /// **'A column of searing light called down in the Radiant One\'s name. The Firstborn God of light may be diminished, but this echo of divine wrath still burns â€” especially against creatures of the Hollow.'**
  String get itemSpl009Desc;

  /// No description provided for @itemSpl010Name.
  ///
  /// In en, this message translates to:
  /// **'Fey Mirage'**
  String get itemSpl010Name;

  /// No description provided for @itemSpl010Desc.
  ///
  /// In en, this message translates to:
  /// **'The Fey Courts deal in glamour and misdirection. This charm wraps the caster in layers of illusory doubles that confuse enemies, causing their attacks to strike at phantoms while the real caster moves unseen.'**
  String get itemSpl010Desc;

  /// No description provided for @itemSpl011Name.
  ///
  /// In en, this message translates to:
  /// **'Earthen Maw'**
  String get itemSpl011Name;

  /// No description provided for @itemSpl011Desc.
  ///
  /// In en, this message translates to:
  /// **'The Deep Mother\'s hunger given form. The ground splits open into a jagged maw of stone teeth that clamps shut on the enemy, crushing and trapping them in the earth\'s grip.'**
  String get itemSpl011Desc;

  /// No description provided for @itemSpl012Name.
  ///
  /// In en, this message translates to:
  /// **'Chorus of Unmaking'**
  String get itemSpl012Name;

  /// No description provided for @itemSpl012Desc.
  ///
  /// In en, this message translates to:
  /// **'The Nameless Choir sang the walls of Valdris into existence â€” and their imprisoned echoes still know the counter-melody. This spell unleashes a discordant wail that unravels enchantments, wards, and the will to fight.'**
  String get itemSpl012Desc;

  /// No description provided for @itemSpl013Name.
  ///
  /// In en, this message translates to:
  /// **'Death\'s Whisper'**
  String get itemSpl013Name;

  /// No description provided for @itemSpl013Desc.
  ///
  /// In en, this message translates to:
  /// **'Death in this world is not an ending but a patient collector. This forbidden invocation borrows Death\'s voice for a single syllable â€” a whisper that makes mortal things remember they are mortal. The strong can resist. The weak simply stop.'**
  String get itemSpl013Desc;

  /// No description provided for @itemSpl014Name.
  ///
  /// In en, this message translates to:
  /// **'Severance Rift'**
  String get itemSpl014Name;

  /// No description provided for @itemSpl014Desc.
  ///
  /// In en, this message translates to:
  /// **'A controlled fragment of the Severance â€” the spell that folded the Valdris kingdom into a dimension that should not exist. This tears a brief rift in space that swallows attacks and redirects them back at the attacker.'**
  String get itemSpl014Desc;

  /// No description provided for @itemSpl015Name.
  ///
  /// In en, this message translates to:
  /// **'Worldbreak'**
  String get itemSpl015Name;

  /// No description provided for @itemSpl015Desc.
  ///
  /// In en, this message translates to:
  /// **'The ultimate expression of Sundering magic — a spell that reopens the original wound between worlds for a heartbeat. Reality screams. Everything in the blast radius is touched by the raw stuff of creation and un-creation simultaneously. Nothing survives unchanged.'**
  String get itemSpl015Desc;

  /// No description provided for @itemWpn001Effect.
  ///
  /// In en, this message translates to:
  /// **'Shard Resonance: deals 3% bonus damage near areas corrupted by the Hollow.'**
  String get itemWpn001Effect;

  /// No description provided for @itemWpn002Effect.
  ///
  /// In en, this message translates to:
  /// **'+10% damage against Fey creatures.'**
  String get itemWpn002Effect;

  /// No description provided for @itemWpn003Effect.
  ///
  /// In en, this message translates to:
  /// **'Warden Rune: reveals hidden passages in the Hollows. +5% damage to mineral-based enemies.'**
  String get itemWpn003Effect;

  /// No description provided for @itemWpn004Effect.
  ///
  /// In en, this message translates to:
  /// **'Hollow Strike: 15% chance attacks ignore target\'s defense entirely.'**
  String get itemWpn004Effect;

  /// No description provided for @itemWpn005Effect.
  ///
  /// In en, this message translates to:
  /// **'Void Edge: attacks deal 10% bonus damage. The Hollow hungers through the blade.'**
  String get itemWpn005Effect;

  /// No description provided for @itemWpn006Effect.
  ///
  /// In en, this message translates to:
  /// **'Assassination: critical hits deal 35% bonus damage. +12% crit chance from stealth.'**
  String get itemWpn006Effect;

  /// No description provided for @itemWpn007Effect.
  ///
  /// In en, this message translates to:
  /// **'Binding Strike: 20% chance to immobilize target for 1 turn. Deals double damage to escaped prisoners of the deep.'**
  String get itemWpn007Effect;

  /// No description provided for @itemWpn008Effect.
  ///
  /// In en, this message translates to:
  /// **'Lich\'s Ambition: spell attacks deal 15% bonus damage. On kill, restore 5% max HP.'**
  String get itemWpn008Effect;

  /// No description provided for @itemWpn009Effect.
  ///
  /// In en, this message translates to:
  /// **'Inevitability: ignores 15% of target\'s DEF and magic resistance. Cannot be disarmed.'**
  String get itemWpn009Effect;

  /// No description provided for @itemWpn010Effect.
  ///
  /// In en, this message translates to:
  /// **'Rootbound: arrows entangle targets (−15% AGI for 2 turns). Regenerate 2% HP per turn in forest areas.'**
  String get itemWpn010Effect;

  /// No description provided for @itemWpn011Effect.
  ///
  /// In en, this message translates to:
  /// **'Seal Breaker: attacks shatter magical barriers. +25% damage against bound or sealed enemies.'**
  String get itemWpn011Effect;

  /// No description provided for @itemWpn012Effect.
  ///
  /// In en, this message translates to:
  /// **'Dimensional Cut: ignores 25% DEF and magic resistance. 10% chance to tear reality, dealing AoE damage.'**
  String get itemWpn012Effect;

  /// No description provided for @itemWpn013Effect.
  ///
  /// In en, this message translates to:
  /// **'Undying Bloom: the bow regenerates arrows between battles. Crits cause roots to erupt from wounds, dealing 40% bonus damage over 3 turns.'**
  String get itemWpn013Effect;

  /// No description provided for @itemWpn014Effect.
  ///
  /// In en, this message translates to:
  /// **'Magma Vein: attacks deal 20% bonus fire damage and inflict Burn. Costs 2% max HP per hit, but burn damage heals the wielder.'**
  String get itemWpn014Effect;

  /// No description provided for @itemWpn015Effect.
  ///
  /// In en, this message translates to:
  /// **'Covenant: ignores ALL enemy resistances. On kill, absorb the target\'s strongest stat permanently (+1, stacks up to 20).'**
  String get itemWpn015Effect;

  /// No description provided for @itemArm001Effect.
  ///
  /// In en, this message translates to:
  /// **'Ancestral Thread: reduces physical damage taken by 2%.'**
  String get itemArm001Effect;

  /// No description provided for @itemArm002Effect.
  ///
  /// In en, this message translates to:
  /// **'Cave Runner: +5% evasion in underground areas. Faintly glows in darkness.'**
  String get itemArm002Effect;

  /// No description provided for @itemArm003Effect.
  ///
  /// In en, this message translates to:
  /// **'Forest\'s Memory: reduces damage from plant and fey creatures by 10%.'**
  String get itemArm003Effect;

  /// No description provided for @itemArm004Effect.
  ///
  /// In en, this message translates to:
  /// **'Scavenger\'s Luck: +8% gold drop rate. 5% chance to resist curse effects from Valdris relics.'**
  String get itemArm004Effect;

  /// No description provided for @itemArm005Effect.
  ///
  /// In en, this message translates to:
  /// **'Void Warp: 8% chance to deflect attacks through micro-rifts. Takes 5% extra damage from holy sources.'**
  String get itemArm005Effect;

  /// No description provided for @itemArm006Effect.
  ///
  /// In en, this message translates to:
  /// **'Grafted Memory: immune to confusion effects. 10% chance to reflexively dodge (inherited warden instinct).'**
  String get itemArm006Effect;

  /// No description provided for @itemArm007Effect.
  ///
  /// In en, this message translates to:
  /// **'Courtly Grace: immune to Fear effects. +10% magic resistance. Elvish light reveals hidden foes.'**
  String get itemArm007Effect;

  /// No description provided for @itemArm008Effect.
  ///
  /// In en, this message translates to:
  /// **'Hollow Warden: +15% damage resistance while standing ground. Incoming attacks echo faintly, warning of ambush.'**
  String get itemArm008Effect;

  /// No description provided for @itemArm009Effect.
  ///
  /// In en, this message translates to:
  /// **'Solar Ward: immune to darkness and shadow effects. Regenerate 2% HP per turn in daylight or surface areas.'**
  String get itemArm009Effect;

  /// No description provided for @itemArm010Effect.
  ///
  /// In en, this message translates to:
  /// **'Pressure Skin: DEF increases by 1% for each 10% HP lost. Immune to fire and magma damage.'**
  String get itemArm010Effect;

  /// No description provided for @itemArm011Effect.
  ///
  /// In en, this message translates to:
  /// **'Living Barrier: regenerate 3% max HP per turn. Thorns deal 8% recoil damage to melee attackers.'**
  String get itemArm011Effect;

  /// No description provided for @itemArm012Effect.
  ///
  /// In en, this message translates to:
  /// **'Death\'s Passage: ignore environmental hazards. 15% chance to negate fatal damage and survive with 1 HP.'**
  String get itemArm012Effect;

  /// No description provided for @itemArm013Effect.
  ///
  /// In en, this message translates to:
  /// **'Severance Echo: all spell damage reduced by 20%. Once per battle, cast a ward that absorbs damage equal to 30% max HP.'**
  String get itemArm013Effect;

  /// No description provided for @itemArm014Effect.
  ///
  /// In en, this message translates to:
  /// **'Unyielding Chains: immune to knockback, stun, and forced movement. Reduces all incoming damage by 15%.'**
  String get itemArm014Effect;

  /// No description provided for @itemArm015Effect.
  ///
  /// In en, this message translates to:
  /// **'Dimensional Phase: 20% chance to phase through attacks entirely. Immune to all status effects. Stats grow by 1% per turn in combat (max 15%).'**
  String get itemArm015Effect;

  /// No description provided for @itemAcc001Effect.
  ///
  /// In en, this message translates to:
  /// **'Faint Ward: restores 1% HP per turn.'**
  String get itemAcc001Effect;

  /// No description provided for @itemAcc002Effect.
  ///
  /// In en, this message translates to:
  /// **'Fey Favor: +5% evasion against magical attacks. Wisps ignore the wearer.'**
  String get itemAcc002Effect;

  /// No description provided for @itemAcc003Effect.
  ///
  /// In en, this message translates to:
  /// **'Deep Light: reveals hidden enemies and traps. +5% evasion in underground areas.'**
  String get itemAcc003Effect;

  /// No description provided for @itemAcc004Effect.
  ///
  /// In en, this message translates to:
  /// **'Scholar\'s Eye: reveals enemy weaknesses at battle start. +10% XP from Ruins encounters.'**
  String get itemAcc004Effect;

  /// No description provided for @itemAcc005Effect.
  ///
  /// In en, this message translates to:
  /// **'Void Gaze: spell damage +10%. 5% chance attacks erase one enemy buff.'**
  String get itemAcc005Effect;

  /// No description provided for @itemAcc006Effect.
  ///
  /// In en, this message translates to:
  /// **'Druid\'s Pact: healing effects increased by 15%. Fey creatures will not attack first.'**
  String get itemAcc006Effect;

  /// No description provided for @itemAcc007Effect.
  ///
  /// In en, this message translates to:
  /// **'Inherited Instinct: always act first in the opening turn of battle. +15% evasion against traps.'**
  String get itemAcc007Effect;

  /// No description provided for @itemAcc008Effect.
  ///
  /// In en, this message translates to:
  /// **'Resonance: spell damage +15%. Grants brief precognition — see enemy attacks before they land.'**
  String get itemAcc008Effect;

  /// No description provided for @itemAcc009Effect.
  ///
  /// In en, this message translates to:
  /// **'Death Marked: +10% to all damage. Immune to instant-death and charm effects.'**
  String get itemAcc009Effect;

  /// No description provided for @itemAcc010Effect.
  ///
  /// In en, this message translates to:
  /// **'Undying Light: regenerate 3% HP per turn. +20% resistance to dark and corruption effects.'**
  String get itemAcc010Effect;

  /// No description provided for @itemAcc011Effect.
  ///
  /// In en, this message translates to:
  /// **'Warden\'s Reflex: +18% evasion. Automatically counter-attack once per turn when dodging.'**
  String get itemAcc011Effect;

  /// No description provided for @itemAcc012Effect.
  ///
  /// In en, this message translates to:
  /// **'Silent Ward: immune to all sound-based and mind-affecting attacks. Once per battle, negate a killing blow and heal 25% HP.'**
  String get itemAcc012Effect;

  /// No description provided for @itemAcc013Effect.
  ///
  /// In en, this message translates to:
  /// **'Divine Sorrow: all damage +15%. Healing spells cost 40% less. Immune to divine-type damage.'**
  String get itemAcc013Effect;

  /// No description provided for @itemAcc014Effect.
  ///
  /// In en, this message translates to:
  /// **'Root-Hollow Crown: all stats +8%. Below 25% HP, regenerate 5% max HP per turn and gain +20% to all damage.'**
  String get itemAcc014Effect;

  /// No description provided for @itemAcc015Effect.
  ///
  /// In en, this message translates to:
  /// **'All-Seeing: all enemy stats visible. Spells ignore magic resistance. +20% crit chance. The Deep Mother watches through you.'**
  String get itemAcc015Effect;

  /// No description provided for @itemRel001Effect.
  ///
  /// In en, this message translates to:
  /// **'Faint Resonance: 5% chance to gain an extra action per turn.'**
  String get itemRel001Effect;

  /// No description provided for @itemRel002Effect.
  ///
  /// In en, this message translates to:
  /// **'Deep Glow: reveals enemy positions in darkness. +5% magic damage in underground areas.'**
  String get itemRel002Effect;

  /// No description provided for @itemRel003Effect.
  ///
  /// In en, this message translates to:
  /// **'Scholar\'s Record: +10% XP from all encounters. Reveals hidden lore in Ruins areas.'**
  String get itemRel003Effect;

  /// No description provided for @itemRel004Effect.
  ///
  /// In en, this message translates to:
  /// **'Wisp Light: reveals hidden paths and treasures. +10% evasion against ambushes.'**
  String get itemRel004Effect;

  /// No description provided for @itemRel005Effect.
  ///
  /// In en, this message translates to:
  /// **'Void Erosion: attacks permanently reduce enemy DEF by 3% per hit (stacks up to 5x). Wielder takes 1% max HP per turn.'**
  String get itemRel005Effect;

  /// No description provided for @itemRel006Effect.
  ///
  /// In en, this message translates to:
  /// **'Spirit Flame: every 3rd attack deals 50% bonus fire damage. Immune to burn effects.'**
  String get itemRel006Effect;

  /// No description provided for @itemRel007Effect.
  ///
  /// In en, this message translates to:
  /// **'Ward Echo: reflects 15% of magic damage back at caster. +10% resistance to curse effects.'**
  String get itemRel007Effect;

  /// No description provided for @itemRel008Effect.
  ///
  /// In en, this message translates to:
  /// **'Root Bond: regenerate 4% HP per turn. Nature spells deal 25% bonus damage. Warns of corruption nearby.'**
  String get itemRel008Effect;

  /// No description provided for @itemRel009Effect.
  ///
  /// In en, this message translates to:
  /// **'Abyssal Lock: +15% damage against ancient and divine enemies. Grants a shield (10% max HP) at the start of each battle.'**
  String get itemRel009Effect;

  /// No description provided for @itemRel010Effect.
  ///
  /// In en, this message translates to:
  /// **'Titan\'s Weight: immune to knockback and displacement. +15% damage to targets larger than the wielder.'**
  String get itemRel010Effect;

  /// No description provided for @itemRel011Effect.
  ///
  /// In en, this message translates to:
  /// **'Memory Thief: spells have 10% chance to strip one random buff from the target. Dark spells deal 30% bonus damage. Costs 1% max HP per spell cast.'**
  String get itemRel011Effect;

  /// No description provided for @itemRel012Effect.
  ///
  /// In en, this message translates to:
  /// **'Verdant Will: regenerate 5% max HP per turn. Nature and healing effects deal double. Immune to corruption and decay.'**
  String get itemRel012Effect;

  /// No description provided for @itemRel013Effect.
  ///
  /// In en, this message translates to:
  /// **'Earthen Fury: once per battle, call a tremor dealing AoE damage equal to 300% MAG. Enemies hit lose 20% DEF for 3 turns. Immune to earth and magma damage.'**
  String get itemRel013Effect;

  /// No description provided for @itemRel014Effect.
  ///
  /// In en, this message translates to:
  /// **'Severance: attacks permanently reduce enemy stats by 5% (stacks). Spells ignore shields. Once per battle, banish one enemy ability.'**
  String get itemRel014Effect;

  /// No description provided for @itemRel015Effect.
  ///
  /// In en, this message translates to:
  /// **'World Wound: all damage +20%. Once per battle, open a rift that erases one enemy ability permanently. Immune to all debuffs. Nearby enemies lose 3% stats per turn.'**
  String get itemRel015Effect;

  /// No description provided for @itemSpl001Effect.
  ///
  /// In en, this message translates to:
  /// **'Hurls a Sundering shard dealing damage based on MAG.'**
  String get itemSpl001Effect;

  /// No description provided for @itemSpl002Effect.
  ///
  /// In en, this message translates to:
  /// **'Lashes a target with thorned vine, dealing MAG damage and slowing them for 2 turns.'**
  String get itemSpl002Effect;

  /// No description provided for @itemSpl003Effect.
  ///
  /// In en, this message translates to:
  /// **'Grants a stone shield absorbing damage equal to 50% MAG for 3 turns.'**
  String get itemSpl003Effect;

  /// No description provided for @itemSpl004Effect.
  ///
  /// In en, this message translates to:
  /// **'Fires 3 homing bolts of arcane energy, each dealing MAG-scaled damage.'**
  String get itemSpl004Effect;

  /// No description provided for @itemSpl005Effect.
  ///
  /// In en, this message translates to:
  /// **'Drains enemy HP equal to 80% MAG and heals caster for half the amount.'**
  String get itemSpl005Effect;

  /// No description provided for @itemSpl006Effect.
  ///
  /// In en, this message translates to:
  /// **'Heals caster for 120% MAG and removes one negative status effect.'**
  String get itemSpl006Effect;

  /// No description provided for @itemSpl007Effect.
  ///
  /// In en, this message translates to:
  /// **'Erupts magma dealing heavy MAG damage and reducing enemy DEF by 15% for 3 turns.'**
  String get itemSpl007Effect;

  /// No description provided for @itemSpl008Effect.
  ///
  /// In en, this message translates to:
  /// **'Steals enemy ATK/MAG by 10% for 3 turns and boosts caster\'s next attack by 30%.'**
  String get itemSpl008Effect;

  /// No description provided for @itemSpl009Effect.
  ///
  /// In en, this message translates to:
  /// **'Holy damage dealing 150% MAG. Deals double damage to Hollow-corrupted enemies.'**
  String get itemSpl009Effect;

  /// No description provided for @itemSpl010Effect.
  ///
  /// In en, this message translates to:
  /// **'Creates illusions granting 50% evasion for 3 turns. Next attack from stealth deals +40% damage.'**
  String get itemSpl010Effect;

  /// No description provided for @itemSpl011Effect.
  ///
  /// In en, this message translates to:
  /// **'Traps an enemy for 2 turns dealing 100% MAG each turn. Trapped enemies cannot act.'**
  String get itemSpl011Effect;

  /// No description provided for @itemSpl012Effect.
  ///
  /// In en, this message translates to:
  /// **'AoE sonic damage dealing 120% MAG. Dispels all enemy buffs and silences for 2 turns.'**
  String get itemSpl012Effect;

  /// No description provided for @itemSpl013Effect.
  ///
  /// In en, this message translates to:
  /// **'Chance to instantly kill enemies below 25% HP. Otherwise deals 200% MAG damage.'**
  String get itemSpl013Effect;

  /// No description provided for @itemSpl014Effect.
  ///
  /// In en, this message translates to:
  /// **'Opens a dimensional rift absorbing all damage for 2 turns, then detonates for 250% absorbed damage.'**
  String get itemSpl014Effect;

  /// No description provided for @itemSpl015Effect.
  ///
  /// In en, this message translates to:
  /// **'Cataclysmic damage dealing 400% MAG to all enemies. Reduces all enemy stats by 20% permanently. Once per battle.'**
  String get itemSpl015Effect;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
