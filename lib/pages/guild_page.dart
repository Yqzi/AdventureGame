import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/experience_bar.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/top_bar.dart';
import 'package:tes/models/quest.dart';
import 'package:tes/router.dart';

class GuildPage extends StatelessWidget {
  const GuildPage({super.key});

  void _showQuestDetail(BuildContext context, Quest quest) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => GestureDetector(
        onTap: () => Navigator.of(ctx).pop(),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // absorb taps on the card itself
            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFE3D5B8),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Image ──
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      child: Image.asset(
                        'assets/images/${quest.location.toLowerCase()}.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Title ──
                          Text(
                            quest.title,
                            style: GoogleFonts.epilogue(
                              color: const Color(0xFF3E2723),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // ── Difficulty + Location row ──
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3E2723),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  quest.difficulty.label.toUpperCase(),
                                  style: GoogleFonts.epilogue(
                                    color: const Color(0xFFE3D5B8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5D4037),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 12,
                                      color: Color(0xFFE3D5B8),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      quest.location,
                                      style: GoogleFonts.epilogue(
                                        color: const Color(0xFFE3D5B8),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'LV ${quest.recommendedLevel}',
                                style: GoogleFonts.epilogue(
                                  color: const Color(0xFF8D6E63),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ── Description ──
                          Text(
                            '"${quest.description}"',
                            style: GoogleFonts.epilogue(
                              color: const Color(0xFF5D4037),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ── Objective ──
                          _detailRow('OBJECTIVE', quest.objective),
                          const SizedBox(height: 10),

                          // ── Key NPCs ──
                          if (quest.keyNPCs.isNotEmpty) ...[
                            _detailRow('KEY FIGURES', quest.keyNPCs.join(', ')),
                            const SizedBox(height: 10),
                          ],

                          // ── Divider ──
                          DottedBorder(
                            options: RectDottedBorderOptions(
                              color: const Color(0xFFA1887F),
                              padding: EdgeInsets.zero,
                              dashPattern: const [3, 3],
                            ),
                            child: Container(height: 0),
                          ),
                          const SizedBox(height: 12),

                          // ── Reward + Accept button ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'REWARD',
                                    style: GoogleFonts.epilogue(
                                      color: const Color(0xFF8D6E63),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    quest.rewardLabel,
                                    style: GoogleFonts.epilogue(
                                      color: const Color(0xFFBD0F2C),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3E2723),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.game,
                                    arguments: {
                                      'details': quest.toQuestDetails(),
                                    },
                                  );
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.scroll,
                                  size: 14,
                                  color: Color(0xFFE3D5B8),
                                ),
                                label: Text(
                                  "Accept Quest",
                                  style: GoogleFonts.epilogue(
                                    color: const Color(0xFFE3D5B8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.epilogue(
            color: const Color(0xFF8D6E63),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.epilogue(
            color: const Color(0xFF3E2723),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = context.read<GameBloc>().player;
    final quests = Quest.dailyQuests(playerLevel: player.level, count: 4)
      ..add(
        const Quest(
          id: 'f_1201',
          title: 'test',
          description: 'enter and say my name is zac',
          objective: 'enter and say my name is zac',
          aiObjective:
              'when the user enters whenever he says the exact words, I am Zac, the quest is complete',
          location: 'Forest',
          difficulty: QuestDifficulty.routine,
          goldReward: 80,
          xpReward: 40,
          recommendedLevel: 1,
          keyNPCs: ['Elder Rela'],
        ),
      );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      appBar: TopBar(
        title: 'The Notice Board',
        desc: 'Daily',
        textStyle: GoogleFonts.epilogue(
          color: const Color(0xFFE3D5B8),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.25,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: const Color(0xFFE3D5B8),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.hourglass_top_rounded),
            color: const Color(0xFFE3D5B8),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
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
            const SizedBox(height: 10),
            ExperienceBar(player: player),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Open Bounties",
                style: GoogleFonts.epilogue(
                  color: const Color(0xFFE3D5B8),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Color.fromRGBO(0, 0, 0, 0.8),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: quests.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index < quests.length) {
                    final quest = quests[index];
                    return GestureDetector(
                      onTap: () => _showQuestDetail(context, quest),
                      child: PinnedCard(
                        title: quest.title,
                        risk: quest.difficulty.label,
                        description: quest.description,
                        reward: quest.rewardLabel,
                        transformationAngle: index % 2 != 0 ? -0.02 : 0.02,
                        image:
                            'assets/images/${quest.location.toLowerCase()}.png',
                        onActionPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.game,
                            arguments: {'details': quest.toQuestDetails()},
                          );
                        },
                      ),
                    );
                  }

                  // Footer: scribe notice
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.pen,
                            color: Colors.white38,
                            size: 18,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Daily bounties refreshed at dawn...",
                            style: GoogleFonts.epilogue(
                              color: Colors.white38,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CustomBottomBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}
