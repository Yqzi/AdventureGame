import 'package:flutter/material.dart';
import 'package:Questborne/blocs/app/app_bloc.dart';
import 'package:Questborne/config/supabase_config.dart';
import 'package:Questborne/router.dart';
import 'package:Questborne/services/settings_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Questborne/services/ai_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  await SettingsService().init();
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
      child: MaterialApp(
        title: 'Questborne',
        initialRoute: AppRouter.start,
        onGenerateRoute: AppRouter.onGenerateRoute,
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
