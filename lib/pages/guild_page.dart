import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/top_bar.dart';

class GuildPage extends StatelessWidget {
  const GuildPage({super.key});

  final List quests = const [
    {
      'title': 'Goblin Menace',
      'risk': 'Urgent Request',
      'description':
          'Goblins have been spotted near the village. Eliminate the threat.',
      'reward': '100 Gold',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDpJTdLOrUxSMzAephPD1LZlWHsbD17xR0_z7wUN3oDdBs6zyKRC9cjhr5Z092UrNkV_VE0iJAJURZ3m5arjx8OjmVZ1KnMniu78qCPaF_VLFhXwkfxKX4hy5FisK05To6poVEe0K5hSxdKMyajfbXqIXJvnpRcemiYJ3TV77ByyDOYmvcovRxVnPM4zm7qBfNtPV_W_LcMUleRsxnHEuhuD8MaznceL42miZsuT56OJzSWI4eKUJdkbmVqGFaoS3xnPfAnqoeVaZI',
    },
    {
      'title': 'Goblin Menace',
      'risk': 'Urgent Request',
      'description':
          'Goblins have been spotted near the village. Eliminate the threat.',
      'reward': '100 Gold',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDpJTdLOrUxSMzAephPD1LZlWHsbD17xR0_z7wUN3oDdBs6zyKRC9cjhr5Z092UrNkV_VE0iJAJURZ3m5arjx8OjmVZ1KnMniu78qCPaF_VLFhXwkfxKX4hy5FisK05To6poVEe0K5hSxdKMyajfbXqIXJvnpRcemiYJ3TV77ByyDOYmvcovRxVnPM4zm7qBfNtPV_W_LcMUleRsxnHEuhuD8MaznceL42miZsuT56OJzSWI4eKUJdkbmVqGFaoS3xnPfAnqoeVaZI',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      appBar: TopBar(
        title: 'GUILD QUEST BOARD',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "AVAILABLE NOTICES",
                style: GoogleFonts.epilogue(
                  color: const Color.fromARGB(200, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 2,
                width: 45,
                color: orangeText,
                margin: const EdgeInsets.only(bottom: 16),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  itemCount: quests.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index < quests.length) {
                      final quest = quests[index];
                      return QuestCardModel(
                        title: quest['title'],
                        risk: quest['risk'],
                        description: quest['description'],
                        reward: quest['reward'],
                        onActionPressed: () {},
                        image: quest['image'],
                      );
                    } else {
                      // Last item: show the scribe notice
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
                                "More notices being pinned by the scribe...",
                                style: GoogleFonts.epilogue(
                                  color: Colors.white38,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            CustomBottomBar(currentIndex: 2, onTap: (int index) {}),
          ],
        ),
      ),
    );
  }
}
