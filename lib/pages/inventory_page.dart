import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Questborne/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/blocs/app/app_bloc.dart';
import 'package:Questborne/blocs/app/app_event.dart';
import 'package:Questborne/blocs/app/app_state.dart';
import 'package:Questborne/colors.dart';
import 'package:Questborne/components/cards.dart';
import 'package:Questborne/components/experience_bar.dart';
import 'package:Questborne/components/containers.dart';
import 'package:Questborne/components/top_bar.dart';
import 'package:Questborne/models/item.dart';
import 'package:Questborne/models/player.dart';
import 'package:Questborne/utils/localized_enums.dart';
import 'package:Questborne/utils/localized_items.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: context.read<GameBloc>().player.name.toUpperCase(),
        desc: AppLocalizations.of(context).inventoryTitle,
        textStyle: GoogleFonts.epilogue(
          color: const Color(0xFFE3D5B8),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.25,
          fontStyle: FontStyle.italic,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: const Color(0xFFE3D5B8),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            color: const Color(0xFFE3D5B8),
            onPressed: () => Navigator.pushNamed(context, '/characterSheet'),
            tooltip: 'Character Sheet',
          ),
          IconButton(
            icon: const Icon(Icons.diamond_outlined),
            color: const Color(0xFFE3D5B8),
            onPressed: () => Navigator.pushNamed(context, '/subscription'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            color: const Color(0xFFE3D5B8),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, _) {
          final player = context.read<GameBloc>().player;

          final equipment = player.equipment;
          // Non-spell items in inventory (spells live in the Spellbook section)
          final inventory = player.inventory
              .where((i) => i.type != ItemType.spell)
              .toList();

          return Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 48, 30, 23),
                  Color.fromARGB(255, 48, 31, 24),
                ],
                center: Alignment.center,
                radius: 1.6,
              ),
            ),
            child: Column(
              children: [
                // ─── Top section: Equipped slots (left) | Unequipped grid (right) ───
                Expanded(
                  child: Row(
                    children: [
                      // ──────── EQUIPPED SLOTS ────────
                      SizedBox(
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _EquippedSlotTile(
                              icon: FontAwesomeIcons.bolt,
                              slotLabel: AppLocalizations.of(
                                context,
                              ).itemTypeWeapon,
                              item: equipment.weapon,
                              slotType: ItemType.weapon,
                            ),
                            const SizedBox(height: 14),
                            _EquippedSlotTile(
                              icon: FontAwesomeIcons.shield,
                              slotLabel: AppLocalizations.of(
                                context,
                              ).itemTypeArmor,
                              item: equipment.armor,
                              slotType: ItemType.armor,
                            ),
                            const SizedBox(height: 14),
                            _EquippedSlotTile(
                              icon: FontAwesomeIcons.ring,
                              slotLabel: AppLocalizations.of(
                                context,
                              ).itemTypeAccessory,
                              item: equipment.accessory,
                              slotType: ItemType.accessory,
                            ),
                            const SizedBox(height: 14),
                            _EquippedSlotTile(
                              icon: FontAwesomeIcons.ankh,
                              slotLabel: AppLocalizations.of(
                                context,
                              ).itemTypeRelic,
                              item: equipment.relic,
                              slotType: ItemType.relic,
                            ),
                          ],
                        ),
                      ),

                      // ──────── DIVIDER ────────
                      Container(
                        color: const Color.fromARGB(239, 88, 61, 53),
                        width: 1,
                        height: double.infinity,
                      ),

                      // ──────── UNEQUIPPED ITEMS GRID ────────
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(50, 32, 20, 16),
                          child: Column(
                            children: [
                              Container(
                                height: 55,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(239, 88, 61, 53),
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    ).inventoryUnequipped,
                                    style: GoogleFonts.epilogue(
                                      color: const Color.fromARGB(
                                        230,
                                        255,
                                        255,
                                        255,
                                      ),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(12),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 1,
                                      ),
                                  itemCount: inventory.isEmpty
                                      ? 8 // extra empty slots
                                      : (inventory.length < 8
                                            ? 8
                                            : inventory.length),
                                  itemBuilder: (context, index) {
                                    if (index < inventory.length) {
                                      final item = inventory[index];
                                      return _InventoryItemCell(item: item);
                                    }
                                    // Empty placeholder slot
                                    return DottedBorder(
                                      options: RectDottedBorderOptions(
                                        dashPattern: [4, 2],
                                        color: borderGrey,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                            240,
                                            27,
                                            17,
                                            14,
                                          ),
                                        ),
                                        child: const Center(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Spellbook section ───
                _SpellbookSection(player: player),

                // ─── XP bar ───
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: ExperienceBar(player: player),
                ),

                // ─── Bottom section: Stats ───
                Container(
                  height: 2,
                  color: const Color.fromARGB(239, 88, 61, 53),
                ),
                // Row 1: Ability modifiers
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatTile(
                        icon: FontAwesomeIcons.dumbbell,
                        label: 'STR',
                        value: player.strMod,
                        isModifier: true,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.boltLightning,
                        label: 'DEX',
                        value: player.dexMod,
                        isModifier: true,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.heart,
                        label: 'CON',
                        value: player.conMod,
                        isModifier: true,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.book,
                        label: 'INT',
                        value: player.intMod,
                        isModifier: true,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.eye,
                        label: 'WIS',
                        value: player.wisMod,
                        isModifier: true,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.star,
                        label: 'CHA',
                        value: player.chaMod,
                        isModifier: true,
                      ),
                    ],
                  ),
                ),
                // Thin divider between rows
                Container(
                  height: 1,
                  color: const Color.fromARGB(80, 88, 61, 53),
                ),
                // Row 2: Combat stats
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatTile(
                        icon: FontAwesomeIcons.shieldHalved,
                        label: 'AC',
                        value: player.armorClass,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.plus,
                        label: 'PROF',
                        value: player.proficiencyBonus,
                        isModifier: true,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.magnifyingGlass,
                        label: 'PERC',
                        value: player.passivePerception,
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.dice,
                        label: 'HD',
                        value: player.hitDiceRemaining,
                        maxValue: player.level,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  EQUIPPED SLOT TILE  — left column, shows icon or item name
// ═══════════════════════════════════════════════════════════════

class _EquippedSlotTile extends StatelessWidget {
  final IconData icon;
  final String slotLabel;
  final Item? item;
  final ItemType slotType;

  const _EquippedSlotTile({
    required this.icon,
    required this.slotLabel,
    required this.item,
    required this.slotType,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasItem = item != null;
    final borderCol = hasItem ? item!.rarity.color.withAlpha(180) : borderGrey;
    final iconCol = hasItem ? item!.rarity.color : borderGrey;

    return GestureDetector(
      onTap: hasItem
          ? () => _showEquippedItemSheet(context, item!, slotType)
          : null,
      child: Column(
        children: [
          InventorySlot(
            icon: icon,
            item: item,
            height: 75,
            width: 75,
            borderColor: borderCol,
            iconColor: iconCol,
          ),
          const SizedBox(height: 4),
          Text(
            hasItem ? item!.name : slotLabel,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.epilogue(
              color: hasItem
                  ? item!.rarity.color
                  : const Color.fromARGB(220, 255, 255, 255),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: hasItem ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showEquippedItemSheet(
    BuildContext context,
    Item item,
    ItemType slotType,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 34, 22, 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _ItemDetailSheet(
        item: item,
        isEquipped: true,
        onAction: () {
          context.read<GameBloc>().add(UnequipSlotEvent(slotType));
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SPELLBOOK SECTION — all owned spells, always available
// ═══════════════════════════════════════════════════════════════

class _SpellbookSection extends StatelessWidget {
  const _SpellbookSection({required this.player});
  final Player player;

  static const _rarityColors = {
    Rarity.common: Color(0xFFB0B0B0),
    Rarity.rare: Color(0xFF56CCF2),
    Rarity.epic: Color(0xFF8B5CF6),
    Rarity.mythic: Color(0xFFE85D3A),
  };

  @override
  Widget build(BuildContext context) {
    final spells = player.spellItems;
    if (spells.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(40, 139, 92, 246),
        border: const Border(
          top: BorderSide(color: Color.fromARGB(120, 139, 92, 246)),
          bottom: BorderSide(color: Color.fromARGB(120, 139, 92, 246)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.bookOpen,
                size: 11,
                color: Color(0xFF8B5CF6),
              ),
              const SizedBox(width: 6),
              Text(
                'SPELLBOOK',
                style: GoogleFonts.epilogue(
                  color: const Color(0xFF8B5CF6),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${spells.length} spell${spells.length == 1 ? '' : 's'}',
                style: GoogleFonts.epilogue(
                  color: const Color(0xFF8B5CF6).withOpacity(0.55),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: spells.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final spell = spells[i];
                final color =
                    _rarityColors[spell.rarity] ?? const Color(0xFFB0B0B0);
                return Container(
                  constraints: const BoxConstraints(
                    minWidth: 90,
                    maxWidth: 130,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withOpacity(0.35)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        spell.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.epilogue(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Slot ${spell.manaCost}  ·  Lv.${spell.level}',
                        style: GoogleFonts.epilogue(
                          color: color.withOpacity(0.55),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  INVENTORY ITEM CELL  — grid tile for unequipped items
// ═══════════════════════════════════════════════════════════════

class _InventoryItemCell extends StatelessWidget {
  final Item item;
  const _InventoryItemCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showItemSheet(context),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          dashPattern: [4, 2],
          color: item.rarity.color.withAlpha(140),
          padding: EdgeInsets.zero,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(240, 27, 17, 14),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(item.imagePath, fit: BoxFit.contain),
                ),
              ),
              Column(
                children: [
                  Text(
                    localizedItemName(AppLocalizations.of(context), item.id),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.epilogue(
                      color: item.rarity.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    localizedRarity(AppLocalizations.of(context), item.rarity),
                    style: GoogleFonts.epilogue(
                      color: item.rarity.color.withAlpha(160),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 34, 22, 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _ItemDetailSheet(
        item: item,
        isEquipped: false,
        onAction: () {
          context.read<GameBloc>().add(EquipItemEvent(item));
          Navigator.pop(context);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ITEM DETAIL BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════

class _ItemDetailSheet extends StatelessWidget {
  final Item item;
  final bool isEquipped;
  final VoidCallback onAction;

  const _ItemDetailSheet({
    required this.item,
    required this.isEquipped,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag handle ──
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Name + rarity ──
          Row(
            children: [
              Image.asset(
                item.imagePath,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedItemName(AppLocalizations.of(context), item.id),
                      style: GoogleFonts.epilogue(
                        color: item.rarity.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${localizedRarity(AppLocalizations.of(context), item.rarity)}  ·  ${localizedItemType(AppLocalizations.of(context), item.type)}  ·  ${AppLocalizations.of(context).labelLevel(item.level)}',
                      style: GoogleFonts.epilogue(
                        color: Colors.white54,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Description ──
          Text(
            localizedItemDesc(AppLocalizations.of(context), item.id),
            style: GoogleFonts.epilogue(
              color: Colors.white70,
              fontSize: 12,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          // ── Stat summary ──
          Text(
            localizedStatSummary(
              AppLocalizations.of(context),
              manaCost: item.manaCost,
              attack: item.attack,
              defense: item.defense,
              magic: item.magic,
              agility: item.agility,
              health: item.health,
              effect: localizedItemEffect(
                AppLocalizations.of(context),
                item.id,
              ),
            ),
            style: GoogleFonts.epilogue(
              color: const Color(0xFFE3D5B8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          // ── Action button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEquipped
                    ? const Color.fromARGB(255, 120, 50, 40)
                    : const Color.fromARGB(255, 50, 100, 60),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                isEquipped
                    ? AppLocalizations.of(context).unequip
                    : AppLocalizations.of(context).equip,
                style: GoogleFonts.epilogue(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  STAT TILE — bottom bar stat display
// ═══════════════════════════════════════════════════════════════

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  /// When true, displays value as +N / -N modifier format.
  final bool isModifier;

  /// When > 0, shows "value/maxValue" (used for hit dice).
  final int maxValue;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isModifier = false,
    this.maxValue = 0,
  });

  String get _displayValue {
    if (maxValue > 0) return '$value/$maxValue';
    if (isModifier) return value >= 0 ? '+$value' : '$value';
    return '$value';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      width: 52,
      child: Column(
        children: [
          FaIcon(
            icon,
            color: const Color.fromARGB(180, 255, 255, 255),
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.epilogue(
              color: const Color.fromARGB(180, 255, 255, 255),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _displayValue,
            style: GoogleFonts.epilogue(
              color: const Color.fromARGB(220, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
