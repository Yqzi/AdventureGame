import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/blocs/app/app_bloc.dart';
import 'package:Questborne/blocs/app/app_event.dart';
import 'package:Questborne/colors.dart';
import 'package:Questborne/models/ability_scores.dart';
import 'package:Questborne/models/background.dart';
import 'package:Questborne/models/character_class.dart';
import 'package:Questborne/models/character_race.dart';
import 'package:Questborne/router.dart';

class CharacterCreationPage extends StatefulWidget {
  const CharacterCreationPage({super.key});

  @override
  State<CharacterCreationPage> createState() => _CharacterCreationPageState();
}

class _CharacterCreationPageState extends State<CharacterCreationPage> {
  int _step =
      0; // 0=race, 1=class, 2=background, 3=abilities, 4=skills, 5=review

  DndRace? _selectedRace;
  DndClass? _selectedClass;
  DndBackground? _selectedBackground;

  // Standard array values to assign — each index corresponds to AbilityType order.
  static const List<int> _standardArray = [15, 14, 13, 12, 10, 8];
  // Assignment: abilityIndex → standardArrayIndex (null = unassigned)
  final Map<int, int?> _abilityAssignment = {
    0: null,
    1: null,
    2: null,
    3: null,
    4: null,
    5: null,
  };

  List<String> _selectedSkills = [];
  // Half-Elf: player picks any two non-CHA ability scores to gain +1
  final Set<AbilityType> _halfElfChoices = {};

  static const List<AbilityType> _abilityOrder = [
    AbilityType.strength,
    AbilityType.dexterity,
    AbilityType.constitution,
    AbilityType.intelligence,
    AbilityType.wisdom,
    AbilityType.charisma,
  ];

  static const List<String> _abilityLabels = [
    'STR',
    'DEX',
    'CON',
    'INT',
    'WIS',
    'CHA',
  ];

  static const List<String> _abilityNames = [
    'Strength',
    'Dexterity',
    'Constitution',
    'Intelligence',
    'Wisdom',
    'Charisma',
  ];

  AbilityScores get _computedAbilityScores {
    final raceBonuses = Map<AbilityType, int>.from(
      _selectedRace?.data.abilityBonuses ?? {},
    );
    // Half-Elf: merge the two player-chosen +1 bonuses
    if (_selectedRace == DndRace.halfElf) {
      for (final ab in _halfElfChoices) {
        raceBonuses[ab] = (raceBonuses[ab] ?? 0) + 1;
      }
    }
    final Map<AbilityType, int> base = {};
    for (int i = 0; i < 6; i++) {
      final assigned = _abilityAssignment[i];
      final baseVal = assigned != null ? _standardArray[assigned] : 8;
      final ability = _abilityOrder[i];
      base[ability] = baseVal + (raceBonuses[ability] ?? 0);
    }
    return AbilityScores(
      strength: base[AbilityType.strength] ?? 8,
      dexterity: base[AbilityType.dexterity] ?? 8,
      constitution: base[AbilityType.constitution] ?? 8,
      intelligence: base[AbilityType.intelligence] ?? 8,
      wisdom: base[AbilityType.wisdom] ?? 8,
      charisma: base[AbilityType.charisma] ?? 8,
    );
  }

  bool get _allAbilitiesAssigned =>
      _abilityAssignment.values.every((v) => v != null) &&
      _abilityAssignment.values.toSet().length == 6;

  List<String> get _availableSkillChoices => _classSkills[_selectedClass] ?? [];

  int get _requiredSkillCount => _selectedClass?.data.skillChoices ?? 2;

