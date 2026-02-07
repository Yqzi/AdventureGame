import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/top_bar.dart';

class SanctumPage extends StatelessWidget {
  const SanctumPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFD4AF37);
    const goldMuted = Color(0xFF9A7B4F);
    const backgroundDark = Color(0xFF050505);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg/castle.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          /// Strong dark overlay (top-to-bottom)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(220, 0, 0, 0),
                    Color.fromARGB(100, 0, 0, 0),
                    Color.fromARGB(220, 0, 0, 0),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          /// Red atmospheric tint
          Positioned.fill(
            child: Container(color: Colors.red.withOpacity(0.08)),
          ),

          /// Vignette
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(90, 25, 25, 25),
                    Color.fromARGB(100, 10, 10, 10),
                  ],
                ),
              ),
            ),
          ),

          /// Bottom fog - grayscale effect
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 31, 31, 31).withOpacity(0),
                    const Color.fromARGB(255, 24, 24, 24).withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon + Title
                  Row(
                    children: [
                      // Icon with gothic border and background
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primary.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: primary.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.auto_fix_high,
                            color: primary,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'SANCTUM OF',
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 10,
                              letterSpacing: 3,
                              color: primary,
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'FATE WEAVER',
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 22,
                              letterSpacing: 2.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Settings Button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.settings,
                        color: Colors.white70,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomBar(currentIndex: 0),
          ),
        ],
      ),
    );
  }
}
