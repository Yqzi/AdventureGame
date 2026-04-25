import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/components/cards.dart';
import 'package:Questborne/models/item.dart';

/// A vertically-stacked component that shows:
///  1. A spell-slot pips row (filled/empty dots per spell level with any max slots)
///  2. A horizontally scrollable row of spell buttons
///
/// Tapping a spell fires [onCast] with the selected spell item.
class SpellHotbar extends StatelessWidget {
  const SpellHotbar({
    super.key,
    required this.spells,
    required this.currentSpellSlots,
    required this.maxSpellSlots,
    required this.onCast,
    this.enabled = true,
  });

  final List<Item> spells;
  final List<int> currentSpellSlots;
  final List<int> maxSpellSlots;
  final ValueChanged<Item> onCast;
  final bool enabled;

  static const _rarityColors = {
    Rarity.common: Color(0xFFB0B0B0),
    Rarity.rare: Color(0xFF56CCF2),
    Rarity.epic: Color(0xFF8B5CF6),
    Rarity.mythic: Color(0xFFE85D3A),
  };

  /// True if the player can cast this spell (has remaining slot at spell level).
  bool _canCast(Item spell) {
    if (!enabled) return false;
    final slotLevel = spell.manaCost.clamp(1, 9);
    return currentSpellSlots[slotLevel - 1] > 0;
  }

  @override
  Widget build(BuildContext context) {
    if (spells.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Spell Slot Pips row ──
        _SpellSlotPips(
          currentSpellSlots: currentSpellSlots,
          maxSpellSlots: maxSpellSlots,
        ),
        const SizedBox(height: 4),

        // ── Spell buttons ──
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: spells.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final spell = spells[index];
              final canCast = _canCast(spell);
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
                            'Slot ${spell.manaCost}',
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
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SPELL SLOT PIPS
// ─────────────────────────────────────────────────────────────

/// Compact row showing filled/empty dots per spell level.
/// Only levels with at least 1 max slot are shown.
/// e.g.  L1 ●●● L2 ●● L3 ●
class _SpellSlotPips extends StatelessWidget {
  const _SpellSlotPips({
    required this.currentSpellSlots,
    required this.maxSpellSlots,
  });

  final List<int> currentSpellSlots;
  final List<int> maxSpellSlots;

  @override
  Widget build(BuildContext context) {
    // Collect levels that have any max slots
    final levels = <int>[];
    for (int i = 0; i < 9; i++) {
      if (i < maxSpellSlots.length && maxSpellSlots[i] > 0) {
        levels.add(i);
      }
    }
    if (levels.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: levels.map((i) {
            final max = maxSpellSlots[i];
            final current = i < currentSpellSlots.length
                ? currentSpellSlots[i]
                : 0;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'L${i + 1}',
                    style: GoogleFonts.epilogue(
                      color: const Color(0xFFE3D5B8).withOpacity(0.5),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 3),
                  ...List.generate(max, (j) {
                    final filled = j < current;
                    return Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? const Color(0xFF8B5CF6)
                              : Colors.transparent,
                          border: Border.all(
                            color: const Color(
                              0xFF8B5CF6,
                            ).withOpacity(filled ? 0.8 : 0.35),
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
