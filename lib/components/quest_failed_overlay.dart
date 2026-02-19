import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';

/// Full-screen overlay displayed when the quest has been failed.
/// Shows a "QUEST FAILED" banner with the failure reason and a return-to-guild button.
class QuestFailedOverlay extends StatefulWidget {
  final String questTitle;
  final VoidCallback onReturnToGuild;

  const QuestFailedOverlay({
    super.key,
    required this.questTitle,
    required this.onReturnToGuild,
  });

  @override
  State<QuestFailedOverlay> createState() => _QuestFailedOverlayState();
}

class _QuestFailedOverlayState extends State<QuestFailedOverlay>
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

    _backdropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _backdropOpacity = CurvedAnimation(
      parent: _backdropController,
      curve: Curves.easeOut,
    );

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

  static const _bloodRed = Color.fromARGB(255, 219, 184, 180);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_backdropController, _contentController]),
      builder: (context, _) {
        return Stack(
          children: [
            // Dark backdrop with red tint
            Positioned.fill(
              child: Opacity(
                opacity: _backdropOpacity.value * 0.88,
                child: const ColoredBox(color: Color(0xFF1A0505)),
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
                          _ornamentDivider(),
                          const SizedBox(height: 16),

                          // Skull icon
                          Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: FaIcon(
                              FontAwesomeIcons.skull,
                              size: 36,
                              color: _bloodRed.withAlpha(200),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // QUEST FAILED title
                          Transform.translate(
                            offset: Offset(0, _titleSlide.value),
                            child: Text(
                              'QUEST FAILED',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.cinzelDecorative(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: _bloodRed,
                                letterSpacing: 3,
                                decoration: TextDecoration.none,
                                shadows: [
                                  Shadow(
                                    color: _bloodRed.withAlpha(128),
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
                            'The darkness claims another soul.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.crimsonPro(
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              fontStyle: FontStyle.italic,
                              color: greyText.withAlpha(150),
                            ),
                          ),
                          const SizedBox(height: 24),

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

  Widget _ornamentDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 40, height: 1, color: _bloodRed.withAlpha(100)),
        const SizedBox(width: 8),
        Icon(Icons.diamond_outlined, size: 14, color: _bloodRed.withAlpha(160)),
        const SizedBox(width: 8),
        Container(width: 40, height: 1, color: _bloodRed.withAlpha(100)),
      ],
    );
  }

  Widget _buildReturnButton() {
    return GestureDetector(
      onTap: widget.onReturnToGuild,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: _bloodRed.withAlpha(180), width: 1.5),
          borderRadius: BorderRadius.circular(4),
          color: _bloodRed.withAlpha(20),
        ),
        child: Text(
          'RETURN TO GUILD',
          style: GoogleFonts.cinzel(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _bloodRed,
            decoration: TextDecoration.none,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
