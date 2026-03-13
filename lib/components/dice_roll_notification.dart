import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/models/skill_check.dart';

/// Animated D20 roll notification shown when a skill check is performed.
///
/// Displays the action type, a brief tumbling-dice animation that lands on
/// the actual roll, the modifier breakdown, and the outcome.
class DiceRollNotification extends StatefulWidget {
  final SkillCheckResult result;
  final VoidCallback onComplete;

  const DiceRollNotification({
    super.key,
    required this.result,
    required this.onComplete,
  });

  @override
  State<DiceRollNotification> createState() => _DiceRollNotificationState();
}

class _DiceRollNotificationState extends State<DiceRollNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  /// Random numbers shown during the "tumble" phase.
  int _displayedRoll = 1;
  Timer? _tumbleTimer;
  bool _settled = false;
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Fade: in 0–10%, hold 10–80%, out 80–100%.
    _fade = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 20),
    ]).animate(_controller);

    // Slide up slightly.
    _slide = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
      TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 70),
      TweenSequenceItem(
        tween: Tween(
          begin: Offset.zero,
          end: const Offset(0, -0.15),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    // Start the tumbling dice animation (rapid random numbers).
    _tumbleTimer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (!mounted) return;
      setState(() {
        _displayedRoll = _rng.nextInt(20) + 1;
      });
    });

    // After 700ms, settle on the real roll.
    Future.delayed(const Duration(milliseconds: 700), () {
      _tumbleTimer?.cancel();
      if (mounted) {
        setState(() {
          _displayedRoll = widget.result.naturalRoll;
          _settled = true;
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _tumbleTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color get _outcomeColor {
    switch (widget.result.outcome) {
      case CheckOutcome.criticalFailure:
        return const Color(0xFFFF4444);
      case CheckOutcome.failure:
        return const Color(0xFFE57373);
      case CheckOutcome.partialSuccess:
        return const Color(0xFFFFB74D);
      case CheckOutcome.success:
        return const Color(0xFF81C784);
      case CheckOutcome.criticalSuccess:
        return const Color(0xFFFFD700);
    }
  }

  Color get _diceColor {
    if (!_settled) return const Color(0xFFE3D5B8);
    return _outcomeColor;
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;

    // Modifier text: e.g. "+4 stat, -2 injured"
    final modParts = <String>[];
    if (r.statModifier != 0) {
      modParts.add('${r.statModifier >= 0 ? "+" : ""}${r.statModifier}');
    }
    if (r.situationalModifier != 0) {
      modParts.add(
        '${r.situationalModifier >= 0 ? "+" : ""}${r.situationalModifier}',
      );
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1614).withOpacity(0.96),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _outcomeColor.withOpacity(0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _outcomeColor.withOpacity(0.12),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                  const BoxShadow(
                    color: Colors.black54,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Action type label.
                  Text(
                    '${r.actionType.icon}  ${r.actionType.label.toUpperCase()}  CHECK',
                    style: GoogleFonts.epilogue(
                      color: const Color(0xFFE3D5B8).withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dice roll number (animates during tumble).
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: GoogleFonts.cinzelDecorative(
                      color: _diceColor,
                      fontSize: _settled ? 42 : 36,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                    child: Text('$_displayedRoll'),
                  ),

                  // Modifier + total vs DC.
                  if (_settled) ...[
                    const SizedBox(height: 4),

                    // Outcome badge.
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _outcomeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _outcomeColor.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        '${r.outcome.icon}  ${r.outcome.label.toUpperCase()}',
                        style: GoogleFonts.epilogue(
                          color: _outcomeColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
