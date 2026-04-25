// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'QUESTBORNE';

  @override
  String get appTagline => 'НА БАЗЕ ИИ СЮЖЕТНОГО ДВИЖКА';

  @override
  String get buttonOk => 'ОК';

  @override
  String get buttonCancel => 'Отмена';

  @override
  String get buttonSave => 'Сохранить';

  @override
  String get buttonClose => 'Закрыть';

  @override
  String get startEnter => 'ВОЙТИ';

  @override
  String get startPremium => 'Премиум';

  @override
  String get startSettings => 'НАСТРОЙКИ';

  @override
  String get startVersion => 'Версия 0.0.1 • Протокол Тени';

  @override
  String continueWithProvider(String provider) {
    return 'Продолжить с $provider';
  }

  @override
  String get loginTitle => 'ВОЙДИ В\nМИР';

  @override
  String get loginSubtitle => 'Выберите, как хотите продолжить';

  @override
  String get loginGoogle => 'Продолжить с Google';

  @override
  String get loginApple => 'Продолжить с Apple';

  @override
  String get errorSomethingWentWrong => 'Что-то пошло не так';

  @override
  String get labelObjective => 'Задание';

  @override
  String get labelLocation => 'Локация';

  @override
  String get labelReward => 'Награда';

  @override
  String get labelKeyFigures => 'Ключевые персонажи';

  @override
  String get guildTitle => 'Доска Объявлений';

  @override
  String get guildSubtitle => 'Прогресс Квестов';

  @override
  String get guildObjective => 'ЗАДАНИЕ';

  @override
  String get guildKeyFigures => 'КЛЮЧЕВЫЕ ПЕРСОНАЖИ';

  @override
  String get guildReward => 'НАГРАДА';

  @override
  String get guildResume => 'Продолжить';

  @override
  String get guildAcceptQuest => 'Принять Квест';

  @override
  String get guildDone => 'Готово';

  @override
  String get guildCompleted => 'ЗАВЕРШЕНО';

  @override
  String get guildSideBounties => 'ПОБОЧНЫЕ ЗАДАНИЯ';

  @override
  String get guildMainQuests => 'Основные Квесты';

  @override
  String get guildRepeatableQuests => 'Повторяемые Квесты';

  @override
  String guildLevelAbbr(int level) {
    return 'УР $level';
  }

  @override
  String guildGoldDisplay(int amount) {
    return '$amount Золота';
  }

  @override
  String get inventoryTitle => 'ИНВЕНТАРЬ';

  @override
  String get inventoryUnequipped => 'НЕ ЭКИПИРОВАНО';

  @override
  String get shopTitle => 'РЫНОК';

  @override
  String get shopBuy => 'Купить';

  @override
  String get shopSold => 'Продано';

  @override
  String get shopSoldLabel => 'ПРОДАНО';

  @override
  String get shopNotEnoughGold => 'Недостаточно золота';

  @override
  String shopPurchased(String item) {
    return '$item куплен(а)!';
  }

  @override
  String get shopClose => 'Закрыть';

  @override
  String get shopMerchantQuote =>
      '\"Выбирайте мудро, путник. Мои товары стоят больше, чем просто золото...\"';

  @override
  String shopGold(int amount) {
    return '$amount Золота';
  }

  @override
  String get shopMerchantWares => 'Товары Торговца';

  @override
  String get settingsTitle => 'НАСТРОЙКИ';

  @override
  String get settingsProfile => 'ПРОФИЛЬ';

  @override
  String get settingsCharacterName => 'Имя Персонажа';

  @override
  String get settingsEmail => 'Эл. почта';

  @override
  String get settingsAiSafety => 'БЕЗОПАСНОСТЬ ИИ';

  @override
  String get settingsHateSpeech => 'Язык ненависти';

  @override
  String get settingsHarassment => 'Притеснение';

  @override
  String get settingsDangerousContent => 'Опасный контент';

  @override
  String get settingsGeneral => 'ОБЩИЕ';

  @override
  String get settingsPremium => 'Премиум';

  @override
  String get settingsPremiumSubtitle => 'Просмотр вариантов подписки';

  @override
  String get settingsRestoreSubscription => 'Восстановить Подписку';

  @override
  String get settingsRestoreSubtitle => 'Уже подписаны? Восстановите здесь';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageSubtitle => 'Изменить язык приложения';

  @override
  String get settingsLanguageSystem => 'Системный язык';

  @override
  String get settingsAccount => 'АККАУНТ';

  @override
  String get settingsDeleteAccount => 'Удалить Аккаунт';

  @override
  String get settingsDeleteSubtitle =>
      'Безвозвратно удалить аккаунт и все данные';

  @override
  String get settingsLegal => 'ЮРИДИЧЕСКОЕ';

  @override
  String get settingsPrivacyPolicy => 'Политика Конфиденциальности';

  @override
  String get settingsPrivacySubtitle => 'Как мы обрабатываем ваши данные';

  @override
  String get settingsTermsOfService => 'Условия Использования';

  @override
  String get settingsTermsSubtitle => 'Правила и условия использования';

  @override
  String get settingsChangeName => 'ИЗМЕНИТЬ ИМЯ';

  @override
  String get settingsChangeNameDesc =>
      'Выберите новое имя для вашего персонажа';

  @override
  String get settingsEnterNewName => 'Введите новое имя';

  @override
  String get settingsNameReserved =>
      '«Adventurer» зарезервировано — выберите что-то уникальное!';

  @override
  String settingsNameChanged(String name) {
    return 'Имя изменено на $name';
  }

  @override
  String get settingsChooseFilterLevel => 'Выберите уровень фильтрации';

  @override
  String get settingsCheckingSubscription =>
      'Проверка существующей подписки...';

  @override
  String settingsSubscriptionRestored(String tier) {
    return 'Подписка восстановлена! ($tier)';
  }

  @override
  String get settingsNoSubscription => 'Активная подписка не найдена.';

  @override
  String get settingsRestoreFailed =>
      'Не удалось восстановить подписку. Попробуйте позже.';

  @override
  String get settingsDeleteTitle => 'Удалить Аккаунт';

  @override
  String get settingsDeleteMessage =>
      'Это безвозвратно удалит ваш аккаунт и все сохранённые данные. Любая активная подписка также будет отменена. Это действие необратимо.';

  @override
  String get settingsDeleteConfirm => 'Удалить';

  @override
  String get settingsDeleteFailed => 'Что-то пошло не так. Попробуйте позже.';

  @override
  String get safetyLevelLow => 'Низкий';

  @override
  String get safetyLevelMedium => 'Средний';

  @override
  String get safetyLevelHigh => 'Высокий';

  @override
  String get safetyDescLow => 'Разрешительный — подходит для тёмного фэнтези';

  @override
  String get safetyDescMedium => 'Сбалансированная фильтрация';

  @override
  String get safetyDescHigh => 'Строгая фильтрация контента';

  @override
  String get subscriptionPlans => 'ТАРИФЫ';

  @override
  String get subscriptionCredits => 'кредиты';

  @override
  String subscriptionCreditsDaily(int daily) {
    return 'кредиты (+$daily ежедневно)';
  }

  @override
  String subscriptionCreditsRemaining(int max) {
    return 'кредитов осталось из $max';
  }

  @override
  String get subscriptionCurrent => 'Текущий';

  @override
  String subscriptionUpgradedTo(String tier) {
    return 'Улучшено до $tier!';
  }

  @override
  String get subscriptionManageGooglePlay =>
      'Управление подписками в Google Play';

  @override
  String subscriptionMemory(String tag) {
    return 'Память: $tag';
  }

  @override
  String subscriptionResets(String date) {
    return 'Сброс $date';
  }

  @override
  String subscriptionCreditsCount(int count) {
    return '$count кредитов';
  }

  @override
  String subscriptionCreditsDailyFeature(int max, int daily) {
    return '$max + $daily/день кредитов';
  }

  @override
  String get expeditionTitle => 'Экспедиция';

  @override
  String get expeditionOpenWorlds => 'Открытые Миры';

  @override
  String get expeditionEnter => 'Начать Экспедицию';

  @override
  String get expeditionEnterShort => 'Войти';

  @override
  String get expeditionFreeRoam => 'Свободное Исследование';

  @override
  String get expeditionFreeRoamDesc =>
      'Без заданной цели — исследуйте свободно и посмотрите, что вас ждёт.';

  @override
  String get mapDarkwoodForest => 'Тёмный Лес';

  @override
  String get mapDarkwoodForestDesc =>
      'Древний лес, окутанный вечными сумерками. Искривлённые дубы и узловатые корни скрывают забытые тропы, странных существ и шёпот древней магии между покрытыми мхом камнями.';

  @override
  String get mapSunkenCaverns => 'Затонувшие Пещеры';

  @override
  String get mapSunkenCavernsDesc =>
      'Обширная подземная сеть капающих туннелей и светящихся кристаллических пещер. Воздух пропитан запахом сырой земли, а неведомые существа шуршат за пределами света факела.';

  @override
  String get mapAshenRuins => 'Пепельные Руины';

  @override
  String get mapAshenRuinsDesc =>
      'Рушащиеся останки некогда великой цивилизации, наполовину поглощённые песком и ползучими лианами. Обрушившиеся арки ведут к забытым хранилищам, и призраки старого мира таятся в каждой тени.';

  @override
  String get navWorld => 'Мир';

  @override
  String get navQuest => 'Квест';

  @override
  String get navMarket => 'Рынок';

  @override
  String get navHero => 'Герой';

  @override
  String get navSheet => 'Лист';

  @override
  String get nameDialogAppTitle => 'Questborne';

  @override
  String get nameDialogTitle => 'КТО ТЫ?';

  @override
  String get nameDialogSubtitle => 'Назови своё имя, и пусть всё начнётся.';

  @override
  String get nameDialogHint => 'Назови своё имя...';

  @override
  String get nameDialogErrorEmpty => 'У Questborne должно быть имя.';

  @override
  String get nameDialogErrorShort =>
      'Слишком коротко. Даже у странника есть две буквы.';

  @override
  String get nameDialogErrorLong => 'Не более 20 символов.';

  @override
  String get nameDialogErrorReserved => 'Это имя нельзя использовать';

  @override
  String get lootObtained => 'ПОЛУЧЕНО';

  @override
  String lootGoldGained(int amount) {
    return '+$amount Золота';
  }

  @override
  String lootXpGained(int amount) {
    return '+$amount Опыта';
  }

  @override
  String lootHpRestored(int amount) {
    return '+$amount ОЗ Восстановлено';
  }

  @override
  String lootManaRestored(int amount) {
    return '+$amount Маны Восстановлено';
  }

  @override
  String lootGoldLost(int amount) {
    return '-$amount Золота';
  }

  @override
  String lootDamage(int amount) {
    return '-$amount ОЗ';
  }

  @override
  String get lootLevelUp => 'Новый уровень!';

  @override
  String lootLevelUpMultiple(int levels) {
    return 'Новый уровень! (+$levels уровней)';
  }

  @override
  String diceCheck(String action) {
    return '$action ПРОВЕРКА';
  }

  @override
  String get questCompleteTitle => 'КВЕСТ ВЫПОЛНЕН';

  @override
  String get questCompleteSubtitle => 'Ваша история написана.';

  @override
  String get questCompleteRewards => 'НАГРАДЫ';

  @override
  String get questCompleteReturn => 'ВЕРНУТЬСЯ В ГИЛЬДИЮ';

  @override
  String questCompleteGold(int amount) {
    return '$amount Золота';
  }

  @override
  String questCompleteXp(int amount) {
    return '$amount Опыта';
  }

  @override
  String get questFailedTitle => 'КВЕСТ ПРОВАЛЕН';

  @override
  String get questFailedSubtitle => 'Тьма забирает ещё одну душу.';

  @override
  String get questFailedReset => 'Прогресс серии квестов сброшен.';

  @override
  String get questFailedReturn => 'ВЕРНУТЬСЯ В ГИЛЬДИЮ';

  @override
  String spellManaCost(int cost) {
    return '$cost МП';
  }

  @override
  String get itemTypeWeapon => 'ОРУЖИЕ';

  @override
  String get itemTypeArmor => 'БРОНЯ';

  @override
  String get itemTypeAccessory => 'АКСЕССУАР';

  @override
  String get itemTypeRelic => 'РЕЛИКВИЯ';

  @override
  String get itemTypeSpell => 'ЗАКЛИНАНИЕ';

  @override
  String get rarityCommon => 'ОБЫЧНЫЙ';

  @override
  String get rarityRare => 'РЕДКИЙ';

  @override
  String get rarityEpic => 'ЭПИЧЕСКИЙ';

  @override
  String get rarityMythic => 'МИФИЧЕСКИЙ';

  @override
  String get actionMeleeAttack => 'Ближний Бой';

  @override
  String get actionRangedAttack => 'Дальняя Атака';

  @override
  String get actionOffensiveMagic => 'Атакующая Магия';

  @override
  String get actionDefensiveMagic => 'Защитная Магия';

  @override
  String get actionStealth => 'Скрытность';

  @override
  String get actionAssassination => 'Убийство';

  @override
  String get actionDodge => 'Уклонение';

  @override
  String get actionParry => 'Парирование';

  @override
  String get actionPersuasion => 'Убеждение';

  @override
  String get actionThrow => 'Бросок';

  @override
  String get actionDexterity => 'Ловкость';

  @override
  String get actionEndurance => 'Выносливость';

  @override
  String get actionFlee => 'Побег';

  @override
  String get outcomeCriticalFailure => 'Критический Провал';

  @override
  String get outcomeFailure => 'Провал';

  @override
  String get outcomePartialSuccess => 'Частичный Успех';

  @override
  String get outcomeSuccess => 'Успех';

  @override
  String get outcomeCriticalSuccess => 'Критический Успех';

  @override
  String get difficultyRoutine => 'Обычное Задание';

  @override
  String get difficultyDangerous => 'Опасно';

  @override
  String get difficultyPerilous => 'Смертельно опасно';

  @override
  String get difficultySuicidal => 'Самоубийственно';

  @override
  String get statusPoisoned => 'ОТРАВЛЕН';

  @override
  String get statusBurning => 'ГОРИТ';

  @override
  String get statusFrozen => 'ЗАМОРОЖЕН';

  @override
  String get statusBlessed => 'БЛАГОСЛОВЛЁН';

  @override
  String get statusShielded => 'ПОД ЩИТОМ';

  @override
  String get statusWeakened => 'ОСЛАБЛЕН';

  @override
  String get tierWanderer => 'Странник';

  @override
  String get tierAdventurer => 'Искатель Приключений';

  @override
  String get tierChampion => 'Чемпион';

  @override
  String get tierTaglineFree => 'Начните своё путешествие';

  @override
  String get tierTaglineAdventurer => 'Более глубокие истории ждут';

  @override
  String get tierTaglineChampion => 'Абсолютный опыт';

  @override
  String get statAtk => 'АТК';

  @override
  String get statDef => 'ЗАЩ';

  @override
  String get statMag => 'МАГ';

  @override
  String get statAgi => 'ЛОВ';

  @override
  String get statHp => 'ОЗ';

  @override
  String get statMp => 'МП';

  @override
  String get labelGold => 'Золото';

  @override
  String get labelXp => 'Опыт';

  @override
  String labelLevel(int level) {
    return 'Ур $level';
  }

  @override
  String statSummaryFormat(String label, String value) {
    return '$label $value';
  }

  @override
  String priceFormat(int price) {
    return '$price Золота';
  }

  @override
  String rewardFormat(int gold, int xp) {
    return '$gold Золота  ·  $xp Опыта';
  }

  @override
  String get errorSignInRequired => 'Для игры необходимо войти в аккаунт.';

  @override
  String get errorSessionExpired =>
      'Ваша сессия истекла. Пожалуйста, войдите снова.';

  @override
  String get errorSignInToPlay =>
      'Войдите через Google или Apple для прохождения квестов.';

  @override
  String get errorTooManyRequests =>
      'Слишком много запросов — пожалуйста, подождите немного и попробуйте снова.';

  @override
  String get errorServiceUnavailable =>
      'Сервис ИИ временно недоступен. Пожалуйста, попробуйте через минуту. Ваш кредит был возвращён.';

  @override
  String get errorServerError =>
      'Что-то пошло не так на нашей стороне. Пожалуйста, попробуйте снова.';

  @override
  String get errorGeneric =>
      'Что-то пошло не так. Пожалуйста, попробуйте снова.';

  @override
  String get errorNetworkError =>
      'Что-то пошло не так. Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get locationForest => 'Лес';

  @override
  String get locationCave => 'Пещера';

  @override
  String get locationRuins => 'Руины';

  @override
  String freeRoamTitle(String mapTitle) {
    return '$mapTitle — Свободное Исследование';
  }

  @override
  String get freeRoamObjective =>
      'Исследуйте свободно и посмотрите, что мир припас для вас.';

  @override
  String get equip => 'Экипировать';

  @override
  String get unequip => 'Снять';

  @override
  String get nameDialogContinue => 'ПРОДОЛЖИТЬ';

  @override
  String get cardAcceptQuest => 'ПРИНЯТЬ КВЕСТ';

  @override
  String get cardInvestigate => 'Исследовать';

  @override
  String get cardEnter => 'Войти';

  @override
  String get cardRewardLabel => 'НАГРАДА';

  @override
  String get cardDifficultyPrefix => 'Сложность: ';

  @override
  String levelPrefix(int level) {
    return 'ур $level';
  }

  @override
  String get questRepF01Title => 'Патруль гоблинов';

  @override
  String get questRepF01Desc =>
      'Разведчики гоблинов вновь замечены на опушке леса. Ополчение объявило постоянную награду — уничтожьте их, пока они не разграбили ещё одну ферму.';

  @override
  String get questRepF01Obj =>
      'Выследите разведчиков гоблинов на лесных окраинах.';

  @override
  String get questRepC01Title => 'Туннельные паразиты';

  @override
  String get questRepC01Desc =>
      'Крысы и пещерные пауки заполонили верхние Hollows. Шахтёры хорошо платят тем, кто готов их зачистить — твари плодятся быстрее, чем туннели успевают запечатывать.';

  @override
  String get questRepC01Obj =>
      'Зачистите паразитов в шахтёрских туннелях верхних Hollows.';

  @override
  String get questRepR01Title => 'Неупокоенные кости';

  @override
  String get questRepR01Desc =>
      'Внешние курганы Valdris никогда не бывают тихими. Скелеты выбираются из могил каждые несколько дней. Историк Korval платит награду за то, чтобы вход в лагерь оставался свободным.';

  @override
  String get questRepR01Obj =>
      'Упокойте неупокоенную нежить во внешних курганах Valdris.';

  @override
  String get questRepF02Title => 'Награда за бандитов';

  @override
  String get questRepF02Desc =>
      'Разведчики бандитов патрулируют торговые дороги у Thornveil. Купцы отказываются путешествовать без вооружённого сопровождения. Это объявление на доске наград не снимают никогда.';

  @override
  String get questRepF02Obj =>
      'Выследите разведчиков бандитов на торговых дорогах Thornveil.';

  @override
  String get questRepC02Title => 'Сопровождение к рудной жиле';

  @override
  String get questRepC02Desc =>
      'В средних Hollows обнаружена новая рудная жила, но в туннелях рыщут пещерные существа. Бригадир Brick нуждается в том, кто сопроводит шахтёров к жиле и обратно.';

  @override
  String get questRepC02Obj =>
      'Безопасно сопроводите шахтёров через опасные туннели Hollows.';

  @override
  String get questRepR02Title => 'Спасение артефактов';

  @override
  String get questRepR02Desc =>
      'Учёной Veyra нужны проклятые артефакты, извлечённые из верхних руин, прежде чем мародёры продадут их коллекционерам, понятия не имеющим, с чем они имеют дело.';

  @override
  String get questRepR02Obj =>
      'Извлеките проклятые артефакты из верхних руин Valdris.';

  @override
  String get questRepF03Title => 'Очищение скверны';

  @override
  String get questRepF03Desc =>
      'Осквернённый Hollows подлесок расползается по средней части леса. Круг друида Theron выжигает его еженедельно, но им нужен кто-то, кто зачистит существ, гнездящихся в осквернённых рощах.';

  @override
  String get questRepF03Obj =>
      'Зачистите осквернённых Hollows существ в рощах средней части леса.';

  @override
  String get questRepC03Title => 'Грибной сбор';

  @override
  String get questRepC03Desc =>
      'Споровые цветения Deep Mother продолжают извергаться в средних Hollows. Травнице Nessa нужен кто-то, кто уничтожит цветения, прежде чем они сведут шахтёров с ума, — и принесёт образцы для изучения.';

  @override
  String get questRepC03Obj =>
      'Уничтожьте опасные грибные цветения в средних Hollows.';

  @override
  String get questRepR03Title => 'Патруль Tithebound';

  @override
  String get questRepR03Desc =>
      'Стражи Tithebound бродят по руинам средней глубины бесконечными петлями. Когда они забредают слишком близко к наземному лагерю, кто-то должен отогнать их обратно. Награда объявлена постоянно.';

  @override
  String get questRepR03Obj => 'Оттесните патрули Tithebound от верхних руин.';

  @override
  String get questRepF04Title => 'Стычка с Pale Root';

  @override
  String get questRepF04Desc =>
      'Налётчики Pale Root устраивают засады на патрули у Thornwall. Эльфы отрекаются от них, но нападения продолжаются. Награда высока — это не обычные бандиты.';

  @override
  String get questRepF04Obj =>
      'Вступите в бой с налётчиками Pale Root у границы Thornwall.';

  @override
  String get questRepC04Title => 'Патруль глубинных жил';

  @override
  String get questRepC04Desc =>
      'Существа, освобождённые разрушающимися охранными камнями, выползают из глубинных Hollows. Ossborn игнорируют всё, что не угрожает их печатям. Бригадиру Brick нужны наземные жители, чтобы держать средние туннели проходимыми.';

  @override
  String get questRepC04Obj =>
      'Патрулируйте глубинные Hollows и зачистите вырвавшихся существ.';

  @override
  String get questRepR04Title => 'Подавление резонанса';

  @override
  String get questRepR04Desc =>
      'Гул в глубинных руинах порождает узлы резонанса — кристаллы, сводящие людей с ума. Учёная Veyra хорошо платит за их уничтожение, пока звук не достиг поверхности.';

  @override
  String get questRepR04Obj =>
      'Уничтожьте узлы резонанса в глубинных руинах Valdris.';

  @override
  String get questRepF05Title => 'Поручение Verdant Court';

  @override
  String get questRepF05Desc =>
      'Verdant Court поручил смертным воителям очистить от скверны священные рощи, до которых эльфы не могут добраться, не пересекая Thornwall. Плата — эльфийское серебро, ценнее людского золота.';

  @override
  String get questRepF05Obj =>
      'Очистите священную рощу от скверны по поручению Verdant Court.';

  @override
  String get questRepC05Title => 'Починка оков';

  @override
  String get questRepC05Desc =>
      'Охранные камни в глубинных Hollows продолжают трескаться. Forge Spirit не в силах следить за всеми. Кто-то должен доставить запасные камни печатей к разрушающимся пьедесталам, пока то, что за ними, не вырвется на свободу.';

  @override
  String get questRepC05Obj =>
      'Доставьте камни печатей к разрушающимся охранным пьедесталам в глубинных Hollows.';

  @override
  String get questRepR05Title => 'Пространственная печать';

  @override
  String get questRepR05Desc =>
      'У раны Severance продолжают открываться малые разрывы — реальность истончается по краям. Осознанные старейшины Tithebound отмечают их. Кто-то должен закрыть их, пока Nameless Choir не просочился наружу.';

  @override
  String get questRepR05Obj =>
      'Запечатайте малые пространственные разрывы у раны Severance.';

  @override
  String get questF001Title => 'Лагерь гоблинов на торговом тракте';

  @override
  String get questF001Desc =>
      'Разведывательный отряд гоблинов разбил лагерь там, где торговый тракт входит в Thornveil. Лесорубы и купцы отказываются проходить мимо.';

  @override
  String get questF001Obj =>
      'Найдите и уничтожьте лагерь гоблинов, перекрывший лесной торговый тракт.';

  @override
  String get questF002Title => 'Лютоволки Thornveil';

  @override
  String get questF002Desc =>
      'Стая лютоволков захватила главную дорогу через внешний Thornveil. Путников утаскивают в подлесок.';

  @override
  String get questF002Obj =>
      'Выследите или прогоните стаю лютоволков, терроризирующую дорогу через Thornveil.';

  @override
  String get questF003Title => 'Отравленный ручей';

  @override
  String get questF003Desc =>
      'Мерзкая зелёная жижа сочится откуда-то выше по течению в Thornveil. Животные, пьющие из ручья, падают замертво. Травница Nessa опасается, что отрава может достичь деревенского водоснабжения.';

  @override
  String get questF003Obj =>
      'Пройдите вдоль ручья через Thornveil и уничтожьте то, что его отравляет.';

  @override
  String get questF004Title => 'Пропавший лесоруб';

  @override
  String get questF004Desc =>
      'Старый Henrik ушёл валить лес на краю Thornveil три дня назад. Его топор нашли вонзённым в дерево, покрытым следами когтей.';

  @override
  String get questF004Obj =>
      'Выследите пропавшего лесоруба в глубине внешнего Thornveil и узнайте его судьбу.';

  @override
  String get questF005Title => 'Засада бандитов';

  @override
  String get questF005Desc =>
      'Бандиты грабят купцов на лесной дороге за Thornwall. Они исчезают в кронах деревьев прежде, чем прибывает ополчение.';

  @override
  String get questF005Obj =>
      'Устройте ловушку для лесных бандитов и устраните их главаря.';

  @override
  String get questF006Title => 'Проклятие Чёрной Лозы';

  @override
  String get questF006Desc =>
      'Терновая моровая лоза ползёт по лесному подножию у границы Thornwall. По ночам она движется сама, удушая деревья. Друиды Circle of Thorn говорят, что никогда не видели ничего подобного.';

  @override
  String get questF006Obj =>
      'Найдите сердце Чёрной Лозы в глубине Thornveil и выжгите его.';

  @override
  String get questF007Title => 'Засада фей';

  @override
  String get questF007Desc =>
      'Спрайты на краю Thornveil без предупреждения стали враждебными. Путники сообщают о чарах и ограблениях — а хуже того, их уводят с тропы, и больше никто их не видит. Древние договоры с феями, возможно, рушатся.';

  @override
  String get questF007Obj =>
      'Выясните, почему феи стали враждебными, и найдите способ остановить нападения.';

  @override
  String get questF008Title => 'Перебежчица из Vaelithi';

  @override
  String get questF008Desc =>
      'На границе Thornwall обнаружена эльфийка без сознания, покрытая ранами, похожими на самоповреждения — словно она прорвалась сквозь барьер изнутри. Она бормочет о «Pale Root» и умоляет не отправлять её обратно.';

  @override
  String get questF008Obj =>
      'Защитите эльфийскую перебежчицу от тех, кто её преследует, и узнайте, что ей известно.';

  @override
  String get questF009Title => 'Зверь из чащи';

  @override
  String get questF009Desc =>
      'Скот на краю Thornveil разрывает нечто огромное. Следы когтей шириной с мужскую руку. Фермер Gregor говорит, что друиды не помогут — они утверждают, что зверь — это «ответ леса».';

  @override
  String get questF009Obj =>
      'Выследите и убейте зверя, таящегося в глубочайшей чаще внешнего Thornveil.';

  @override
  String get questF010Title => 'Паучьи гнёзда в кронах';

  @override
  String get questF010Desc =>
      'Гигантская паутина оплетает кроны на мили вдоль торгового тракта. Закутанные в коконы путники свисают с ветвей, некоторые ещё живы. Рейнджер Elara говорит, что пауки появились после ослабления договоров с феями.';

  @override
  String get questF010Obj =>
      'Сожгите паучьи гнёзда в лесных кронах и спасите выживших.';

  @override
  String get questF011Title => 'Зелёный ужас';

  @override
  String get questF011Desc =>
      'Чудовищное растительное существо пустило корни у границы Thornwall. Друид Theron полагает, что оно выросло из осквернённой Hollows почвы — той самой заразы, которую Vaelithi отказываются признавать.';

  @override
  String get questF011Obj =>
      'Прорубитесь сквозь заросли и уничтожьте чудовищное растительное существо, угрожающее границе Thornwall.';

  @override
  String get questF012Title => 'Терновый венец';

  @override
  String get questF012Desc =>
      'Осквернённый древень захватил глубочайшую рощу за Thornwall. Друиды Circle of Thorn говорят, что в его ствол вбит тёмный кристалл — та же скверна, что расползается из Hollows.';

  @override
  String get questF012Obj =>
      'Проникните в древнюю рощу и уничтожьте скверну внутри древня.';

  @override
  String get questF013Title => 'Алтарь культа Костра';

  @override
  String get questF013Desc =>
      'Фанатичный культ огня возводит алтари-костры среди деревьев внешнего Thornveil. Шпионка Maren говорит, что они поклоняются чему-то в Hollows и планируют выжечь путь сквозь Thornwall, чтобы добраться до Vaelith.';

  @override
  String get questF013Obj =>
      'Проникните в лесной лагерь культа огня и устраните их лидера.';

  @override
  String get questF014Title => 'Охотничьи угодья дракона';

  @override
  String get questF014Desc =>
      'Молодой дракон объявил смертный лес своей охотничьей территорией. Обугленные поляны отмечают его жертв. Vaelithi запечатали Thornwall ещё плотнее — помогать они не намерены.';

  @override
  String get questF014Obj =>
      'Выследите дракона до его лесного логова и положите конец его владычеству.';

  @override
  String get questF015Title => 'Военный лагерь орков';

  @override
  String get questF015Desc =>
      'Орочья военная дружина построила укреплённый лагерь в смертном лесу. Они совершают набеги на окрестные деревни каждую ночь. Командир Hale располагает поддержкой ополчения, но недостаточной для штурма лагеря в одиночку.';

  @override
  String get questF015Obj =>
      'Штурмуйте военный лагерь орков в лесу и сломите их осаду деревень.';

  @override
  String get questF016Title => 'Пролом в Thornwall';

  @override
  String get questF016Desc =>
      'Нечто проделало дыру в Thornwall — живом барьере, отделяющем Vaelith от смертного мира. Фейские существа и кое-что похуже хлынули в пролом. Эльфы не ответили. Друиды перегружены.';

  @override
  String get questF016Obj =>
      'Доберитесь до пролома в Thornwall и запечатайте его, пока брешь не расширилась.';

  @override
  String get questF017Title => 'Вторжение Pale Root';

  @override
  String get questF017Desc =>
      'Агенты Pale Root — эльфы из мятежной фракции Vaelith — пересекли Thornwall и саботируют святилища Circle of Thorn. Друид Theron полагает, что они хотят обрушить барьер, чтобы Vaelith расширился силой.';

  @override
  String get questF017Obj =>
      'Выследите и остановите агентов Pale Root, пока они не уничтожили последнее друидическое святилище.';

  @override
  String get questF018Title => 'Тени в кронах';

  @override
  String get questF018Desc =>
      'Вечные сумерки пали на обширную часть Thornveil. Теневые существа бродят в затемнённых кронах. Жрица Солнца Amara говорит, что Солнечный Камень — древняя реликвия, привязывающая дневной свет к лесу — был похищен.';

  @override
  String get questF018Obj =>
      'Найдите Солнечный Камень и верните дневной свет в потемневший лес.';

  @override
  String get questF019Title => 'Зараза под Vaelith';

  @override
  String get questF019Desc =>
      'Изгнанник из Vaelithi пересёк Thornwall с отчаянной вестью: зараза в корневых пустотах под Vaelith распространяется быстрее, чем эльфы могут её сдерживать. Verdant Court отказывается просить смертных о помощи — но этот изгнанник просит сам.';

  @override
  String get questF019Obj =>
      'Пройдите через брешь в Thornwall и спуститесь в корневые пустоты, чтобы найти источник заразы.';

  @override
  String get questF020Title => 'Богоед';

  @override
  String get questF020Desc =>
      'Святилища по всему Thornveil замолчали. Существо, питающееся божественной сущностью, рыщет среди деревьев — друиды называют его Богоедом, чем-то, что не должно существовать за пределами Hollow.';

  @override
  String get questF020Obj =>
      'Выследите Богоеда через священные рощи, пока он не пожрал последнее святилище.';

  @override
  String get questF021Title => 'Мировое Древо горит';

  @override
  String get questF021Desc =>
      'Демоническое пламя охватило Мировое Древо. Vaelithi впервые за три столетия открыли Thornwall — не чтобы помочь, а чтобы эвакуироваться. Если Мировое Древо падёт, лес и всё под ним погибнет.';

  @override
  String get questF021Obj =>
      'Поднимитесь по пылающему Мировому Древу и потушите адское пламя на его вершине.';

  @override
  String get questF022Title => 'Суд Verdant Court';

  @override
  String get questF022Desc =>
      'Королева Seylith Бессмертная призвала игрока в Vaelith — первого смертного, приглашённого за Thornwall за три столетия. Она не объясняет зачем. Фракция Pale Root видит в этом возможность.';

  @override
  String get questF022Obj =>
      'Войдите в Vaelith, переживите испытание Verdant Court и узнайте, что скрывали эльфы.';

  @override
  String get questF023Title => 'Роща Смерти';

  @override
  String get questF023Desc =>
      'Смерть — старейший бог — посадил чёрный саженец в сердце Thornveil. Все, кто проходит мимо, истлевают до костей. Мировое Древо содрогается. Vaelithi замолчали. Друиды говорят — это конец леса.';

  @override
  String get questF023Obj =>
      'Вырвите саженец Смерти с лесной поляны и выживите против того, что его охраняет.';

  @override
  String get questC001Title => 'Обитатели подвала';

  @override
  String get questC001Desc =>
      'Из пещеры под старой таверной доносится скрежет. Нечто поднялось из Hollows в верхние туннели.';

  @override
  String get questC001Obj =>
      'Зачистите существ, заполонивших подвальную пещеру под старой таверной.';

  @override
  String get questC002Title => 'Светящиеся глубины';

  @override
  String get questC002Desc =>
      'Тусклое зелёное свечение пульсирует из входа в Hollows. Вода в деревенском колодце стала отдавать гнилью — травница Nessa говорит, что грибные наросты Deep Mother расползаются вверх.';

  @override
  String get questC002Obj =>
      'Спуститесь в Hollows и уничтожьте то, что загрязняет подземный источник воды.';

  @override
  String get questC003Title => 'Рой летучих мышей в Hollows';

  @override
  String get questC003Desc =>
      'Огромные пещерные летучие мыши извергаются из входа в Hollows на закате, терроризируя пастухов на поверхности.';

  @override
  String get questC003Obj =>
      'Войдите в верхние Hollows и разберитесь с колонией чудовищных летучих мышей.';

  @override
  String get questC004Title => 'Контрабандистский туннель';

  @override
  String get questC004Desc =>
      'Незаконные товары текут через потайной ход в верхних Hollows. Контрабандисты используют обработанные каменные туннели, которые шахтёры бросили, услышав странные звуки глубже.';

  @override
  String get questC004Obj =>
      'Проникните в контрабандистский туннель в Hollows и пресеките их операцию.';

  @override
  String get questC005Title => 'Обрушенная шахта';

  @override
  String get questC005Desc =>
      'Шахтёры пробили стену и обнаружили нечто древнее — проход, высеченный нечеловеческой рукой. Из-за обвала доносятся странные звуки, а камень тёплый на ощупь.';

  @override
  String get questC005Obj =>
      'Исследуйте обрушенную шахту и спасите шахтёров, застрявших в древних туннелях.';

  @override
  String get questC006Title => 'Тварь из глубин';

  @override
  String get questC006Desc =>
      'Нечто огромное обитает в подземном озере, где Hollows встречаются с грунтовыми водами. Рябь появляется там, где ничто не должно шевелиться.';

  @override
  String get questC006Obj =>
      'Выманите и убейте существо, обитающее в подземном озере Hollows.';

  @override
  String get questC007Title => 'Первая ловушка';

  @override
  String get questC007Desc =>
      'Шахтёры открыли новый туннель, и трое из них исчезли. Выживший выполз обратно, бормоча о плитах пола, которые «кричали огнём» — ловушки смотрителей из глубинных Hollows, гораздо выше, чем им положено быть.';

  @override
  String get questC007Obj =>
      'Пройдите ловушки в средних Hollows и вызволите пропавших шахтёров.';

  @override
  String get questC008Title => 'Грибная чума';

  @override
  String get questC008Desc =>
      'Биолюминесцентные грибные наросты — дыхание Deep Mother — стремительно распространяются по средним Hollows. Шахтёры, вдохнувшие споры, сходят с ума, скребут стены и говорят чужими голосами.';

  @override
  String get questC008Obj =>
      'Доберитесь до источника грибной чумы в глубине Hollows и уничтожьте его.';

  @override
  String get questC009Title => 'Рынок плоти';

  @override
  String get questC009Desc =>
      'Люди исчезают из деревень наверху. В беззаконных верхних Hollows действует чёрный рынок, торгующий живыми телами. Контрабандисты забрались глубже, чем кому-либо следовало.';

  @override
  String get questC009Obj =>
      'Проникните на подземный рынок плоти в Hollows и освободите пленников.';

  @override
  String get questC010Title => 'Подземная арена';

  @override
  String get questC010Desc =>
      'В боевых ямах Hollows появился новый чемпион — он никогда не кровоточит. Его кожа бледна и полупрозрачна, и сражается он с неподвижностью, пугающей толпу. Говорят, он выполз из глубин.';

  @override
  String get questC010Obj =>
      'Бросьте вызов непобеждённому чемпиону ямы и раскройте секрет его побед.';

  @override
  String get questC011Title => 'Коридор костяных колокольцев';

  @override
  String get questC011Desc =>
      'Исследователи нашли проход глубже в Hollows, увешанный колокольцами из костей. Первый, кто коснулся одного из них, мёртв — колоколец взорвался бритвенными осколками. Это ремесло смотрителей. За ними что-то запечатано.';

  @override
  String get questC011Obj =>
      'Пройдите коридор костяных колокольцев в глубинных Hollows, не активировав ловушки, и узнайте, что скрывается за ним.';

  @override
  String get questC012Title => 'Первый контакт';

  @override
  String get questC012Desc =>
      'Шахтёрская бригада пробилась в палату, где камень покрыт символами, которые никто не узнаёт. Трое шахтёров найдены мёртвыми — убиты тихо, точно, без борьбы. Здесь что-то есть. Что-то, что не желает быть найденным.';

  @override
  String get questC012Obj =>
      'Спуститесь в недавно вскрытую палату и выясните, что убило шахтёров.';

  @override
  String get questC013Title => 'Тюрьма эха';

  @override
  String get questC013Desc =>
      'Древняя тюрьма в средних Hollows начала трескаться. Охранные камни выходят из строя — бригадир Brick говорит, что камень кричит по ночам. То, что запечатано внутри, крепнет с каждым часом.';

  @override
  String get questC013Obj =>
      'Пройдите по разрушающейся тюрьме в Hollows и восстановите оковы, прежде чем то, что внутри, вырвется на свободу.';

  @override
  String get questC014Title => 'Лавовые жилы';

  @override
  String get questC014Desc =>
      'Магма поднимается по туннелям, которые должны быть холодным камнем. Огненные элементали выползают из расплавленной породы — кровь Deep Mother, вскипающая снизу. Ossborn полностью отступили из этого участка.';

  @override
  String get questC014Obj =>
      'Доберитесь до вулканического жерла в глубинных Hollows и запечатайте разлом, прежде чем магма достигнет верхних туннелей.';

  @override
  String get questC015Title => 'Клад дрейка';

  @override
  String get questC015Desc =>
      'Пещерный дрейк прорыл нору в средних Hollows и свил гнездо на жиле сырой руды. Его дыхание раскаляет туннели добела. Ossborn игнорируют его — он не нарушил ни одной печати. Шахтёры — не могут.';

  @override
  String get questC015Obj =>
      'Войдите в логово пещерного дрейка в Hollows и разберитесь с ним.';

  @override
  String get questC016Title => 'Похитители охранных камней';

  @override
  String get questC016Desc =>
      'Кто-то крадёт охранные камни из глубинных Hollows и продаёт их на поверхности как магические диковинки. Ossborn отреагировали — четверо торговцев мертвы, убиты тихо в своих постелях. Кражи не прекратились.';

  @override
  String get questC016Obj =>
      'Найдите похитителей охранных камней в Hollows, прежде чем Ossborn перебьют всех причастных.';

  @override
  String get questC017Title => 'Обряд Прививки';

  @override
  String get questC017Desc =>
      'Старейшина Ossborn отделилась от остальных. Она говорит — запинаясь, голосом, наслоённым эхом мёртвых смотрителей — и просит о помощи. Кости в её теле отторгают прививку. Если она умрёт, знания трёх смотрителей погибнут вместе с ней.';

  @override
  String get questC017Obj =>
      'Сопроводите ослабевшую старейшину Ossborn к глубинной кузне, где Forge Spirit сможет стабилизировать её прививки.';

  @override
  String get questC018Title => 'Разлом Пустоты';

  @override
  String get questC018Desc =>
      'Реальность рвётся в глубочайшей известной палате Hollows. Существа Пустоты хлынули сквозь трещину — та же скверна Hollow. Даже Ossborn отступают.';

  @override
  String get questC018Obj =>
      'Закройте Разлом Пустоты в глубочайших Hollows, прежде чем разрыв станет постоянным.';

  @override
  String get questC019Title => 'Цепи титана';

  @override
  String get questC019Desc =>
      'Титан, запечатанный во время Sundering, почти вырвался на свободу. Его содрогания обрушивают туннели на мили. Ossborn хранят память о том, как цепи были первоначально выкованы — но знания фрагментарны, разделены между тремя старейшинами, которые больше не сходятся в последовательности.';

  @override
  String get questC019Obj =>
      'Вместе с Forge Spirit и Ossborn перекуйте цепи титана, прежде чем он пробудится.';

  @override
  String get questC020Title => 'Безумный Ossborn';

  @override
  String get questC020Desc =>
      'Старейшина Ossborn сошёл с ума — тяжесть воспоминаний дюжины мёртвых смотрителей раздавила его собственную личность. Он верит, что он и есть тот смотритель, чьи кости несёт, и методично деактивирует печати, которые тот смотритель изначально ставил, утверждая, что это «его право снять».';

  @override
  String get questC020Obj =>
      'Выследите безумного Ossborn в глубинных Hollows и остановите его, пока он не вскрыл запечатанные тюрьмы.';

  @override
  String get questC021Title => 'Темница Пожирателя';

  @override
  String get questC021Desc =>
      'Пожиратель — нечто, предшествующее даже богам — шевелится в своём склепе под глубочайшими Hollows. Ossborn собрались в числе, невиданном за столетия. Forge Spirit замолчал. Охранные камни выходят из строя.';

  @override
  String get questC021Obj =>
      'Соберите Камни Печати и укрепите темницу Пожирателя, прежде чем он вырвется на свободу.';

  @override
  String get questC022Title => 'Врата Демонов';

  @override
  String get questC022Desc =>
      'В нижайшей точке Hollows открылись врата в бездну — печать, державшаяся со времён Sundering, теперь треснула. Демонические легионы стягиваются по ту сторону. Ossborn, хранившие память смотрителя для этой печати, мертвы.';

  @override
  String get questC022Obj =>
      'Спуститесь на дно Hollows и запечатайте Врата Демонов, прежде чем начнётся вторжение.';

  @override
  String get questC023Title => 'Змей из глубин';

  @override
  String get questC023Desc =>
      'Колоссальный змей извивается в глубочайших затопленных туннелях Hollows. Его яд растворяет охранные камни — Ossborn потеряли три запечатанных прохода из-за его кислотного следа. Если он доберётся до круга оков, темница Пожирателя падёт.';

  @override
  String get questC023Obj =>
      'Выследите великого змея в затопленных туннелях и убейте его, прежде чем он уничтожит оковы.';

  @override
  String get questC024Title => 'Сердце Горы';

  @override
  String get questC024Desc =>
      'Нечто древнее бьётся в ядре горы — Сердце Горы, живой орган из камня и магмы, который, возможно, является собственным сердцем Deep Mother, всё ещё бьющимся после Sundering. Оно пробуждается. Ossborn преклоняют колени перед ним. Forge Spirit говорит, что его нужно заглушить. Ossborn говорят, что нельзя.';

  @override
  String get questC024Obj =>
      'Доберитесь до Сердца Горы в глубочайшей точке Hollows и решите его судьбу.';

  @override
  String get questR001Title => 'Проклятый курган';

  @override
  String get questR001Desc =>
      'По ночам в старейшем кургане руин Valdris мерцают огни. Мёртвые не находят покоя в этих осыпающихся залах — а учёная Veyra говорит, что стены гудят, если прижать к ним ухо.';

  @override
  String get questR001Obj =>
      'Войдите в курган под руинами Valdris и упокойте беспокойных мертвецов.';

  @override
  String get questR002Title => 'Паразиты в подземелье';

  @override
  String get questR002Desc =>
      'Гигантские крысы заполонили подземелье под руинами Valdris. Они осмелели настолько, что нападают на исследователей, стоящих лагерем у входа.';

  @override
  String get questR002Obj =>
      'Спуститесь в подземелье руин и разберитесь с крысиным нашествием.';

  @override
  String get questR003Title => 'Шепчущий идол';

  @override
  String get questR003Desc =>
      'В руинах Valdris откопан каменный идол. Всякий, кто его коснётся, слышит шёпот на языке, который почти понимает. Учёная Veyra говорит, что идол древнее самого Valdris — его здесь быть не должно.';

  @override
  String get questR003Obj =>
      'Найдите и уничтожьте проклятый идол, скрытый в руинах Valdris.';

  @override
  String get questR004Title => 'Расхитители гробниц';

  @override
  String get questR004Desc =>
      'Грабители вскрывают запечатанные палаты в руинах Valdris. Историк Korval в ярости — каждая сломанная печать выпускает ещё больше того, что здесь таится.';

  @override
  String get questR004Obj =>
      'Остановите расхитителей гробниц, прежде чем они сломают не ту печать в руинах Valdris.';

  @override
  String get questR005Title => 'Неупокоенные мертвецы';

  @override
  String get questR005Desc =>
      'Скелеты патрулируют коридоры руин Valdris по ночам. На них доспехи королевства, что когда-то здесь стояло — доспехи, которые должны были рассыпаться в ржавчину столетия назад.';

  @override
  String get questR005Obj =>
      'Найдите источник нежити, патрулирующей коридоры Valdris, и упокойте их.';

  @override
  String get questR006Title => 'Запечатанная библиотека';

  @override
  String get questR006Desc =>
      'В руинах Valdris обнаружена запечатанная библиотека. Учёная Veyra говорит, что дверь реагирует на прикосновение — она тёплая, а металл вибрирует, будто что-то по ту сторону дышит.';

  @override
  String get questR006Obj =>
      'Войдите в запечатанную библиотеку в руинах Valdris и извлеките то, что внутри.';

  @override
  String get questR007Title => 'Шепчущие залы';

  @override
  String get questR007Desc =>
      'Нижние руины гудят низким, сводящим с ума гулом. Те, кто задерживается слишком долго, начинают говорить на мёртвых языках. Историк Korval списывает это на «остаточные чары». Учёная Veyra не столь уверена.';

  @override
  String get questR007Obj =>
      'Найдите источник сводящего с ума гула в нижних залах Valdris и заглушите его.';

  @override
  String get questR008Title => 'Серые стражи';

  @override
  String get questR008Desc =>
      'Исследователи сообщают о высоких, худых фигурах, неподвижно стоящих в нижних коридорах — пепельно-серая кожа, угловатые кости, пустые глаза. Они не реагируют на речь. Они атакуют без предупреждения при слишком близком приближении.';

  @override
  String get questR008Obj =>
      'Исследуйте загадочные серые фигуры в глубоких руинах Valdris.';

  @override
  String get questR009Title => 'Проклятое хранилище';

  @override
  String get questR009Desc =>
      'Хранилище глубже в руинах Valdris источает тёмную энергию. Люди поблизости начинают ходить во сне ко входу. Историк Korval говорит, что артефакты внутри старше Valdris на столетия — что должно быть невозможным.';

  @override
  String get questR009Obj =>
      'Войдите в хранилище Valdris и уничтожьте коллекцию проклятых артефактов.';

  @override
  String get questR010Title => 'Чумной склеп';

  @override
  String get questR010Desc =>
      'Из-под руин Valdris вышел караван нежити. Чума, которую они несут, окрашивает плоть в серый — тот же серый, что у безмолвных стражей глубже.';

  @override
  String get questR010Obj =>
      'Спуститесь в склеп под руинами и запечатайте источник ходячей чумы.';

  @override
  String get questR011Title => 'Теневой охотник';

  @override
  String get questR011Desc =>
      'Призрачный убийца преследует купца, забредшего в руины Valdris в поисках сокровищ. Трое стражей мертвы — убиты чем-то, что прошло сквозь стены, словно их не существует.';

  @override
  String get questR011Obj =>
      'Выследите призрачного убийцу в руинах и защитите купца.';

  @override
  String get questR012Title => 'Зацикленный коридор';

  @override
  String get questR012Desc =>
      'Учёная Veyra отправила команду в руины средней глубины. Они вернулись через три дня — настаивая, что прошёл лишь час. Они говорят, что каждый коридор приводил обратно в одну и ту же комнату. Один из них нарисовал карту. Карта невозможна.';

  @override
  String get questR012Obj =>
      'Пройдите зацикленные коридоры в глубоких руинах Valdris и выясните, что вызывает пространственное искажение.';

  @override
  String get questR013Title => 'Пробуждение Tithebound';

  @override
  String get questR013Desc =>
      'Tithebound был захвачен живым — впервые. Он сидит в клетке в лагере Korval, раскачиваясь и бормоча обрывки фраз. Потом он произнёс чётко: «Они возвращаются». Больше он не произнёс ни слова.';

  @override
  String get questR013Obj =>
      'Спуститесь в глубокие руины и выясните, что имел в виду захваченный Tithebound.';

  @override
  String get questR014Title => 'Затопленное святилище';

  @override
  String get questR014Desc =>
      'Храм наполовину затоплен в нижних руинах. Строители Valdris не должны были строить так глубоко — если только руины не уходят дальше вниз, чем кто-либо полагал.';

  @override
  String get questR014Obj =>
      'Нырните в затопленное святилище и остановите то, что пробуждается внизу.';

  @override
  String get questR015Title => 'Культ Valdris';

  @override
  String get questR015Desc =>
      'Среди одержимых руинами сформировался культ — смертные, верящие, что Valdris был взят, а не уничтожен, и что они могут последовать за ним, куда бы он ни делся. Они освятили кровавый алтарь в тронном зале.';

  @override
  String get questR015Obj =>
      'Уничтожьте кровавый алтарь культа в тронном зале Valdris, прежде чем их ритуал завершится.';

  @override
  String get questR016Title => 'Неправильная комната';

  @override
  String get questR016Desc =>
      'Картографическая группа обнаружила комнату, которой не должно существовать. Её нет ни на одном плане. Дверь была заперта изнутри. Когда они открыли её, один из них сказал: «Эта комната больше здания, в котором находится». Он был прав.';

  @override
  String get questR016Obj =>
      'Войдите в невозможную комнату в руинах Valdris и выживите внутри.';

  @override
  String get questR017Title => 'Война Tithebound';

  @override
  String get questR017Desc =>
      'Tithebound раскололись на две фракции в глубоких руинах. Одна группа атакует всех, кто входит. Другая стоит в стороне, наблюдая, не делая ничего, чтобы помешать — или помочь. Что-то изменилось внизу.';

  @override
  String get questR017Obj =>
      'Пройдите сквозь конфликт Tithebound в глубоких руинах и доберитесь до нижайшей доступной палаты.';

  @override
  String get questR018Title => 'Звук возвращается';

  @override
  String get questR018Desc =>
      'Гул, который учёные отвергали, стал звуком — многослойным, меняющимся шумом, срезающим края мыслей. Учёная Veyra больше не может входить в глубокие руины. Она говорит, что забыла собственное имя на три секунды, и этого было достаточно.';

  @override
  String get questR018Obj =>
      'Спуститесь в глубочайшие руины, где звук громче всего, и обнаружьте его источник.';

  @override
  String get questR019Title => 'Исповедь старейшины';

  @override
  String get questR019Desc =>
      'Старейшина Tithebound — более осознанная, чем все встреченные прежде — приблизилась к наземному лагерю. Она говорит запинаясь, но связно. Она говорит, что помнит, что произошло с её народом. Она хочет рассказать кому-нибудь, прежде чем Choir заберёт это.';

  @override
  String get questR019Obj =>
      'Защитите осознанную старейшину Tithebound, пока она говорит, и узнайте, что произошло с её видом.';

  @override
  String get questR020Title => 'Сквозь Choir';

  @override
  String get questR020Desc =>
      'Рана Severance открыта. Nameless Choir наполняет глубочайшую палату — звук, который обдирает всё. За ним, сквозь разрыв, видны башни из бледного камня. Valdris не был уничтожен. Он был взят. Игрок может его видеть.';

  @override
  String get questR020Obj =>
      'Пройдите сквозь Nameless Choir и войдите в свёрнутое измерение Valdris.';

  @override
  String get questR021Title => 'Живое королевство';

  @override
  String get questR021Desc =>
      'Valdris жив. Улицы вымощены тёмным стеклом, не отражающим звёзд. Жители движутся медленными процессиями, улыбаясь слишком широко, повторяя одни и те же слова. Архитектура изгибается по краям. Что-то глубоко, фундаментально неправильно.';

  @override
  String get questR021Obj =>
      'Исследуйте свёрнутое королевство Valdris и поймите, что произошло с его жителями.';

  @override
  String get questR022Title => 'Трон, что знает твоё имя';

  @override
  String get questR022Desc =>
      'Тронный зал всегда виден с любой улицы, словно город изгибается внутрь к нему. На троне что-то сидит. Оно носит корону. Оно не король. Оно знает имя игрока.';

  @override
  String get questR022Obj =>
      'Войдите в тронный зал Valdris и противостойте тому, что правит свёрнутым королевством.';

  @override
  String get questR023Title => 'Severance отменён';

  @override
  String get questR023Desc =>
      'Сущности на троне брошен вызов. Королевство содрогается. Choir кричит. Пространственная рана, создавшая эту тюрьму, дестабилизируется — если она схлопнется с игроком внутри, он навечно заперт в Valdris. Но если рану можно раздвинуть шире, Valdris может вернуться в реальный мир.';

  @override
  String get questR023Obj =>
      'Сбегите из схлопывающегося измерения Valdris, пока рана Severance не закрылась — или найдите способ разрушить Severance навсегда.';

  @override
  String get itemWpn001Name => 'Нож осколка Sundering';

  @override
  String get itemWpn001Desc =>
      'Грубый нож, отколотый от камня, упавшего во время войны Перворождённых Богов. Он слабо гудит в руке — эхо удара, расколовшего саму реальность.';

  @override
  String get itemWpn002Name => 'Лук следопыта Thornveil';

  @override
  String get itemWpn002Desc =>
      'Короткий охотничий лук из живого тернового дерева, на ветвях которого ещё зеленеют бутоны, что никогда не распустятся. Thornveil охотно дарит их смертным следопытам, которых терпит — тетива издаёт звук, слышимый лишь лесным тварям, и те бегут.';

  @override
  String get itemWpn003Name => 'Клинок стража Hollows';

  @override
  String get itemWpn003Desc =>
      'Короткий, широколезвийный меч из тёмного железа с пылающими рунами стражей вдоль дола. Его носят шахтёры, работающие в верхних Hollows — там, где тварям во тьме нужно нечто большее, чем фонарь.';

  @override
  String get itemWpn004Name => 'Ритуальный клинок Tithebound';

  @override
  String get itemWpn004Desc =>
      'Длинный, тонкий клинок из серого металла, который носят Tithebound — пепельнокожие стражи, патрулирующие руины Valdris по маршрутам, которые не могут объяснить. Этот был выронен часовым, который остановился посреди обхода и просто забыл, как двигаться.';

  @override
  String get itemWpn005Name => 'Затронутый Hollow фальшион';

  @override
  String get itemWpn005Desc =>
      'Клинок, слишком долго пролежавший у раны в реальности, откуда сочится Hollow. Пустотная субстанция разъела сталь, сделав её легче и невозможно острой — но металл крошится с каждым днём всё больше.';

  @override
  String get itemWpn006Name => 'Шёпот-арбалет Pale Root';

  @override
  String get itemWpn006Desc =>
      'Компактный арбалет из белёного дерева, направляющая которого инкрустирована толчёными лепестками, гасящими любой звук. Pale Root стреляют из них с Высокого Полога — двое лордов пали прежде, чем кто-то услышал болт. Verdant Court делает вид, что этого не существует.';

  @override
  String get itemWpn007Name => 'Алебарда мастерства стражей';

  @override
  String get itemWpn007Desc =>
      'Выкована по техникам, унаследованным через Rite of Grafting — узоры, которые не замыслил ни один живой разум, откованные из памяти, хранящейся в костях мёртвых стражей. Руническая последовательность на древке совпадает с молитвой связывания, запечатавшей нечто в средних глубинах.';

  @override
  String get itemWpn008Name => 'Посох-клинок Morvaine';

  @override
  String get itemWpn008Desc =>
      'Посох Morvaine, ученика, чья погоня за личизмом расколола Valdris изнутри — так, по крайней мере, гласят хроники. Дерево окаменело, а кристалл на навершии показывает королевство, совсем не похожее на руины.';

  @override
  String get itemWpn009Name => 'Десятина Смерти';

  @override
  String get itemWpn009Desc =>
      'Коса, не принадлежавшая ни одному жнецу — она просто появлялась там, где недавно прошла Смерть. Смерть — старшая из трёх уцелевших богов, свободно ходит меж двух миров и не отвечает ни на одну молитву. Этот клинок несёт то же холодное безразличие.';

  @override
  String get itemWpn010Name => 'Жила World Tree';

  @override
  String get itemWpn010Desc =>
      'Длинный лук, натянутый корневым волокном самого World Tree — исполинского древа высотой в мили, чьи корни пронзают подземный мир. Стрелы, выпущенные из этого лука, отклоняются к живым существам, словно Древо всё ещё жаждет того, что растёт вне его досягаемости.';

  @override
  String get itemWpn011Name => 'Великий молот Forge Spirit';

  @override
  String get itemWpn011Desc =>
      'Молот, излучающий жар из ядра мира. Forge Spirit, хранящий древние узы, чинил им камни-обереги — и сокрушал всё, что выбиралось наружу, когда ремонт запаздывал.';

  @override
  String get itemWpn012Name => 'Грань Severance';

  @override
  String get itemWpn012Desc =>
      'Клинок, выкованный из тёмного стекла, которым вымощены улицы Valdris — не руин, а живого королевства, свёрнутого в измерение, которого не должно существовать. Стекло отражает коридоры, по которым вы никогда не ходили, и небо без звёзд.';

  @override
  String get itemWpn013Name => 'Дуга Цветения Seylith';

  @override
  String get itemWpn013Desc =>
      'Церемониальный лук, выращенный в корневых пустотах World Tree во время Bloom Rite — испытания, определяющего наследование Vaelithi. Его тетива сама прорастает стрелами-шипами. Королева Seylith натягивала эту дугу четыре столетия. Она ни разу не промахнулась.';

  @override
  String get itemWpn014Name => 'Клык Deep Mother';

  @override
  String get itemWpn014Desc =>
      'Сталактит, вырванный прямо над Сердцем Горы — живым органом из камня и магмы, бьющимся в глубочайших Hollows. Некоторые учёные полагают, что это собственное сердце Deep Mother. Этот клык всё ещё сочится расплавленной злобой.';

  @override
  String get itemWpn015Name => 'Клинок Завета Azrathar';

  @override
  String get itemWpn015Desc =>
      'Оружие, которое демон Azrathar некогда предложил Valdris в обмен на проход в мир смертных. Хроники винят Azrathar в падении королевства — но клинок так и не был использован. Что бы ни уничтожило Valdris, это был не демон. Это было нечто куда худшее.';

  @override
  String get itemArm001Name => 'Обмотки из ткани Sundering';

  @override
  String get itemArm001Desc =>
      'Полосы древней ткани, спасённые с поля битвы старше любого королевства. Ткань была соткана до войны Перворождённых Богов — когда мироздание ещё было едино.';

  @override
  String get itemArm002Name => 'Контрабандистская тоннельная кожа';

  @override
  String get itemArm002Desc =>
      'Затвердевшая кожа, сшитая контрабандистами, которые при свете факелов таскают товар через верхние Hollows. Запачкана биолюминесцентным грибковым осадком, который так до конца и не отмывается.';

  @override
  String get itemArm003Name => 'Кираса из коры Thornveil';

  @override
  String get itemArm003Desc =>
      'Нагрудник, сформированный из опавшей коры Thornveil. Лес отдал это дерево добровольно — поражённое молнией, уже мёртвое. Даже в смерти кора сопротивляется гниению с упрямой, живой непокорностью.';

  @override
  String get itemArm004Name => 'Шинель мародёра могил Valdris';

  @override
  String get itemArm004Desc =>
      'Латаная кожа тех, кто достаточно глуп, чтобы грабить верхние руины Valdris. В каждом кармане гремят украденные безделушки, которые шепчут, когда ветер не тот. Учёная Veyra осуждает мародёров. Они носят её неодобрение как знак почёта.';

  @override
  String get itemArm005Name => 'Латы со шрамами Hollow';

  @override
  String get itemArm005Desc =>
      'Стальные латы, искривлённые близостью к Hollow — пустотной порче, сочащейся сквозь трещины реальности. Металл изогнут под углами, которые не должны держаться, однако доспех легче и крепче всего, что могла бы создать любая кузница.';

  @override
  String get itemArm006Name => 'Привитой панцирь Ossborn';

  @override
  String get itemArm006Desc =>
      'Доспех, собранный из сброшенных костяных пластин Ossborn — безглазых монахов, несущих в своих сросшихся скелетах память мёртвых стражей. Каждая пластина гудит на своей частоте, словно вспоминая другой голос.';

  @override
  String get itemArm007Name => 'Церемониальная кольчуга Verdant Court';

  @override
  String get itemArm007Desc =>
      'Кольчуга из зелёно-золотого сплава, каждое кольцо которой выполнено в форме крохотного листа. Её носили двенадцать лордов Высокого Полога при Verdant Court Vaelith — пока двоих не убили Pale Root. Этот комплект принадлежал одному из павших.';

  @override
  String get itemArm008Name => 'Латы часового Tithebound';

  @override
  String get itemArm008Desc =>
      'Хитиновый доспех, выращенный — не выкованный — часовыми Tithebound в глубоких руинах. Сделан из их собственной сброшенной кожи, наслоённой веками. Пепельно-серый и тёплый на ощупь, словно что-то внутри ещё помнит, каково это — быть живым.';

  @override
  String get itemArm009Name => 'Благословенная кольчуга Сияющего';

  @override
  String get itemArm009Desc =>
      'Латный доспех, освящённый клириками, что поддерживают печати связывания именем Сияющего. Бог, выковавший солнце, объявил владычество над поверхностным миром — этот доспех несёт тот указ, вбитый в каждую заклёпку.';

  @override
  String get itemArm010Name => 'Панцирь Deep Mother';

  @override
  String get itemArm010Desc =>
      'Хитин, добытый с существ, рождённых слишком близко к Сердцу Горы. Deep Mother зарылась в ядро земли и объявила своим всё, что под камнем — эти панцири несут её территориальную ярость, твердея под давлением.';

  @override
  String get itemArm011Name => 'Живой доспех Thornwall';

  @override
  String get itemArm011Desc =>
      'Доспех, выращенный из фрагмента самой Thornwall — заколдованной стены из тёрна, запечатывающей Vaelith от мира смертных. Люди, пересекающие Thornwall, не возвращаются. Этот доспех был выдран с края стены, и он не прекратил расти.';

  @override
  String get itemArm012Name => 'Саван Странствующей Смерти';

  @override
  String get itemArm012Desc =>
      'Плащ абсолютной черноты, невесомый и подходящий каждому. Смерть — старшая из трёх уцелевших богов, свободно ходит меж двух миров. Этот саван некогда окутывал нечто, стоявшее в тени Смерти — и тень так никогда и не ушла.';

  @override
  String get itemArm013Name => 'Одеяния придворного арканиста';

  @override
  String get itemArm013Desc =>
      'Мантии, которые носили придворные арканисты Valdris, сотворившие Severance — заклинание, утянувшее целое королевство в свёрнутое измерение. Арканисты были поглощены собственным творением. Мантии помнят заклинание в каждом вплетённом сигиле.';

  @override
  String get itemArm014Name => 'Латы связывания титана';

  @override
  String get itemArm014Desc =>
      'Доспех, выкованный из настоящих цепей, сковавших титана в средних глубинах во время Sundering. Титан всё ещё дремлет внизу — и цепи всё ещё стягиваются, когда что-то шевелится в его темнице. Надев их, вы чувствуете тяжесть удержания бога на месте.';

  @override
  String get itemArm015Name => 'Netherveil Свёрнутого Королевства';

  @override
  String get itemArm015Desc =>
      'Одеяние, сотканное из мембраны между миром смертных и свёрнутым измерением, где Valdris всё ещё живёт. Оно пахнет неподвижным воздухом королевства, где время петляет, и облегает носителя, словно реальность изгибается, избегая Severance.';

  @override
  String get itemAcc001Name => 'Треснувшая печать связывания';

  @override
  String get itemAcc001Desc =>
      'Ладонный осколок камня-оберега, носимый как подвеска. Клирики поддерживают эти печати по всему миру — эта треснула, и то, что она удерживала, давно исчезло. Напоминание о том, что мир нужно удерживать от распада — одна сломанная печать за раз.';

  @override
  String get itemAcc002Name => 'Оберег фейского договора';

  @override
  String get itemAcc002Desc =>
      'Скрученный узел из серебряной проволоки и сухих лепестков, подаренный спрайтами Фейского Двора в обмен на секрет. Договор прост: носи это, и древние духи-обманщики будут обманывать тебя лишь слегка. Когда договоры истончатся, даже это не поможет.';

  @override
  String get itemAcc003Name => 'Биолюминесцентный грибной фонарь';

  @override
  String get itemAcc003Desc =>
      'Грозди пещерных грибов в клетке, светящиеся под остаточным влиянием Deep Mother. Шахтёры ценят их выше факелов — они никогда не гаснут и пульсируют быстрее, когда из темноты за тобой что-то наблюдает.';

  @override
  String get itemAcc004Name => 'Исследовательский кулон Korval';

  @override
  String get itemAcc004Desc =>
      'Латунный медальон с фрагментом записей историка Korval об архитектуре Valdris — а именно, его озадаченные наблюдения о комнатах, которые внутри кажутся больше, чем снаружи. Он списал это на остаточные чары. Он ошибался.';

  @override
  String get itemAcc005Name => 'Амулет пустоты Hollow';

  @override
  String get itemAcc005Desc =>
      'Самоцвет с дырой — не физической дырой, а отсутствием, где Hollow разъела сердцевину кристалла. Свет огибает пустоту. Если смотреть в неё слишком долго, забываешь, на что смотрел.';

  @override
  String get itemAcc006Name => 'Печатка Circle of Thorn';

  @override
  String get itemAcc006Desc =>
      'Кольцо из живого дерева, которое носят друиды Circle of Thorn — посредники между смертными и фэйри. Их ряды редеют с каждым десятилетием. Эта печатка всё ещё проводит старые договоры, хотя всё меньше сущностей отвечает на её зов.';

  @override
  String get itemAcc007Name => 'Осколок памяти Ossborn';

  @override
  String get itemAcc007Desc =>
      'Костяной осколок от старейшины Ossborn — кусок, отпавший во время Rite of Grafting. Он несёт единственное воспоминание стража: точную руническую последовательность, державшую определённую темницу запечатанной три тысячи лет. Последовательность воспроизводится в ваших снах.';

  @override
  String get itemAcc008Name => 'Камень резонанса Tithebound';

  @override
  String get itemAcc008Desc =>
      'Гладкий серый камень, вибрирующий на той же частоте, что и пустые глаза Tithebound. Если держать его в руке, вы слышите то же, что и они — слабый звук из-под руин, принимающий форму того, чего вы желаете больше всего. Это не зов. Это приманка.';

  @override
  String get itemAcc009Name => 'Странствующее кольцо Смерти';

  @override
  String get itemAcc009Desc =>
      'Кольцо из мертвенно-белого металла, безликое и холодное. Смерть свободно ходит меж двух миров и не отвечает ни на одну молитву — но Смерть замечает тех, кто несёт артефакты божественного. Это кольцо гарантирует, что вас заметят в ответ.';

  @override
  String get itemAcc010Name => 'Лунная брошь Seylith';

  @override
  String get itemAcc010Desc =>
      'Брошь эльфийской работы с лунным камнем, хранящим четыре столетия света — по одному на каждый год правления королевы Seylith Бессмертной. Vaelithi не расстаются с такими вещами. Само её существование за пределами Thornwall означает, что кто-то дезертировал или погиб.';

  @override
  String get itemAcc011Name => 'Наручи из костей стражей';

  @override
  String get itemAcc011Desc =>
      'Наручи, вырезанные из костей древних стражей — тех самых, что сковали титанов и запечатали демонов. Ossborn вживили эти кости в себя. Эти наручи несут то, что Ossborn решили не хранить.';

  @override
  String get itemAcc012Name => 'Подвеска тишины Хора';

  @override
  String get itemAcc012Desc =>
      'Подвеска, создающая сферу абсолютной тишины — изготовлена старейшиной Tithebound, сохранившим достаточно осознанности, чтобы понять, что делает Nameless Choir. Эта тишина не умиротворяет. Это отсутствие звука, который вас разрушает.';

  @override
  String get itemAcc013Name => 'Слеза Перворождённого';

  @override
  String get itemAcc013Desc =>
      'Кристаллизованная слеза, пролитая во время Sundering — из какого именно из трёх уцелевших богов, учёные не сходятся. Сияющий оплакивал солнце. Deep Mother оплакивала землю. Смерть, старшая из всех, не плачет — но что-то упало с её лика.';

  @override
  String get itemAcc014Name => 'Корона Bloom Rite';

  @override
  String get itemAcc014Desc =>
      'Корона, сформированная в корневых пустотах World Tree во время Bloom Rite — высшего испытания наследования Vaelithi. Кандидаты спускаются и возвращаются изменёнными — или не возвращаются вовсе. Эта корона была найдена рядом с тем, кто не вернулся.';

  @override
  String get itemAcc015Name => 'Око Deep Mother';

  @override
  String get itemAcc015Desc =>
      'Не метафора. Не самоцвет в форме глаза. Глаз — молочно-белый, размером с кулак, тёплый, влажный, и он моргает. Извлечён из расщелины у Сердца Горы, где камень истончился достаточно, чтобы видеть сквозь него. Deep Mother всё ещё смотрит через него.';

  @override
  String get itemRel001Name => 'Расколотая печать связывания';

  @override
  String get itemRel001Desc =>
      'Сломанный камень-оберег — один из тысяч, разбросанных по ветшающим древним темницам. Друиды ухаживают за корнями World Tree, клирики поддерживают печати связывания, а герои несут клинки во тьму. Вы несёте осколок того, за сохранность чего все они сражаются.';

  @override
  String get itemRel002Name => 'Биолюминесцентная спора Hollows';

  @override
  String get itemRel002Desc =>
      'Живая грибковая гроздь из верхних Hollows, пульсирующая остаточным влиянием Deep Mother. Она освещает тёмные места болезненным зелёным свечением и отшатывается от жара, словно Deep Mother не одобряет огонь Сияющего.';

  @override
  String get itemRel003Name => 'Полевой дневник учёной Veyra';

  @override
  String get itemRel003Desc =>
      'Потрёпанный дневник учёной Veyra, каталогизирующей верхние руины Valdris вместе с историком Korval. Её записи скрупулёзны, но сбивчивы — замеры, противоречащие друг другу, зарисовки комнат, которые внутри больше, чем снаружи. Она называет это \"остаточными чарами\". Она ошибается.';

  @override
  String get itemRel004Name => 'Фонарь блуждающего огонька Thornveil';

  @override
  String get itemRel004Desc =>
      'Клетка из живых лоз с пойманным блуждающим огоньком из Фейских Дворов. Древние договоры, связывающие фэйри, старше даже эльфов — этот огонёк согласился служить в обмен на защиту от того, что случится, когда эти договоры наконец рухнут.';

  @override
  String get itemRel005Name => 'Осколок Hollow';

  @override
  String get itemRel005Desc =>
      'Кристаллизованный фрагмент самого Hollow — пустотная субстанция, затвердевшая во что-то почти вещественное. Она медленно уничтожает всё, к чему прикасается: дерево сереет, металл ржавеет, кожа немеет. Hollow распространяется не как вторжение, а как эрозия. Так выглядит эрозия, когда её держишь в руке.';

  @override
  String get itemRel006Name => 'Уголёк Forge Spirit';

  @override
  String get itemRel006Desc =>
      'Фрагмент живого пламени Forge Spirit — древней сущности, поддерживающей слабеющие узы в Hollows. Он считает Ossborn инструментами, не союзниками. Вас он считает чем-то ещё меньшим. Но уголёк горит, и горит истинно.';

  @override
  String get itemRel007Name => 'Осколок камня-оберега Valdris';

  @override
  String get itemRel007Desc =>
      'Фрагмент защитных оберегов, некогда ограждавших Valdris — до того как Morvaine разрушил их изнутри или Azrathar пробил их снаружи. Хроники расходятся. Этот осколок гудит на частоте, от которой ноют зубы, и иногда показывает королевство, совсем не похожее на руины.';

  @override
  String get itemRel008Name => 'Сердце корней World Tree';

  @override
  String get itemRel008Desc =>
      'Узловатый сердцевинный нарост из глубин корневой системы World Tree — там, где корни пронзают подземный мир. В тех корневых пустотах шевелится нечто, чему Vaelithi не дают имени: мор, иссушающий их деревья изнутри. Это сердце всё ещё пульсирует жизнью, но края его серы.';

  @override
  String get itemRel009Name => 'Замковый камень темницы Пожирателя';

  @override
  String get itemRel009Desc =>
      'Замковый камень из глубочайшего хранилища в Hollows — темницы, удерживающей Пожирателя, нечто, предшествующее даже богам. Forge Spirit хранит эту связь превыше всех прочих. Ossborn отказываются приближаться к ней. Камень тёплый, а если прижать к нему ухо — слышно дыхание.';

  @override
  String get itemRel010Name => 'Звено оков титана';

  @override
  String get itemRel010Desc =>
      'Одно звено из цепей, выкованных во время Sundering, чтобы сковать титанов в их темницах. Цепи были созданы, чтобы удерживать богов. Одно звено всё ещё несёт эту цель — когда держишь его, чувствуешь тяжесть удержания чего-то неизмеримо могущественного на месте.';

  @override
  String get itemRel011Name => 'Эхо Nameless Choir';

  @override
  String get itemRel011Desc =>
      'Камертон, вибрирующий на точной частоте Nameless Choir — звуке, который издаёт пространственная рана, отказываясь закрываться. Длительное воздействие стирает память: сначала мелочи, потом крупное. Держа его, вы слышите первую ноту. Она звучит как что-то, что вы забыли.';

  @override
  String get itemRel012Name => 'Сердце Verdant Court';

  @override
  String get itemRel012Desc =>
      'Изумрудное ядро власти Vaelith — живой самоцвет, росший в троне Verdant Court на протяжении столетий. Он хранит совокупную волю каждого монарха Vaelithi, прошедшего Bloom Rite. Королева Seylith восседала подле него четыреста лет. Самоцвет помнит каждый из них.';

  @override
  String get itemRel013Name => 'Сердечный камень Deep Mother';

  @override
  String get itemRel013Desc =>
      'Фрагмент самого Сердца Горы — живого органа из камня и магмы, который, по мнению учёных, является собственным сердцем Deep Mother, всё ещё бьющимся после Sundering. Он пульсирует в руке ритмом медленнее любого смертного сердца, и земля дрожит в унисон.';

  @override
  String get itemRel014Name => 'Катализатор Severance';

  @override
  String get itemRel014Desc =>
      'Кристаллический фокус, через который придворные арканисты Valdris направили Severance — заклинание, свернувшее целое королевство в измерение, которого не должно существовать. Арканисты были поглощены. Катализатор уцелел. Он всё ещё хочет сворачивать.';

  @override
  String get itemRel015Name => 'Рана Sundering';

  @override
  String get itemRel015Desc =>
      'Не предмет — шрам в самой реальности, заключённый в сферу из связующего стекла, созданную первыми стражами. Внутри видна изначальная рана: трещина, которую Перворождённые Боги разорвали в мироздании. Она так и не затянулась. Hollow сочится из подобных ран. Нести её — значит нести причину, по которой мир сломан.';

  @override
  String get itemSpl001Name => 'Осколочный снаряд';

  @override
  String get itemSpl001Desc =>
      'Зазубренный снаряд из кристаллизованной энергии Sundering, запущенный во врага. Осколки гудят эхом удара, расколовшего реальность — даже щепка несёт в себе это древнее насилие.';

  @override
  String get itemSpl002Name => 'Плеть шипов';

  @override
  String get itemSpl002Desc =>
      'Thornveil откликается на тех, кто произносит её старые имена. Это заклинание призывает плеть из живых шипов с лесной подстилки, чтобы хлестать и опутывать врагов колючими лозами.';

  @override
  String get itemSpl003Name => 'Каменная кожа';

  @override
  String get itemSpl003Desc =>
      'Глубинный камень Hollows помнит искусство стражей — древнее умение связывать землю с плотью. Это заклинание покрывает заклинателя панцирем из живого камня, отражающим клинки.';

  @override
  String get itemSpl004Name => 'Чародейский снаряд';

  @override
  String get itemSpl004Desc =>
      'Придворные арканисты Valdris очистили сырую ману до точных снарядов, преследующих цели по коридорам и из-за укрытий. По их меркам заклинание элементарно — а по меркам всех остальных — сокрушительно.';

  @override
  String get itemSpl005Name => 'Поглощение Hollow';

  @override
  String get itemSpl005Desc =>
      'Запретная техника, направляющая голод Hollow. Заклинатель открывает тончайшую трещину между мирами, и пустота пьёт жизненную силу врага, возвращая малую долю заклинателю.';

  @override
  String get itemSpl006Name => 'Цветение леса';

  @override
  String get itemSpl006Desc =>
      'Молитва World Tree, проведённая через живое дерево. Золотисто-зелёный свет расцветает вокруг заклинателя, залечивая раны и очищая порчу. Целители Vaelithi звали это Firstbloom — простейший дар, который Древо всё ещё даёт.';

  @override
  String get itemSpl007Name => 'Расплавленная волна';

  @override
  String get itemSpl007Desc =>
      'Глубоко под Hollows Forge Spirit всё ещё стучит по своей вечной наковальне. Это заклинание заимствует вздох его огня — жидкий камень извергается из земли обжигающей волной, плавящей доспехи и плоть.';

  @override
  String get itemSpl008Name => 'Десятина души';

  @override
  String get itemSpl008Desc =>
      'Tithebound из Valdris платили долги душевной субстанцией, а не монетой. Это мрачное чародейство требует ту же плату от врага — вырывая частицу его сущности, чтобы подпитать следующий удар заклинателя.';

  @override
  String get itemSpl009Name => 'Суд Сияющего';

  @override
  String get itemSpl009Desc =>
      'Столп испепеляющего света, низвергнутый именем Сияющего. Перворождённый Бог света, быть может, ослаблен, но это эхо божественного гнева всё ещё жжёт — особенно тварей Hollow.';

  @override
  String get itemSpl010Name => 'Фейский мираж';

  @override
  String get itemSpl010Desc =>
      'Фейские Дворы торгуют наваждениями и обманом. Эти чары окутывают заклинателя слоями иллюзорных двойников, сбивающих врагов с толку: их удары приходятся по фантомам, пока настоящий заклинатель движется невидимо.';

  @override
  String get itemSpl011Name => 'Пасть земли';

  @override
  String get itemSpl011Desc =>
      'Голод Deep Mother, обретший форму. Земля разверзается зазубренной пастью из каменных зубов, смыкающейся на враге, круша и заключая его в хватку земли.';

  @override
  String get itemSpl012Name => 'Хор развоплощения';

  @override
  String get itemSpl012Desc =>
      'Nameless Choir спел стены Valdris, призвав их к бытию — и заточённые отголоски всё ещё знают обратную мелодию. Это заклинание обрушивает диссонансный вопль, расплетающий чары, обереги и волю к сопротивлению.';

  @override
  String get itemSpl013Name => 'Шёпот Смерти';

  @override
  String get itemSpl013Desc =>
      'Смерть в этом мире — не конец, а терпеливый собиратель. Это запретное заклинание заимствует голос Смерти на единственный слог — шёпот, напоминающий смертным, что они смертны. Сильные могут устоять. Слабые просто замирают.';

  @override
  String get itemSpl014Name => 'Разлом Severance';

  @override
  String get itemSpl014Desc =>
      'Управляемый фрагмент Severance — заклинания, свернувшего королевство Valdris в измерение, которого не должно существовать. Это открывает краткий разлом в пространстве, поглощающий атаки и перенаправляющий их обратно в атакующего.';

  @override
  String get itemSpl015Name => 'Миролом';

  @override
  String get itemSpl015Desc =>
      'Высшее проявление магии Sundering — заклинание, на мгновение вновь вскрывающее изначальную рану между мирами. Реальность кричит. Всё в радиусе поражения соприкасается с чистой субстанцией творения и не-творения одновременно. Ничто не остаётся прежним.';

  @override
  String get itemWpn001Effect =>
      'Резонанс осколка: наносит 3 % бонусного урона вблизи зон, повреждённых Hollow.';

  @override
  String get itemWpn002Effect => '+10 % урона против фейских существ.';

  @override
  String get itemWpn003Effect =>
      'Руна стража: раскрывает скрытые проходы в Hollows. +5 % урона по минеральным врагам.';

  @override
  String get itemWpn004Effect =>
      'Удар Hollow: 15 % шанс, что атаки полностью игнорируют защиту цели.';

  @override
  String get itemWpn005Effect =>
      'Клинок Пустоты: атаки наносят 10 % бонусного урона. Hollow голодает через клинок.';

  @override
  String get itemWpn006Effect =>
      'Убийство: критические удары наносят 35 % бонусного урона. +12 % шанс крита из скрытности.';

  @override
  String get itemWpn007Effect =>
      'Сковывающий удар: 20 % шанс обездвижить цель на 1 ход. Наносит двойной урон сбежавшим узникам глубин.';

  @override
  String get itemWpn008Effect =>
      'Амбиция лича: магические атаки наносят 15 % бонусного урона. При убийстве восстанавливает 5 % макс. ОЗ.';

  @override
  String get itemWpn009Effect =>
      'Неотвратимость: игнорирует 15 % ЗАЩ и магического сопротивления цели. Нельзя обезоружить.';

  @override
  String get itemWpn010Effect =>
      'Оплетение: стрелы опутывают цели (−15 % ЛОВ на 2 хода). Регенерация 2 % ОЗ за ход в лесных зонах.';

  @override
  String get itemWpn011Effect =>
      'Сокрушитель печатей: атаки разрушают магические барьеры. +25 % урона по связанным или запечатанным врагам.';

  @override
  String get itemWpn012Effect =>
      'Размерный разрез: игнорирует 25 % ЗАЩ и магического сопротивления. 10 % шанс разорвать реальность, нанося урон по площади.';

  @override
  String get itemWpn013Effect =>
      'Неувядающий цвет: лук восстанавливает стрелы между боями. Критические удары вызывают корни из ран, нанося 40 % бонусного урона за 3 хода.';

  @override
  String get itemWpn014Effect =>
      'Жила магмы: атаки наносят 20 % бонусного огненного урона и накладывают Ожог. Стоит 2 % макс. ОЗ за удар, но урон от ожога исцеляет владельца.';

  @override
  String get itemWpn015Effect =>
      'Covenant: игнорирует ВСЕ сопротивления врагов. При убийстве поглощает сильнейшую характеристику цели навсегда (+1, накапливается до 20).';

  @override
  String get itemArm001Effect =>
      'Нить предков: снижает получаемый физический урон на 2 %.';

  @override
  String get itemArm002Effect =>
      'Бегун пещер: +5 % уклонения в подземных зонах. Слабо светится в темноте.';

  @override
  String get itemArm003Effect =>
      'Память леса: снижает урон от растительных и фейских существ на 10 %.';

  @override
  String get itemArm004Effect =>
      'Удача мародёра: +8 % к выпадению золота. 5 % шанс сопротивляться эффектам проклятий от реликвий Valdris.';

  @override
  String get itemArm005Effect =>
      'Искажение Пустоты: 8 % шанс отклонить атаки через микро-разломы. Получает 5 % дополнительного урона от священных источников.';

  @override
  String get itemArm006Effect =>
      'Привитая память: иммунитет к эффектам замешательства. 10 % шанс рефлекторно уклониться (унаследованный инстинкт стража).';

  @override
  String get itemArm007Effect =>
      'Придворная грация: иммунитет к эффектам Страха. +10 % магического сопротивления. Эльфийский свет обнаруживает скрытых врагов.';

  @override
  String get itemArm008Effect =>
      'Страж Hollow: +15 % сопротивления урону в стойкой позиции. Входящие атаки слабо отдаются эхом, предупреждая о засадах.';

  @override
  String get itemArm009Effect =>
      'Солнечная защита: иммунитет к эффектам тьмы и тени. Регенерация 2 % ОЗ за ход при дневном свете или на поверхности.';

  @override
  String get itemArm010Effect =>
      'Кожа давления: ЗАЩ увеличивается на 1 % за каждые потерянные 10 % ОЗ. Иммунитет к огненному и магмовому урону.';

  @override
  String get itemArm011Effect =>
      'Живой барьер: регенерация 3 % макс. ОЗ за ход. Шипы наносят 8 % отражённого урона атакующим ближнего боя.';

  @override
  String get itemArm012Effect =>
      'Путь Смерти: игнорирует угрозы окружающей среды. 15 % шанс отменить смертельный урон и выжить с 1 ОЗ.';

  @override
  String get itemArm013Effect =>
      'Эхо Severance: весь урон от заклинаний снижен на 20 %. Раз за бой создаёт защиту, поглощающую урон, равный 30 % макс. ОЗ.';

  @override
  String get itemArm014Effect =>
      'Несокрушимые цепи: иммунитет к отбрасыванию, оглушению и принудительному перемещению. Снижает весь входящий урон на 15 %.';

  @override
  String get itemArm015Effect =>
      'Размерная фаза: 20 % шанс полностью пройти сквозь атаки. Иммунитет ко всем эффектам статуса. Характеристики растут на 1 % за ход в бою (макс. 15 %).';

  @override
  String get itemAcc001Effect =>
      'Слабая защита: восстанавливает 1 % ОЗ за ход.';

  @override
  String get itemAcc002Effect =>
      'Благосклонность фей: +5 % уклонения от магических атак. Огоньки игнорируют владельца.';

  @override
  String get itemAcc003Effect =>
      'Глубинный свет: обнаруживает скрытых врагов и ловушки. +5 % уклонения в подземных зонах.';

  @override
  String get itemAcc004Effect =>
      'Глаз учёного: раскрывает слабости врагов в начале боя. +10 % опыта от встреч в Руинах.';

  @override
  String get itemAcc005Effect =>
      'Взор Пустоты: урон заклинаний +10 %. 5 % шанс, что атаки стирают один бафф врага.';

  @override
  String get itemAcc006Effect =>
      'Пакт друида: эффекты исцеления усилены на 15 %. Фейские существа не атакуют первыми.';

  @override
  String get itemAcc007Effect =>
      'Унаследованный инстинкт: всегда действует первым в начальном ходу боя. +15 % уклонения от ловушек.';

  @override
  String get itemAcc008Effect =>
      'Резонанс: урон заклинаний +15 %. Даёт краткое предвидение — видит вражеские атаки до их нанесения.';

  @override
  String get itemAcc009Effect =>
      'Отмеченный Смертью: +10 % ко всему урону. Иммунитет к мгновенной смерти и эффектам очарования.';

  @override
  String get itemAcc010Effect =>
      'Неугасимый свет: регенерация 3 % ОЗ за ход. +20 % сопротивления эффектам тьмы и порчи.';

  @override
  String get itemAcc011Effect =>
      'Рефлекс стража: +18 % уклонения. Автоматическая контратака раз в ход при уклонении.';

  @override
  String get itemAcc012Effect =>
      'Безмолвная защита: иммунитет ко всем звуковым и воздействующим на разум атакам. Раз за бой отменяет смертельный удар и исцеляет 25 % ОЗ.';

  @override
  String get itemAcc013Effect =>
      'Божественная скорбь: весь урон +15 %. Заклинания исцеления стоят на 40 % меньше. Иммунитет к урону божественного типа.';

  @override
  String get itemAcc014Effect =>
      'Корневая корона: все характеристики +8 %. Ниже 25 % ОЗ регенерация 5 % макс. ОЗ за ход и +20 % ко всему урону.';

  @override
  String get itemAcc015Effect =>
      'Всевидение: все характеристики врагов видимы. Заклинания игнорируют магическое сопротивление. +20 % шанс крита. Мать Глубин наблюдает через вас.';

  @override
  String get itemRel001Effect =>
      'Слабый резонанс: 5 % шанс получить дополнительное действие за ход.';

  @override
  String get itemRel002Effect =>
      'Глубинное свечение: раскрывает позиции врагов в темноте. +5 % магического урона в подземных зонах.';

  @override
  String get itemRel003Effect =>
      'Летопись учёного: +10 % опыта от всех встреч. Раскрывает скрытые знания в зонах Руин.';

  @override
  String get itemRel004Effect =>
      'Свет огонька: раскрывает скрытые пути и сокровища. +10 % уклонения от засад.';

  @override
  String get itemRel005Effect =>
      'Эрозия Пустоты: атаки навсегда снижают ЗАЩ врага на 3 % за удар (накапливается до 5 раз). Владелец теряет 1 % макс. ОЗ за ход.';

  @override
  String get itemRel006Effect =>
      'Пламя духа: каждая 3-я атака наносит 50 % бонусного огненного урона. Иммунитет к эффектам ожога.';

  @override
  String get itemRel007Effect =>
      'Эхо защиты: отражает 15 % магического урона обратно в заклинателя. +10 % сопротивления эффектам проклятий.';

  @override
  String get itemRel008Effect =>
      'Корневая связь: регенерация 4 % ОЗ за ход. Заклинания природы наносят 25 % бонусного урона. Предупреждает о порче поблизости.';

  @override
  String get itemRel009Effect =>
      'Бездонный замок: +15 % урона по древним и божественным врагам. Даёт щит (10 % макс. ОЗ) в начале каждого боя.';

  @override
  String get itemRel010Effect =>
      'Вес Титана: иммунитет к отбрасыванию и перемещению. +15 % урона по целям крупнее владельца.';

  @override
  String get itemRel011Effect =>
      'Похититель памяти: заклинания с 10 % шансом снимают случайный бафф с цели. Тёмные заклинания наносят 30 % бонусного урона. Стоит 1 % макс. ОЗ за применение.';

  @override
  String get itemRel012Effect =>
      'Зелёная воля: регенерация 5 % макс. ОЗ за ход. Эффекты природы и исцеления удваиваются. Иммунитет к порче и разложению.';

  @override
  String get itemRel013Effect =>
      'Земная ярость: раз за бой вызывает подземный толчок, наносящий урон по площади, равный 300 % МАГ. Поражённые враги теряют 20 % ЗАЩ на 3 хода. Иммунитет к земляному и магмовому урону.';

  @override
  String get itemRel014Effect =>
      'Severance: атаки навсегда снижают характеристики врагов на 5 % (накапливается). Заклинания игнорируют щиты. Раз за бой изгоняет одну способность врага.';

  @override
  String get itemRel015Effect =>
      'Рана мира: весь урон +20 %. Раз за бой открывает разлом, навсегда стирающий одну способность врага. Иммунитет ко всем дебаффам. Ближайшие враги теряют 3 % характеристик за ход.';

  @override
  String get itemSpl001Effect =>
      'Запускает осколок Sundering, наносящий урон на основе МАГ.';

  @override
  String get itemSpl002Effect =>
      'Хлещет цель терновой лозой, нанося урон МАГ и замедляя на 2 хода.';

  @override
  String get itemSpl003Effect =>
      'Создаёт каменный щит, поглощающий урон, равный 50 % МАГ, на 3 хода.';

  @override
  String get itemSpl004Effect =>
      'Выпускает 3 самонаводящихся снаряда тайной энергии, каждый наносит урон на основе МАГ.';

  @override
  String get itemSpl005Effect =>
      'Вытягивает ОЗ врага в размере 80 % МАГ и исцеляет заклинателя на половину.';

  @override
  String get itemSpl006Effect =>
      'Исцеляет заклинателя на 120 % МАГ и снимает один негативный эффект.';

  @override
  String get itemSpl007Effect =>
      'Извергает магму, нанося тяжёлый урон МАГ и снижая ЗАЩ врага на 15 % на 3 хода.';

  @override
  String get itemSpl008Effect =>
      'Крадёт АТК/МАГ врага на 10 % на 3 хода и усиливает следующую атаку заклинателя на 30 %.';

  @override
  String get itemSpl009Effect =>
      'Священный урон, наносящий 150 % МАГ. Наносит двойной урон врагам, поражённым Hollow.';

  @override
  String get itemSpl010Effect =>
      'Создаёт иллюзии, дающие 50 % уклонения на 3 хода. Следующая атака из скрытности наносит +40 % урона.';

  @override
  String get itemSpl011Effect =>
      'Ловит врага на 2 хода, нанося 100 % МАГ каждый ход. Пойманные враги не могут действовать.';

  @override
  String get itemSpl012Effect =>
      'Звуковой урон по площади, наносящий 120 % МАГ. Рассеивает все баффы врагов и накладывает молчание на 2 хода.';

  @override
  String get itemSpl013Effect =>
      'Шанс мгновенно убить врагов ниже 25 % ОЗ. Иначе наносит 200 % урона МАГ.';

  @override
  String get itemSpl014Effect =>
      'Открывает размерный разлом, поглощающий весь урон на 2 хода, затем взрывается, нанося 250 % поглощённого урона.';

  @override
  String get itemSpl015Effect =>
      'Катастрофический урон, наносящий 400 % МАГ всем врагам. Навсегда снижает все характеристики врагов на 20 %. Раз за бой.';
}
