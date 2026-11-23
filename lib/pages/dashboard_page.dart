
import 'package:flutter/material.dart';

import 'operacao_page.dart';

import '../widgets/app_header.dart';
import '../widgets/side_menu.dart';
import '../widgets/dashboard_indicator.dart';
import '../widgets/passengers_panel.dart';
import '../widgets/alerts_panel.dart';
import '../widgets/period_summary.dart';
import '../widgets/operation_chart.dart';

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
      backgroundColor: const Color(0xFFF4F7FA),
      body: Column(
        children: [
          // mantém o cabeçalho original
          const AppHeader(),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SideMenu(
                  menuSelecionado: menuSelecionado,
                  onMenuSelected: (index) {
                    setState(() {
                      menuSelecionado = index;
                    });
                  },
                ),

                Expanded(
                  child: _conteudo(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (menuSelecionado == 0) {
      return _dashboard();
    }

    if (menuSelecionado == 1) {
      return const OperacaoPage();
    }

    return Center(
      child: Text(
        menus[menuSelecionado],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF183B63),
        ),
      ),
    );
  }

  Widget _dashboard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool compacto = constraints.maxWidth < 950;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cabecalhoDashboard(),

              const SizedBox(height: 14),

              const Text(
                'Indicadores principais',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF163D68),
                ),
              ),

              const SizedBox(height: 8),

              _indicadores(compacto),

              const SizedBox(height: 12),

              if (compacto)
                const Column(
                  children: [
                    OperationChart(),
                    SizedBox(height: 12),
                    PassengersPanel(),
                  ],
                )
              else
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: OperationChart(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: PassengersPanel(),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              if (compacto)
                const Column(
                  children: [
                    AlertsPanel(),
                    SizedBox(height: 12),
                    PeriodSummary(),
                  ],
                )
              else
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AlertsPanel(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: PeriodSummary(),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _cabecalhoDashboard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PAINEL OPERACIONAL',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1855C9),
                  letterSpacing: .3,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Visão geral',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Indicadores atualizados para o período selecionado.',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 15),

        _filtrosPeriodo(),
      ],
    );
  }

  Widget _filtrosPeriodo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Período da análise',
          style: TextStyle(
            fontSize: 7,
            color: Color(0xFF64748B),
          ),
        ),

        const SizedBox(height: 4),

        Row(
          children: [
            _periodoButton('Diário', true),
            _periodoButton('Semanal', false),
            _periodoButton('Mensal', false),

            const SizedBox(width: 8),

            Container(
              height: 28,
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFD6DEE8),
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 10,
                    color: Color(0xFF55708F),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '18/06/2025',
                    style: TextStyle(
                      fontSize: 8,
                      color: Color(0xFF334155),
                    ),
                  ),
                  SizedBox(width: 14),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 13,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 3),

        const Text(
          'Hoje, 18 de junho de 2025',
          style: TextStyle(
            fontSize: 7,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _periodoButton(
    String texto,
    bool selecionado,
  ) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: selecionado
            ? const Color(0xFF1554C0)
            : Colors.white,
        border: Border.all(
          color: const Color(0xFFD6DEE8),
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.center,
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w500,
          color: selecionado
              ? Colors.white
              : const Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _indicadores(bool compacto) {
    final cards = [
      const DashboardIndicator(
        icon: Icons.route,
        title: 'Quilometragem',
        value: '12.450',
        unit: 'km',
        variation: '+2,4%',
        positive: true,
      ),
      const DashboardIndicator(
        icon: Icons.directions_bus_outlined,
        title: 'Viagens realizadas',
        value: '1.284',
        unit: 'viagens',
        variation: '-4,8%',
        positive: false,
      ),
      const DashboardIndicator(
        icon: Icons.people_outline,
        title: 'Passageiros pagantes',
        value: '38.520',
        unit: 'passageiros',
        variation: '+3,1%',
        positive: true,
      ),
      const DashboardIndicator(
        icon: Icons.person_outline,
        title: 'Não pagantes',
        value: '4.210',
        unit: 'passageiros',
        variation: '+0,8%',
        positive: true,
      ),
      const DashboardIndicator(
        icon: Icons.payments_outlined,
        title: 'Receita registrada',
        value: 'R\$ 186.420',
        unit: 'valor bruto registrado',
        variation: '+2,7%',
        positive: true,
      ),
    ];

    if (compacto) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: cards,
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 8),
        Expanded(child: cards[1]),
        const SizedBox(width: 8),
        Expanded(child: cards[2]),
        const SizedBox(width: 8),
        Expanded(child: cards[3]),
        const SizedBox(width: 8),
        Expanded(child: cards[4]),
      ],
    );
  }
}
