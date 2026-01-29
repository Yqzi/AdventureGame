import 'package:flutter/material.dart';
import 'package:tes/pages/map_page.dart';
import 'package:tes/pages/start_page.dart';
import 'package:tes/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const MyHomePage());
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
    return MaterialApp(
      initialRoute: AppRouter.start,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
