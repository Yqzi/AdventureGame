import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onThirdActionPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const TopBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onSettingsPressed,
    this.onThirdActionPressed,
    this.backgroundColor = const Color.fromARGB(240, 37, 21, 16),
    this.borderColor = const Color.fromARGB(239, 88, 61, 53),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: Text(
        title,
        style: GoogleFonts.epilogue(
          color: textColor,
          fontSize: 16,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        color: textColor,
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          color: textColor,
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: borderColor),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
