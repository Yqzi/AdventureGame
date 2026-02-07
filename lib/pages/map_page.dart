import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/top_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      appBar: TopBar(
        title: 'WORLD MAP',
        textStyle: GoogleFonts.newsreader(
          color: const Color(0xFFE3D5B8), // #e3d5b8
          fontSize: 24, // text-xl ≈ 20px
          fontWeight: FontWeight.bold, // font-bold
          fontStyle: FontStyle.italic,
          height: 1.25,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Map Background Textures
                Positioned.fill(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBEhCOx91aDlmzda6a3Se3yDMsjCMKv14aygUPkeZfBjAzWlLcG_OrI8Vcy9ULyfHP_-FpFKZuJPgY-ok-fNNU3syNrixnSOdAJyX-kJ54xf-pMw7nOPlm6aUXB4ypLWCNZQv6G-pwZIrZfgHL9wIuIg4ap0wwFpi2u18rMg8FzMkK3cIS205G4QsF72aWGvaKh8WErj0YMtNrW5AfeaSNy1t0momnxT0DuX2eTFhEbEfUF3P_SXdo-OkuSABuc4411qfRc0DfCP4E',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.4),
                    colorBlendMode: BlendMode.overlay,
                  ),
                ),
                Positioned.fill(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDu5L-GEUZSVpTubzyws2WeuKNjVrVhuCuPcoBKjbcZwasLIQ1AcdTPlwftRAcnvFzoUsUj_poiCp21uw1b5olfoiqM8pBWECcPGY2W6SYXd9YwNDLl6gzYHWU4wQE0_Z9p74nc_t4CY2RWwsi4ygPyaKb4fBIEw_UNy6UWskv8v2Blnw1PE3HD4aHa24uLBiajDfBpPpmbxzeVypC4ff2LlIMSfoeCmftKOFkaJoHt_ks9FxqEDknNtnvC_wyvAa8tm_h_PlZox24',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.1),
                    colorBlendMode: BlendMode.multiply,
                  ),
                ),
                // Fog / Vignette
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        colors: [Colors.transparent, Color(0xFF111621)],
                        radius: 1.2,
                        center: Alignment.center,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Color(0xFF111621).withOpacity(0.7)),
                ),
                // Map Tokens
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.35,
                  left: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              border: Border.all(
                                color: const Color(0xFFE3D5C5),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.castle, color: Color(0xFFE3D5C5)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Ironhold",
                          style: TextStyle(
                            color: Color(0xFFE3D5C5),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomBottomBar(currentIndex: 0),
        ],
      ),
    );
  }
}
