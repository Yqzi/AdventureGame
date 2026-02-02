import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/buttons.dart';
import 'package:tes/components/stat_bar.dart';
import 'package:tes/components/top_bar.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  final List equipment = const [];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double consumedHealth = 0.0;
    double consumedMana = 0.0;
    int health = 100;
    int mana = 100;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // Temporary static title
        appBar: TopBar(
          title: 'FOREST OF DESPAIR',
          desc: "CHAPTER 1",
          buttonColor: orangeText,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: orangeText,
            onPressed: () {},
          ),
        ),
        body: Column(
          children: [
            // insert Image
            Container(height: screenHeight / 4),
            Expanded(
              child: Container(
                color: Color.fromARGB(248, 22, 18, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(color: borderGrey),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'HEALTH',
                                      style: GoogleFonts.epilogue(
                                        color: const Color.fromARGB(
                                          200,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '$health/100',
                                      style: GoogleFonts.epilogue(
                                        color: const Color.fromARGB(
                                          220,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                StatBar(
                                  consumed: consumedHealth,
                                  color: const Color.fromARGB(255, 236, 19, 19),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: borderGrey),
                                bottom: BorderSide(color: borderGrey),
                                left: BorderSide(color: borderGrey),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'MANA',
                                      style: GoogleFonts.epilogue(
                                        color: const Color.fromARGB(
                                          200,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '$mana/100',
                                      style: GoogleFonts.epilogue(
                                        color: const Color.fromARGB(
                                          220,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                StatBar(
                                  consumed: consumedMana,
                                  color: const Color.fromARGB(
                                    255,
                                    112,
                                    85,
                                    233,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(),
                  ],
                ),
              ),
            ),
            Container(
              color: Color.fromARGB(248, 22, 18, 16),
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderGrey),
                    ),
                    child: TextField(
                      style: GoogleFonts.epilogue(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type your action...',
                        hintStyle: GoogleFonts.epilogue(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      cursorColor: orangeText,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Expanded(
                        child: customOutlinedButton(
                          icon: Icon(Icons.gavel, color: Colors.white),
                          color: orangeText,
                          title: 'ATTACK',
                          fontsize: 16,
                          onpressed: () {},
                        ),
                      ),
                      Expanded(
                        child: customOutlinedButton(
                          icon: Icon(Icons.auto_awesome, color: Colors.white),
                          color: purpleSpecial,
                          title: 'SPECIAL',
                          fontsize: 16,
                          onpressed: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16,
                    children: [
                      Expanded(
                        child: customOutlinedButton(
                          icon: Icon(Icons.favorite, color: Colors.green),
                          title: 'HEAL POT',
                          fontsize: 16,
                          onpressed: () {},
                        ),
                      ),
                      Expanded(
                        child: customOutlinedButton(
                          icon: Icon(Icons.directions_run, color: Colors.white),
                          title: 'FLEE',
                          fontsize: 16,
                          onpressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
