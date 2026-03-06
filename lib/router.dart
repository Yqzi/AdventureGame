import 'package:Questborne/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:Questborne/pages/game_page.dart';
import 'package:Questborne/pages/guild_page.dart';
import 'package:Questborne/pages/inventory_page.dart';
import 'package:Questborne/pages/map_page.dart';
import 'package:Questborne/pages/world_explore_page.dart';
import 'package:Questborne/pages/shop_page.dart';
import 'package:Questborne/pages/start_page.dart';
import 'package:Questborne/pages/subscription_page.dart';

class AppRouter {
  static const start = '/start';
  static const map = '/map';
  static const inventory = '/inventory';
  static const game = '/game';
  static const guild = '/guild';
  static const shop = '/shop';
  static const worldExplore = '/worldExplore';
  static const settingsPage = '/settings';
  static const subscription = '/subscription';

  static Route<dynamic> _noAnim(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, __, ___, child) => child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case start:
        return _noAnim(const StartPage(), settings);
      case map:
        return _noAnim(const MapPage(), settings);
      case inventory:
        return _noAnim(const InventoryPage(), settings);
      case game:
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return _noAnim(
          GamePage(
            details: args['details'],
            resume: args['resume'] == true,
            questId: args['questId'] as String?,
          ),
          settings,
        );
      case guild:
        return _noAnim(GuildPage(), settings);
      case shop:
        return _noAnim(const ShopPage(), settings);
      case worldExplore:
        return _noAnim(const WorldExplorationPage(), settings);
      case settingsPage:
        return _noAnim(const SettingsPage(), settings);
      case subscription:
        return _noAnim(const SubscriptionPage(), settings);
      default:
        return _noAnim(
          const Scaffold(body: Center(child: Text('404 – Page not found'))),
          settings,
        );
    }
  }
}
