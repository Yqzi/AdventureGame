import 'package:flutter/material.dart';

/// Shimmering skeleton lines that mimic not-yet-loaded narrative text.
///
/// Fills all available [height] with animated placeholder bars whose widths
/// vary naturally so they look like real paragraphs.
class NarrativeSkeleton extends StatefulWidget {
  /// Total height the skeleton should fill.
  final double height;

  const NarrativeSkeleton({super.key, required this.height});

  @override
  State<NarrativeSkeleton> createState() => _NarrativeSkeletonState();
}

class _NarrativeSkeletonState extends State<NarrativeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.height <= 0) return const SizedBox.shrink();

    // Line config: height per skeleton line + vertical spacing.
    const double lineHeight = 14;
    const double lineSpacing = 16; // matches ~1.7 text height ratio
    const double step = lineHeight + lineSpacing;

    final int lineCount = (widget.height / step).floor().clamp(1, 40);

    // Deterministic width fractions so lines look natural.
    const widths = [
      0.95,
      0.88,
      0.92,
      0.78,
      0.85,
      0.90,
      0.70,
      0.93,
      0.82,
      0.87,
      0.76,
      0.91,
      0.84,
      0.79,
      0.94,
      0.72,
      0.89,
      0.81,
      0.86,
      0.75,
    ];

    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(lineCount, (i) {
            final widthFrac = widths[i % widths.length];
            // Stagger the shimmer per line for a wave effect.
            final offset = (i * 0.06).clamp(0.0, 0.5);
            final t = ((_shimmer.value + offset) % 1.0);
            final opacity = 0.06 + 0.08 * _pulse(t);

            return Padding(
              padding: const EdgeInsets.only(bottom: lineSpacing),
              child: FractionallySizedBox(
                widthFactor: widthFrac,
                child: Container(
                  height: lineHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3D5B8).withOpacity(opacity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Smooth pulse: 0 → 1 → 0 over one cycle.
  static double _pulse(double t) {
    return (t < 0.5) ? (t * 2) : (2 - t * 2);
  }
}
