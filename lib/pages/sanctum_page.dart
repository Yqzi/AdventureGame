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

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      body: Stack(
        children: [
          Positioned.fill(
            top: 15,
            child: Image.asset(
              'assets/images/bg/castle.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Container(color: Color(0xFF020C15), height: 15),

          /// Strong dark overlay (top-to-bottom)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(230, 0, 0, 0),
                    Color.fromARGB(100, 0, 0, 0),
                    Color.fromARGB(80, 0, 0, 0),
                    Color.fromARGB(220, 0, 0, 0),
                  ],
                  stops: [0.0, 0.5, 0.6, 1.0],
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 52,
                  horizontal: 20,
                ),
                child: Row(
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
                          children: [
                            Text(
                              'SANCTUM OF',
                              style: GoogleFonts.cinzel(
                                fontSize: 10,
                                letterSpacing: 3,
                                color: primary,
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'FATE WEAVER',
                              style: GoogleFonts.cinzel(
                                fontSize: 20,
                                letterSpacing: 2.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
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
              ),
              Column(
                spacing: 48,
                children: [
                  _WorldEntranceButton(primary: primary),
                  _ForgeQuestButton(),
                  Text(
                    'The sands of destiny are shifting...',
                    style: GoogleFonts.crimsonText(
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1,
                      color: const Color(0xFFD4AF37).withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              CustomBottomBar(currentIndex: 0),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorldEntranceButton extends StatelessWidget {
  const _WorldEntranceButton({super.key, required this.primary});

  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color.fromARGB(100, 212, 175, 55),
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          height: 180,
          width: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(12, 212, 175, 55),
            border: Border.all(color: const Color.fromARGB(50, 212, 175, 55)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.hourglassStart, color: primary, size: 30),
              SizedBox(height: 12),
              Text(
                'ENTER WORLD',
                style: GoogleFonts.cinzel(
                  fontSize: 16,
                  letterSpacing: 2.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForgeQuestButton extends StatelessWidget {
  const _ForgeQuestButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color voidBlack = Color(0xFF020C15);
    const Color zinc900 = Color(0xFF18181B);
    const Color goldMuted = Color(0xFFD4AF37);
    const double borderRadius = 40.0;

    return Column(
      children: [
        Stack(
          children: [
            // Outer glow effect
            Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                boxShadow: [
                  BoxShadow(color: goldMuted.withOpacity(0.2), blurRadius: 32),
                ],
              ),
            ),
            // Main button
            Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [voidBlack, zinc900],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                border: Border.all(
                  color: goldMuted.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
                child: Stack(
                  children: [
                    // Radial gold dot pattern overlay
                    Positioned.fill(
                      top: 10,
                      child: Opacity(
                        opacity: 0.1,
                        child: CustomPaint(painter: _RadialDotPatternPainter()),
                      ),
                    ),
                    // Button content
                    Center(
                      child: Container(
                        height: 140,
                        width: 290,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(borderRadius - 4),
                            topRight: Radius.circular(borderRadius - 4),
                          ),
                          color: const Color.fromARGB(8, 255, 255, 255),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hardware,
                              size: 32,
                              color: goldMuted.withOpacity(0.7),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'FORGE QUEST',
                              style: GoogleFonts.cinzel(
                                fontSize: 11,
                                letterSpacing: 2,
                                color: goldMuted.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RadialDotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.fill;
    const double spacing = 18;
    const double dotRadius = 1;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
