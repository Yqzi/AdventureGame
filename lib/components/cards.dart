import 'package:flutter/material.dart';
import 'package:tes/colors.dart';

class CardModel extends StatelessWidget {
  final String rarity;
  final String title;
  final String description;
  final String cost;
  final ImageProvider? image;

  const CardModel({
    required this.rarity,
    required this.title,
    required this.description,
    required this.cost,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: borderGrey,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      height: MediaQuery.of(context).size.height / 4.5,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rarity,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(title),
                Text(description),
                Text(cost),
              ],
            ),
          ),
          // Image(image: image),
        ],
      ),
    );
  }
}
