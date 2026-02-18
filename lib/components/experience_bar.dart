import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/models/player.dart';

/// A reusable XP progress bar showing current experience toward the next level.
class ExperienceBar extends StatelessWidget {
  final Player player;

  const ExperienceBar({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final xp = player.experience;
    final xpNeeded = player.experienceToNextLevel;
    final progress = xpNeeded > 0 ? (xp / xpNeeded).clamp(0.0, 1.0) : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'lvl ${player.level}',
                style: GoogleFonts.epilogue(
                  color: const Color(0xFF8D6E63),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                '$xp / $xpNeeded',
                style: GoogleFonts.epilogue(
                  color: const Color(0xFFE3D5B8).withOpacity(0.6),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.08),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFD4883A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
