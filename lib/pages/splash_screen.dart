import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Questborne/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _emberController;
  late final List<_EmberParticle> _embers;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _embers = List.generate(18, (_) => _EmberParticle(rng));
    _emberController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRouter.start);
      }
    });
  }

  @override
  void dispose() {
    _emberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ClipRect(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              // ── Bottom orange radial glow ──
              Positioned(
                bottom: -size.height * 0.35,
                left: -size.width * 0.3,
                right: -size.width * 0.3,
                child: Container(
                  width: size.width * 1.6,
                  height: size.height * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFec4913).withValues(alpha: 0.30),
                        const Color(0xFFec4913).withValues(alpha: 0.18),
                        const Color(0xFFec4913).withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Animated rising embers ──
              AnimatedBuilder(
                animation: _emberController,
                builder: (context, _) {
                  return CustomPaint(
                    size: size,
                    painter: _EmberPainter(
                      embers: _embers,
                      progress: _emberController.value,
                    ),
                  );
                },
              ),

              // ── Icon with soft glow ──
              Positioned(
                top: size.height * 0.30,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow behind the icon
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.08),
                              blurRadius: 60,
                              spreadRadius: 30,
                            ),
                          ],
                        ),
                      ),
                      // Flower icon
                      SvgPicture.asset(
                        'assets/icons/flower.svg',
                        width: 150,
                        height: 150,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Title text ──
              Positioned(
                top: size.height * 0.30 + 200,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).appTitle,
                    style: GoogleFonts.cinzel(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 36,
                      letterSpacing: 6,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.25),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Bottom tagline ──
              Positioned(
                bottom: size.height * 0.05,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context).appTagline,
                    style: GoogleFonts.cinzel(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 11,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────
//  Ember particle data
// ───────────────────────────────────────────────────────

class _EmberParticle {
  final double x; // 0..1 horizontal position
  final double startY; // 0..1 start from bottom
  final double speed; // how fast it rises (0..1 range per cycle)
  final double radius;
  final double opacity;
  final double phase; // random phase offset

  _EmberParticle(Random rng)
    : x = rng.nextDouble(),
      startY = rng.nextDouble() * 0.35,
      speed = 0.3 + rng.nextDouble() * 0.5,
      radius = 1.5 + rng.nextDouble() * 2.5,
      opacity = 0.3 + rng.nextDouble() * 0.5,
      phase = rng.nextDouble();
}

// ───────────────────────────────────────────────────────
//  Ember painter
// ───────────────────────────────────────────────────────

class _EmberPainter extends CustomPainter {
  final List<_EmberParticle> embers;
  final double progress;

  _EmberPainter({required this.embers, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final e in embers) {
      // Phase-offset looping position
      final t = (progress + e.phase) % 1.0;
      final y =
          size.height - (e.startY * size.height) - (t * size.height * e.speed);
      if (y < 0) continue;

      // Fade out as embers rise
      final fadeFactor = (1.0 - t).clamp(0.0, 1.0);
      final alpha = (e.opacity * fadeFactor).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = const Color(0xFFec4913).withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, e.radius * 2);

      canvas.drawCircle(Offset(e.x * size.width, y), e.radius, paint);

      // Brighter core
      final corePaint = Paint()
        ..color = const Color(0xFFff7733).withValues(alpha: alpha * 0.7);
      canvas.drawCircle(Offset(e.x * size.width, y), e.radius * 0.5, corePaint);
    }
  }

  @override
  bool shouldRepaint(_EmberPainter old) => true;
}
