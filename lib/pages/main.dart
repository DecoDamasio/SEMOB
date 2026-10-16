import 'package:flutter/material.dart';

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
          _topo(),
          _menuHorizontal(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _conteudo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topo() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E5E9),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.directions_bus,
            color: Color(0xFF1554C0),
            size: 30,
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SEMOB-SCS',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Mobilidade Urbana',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            'Administrador',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuHorizontal() {
    return Container(
      height: 52,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            menus.length,
            (index) {
              final selecionado = menuSelecionado == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    menuSelecionado = index;
                  });
                },
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selecionado
                            ? const Color(0xFF1554C0)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      menus[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: selecionado
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: selecionado
                            ? const Color(0xFF1554C0)
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _conteudo() {
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
          children: [
            _cardResumo(
              'Passageiros',
              '--',
            ),
            _cardResumo(
              'Veículos ativos',
              '--',
            ),
            _cardResumo(
              'Linhas em operação',
              '--',
            ),
            _cardResumo(
              'Ocorrências',
              '--',
            ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _grafico(),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: _atividade(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardResumo(
    String titulo,
    String valor,
  ) {
    return Container(
      width: 230,
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFE1E4E8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _grafico() {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFE1E4E8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Movimentação',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Dados de movimentação',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _barraGrafico(70),
                _barraGrafico(110),
                _barraGrafico(85),
                _barraGrafico(130),
                _barraGrafico(95),
                _barraGrafico(120),
                _barraGrafico(75),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraGrafico(double altura) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: altura,
            width: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE7F8),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _atividade() {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFE1E4E8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atividade recente',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          _atividadeItem('Sem dados disponíveis'),
          const Divider(),
          _atividadeItem('Nenhuma ocorrência registrada'),
          const Divider(),
          _atividadeItem('Aguardando atualização'),
        ],
      ),
    );
  }

  Widget _atividadeItem(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}