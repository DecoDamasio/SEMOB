import 'package:flutter/material.dart';

import 'pages/dashboard_page.dart';
import 'pages/operacao_page.dart';

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
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF5F6F8),
      ),
      home: const DashboardPage(),
    );
  }
}