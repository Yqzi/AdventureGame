import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/experience_bar.dart';
import 'package:tes/components/top_bar.dart';
import 'package:tes/router.dart';

class WorldExplorationPage extends StatelessWidget {
  const WorldExplorationPage({super.key});

  static const List<Map<String, String>> _maps = [
    {
      'title': 'The Darkwood Forest',
      'location': 'Forest',
      'description':
          'An ancient woodland shrouded in perpetual twilight. Twisted oaks '
          'and gnarled roots hide forgotten paths, strange creatures, and '
          'whispers of old magic between the moss-covered stones.',
      'image': 'assets/images/forest.png',
    },
    {
      'title': 'The Sunken Caverns',
      'location': 'Cave',
      'description':
          'A vast subterranean network of dripping tunnels and '
          'glowing crystal chambers. The air is thick with the scent of damp '
          'earth, and unknown things skitter just beyond the torchlight.',
      'image': 'assets/images/cave.png',
    },
    {
      'title': 'The Ashen Ruins',
      'location': 'Ruins',
      'description':
          'Crumbling remnants of a once-great civilization, half-swallowed '
          'by sand and creeping vines. Collapsed archways lead to forgotten '
          'vaults, and the ghosts of the old world linger in every shadow.',
      'image': 'assets/images/ruins.png',
    },
  ];

  /// Build the details map that gets sent to GamePage / AI service.
  Map<String, dynamic> _buildExpeditionDetails(Map<String, String> map) {
    return {
      'title': '${map['title']} — Free Roam',
      'location': map['location'],
      'description': map['description'],
      'objective': 'Explore freely and see what the world has in store.',
      'aiObjective':
          'Open-world exploration. There is no fixed objective — '
          'the player is free to roam, discover, and interact with whatever '
          'they find. Let the adventure unfold naturally. '
          'Do NOT set questCompleted to true during free roam.',
      'reward': '',
      'keyNPCs': <String>[],
    };
  }

  void _showMapDetail(BuildContext context, Map<String, String> map) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // absorb taps on the dialog itself
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2320),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF5A3E2B),
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Map image ──
                        Image.asset(
                          map['image']!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.3),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Title ──
                              Text(
                                map['title']!,
                                style: GoogleFonts.epilogue(
                                  color: const Color(0xFFE3D5B8),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // ── Location badge ──
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3A2A1F),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFF5A3E2B),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.mapLocationDot,
                                      color: Color(0xFFB0896D),
                                      size: 13,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      map['location']!,
                                      style: GoogleFonts.epilogue(
                                        color: const Color(0xFFB0896D),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // ── Description ──
                              Text(
                                map['description']!,
                                style: GoogleFonts.epilogue(
                                  color: const Color(0xFFB0896D),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // ── Free-roam note ──
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.compass,
                                    color: Color(0xFF7A9F6A),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'No set objective — explore freely and '
                                      'see what awaits.',
                                      style: GoogleFonts.epilogue(
                                        color: const Color(0xFF7A9F6A),
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // ── Enter Expedition button ──
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // close dialog
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.game,
                                      arguments: {
                                        'details': _buildExpeditionDetails(map),
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD4883A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Enter Expedition',
                                    style: GoogleFonts.epilogue(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      appBar: TopBar(
        title: 'Expedition',
        textStyle: GoogleFonts.epilogue(
          color: const Color(0xFFE3D5B8),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.25,
        ),
      ),
      body: Builder(
        builder: (context) {
          final player = context.read<GameBloc>().player;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              ExperienceBar(player: player),
              const SizedBox(height: 12),

              // ── Section header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Open Worlds",
                  style: GoogleFonts.epilogue(
                    color: const Color(0xFFE3D5B8),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    letterSpacing: 1.2,
                    shadows: const [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Color.fromRGBO(0, 0, 0, 0.8),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Map cards ──
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _maps.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final map = _maps[index];
                    return GestureDetector(
                      onTap: () => _showMapDetail(context, map),
                      child: _ExpeditionMapCard(map: map),
                    );
                  },
                ),
              ),

              CustomBottomBar(currentIndex: 0),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  EXPEDITION MAP CARD
// ─────────────────────────────────────────────────────────
class _ExpeditionMapCard extends StatelessWidget {
  final Map<String, String> map;
  const _ExpeditionMapCard({required this.map});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF2D2320),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Map image ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              map['image']!,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.3),
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 170,
                child: Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title ──
                Text(
                  map['title']!,
                  style: GoogleFonts.epilogue(
                    color: const Color(0xFFE3D5B8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // ── Description (truncated) ──
                Text(
                  map['description']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.epilogue(
                    color: const Color(0xFFB0896D),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // ── Footer: location + free roam label ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.compass,
                          color: Color(0xFF7A9F6A),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Free Roam',
                          style: GoogleFonts.epilogue(
                            color: const Color(0xFF7A9F6A),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4883A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Enter',
                        style: GoogleFonts.epilogue(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
