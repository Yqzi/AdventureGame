import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animates a gold number counting up/down to [targetValue].
class AnimatedCoinCounter extends StatefulWidget {
  final int targetValue;
  final Duration duration;

  const AnimatedCoinCounter({
    super.key,
    required this.targetValue,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedCoinCounter> createState() => _AnimatedCoinCounterState();
}

class _AnimatedCoinCounterState extends State<AnimatedCoinCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _displayValue = 0;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.targetValue;
    _previousValue = widget.targetValue;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _animation.addListener(() {
      setState(() {
        _displayValue =
            (_previousValue +
                    (widget.targetValue - _previousValue) * _animation.value)
                .round();
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedCoinCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue) {
      _previousValue = _displayValue;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_displayValue',
      style: GoogleFonts.epilogue(
        color: Colors.amber,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }
}
