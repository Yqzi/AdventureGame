import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/top_bar.dart';

class QuestCreationPage extends StatelessWidget {
  const QuestCreationPage({super.key});

  final List quests = const [
    {
      'title': 'Forest',
      'risk': 'Urgent Request',
      'description': 'Explore the forest.',
      'reward': '??',
      'image': 'assets/images/forest.png',
    },
    {
      'title': 'Cave',
      'risk': 'Urgent Request',
      'description': 'Explore the cave.',
      'reward': '??',
      'image': 'assets/images/cave.png',
    },
    {
      'title': 'Ruins',
      'risk': 'Urgent Request',
      'description': 'Explore the ruins.',
      'reward': '??',
      'image': 'assets/images/ruins.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      appBar: TopBar(
        title: 'Explore',
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
                "Open Worlds",
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
                  itemCount: quests.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final quest = quests[index];
                    return SimpleQuestCard(
                      title: quest['title'],
                      description: quest['description'],
                      reward: quest['reward'],
                      onActionPressed: () {},
                      image: quest['image'],
                    );
                  },
                ),
              ),
            ),
            CustomBottomBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}
