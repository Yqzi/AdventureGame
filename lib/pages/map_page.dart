import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[200]!, Colors.grey[600]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 52,
            left: 24,
            right: 24,
          ),
          child: Container(),
        ),
      ),
    );
  }
}
