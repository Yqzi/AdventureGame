import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/bottom_bar.dart';
import 'package:tes/components/cards.dart';
import 'package:tes/components/top_bar.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  final List<Map<String, dynamic>> wares = const [
    {
      'rarity': Rarity.common,
      'title': 'Potion of Healing',
      'stats': 'Restores 50 HP instantly.',
      'cost': '500 Gold',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAsg60tCEw3scioXESnKDkZjENWuR0SVK6pvdN_hrlK_5UAVI_fTjANfyosJx2G24Xgc7zslAN9byiwLdqmU36j5yNOMnv96LwaVEycux_sr9ZDUyvKqJigwHmd3pZaUHS9zDEFIWEz8_-iMdO-mTOV4sBcKTPI--Kro-75hYTC-EBQReozFNvkH8hGMn6cKm_aCCIamPco6y1A5hwmJ3FLPfhyvbqmnLpOOYffrd1XWKAYQ39QhmChdPO_3-mw7kJrDpNgUUqfwl4',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 26, 20),
      appBar: TopBar(
        title: 'THE MARKET',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.coins),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "AVAILABLE NOTICES",
                style: GoogleFonts.epilogue(
                  color: const Color.fromARGB(200, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 2,
                width: 45,
                color: orangeText,
                margin: const EdgeInsets.only(bottom: 16),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  itemCount: wares.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final ware = wares[index];
                    return ShopCardModel(
                      rarity: ware['rarity'],
                      title: ware['title'],
                      stats: ware['stats'],
                      cost: ware['cost'],
                      imageUrl: ware['imageUrl'],
                      onPressed: () {},
                    );
                  },
                ),
              ),
            ),
            CustomBottomBar(currentIndex: 1, onTap: (int index) {}),
          ],
        ),
      ),
    );
  }
}
