import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/containers.dart';
import 'package:tes/components/top_bar.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  final List equipment = const [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'CHARACTER INVENTORY',
        textStyle: GoogleFonts.epilogue(
          color: const Color(0xFFE3D5B8), // #e3d5b8
          fontSize: 20, // text-xl ≈ 20px
          fontWeight: FontWeight.bold, // font-bold
          height: 1.25,
          fontStyle: FontStyle.italic,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: const Color(0xFFE3D5B8),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: const Color(0xFFE3D5B8),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromARGB(255, 48, 30, 23),
              Color.fromARGB(255, 48, 31, 24),
            ],
            center: Alignment.center,
            radius: 1.6,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InventorySlot(
                          icon: FontAwesomeIcons.bolt,
                          borderColor: borderGrey,
                          iconColor: borderGrey,
                        ),
                        Text(
                          'WEAPON',
                          style: GoogleFonts.epilogue(
                            color: const Color.fromARGB(220, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        InventorySlot(
                          icon: FontAwesomeIcons.shield,
                          borderColor: borderGrey,
                          iconColor: borderGrey,
                        ),
                        Text(
                          'ARMOR',
                          style: GoogleFonts.epilogue(
                            color: const Color.fromARGB(220, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        InventorySlot(
                          icon: FontAwesomeIcons.ring,
                          borderColor: borderGrey,
                          iconColor: borderGrey,
                        ),
                        Text(
                          'ACCESSORY',
                          style: GoogleFonts.epilogue(
                            color: const Color.fromARGB(220, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                        InventorySlot(
                          icon: FontAwesomeIcons.ankh,
                          borderColor: borderGrey,
                          iconColor: borderGrey,
                        ),
                        Text(
                          'RELIC',
                          style: GoogleFonts.epilogue(
                            color: const Color.fromARGB(220, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(239, 88, 61, 53),
                    width: 1,
                    height: double.infinity,
                  ),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(50, 32, 20, 16),
                      child: Column(
                        children: [
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color.fromARGB(239, 88, 61, 53),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "UNEQUIPPED",
                                style: GoogleFonts.epilogue(
                                  color: const Color.fromARGB(
                                    230,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: equipment.length + 12,
                              itemBuilder: (context, index) {
                                return DottedBorder(
                                  options: RectDottedBorderOptions(
                                    dashPattern: [4, 2],
                                    color: borderGrey,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(240, 27, 17, 14),
                                    ),
                                    child: const Center(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 2, color: const Color.fromARGB(239, 88, 61, 53)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InventorySlot(
                  icon: FontAwesomeIcons.dumbbell,
                  label: 'STR',
                  value: '14',
                  height: 100,
                  width: 100,
                  iconSize: 24,
                  showValue: true,
                  borderColor: borderGrey,
                  margin: const EdgeInsets.only(top: 16, bottom: 26),
                  iconColor: const Color.fromARGB(180, 255, 255, 255),
                ),
                InventorySlot(
                  icon: FontAwesomeIcons.boltLightning,
                  label: 'AGI',
                  value: '14',
                  height: 100,
                  width: 100,
                  iconSize: 24,
                  showValue: true,
                  borderColor: borderGrey,
                  margin: const EdgeInsets.only(top: 16, bottom: 26),
                  iconColor: const Color.fromARGB(180, 255, 255, 255),
                ),
                InventorySlot(
                  icon: FontAwesomeIcons.wandSparkles,
                  label: 'MAGIC',
                  value: '14',
                  height: 100,
                  width: 100,
                  iconSize: 24,
                  showValue: true,
                  borderColor: borderGrey,
                  margin: const EdgeInsets.only(top: 16, bottom: 26),
                  iconColor: const Color.fromARGB(180, 255, 255, 255),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
