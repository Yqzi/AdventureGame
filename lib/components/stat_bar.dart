import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final double consumed;
  final double height;
  final Color color;

  const StatBar({
    super.key,
    required this.consumed,
    required this.color,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    double convertedValue = (consumed > 100
        ? 100
        : (consumed < 0 ? 0 : consumed));
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(136, 104, 98, 95),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Container(
              // inner fill
              height: height,
              width: constraints.maxWidth * (1 - (convertedValue / 100)),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        );
      },
    );
  }
}
