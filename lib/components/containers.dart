import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class InventorySlot extends StatelessWidget {
  final IconData icon;
  final String? label;
  final String? value;
  final double height;
  final double width;
  final double iconSize;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final double borderRadius;
  final bool showValue;
  final EdgeInsetsGeometry? margin;

  const InventorySlot({
    super.key,
    required this.icon,
    this.label,
    this.value,
    this.height = 75,
    this.width = 75,
    this.iconSize = 36,
    this.backgroundColor = const Color.fromARGB(255, 31, 26, 24),
    this.borderColor = const Color.fromARGB(255, 88, 61, 53),
    this.iconColor = const Color.fromARGB(220, 255, 255, 255),
    this.borderRadius = 1,
    this.showValue = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 6),
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: label != null
            ? MainAxisAlignment.end
            : MainAxisAlignment.center,
        children: [
          FaIcon(icon, color: iconColor, size: iconSize),
          if (label != null) const SizedBox(height: 8),
          if (label != null)
            Text(
              label!,
              style: GoogleFonts.epilogue(
                color: const Color.fromARGB(180, 255, 255, 255),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 12,
              ),
            ),
          if (showValue && value != null)
            Text(
              value!,
              style: GoogleFonts.epilogue(
                color: const Color.fromARGB(220, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          if (showValue) const SizedBox(height: 4),
        ],
      ),
    );
  }
}
