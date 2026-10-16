import 'package:flutter/material.dart';

import 'operacao_page.dart';

import '../widgets/app_header.dart';
import '../widgets/horizontal_menu.dart';
import '../widgets/summary_card.dart';
import '../widgets/movement_chart.dart';
import '../widgets/recent_activity.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int menuSelecionado = 0;

  final List<String> menus = [
    'Dashboard',
    'Operação',
    'Análises',
    'Relatórios',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppHeader(),

          Row(
  children: [
    TextButton(
      onPressed: () {
        setState(() {
          menuSelecionado = 0;
        });
      },
      child: const Text('Dashboard'),
    ),
    TextButton(
      onPressed: () {
        setState(() {
          menuSelecionado = 1;
        });
      },
      child: const Text('OPERAÇÃO'),
    ),
    TextButton(
      onPressed: () {
        setState(() {
          menuSelecionado = 2;
        });
      },
      child: const Text('Análises'),
    ),
    TextButton(
      onPressed: () {
        setState(() {
          menuSelecionado = 3;
        });
      },
      child: const Text('Relatórios'),
    ),
  ],
),

          Expanded(
            child: _conteudo(),
          ),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (menuSelecionado == 0) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _dashboard(),
      );
    }

    if (menuSelecionado == 1) {
  return const OperacaoPage();
}

    return Center(
      child: Text(
        menus[menuSelecionado],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _dashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Visão geral da mobilidade urbana',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 22),

        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: const [
            SummaryCard(
              titulo: 'Passageiros',
              valor: '--',
            ),
            SummaryCard(
              titulo: 'Veículos ativos',
              valor: '--',
            ),
            SummaryCard(
              titulo: 'Linhas em operação',
              valor: '--',
            ),
            SummaryCard(
              titulo: 'Ocorrências',
              valor: '--',
            ),
          ],
        ),

        const SizedBox(height: 22),

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MovementChart(),
                  SizedBox(height: 18),
                  RecentActivity(),
                ],
              );
            }

            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: MovementChart(),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: RecentActivity(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}