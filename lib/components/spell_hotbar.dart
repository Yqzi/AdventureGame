import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/components/cards.dart';
import 'package:Questborne/models/item.dart';

/// A horizontally scrollable row of spell buttons shown above the text input
/// during quests. Tapping a spell fires [onCast] with the selected spell item.
class SpellHotbar extends StatelessWidget {
  const SpellHotbar({
    super.key,
    required this.spells,
    required this.currentMana,
    required this.onCast,
    this.enabled = true,
  });

  final List<Item> spells;
  final int currentMana;
  final ValueChanged<Item> onCast;
  final bool enabled;

  static const _rarityColors = {
    Rarity.common: Color(0xFFB0B0B0),
    Rarity.rare: Color(0xFF56CCF2),
    Rarity.epic: Color(0xFF8B5CF6),
    Rarity.mythic: Color(0xFFE85D3A),
  };

  @override
  Widget build(BuildContext context) {
    if (spells.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: spells.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final spell = spells[index];
          final canCast = enabled && currentMana >= spell.manaCost;
          final color = _rarityColors[spell.rarity] ?? Colors.white70;

          return GestureDetector(
            onTap: canCast ? () => onCast(spell) : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: canCast ? 1.0 : 0.38,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withOpacity(canCast ? 0.50 : 0.15),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        '${spell.manaCost} MP',
                        style: GoogleFonts.epilogue(
                          color: color.withOpacity(0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
