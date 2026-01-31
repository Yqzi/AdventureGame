import 'package:flutter/material.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/top_bar.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'title'),
      body: Container(color: brownBackground),
    );
  }
}
