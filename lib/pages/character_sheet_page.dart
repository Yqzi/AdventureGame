import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/blocs/app/app_bloc.dart';
import 'package:Questborne/blocs/app/app_state.dart';
import 'package:Questborne/components/top_bar.dart';
import 'package:Questborne/models/ability_scores.dart';
import 'package:Questborne/models/background.dart';
import 'package:Questborne/models/character_class.dart';
import 'package:Questborne/models/character_race.dart';
import 'package:Questborne/models/player.dart';

// ─────────────────────────────────────────────────────────────
//  D&D 5e skill → ability mapping (18 skills)
// ─────────────────────────────────────────────────────────────

typedef _Skill = ({String name, AbilityType ability});

const List<_Skill> _allSkills = [
  (name: 'Acrobatics', ability: AbilityType.dexterity),
  (name: 'Animal Handling', ability: AbilityType.wisdom),
  (name: 'Arcana', ability: AbilityType.intelligence),
  (name: 'Athletics', ability: AbilityType.strength),
  (name: 'Deception', ability: AbilityType.charisma),
  (name: 'History', ability: AbilityType.intelligence),
  (name: 'Insight', ability: AbilityType.wisdom),
  (name: 'Intimidation', ability: AbilityType.charisma),
  (name: 'Investigation', ability: AbilityType.intelligence),
  (name: 'Medicine', ability: AbilityType.wisdom),
  (name: 'Nature', ability: AbilityType.intelligence),
  (name: 'Perception', ability: AbilityType.wisdom),
  (name: 'Performance', ability: AbilityType.charisma),
  (name: 'Persuasion', ability: AbilityType.charisma),
  (name: 'Religion', ability: AbilityType.intelligence),
  (name: 'Sleight of Hand', ability: AbilityType.dexterity),
  (name: 'Stealth', ability: AbilityType.dexterity),
  (name: 'Survival', ability: AbilityType.wisdom),
];

const _bgColor = Color.fromARGB(255, 27, 17, 14);
const _cardColor = Color.fromARGB(255, 34, 22, 18);
const _accent = Color(0xFF8D6E63);
const _textPrimary = Color(0xFFE3D5B8);
const _textDim = Color(0xFF8D7060);
const _border = Color.fromARGB(239, 88, 61, 53);
const _profColor = Color(0xFF81C784);

// ═══════════════════════════════════════════════════════════════
//  CHARACTER SHEET PAGE
// ═══════════════════════════════════════════════════════════════

class CharacterSheetPage extends StatelessWidget {
  const CharacterSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: TopBar(
        title: 'CHARACTER SHEET',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: _textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, _) {
          final player = context.read<GameBloc>().player;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderCard(player: player),
                const SizedBox(height: 12),
                _AbilityScoresGrid(player: player),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _SavingThrowsCard(player: player)),
                    const SizedBox(width: 10),
                    Expanded(flex: 2, child: _SkillsCard(player: player)),
                  ],
                ),
                const SizedBox(height: 12),
                _CombatCard(player: player),
                const SizedBox(height: 12),
                _FeaturesCard(player: player),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  HEADER CARD
