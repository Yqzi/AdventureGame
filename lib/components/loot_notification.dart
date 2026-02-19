import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/models/story_event.dart';

/// Shows a brief overlay notification when the player obtains loot
/// (gold, XP, items, etc.) extracted from [StoryEffects].
class LootNotification extends StatefulWidget {
  final StoryEffects effects;
  final VoidCallback onComplete;

  const LootNotification({
    super.key,
    required this.effects,
    required this.onComplete,
  });

  @override
  State<LootNotification> createState() => _LootNotificationState();
}

class _LootNotificationState extends State<LootNotification>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // 0.0–0.15 : fade/slide in
    // 0.15–0.75: hold
    // 0.75–1.0 : fade out
    _fadeIn = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 25),
    ]).animate(_controller);

    _slideIn = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 60),
      TweenSequenceItem(
        tween: Tween(
          begin: Offset.zero,
          end: const Offset(0, -0.15),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    // Play coin sound if gold was gained
    if (widget.effects.goldGained > 0) {
      _playCoinSound();
    }

    _controller.forward();
  }

  Future<void> _playCoinSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/coins.wav'));
    } catch (e) {
      debugPrint('Failed to play coin sound: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildLootItems();
    if (items.isEmpty) return const SizedBox.shrink();

    return Positioned(
      top: MediaQuery.of(context).padding.top + 80,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _slideIn,
        child: FadeTransition(
          opacity: _fadeIn,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2320).withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4883A).withOpacity(0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4883A).withOpacity(0.15),
                    blurRadius: 20,
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
                  // Title
                  Text(
                    'OBTAINED',
                    style: GoogleFonts.epilogue(
                      color: const Color(0xFFD4883A),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Loot rows
                  ...items,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLootItems() {
    final items = <Widget>[];
    final effects = widget.effects;

    if (effects.goldGained > 0) {
      items.add(
        _lootRow(
          icon: FontAwesomeIcons.coins,
          iconColor: Colors.amber,
          label: '+${effects.goldGained} Gold',
          labelColor: Colors.amber,
        ),
      );
    }

    if (effects.xpGained > 0) {
      items.add(
        _lootRow(
          icon: FontAwesomeIcons.starHalfStroke,
          iconColor: const Color(0xFF7FC8F8),
          label: '+${effects.xpGained} XP',
          labelColor: const Color(0xFF7FC8F8),
        ),
      );
    }

    if (effects.itemGainedId != null) {
      items.add(
        _lootRow(
          icon: FontAwesomeIcons.boxOpen,
          iconColor: const Color(0xFFA78BFA),
          label: 'New Item Acquired!',
          labelColor: const Color(0xFFA78BFA),
        ),
      );
    }

    if (effects.heal > 0) {
      items.add(
        _lootRow(
          icon: FontAwesomeIcons.heartPulse,
          iconColor: const Color(0xFF6FCF97),
          label: '+${effects.heal} HP Restored',
          labelColor: const Color(0xFF6FCF97),
        ),
      );
    }

    if (effects.manaRestored > 0) {
      items.add(
        _lootRow(
          icon: FontAwesomeIcons.droplet,
          iconColor: const Color(0xFF56CCF2),
          label: '+${effects.manaRestored} Mana Restored',
          labelColor: const Color(0xFF56CCF2),
        ),
      );
    }

    if (effects.goldLost > 0) {
      items.add(
        _lootRow(
          icon: FontAwesomeIcons.coins,
          iconColor: Colors.red.shade300,
          label: '-${effects.goldLost} Gold',
          labelColor: Colors.red.shade300,
        ),
      );
    }

    if (effects.damage > 0) {
      items.add(
        _lootRow(
          icon: FontAwesomeIcons.heartCrack,
          iconColor: Colors.red.shade400,
          label: '-${effects.damage} HP',
          labelColor: Colors.red.shade400,
        ),
      );
    }

    return items;
  }

  Widget _lootRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color labelColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: iconColor, size: 15),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.epilogue(
              color: labelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

/// Checks whether the effects have anything worth showing.
bool hasVisibleEffects(StoryEffects? effects) {
  if (effects == null) return false;
  return effects.goldGained > 0 ||
      effects.goldLost > 0 ||
      effects.xpGained > 0 ||
      effects.itemGainedId != null ||
      effects.heal > 0 ||
      effects.manaRestored > 0 ||
      effects.damage > 0;
}
