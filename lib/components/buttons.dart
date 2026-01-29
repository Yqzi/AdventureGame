import 'package:flutter/material.dart';
import 'package:tes/colors.dart';

OutlinedButton customOutlinedButton({
  required String title,
  required VoidCallback onpressed,
  IconData? icon,
  double fontsize = 20,
  double height = 60,
  double letterSpacing = 0,
  Color color = const Color.fromARGB(201, 48, 48, 48),
}) => OutlinedButton(
  style: OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: BorderSide(color: borderGrey),
    backgroundColor: color,
    shadowColor: color,
    elevation: 12,
    fixedSize: Size(0, height),
    splashFactory: NoSplash.splashFactory,
  ),
  onPressed: onpressed,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (icon != null)
        Icon(icon, color: Colors.white)
      else
        const SizedBox.shrink(),
      SizedBox(width: icon != null ? 8 : 0),
      Text(
        title,
        style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
          fontSize: fontsize,
          fontWeight: FontWeight.w800,
          letterSpacing: letterSpacing,
        ),
      ),
    ],
  ),
);
