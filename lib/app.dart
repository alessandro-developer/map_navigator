import 'package:flutter/material.dart';
import 'package:map_navigator/presentation.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Map Navigator Demo', home: const HomePage());
  }
}
