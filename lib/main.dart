import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'theme/tema.dart';

void main() {
  runApp(const SemobApp());
}

class SemobApp extends StatelessWidget {
  const SemobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SEMOB-SCS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Cores.primaria),
        scaffoldBackgroundColor: Cores.fundo,
      ),
      home: const HomePage(),
    );
  }
}
