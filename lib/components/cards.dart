import 'package:flutter/material.dart';
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
      color: borderGrey,
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(title),
                Text(description),
                Text(cost),
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
  final String subtitle;
  final String description;
  final String underline;
  final String actionText;
  final VoidCallback onActionPressed;
  final String footerText;
  final String image;

  const QuestCardModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.underline,
    required this.actionText,
    required this.onActionPressed,
    required this.footerText,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height / 3;
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Color.fromARGB(255, 39, 30, 28),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Image with fade
          SizedBox(
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
                              Colors.transparent,
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
          // Content
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: cardHeight / 3 - 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    title,
                    style: const TextStyle(
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
                  child: Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4,
                  ),
                  child: Text(
                    description,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 2,
                  ),
                  child: Text(
                    underline,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          footerText,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onActionPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(actionText),
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
