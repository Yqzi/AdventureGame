import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';

class CardModel extends StatelessWidget {
  final String rarity;
  final String title;
  final String description;
  final String cost;
  final ImageProvider? image;

  const CardModel({
    required this.rarity,
    required this.title,
    required this.description,
    required this.cost,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderGrey, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      height: MediaQuery.of(context).size.height / 4.5,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rarity,
                  style: GoogleFonts.epilogue(fontWeight: FontWeight.bold),
                ),
                Text(title, style: GoogleFonts.epilogue()),
                Text(description, style: GoogleFonts.epilogue()),
                Text(cost, style: GoogleFonts.epilogue()),
              ],
            ),
          ),
          // Image(image: image),
        ],
      ),
    );
  }
}

class QuestCardModel extends StatelessWidget {
  final String title;
  final String risk;
  final String description;
  final String reward;
  final VoidCallback onActionPressed;
  final String image;

  const QuestCardModel({
    required this.title,
    required this.risk,
    required this.description,
    required this.reward,
    required this.onActionPressed,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height / 3;
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color.fromARGB(255, 39, 30, 28),
        border: Border.all(color: Color.fromARGB(255, 51, 39, 37)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Image with fade
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: cardHeight,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: cardHeight / 3,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(image, fit: BoxFit.cover),
                        // Fog overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color.fromARGB(
                                  255,
                                  39,
                                  30,
                                  28,
                                ).withAlpha((0.28 * 255).toInt()),
                                const Color.fromARGB(
                                  255,
                                  39,
                                  30,
                                  28,
                                ).withAlpha((0.35 * 255).toInt()),
                                const Color.fromARGB(
                                  255,
                                  39,
                                  30,
                                  28,
                                ).withAlpha((0.20 * 255).toInt()),
                              ],
                              stops: [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color.fromARGB(255, 39, 30, 28),
                              ],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(color: Color.fromARGB(255, 39, 30, 28)),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: cardHeight / 3 - 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        title,
                        style: GoogleFonts.epilogue(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 39, 30, 28),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              // controls the amount that are colored in
                              final color = index < 3
                                  ? orangeText
                                  : orangeText.withOpacity(0.4);
                              return Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: Icon(
                                  FontAwesomeIcons
                                      .skull, // Requires Flutter 3.16+ for Material Icons
                                  color: color,
                                  size: 14,
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 8),
                          Text(
                            risk,
                            style: GoogleFonts.epilogue(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4,
                      ),
                      child: Text(
                        '"$description"',
                        style: GoogleFonts.epilogue(
                          color: greyText,
                          fontSize: 16,
                          letterSpacing: 1,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        height: 1,
                        color: Colors.white38,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "REWARD",
                                    style: GoogleFonts.epilogue(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: greyText,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.coins,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        reward,
                                        style: GoogleFonts.epilogue(
                                          color: Colors.amber,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            ElevatedButton(
                              onPressed: onActionPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: orangeText,
                                shadowColor: orangeText,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'ACCEPT QUEST',
                                style: GoogleFonts.epilogue(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
