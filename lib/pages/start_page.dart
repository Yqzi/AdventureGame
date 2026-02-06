import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/components/buttons.dart';
import 'package:tes/router.dart';
import '/colors.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
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
                      title: 'ENTER',
                      color: orangeText,
                      glow: true,
                      letterSpacing: 1,
                      fontsize: 22,
                      icon: Icon(Icons.style, color: Colors.white),
                      onpressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRouter.guild,
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: customOutlinedButton(
                          title: 'ARCHIVES',
                          glow: true,
                          letterSpacing: 1,
                          fontsize: 16,
                          // Temporary redirect
                          onpressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRouter.shop,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: customOutlinedButton(
                          title: 'SETTINGS',
                          glow: true,
                          letterSpacing: 1,
                          fontsize: 16,
                          // temporary redirect
                          onpressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRouter.inventory,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: orangeText.withOpacity(0.2),
                      border: Border.all(color: Color(0xFFFF6B00), width: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 9, color: orangeText),
                        SizedBox(width: 6),
                        Text(
                          'STORY ENGINE ACTIVE',
                          style: GoogleFonts.epilogue(
                            fontSize: 11,
                            color: const Color.fromARGB(255, 245, 18, 56),
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
