import 'package:flutter/material.dart';
import 'package:tes/pages/game_page.dart';
import 'package:tes/pages/guild_page.dart';
import 'package:tes/pages/inventory_page.dart';
import 'package:tes/pages/map_page.dart';
import 'package:tes/pages/world_explore_page.dart';
import 'package:tes/pages/sanctum_page.dart';
import 'package:tes/pages/shop_page.dart';
import 'package:tes/pages/start_page.dart';

class AppRouter {
  static const start = '/start';
  static const map = '/map';
  static const inventory = '/inventory';
  static const game = '/game';
  static const guild = '/guild';
  static const shop = '/shop';
  static const sanctum = '/sanctum';
  static const worldExplore = '/worldExplore';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return MaterialPageRoute(builder: (_) => const StartPage());
      case map:
        return MaterialPageRoute(builder: (_) => const MapPage());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryPage());
      case game:
        return MaterialPageRoute(builder: (_) => const GamePage());
      case guild:
        return MaterialPageRoute(builder: (_) => GuildPage());
      case shop:
        return MaterialPageRoute(builder: (_) => const ShopPage());
      case sanctum:
        return MaterialPageRoute(builder: (_) => const SanctumPage());
      case worldExplore:
        return MaterialPageRoute(builder: (_) => const WorldExplorationPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 – Page not found'))),
        );
    }
  }
}
