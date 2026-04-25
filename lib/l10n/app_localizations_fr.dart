// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'QUESTBORNE';

  @override
  String get appTagline => 'PROPULSÉ PAR UN MOTEUR NARRATIF IA';

  @override
  String get buttonOk => 'OK';

  @override
  String get buttonCancel => 'Annuler';

  @override
  String get buttonSave => 'Sauvegarder';

  @override
  String get buttonClose => 'Fermer';

  @override
  String get startEnter => 'ENTRER';

  @override
  String get startPremium => 'Premium';

  @override
  String get startSettings => 'PARAMÈTRES';

  @override
  String get startVersion => 'Version 0.0.1 • Protocole Crête-d\'Ombre';

  @override
  String continueWithProvider(String provider) {
    return 'Continuer avec $provider';
  }

  @override
  String get loginTitle => 'ENTREZ DANS\nLE ROYAUME';

  @override
  String get loginSubtitle => 'Choisissez comment vous souhaitez continuer';

  @override
  String get loginGoogle => 'Continuer avec Google';

  @override
  String get loginApple => 'Continuer avec Apple';

  @override
  String get errorSomethingWentWrong => 'Un problème est survenu';

  @override
  String get labelObjective => 'Objectif';

  @override
  String get labelLocation => 'Lieu';

  @override
  String get labelReward => 'Récompense';

  @override
  String get labelKeyFigures => 'Personnages clés';

  @override
  String get guildTitle => 'Le Tableau d\'Affichage';

  @override
  String get guildSubtitle => 'Progression des Quêtes';

  @override
  String get guildObjective => 'OBJECTIF';

  @override
  String get guildKeyFigures => 'PERSONNAGES CLÉS';

  @override
  String get guildReward => 'RÉCOMPENSE';

  @override
  String get guildResume => 'Reprendre';

  @override
  String get guildAcceptQuest => 'Accepter la Quête';

  @override
  String get guildDone => 'Terminé';

  @override
  String get guildCompleted => 'TERMINÉ';

  @override
  String get guildSideBounties => 'PRIMES SECONDAIRES';

  @override
  String get guildMainQuests => 'Quêtes Principales';

  @override
  String get guildRepeatableQuests => 'Quêtes Répétables';

  @override
  String guildLevelAbbr(int level) {
    return 'NV $level';
  }

  @override
  String guildGoldDisplay(int amount) {
    return '$amount Or';
  }

  @override
  String get inventoryTitle => 'INVENTAIRE';

  @override
  String get inventoryUnequipped => 'NON ÉQUIPÉ';

  @override
  String get shopTitle => 'LE MARCHÉ';

  @override
  String get shopBuy => 'Acheter';

  @override
  String get shopSold => 'Vendu';

  @override
  String get shopSoldLabel => 'VENDU';

  @override
  String get shopNotEnoughGold => 'Pas assez d\'or';

  @override
  String shopPurchased(String item) {
    return '$item acheté(e) !';
  }

  @override
  String get shopClose => 'Fermer';

  @override
  String get shopMerchantQuote =>
      '\"Choisissez bien, voyageur. Mes marchandises coûtent plus que de l\'or...\"';

  @override
  String shopGold(int amount) {
    return '$amount Or';
  }

  @override
  String get shopMerchantWares => 'Marchandises du Marchand';

  @override
  String get settingsTitle => 'PARAMÈTRES';

  @override
  String get settingsProfile => 'PROFIL';

  @override
  String get settingsCharacterName => 'Nom du Personnage';

  @override
  String get settingsEmail => 'E-mail';

  @override
  String get settingsAiSafety => 'SÉCURITÉ IA';

  @override
  String get settingsHateSpeech => 'Discours haineux';

  @override
  String get settingsHarassment => 'Harcèlement';

  @override
  String get settingsDangerousContent => 'Contenu dangereux';

  @override
  String get settingsGeneral => 'GÉNÉRAL';

  @override
  String get settingsPremium => 'Premium';

  @override
  String get settingsPremiumSubtitle => 'Voir les options d\'abonnement';

  @override
  String get settingsRestoreSubscription => 'Restaurer l\'abonnement';

  @override
  String get settingsRestoreSubtitle => 'Déjà abonné ? Restaurez-le ici';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSubtitle => 'Changer la langue de l\'application';

  @override
  String get settingsLanguageSystem => 'Langue du système';

  @override
  String get settingsAccount => 'COMPTE';

  @override
  String get settingsDeleteAccount => 'Supprimer le Compte';

  @override
  String get settingsDeleteSubtitle =>
      'Supprimer définitivement votre compte et toutes les données';

  @override
  String get settingsLegal => 'MENTIONS LÉGALES';

  @override
  String get settingsPrivacyPolicy => 'Politique de Confidentialité';

  @override
  String get settingsPrivacySubtitle => 'Comment nous traitons vos données';

  @override
  String get settingsTermsOfService => 'Conditions d\'Utilisation';

  @override
  String get settingsTermsSubtitle => 'Règles et conditions d\'utilisation';

  @override
  String get settingsChangeName => 'CHANGER LE NOM';

  @override
  String get settingsChangeNameDesc =>
      'Choisissez un nouveau nom pour votre personnage';

  @override
  String get settingsEnterNewName => 'Entrez un nouveau nom';

  @override
  String get settingsNameReserved =>
      '« Adventurer » est réservé — choisissez quelque chose d\'unique !';

  @override
  String settingsNameChanged(String name) {
    return 'Nom changé en $name';
  }

  @override
  String get settingsChooseFilterLevel => 'Choisissez un niveau de filtrage';

  @override
  String get settingsCheckingSubscription =>
      'Vérification de l\'abonnement existant...';

  @override
  String settingsSubscriptionRestored(String tier) {
    return 'Abonnement restauré ! ($tier)';
  }

  @override
  String get settingsNoSubscription => 'Aucun abonnement actif trouvé.';

  @override
  String get settingsRestoreFailed =>
      'Impossible de restaurer l\'abonnement. Réessayez plus tard.';

  @override
  String get settingsDeleteTitle => 'Supprimer le Compte';

  @override
  String get settingsDeleteMessage =>
      'Cela supprimera définitivement votre compte et toutes les données sauvegardées. Tout abonnement actif sera également annulé. Cette action est irréversible.';

  @override
  String get settingsDeleteConfirm => 'Supprimer';

  @override
  String get settingsDeleteFailed =>
      'Un problème est survenu. Réessayez plus tard.';

  @override
  String get safetyLevelLow => 'Faible';

  @override
  String get safetyLevelMedium => 'Moyen';

  @override
  String get safetyLevelHigh => 'Élevé';

  @override
  String get safetyDescLow => 'Permissif — adapté à la dark fantasy';

  @override
  String get safetyDescMedium => 'Filtrage équilibré';

  @override
  String get safetyDescHigh => 'Filtrage strict du contenu';

  @override
  String get subscriptionPlans => 'FORFAITS';

  @override
  String get subscriptionCredits => 'crédits';

  @override
  String subscriptionCreditsDaily(int daily) {
    return 'crédits (+$daily quotidiens)';
  }

  @override
  String subscriptionCreditsRemaining(int max) {
    return 'crédits restants sur $max';
  }

  @override
  String get subscriptionCurrent => 'Actuel';

  @override
  String subscriptionUpgradedTo(String tier) {
    return 'Amélioré en $tier !';
  }

  @override
  String get subscriptionManageGooglePlay =>
      'Gérer les Abonnements sur Google Play';

  @override
  String subscriptionMemory(String tag) {
    return 'Mémoire $tag';
  }

  @override
  String subscriptionResets(String date) {
    return 'Réinitialisation $date';
  }

  @override
  String subscriptionCreditsCount(int count) {
    return '$count crédits';
  }

  @override
  String subscriptionCreditsDailyFeature(int max, int daily) {
    return '$max + $daily/jour crédits';
  }

  @override
  String get expeditionTitle => 'Expédition';

  @override
  String get expeditionOpenWorlds => 'Mondes Ouverts';

  @override
  String get expeditionEnter => 'Lancer l\'Expédition';

  @override
  String get expeditionEnterShort => 'Entrer';

  @override
  String get expeditionFreeRoam => 'Exploration Libre';

  @override
  String get expeditionFreeRoamDesc =>
      'Pas d\'objectif défini — explorez librement et voyez ce qui vous attend.';

  @override
  String get mapDarkwoodForest => 'La Forêt de Sombrebois';

  @override
  String get mapDarkwoodForestDesc =>
      'Un ancien bois plongé dans un crépuscule perpétuel. Des chênes tordus et des racines noueuses cachent des sentiers oubliés, des créatures étranges et des murmures de vieille magie entre les pierres couvertes de mousse.';

  @override
  String get mapSunkenCaverns => 'Les Cavernes Englouties';

  @override
  String get mapSunkenCavernsDesc =>
      'Un vaste réseau souterrain de tunnels suintants et de chambres cristallines luminescentes. L\'air est chargé de l\'odeur de terre humide, et des choses inconnues grouillent juste au-delà de la lumière des torches.';

  @override
  String get mapAshenRuins => 'Les Ruines de Cendres';

  @override
  String get mapAshenRuinsDesc =>
      'Vestiges croulants d\'une civilisation autrefois grandiose, à moitié engloutis par le sable et les lianes rampantes. Des arches effondrées mènent à des voûtes oubliées, et les fantômes de l\'ancien monde persistent dans chaque ombre.';

  @override
  String get navWorld => 'Monde';

  @override
  String get navQuest => 'Quête';

  @override
  String get navMarket => 'Marché';

  @override
  String get navHero => 'Héros';

  @override
  String get navSheet => 'Fiche';

  @override
  String get nameDialogAppTitle => 'Questborne';

  @override
  String get nameDialogTitle => 'QUI ÊTES-VOUS ?';

  @override
  String get nameDialogSubtitle =>
      'Prononcez votre nom, et que l\'aventure commence.';

  @override
  String get nameDialogHint => 'Prononcez votre nom...';

  @override
  String get nameDialogErrorEmpty => 'Le Questborne doit avoir un nom.';

  @override
  String get nameDialogErrorShort =>
      'Trop court. Même un vagabond a deux lettres.';

  @override
  String get nameDialogErrorLong => 'Gardez-le sous 20 caractères.';

  @override
  String get nameDialogErrorReserved => 'Ce nom n\'est pas autorisé';

  @override
  String get lootObtained => 'OBTENU';

  @override
  String lootGoldGained(int amount) {
    return '+$amount Or';
  }

  @override
  String lootXpGained(int amount) {
    return '+$amount XP';
  }

  @override
  String lootHpRestored(int amount) {
    return '+$amount PV Restaurés';
  }

  @override
  String lootManaRestored(int amount) {
    return '+$amount Mana Restauré';
  }

  @override
  String lootGoldLost(int amount) {
    return '-$amount Or';
  }

  @override
  String lootDamage(int amount) {
    return '-$amount PV';
  }

  @override
  String get lootLevelUp => 'Niveau supérieur !';

  @override
  String lootLevelUpMultiple(int levels) {
    return 'Niveau supérieur ! (+$levels niveaux)';
  }

  @override
  String diceCheck(String action) {
    return '$action TEST';
  }

  @override
  String get questCompleteTitle => 'QUÊTE ACCOMPLIE';

  @override
  String get questCompleteSubtitle => 'Votre histoire a été écrite.';

  @override
  String get questCompleteRewards => 'RÉCOMPENSES';

  @override
  String get questCompleteReturn => 'RETOUR À LA GUILDE';

  @override
  String questCompleteGold(int amount) {
    return '$amount Or';
  }

  @override
  String questCompleteXp(int amount) {
    return '$amount XP';
  }

  @override
  String get questFailedTitle => 'QUÊTE ÉCHOUÉE';

  @override
  String get questFailedSubtitle => 'Les ténèbres réclament une âme de plus.';

  @override
  String get questFailedReset =>
      'Votre progression de série de quêtes a été réinitialisée.';

  @override
  String get questFailedReturn => 'RETOUR À LA GUILDE';

  @override
  String spellManaCost(int cost) {
    return '$cost PM';
  }

  @override
  String get itemTypeWeapon => 'ARME';

  @override
  String get itemTypeArmor => 'ARMURE';

  @override
  String get itemTypeAccessory => 'ACCESSOIRE';

  @override
  String get itemTypeRelic => 'RELIQUE';

  @override
  String get itemTypeSpell => 'SORT';

  @override
  String get rarityCommon => 'COMMUN';

  @override
  String get rarityRare => 'RARE';

  @override
  String get rarityEpic => 'ÉPIQUE';

  @override
  String get rarityMythic => 'MYTHIQUE';

  @override
  String get actionMeleeAttack => 'Attaque de Mêlée';

  @override
  String get actionRangedAttack => 'Attaque à Distance';

  @override
  String get actionOffensiveMagic => 'Magie Offensive';

  @override
  String get actionDefensiveMagic => 'Magie Défensive';

  @override
  String get actionStealth => 'Furtivité';

  @override
  String get actionAssassination => 'Assassinat';

  @override
  String get actionDodge => 'Esquive';

  @override
  String get actionParry => 'Parade';

  @override
  String get actionPersuasion => 'Persuasion';

  @override
  String get actionThrow => 'Lancer';

  @override
  String get actionDexterity => 'Dextérité';

  @override
  String get actionEndurance => 'Endurance';

  @override
  String get actionFlee => 'Fuite';

  @override
  String get outcomeCriticalFailure => 'Échec Critique';

  @override
  String get outcomeFailure => 'Échec';

  @override
  String get outcomePartialSuccess => 'Succès Partiel';

  @override
  String get outcomeSuccess => 'Succès';

  @override
  String get outcomeCriticalSuccess => 'Succès Critique';

  @override
  String get difficultyRoutine => 'Tâche de Routine';

  @override
  String get difficultyDangerous => 'Dangereux';

  @override
  String get difficultyPerilous => 'Périlleux';

  @override
  String get difficultySuicidal => 'Suicidaire';

  @override
  String get statusPoisoned => 'EMPOISONNÉ';

  @override
  String get statusBurning => 'BRÛLANT';

  @override
  String get statusFrozen => 'GELÉ';

  @override
  String get statusBlessed => 'BÉNI';

  @override
  String get statusShielded => 'PROTÉGÉ';

  @override
  String get statusWeakened => 'AFFAIBLI';

  @override
  String get tierWanderer => 'Vagabond';

  @override
  String get tierAdventurer => 'Aventurier';

  @override
  String get tierChampion => 'Champion';

  @override
  String get tierTaglineFree => 'Commencez votre voyage';

  @override
  String get tierTaglineAdventurer =>
      'Des histoires plus profondes vous attendent';

  @override
  String get tierTaglineChampion => 'L\'expérience ultime';

  @override
  String get statAtk => 'ATQ';

  @override
  String get statDef => 'DÉF';

  @override
  String get statMag => 'MAG';

  @override
  String get statAgi => 'AGI';

  @override
  String get statHp => 'PV';

  @override
  String get statMp => 'PM';

  @override
  String get labelGold => 'Or';

  @override
  String get labelXp => 'XP';

  @override
  String labelLevel(int level) {
    return 'Nv $level';
  }

  @override
  String statSummaryFormat(String label, String value) {
    return '$label $value';
  }

  @override
  String priceFormat(int price) {
    return '$price Or';
  }

  @override
  String rewardFormat(int gold, int xp) {
    return '$gold Or  ·  $xp XP';
  }

  @override
  String get errorSignInRequired => 'Vous devez être connecté pour jouer.';

  @override
  String get errorSessionExpired =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get errorSignInToPlay =>
      'Connectez-vous avec Google ou Apple pour jouer aux quêtes.';

  @override
  String get errorTooManyRequests =>
      'Trop de requêtes — veuillez patienter un instant et réessayer.';

  @override
  String get errorServiceUnavailable =>
      'Le service IA est temporairement indisponible. Veuillez réessayer dans un instant. Votre crédit a été remboursé.';

  @override
  String get errorServerError =>
      'Un problème est survenu de notre côté. Veuillez réessayer.';

  @override
  String get errorGeneric => 'Un problème est survenu. Veuillez réessayer.';

  @override
  String get errorNetworkError =>
      'Un problème est survenu. Vérifiez votre connexion internet et réessayez.';

  @override
  String get locationForest => 'Forêt';

  @override
  String get locationCave => 'Grotte';

  @override
  String get locationRuins => 'Ruines';

  @override
  String freeRoamTitle(String mapTitle) {
    return '$mapTitle — Exploration Libre';
  }

  @override
  String get freeRoamObjective =>
      'Explorez librement et voyez ce que le monde vous réserve.';

  @override
  String get equip => 'Équiper';

  @override
  String get unequip => 'Déséquiper';

  @override
  String get nameDialogContinue => 'CONTINUER';

  @override
  String get cardAcceptQuest => 'ACCEPTER LA QUÊTE';

  @override
  String get cardInvestigate => 'Enquêter';

  @override
  String get cardEnter => 'Entrer';

  @override
  String get cardRewardLabel => 'RÉCOMPENSE';

  @override
  String get cardDifficultyPrefix => 'Difficulté : ';

  @override
  String levelPrefix(int level) {
    return 'niv $level';
  }

  @override
  String get questRepF01Title => 'Patrouille de gobelins';

  @override
  String get questRepF01Desc =>
      'Des éclaireurs gobelins ont été repérés le long de la lisière de la forêt. La milice offre une prime permanente — éliminez-les avant qu\'ils ne pillent une autre ferme.';

  @override
  String get questRepF01Obj =>
      'Chassez les éclaireurs gobelins aux abords de la forêt.';

  @override
  String get questRepC01Title => 'Vermine des tunnels';

  @override
  String get questRepC01Desc =>
      'Des rats et des araignées des cavernes infestent les Hollows supérieurs. Les mineurs paient bien quiconque accepte de les éliminer — les créatures se reproduisent plus vite que les tunnels ne peuvent être scellés.';

  @override
  String get questRepC01Obj =>
      'Éliminez la vermine des tunnels miniers des Hollows supérieurs.';

  @override
  String get questRepR01Title => 'Os sans repos';

  @override
  String get questRepR01Desc =>
      'Les tertres extérieurs de Valdris ne restent jamais silencieux. Des squelettes s\'arrachent de leurs tombes tous les quelques jours. L\'historien Korval offre une prime pour garder l\'entrée du campement dégagée.';

  @override
  String get questRepR01Obj =>
      'Renvoyez les morts-vivants au repos dans les tertres extérieurs de Valdris.';

  @override
  String get questRepF02Title => 'Prime aux bandits';

  @override
  String get questRepF02Desc =>
      'Des éclaireurs bandits patrouillent les routes commerciales près du Thornveil. Les marchands refusent de voyager sans escorte armée. Le tableau des primes garde cette annonce en permanence.';

  @override
  String get questRepF02Obj =>
      'Chassez les éclaireurs bandits le long des routes commerciales du Thornveil.';

  @override
  String get questRepC02Title => 'Escorte du filon';

  @override
  String get questRepC02Desc =>
      'Un nouveau filon de minerai a été découvert dans les Hollows intermédiaires, mais les tunnels sont hantés par des créatures cavernicoles. Le contremaître Brick a besoin de quelqu\'un pour escorter les mineurs jusqu\'au filon et retour.';

  @override
  String get questRepC02Obj =>
      'Escortez les mineurs en sécurité à travers les tunnels dangereux des Hollows.';

  @override
  String get questRepR02Title => 'Récupération d\'artefacts';

  @override
  String get questRepR02Desc =>
      'L\'érudite Veyra a besoin que des artefacts maudits soient récupérés dans les ruines supérieures avant que les pillards ne les vendent à des collectionneurs qui n\'ont aucune idée de ce qu\'ils manipulent.';

  @override
  String get questRepR02Obj =>
      'Récupérez des artefacts maudits dans les ruines supérieures de Valdris.';

  @override
  String get questRepF03Title => 'Purification de la corruption';

  @override
  String get questRepF03Desc =>
      'Les broussailles corrompues par le Hollow se propagent à travers la forêt centrale. Le cercle du druide Theron les brûle chaque semaine, mais ils ont besoin de quelqu\'un pour éliminer les créatures qui nichent dans les bosquets corrompus.';

  @override
  String get questRepF03Obj =>
      'Éliminez les créatures corrompues par le Hollow dans les bosquets de la forêt centrale.';

  @override
  String get questRepC03Title => 'Récolte fongique';

  @override
  String get questRepC03Desc =>
      'Les floraisons de spores de la Deep Mother continuent d\'éclater dans les Hollows intermédiaires. L\'herboriste Nessa a besoin de quelqu\'un pour détruire les floraisons avant qu\'elles ne rendent les mineurs fous — et pour rapporter des échantillons qu\'elle puisse étudier.';

  @override
  String get questRepC03Obj =>
      'Détruisez les floraisons fongiques dangereuses dans les Hollows intermédiaires.';

  @override
  String get questRepR03Title => 'Patrouille Tithebound';

  @override
  String get questRepR03Desc =>
      'Des sentinelles Tithebound errent dans les ruines de profondeur moyenne en boucles sans fin. Quand elles s\'approchent trop du campement de surface, quelqu\'un doit les repousser. La prime est toujours affichée.';

  @override
  String get questRepR03Obj =>
      'Repoussez les patrouilles Tithebound hors des ruines supérieures.';

  @override
  String get questRepF04Title => 'Escarmouche Pale Root';

  @override
  String get questRepF04Desc =>
      'Des pillards Pale Root tendent des embuscades aux patrouilles près du Thornwall. Les elfes les désavouent, mais les attaques continuent. La prime est élevée — ce ne sont pas de simples bandits.';

  @override
  String get questRepF04Obj =>
      'Affrontez les pillards Pale Root près de la frontière du Thornwall.';

  @override
  String get questRepC04Title => 'Patrouille des profondeurs';

  @override
  String get questRepC04Desc =>
      'Des créatures libérées par les pierres de garde défaillantes remontent des Hollows profonds. Les Ossborn ignorent tout ce qui ne menace pas leurs sceaux. Le contremaître Brick a besoin de gens de la surface pour maintenir les tunnels intermédiaires praticables.';

  @override
  String get questRepC04Obj =>
      'Patrouillez dans les Hollows profonds et éliminez les créatures échappées.';

  @override
  String get questRepR04Title => 'Suppression de résonance';

  @override
  String get questRepR04Desc =>
      'Le bourdonnement dans les ruines profondes ne cesse de générer des nœuds de résonance — des cristaux qui rendent les gens fous. L\'érudite Veyra paie bien pour qu\'on les brise avant que le son n\'atteigne la surface.';

  @override
  String get questRepR04Obj =>
      'Détruisez les nœuds de résonance dans les ruines profondes de Valdris.';

  @override
  String get questRepF05Title => 'Mission de la Verdant Court';

  @override
  String get questRepF05Desc =>
      'La Verdant Court a chargé des champions mortels de purger la corruption des bosquets sacrés que les elfes ne peuvent atteindre sans franchir le Thornwall. La paie est en argent elfique — plus précieux que l\'or humain.';

  @override
  String get questRepF05Obj =>
      'Purgez la corruption d\'un bosquet sacré pour la Verdant Court.';

  @override
  String get questRepC05Title => 'Réparation des liens';

  @override
  String get questRepC05Desc =>
      'Les pierres de garde dans les Hollows profonds ne cessent de se fissurer. Le Forge Spirit ne peut pas toutes les entretenir. Quelqu\'un doit transporter des pierres de scellement de remplacement jusqu\'aux piédestaux défaillants avant que ce qu\'elles retiennent ne se libère.';

  @override
  String get questRepC05Obj =>
      'Livrez des pierres de scellement aux piédestaux de garde défaillants dans les Hollows profonds.';

  @override
  String get questRepR05Title => 'Sceau dimensionnel';

  @override
  String get questRepR05Desc =>
      'Des déchirures mineures continuent de s\'ouvrir près de la blessure du Severance — la réalité s\'effiloche sur les bords. Les anciens Tithebound conscients les marquent. Quelqu\'un doit les refermer avant que le Nameless Choir ne s\'y infiltre.';

  @override
  String get questRepR05Obj =>
      'Scellez les déchirures dimensionnelles mineures près de la blessure du Severance.';

  @override
  String get questF001Title => 'Camp gobelin sur la route marchande';

  @override
  String get questF001Desc =>
      'Un groupe d\'éclaireurs gobelins a installé un campement là où la route marchande entre dans le Thornveil. Bûcherons et marchands refusent de passer.';

  @override
  String get questF001Obj =>
      'Localisez et détruisez le camp gobelin qui bloque la route marchande de la forêt.';

  @override
  String get questF002Title => 'Loups sinistres du Thornveil';

  @override
  String get questF002Desc =>
      'Une meute de loups sinistres a pris possession de la route principale à travers le Thornveil extérieur. Des voyageurs sont traînés dans les sous-bois.';

  @override
  String get questF002Obj =>
      'Chassez ou repoussez la meute de loups sinistres qui terrorise la route du Thornveil.';

  @override
  String get questF003Title => 'Le ruisseau empoisonné';

  @override
  String get questF003Desc =>
      'Une boue verdâtre et nauséabonde suinte de quelque part en amont dans le Thornveil. Les animaux qui boivent au ruisseau s\'effondrent, morts. L\'herboriste Nessa craint que cela n\'atteigne l\'approvisionnement en eau du village.';

  @override
  String get questF003Obj =>
      'Suivez le ruisseau à travers le Thornveil et détruisez ce qui l\'empoisonne.';

  @override
  String get questF004Title => 'Le bûcheron disparu';

  @override
  String get questF004Desc =>
      'Le vieux Henrik est parti abattre du bois à la lisière du Thornveil il y a trois jours. Sa hache a été trouvée plantée dans un arbre, couverte de marques de griffes.';

  @override
  String get questF004Obj =>
      'Suivez la trace du bûcheron disparu dans les profondeurs du Thornveil extérieur et découvrez son sort.';

  @override
  String get questF005Title => 'Embuscade de bandits';

  @override
  String get questF005Desc =>
      'Des bandits dévalisent les marchands sur la route forestière à l\'extérieur du Thornwall. Ils s\'évanouissent dans la canopée avant l\'arrivée de la milice.';

  @override
  String get questF005Obj =>
      'Tendez un piège aux bandits de la forêt et abattez leur chef.';

  @override
  String get questF006Title => 'Malédiction de la Vigne Noire';

  @override
  String get questF006Desc =>
      'Un fléau épineux rampe sur le sol de la forêt près de la frontière du Thornwall. Il se déplace de lui-même la nuit, étranglant les arbres. Les druides du Circle of Thorn disent n\'avoir jamais rien vu de tel.';

  @override
  String get questF006Obj =>
      'Trouvez le cœur de la Vigne Noire au plus profond du Thornveil et brûlez-le.';

  @override
  String get questF007Title => 'L\'embuscade féerique';

  @override
  String get questF007Desc =>
      'Les lutins à la lisière du Thornveil sont devenus hostiles sans avertissement. Les voyageurs rapportent avoir été enchantés et dévalisés — ou pire, menés hors du sentier pour ne plus jamais être revus. Les anciens pactes féeriques se délitent peut-être.';

  @override
  String get questF007Obj =>
      'Découvrez pourquoi les fées sont devenues hostiles et trouvez un moyen d\'arrêter les attaques.';

  @override
  String get questF008Title => 'La désertrice Vaelithi';

  @override
  String get questF008Desc =>
      'Une elfe a été trouvée inconsciente à la frontière du Thornwall, couverte de blessures qui semblent auto-infligées — comme si elle avait griffé la barrière de l\'intérieur. Elle murmure à propos d\'une « Pale Root » et supplie qu\'on ne la renvoie pas.';

  @override
  String get questF008Obj =>
      'Protégez la désertrice elfique de ceux qui la pourchassent et apprenez ce qu\'elle sait.';

  @override
  String get questF009Title => 'La bête du fourré';

  @override
  String get questF009Desc =>
      'Le bétail à la lisière du Thornveil est déchiqueté par quelque chose de massif. Les marques de griffes font la largeur d\'un bras d\'homme. Le fermier Gregor dit que les druides refusent d\'aider — ils prétendent que la bête est « la réponse de la forêt ».';

  @override
  String get questF009Obj =>
      'Pistez et tuez la bête tapie dans le fourré le plus profond du Thornveil extérieur.';

  @override
  String get questF010Title => 'Nids d\'araignées dans la canopée';

  @override
  String get questF010Desc =>
      'Des toiles géantes couvrent la canopée sur des kilomètres le long de la route marchande. Des voyageurs emmaillotés pendent des branches, certains encore vivants. La ranger Elara dit que les araignées sont apparues après l\'affaiblissement des pactes féeriques.';

  @override
  String get questF010Obj =>
      'Brûlez les nids d\'araignées dans la canopée forestière et sauvez les survivants.';

  @override
  String get questF011Title => 'La terreur verdoyante';

  @override
  String get questF011Desc =>
      'Une créature végétale monstrueuse a pris racine près de la frontière du Thornwall. Le druide Theron pense qu\'elle a poussé dans un sol corrompu par le Hollow — le même fléau que les Vaelithi refusent de reconnaître.';

  @override
  String get questF011Obj =>
      'Frayez-vous un chemin à travers la végétation et détruisez la créature végétale monstrueuse qui menace la frontière du Thornwall.';

  @override
  String get questF012Title => 'Couronne d\'épines';

  @override
  String get questF012Desc =>
      'Un sylvanien corrompu a revendiqué le bosquet le plus profond à l\'extérieur du Thornwall. Les druides du Circle of Thorn disent qu\'un cristal sombre a été enfoncé dans son tronc — le même type de corruption qui se propage depuis les Hollows.';

  @override
  String get questF012Obj =>
      'Aventurez-vous dans le bosquet ancien et détruisez la corruption à l\'intérieur du sylvanien.';

  @override
  String get questF013Title => 'L\'autel du culte du bûcher';

  @override
  String get questF013Desc =>
      'Un culte fanatique du feu a érigé des autels-bûchers entre les arbres du Thornveil extérieur. L\'espionne Maren dit qu\'ils vénèrent quelque chose dans les Hollows en dessous et projettent de brûler un passage à travers le Thornwall pour atteindre Vaelith.';

  @override
  String get questF013Obj =>
      'Infiltrez le campement forestier du culte du feu et éliminez leur chef.';

  @override
  String get questF014Title => 'Le terrain de chasse du dragon';

  @override
  String get questF014Desc =>
      'Un jeune dragon a revendiqué la forêt des mortels comme territoire de chasse. Des clairières calcinées marquent ses victimes. Les Vaelithi ont resserré le Thornwall — ils n\'ont pas l\'intention d\'aider.';

  @override
  String get questF014Obj =>
      'Pistez le dragon jusqu\'à son repaire forestier et mettez fin à son règne.';

  @override
  String get questF015Title => 'Camp de guerre orc';

  @override
  String get questF015Desc =>
      'Une horde de guerre orc a bâti un camp fortifié dans la forêt des mortels. Ils pillent les villages environnants chaque nuit. Le commandant Hale dispose du soutien de la milice, mais pas assez pour assaillir le camp seul.';

  @override
  String get questF015Obj =>
      'Assaillez le camp de guerre orc dans la forêt et brisez leur siège sur les villages.';

  @override
  String get questF016Title => 'La brèche du Thornwall';

  @override
  String get questF016Desc =>
      'Quelque chose a déchiré un trou dans le Thornwall — la barrière vivante qui scelle Vaelith du monde mortel. Des créatures féeriques et pire encore se déversent par la brèche. Les elfes n\'ont pas répondu. Les druides sont submergés.';

  @override
  String get questF016Obj =>
      'Atteignez la brèche du Thornwall et scellez-la avant qu\'elle ne s\'élargisse davantage.';

  @override
  String get questF017Title => 'L\'incursion Pale Root';

  @override
  String get questF017Desc =>
      'Des agents Pale Root — des elfes de la faction rebelle de Vaelith — ont franchi le Thornwall et sabotent les sanctuaires du Circle of Thorn. Le druide Theron pense qu\'ils veulent que la barrière tombe pour que Vaelith puisse s\'étendre par la force.';

  @override
  String get questF017Obj =>
      'Pistez et arrêtez les agents Pale Root avant qu\'ils ne détruisent le dernier sanctuaire druidique.';

  @override
  String get questF018Title => 'Ombres dans la canopée';

  @override
  String get questF018Desc =>
      'Un crépuscule éternel est tombé sur une vaste section du Thornveil. Des créatures d\'ombre rôdent dans la canopée assombrie. La prêtresse du soleil Amara dit que la Pierre Solaire — une relique ancienne qui ancre la lumière du jour à la forêt — a été volée.';

  @override
  String get questF018Obj =>
      'Retrouvez la Pierre Solaire et restaurez la lumière du jour dans la forêt assombrie.';

  @override
  String get questF019Title => 'Le fléau sous Vaelith';

  @override
  String get questF019Desc =>
      'Un exilé Vaelithi a franchi le Thornwall avec des nouvelles désespérées : le fléau dans les racines-cavernes sous Vaelith se propage plus vite que les elfes ne peuvent le contenir. La Verdant Court refuse de demander l\'aide des mortels — mais cet exilé la demande quand même.';

  @override
  String get questF019Obj =>
      'Traversez une brèche dans le Thornwall et descendez dans les racines-cavernes pour trouver la source du fléau.';

  @override
  String get questF020Title => 'Le Dévoreur de dieux';

  @override
  String get questF020Desc =>
      'Les sanctuaires à travers le Thornveil se sont tus. Une créature se nourrissant d\'essence divine rôde entre les arbres — les druides l\'appellent un Dévoreur de dieux, quelque chose qui ne devrait pas exister hors du Hollow.';

  @override
  String get questF020Obj =>
      'Chassez le Dévoreur de dieux à travers les bosquets sacrés avant qu\'il ne dévore le dernier sanctuaire.';

  @override
  String get questF021Title => 'L\'Arbre-Monde brûle';

  @override
  String get questF021Desc =>
      'Un feu démoniaque engloutit l\'Arbre-Monde. Les Vaelithi ont ouvert le Thornwall pour la première fois en trois siècles — non pour aider, mais pour évacuer. Si l\'Arbre-Monde tombe, la forêt et tout ce qui se trouve en dessous meurt.';

  @override
  String get questF021Obj =>
      'Gravissez l\'Arbre-Monde en flammes et éteignez le feu infernal à sa cime.';

  @override
  String get questF022Title => 'Le jugement de la Verdant Court';

  @override
  String get questF022Desc =>
      'La reine Seylith l\'Immortelle a convoqué le joueur à Vaelith — le premier mortel invité à traverser le Thornwall en trois siècles. Elle n\'explique pas pourquoi. La faction Pale Root y voit une opportunité.';

  @override
  String get questF022Obj =>
      'Entrez dans Vaelith, survivez à l\'épreuve de la Verdant Court et apprenez ce que les elfes dissimulent.';

  @override
  String get questF023Title => 'Le bosquet de la Mort';

  @override
  String get questF023Desc =>
      'La Mort — le plus ancien des dieux — a planté un jeune arbre noir au cœur du Thornveil. Tous ceux qui passent à côté se réduisent en os. L\'Arbre-Monde frémit. Les Vaelithi se sont tus. Les druides disent que c\'est la fin de la forêt.';

  @override
  String get questF023Obj =>
      'Arrachez le jeune arbre de la Mort de la clairière forestière et survivez à ce qui le garde.';

  @override
  String get questC001Title => 'Habitants de la cave';

  @override
  String get questC001Desc =>
      'Des grattements résonnent depuis la caverne sous la vieille auberge. Quelque chose est remonté des Hollows dans les tunnels supérieurs.';

  @override
  String get questC001Obj =>
      'Éliminez les créatures qui infestent la caverne sous la vieille auberge.';

  @override
  String get questC002Title => 'Les profondeurs luisantes';

  @override
  String get questC002Desc =>
      'Une faible lueur verte pulse depuis une entrée des Hollows. L\'eau du puits du village a commencé à avoir un goût de pourriture — l\'herboriste Nessa dit que les excroissances fongiques de la Deep Mother remontent.';

  @override
  String get questC002Obj =>
      'Descendez dans les Hollows et purgez ce qui contamine la source d\'eau souterraine.';

  @override
  String get questC003Title => 'Nuée de chauves-souris dans les Hollows';

  @override
  String get questC003Desc =>
      'D\'énormes chauves-souris cavernicoles jaillissent d\'une entrée des Hollows au crépuscule, terrorisant les bergers en surface.';

  @override
  String get questC003Obj =>
      'Pénétrez dans les Hollows supérieurs et occupez-vous de la colonie de chauves-souris monstrueuses.';

  @override
  String get questC004Title => 'Le tunnel des contrebandiers';

  @override
  String get questC004Desc =>
      'Des marchandises illégales circulent par un passage caché dans les Hollows supérieurs. Les contrebandiers utilisent les tunnels de pierre taillée que les mineurs ont abandonnés après avoir entendu d\'étranges sons plus profondément.';

  @override
  String get questC004Obj =>
      'Infiltrez le tunnel des contrebandiers dans les Hollows et interceptez leur opération.';

  @override
  String get questC005Title => 'Le puits effondré';

  @override
  String get questC005Desc =>
      'Les mineurs ont percé jusqu\'à quelque chose d\'ancien — un passage taillé par aucune main humaine. D\'étranges sons résonnent au-delà de l\'effondrement, et la pierre est chaude au toucher.';

  @override
  String get questC005Obj =>
      'Explorez le puits de mine effondré et secourez les mineurs piégés dans les tunnels anciens.';

  @override
  String get questC006Title => 'Le rôdeur des profondeurs';

  @override
  String get questC006Desc =>
      'Quelque chose de massif vit dans le lac souterrain où les Hollows rejoignent la nappe phréatique. Des ondulations apparaissent là où rien ne devrait bouger.';

  @override
  String get questC006Obj =>
      'Attirez et tuez la créature qui réside dans le lac souterrain des Hollows.';

  @override
  String get questC007Title => 'Le premier piège';

  @override
  String get questC007Desc =>
      'Des mineurs ont ouvert un nouveau tunnel et trois d\'entre eux ont disparu. Un survivant est revenu en rampant, balbutiant à propos de dalles qui « hurlaient du feu » — des pièges de gardien des Hollows profonds, bien au-dessus de l\'endroit où ils devraient se trouver.';

  @override
  String get questC007Obj =>
      'Naviguez à travers le passage piégé dans les Hollows intermédiaires et retrouvez les mineurs disparus.';

  @override
  String get questC008Title => 'La peste fongique';

  @override
  String get questC008Desc =>
      'Des excroissances fongiques bioluminescentes — le souffle de la Deep Mother — se propagent rapidement dans les Hollows intermédiaires. Les mineurs qui inhalent les spores sombrent dans la folie, griffant les murs et parlant avec des voix qui ne sont pas les leurs.';

  @override
  String get questC008Obj =>
      'Atteignez la source de la peste fongique au plus profond des Hollows et détruisez-la.';

  @override
  String get questC009Title => 'Le marché de la chair';

  @override
  String get questC009Desc =>
      'Des gens disparaissent des villages en surface. Un marché noir opère dans les Hollows supérieurs sans loi, trafiquant des corps vivants. Les contrebandiers se sont enfoncés plus profondément que quiconque ne le devrait.';

  @override
  String get questC009Obj =>
      'Infiltrez le marché de la chair souterrain dans les Hollows et libérez les prisonniers.';

  @override
  String get questC010Title => 'L\'arène souterraine';

  @override
  String get questC010Desc =>
      'Les fosses de combat des Hollows ont un nouveau champion — un qui ne saigne jamais. Sa peau est pâle et translucide, et il combat avec une immobilité qui terrifie la foule. Certains disent qu\'il a rampé depuis les profondeurs.';

  @override
  String get questC010Obj =>
      'Défiez le champion invaincu de l\'arène et percez le secret de ses victoires.';

  @override
  String get questC011Title => 'Le corridor aux carillons d\'os';

  @override
  String get questC011Desc =>
      'Des explorateurs ont trouvé un passage plus profond dans les Hollows orné de carillons faits d\'os. Le premier homme qui en a touché un est mort — le carillon a explosé en éclats tranchants. C\'est de l\'artisanat de gardien. Quelque chose est scellé au-delà.';

  @override
  String get questC011Obj =>
      'Naviguez dans le corridor aux carillons d\'os dans les Hollows profonds sans déclencher les pièges et découvrez ce qui se trouve au-delà.';

  @override
  String get questC012Title => 'Premier contact';

  @override
  String get questC012Desc =>
      'Une équipe de minage a percé jusqu\'à une chambre où la pierre était gravée de symboles que personne ne reconnaît. Trois des mineurs ont été retrouvés morts — tués silencieusement, avec précision, sans lutte. Quelque chose est là en bas. Quelque chose qui ne veut pas être trouvé.';

  @override
  String get questC012Obj =>
      'Descendez dans la chambre nouvellement percée et découvrez ce qui a tué les mineurs.';

  @override
  String get questC013Title => 'Prison d\'échos';

  @override
  String get questC013Desc =>
      'Une ancienne prison dans les Hollows intermédiaires commence à se fissurer. Les pierres de garde faiblissent — le contremaître Brick dit que la pierre hurle la nuit. Ce qui est scellé à l\'intérieur devient plus fort d\'heure en heure.';

  @override
  String get questC013Obj =>
      'Naviguez dans la prison en ruine des Hollows et rescellez le lien avant que ce qui est à l\'intérieur ne se libère.';

  @override
  String get questC014Title => 'Les veines de lave';

  @override
  String get questC014Desc =>
      'Du magma remonte par des tunnels qui devraient être de la pierre froide. Des élémentaires de feu rampent hors de la roche en fusion — le sang de la Deep Mother, bouillonnant depuis les profondeurs. Les Ossborn se sont entièrement retirés de cette section.';

  @override
  String get questC014Obj =>
      'Atteignez la cheminée volcanique dans les Hollows profonds et scellez la brèche avant que le magma n\'atteigne les tunnels supérieurs.';

  @override
  String get questC015Title => 'Le trésor du dracoserpent';

  @override
  String get questC015Desc =>
      'Un dracoserpent des cavernes a creusé dans les Hollows intermédiaires et fait son nid sur un filon de minerai brut. Son souffle chauffe les tunnels jusqu\'à les rendre brûlants. Les Ossborn l\'ignorent — il n\'a brisé aucun sceau. Les mineurs ne le peuvent pas.';

  @override
  String get questC015Obj =>
      'Entrez dans le repaire du dracoserpent dans les Hollows et occupez-vous de lui.';

  @override
  String get questC016Title => 'Les voleurs de pierres de garde';

  @override
  String get questC016Desc =>
      'Quelqu\'un vole les pierres de garde des Hollows profonds et les revend comme curiosités magiques en surface. Les Ossborn ont répondu — quatre marchands sont morts, tués silencieusement dans leur lit. Les vols n\'ont pas cessé.';

  @override
  String get questC016Obj =>
      'Trouvez les voleurs de pierres de garde dans les Hollows avant que les Ossborn ne tuent tous les impliqués.';

  @override
  String get questC017Title => 'Le rite de greffe';

  @override
  String get questC017Desc =>
      'Une ancienne Ossborn a rompu avec les autres. Elle parle — avec hésitation, d\'une voix superposée aux échos de gardiens morts — et demande de l\'aide. Les os dans son corps rejettent la greffe. Si elle meurt, le savoir de trois gardiens meurt avec elle.';

  @override
  String get questC017Obj =>
      'Escortez l\'ancienne Ossborn défaillante jusqu\'à la forge profonde où le Forge Spirit peut stabiliser ses greffes.';

  @override
  String get questC018Title => 'La faille du Vide';

  @override
  String get questC018Desc =>
      'La réalité se déchire dans la chambre la plus profonde connue des Hollows. Des créatures du Vide se déversent par la fissure — la même corruption du Hollow décrite dans les textes universels. Même les Ossborn battent en retraite.';

  @override
  String get questC018Obj =>
      'Fermez la faille du Vide dans les Hollows les plus profonds avant que la brèche ne devienne permanente.';

  @override
  String get questC019Title => 'Les chaînes du titan';

  @override
  String get questC019Desc =>
      'Un titan scellé durant le Sundering a presque brisé ses liens. Ses tremblements effondrent les tunnels sur des kilomètres. Les Ossborn portent la mémoire de la façon dont les chaînes furent forgées à l\'origine — mais le savoir est fragmentaire, dispersé entre trois anciens qui ne s\'accordent plus sur la séquence.';

  @override
  String get questC019Obj =>
      'Travaillez avec le Forge Spirit et les Ossborn pour reforger les chaînes du titan avant qu\'il ne s\'éveille.';

  @override
  String get questC020Title => 'L\'Ossborn dément';

  @override
  String get questC020Desc =>
      'Un ancien Ossborn a sombré dans la folie — le poids des souvenirs d\'une douzaine de gardiens morts a écrasé sa propre identité. Il croit ÊTRE le gardien dont il porte les os, et il désactive systématiquement les sceaux que ce gardien avait posés, affirmant qu\'ils sont « les siens à relâcher ».';

  @override
  String get questC020Obj =>
      'Pistez l\'Ossborn dément à travers les Hollows profonds et arrêtez-le avant qu\'il n\'ouvre les prisons scellées.';

  @override
  String get questC021Title => 'La prison du Dévoreur';

  @override
  String get questC021Desc =>
      'Le Dévoreur — quelque chose qui précède même les dieux — s\'agite dans sa voûte sous les Hollows les plus profonds. Les Ossborn se sont rassemblés en nombres jamais vus depuis des siècles. Le Forge Spirit s\'est tu. Les pierres de garde faiblissent.';

  @override
  String get questC021Obj =>
      'Rassemblez les Pierres de Scellement et renforcez la prison du Dévoreur avant qu\'il ne se libère.';

  @override
  String get questC022Title => 'La porte démoniaque';

  @override
  String get questC022Desc =>
      'Une porte vers l\'abîme s\'est ouverte au point le plus bas des Hollows — un sceau qui tenait depuis le Sundering, maintenant fissuré. Des légions démoniaques s\'amassent de l\'autre côté. Les Ossborn portant la mémoire du gardien de ce sceau sont morts.';

  @override
  String get questC022Obj =>
      'Descendez au fond des Hollows et scellez la porte démoniaque avant que l\'invasion ne commence.';

  @override
  String get questC023Title => 'Le serpent des profondeurs';

  @override
  String get questC023Desc =>
      'Un serpent colossal s\'enroule à travers les tunnels inondés les plus profonds des Hollows. Son venin dissout la pierre de garde — les Ossborn ont perdu trois passages scellés dans son sillage acide. S\'il atteint le cercle de liaison, la prison du Dévoreur cède.';

  @override
  String get questC023Obj =>
      'Pistez le grand serpent à travers les tunnels inondés et tuez-le avant qu\'il ne détruise les liens.';

  @override
  String get questC024Title => 'Le cœur de la montagne';

  @override
  String get questC024Desc =>
      'Quelque chose d\'ancien bat au cœur de la montagne — le Cœur de la Montagne, un organe vivant de pierre et de magma qui pourrait être le propre cœur de la Deep Mother, battant encore après le Sundering. Il s\'éveille. Les Ossborn s\'agenouillent devant. Le Forge Spirit dit qu\'il doit être réduit au silence. Les Ossborn disent qu\'il ne le doit pas.';

  @override
  String get questC024Obj =>
      'Atteignez le Cœur de la Montagne au point le plus profond des Hollows et décidez de son sort.';

  @override
  String get questR001Title => 'Le tertre hanté';

  @override
  String get questR001Desc =>
      'Des lumières vacillent à l\'intérieur du plus ancien tertre des ruines de Valdris la nuit. Les morts ne reposent pas en paix dans ces salles en ruine — et l\'érudite Veyra dit que les murs bourdonnent si l\'on y colle l\'oreille.';

  @override
  String get questR001Obj =>
      'Entrez dans le tertre sous les ruines de Valdris et ramenez les morts sans repos au repos.';

  @override
  String get questR002Title => 'Vermine dans les souterrains';

  @override
  String get questR002Desc =>
      'Des rats géants ont envahi les souterrains sous les ruines de Valdris. Ils sont devenus assez hardis pour attaquer les chercheurs campés à l\'entrée.';

  @override
  String get questR002Obj =>
      'Descendez dans les souterrains des ruines et occupez-vous de l\'infestation de rats.';

  @override
  String get questR003Title => 'L\'idole murmurante';

  @override
  String get questR003Desc =>
      'Une idole de pierre a été exhumée dans les ruines de Valdris. Quiconque la touche entend des murmures dans une langue qu\'il comprend presque. L\'érudite Veyra dit que l\'idole est antérieure à Valdris même — elle ne devrait pas être ici.';

  @override
  String get questR003Obj =>
      'Trouvez et détruisez l\'idole maudite cachée dans les ruines de Valdris.';

  @override
  String get questR004Title => 'Pilleurs de tombes';

  @override
  String get questR004Desc =>
      'Des pilleurs de tombes forcent les chambres scellées des ruines de Valdris. L\'historien Korval est furieux — chaque sceau brisé libère davantage de ce qui rôde ici.';

  @override
  String get questR004Obj =>
      'Arrêtez les pilleurs de tombes avant qu\'ils ne brisent le mauvais sceau dans les ruines de Valdris.';

  @override
  String get questR005Title => 'Les morts sans repos';

  @override
  String get questR005Desc =>
      'Des squelettes patrouillent les couloirs des ruines de Valdris la nuit. Ils portent des armures du royaume qui se dressait jadis ici — des armures qui auraient dû rouiller jusqu\'à l\'oubli depuis des siècles.';

  @override
  String get questR005Obj =>
      'Trouvez la source des patrouilles de morts-vivants dans les couloirs de Valdris et mettez-les au repos.';

  @override
  String get questR006Title => 'La bibliothèque scellée';

  @override
  String get questR006Desc =>
      'Une bibliothèque scellée a été découverte dans les ruines de Valdris. L\'érudite Veyra dit que la porte réagit au toucher — elle est chaude, et le métal vibre comme si quelque chose de l\'autre côté respirait.';

  @override
  String get questR006Obj =>
      'Entrez dans la bibliothèque scellée des ruines de Valdris et récupérez ce qui s\'y trouve.';

  @override
  String get questR007Title => 'Les salles murmurantes';

  @override
  String get questR007Desc =>
      'Les ruines inférieures bourdonnent d\'un vrombissement sourd et lancinant. Ceux qui s\'y attardent trop longtemps se mettent à parler en langues mortes. L\'historien Korval attribue cela à un « enchantement résiduel ». L\'érudite Veyra est moins certaine.';

  @override
  String get questR007Obj =>
      'Trouvez ce qui crée le bourdonnement lancinant dans les salles inférieures de Valdris et faites-le taire.';

  @override
  String get questR008Title => 'Les sentinelles grises';

  @override
  String get questR008Desc =>
      'Des explorateurs rapportent avoir vu de grandes silhouettes décharnées immobiles dans les couloirs inférieurs — peau gris cendré, os anguleux, yeux creux. Elles ne répondent pas à la parole. Elles attaquent sans avertissement si l\'on s\'approche trop.';

  @override
  String get questR008Obj =>
      'Enquêtez sur les mystérieuses silhouettes grises dans les ruines profondes de Valdris.';

  @override
  String get questR009Title => 'La voûte maudite';

  @override
  String get questR009Desc =>
      'Une voûte plus profonde dans les ruines de Valdris laisse échapper une énergie sombre. Les gens à proximité somnambulent vers l\'entrée. L\'historien Korval dit que les artefacts à l\'intérieur sont antérieurs à Valdris de plusieurs siècles — ce qui devrait être impossible.';

  @override
  String get questR009Obj =>
      'Entrez dans la voûte de Valdris et détruisez la collection d\'artefacts maudits.';

  @override
  String get questR010Title => 'Crypte de la peste';

  @override
  String get questR010Desc =>
      'Une caravane de morts-vivants a émergé de sous les ruines de Valdris. La peste qu\'ils portent rend la chair grise — le même gris que les sentinelles silencieuses plus profondément à l\'intérieur.';

  @override
  String get questR010Obj =>
      'Descendez dans la crypte sous les ruines et scellez la source de la peste ambulante.';

  @override
  String get questR011Title => 'Le traqueur d\'ombres';

  @override
  String get questR011Desc =>
      'Un assassin spectral traque un marchand qui s\'est aventuré dans les ruines de Valdris à la recherche de trésors. Trois gardes sont morts — tués par quelque chose qui se déplaçait à travers les murs comme s\'ils n\'existaient pas.';

  @override
  String get questR011Obj =>
      'Pistez l\'assassin spectral à travers les ruines et protégez le marchand.';

  @override
  String get questR012Title => 'Le corridor en boucle';

  @override
  String get questR012Desc =>
      'L\'érudite Veyra a envoyé une équipe dans les ruines de profondeur moyenne. Ils sont revenus trois jours plus tard — jurant qu\'une seule heure s\'était écoulée. Ils disent que chaque couloir ramenait à la même salle. L\'un d\'eux a dessiné un plan. Le plan est impossible.';

  @override
  String get questR012Obj =>
      'Naviguez dans les corridors en boucle des ruines profondes de Valdris et découvrez ce qui cause la distorsion spatiale.';

  @override
  String get questR013Title => 'L\'éveil Tithebound';

  @override
  String get questR013Desc =>
      'Un Tithebound a été capturé vivant — une première. Il est assis dans une cage au camp de Korval, se balançant et murmurant des phrases brisées. Puis il a dit quelque chose clairement : « Ils reviennent. » Il n\'a plus parlé depuis.';

  @override
  String get questR013Obj =>
      'Descendez dans les ruines plus profondes et enquêtez sur ce que le Tithebound capturé voulait dire.';

  @override
  String get questR014Title => 'Le sanctuaire englouti';

  @override
  String get questR014Desc =>
      'Un temple se trouve à moitié submergé dans les ruines inférieures inondées. Les bâtisseurs de Valdris n\'auraient pas dû construire aussi profond — à moins que les ruines ne s\'étendent plus loin que quiconque ne le croyait.';

  @override
  String get questR014Obj =>
      'Plongez dans le sanctuaire inondé et arrêtez ce qui s\'agite en dessous.';

  @override
  String get questR015Title => 'Le culte de Valdris';

  @override
  String get questR015Desc =>
      'Un culte s\'est formé parmi les obsédés des ruines — des mortels qui croient que Valdris a été emporté, non détruit, et qu\'ils peuvent le suivre où qu\'il soit allé. Ils ont consacré un autel de sang dans la salle du trône.';

  @override
  String get questR015Obj =>
      'Détruisez l\'autel de sang du culte dans la salle du trône de Valdris avant que leur rituel ne s\'achève.';

  @override
  String get questR016Title => 'La mauvaise salle';

  @override
  String get questR016Desc =>
      'Une équipe de cartographes a trouvé une salle qui ne devrait pas exister. Elle ne figure sur aucun plan. La porte était scellée de l\'intérieur. Quand ils l\'ont ouverte, l\'un d\'eux a dit : « Cette salle est plus grande que le bâtiment qui la contient. » Il avait raison.';

  @override
  String get questR016Obj =>
      'Entrez dans la salle impossible des ruines de Valdris et survivez à ce qui s\'y trouve.';

  @override
  String get questR017Title => 'La guerre Tithebound';

  @override
  String get questR017Desc =>
      'Les Tithebound se sont divisés en deux factions dans les ruines profondes. Un groupe attaque quiconque entre. L\'autre se tient aux bords, observant, sans faire un geste pour les arrêter — ni pour aider. Quelque chose a changé en bas.';

  @override
  String get questR017Obj =>
      'Naviguez dans le conflit Tithebound des ruines profondes et atteignez la chambre accessible la plus basse.';

  @override
  String get questR018Title => 'Le son revient';

  @override
  String get questR018Desc =>
      'Le bourdonnement que les érudits avaient rejeté est devenu un son — un bruit changeant et stratifié qui efface les contours de vos pensées. L\'érudite Veyra ne peut plus entrer dans les ruines profondes. Elle dit qu\'elle a oublié son propre nom pendant trois secondes et que c\'était suffisant.';

  @override
  String get questR018Obj =>
      'Descendez dans les ruines les plus profondes où le son est le plus fort et découvrez sa source.';

  @override
  String get questR019Title => 'La confession de l\'ancienne';

  @override
  String get questR019Desc =>
      'Une ancienne Tithebound — plus consciente que toute autre rencontrée — s\'est approchée du campement de surface. Elle parle en phrases hésitantes mais complètes. Elle dit qu\'elle se souvient de ce qui est arrivé à son peuple. Elle veut le dire à quelqu\'un avant que le Choir ne le prenne.';

  @override
  String get questR019Obj =>
      'Protégez l\'ancienne Tithebound consciente pendant qu\'elle parle et apprenez ce qui est arrivé à son espèce.';

  @override
  String get questR020Title => 'À travers le Choir';

  @override
  String get questR020Desc =>
      'La blessure du Severance est ouverte. Le Nameless Choir emplit la chambre la plus profonde — un son qui dépouille tout. Au-delà, à travers la déchirure, des tours de pierre pâle sont visibles. Valdris n\'a pas été détruit. Il a été emporté. Le joueur peut le voir.';

  @override
  String get questR020Obj =>
      'Traversez le Nameless Choir et entrez dans la dimension repliée de Valdris.';

  @override
  String get questR021Title => 'Le royaume vivant';

  @override
  String get questR021Desc =>
      'Valdris est vivant. Les rues sont pavées de verre sombre qui ne reflète aucune étoile. Des citoyens avancent en lentes processions, souriant trop largement, répétant les mêmes mots. L\'architecture se tord aux bords. Quelque chose est profondément, fondamentalement mauvais.';

  @override
  String get questR021Obj =>
      'Explorez le royaume replié de Valdris et comprenez ce qui est arrivé à son peuple.';

  @override
  String get questR022Title => 'Le trône qui connaît votre nom';

  @override
  String get questR022Desc =>
      'La salle du trône est toujours visible depuis n\'importe quelle rue, comme si la cité se courbait vers elle. Quelque chose est assis sur le trône. Cela porte une couronne. Ce n\'est pas un roi. Cela connaît le nom du joueur.';

  @override
  String get questR022Obj =>
      'Entrez dans la salle du trône de Valdris et affrontez ce qui règne sur le royaume replié.';

  @override
  String get questR023Title => 'Le Severance défait';

  @override
  String get questR023Desc =>
      'L\'entité du trône a été défiée. Le royaume tremble. Le Choir hurle. La blessure dimensionnelle qui a créé cette prison se déstabilise — si elle s\'effondre avec le joueur à l\'intérieur, il est piégé dans Valdris pour toujours. Mais si la blessure peut être forcée plus large, Valdris pourrait retourner dans le monde réel.';

  @override
  String get questR023Obj =>
      'Fuyez la dimension de Valdris en train de se replier avant que la blessure du Severance ne se referme — ou trouvez un moyen de briser le Severance entièrement.';

  @override
  String get itemWpn001Name => 'Couteau d\'Éclat du Sundering';

  @override
  String get itemWpn001Desc =>
      'Un couteau grossier taillé dans une pierre tombée durant la guerre des Dieux Premiers-Nés. Il vibre faiblement lorsqu\'on le tient — un écho du coup qui fissura la réalité elle-même.';

  @override
  String get itemWpn002Name => 'Arc de Traqueur du Thornveil';

  @override
  String get itemWpn002Desc =>
      'Un arc de chasse court en bois d\'épines vivant, dont les branches portent encore des bourgeons verts qui n\'éclosent jamais. Le Thornveil les offre volontiers aux traqueurs mortels qu\'il tolère — la corde émet une note que seules les créatures de la forêt entendent, et elles fuient.';

  @override
  String get itemWpn003Name => 'Lame de Gardien des Hollows';

  @override
  String get itemWpn003Desc =>
      'Une épée courte et large en fer sombre, gravée de runes de gardien luisantes le long de la gouttière. Portée par les mineurs qui travaillent dans les Hollows supérieurs — là où les choses dans l\'obscurité exigent plus qu\'une lanterne.';

  @override
  String get itemWpn004Name => 'Lame Rituelle Tithebound';

  @override
  String get itemWpn004Desc =>
      'Une lame longue et fine de métal gris portée par les Tithebound — les gardiens à la peau cendrée qui patrouillent les ruines de Valdris en boucles qu\'ils ne peuvent expliquer. Celle-ci fut lâchée par une sentinelle qui s\'arrêta en pleine patrouille et oublia simplement comment bouger.';

  @override
  String get itemWpn005Name => 'Fauchon Touché-par-le-Hollow';

  @override
  String get itemWpn005Desc =>
      'Une lame laissée trop longtemps près d\'une plaie dans la réalité où le Hollow suinte. La substance du vide a rongé l\'acier, le rendant plus léger et impossiblement tranchant — mais le métal s\'effrite un peu plus chaque jour.';

  @override
  String get itemWpn006Name => 'Arbalète Murmurante de Pale Root';

  @override
  String get itemWpn006Desc =>
      'Une arbalète compacte en bois blanchi, son rail incrusté de pétales broyés qui étouffent tout son. Les Pale Root les utilisent depuis la Haute Canopée — deux seigneurs tombèrent avant que quiconque n\'entende le carreau. La Verdant Court prétend qu\'elles n\'existent pas.';

  @override
  String get itemWpn007Name => 'Hallebarde d\'Art de Gardien';

  @override
  String get itemWpn007Desc =>
      'Forgée selon des techniques héritées par le Rite de la Greffe — des motifs qu\'aucun esprit vivant n\'a conçus, martelés à partir de mémoires conservées dans les os de gardiens morts. La séquence de runes le long du manche correspond à une prière de scellement qui enferma quelque chose dans les profondeurs intermédiaires.';

  @override
  String get itemWpn008Name => 'Lame-Bâton de Morvaine';

  @override
  String get itemWpn008Desc =>
      'Le bâton de marche de Morvaine, l\'apprenti dont la quête de la licherie brisa Valdris de l\'intérieur — du moins selon les chroniques. Le bois est pétrifié, et le cristal à son sommet montre un royaume qui ne ressemble en rien à des ruines.';

  @override
  String get itemWpn009Name => 'Dîme de la Mort';

  @override
  String get itemWpn009Desc =>
      'Une faux qui n\'a appartenu à aucun faucheur — elle est simplement apparue là où la Mort était récemment passée. La Mort est l\'aînée des trois dieux survivants, marche librement entre les deux mondes et ne répond à aucune prière. Cette lame porte la même froide indifférence.';

  @override
  String get itemWpn010Name => 'Tendon du World Tree';

  @override
  String get itemWpn010Desc =>
      'Un arc long cordé avec une fibre de racine du World Tree lui-même — le titan haut de plusieurs lieues dont les racines percent le monde souterrain. Les flèches tirées de cet arc dévient vers les êtres vivants, comme si l\'Arbre avait encore faim de ce qui pousse hors de sa portée.';

  @override
  String get itemWpn011Name => 'Grand Marteau du Forge Spirit';

  @override
  String get itemWpn011Desc =>
      'Un marteau qui irradie la chaleur du cœur du monde. Le Forge Spirit qui entretient les anciens sceaux l\'utilisait pour réparer les pierres de garde — et pour écraser tout ce qui émergeait quand ces réparations arrivaient trop tard.';

  @override
  String get itemWpn012Name => 'Tranchant du Severance';

  @override
  String get itemWpn012Desc =>
      'Une lame forgée dans le verre sombre qui pave les rues de Valdris — non pas les ruines, mais le royaume vivant replié dans une dimension qui ne devrait pas exister. Le verre reflète des couloirs que vous n\'avez jamais parcourus et un ciel sans étoiles.';

  @override
  String get itemWpn013Name => 'Arc de Floraison de Seylith';

  @override
  String get itemWpn013Desc =>
      'Un arc cérémoniel cultivé dans les cavités racinaires du World Tree durant le Rite de la Floraison — l\'épreuve qui détermine la succession Vaelithi. Sa corde fait germer des flèches d\'épines d\'elle-même. La Reine Seylith tendit cet arc pendant quatre siècles. Il n\'a jamais manqué sa cible.';

  @override
  String get itemWpn014Name => 'Croc de la Deep Mother';

  @override
  String get itemWpn014Desc =>
      'Une stalactite arrachée juste au-dessus du Cœur de la Montagne — l\'organe vivant de pierre et de magma qui bat dans les profondeurs des Hollows. Certains érudits pensent qu\'il s\'agit du propre cœur de la Deep Mother. Ce croc dégoutte encore de dépit en fusion.';

  @override
  String get itemWpn015Name => 'Lame du Pacte d\'Azrathar';

  @override
  String get itemWpn015Desc =>
      'L\'arme que le démon Azrathar offrit jadis à Valdris en échange d\'un passage vers le monde mortel. Les chroniques accusent Azrathar de la chute du royaume — mais la lame ne fut jamais utilisée. Ce qui détruisit Valdris n\'était pas un démon. C\'était quelque chose de bien pire.';

  @override
  String get itemArm001Name => 'Bandelettes de Tissu du Sundering';

  @override
  String get itemArm001Desc =>
      'Des bandes de tissu ancien récupérées sur un champ de bataille plus vieux que tout royaume. Le tissu fut tissé avant que les Dieux Premiers-Nés ne se fassent la guerre — quand la création était encore d\'un seul tenant.';

  @override
  String get itemArm002Name => 'Cuirs de Contrebandier des Tunnels';

  @override
  String get itemArm002Desc =>
      'Du cuir durci cousu par les contrebandiers qui font passer de la marchandise dans les Hollows supérieurs à la lueur des torches. Taché de résidu fongique bioluminescent qui ne part jamais tout à fait.';

  @override
  String get itemArm003Name => 'Cuirasse d\'Écorce du Thornveil';

  @override
  String get itemArm003Desc =>
      'Un plastron façonné dans l\'écorce tombée du Thornveil. La forêt donna ce bois de plein gré — un arbre frappé par la foudre, déjà mort. Même dans la mort, l\'écorce résiste à la pourriture avec un entêtement vivace.';

  @override
  String get itemArm004Name => 'Manteau de Pilleur de Tombes de Valdris';

  @override
  String get itemArm004Desc =>
      'Du cuir rapiécé porté par ceux assez fous pour piller les ruines supérieures de Valdris. Chaque poche cliquète de bibelots volés qui murmurent quand le vent tourne mal. L\'érudite Veyra condamne les pilleurs. Ils portent sa désapprobation comme un insigne.';

  @override
  String get itemArm005Name => 'Plates Scarifiées par le Hollow';

  @override
  String get itemArm005Desc =>
      'Des plaques d\'acier déformées par la proximité du Hollow — la corruption du vide qui suinte par les fissures de la réalité. Le métal se plie selon des angles qui ne devraient pas tenir, pourtant l\'armure est plus légère et plus dure que ce qu\'aucune forge pourrait produire.';

  @override
  String get itemArm006Name => 'Carapace Greffée Ossborn';

  @override
  String get itemArm006Desc =>
      'Une armure assemblée à partir de plaques osseuses perdues par les Ossborn — les moines aveugles qui portent les mémoires des gardiens morts dans leurs squelettes fusionnés. Chaque plaque vibre à une fréquence différente, comme si elle se souvenait d\'une voix différente.';

  @override
  String get itemArm007Name => 'Mailles Cérémonielles de la Verdant Court';

  @override
  String get itemArm007Desc =>
      'Une cotte de mailles en alliage vert-or, chaque anneau en forme de minuscule feuille. Portée par les douze seigneurs de la Haute Canopée de la Verdant Court de Vaelith — avant que deux ne soient assassinés par les Pale Root. Ce jeu appartenait à l\'un des défunts.';

  @override
  String get itemArm008Name => 'Plates de Sentinelle Tithebound';

  @override
  String get itemArm008Desc =>
      'Une armure chitineuse cultivée — non forgée — par les sentinelles Tithebound dans les ruines profondes. Faite de leur propre peau morte, superposée au fil des siècles. Gris-cendre et chaude au toucher, comme si quelque chose à l\'intérieur se souvenait encore d\'être vivant.';

  @override
  String get itemArm009Name => 'Mailles Bénies du Radieux';

  @override
  String get itemArm009Desc =>
      'Une armure de plates bénie par les clercs qui entretiennent les sceaux de scellement au nom du Radieux. Le dieu qui forgea le soleil proclama sa domination sur le monde de surface — cette armure porte ce décret martelé dans chaque rivet.';

  @override
  String get itemArm010Name => 'Carapace de la Deep Mother';

  @override
  String get itemArm010Desc =>
      'De la chitine récoltée sur des créatures nées trop près du Cœur de la Montagne. La Deep Mother s\'enfouit au cœur de la terre et revendiqua tout ce qui se trouve sous la pierre — ces carapaces portent sa fureur territoriale, durcissant sous la pression.';

  @override
  String get itemArm011Name => 'Armure Vivante du Thornwall';

  @override
  String get itemArm011Desc =>
      'Une armure cultivée à partir d\'un fragment du Thornwall lui-même — la barrière enchantée de ronces qui scelle Vaelith du monde mortel. Les humains qui traversent le Thornwall ne reviennent pas. Cette armure fut arrachée au bord du mur, et elle n\'a pas cessé de croître.';

  @override
  String get itemArm012Name => 'Linceul Ambulant de la Mort';

  @override
  String get itemArm012Desc =>
      'Une cape d\'un noir absolu qui ne pèse rien et va à tout le monde. La Mort est l\'aînée des trois dieux survivants et marche librement entre les deux mondes. Ce linceul drapait jadis quelque chose qui se tenait dans l\'ombre de la Mort — et l\'ombre ne l\'a jamais tout à fait quitté.';

  @override
  String get itemArm013Name => 'Vestiges de l\'Arcaniste de Cour';

  @override
  String get itemArm013Desc =>
      'Des robes portées par les Arcanistes de la Cour de Valdris qui lancèrent le Severance — le sort qui attira un royaume entier dans une dimension repliée. Les Arcanistes furent consumés par leur propre ouvrage. Les robes se souviennent de l\'incantation dans chaque sigille tissé.';

  @override
  String get itemArm014Name => 'Plates de Chaînes du Titan';

  @override
  String get itemArm014Desc =>
      'Une armure forgée à partir des véritables chaînes qui lièrent un titan dans les profondeurs intermédiaires durant le Sundering. Le titan sommeille encore en dessous — et les chaînes se resserrent toujours quand quelque chose s\'agite dans sa prison. En les portant, vous sentez le poids de maintenir un dieu en place.';

  @override
  String get itemArm015Name => 'Voile d\'Outre-monde du Royaume Replié';

  @override
  String get itemArm015Desc =>
      'Un vêtement tissé à partir de la membrane entre le monde mortel et la dimension repliée où Valdris vit encore. Il sent l\'air immobile d\'un royaume où le temps boucle, et se courbe autour de celui qui le porte comme la réalité se ploie pour éviter le Severance.';

  @override
  String get itemAcc001Name => 'Sceau de Scellement Fissuré';

  @override
  String get itemAcc001Desc =>
      'Un fragment de pierre de garde de la taille d\'une paume, porté en pendentif. Les clercs entretiennent ces sceaux à travers le monde — celui-ci s\'est fissuré, et ce qu\'il retenait a disparu depuis longtemps. Un rappel que le monde a besoin d\'être maintenu, un sceau brisé à la fois.';

  @override
  String get itemAcc002Name => 'Charme de Pacte Féerique';

  @override
  String get itemAcc002Desc =>
      'Un nœud tordu de fil d\'argent et de pétales séchés, offert par les sprites de la Cour Féerique en échange d\'un secret. Le pacte est simple : portez ceci, et les vieux esprits farceurs ne vous joueront que de doux tours. Quand les pactes s\'effilochent, même ceci ne vous aidera plus.';

  @override
  String get itemAcc003Name => 'Lanterne Fongique Bioluminescente';

  @override
  String get itemAcc003Desc =>
      'Un amas de champignons de caverne en cage qui luisent sous l\'influence ambiante de la Deep Mother. Les mineurs les préfèrent aux torches — ils ne s\'éteignent jamais, et pulsent plus vite quand quelque chose vous observe depuis l\'obscurité.';

  @override
  String get itemAcc004Name => 'Pendentif de Recherche de Korval';

  @override
  String get itemAcc004Desc =>
      'Un médaillon en laiton contenant un fragment des notes de l\'Historien Korval sur l\'architecture de Valdris — plus précisément, ses observations confuses sur des pièces qui semblent plus grandes à l\'intérieur qu\'à l\'extérieur. Il l\'attribua à un enchantement résiduel. Il avait tort.';

  @override
  String get itemAcc005Name => 'Amulette du Vide du Hollow';

  @override
  String get itemAcc005Desc =>
      'Une gemme trouée — non pas un trou physique, mais une absence là où le Hollow a défait le centre du cristal. La lumière contourne le vide. Le fixer trop longtemps vous fait oublier ce que vous regardiez.';

  @override
  String get itemAcc006Name => 'Chevalière du Circle of Thorn';

  @override
  String get itemAcc006Desc =>
      'Un anneau de bois vivant porté par les druides du Circle of Thorn — médiateurs entre mortels et Fey. Leurs rangs s\'amenuisent à chaque décennie. Cette chevalière canalise encore les anciens pactes, bien que de moins en moins y répondent.';

  @override
  String get itemAcc007Name => 'Fragment de Mémoire Ossborn';

  @override
  String get itemAcc007Desc =>
      'Un éclat d\'os d\'un ancien Ossborn — un morceau tombé lors du Rite de la Greffe. Il porte une seule mémoire de gardien : la séquence exacte de runes qui maintint une prison scellée pendant trois mille ans. La séquence se joue dans vos rêves.';

  @override
  String get itemAcc008Name => 'Pierre de Résonance Tithebound';

  @override
  String get itemAcc008Desc =>
      'Une pierre grise et lisse qui vibre à la même fréquence que les yeux creux des Tithebound. Quand on la tient, on entend ce qu\'ils entendent — un son faible venu de loin sous les ruines qui prend la forme de ce que vous désirez le plus. Ce n\'est pas un appel. C\'est un appât.';

  @override
  String get itemAcc009Name => 'Anneau Ambulant de la Mort';

  @override
  String get itemAcc009Desc =>
      'Un anneau de métal blanc-os, lisse et froid. La Mort marche librement entre les deux mondes et ne répond à aucune prière — mais la Mort remarque ceux qui portent des artefacts divins. Cet anneau garantit que vous êtes remarqué en retour.';

  @override
  String get itemAcc010Name => 'Broche de Pierre de Lune de Seylith';

  @override
  String get itemAcc010Desc =>
      'Une broche d\'artisanat elfique sertie d\'une pierre de lune qui retient quatre siècles de lumière — un pour chaque année du règne de la Reine Seylith l\'Immortelle. Les Vaelithi ne se séparent pas de celles-ci. Qu\'elle existe hors du Thornwall signifie que quelqu\'un a déserté ou est mort.';

  @override
  String get itemAcc011Name => 'Brassards d\'Os de Gardien';

  @override
  String get itemAcc011Desc =>
      'Des brassards taillés dans les os d\'anciens gardiens — les originaux qui enchaînèrent les titans et scellèrent les démons. Les Ossborn greffèrent ces os en eux-mêmes. Ces brassards portent ce que les Ossborn choisirent de ne pas garder.';

  @override
  String get itemAcc012Name => 'Pendentif de Silence du Chœur';

  @override
  String get itemAcc012Desc =>
      'Un pendentif qui génère une sphère de silence absolu — façonné par un ancien Tithebound qui avait conservé assez de conscience pour comprendre ce que fait le Nameless Choir. Le silence n\'est pas paisible. C\'est l\'absence du son qui vous défait.';

  @override
  String get itemAcc013Name => 'Larme du Premier-Né';

  @override
  String get itemAcc013Desc =>
      'Une larme cristallisée versée durant le Sundering — de quel des trois dieux survivants, aucun érudit ne s\'accorde. Le Radieux pleura pour le soleil. La Deep Mother pleura pour la terre. La Mort, aînée de tous, ne pleure pas — mais quelque chose tomba de son visage.';

  @override
  String get itemAcc014Name => 'Couronne du Rite de la Floraison';

  @override
  String get itemAcc014Desc =>
      'La couronne formée dans les cavités racinaires du World Tree durant le Rite de la Floraison — l\'épreuve ultime de la succession Vaelithi. Les candidats descendent et reviennent changés, ou ne reviennent pas du tout. Cette couronne fut trouvée à côté de quelqu\'un qui n\'est pas revenu.';

  @override
  String get itemAcc015Name => 'Œil de la Deep Mother';

  @override
  String get itemAcc015Desc =>
      'Pas une métaphore. Pas une gemme en forme d\'œil. Un œil — blanc laiteux, de la taille d\'un poing, chaud et humide, et il cligne. Arraché d\'une crevasse près du Cœur de la Montagne là où la roche s\'amincissait assez pour voir au travers. La Deep Mother voit encore au travers.';

  @override
  String get itemRel001Name => 'Sceau de Scellement Fracturé';

  @override
  String get itemRel001Desc =>
      'Une pierre de garde brisée — l\'une des milliers dispersées à travers les prisons antiques qui s\'effritent. Les druides entretiennent les racines du World Tree, les clercs maintiennent les sceaux de scellement, et les héros portent des lames dans les ténèbres. Vous portez un morceau de ce qu\'ils luttent tous pour maintenir.';

  @override
  String get itemRel002Name => 'Spore Bioluminescente des Hollows';

  @override
  String get itemRel002Desc =>
      'Un amas fongique vivant des Hollows supérieurs, pulsant sous l\'influence ambiante de la Deep Mother. Il éclaire les lieux sombres d\'une lueur verdâtre maladive et recule devant la chaleur, comme si la Deep Mother désapprouvait le feu du Radieux.';

  @override
  String get itemRel003Name => 'Journal de Terrain de l\'Érudite Veyra';

  @override
  String get itemRel003Desc =>
      'Un journal usé appartenant à l\'érudite Veyra, qui catalogue les ruines supérieures de Valdris aux côtés de l\'Historien Korval. Ses notes sont méticuleuses mais confuses — des mesures qui se contredisent, des croquis de pièces plus grandes à l\'intérieur qu\'à l\'extérieur. Elle appelle cela \"enchantement résiduel\". Elle a tort.';

  @override
  String get itemRel004Name => 'Lanterne à Feu Follet du Thornveil';

  @override
  String get itemRel004Desc =>
      'Une cage de lianes vivantes contenant un feu follet capturé des Cours Féeriques. Les anciens pactes qui lient les fey sont antérieurs même aux elfes — ce feu follet a accepté de servir en échange d\'une protection contre ce qui arrive quand ces pactes finiront par se rompre.';

  @override
  String get itemRel005Name => 'Éclat du Hollow';

  @override
  String get itemRel005Desc =>
      'Un fragment cristallisé du Hollow lui-même — substance du vide durcie en quelque chose de presque physique. Il défait lentement ce qu\'il touche : le bois grisonne, le métal se corrode, la peau s\'engourdit. Le Hollow ne se répand pas comme une invasion mais comme une érosion. Voici ce à quoi l\'érosion ressemble tenue dans votre main.';

  @override
  String get itemRel006Name => 'Braise du Forge Spirit';

  @override
  String get itemRel006Desc =>
      'Un fragment de flamme vivante du Forge Spirit — l\'entité ancienne qui entretient les sceaux faiblissants dans les Hollows. Il considère les Ossborn comme des outils, pas des alliés. Il vous considère comme moins que cela. Mais la braise brûle, et elle brûle juste.';

  @override
  String get itemRel007Name => 'Éclat de Pierre de Garde de Valdris';

  @override
  String get itemRel007Desc =>
      'Un fragment des protections qui protégeaient jadis Valdris — avant que Morvaine ne les brise de l\'intérieur, ou qu\'Azrathar ne les perce de l\'extérieur. Les chroniques divergent. Cet éclat vibre à une fréquence qui fait mal aux dents, et montre parfois un royaume qui ne ressemble en rien à des ruines.';

  @override
  String get itemRel008Name => 'Cœur de Racine du World Tree';

  @override
  String get itemRel008Desc =>
      'Un nœud de duramen noueux provenant des profondeurs du réseau racinaire du World Tree — là où les racines percent le monde souterrain. Quelque chose s\'agite dans ces cavités racinaires que les Vaelithi refusent de nommer : un fléau qui flétrit leurs arbres de l\'intérieur. Ce cœur pulse encore de vie, mais ses bords sont gris.';

  @override
  String get itemRel009Name => 'Clé de Voûte de la Prison du Dévoreur';

  @override
  String get itemRel009Desc =>
      'Une clé de voûte de la crypte la plus profonde des Hollows — la prison qui retient le Dévoreur, quelque chose d\'antérieur même aux dieux. Le Forge Spirit entretient ce sceau par-dessus tous les autres. Les Ossborn refusent de s\'en approcher. La clé de voûte est chaude, et si vous y pressez l\'oreille, vous entendez respirer.';

  @override
  String get itemRel010Name => 'Maillon de Chaîne du Titan';

  @override
  String get itemRel010Desc =>
      'Un seul maillon des chaînes forgées durant le Sundering pour lier les titans dans leurs prisons. Les chaînes furent faites pour retenir des dieux. Un seul maillon porte encore cette vocation — quand on le tient, on sent le poids de maintenir en place quelque chose d\'incommensurable.';

  @override
  String get itemRel011Name => 'Écho du Nameless Choir';

  @override
  String get itemRel011Desc =>
      'Un diapason qui vibre à la fréquence exacte du Nameless Choir — le son que produit une plaie dimensionnelle quand elle refuse de se refermer. Une exposition prolongée dépouille la mémoire : d\'abord les petites choses, puis les grandes. En le tenant, vous entendez la première note. Elle ressemble à quelque chose que vous avez oublié.';

  @override
  String get itemRel012Name => 'Cœur de la Verdant Court';

  @override
  String get itemRel012Desc =>
      'Le noyau d\'émeraude de la gouvernance de Vaelith — une gemme vivante cultivée au sein du trône de la Verdant Court au fil des siècles. Elle contient la volonté accumulée de chaque monarque Vaelithi ayant passé le Rite de la Floraison. La Reine Seylith siégea à ses côtés pendant quatre cents ans. La gemme se souvient de chacun d\'entre eux.';

  @override
  String get itemRel013Name => 'Pierre-Cœur de la Deep Mother';

  @override
  String get itemRel013Desc =>
      'Un fragment du Cœur de la Montagne lui-même — l\'organe vivant de pierre et de magma que les érudits croient être le propre cœur de la Deep Mother, battant encore après le Sundering. Il pulse dans votre main à un rythme plus lent que celui de tout cœur mortel, et le sol tremble en sympathie.';

  @override
  String get itemRel014Name => 'Catalyseur du Severance';

  @override
  String get itemRel014Desc =>
      'Le foyer cristallin à travers lequel les Arcanistes de la Cour de Valdris canalisèrent le Severance — le sort qui replia un royaume entier dans une dimension qui ne devrait pas exister. Les Arcanistes furent consumés. Le catalyseur survécut. Il veut encore replier les choses.';

  @override
  String get itemRel015Name => 'La Blessure du Sundering';

  @override
  String get itemRel015Desc =>
      'Pas un objet — une cicatrice dans la réalité elle-même, contenue dans une sphère de verre de scellement fabriquée par les premiers gardiens. À l\'intérieur, vous voyez la blessure originelle : la fissure que les Dieux Premiers-Nés déchirèrent dans la création. Elle n\'a jamais guéri. Le Hollow suinte de blessures comme celle-ci. La porter, c\'est porter la raison pour laquelle le monde est brisé.';

  @override
  String get itemSpl001Name => 'Trait d\'Éclat';

  @override
  String get itemSpl001Desc =>
      'Un trait dentelé d\'énergie cristallisée du Sundering projeté sur l\'ennemi. Les fragments vibrent de l\'écho du coup qui fissura la réalité — même un éclat porte cette violence ancienne.';

  @override
  String get itemSpl002Name => 'Fouet d\'Épines';

  @override
  String get itemSpl002Desc =>
      'Le Thornveil répond à ceux qui prononcent ses anciens noms. Cette invocation appelle un fouet d\'épines vivantes depuis le sol de la forêt pour lacérer et entraver les ennemis dans des lianes barbelées.';

  @override
  String get itemSpl003Name => 'Peau de Pierre';

  @override
  String get itemSpl003Desc =>
      'La pierre profonde des Hollows se souvient de l\'Art de Gardien — l\'ancien art de lier la terre à la chair. Cette protection recouvre le lanceur d\'une coquille de roche vivante qui dévie les lames.';

  @override
  String get itemSpl004Name => 'Projectile Arcanique';

  @override
  String get itemSpl004Desc =>
      'Les Arcanistes de la Cour de Valdris ont affiné le mana brut en traits précis qui traquent leurs cibles à travers les couloirs et par-dessus les obstacles. Le sort est élémentaire selon leurs critères — et dévastateur selon ceux de tous les autres.';

  @override
  String get itemSpl005Name => 'Drain du Hollow';

  @override
  String get itemSpl005Desc =>
      'Une technique interdite qui canalise la faim du Hollow. Le lanceur ouvre une fissure capillaire entre les mondes et le vide s\'abreuve de la force vitale de l\'ennemi, en rendant une fraction au lanceur.';

  @override
  String get itemSpl006Name => 'Floraison Verdoyante';

  @override
  String get itemSpl006Desc =>
      'Une prière au World Tree canalisée à travers du bois vivant. Une lumière vert-or éclôt autour du lanceur, recousant les plaies et purgeant la corruption. Les guérisseurs Vaelithi appelaient cela la Première Floraison — le don le plus simple que l\'Arbre accorde encore.';

  @override
  String get itemSpl007Name => 'Vague de Magma';

  @override
  String get itemSpl007Desc =>
      'Au plus profond des Hollows, le Forge Spirit martèle encore son enclume éternelle. Cette invocation emprunte un souffle de son feu — la pierre liquide jaillit du sol en une vague brûlante qui fond armure et chair.';

  @override
  String get itemSpl008Name => 'Dîme d\'Âme';

  @override
  String get itemSpl008Desc =>
      'Les Tithebound de Valdris payaient leurs dettes en substance d\'âme, non en pièces. Cet enchantement sinistre exige le même prix d\'un ennemi — arrachant un éclat de son essence pour alimenter la prochaine frappe du lanceur.';

  @override
  String get itemSpl009Name => 'Jugement Radieux';

  @override
  String get itemSpl009Desc =>
      'Une colonne de lumière incandescente invoquée au nom du Radieux. Le Dieu Premier-Né de la lumière est peut-être diminué, mais cet écho de courroux divin brûle encore — surtout contre les créatures du Hollow.';

  @override
  String get itemSpl010Name => 'Mirage Féerique';

  @override
  String get itemSpl010Desc =>
      'Les Cours Féeriques traitent en glamour et en tromperie. Ce charme enveloppe le lanceur de couches de doubles illusoires qui désorientent les ennemis, faisant frapper leurs attaques sur des fantômes tandis que le vrai lanceur se déplace invisible.';

  @override
  String get itemSpl011Name => 'Gueule Tellurique';

  @override
  String get itemSpl011Desc =>
      'La faim de la Deep Mother incarnée. Le sol s\'ouvre en une mâchoire hérissée de dents de pierre qui se referme sur l\'ennemi, l\'écrasant et le piégeant dans l\'étreinte de la terre.';

  @override
  String get itemSpl012Name => 'Chœur de la Défaisance';

  @override
  String get itemSpl012Desc =>
      'Le Nameless Choir chanta les murs de Valdris à l\'existence — et leurs échos emprisonnés connaissent encore la contre-mélodie. Ce sort libère une plainte discordante qui défait les enchantements, les protections et la volonté de combattre.';

  @override
  String get itemSpl013Name => 'Murmure de la Mort';

  @override
  String get itemSpl013Desc =>
      'La Mort dans ce monde n\'est pas une fin mais une collectrice patiente. Cette invocation interdite emprunte la voix de la Mort pour une seule syllabe — un murmure qui rappelle aux êtres mortels qu\'ils sont mortels. Les forts peuvent résister. Les faibles cessent simplement.';

  @override
  String get itemSpl014Name => 'Faille du Severance';

  @override
  String get itemSpl014Desc =>
      'Un fragment contrôlé du Severance — le sort qui replia le royaume de Valdris dans une dimension qui ne devrait pas exister. Ceci déchire une brève faille dans l\'espace qui absorbe les attaques et les redirige vers l\'attaquant.';

  @override
  String get itemSpl015Name => 'Brise-Monde';

  @override
  String get itemSpl015Desc =>
      'L\'expression ultime de la magie du Sundering — un sort qui rouvre la blessure originelle entre les mondes l\'espace d\'un battement de cœur. La réalité hurle. Tout dans le rayon de l\'explosion est touché par la substance brute de la création et de la dé-création simultanément. Rien ne survit inchangé.';

  @override
  String get itemWpn001Effect =>
      'Résonance de l\'éclat : inflige 3 % de dégâts bonus près des zones corrompues par le Hollow.';

  @override
  String get itemWpn002Effect =>
      '+10 % de dégâts contre les créatures féeriques.';

  @override
  String get itemWpn003Effect =>
      'Rune du gardien : révèle les passages cachés dans les Hollows. +5 % de dégâts aux ennemis minéraux.';

  @override
  String get itemWpn004Effect =>
      'Frappe du Hollow : 15 % de chance que les attaques ignorent entièrement la défense de la cible.';

  @override
  String get itemWpn005Effect =>
      'Lame du Vide : les attaques infligent 10 % de dégâts bonus. Le Hollow affame à travers la lame.';

  @override
  String get itemWpn006Effect =>
      'Assassinat : les coups critiques infligent 35 % de dégâts bonus. +12 % de chance de critique depuis la furtivité.';

  @override
  String get itemWpn007Effect =>
      'Frappe liante : 20 % de chance d\'immobiliser la cible pendant 1 tour. Inflige le double de dégâts aux prisonniers évadés des profondeurs.';

  @override
  String get itemWpn008Effect =>
      'Ambition du Liche : les attaques magiques infligent 15 % de dégâts bonus. Sur élimination, restaure 5 % des PV max.';

  @override
  String get itemWpn009Effect =>
      'Inéluctabilité : ignore 15 % de la DÉF et de la résistance magique de la cible. Ne peut être désarmé.';

  @override
  String get itemWpn010Effect =>
      'Enracinement : les flèches enchevêtrent les cibles (−15 % AGI pendant 2 tours). Régénère 2 % de PV par tour en zones forestières.';

  @override
  String get itemWpn011Effect =>
      'Briseur de sceau : les attaques brisent les barrières magiques. +25 % de dégâts contre les ennemis liés ou scellés.';

  @override
  String get itemWpn012Effect =>
      'Coupure dimensionnelle : ignore 25 % de DÉF et de résistance magique. 10 % de chance de déchirer la réalité, infligeant des dégâts de zone.';

  @override
  String get itemWpn013Effect =>
      'Floraison éternelle : l\'arc régénère ses flèches entre les combats. Les critiques font éclater des racines des blessures, infligeant 40 % de dégâts bonus sur 3 tours.';

  @override
  String get itemWpn014Effect =>
      'Veine de magma : les attaques infligent 20 % de dégâts de feu bonus et infligent Brûlure. Coûte 2 % des PV max par coup, mais les dégâts de brûlure soignent le porteur.';

  @override
  String get itemWpn015Effect =>
      'Covenant : ignore TOUTES les résistances ennemies. Sur élimination, absorbe la stat la plus forte de la cible de façon permanente (+1, cumulable jusqu\'à 20).';

  @override
  String get itemArm001Effect =>
      'Fil ancestral : réduit les dégâts physiques subis de 2 %.';

  @override
  String get itemArm002Effect =>
      'Coureur des cavernes : +5 % d\'esquive en zones souterraines. Brille faiblement dans l\'obscurité.';

  @override
  String get itemArm003Effect =>
      'Mémoire de la forêt : réduit les dégâts des créatures végétales et féeriques de 10 %.';

  @override
  String get itemArm004Effect =>
      'Chance du pilleur : +8 % de taux de chute d\'or. 5 % de chance de résister aux effets de malédiction des reliques de Valdris.';

  @override
  String get itemArm005Effect =>
      'Distorsion du Vide : 8 % de chance de dévier les attaques à travers des micro-failles. Subit 5 % de dégâts supplémentaires des sources sacrées.';

  @override
  String get itemArm006Effect =>
      'Mémoire greffée : immunisé contre les effets de confusion. 10 % de chance d\'esquiver par réflexe (instinct de gardien hérité).';

  @override
  String get itemArm007Effect =>
      'Grâce courtoise : immunisé contre les effets de Peur. +10 % de résistance magique. La lumière elfique révèle les ennemis cachés.';

  @override
  String get itemArm008Effect =>
      'Gardien du Hollow : +15 % de résistance aux dégâts en position défensive. Les attaques entrantes résonnent faiblement, avertissant des embuscades.';

  @override
  String get itemArm009Effect =>
      'Protection solaire : immunisé contre les effets d\'obscurité et d\'ombre. Régénère 2 % de PV par tour en plein jour ou en zones de surface.';

  @override
  String get itemArm010Effect =>
      'Peau de pression : la DÉF augmente de 1 % pour chaque 10 % de PV perdus. Immunisé aux dégâts de feu et de magma.';

  @override
  String get itemArm011Effect =>
      'Barrière vivante : régénère 3 % des PV max par tour. Les épines infligent 8 % de dégâts de recul aux attaquants de mêlée.';

  @override
  String get itemArm012Effect =>
      'Passage de la Mort : ignore les dangers environnementaux. 15 % de chance d\'annuler les dégâts fatals et de survivre avec 1 PV.';

  @override
  String get itemArm013Effect =>
      'Écho du Severance : tous les dégâts de sorts réduits de 20 %. Une fois par combat, lance une protection absorbant des dégâts égaux à 30 % des PV max.';

  @override
  String get itemArm014Effect =>
      'Chaînes inébranlables : immunisé au recul, à l\'étourdissement et au déplacement forcé. Réduit tous les dégâts entrants de 15 %.';

  @override
  String get itemArm015Effect =>
      'Phase dimensionnelle : 20 % de chance de traverser les attaques entièrement. Immunisé à tous les effets de statut. Les stats augmentent de 1 % par tour en combat (max 15 %).';

  @override
  String get itemAcc001Effect =>
      'Protection faible : restaure 1 % de PV par tour.';

  @override
  String get itemAcc002Effect =>
      'Faveur féerique : +5 % d\'esquive contre les attaques magiques. Les feux follets ignorent le porteur.';

  @override
  String get itemAcc003Effect =>
      'Lumière profonde : révèle les ennemis et pièges cachés. +5 % d\'esquive en zones souterraines.';

  @override
  String get itemAcc004Effect =>
      'Œil du savant : révèle les faiblesses ennemies au début du combat. +10 % d\'XP des rencontres en Ruines.';

  @override
  String get itemAcc005Effect =>
      'Regard du Vide : dégâts de sorts +10 %. 5 % de chance que les attaques effacent un buff ennemi.';

  @override
  String get itemAcc006Effect =>
      'Pacte du druide : les effets de soin augmentés de 15 %. Les créatures féeriques n\'attaquent pas en premier.';

  @override
  String get itemAcc007Effect =>
      'Instinct hérité : agit toujours en premier au tour d\'ouverture du combat. +15 % d\'esquive contre les pièges.';

  @override
  String get itemAcc008Effect =>
      'Résonance : dégâts de sorts +15 %. Accorde une brève précognition — voit les attaques ennemies avant qu\'elles ne frappent.';

  @override
  String get itemAcc009Effect =>
      'Marqué par la Mort : +10 % à tous les dégâts. Immunisé aux effets de mort instantanée et de charme.';

  @override
  String get itemAcc010Effect =>
      'Lumière éternelle : régénère 3 % de PV par tour. +20 % de résistance aux effets d\'obscurité et de corruption.';

  @override
  String get itemAcc011Effect =>
      'Réflexe du gardien : +18 % d\'esquive. Contre-attaque automatiquement une fois par tour en esquivant.';

  @override
  String get itemAcc012Effect =>
      'Protection silencieuse : immunisé à toutes les attaques sonores et affectant l\'esprit. Une fois par combat, annule un coup fatal et soigne 25 % des PV.';

  @override
  String get itemAcc013Effect =>
      'Chagrin divin : tous les dégâts +15 %. Les sorts de soin coûtent 40 % de moins. Immunisé aux dégâts de type divin.';

  @override
  String get itemAcc014Effect =>
      'Couronne du creux-racine : toutes les stats +8 %. En dessous de 25 % de PV, régénère 5 % des PV max par tour et gagne +20 % à tous les dégâts.';

  @override
  String get itemAcc015Effect =>
      'Omniscience : toutes les stats ennemies visibles. Les sorts ignorent la résistance magique. +20 % de chance de critique. La Mère des Profondeurs observe à travers vous.';

  @override
  String get itemRel001Effect =>
      'Faible résonance : 5 % de chance de gagner une action supplémentaire par tour.';

  @override
  String get itemRel002Effect =>
      'Lueur profonde : révèle les positions ennemies dans l\'obscurité. +5 % de dégâts magiques en zones souterraines.';

  @override
  String get itemRel003Effect =>
      'Chronique du savant : +10 % d\'XP de toutes les rencontres. Révèle le savoir caché dans les zones de Ruines.';

  @override
  String get itemRel004Effect =>
      'Lumière de feu follet : révèle les chemins et trésors cachés. +10 % d\'esquive contre les embuscades.';

  @override
  String get itemRel005Effect =>
      'Érosion du Vide : les attaques réduisent la DÉF ennemie de 3 % par coup de façon permanente (cumulable 5 fois). Le porteur subit 1 % des PV max par tour.';

  @override
  String get itemRel006Effect =>
      'Flamme spirituelle : chaque 3e attaque inflige 50 % de dégâts de feu bonus. Immunisé aux effets de brûlure.';

  @override
  String get itemRel007Effect =>
      'Écho de protection : réfléchit 15 % des dégâts magiques vers le lanceur. +10 % de résistance aux effets de malédiction.';

  @override
  String get itemRel008Effect =>
      'Lien racinaire : régénère 4 % de PV par tour. Les sorts de nature infligent 25 % de dégâts bonus. Avertit de la corruption à proximité.';

  @override
  String get itemRel009Effect =>
      'Verrou abyssal : +15 % de dégâts contre les ennemis anciens et divins. Octroie un bouclier (10 % des PV max) au début de chaque combat.';

  @override
  String get itemRel010Effect =>
      'Poids du Titan : immunisé au recul et au déplacement. +15 % de dégâts aux cibles plus grandes que le porteur.';

  @override
  String get itemRel011Effect =>
      'Voleur de mémoire : les sorts ont 10 % de chance de retirer un buff aléatoire de la cible. Les sorts sombres infligent 30 % de dégâts bonus. Coûte 1 % des PV max par sort lancé.';

  @override
  String get itemRel012Effect =>
      'Volonté verdoyante : régénère 5 % des PV max par tour. Les effets de nature et de soin sont doublés. Immunisé à la corruption et à la décomposition.';

  @override
  String get itemRel013Effect =>
      'Fureur terrestre : une fois par combat, invoque un tremblement infligeant des dégâts de zone égaux à 300 % de MAG. Les ennemis touchés perdent 20 % de DÉF pendant 3 tours. Immunisé aux dégâts de terre et de magma.';

  @override
  String get itemRel014Effect =>
      'Severance : les attaques réduisent les stats ennemies de 5 % de façon permanente (cumulable). Les sorts ignorent les boucliers. Une fois par combat, bannit une capacité ennemie.';

  @override
  String get itemRel015Effect =>
      'Blessure du monde : tous les dégâts +20 %. Une fois par combat, ouvre une faille qui efface une capacité ennemie de façon permanente. Immunisé à tous les débuffs. Les ennemis proches perdent 3 % de stats par tour.';

  @override
  String get itemSpl001Effect =>
      'Lance un éclat du Sundering infligeant des dégâts basés sur la MAG.';

  @override
  String get itemSpl002Effect =>
      'Fouette une cible avec une liane épineuse, infligeant des dégâts de MAG et la ralentissant pendant 2 tours.';

  @override
  String get itemSpl003Effect =>
      'Octroie un bouclier de pierre absorbant des dégâts égaux à 50 % de la MAG pendant 3 tours.';

  @override
  String get itemSpl004Effect =>
      'Tire 3 projectiles arcaniques à tête chercheuse, chacun infligeant des dégâts basés sur la MAG.';

  @override
  String get itemSpl005Effect =>
      'Draine les PV ennemis à hauteur de 80 % de la MAG et soigne le lanceur pour la moitié du montant.';

  @override
  String get itemSpl006Effect =>
      'Soigne le lanceur pour 120 % de la MAG et retire un effet de statut négatif.';

  @override
  String get itemSpl007Effect =>
      'Fait érupter du magma infligeant de lourds dégâts de MAG et réduisant la DÉF ennemie de 15 % pendant 3 tours.';

  @override
  String get itemSpl008Effect =>
      'Vole l\'ATQ/MAG ennemie de 10 % pendant 3 tours et augmente la prochaine attaque du lanceur de 30 %.';

  @override
  String get itemSpl009Effect =>
      'Dégâts sacrés infligeant 150 % de MAG. Inflige le double de dégâts aux ennemis corrompus par le Hollow.';

  @override
  String get itemSpl010Effect =>
      'Crée des illusions accordant 50 % d\'esquive pendant 3 tours. La prochaine attaque depuis la furtivité inflige +40 % de dégâts.';

  @override
  String get itemSpl011Effect =>
      'Piège un ennemi pendant 2 tours, infligeant 100 % de MAG chaque tour. Les ennemis piégés ne peuvent pas agir.';

  @override
  String get itemSpl012Effect =>
      'Dégâts soniques de zone infligeant 120 % de MAG. Dissipe tous les buffs ennemis et réduit au silence pendant 2 tours.';

  @override
  String get itemSpl013Effect =>
      'Chance de tuer instantanément les ennemis en dessous de 25 % de PV. Sinon inflige 200 % de dégâts de MAG.';

  @override
  String get itemSpl014Effect =>
      'Ouvre une faille dimensionnelle absorbant tous les dégâts pendant 2 tours, puis détone pour 250 % des dégâts absorbés.';

  @override
  String get itemSpl015Effect =>
      'Dégâts cataclysmiques infligeant 400 % de MAG à tous les ennemis. Réduit toutes les stats ennemies de 20 % de façon permanente. Une fois par combat.';
}