  // Skill lists per class (D&D 5e Basic Rules).
  static const Map<DndClass, List<String>> _classSkills = {
    DndClass.barbarian: [
      'Animal Handling',
      'Athletics',
      'Intimidation',
      'Nature',
      'Perception',
      'Survival',
    ],
    DndClass.bard: [
      'Acrobatics',
      'Animal Handling',
      'Arcana',
      'Athletics',
      'Deception',
      'History',
      'Insight',
      'Intimidation',
      'Investigation',
      'Medicine',
      'Nature',
      'Perception',
      'Performance',
      'Persuasion',
      'Religion',
      'Sleight of Hand',
      'Stealth',
    ],
    DndClass.cleric: [
      'History',
      'Insight',
      'Medicine',
      'Persuasion',
      'Religion',
    ],
    DndClass.druid: [
      'Arcana',
      'Animal Handling',
      'Insight',
      'Medicine',
      'Nature',
      'Perception',
      'Religion',
      'Survival',
    ],
    DndClass.fighter: [
      'Acrobatics',
      'Animal Handling',
      'Athletics',
      'History',
      'Insight',
      'Intimidation',
      'Perception',
      'Survival',
    ],
    DndClass.monk: [
      'Acrobatics',
      'Athletics',
      'History',
      'Insight',
      'Religion',
      'Stealth',
    ],
    DndClass.paladin: [
      'Athletics',
      'Insight',
      'Intimidation',
      'Medicine',
      'Persuasion',
      'Religion',
    ],
    DndClass.ranger: [
      'Animal Handling',
      'Athletics',
      'Insight',
      'Investigation',
      'Nature',
      'Perception',
      'Stealth',
      'Survival',
    ],
    DndClass.rogue: [
      'Acrobatics',
      'Athletics',
      'Deception',
      'Insight',
      'Intimidation',
      'Investigation',
      'Perception',
      'Performance',
      'Persuasion',
      'Sleight of Hand',
      'Stealth',
    ],
    DndClass.sorcerer: [
      'Arcana',
      'Deception',
      'Insight',
      'Intimidation',
      'Persuasion',
      'Religion',
    ],
    DndClass.warlock: [
      'Arcana',
      'Deception',
      'History',
      'Intimidation',
      'Investigation',
      'Nature',
      'Religion',
    ],
    DndClass.wizard: [
      'Arcana',
      'History',
      'Insight',
      'Investigation',
      'Medicine',
      'Religion',
    ],
  };

