import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/router.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    List pages = [
      AppRouter.sanctum,
      AppRouter.guild,
      AppRouter.shop,
      AppRouter.inventory,
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 41, 26, 20),
        border: const Border(
          top: BorderSide(color: Color.fromARGB(239, 88, 61, 53), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          final List<BottomBarItem> items = [
            BottomBarItem(icon: Icons.public, label: 'World'),
            BottomBarItem(icon: Icons.bookmark_add_rounded, label: 'Quest'),
            BottomBarItem(icon: Icons.store, label: 'Market'),
            BottomBarItem(icon: FontAwesomeIcons.shieldHeart, label: 'Hero'),
          ];
          final selected = index == currentIndex;
          final item = items[index];
          final isGoldGlow = index == 0;
          return GestureDetector(
            onTap: () => (Navigator.pushNamed(context, pages[index])),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: (isGoldGlow && selected)
                      ? BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFD4AF37).withOpacity(0.15),
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                        )
                      : null,
                  child: Icon(
                    item.icon,
                    color: selected
                        ? (isGoldGlow ? Color(0xFFD4AF37) : redText)
                        : Colors.white54,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.epilogue(
                    color: selected
                        ? (isGoldGlow ? Color(0xFFD4AF37) : redText)
                        : Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1,
                    shadows: (isGoldGlow && selected)
                        ? [
                            Shadow(
                              color: Color(0xFFD4AF37).withOpacity(0.4),
                              blurRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class BottomBarItem {
  final IconData icon;
  final String label;

  const BottomBarItem({required this.icon, required this.label});
}
