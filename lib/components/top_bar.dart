import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onSettingsPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const TopBar({
    super.key,
    required this.title,
    this.onMenuPressed,
    this.onSettingsPressed,
    this.backgroundColor = const Color.fromARGB(240, 37, 21, 16),
    this.borderColor = const Color.fromARGB(239, 88, 61, 53),
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        color: textColor,
        onPressed: onMenuPressed,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          color: textColor,
          onPressed: onSettingsPressed,
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(height: 2, color: borderColor),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