  bool get _canProceedFromCurrentStep {
    switch (_step) {
      case 0:
        return _selectedRace != null &&
            (_selectedRace != DndRace.halfElf || _halfElfChoices.length == 2);
      case 1:
        return _selectedClass != null;
      case 2:
        return _selectedBackground != null;
      case 3:
        return _allAbilitiesAssigned;
      case 4:
        return _selectedSkills.length == _requiredSkillCount;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(child: _buildCurrentStep()),
            _buildNavButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    const stepTitles = [
      'Choose Your Race',
      'Choose Your Class',
      'Choose Your Background',
      'Assign Ability Scores',
      'Choose Skills',
      'Review Character',
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        children: [
          Text(
            'Create Your Character',
            style: GoogleFonts.cinzelDecorative(
              color: const Color(0xFFE3D5B8),
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stepTitles[_step],
            style: GoogleFonts.cinzel(
              color: const Color(0xFFBD8C4C),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: List.generate(6, (i) {
          final active = i == _step;
          final done = i < _step;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: done
                    ? const Color(0xFFBD8C4C)
                    : active
                    ? const Color(0xFFE3D5B8)
                    : const Color(0xFF2A2017),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return _buildRaceStep();
      case 1:
        return _buildClassStep();
      case 2:
        return _buildBackgroundStep();
      case 3:
        return _buildAbilityStep();
      case 4:
        return _buildSkillStep();
      case 5:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  // ── Race Step ──────────────────────────────────────────────────────────────

  Widget _buildRaceStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...DndRace.values.map((race) {
          final data = race.data;
          final selected = _selectedRace == race;
          final bonusText = race == DndRace.halfElf
              ? '${_formatBonuses(data.abilityBonuses)}, +1 to any two other ability scores (your choice)'
              : _formatBonuses(data.abilityBonuses);
          return _buildOptionCard(
            title: race.displayName,
            subtitle: data.description,
            detail:
                bonusText +
                (data.traits.isNotEmpty
                    ? '\nTraits: ${data.traits.join(", ")}'
                    : ''),
            selected: selected,
            onTap: () => setState(() {
              _selectedRace = race;
              _halfElfChoices.clear();
            }),
          );
        }),
        if (_selectedRace == DndRace.halfElf) _buildHalfElfChoicePicker(),
      ],
    );
  }

  Widget _buildHalfElfChoicePicker() {
    // All abilities except CHA (which already gets +2)
    const choices = [
      AbilityType.strength,
      AbilityType.dexterity,
      AbilityType.constitution,
      AbilityType.intelligence,
      AbilityType.wisdom,
    ];
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111A10),
        border: Border.all(color: const Color(0xFF5A8A4C)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Half-Elf Trait: +1 to Two Ability Scores',
            style: GoogleFonts.cinzel(
              color: const Color(0xFF8ACA6C),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose any two ability scores (other than Charisma) to increase by +1.',
            style: GoogleFonts.lato(
              color: const Color(0xFF6A8A5A),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${_halfElfChoices.length}/2 selected',
            style: GoogleFonts.lato(
              color: _halfElfChoices.length == 2
                  ? const Color(0xFF5A8A4C)
                  : const Color(0xFF7A6A5A),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: choices.map((ab) {
              final selected = _halfElfChoices.contains(ab);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      _halfElfChoices.remove(ab);
                    } else if (_halfElfChoices.length < 2) {
                      _halfElfChoices.add(ab);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF2A2017)
                        : const Color(0xFF150F0C),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFFBD8C4C)
                          : const Color(0xFF3A3020),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _abilityLabels[_abilityOrder.indexOf(ab)],
                    style: GoogleFonts.cinzel(
                      color: selected
                          ? const Color(0xFFE3D5B8)
                          : const Color(0xFF7A6A5A),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _formatBonuses(Map<AbilityType, int> bonuses) {
    if (bonuses.isEmpty) return '';
    return bonuses.entries
        .map(
          (e) =>
              '${_abilityLabels[_abilityOrder.indexOf(e.key)]} ${e.value > 0 ? "+" : ""}${e.value}',
        )
        .join(', ');
  }

  // ── Class Step ────────────────────────────────────────────────────────────

  Widget _buildClassStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: DndClass.values.map((cls) {
        final data = cls.data;
        final selected = _selectedClass == cls;
        final spellNote = data.isSpellcaster
            ? '  ·  Spellcasting: ${data.spellcastingAbility?.name.toUpperCase() ?? ""}'
            : '';
        return _buildOptionCard(
          title: cls.displayName,
          subtitle: 'Hit Die: d${data.hitDie}$spellNote',
          detail: data.keyFeatures,
          selected: selected,
          onTap: () => setState(() {
            _selectedClass = cls;
            _selectedSkills = [];
          }),
        );
      }).toList(),
    );
  }

  // ── Background Step ───────────────────────────────────────────────────────

  Widget _buildBackgroundStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: DndBackground.values.map((bg) {
        final data = bg.data;
        final selected = _selectedBackground == bg;
        return _buildOptionCard(
          title: bg.displayName,
          subtitle: data.description,
          detail:
              'Skills: ${data.skillProficiencies.join(", ")}\n${data.featureName}: ${data.featureDescription}',
          selected: selected,
          onTap: () => setState(() => _selectedBackground = bg),
        );
      }).toList(),
    );
  }

  // ── Ability Score Step ────────────────────────────────────────────────────

  Widget _buildAbilityStep() {
    final raceBonuses = _selectedRace?.data.abilityBonuses ?? {};
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assign the standard array [${_standardArray.join(", ")}] to your ability scores. '
            'Drag a value onto a score, or tap to cycle.',
            style: GoogleFonts.lato(
              color: const Color(0xFFB0A090),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // Available values
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(6, (arrIdx) {
              final isUsed = _abilityAssignment.values.contains(arrIdx);
              return _buildArrayChip(arrIdx, isUsed);
            }),
          ),
          const SizedBox(height: 20),
          // Ability rows
          ...List.generate(6, (abilIdx) {
            final ability = _abilityOrder[abilIdx];
            final assignedArrIdx = _abilityAssignment[abilIdx];
            final baseVal = assignedArrIdx != null
                ? _standardArray[assignedArrIdx]
                : null;
            final raceBon = raceBonuses[ability] ?? 0;
            final total = (baseVal ?? 0) + raceBon;
            final mod = AbilityScores.modifier(total);
            return _buildAbilityRow(
              abilIdx: abilIdx,
              assignedArrIdx: assignedArrIdx,
              baseVal: baseVal,
              raceBon: raceBon,
              total: baseVal != null ? total : null,
              mod: baseVal != null ? mod : null,
            );
          }),
          const SizedBox(height: 12),
          if (_selectedClass != null) ...[
            Text(
              'Primary abilities for ${_selectedClass!.displayName}: '
              '${_selectedClass!.data.primaryAbilities.map((a) => a.name.toUpperCase()).join(", ")}',
              style: GoogleFonts.lato(
                color: const Color(0xFFBD8C4C),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArrayChip(int arrIdx, bool isUsed) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        // Dragging an ability row's assigned value back to pool — unassign it
        setState(() {
          final abilIdx = details.data;
          _abilityAssignment[abilIdx] = null;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<int>(
          data: arrIdx, // dragging the array index
          feedback: Material(
            color: Colors.transparent,
            child: _arrayValueWidget(
              _standardArray[arrIdx],
              isUsed,
              dragging: true,
            ),
          ),
          childWhenDragging: _arrayValueWidget(_standardArray[arrIdx], true),
          child: GestureDetector(
            onTap: isUsed
                ? null
                : () {
                    // Assign to first unassigned ability
                    for (int i = 0; i < 6; i++) {
                      if (_abilityAssignment[i] == null) {
                        setState(() => _abilityAssignment[i] = arrIdx);
                        break;
                      }
                    }
                  },
            child: _arrayValueWidget(_standardArray[arrIdx], isUsed),
          ),
        );
      },
    );
  }

  Widget _arrayValueWidget(int value, bool used, {bool dragging = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: used
            ? const Color(0xFF1A1410)
            : dragging
            ? const Color(0xFFBD8C4C)
            : const Color(0xFF2A2017),
        border: Border.all(
          color: used ? const Color(0xFF3A3020) : const Color(0xFFBD8C4C),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$value',
          style: GoogleFonts.cinzel(
            color: used ? const Color(0xFF4A3828) : const Color(0xFFE3D5B8),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAbilityRow({
    required int abilIdx,
    required int? assignedArrIdx,
    required int? baseVal,
    required int raceBon,
    required int? total,
    required int? mod,
  }) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        final arrIdx = details.data;
        // Remove this arrIdx from whoever had it before
        setState(() {
          for (int i = 0; i < 6; i++) {
            if (_abilityAssignment[i] == arrIdx) {
              _abilityAssignment[i] = null;
            }
          }
          _abilityAssignment[abilIdx] = arrIdx;
        });
      },
      builder: (context, candidateData, rejectedData) {
        final isOver = candidateData.isNotEmpty;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isOver ? const Color(0xFF2A2017) : const Color(0xFF150F0C),
            border: Border.all(
              color: isOver
                  ? const Color(0xFFBD8C4C)
                  : assignedArrIdx != null
                  ? const Color(0xFF4A3828)
                  : const Color(0xFF2A2017),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Text(
                  _abilityLabels[abilIdx],
                  style: GoogleFonts.cinzel(
                    color: const Color(0xFFBD8C4C),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _abilityNames[abilIdx],
                  style: GoogleFonts.lato(
                    color: const Color(0xFF7A6A5A),
                    fontSize: 12,
                  ),
                ),
              ),
              if (raceBon != 0)
                Text(
                  '${raceBon > 0 ? "+" : ""}$raceBon race',
                  style: GoogleFonts.lato(
                    color: const Color(0xFF5A8A4C),
                    fontSize: 11,
                  ),
                ),
              const SizedBox(width: 8),
              if (assignedArrIdx != null)
                Draggable<int>(
                  data: abilIdx, // dragging the ability index back to pool
                  feedback: Material(
                    color: Colors.transparent,
                    child: _assignedValueWidget(total!, mod!),
                  ),
                  onDragCompleted: () =>
                      setState(() => _abilityAssignment[abilIdx] = null),
                  child: _assignedValueWidget(total!, mod),
                )
              else
                Container(
                  width: 52,
                  height: 36,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF3A3020),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '—',
                      style: GoogleFonts.lato(color: const Color(0xFF3A3020)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _assignedValueWidget(int total, int mod) {
    return Container(
      width: 52,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF2A1E14),
        border: Border.all(color: const Color(0xFFBD8C4C), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$total',
            style: GoogleFonts.cinzel(
              color: const Color(0xFFE3D5B8),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          Text(
            AbilityScores.formatMod(mod),
            style: GoogleFonts.lato(
              color: mod >= 0 ? const Color(0xFF5A8A4C) : redText,
              fontSize: 10,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  // ── Skill Step ────────────────────────────────────────────────────────────

  Widget _buildSkillStep() {
    final bgSkills = _selectedBackground?.data.skillProficiencies ?? [];
    final classSkills = _availableSkillChoices;
    final needed = _requiredSkillCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (bgSkills.isNotEmpty) ...[
            Text(
              'From Background (${_selectedBackground?.displayName}):',
              style: GoogleFonts.cinzel(
                color: const Color(0xFFBD8C4C),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: bgSkills
                  .map((s) => _buildSkillChip(s, fixed: true))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
          Text(
            'From ${_selectedClass?.displayName} (choose $needed):',
            style: GoogleFonts.cinzel(
              color: const Color(0xFFBD8C4C),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_selectedSkills.length}/$needed selected',
            style: GoogleFonts.lato(
              color: _selectedSkills.length == needed
                  ? const Color(0xFF5A8A4C)
                  : const Color(0xFF7A6A5A),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: classSkills.map((s) {
              final selected = _selectedSkills.contains(s);
              final alreadyFromBg = bgSkills.contains(s);
              return _buildSkillChip(
                s,
                selectable: !alreadyFromBg,
                selected: selected,
                onTap: alreadyFromBg
                    ? null
                    : () {
                        setState(() {
                          if (selected) {
                            _selectedSkills.remove(s);
                          } else if (_selectedSkills.length < needed) {
                            _selectedSkills.add(s);
                          }
                        });
                      },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(
    String skill, {
    bool fixed = false,
    bool selectable = true,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: fixed
              ? const Color(0xFF1E2A18)
              : selected
              ? const Color(0xFF2A2017)
              : const Color(0xFF150F0C),
          border: Border.all(
            color: fixed
                ? const Color(0xFF5A8A4C)
                : selected
                ? const Color(0xFFBD8C4C)
                : const Color(0xFF3A3020),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          skill,
          style: GoogleFonts.lato(
            color: fixed
                ? const Color(0xFF8ACA6C)
                : selected
                ? const Color(0xFFE3D5B8)
                : const Color(0xFF7A6A5A),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ── Review Step ───────────────────────────────────────────────────────────

  Widget _buildReviewStep() {
    final scores = _computedAbilityScores;
    final bgSkills = _selectedBackground?.data.skillProficiencies ?? [];
    final allSkills = [...bgSkills, ..._selectedSkills].toSet().toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _reviewRow('Race', _selectedRace?.displayName ?? ''),
          if (_selectedRace == DndRace.halfElf && _halfElfChoices.length == 2)
            _reviewRow(
              'Half-Elf +1',
              _halfElfChoices
                  .map((a) => _abilityLabels[_abilityOrder.indexOf(a)])
                  .join(', '),
            ),
          _reviewRow('Class', _selectedClass?.displayName ?? ''),
          _reviewRow('Background', _selectedBackground?.displayName ?? ''),
          const Divider(color: Color(0xFF3A3020), height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(6, (i) {
              final ability = _abilityOrder[i];
              final score = scores.getScore(ability);
              final mod = scores.getMod(ability);
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      _abilityLabels[i],
                      style: GoogleFonts.cinzel(
                        color: const Color(0xFFBD8C4C),
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      '$score',
                      style: GoogleFonts.cinzelDecorative(
                        color: const Color(0xFFE3D5B8),
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      AbilityScores.formatMod(mod),
                      style: GoogleFonts.lato(
                        color: mod >= 0 ? const Color(0xFF5A8A4C) : redText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const Divider(color: Color(0xFF3A3020), height: 24),
          if (allSkills.isNotEmpty) _reviewRow('Skills', allSkills.join(', ')),
          if (_selectedClass != null) ...[
            _reviewRow('Hit Die', 'd${_selectedClass!.data.hitDie}'),
            _reviewRow(
              'Saving Throws',
              _selectedClass!.data.savingThrowProficiencies
                  .map((a) => a.name.toUpperCase())
                  .join(', '),
            ),
            if (_selectedClass!.data.isSpellcaster)
              _reviewRow(
                'Spellcasting',
                _selectedClass!.data.spellcastingAbility!.name.toUpperCase(),
              ),
          ],
          const SizedBox(height: 24),
          Text(
            'Ready to begin your adventure?',
            style: GoogleFonts.cinzel(
              color: const Color(0xFFE3D5B8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.cinzel(
                color: const Color(0xFFBD8C4C),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(
                color: const Color(0xFFE3D5B8),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared option card ────────────────────────────────────────────────────

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required String detail,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2A1E14) : const Color(0xFF150F0C),
          border: Border.all(
            color: selected ? const Color(0xFFBD8C4C) : const Color(0xFF2A2017),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.cinzel(
                      color: selected
                          ? const Color(0xFFE3D5B8)
                          : const Color(0xFFAA9A8A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFFBD8C4C),
                    size: 18,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                color: const Color(0xFF8A7A6A),
                fontSize: 12,
              ),
            ),
            if (detail.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                detail,
                style: GoogleFonts.lato(
                  color: const Color(0xFF6A5A4A),
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Widget _buildNavButtons() {
    final isLast = _step == 5;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _step--),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4A3828)),
                  foregroundColor: const Color(0xFFAA9A8A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Back', style: GoogleFonts.cinzel(fontSize: 13)),
              ),
            ),
          if (_step > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _canProceedFromCurrentStep
                  ? () {
                      if (isLast) {
                        _submitCharacter();
                      } else {
                        setState(() => _step++);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBD8C4C),
                disabledBackgroundColor: const Color(0xFF2A2017),
                foregroundColor: const Color(0xFF0D0A09),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isLast ? 'Begin Adventure' : 'Continue',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitCharacter() {
    final bgSkills = _selectedBackground?.data.skillProficiencies ?? [];
    final allSkills = [...bgSkills, ..._selectedSkills].toSet().toList();

    context.read<GameBloc>().add(
      CompleteCharacterCreationEvent(
        dndClass: _selectedClass!,
        dndRace: _selectedRace!,
        background: _selectedBackground!,
        abilityScores: _computedAbilityScores,
        skillProficiencies: allSkills,
      ),
    );

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRouter.guild, (route) => false);
  }
}
