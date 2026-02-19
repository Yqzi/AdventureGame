import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';

/// Full-screen overlay displayed when the quest objective is completed.
/// Shows a "QUEST COMPLETE" banner with reward summary and a return-to-guild button.
class QuestCompleteOverlay extends StatefulWidget {
  final String questTitle;
  final int totalGold;
  final int totalXp;
  final List<String> itemsGained;
  final VoidCallback onReturnToGuild;

  const QuestCompleteOverlay({
    super.key,
    required this.questTitle,
    required this.onReturnToGuild,
    this.totalGold = 0,
    this.totalXp = 0,
    this.itemsGained = const [],
  });

  @override
  State<QuestCompleteOverlay> createState() => _QuestCompleteOverlayState();
}

class _QuestCompleteOverlayState extends State<QuestCompleteOverlay>
    with TickerProviderStateMixin {
  late AnimationController _backdropController;
  late AnimationController _contentController;
  late Animation<double> _backdropOpacity;
  late Animation<double> _contentOpacity;
  late Animation<double> _contentScale;
  late Animation<double> _titleSlide;

  @override
  void initState() {
    super.initState();

    // Backdrop fades in over 400ms
    _backdropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _backdropOpacity = CurvedAnimation(
      parent: _backdropController,
      curve: Curves.easeOut,
    );

    // Content appears after a short delay, scales + fades in
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    _contentScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.elasticOut),
    );
    _titleSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _backdropController.forward();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _backdropController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_backdropController, _contentController]),
      builder: (context, _) {
        return Stack(
          children: [
            // Dark backdrop
            Positioned.fill(
              child: Opacity(
                opacity: _backdropOpacity.value * 0.85,
                child: const ColoredBox(color: Colors.black),
              ),
            ),

            // Content
            Positioned.fill(
              child: Opacity(
                opacity: _contentOpacity.value,
                child: Transform.scale(
                  scale: _contentScale.value,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Decorative divider top
                          _ornamentDivider(),
                          const SizedBox(height: 16),

                          // QUEST COMPLETE title
                          Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: Text(
                              'QUEST COMPLETE',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cinzelDecorative(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFD4A843),
                                letterSpacing: 3,
                                decoration: TextDecoration.none,
                                shadows: [
                                  const Shadow(
                                    color: Color(0x80D4A843),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Quest title
                          Text(
                            widget.questTitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.crimsonPro(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: greyText,
                              decoration: TextDecoration.none,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            'Your tale has been written.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.crimsonPro(
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              fontStyle: FontStyle.italic,
                              color: greyText.withAlpha(150),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Reward summary ──
                          if (_hasAnyReward) ...[
                            Text(
                              'REWARDS',
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFD4A843).withAlpha(180),
                                decoration: TextDecoration.none,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(8),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xFFD4A843).withAlpha(40),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.totalGold > 0)
                                    _rewardRow(
                                      FontAwesomeIcons.coins,
                                      Colors.amber,
                                      '${widget.totalGold} Gold',
                                    ),
                                  if (widget.totalXp > 0) ...[
                                    if (widget.totalGold > 0)
                                      const SizedBox(height: 8),
                                    _rewardRow(
                                      FontAwesomeIcons.star,
                                      const Color(0xFF7EB5F5),
                                      '${widget.totalXp} XP',
                                    ),
                                  ],
                                  for (final item in widget.itemsGained) ...[
                                    const SizedBox(height: 8),
                                    _rewardRow(
                                      FontAwesomeIcons.gem,
                                      const Color(0xFFB07EF5),
                                      item,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Decorative divider bottom
                          _ornamentDivider(),
                          const SizedBox(height: 36),

                          // Return to guild button
                          _buildReturnButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool get _hasAnyReward =>
      widget.totalGold > 0 ||
      widget.totalXp > 0 ||
      widget.itemsGained.isNotEmpty;

  Widget _rewardRow(IconData icon, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 14, color: color.withAlpha(200)),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.crimsonPro(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _ornamentDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 1,
          color: const Color(0xFFD4A843).withAlpha(100),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.diamond_outlined,
          size: 14,
          color: const Color(0xFFD4A843).withAlpha(160),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 1,
          color: const Color(0xFFD4A843).withAlpha(100),
        ),
      ],
    );
  }

  Widget _buildReturnButton() {
    return GestureDetector(
      onTap: widget.onReturnToGuild,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD4A843).withAlpha(180),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xFFD4A843).withAlpha(20),
        ),
        child: Text(
          'RETURN TO GUILD',
          style: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFD4A843),
            decoration: TextDecoration.none,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
