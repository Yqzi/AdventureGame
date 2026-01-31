import 'package:flutter/material.dart';
import 'package:tes/pages/inventory_page.dart';
import 'package:tes/pages/map_page.dart';
import 'package:tes/pages/start_page.dart';

class AppRouter {
  static const start = '/start';
  static const map = '/map';
  static const inventory = '/inventory';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return MaterialPageRoute(builder: (_) => const StartPage());
      case map:
        return MaterialPageRoute(builder: (_) => const MapPage());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 – Page not found'))),
        );
    }
  }
}