// ─────────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character name + level badge
          Row(
            children: [
              Expanded(
                child: Text(
                  player.name,
                  style: GoogleFonts.cinzelDecorative(
                    color: _textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withOpacity(0.6)),
                ),
                child: Text(
                  'Level ${player.level}',
                  style: GoogleFonts.epilogue(
                    color: _textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Class · Race · Background tags
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (player.dndClass != null)
                _Tag(player.dndClass!.displayName, const Color(0xFF1565C0)),
              if (player.dndRace != null)
                _Tag(player.dndRace!.displayName, const Color(0xFF2E7D32)),
              if (player.background != null)
                _Tag(player.background!.displayName, const Color(0xFF6A1B9A)),
            ],
          ),
          const SizedBox(height: 10),
          // Proficiency bonus
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.plus, size: 11, color: _textDim),
              const SizedBox(width: 6),
              Text(
                'Proficiency Bonus: +${player.proficiencyBonus}',
                style: GoogleFonts.epilogue(color: _textDim, fontSize: 12),
              ),
              const SizedBox(width: 20),
              const FaIcon(FontAwesomeIcons.eye, size: 11, color: _textDim),
              const SizedBox(width: 6),
              Text(
                'Passive Perception: ${player.passivePerception}',
                style: GoogleFonts.epilogue(color: _textDim, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: GoogleFonts.epilogue(
          color: color.withOpacity(0.9),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  ABILITY SCORES GRID
// ─────────────────────────────────────────────────────────────

class _AbilityScoresGrid extends StatelessWidget {
  const _AbilityScoresGrid({required this.player});
  final Player player;

  static const _abilities = [
    AbilityType.strength,
    AbilityType.dexterity,
    AbilityType.constitution,
    AbilityType.intelligence,
    AbilityType.wisdom,
    AbilityType.charisma,
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'ABILITY SCORES',
      accentBorder: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _abilities.map((ability) {
          final score = player.abilityScores.getScore(ability);
          final mod = player.abilityScores.getMod(ability);
          final isSaveProf =
              player.dndClass?.data.savingThrowProficiencies.contains(
                ability,
              ) ??
              false;
          return _AbilityBox(
            ability: ability,
            score: score,
            mod: mod,
            isSaveProficient: isSaveProf,
          );
        }).toList(),
      ),
    );
  }
}

class _AbilityBox extends StatelessWidget {
  const _AbilityBox({
    required this.ability,
    required this.score,
    required this.mod,
    required this.isSaveProficient,
  });
  final AbilityType ability;
  final int score;
  final int mod;
  final bool isSaveProficient;

  @override
  Widget build(BuildContext context) {
    final modStr = mod >= 0 ? '+$mod' : '$mod';
    return Column(
      children: [
        // Ability name
        Text(
          ability.shortName,
          style: GoogleFonts.epilogue(
            color: _accent,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        // Score box
        Container(
          width: 54,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: _bgColor,
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Text(
                '$score',
                style: GoogleFonts.epilogue(
                  color: _textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 1,
                color: _border,
                margin: const EdgeInsets.symmetric(horizontal: 4),
              ),
              const SizedBox(height: 2),
              Text(
                modStr,
                style: GoogleFonts.epilogue(
                  color: _textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Save proficiency dot
        const SizedBox(height: 4),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSaveProficient ? _profColor : Colors.transparent,
            border: Border.all(
              color: isSaveProficient ? _profColor : _textDim,
              width: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SAVING THROWS CARD
// ─────────────────────────────────────────────────────────────

class _SavingThrowsCard extends StatelessWidget {
  const _SavingThrowsCard({required this.player});
  final Player player;

  static const _abilities = [
    AbilityType.strength,
    AbilityType.dexterity,
    AbilityType.constitution,
    AbilityType.intelligence,
    AbilityType.wisdom,
    AbilityType.charisma,
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'SAVING THROWS',
      child: Column(
        children: _abilities.map((ab) {
          final bonus = player.savingThrowBonus(ab);
          final isProf =
              player.dndClass?.data.savingThrowProficiencies.contains(ab) ??
              false;
          final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';
          return _ProfRow(isProf: isProf, label: ab.shortName, value: bonusStr);
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SKILLS CARD
// ─────────────────────────────────────────────────────────────

class _SkillsCard extends StatelessWidget {
  const _SkillsCard({required this.player});
  final Player player;

  bool _isProficient(String skillName) {
    return player.skillProficiencies.any(
      (s) => s.toLowerCase() == skillName.toLowerCase(),
    );
  }

  int _skillBonus(AbilityType ability, bool isProf) {
    return player.abilityScores.getMod(ability) +
        (isProf ? player.proficiencyBonus : 0);
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'SKILLS',
      child: Column(
        children: _allSkills.map((skill) {
          final isProf = _isProficient(skill.name);
          final bonus = _skillBonus(skill.ability, isProf);
          final bonusStr = bonus >= 0 ? '+$bonus' : '$bonus';
          return _ProfRow(
            isProf: isProf,
            label: skill.name,
            sublabel: skill.ability.shortName,
            value: bonusStr,
          );
        }).toList(),
      ),
    );
  }
}

class _ProfRow extends StatelessWidget {
  const _ProfRow({
    required this.isProf,
    required this.label,
    required this.value,
    this.sublabel,
  });
  final bool isProf;
  final String label;
  final String value;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isProf ? _profColor : Colors.transparent,
              border: Border.all(
                color: isProf ? _profColor : _textDim,
                width: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.epilogue(
                color: _textPrimary,
                fontSize: 13,
                fontWeight: isProf ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
          if (sublabel != null)
            Text(
              sublabel!,
              style: GoogleFonts.epilogue(
                color: _textDim,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.epilogue(
                color: _textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  COMBAT STATS CARD
// ─────────────────────────────────────────────────────────────

class _CombatCard extends StatelessWidget {
  const _CombatCard({required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    final hitDieFaces = player.dndClass?.data.hitDie ?? 8;
    final initiative = player.dexMod;
    final initiativeStr = initiative >= 0 ? '+$initiative' : '$initiative';
    final speed = player.dndRace?.data.speed ?? 30;

    return _Card(
      title: 'COMBAT',
      accentBorder: true,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _CombatStat(
                  label: 'HP',
                  value: '${player.currentHealth}/${player.effectiveMaxHp}',
                  sublabel: player.maxHealth != player.effectiveMaxHp
                      ? '(max ${player.maxHealth})'
                      : null,
                ),
              ),
              Expanded(
                child: _CombatStat(
                  label: 'ARMOR CLASS',
                  value: '${player.armorClass}',
                ),
              ),
              Expanded(
                child: _CombatStat(label: 'INITIATIVE', value: initiativeStr),
              ),
              Expanded(
                child: _CombatStat(label: 'SPEED', value: '${speed}ft'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CombatStat(
                  label: 'HIT DICE',
                  value:
                      '${player.hitDiceRemaining}/${player.level} d$hitDieFaces',
                  sublabel: 'remaining',
                ),
              ),
              if (player.isSpellcaster) ...[
                Expanded(
                  child: _CombatStat(
                    label: 'SPELL SAVE DC',
                    value: '${player.spellSaveDC}',
                  ),
                ),
                Expanded(
                  child: _CombatStat(
                    label: 'SPELL ATTACK',
                    value: '+${player.spellAttackBonus}',
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CombatStat extends StatelessWidget {
  const _CombatStat({required this.label, required this.value, this.sublabel});
  final String label;
  final String value;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: _bgColor,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.epilogue(
              color: _textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (sublabel != null)
            Text(
              sublabel!,
              textAlign: TextAlign.center,
              style: GoogleFonts.epilogue(color: _textDim, fontSize: 9),
            ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.epilogue(
              color: _accent,
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  FEATURES CARD (exhaustion, inspiration, concentration, death saves)
// ─────────────────────────────────────────────────────────────

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard({required this.player});
  final Player player;

  Color _exhaustionColor(int level) {
    if (level >= 5) return const Color(0xFFD32F2F);
    if (level >= 4) return const Color(0xFFE53935);
    if (level >= 3) return const Color(0xFFFF7043);
    return const Color(0xFFFF8F00);
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'FEATURES & STATUS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exhaustion level bar
          Row(
            children: [
              Text(
                'Exhaustion: ${player.exhaustionLevel}/6',
                style: GoogleFonts.epilogue(
                  color: player.exhaustionLevel > 0
                      ? _exhaustionColor(player.exhaustionLevel)
                      : _textDim,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: List.generate(6, (i) {
                    final filled = i < player.exhaustionLevel;
                    return Expanded(
                      child: Container(
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: filled ? _exhaustionColor(i + 1) : _bgColor,
                          border: Border.all(
                            color: filled
                                ? _exhaustionColor(i + 1)
                                : _textDim.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Inspiration
          Row(
            children: [
              Icon(
                player.hasInspiration ? Icons.star : Icons.star_border,
                color: player.hasInspiration ? Colors.amber : _textDim,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                player.hasInspiration ? 'Inspired' : 'No Inspiration',
                style: GoogleFonts.epilogue(
                  color: player.hasInspiration ? Colors.amber : _textDim,
                  fontSize: 12,
                  fontWeight: player.hasInspiration
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
            ],
          ),

          // Concentration
          if (player.concentratingOnSpell != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('⚡', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                Text(
                  'Concentrating: ${player.concentratingOnSpell}',
                  style: GoogleFonts.epilogue(
                    color: const Color(0xFFFFCC80),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          // Death saves (read-only)
          if (player.isDying ||
              player.isStable ||
              player.deathSaveSuccesses > 0 ||
              player.deathSaveFailures > 0) ...[
            const SizedBox(height: 12),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 10),
            Text(
              'DEATH SAVING THROWS',
              style: GoogleFonts.epilogue(
                color: _accent,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  'Successes: ',
                  style: GoogleFonts.epilogue(color: _textDim, fontSize: 11),
                ),
                ...List.generate(3, (i) {
                  final filled = i < player.deathSaveSuccesses;
                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? const Color(0xFF388E3C)
                          : Colors.transparent,
                      border: Border.all(
                        color: filled
                            ? const Color(0xFF66BB6A)
                            : Colors.white24,
                        width: 1.2,
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 16),
                Text(
                  'Failures: ',
                  style: GoogleFonts.epilogue(color: _textDim, fontSize: 11),
                ),
                ...List.generate(3, (i) {
                  final filled = i < player.deathSaveFailures;
                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? const Color(0xFFD32F2F)
                          : Colors.transparent,
                      border: Border.all(
                        color: filled
                            ? const Color(0xFFEF5350)
                            : Colors.white24,
                        width: 1.2,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],

          // Active conditions
          if (player.conditions.isNotEmpty || player.exhaustionLevel > 0) ...[
            const SizedBox(height: 12),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 8),
            Text(
              'CONDITIONS',
              style: GoogleFonts.epilogue(
                color: _accent,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: player.conditions
                  .map(
                    (c) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      child: Text(
                        c.label,
                        style: GoogleFonts.epilogue(
                          color: _textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          // Skill proficiencies list
          if (player.skillProficiencies.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 8),
            Text(
              'SKILL PROFICIENCIES',
              style: GoogleFonts.epilogue(
                color: _accent,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: player.skillProficiencies
                  .map(
                    (s) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _profColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _profColor.withOpacity(0.4)),
                      ),
                      child: Text(
                        s,
                        style: GoogleFonts.epilogue(
                          color: _profColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  SHARED CARD WIDGET
// ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child, this.title, this.accentBorder = false});
  final Widget child;
  final String? title;
  final bool accentBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(8),
        border: accentBorder
            ? Border(
                left: const BorderSide(color: Color(0xFFBD8C4C), width: 4),
                top: BorderSide(color: _border),
                right: BorderSide(color: _border),
                bottom: BorderSide(color: _border),
              )
            : Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: GoogleFonts.epilogue(
                color: _accent,
                fontSize: 12,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }
}
