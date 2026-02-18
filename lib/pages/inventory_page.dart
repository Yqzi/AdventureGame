import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/blocs/app/app_event.dart';
import 'package:tes/blocs/app/app_state.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/experience_bar.dart';
import 'package:tes/components/containers.dart';
import 'package:tes/components/top_bar.dart';
import 'package:tes/models/item.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'CHARACTER INVENTORY',
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
            icon: const Icon(Icons.more_vert),
            color: const Color(0xFFE3D5B8),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, _) {
          final player = context.read<GameBloc>().player;

          final equipment = player.equipment;
          final inventory = player.inventory;

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
                              slotLabel: 'WEAPON',
                              item: equipment.weapon,
                              slotType: ItemType.weapon,
                            ),
                            const SizedBox(height: 14),
                            _EquippedSlotTile(
                              icon: FontAwesomeIcons.shield,
                              slotLabel: 'ARMOR',
                              item: equipment.armor,
                              slotType: ItemType.armor,
                            ),
                            const SizedBox(height: 14),
                            _EquippedSlotTile(
                              icon: FontAwesomeIcons.ring,
                              slotLabel: 'ACCESSORY',
                              item: equipment.accessory,
                              slotType: ItemType.accessory,
                            ),
                            const SizedBox(height: 14),
                            _EquippedSlotTile(
                              icon: FontAwesomeIcons.ankh,
                              slotLabel: 'RELIC',
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
                                    'UNEQUIPPED',
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
                                  itemCount: inventory.length < 8
                                      ? 8 // extra empty slots
                                      : inventory.length,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatTile(
                        icon: FontAwesomeIcons.crosshairs,
                        label: 'ATK',
                        value: player.baseAttack,
                        bonus: equipment.totalBonus('attack'),
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.shieldHalved,
                        label: 'DEF',
                        value: player.baseDefense,
                        bonus: equipment.totalBonus('defense'),
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.wandSparkles,
                        label: 'MAG',
                        value: player.baseMagic,
                        bonus: equipment.totalBonus('magic'),
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.boltLightning,
                        label: 'AGI',
                        value: player.baseAgility,
                        bonus: equipment.totalBonus('agility'),
                      ),
                      _StatTile(
                        icon: FontAwesomeIcons.heartPulse,
                        label: 'HP',
                        value: player.baseHealth,
                        bonus: equipment.totalBonus('health'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
                  child: Text(
                    item.type.icon,
                    style: const TextStyle(fontSize: 33),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.epilogue(
                      color: item.rarity.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.rarity.label,
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
              Text(item.type.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.epilogue(
                        color: item.rarity.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${item.rarity.label}  ·  ${item.type.label}  ·  Lv ${item.level}',
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
            item.description,
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
            item.statSummary,
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
                isEquipped ? 'UNEQUIP' : 'EQUIP',
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
  final int bonus;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.bonus = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      width: 64,
      child: Column(
        children: [
          FaIcon(
            icon,
            color: const Color.fromARGB(180, 255, 255, 255),
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.epilogue(
              color: const Color.fromARGB(180, 255, 255, 255),
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$value',
                style: GoogleFonts.epilogue(
                  color: const Color.fromARGB(220, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (bonus > 0)
                Text(
                  ' +$bonus',
                  style: GoogleFonts.epilogue(
                    color: const Color.fromARGB(200, 100, 220, 100),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
