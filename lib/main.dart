import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tes/services/ai_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp()); // Replace MyApp with your actual root widget
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
        title: 'Flutter Demo',
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
