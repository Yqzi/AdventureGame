import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/router.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    List pages = [
      AppRouter.map,
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
            BottomBarItem(icon: Icons.map, label: 'Map'),
            BottomBarItem(icon: Icons.bookmark_add_rounded, label: 'Quest'),
            BottomBarItem(icon: Icons.store, label: 'Market'),
            BottomBarItem(icon: Icons.person, label: 'Hero'),
          ];
          final selected = index == currentIndex;
          final item = items[index];
          return GestureDetector(
            onTap: () => (Navigator.pushNamed(context, pages[index])),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: selected ? redText : Colors.white54,
                  size: 30,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: GoogleFonts.epilogue(
                    color: selected ? redText : Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1,
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
