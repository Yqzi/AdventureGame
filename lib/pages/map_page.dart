import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/map.png',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),

        // Shop hit zone
        Positioned(
          left: 0.1 * screenWidth,
          bottom: 0.2 * screenHeight,
          width: 0.3 * screenWidth,
          height: 0.15 * screenHeight,
          child: GestureDetector(onTap: () => print("Shop tapped")),
        ),

        // Guild hit zone
        Positioned(
          left: 0.55 * screenWidth,
          bottom: 0.2 * screenHeight,
          width: 0.3 * screenWidth,
          height: 0.15 * screenHeight,
          child: GestureDetector(onTap: () => print("Guild tapped")),
        ),
      ],
    );
  }
}
