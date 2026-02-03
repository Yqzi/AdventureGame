import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? desc;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSettingsPressed;
  final VoidCallback? onThirdActionPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color buttonColor;

  const TopBar({
    super.key,
    required this.title,
    this.desc,
    this.leading,
    this.actions,
    this.onMenuPressed,
    this.onSettingsPressed,
    this.onThirdActionPressed,
    this.backgroundColor = const Color.fromARGB(255, 41, 26, 20),
    this.borderColor = const Color.fromARGB(239, 88, 61, 53),
    this.textColor = Colors.white,
    this.buttonColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.epilogue(
              color: textColor,
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (desc != null)
            Text(
              desc!,
              style: GoogleFonts.epilogue(
                color: orangeText,
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      leading: leading,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: borderColor),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}
