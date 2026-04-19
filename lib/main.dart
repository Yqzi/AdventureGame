import 'package:flutter/material.dart';
import 'package:Questborne/blocs/app/app_bloc.dart';
import 'package:Questborne/config/supabase_config.dart';
import 'package:Questborne/router.dart';
import 'package:Questborne/services/settings_service.dart';
import 'package:Questborne/services/purchase_service.dart';
import 'package:Questborne/services/subscription_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Questborne/l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Questborne/services/ai_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Global notifier so any widget can trigger a locale change at runtime.
final ValueNotifier<Locale?> localeNotifier = ValueNotifier<Locale?>(
  SettingsService().locale,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SettingsService().init();
  // Pre-load subscription tier so it's available immediately.
  await SubscriptionService().fetch();
  // Init Play Store billing (loads products, listens for pending purchases).
  await PurchaseService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GameBloc(aiService: AIService())),
      ],
      child: ValueListenableBuilder<Locale?>(
        valueListenable: localeNotifier,
        builder: (context, locale, _) {
          return MaterialApp(
            title: 'Questborne',
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            localeResolutionCallback: (deviceLocale, supported) {
              if (locale != null) return locale;
              for (final s in supported) {
                if (s.languageCode == deviceLocale?.languageCode) return s;
              }
              return const Locale('en');
            },
            initialRoute: AppRouter.splash,
            onGenerateRoute: AppRouter.onGenerateRoute,
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: const _NoStretchScrollBehavior(),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Replace with your actual home page content, e.g., Scaffold or StartPage
    return const Scaffold(
      body: Center(child: Text('Home Page')), // Placeholder
    );
  }
}

class _NoStretchScrollBehavior extends ScrollBehavior {
  const _NoStretchScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
