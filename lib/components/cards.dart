import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/colors.dart';
import 'package:tes/models/item.dart';

enum Rarity { common, rare, epic, mythic }

extension RarityExtension on Rarity {
  String get label {
    switch (this) {
      case Rarity.common:
        return 'COMMON';
      case Rarity.rare:
        return 'RARE';
      case Rarity.epic:
        return 'EPIC';
      case Rarity.mythic:
        return 'MYTHIC';
    }
  }

  Color get color {
    switch (this) {
      case Rarity.common:
        return Colors.white;
      case Rarity.rare:
        return Colors.blue;
      case Rarity.epic:
        return Colors.purple;
      case Rarity.mythic:
        return Colors.red;
    }
  }
}

class ShopCardModel extends StatelessWidget {
  final Item item;
  final VoidCallback onPressed;
  final bool isSold;

  const ShopCardModel({
    required this.onPressed,
    super.key,
    required this.item,
    this.isSold = false,
  });

  static const double _cardHeight = 180;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      child: Opacity(
        opacity: isSold ? 0.45 : 1.0,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 30, 28),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  // Left accent strip
                  SizedBox(
                    width: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: item.rarity.color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  // Info column
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rarity badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: item.rarity.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.rarity.label.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.epilogue(
                                color: item.rarity.color,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Title
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.epilogue(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Stats – takes remaining space
                          Expanded(
                            child: Text(
                              item.statSummary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.epilogue(
                                color: greyText,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          // Buy button – anchored at bottom
                          SizedBox(
                            height: 36,
                            child: isSold
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'SOLD',
                                          style: GoogleFonts.epilogue(
                                            color: Colors.white38,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          FontAwesomeIcons.check,
                                          color: Colors.white38,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: onPressed,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: redText,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.priceLabel,
                                          style: GoogleFonts.epilogue(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          FontAwesomeIcons.cartShopping,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right side image / placeholder
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        item.type.icon,
                        style: const TextStyle(fontSize: 44),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SOLD banner overlay
            if (isSold)
              Positioned(
                top: 8,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(200, 60, 60, 60),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    'SOLD',
                    style: GoogleFonts.epilogue(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class QuestCardModel extends StatelessWidget {
  final String title;
  final String risk;
  final String description;
  final String reward;
  final VoidCallback onActionPressed;
  final String image;

  const QuestCardModel({
    required this.title,
    required this.risk,
    required this.description,
    required this.reward,
    required this.onActionPressed,
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardHeight = MediaQuery.of(context).size.height / 3;
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Color.fromARGB(255, 39, 30, 28),
        border: Border.all(color: Color.fromARGB(255, 51, 39, 37)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Image with fade
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: cardHeight,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: cardHeight / 3,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(image, fit: BoxFit.cover),
                        // Fog overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color.fromARGB(
                                  255,
                                  39,
                                  30,
                                  28,
                                ).withAlpha((0.28 * 255).toInt()),
                                const Color.fromARGB(
                                  255,
                                  39,
                                  30,
                                  28,
                                ).withAlpha((0.35 * 255).toInt()),
                                const Color.fromARGB(
                                  255,
                                  39,
                                  30,
                                  28,
                                ).withAlpha((0.20 * 255).toInt()),
                              ],
                              stops: [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color.fromARGB(255, 39, 30, 28),
                              ],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(color: Color.fromARGB(255, 39, 30, 28)),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: cardHeight / 3 - 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        title,
                        style: GoogleFonts.epilogue(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(255, 39, 30, 28),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              // controls the amount that are colored in
                              final color = index < 3
                                  ? redText
                                  : redText.withOpacity(0.4);
                              return Padding(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: Icon(
                                  FontAwesomeIcons
                                      .skull, // Requires Flutter 3.16+ for Material Icons
                                  color: color,
                                  size: 14,
                                ),
                              );
                            }),
                          ),
                          SizedBox(width: 8),
                          Text(
                            risk,
                            style: GoogleFonts.epilogue(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4,
                      ),
                      child: Text(
                        '"$description"',
                        style: GoogleFonts.epilogue(
                          color: greyText,
                          fontSize: 16,
                          letterSpacing: 1,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        height: 1,
                        color: Colors.white38,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "REWARD",
                                    style: GoogleFonts.epilogue(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: greyText,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.coins,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        reward,
                                        style: GoogleFonts.epilogue(
                                          color: Colors.amber,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            ElevatedButton(
                              onPressed: onActionPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: redText,
                                shadowColor: redText,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'ACCEPT QUEST',
                                style: GoogleFonts.epilogue(
                                  color: Colors.white,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PinnedCard extends StatelessWidget {
  final String title;
  final String risk;
  final String description;
  final String reward;
  final String image;
  final double transformationAngle;
  final VoidCallback onActionPressed;
  final String actionLabel;
  final IconData actionIcon;

  const PinnedCard({
    super.key,
    required this.title,
    required this.risk,
    required this.description,
    required this.reward,
    required this.image,
    required this.onActionPressed,
    required this.transformationAngle,
    this.actionLabel = 'Investigate',
    this.actionIcon = Icons.visibility,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: RepaintBoundary(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Transform.rotate(
              angle: transformationAngle, // subtle tilt
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE3D5B8),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            image,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.epilogue(
                              color: const Color(0xFF3E2723),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                'Difficulty: ',
                                style: GoogleFonts.epilogue(
                                  color: const Color(0xFF5D4037),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3E2723),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  risk.toUpperCase(),
                                  style: GoogleFonts.epilogue(
                                    color: const Color(0xFFE3D5B8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"$description"',
                            style: GoogleFonts.epilogue(
                              color: const Color(0xFF5D4037),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DottedBorder(
                            options: RectDottedBorderOptions(
                              color: Color(0xFFA1887F),
                              padding: EdgeInsets.zero,
                              dashPattern: const [3, 3],
                            ),
                            child: Container(height: 0),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'REWARD',
                                    style: GoogleFonts.epilogue(
                                      color: const Color(0xFF8D6E63),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    reward,
                                    style: GoogleFonts.epilogue(
                                      color: const Color(0xFFBD0F2C),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3E2723),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      4,
                                    ),
                                  ),
                                ),
                                onPressed: onActionPressed,
                                icon: Icon(
                                  actionIcon,
                                  size: 18,
                                  color: const Color(0xFFE3D5B8),
                                ),
                                label: Text(
                                  actionLabel,
                                  style: GoogleFonts.epilogue(
                                    color: const Color(0xFFE3D5B8),
                                    fontWeight: FontWeight.bold,
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
              ),
            ),
            Positioned(
              top: -8,
              left: MediaQuery.of(context).size.width / 2 - 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF8D6E63),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3E2723), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleQuestCard extends StatelessWidget {
  final String title;
  final String description;
  final String reward;
  final String image;
  final VoidCallback onActionPressed;

  const SimpleQuestCard({
    super.key,
    required this.title,
    required this.description,
    required this.reward,
    required this.image,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF2D2320),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.3),
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey, size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.epilogue(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.epilogue(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reward,
                          style: GoogleFonts.epilogue(
                            color: Colors.amber,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: onActionPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Enter',
                        style: GoogleFonts.epilogue(
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
