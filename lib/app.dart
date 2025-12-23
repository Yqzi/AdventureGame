import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app/app_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AppBloc())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(),
      ),
    );
  }
}
