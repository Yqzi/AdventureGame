import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ClipRect(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  width: screenHeight,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 40,
                        spreadRadius: screenHeight,
                      ),
                    ],
                  ),
                ),
              ),

              // Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   bottom: 100,
              //   child: Container(
              //     width: screenHeight,
              //     height: screenHeight,
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       gradient: RadialGradient(
              //         colors: [
              //           Colors.transparent,
              //           Colors.white.withValues(alpha: 0.1),
              //           Colors.transparent,
              //           Colors.white.withValues(alpha: 0.05),
              //           Colors.transparent,
              //         ],
              //         stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                top: 0,
                bottom: 0 - screenHeight,
                left: size.width / 2 - screenHeight / 2,
                child: Container(
                  width: screenHeight,
                  height: screenHeight * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFFec4913).withValues(alpha: 0.2),
                        Color(0xFFec4913).withValues(alpha: 0.2),
                        Color(0xFFec4913).withValues(alpha: 0.15),
                        Color(0xFFec4913).withValues(alpha: 0.1),
                        Color(0xFFec4913).withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                    ),
                  ),
                ),
              ),

              // SVG icon
              Positioned.fill(
                top: -100,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glowing rings
                      Container(
                        width: screenHeight,
                        height: screenHeight,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
                          ),
                        ),
                      ),
                      // SVG icon
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                              Colors.white.withOpacity(0.05),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/flower.svg',
                          width: 180,
                          height: 180,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned.fill(
                top: -100 + 180 + 150,
                child: Center(
                  child: Text(
                    "TITLE",
                    style: GoogleFonts.cinzel(
                      color: Colors.white70,
                      fontSize: 40,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.grey[300]!.withOpacity(0.2),
                          blurRadius: 40,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Embers at the bottom
              Positioned(
                bottom: size.height * 0.10,
                left: size.width * 0.20,
                child: _Ember(size: 5, opacity: 0.6),
              ),
              Positioned(
                bottom: size.height * 0.15,
                left: size.width * 0.60,
                child: _Ember(size: 4, opacity: 0.4),
              ),
              Positioned(
                bottom: size.height * 0.05,
                left: size.width * 0.40,
                child: _Ember(size: 6, opacity: 0.5),
              ),
              Positioned(
                bottom: size.height * 0.25,
                left: size.width * 0.80,
                child: _Ember(size: 3, opacity: 0.3),
              ),
              Positioned(
                bottom: size.height * 0.08,
                left: size.width * 0.10,
                child: _Ember(size: 4, opacity: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ember extends StatelessWidget {
  final double size;
  final double opacity;
  const _Ember({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFFec4913).withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFec4913).withOpacity(opacity),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
