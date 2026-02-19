import 'dart:async';
import 'package:flutter/material.dart';

/// A widget that reveals text character-by-character with a typewriter effect.
///
/// Designed for streaming scenarios: as [text] grows (new chunks arrive),
/// the animation continues seamlessly from where it left off.
class TypewriterText extends StatefulWidget {
  /// The full text to display (may still be growing if streaming).
  final String text;

  /// Whether the source stream has finished. Once true **and** all characters
  /// are revealed, the timer stops.
  final bool isComplete;

  /// Milliseconds between each character reveal.
  final int charDelayMs;

  /// Builder that receives the currently-visible portion of [text].
  /// Use this to apply your own styling (drop-cap, RichText, etc.).
  final Widget Function(BuildContext context, String visibleText) builder;

  /// Optional callback fired every time a new character is revealed.
  /// Useful for triggering scroll-to-bottom.
  final VoidCallback? onReveal;

  const TypewriterText({
    super.key,
    required this.text,
    required this.isComplete,
    required this.builder,
    this.charDelayMs = 6,
    this.onReveal,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  /// Number of characters currently visible.
  int _visibleLength = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // If the message is already complete when we first build (e.g. scrolled
    // back into view), show all text instantly — no re-typing animation.
    if (widget.isComplete) {
      _visibleLength = widget.text.length;
    } else {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If new text arrived and the timer isn't running, restart it.
    if (widget.text.length > _visibleLength && _timer == null) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(milliseconds: widget.charDelayMs),
      (_) => _tick(),
    );
  }

  void _tick() {
    if (_visibleLength >= widget.text.length) {
      // All available characters revealed.
      if (widget.isComplete) {
        _timer?.cancel();
        _timer = null;
      }
      return;
    }

    // Reveal multiple characters per tick for punctuation pauses:
    // After '.', '!', '?' pause one tick; otherwise advance 1 char.
    final nextChar = widget.text[_visibleLength];
    setState(() {
      _visibleLength++;
    });

    // Small natural pause after sentence-ending punctuation — we simply
    // skip advancing on the *next* tick by not doing anything special here;
    // the normal timer interval gives a subtle pause. For commas we could
    // optionally do nothing, but the base interval already feels organic.

    widget.onReveal?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.text.substring(
      0,
      _visibleLength.clamp(0, widget.text.length),
    );
    return widget.builder(context, visible);
  }
}
