import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final double consumed;
  final double height;
  final Color color;

  /// Optional temp HP display (teal layer on top of the HP fill).
  /// Pass [tempHp] > 0 together with [currentHp] and [effectiveMaxHp]
  /// to show the temp-HP overlay. Only used on the HP bar.
  final int tempHp;
  final int currentHp;
  final int effectiveMaxHp;

  const StatBar({
    super.key,
    required this.consumed,
    required this.color,
    this.height = 6,
    this.tempHp = 0,
    this.currentHp = 0,
    this.effectiveMaxHp = 0,
  });

  @override
  Widget build(BuildContext context) {
    double convertedValue = (consumed > 100
        ? 100
        : (consumed < 0 ? 0 : consumed));
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * (1 - (convertedValue / 100));

        // Temp HP layer: a teal stripe immediately after the real HP fill.
        double tempWidth = 0;
        if (tempHp > 0 && effectiveMaxHp > 0) {
          final tempFraction = (tempHp / effectiveMaxHp).clamp(0.0, 1.0);
          // Clamp so fill + temp don't exceed bar width
          final remaining = (totalWidth - fillWidth).clamp(0.0, totalWidth);
          tempWidth = (totalWidth * tempFraction).clamp(0.0, remaining);
        }

        return Stack(
          children: [
            // Background track
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(136, 104, 98, 95),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            // Real HP fill
            Container(
              height: height,
              width: fillWidth,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            // Temp HP teal layer (right of real HP fill)
            if (tempWidth > 0)
              Positioned(
                left: fillWidth,
                child: Container(
                  height: height,
                  width: tempWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFF26C6DA),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
