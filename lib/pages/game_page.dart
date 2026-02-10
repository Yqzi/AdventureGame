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
    bool isInCombat = false;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            // Top Row: Back button, Title, Heart icon with number
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button in dark container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  // Title
                  Text(
                    'Adventure',
                    style: GoogleFonts.epilogue(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                  // Heart icon with number
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '5', // Example number, replace with variable if needed
                          style: GoogleFonts.epilogue(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // insert Image
            Container(height: screenHeight / 4),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Color.fromARGB(248, 22, 18, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      child: Column(children: [Container()]),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: borderGrey),
                              color: const Color.fromARGB(255, 63, 63, 63),
                            ),
                            child: Text(
                              'temp static text 1',
                              style: GoogleFonts.epilogue(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: borderGrey),
                              color: const Color.fromARGB(255, 63, 63, 63),
                            ),
                            child: Text(
                              'temp static text 2',
                              style: GoogleFonts.epilogue(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isInCombat)
              // ignore: dead_code
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
                          hintStyle: GoogleFonts.epilogue(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        cursorColor: redText,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: customOutlinedButton(
                            icon: Icon(Icons.gavel, color: Colors.white),
                            color: redText,
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
                            icon: Icon(
                              Icons.directions_run,
                              color: Colors.white,
                            ),
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
