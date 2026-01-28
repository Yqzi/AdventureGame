import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/components/buttons.dart';
import '/colors.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background
        Stack(
          children: [
            Image.asset(
              'assets/images/bg/castle.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              height: screenHeight,
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
          ],
        ),
        // Content
        Padding(
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 52,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 50,
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderGrey),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleQuestion,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "TEMP TITLE",
                textAlign: TextAlign.center,
                style: GoogleFonts.epilogue(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 0.95,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  shadows: const [
                    Shadow(
                      blurRadius: 15,
                      offset: Offset(0, 5),
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              SizedBox(),
              Column(
                spacing: 12,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: customOutlinedButton(
                      title: 'START NEW GAME',
                      color: Color(0xFFFF6B00),
                      letterSpacing: 1,
                      icon: Icons.style,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: customOutlinedButton(
                      title: 'CONTINUE',
                      letterSpacing: 1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: customOutlinedButton(
                          title: 'ARCHIVES',
                          letterSpacing: 1,
                          fontsize: 16,
                        ),
                      ),
                      Expanded(
                        child: customOutlinedButton(
                          title: 'SETTINGS',
                          letterSpacing: 1,
                          fontsize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFF6B00).withOpacity(0.2),
                      border: Border.all(color: Color(0xFFFF6B00), width: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 9, color: Color(0xFFFF6B00)),
                        SizedBox(width: 6),
                        Text(
                          'STORY ENGINE ACTIVE',
                          style: GoogleFonts.epilogue(
                            fontSize: 11,
                            color: Color(0xFFFF6B00),
                            decoration: TextDecoration.none,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Version 0.0.1 • Shadow-Crest Protocol",
                    style: GoogleFonts.epilogue(
                      color: Colors.white60,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
