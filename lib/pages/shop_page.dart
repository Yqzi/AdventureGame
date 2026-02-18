import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/blocs/app/app_event.dart';
import 'package:tes/blocs/app/app_state.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/top_bar.dart';
import 'package:tes/models/item.dart';
import 'package:tes/models/player.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  /// Pick 4 items whose level is near the player's level.
  /// Uses a day-based seed so the selection stays the same all day.
  /// Does NOT exclude owned items — they show as "SOLD" instead.
  List<Item> _waresForDay(int playerLevel) {
    final now = DateTime.now();
    final daySeed = now.year * 10000 + now.month * 100 + now.day;

    final low = (playerLevel - 10).clamp(1, 100);
    final high = (playerLevel + 5).clamp(1, 100);

    var pool = allItems
        .where((i) => i.level >= low && i.level <= high)
        .toList();

    // Fallback: grab closest by level
    if (pool.length < 4) {
      pool = List.of(allItems)
        ..sort(
          (a, b) => (a.level - playerLevel).abs().compareTo(
            (b.level - playerLevel).abs(),
          ),
        );
    }

    // Deterministic daily shuffle
    pool.shuffle(Random(daySeed));
    return pool.take(4).toList();
  }

  /// Check whether the player already owns this item.
  bool _isOwned(Player player, Item item) {
    final ownedIds = <String>{
      ...player.inventory.map((i) => i.id),
      if (player.equipment.weapon != null) player.equipment.weapon!.id,
      if (player.equipment.armor != null) player.equipment.armor!.id,
      if (player.equipment.accessory != null) player.equipment.accessory!.id,
      if (player.equipment.relic != null) player.equipment.relic!.id,
    };
    return ownedIds.contains(item.id);
  }

  void _showItemDetail(
    BuildContext context,
    Item item,
    Player player, {
    bool isSold = false,
  }) {
    final canAfford = !isSold && player.canAfford(item.price);

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 34, 22, 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: item.rarity.color.withOpacity(0.4)),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 40,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: icon + name + rarity ──
                Row(
                  children: [
                    // Item type icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.rarity.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: item.rarity.color.withOpacity(0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          item.type.icon,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.epilogue(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: item.rarity.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.rarity.label.toUpperCase(),
                                  style: GoogleFonts.epilogue(
                                    color: item.rarity.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.type.label,
                                style: GoogleFonts.epilogue(
                                  color: greyText,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'LV ${item.level}',
                                style: GoogleFonts.epilogue(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Description ──
                Text(
                  item.description,
                  style: GoogleFonts.epilogue(
                    color: const Color(0xFFE3D5B8),
                    fontSize: 14,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Stat bonuses ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (item.attack > 0)
                        _statChip('ATK', '+${item.attack}', Colors.redAccent),
                      if (item.defense > 0)
                        _statChip('DEF', '+${item.defense}', Colors.blueAccent),
                      if (item.magic > 0)
                        _statChip('MAG', '+${item.magic}', Colors.purpleAccent),
                      if (item.agility > 0)
                        _statChip(
                          'AGI',
                          '+${item.agility}',
                          Colors.greenAccent,
                        ),
                      if (item.health > 0)
                        _statChip('HP', '+${item.health}', Colors.amber),
                    ],
                  ),
                ),

                // ── Effect ──
                if (item.effect.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.rarity.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: item.rarity.color.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.wandMagicSparkles,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.effect,
                            style: GoogleFonts.epilogue(
                              color: const Color(0xFFE3D5B8),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                // ── Price + Buy button ──
                Row(
                  children: [
                    // Price tag
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.coins,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.priceLabel,
                          style: GoogleFonts.epilogue(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Cancel
                    if (canAfford && !isSold)
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Close',
                          style: GoogleFonts.epilogue(color: greyText),
                        ),
                      ),
                    const SizedBox(width: 8),
                    // Buy
                    ElevatedButton.icon(
                      onPressed: canAfford && !isSold
                          ? () {
                              Navigator.of(ctx).pop();
                              if (!context.mounted) return;
                              context.read<GameBloc>().add(BuyItemEvent(item));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: const Color.fromARGB(
                                    230,
                                    34,
                                    22,
                                    18,
                                  ),
                                  content: Text(
                                    'Purchased ${item.name}!',
                                    style: GoogleFonts.epilogue(
                                      color: const Color(0xFFE3D5B8),
                                    ),
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAfford ? redText : Colors.grey[800],
                        disabledBackgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.cartShopping,
                        color: canAfford ? Colors.white : Colors.white38,
                        size: 14,
                      ),
                      label: Text(
                        isSold
                            ? 'Sold'
                            : canAfford
                            ? 'Buy'
                            : 'Not enough gold',
                        style: GoogleFonts.epilogue(
                          color: canAfford ? Colors.white : Colors.white38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.epilogue(
            color: color.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.epilogue(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final player = context.read<GameBloc>().player;
        final wares = _waresForDay(player.level);

        // Sort: unsold first, sold at bottom
        final sorted = List<Item>.from(wares)
          ..sort((a, b) {
            final aSold = _isOwned(player, a) ? 1 : 0;
            final bSold = _isOwned(player, b) ? 1 : 0;
            return aSold.compareTo(bSold);
          });

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 41, 26, 20),
          appBar: TopBar(
            title: 'THE MARKET',
            textStyle: GoogleFonts.epilogue(
              color: const Color(0xFFE3D5B8),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: const Color(0xFFE3D5B8),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.coins),
                color: redText,
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Banner image ───
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuClCOV1kVgcBq2-51nor8G1KJ9OrPiMBmX2p1dNs7B6deOoAuD4Hv86MmkBWquDJzN7Ej0bxR2Jt6-8EcUwZl2UdGU6IHhOhpyH7VzQ-708aIvzHmlf7APrNgJJ8zUucA6jvPVqC560j9FP67Unt371jTsTcyUrcFXS1GMCy-Qyx91RY56h_6evt8EPVC8_3TksYGwZKowLgqvE39GGpcaTZ_h9Qk59AN-VTwpl5SwVI5y6cZDYer4xFhDJP99jAhN_DPtcJrpCMCY',
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment(0, -0.5),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color.fromARGB(255, 41, 26, 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            '"Choose wisely, traveler. My wares cost more than just gold..."',
                            style: GoogleFonts.epilogue(
                              color: Colors.white60,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // ─── Player level / gold bar ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Level badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: redText.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: redText.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.shieldHalved,
                            color: Color(0xFFE3D5B8),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'LV ${player.level}',
                            style: GoogleFonts.epilogue(
                              color: const Color(0xFFE3D5B8),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Gold display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.coins,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${player.gold} Gold',
                            style: GoogleFonts.epilogue(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ─── Header row ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Merchant's Wares",
                      style: GoogleFonts.epilogue(
                        color: const Color(0xFFE3D5B8),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'STOCK: ${sorted.where((i) => !_isOwned(player, i)).length}',
                      style: GoogleFonts.epilogue(
                        color: Colors.white54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Item list ───
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    itemCount: sorted.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = sorted[index];
                      final isSold = _isOwned(player, item);
                      final canAfford = !isSold && player.canAfford(item.price);
                      return GestureDetector(
                        onTap: () => _showItemDetail(
                          context,
                          item,
                          player,
                          isSold: isSold,
                        ),
                        child: ShopCardModel(
                          item: item,
                          isSold: isSold,
                          onPressed: canAfford
                              ? () => _showItemDetail(
                                  context,
                                  item,
                                  player,
                                  isSold: isSold,
                                )
                              : () {
                                  if (isSold) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color.fromARGB(
                                        230,
                                        34,
                                        22,
                                        18,
                                      ),
                                      content: Text(
                                        'Not enough gold!',
                                        style: GoogleFonts.epilogue(
                                          color: redText,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                        ),
                      );
                    },
                  ),
                ),
              ),
              CustomBottomBar(currentIndex: 2),
            ],
          ),
        );
      },
    );
  }
}
