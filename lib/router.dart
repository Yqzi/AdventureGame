import 'package:Questborne/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:Questborne/pages/game_page.dart';
import 'package:Questborne/pages/guild_page.dart';
import 'package:Questborne/pages/inventory_page.dart';
import 'package:Questborne/pages/map_page.dart';
import 'package:Questborne/pages/world_explore_page.dart';
import 'package:Questborne/pages/shop_page.dart';
import 'package:Questborne/pages/start_page.dart';

class AppRouter {
  static const start = '/start';
  static const map = '/map';
  static const inventory = '/inventory';
  static const game = '/game';
  static const guild = '/guild';
  static const shop = '/shop';
  static const worldExplore = '/worldExplore';
  static const settingsPage = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case start:
        return MaterialPageRoute(builder: (_) => const StartPage());
      case map:
        return MaterialPageRoute(builder: (_) => const MapPage());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryPage());
      case game:
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) {
            return GamePage(
              details: args['details'],
              resume: args['resume'] == true,
              questId: args['questId'] as String?,
            );
          },
        );
      case guild:
        return MaterialPageRoute(builder: (_) => GuildPage());
      case shop:
        return MaterialPageRoute(builder: (_) => const ShopPage());
      case worldExplore:
        return MaterialPageRoute(builder: (_) => const WorldExplorationPage());
      case settingsPage:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 – Page not found'))),
        );
    }
  }
}
