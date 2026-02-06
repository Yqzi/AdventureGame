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
        title: 'The Notice Board',
        textStyle: GoogleFonts.epilogue(
          color: const Color(0xFFE3D5B8), // #e3d5b8
          fontSize: 20, // text-xl ≈ 20px
          fontWeight: FontWeight.bold, // font-bold
          height: 1.25,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: const Color(0xFFE3D5B8),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Open Bounties",
                style: GoogleFonts.epilogue(
                  color: const Color(0xFFE3D5B8), // text-[#e3d5b8]
                  fontSize: 22, // text-2xl ≈ 24px
                  fontWeight: FontWeight.bold, // font-bold
                  height: 1.25, // leading-tight
                  letterSpacing: 1.2, // tracking-wide (adjust as needed)
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2), // x=2, y=2
                      blurRadius: 4, // blur radius
                      color: Color.fromRGBO(0, 0, 0, 0.8), // rgba(0,0,0,0.8)
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: ListView.separated(
                  itemCount: quests.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index < quests.length) {
                      final quest = quests[index];
                      return PinnedCard(
                        title: quest['title'],
                        risk: quest['risk'],
                        description: quest['description'],
                        reward: quest['reward'],
                        transformationAngle: index % 2 != 0 ? -0.02 : 0.02,
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
            CustomBottomBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}
