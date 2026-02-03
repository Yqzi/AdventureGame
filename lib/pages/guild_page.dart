import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/top_bar.dart';

class GuildPage extends StatelessWidget {
  const GuildPage({super.key});

  final List quests = const [
    {
      'title': 'Goblin Menace',
      'subtitle': 'Urgent Request',
      'description':
          'Goblins have been spotted near the village. Eliminate the threat.',
      'underline': 'Reward: 100 Gold',
      'actionText': 'Accept',
      'footerText': 'Expires in 2 days',
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
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AVAILABLE NOTICES",
              style: GoogleFonts.epilogue(
                color: const Color.fromARGB(200, 255, 255, 255),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 45,
              color: orangeText,
              margin: const EdgeInsets.only(bottom: 16),
            ),
            SizedBox(height: 4),
            Expanded(
              child: ListView.separated(
                itemCount: quests.length,
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final quest = quests[index];
                  return QuestCardModel(
                    title: quest['title'],
                    subtitle: quest['subtitle'],
                    description: quest['description'],
                    underline: quest['underline'],
                    actionText: quest['actionText'],
                    onActionPressed: () {},
                    footerText: quest['footerText'],
                    image: quest['image'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
