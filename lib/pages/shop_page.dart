import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FIX IMAGE FADE TO BACKGROUND
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuClCOV1kVgcBq2-51nor8G1KJ9OrPiMBmX2p1dNs7B6deOoAuD4Hv86MmkBWquDJzN7Ej0bxR2Jt6-8EcUwZl2UdGU6IHhOhpyH7VzQ-708aIvzHmlf7APrNgJJ8zUucA6jvPVqC560j9FP67Unt371jTsTcyUrcFXS1GMCy-Qyx91RY56h_6evt8EPVC8_3TksYGwZKowLgqvE39GGpcaTZ_h9Qk59AN-VTwpl5SwVI5y6cZDYer4xFhDJP99jAhN_DPtcJrpCMCY',
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment(0, -0.5),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color.fromARGB(255, 41, 26, 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          border: Border.all(color: Colors.white38),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          '"Choose wisely, traveler. My wares cost more than just gold..."',
                          style: GoogleFonts.epilogue(
                            color: Colors.white60,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Merchant's Wares",
                    style: GoogleFonts.epilogue(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "STOCK: ${wares.length}",
                    style: GoogleFonts.epilogue(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
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
            CustomBottomBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}
