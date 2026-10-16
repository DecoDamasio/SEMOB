import 'package:flutter/material.dart';

class OperacaoPage extends StatelessWidget {
  const OperacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cabecalho(),

            const SizedBox(height: 20),

            _cardsResumo(),

            const SizedBox(height: 20),

            _tabelaLinhas(),

            const SizedBox(height: 26),

            _rodape(),
          ],
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACOMPANHAMENTO EM TEMPO REAL',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1554C0),
            letterSpacing: 0.3,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Operação',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF071A33),
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Situação das linhas, veículos e viagens programadas para hoje.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF60738F),
          ),
        ),

        const SizedBox(height: 20),

        Container(
          height: 1,
          color: const Color(0xFFD0DAE6),
        ),
      ],
    );
  }

  Widget _cardsResumo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = (constraints.maxWidth - 45) / 4;

        if (constraints.maxWidth < 900) {
          return Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              _cardResumo(
                largura: constraints.maxWidth > 600
                    ? (constraints.maxWidth - 15) / 2
                    : constraints.maxWidth,
                icone: Icons.directions_bus_outlined,
                cor: const Color(0xFFEAF2FF),
                corIcone: const Color(0xFF1554C0),
                titulo: 'Veículos em operação',
                valor: '38',
                descricao: 'de 42 disponíveis',
              ),
              _cardResumo(
                largura: constraints.maxWidth > 600
                    ? (constraints.maxWidth - 15) / 2
                    : constraints.maxWidth,
                icone: Icons.directions_bus_outlined,
                cor: const Color(0xFFEAF9F2),
                corIcone: const Color(0xFF079455),
                titulo: 'Viagens concluídas',
                valor: '1.156',
                descricao: '90% das programadas',
              ),
              _cardResumo(
                largura: constraints.maxWidth > 600
                    ? (constraints.maxWidth - 15) / 2
                    : constraints.maxWidth,
                icone: Icons.access_time,
                cor: const Color(0xFFFFF8E8),
                corIcone: const Color(0xFFE68A00),
                titulo: 'Pontualidade média',
                valor: '93,4%',
                descricao: 'meta municipal: 95%',
              ),
              _cardResumo(
                largura: constraints.maxWidth > 600
                    ? (constraints.maxWidth - 15) / 2
                    : constraints.maxWidth,
                icone: Icons.warning_amber_outlined,
                cor: const Color(0xFFFFF0F0),
                corIcone: const Color(0xFFE31B23),
                titulo: 'Ocorrências abertas',
                valor: '3',
                descricao: '1 ocorrência prioritária',
              ),
            ],
          );
        }

        return Row(
          children: [
            SizedBox(
              width: largura,
              child: _cardResumo(
                largura: largura,
                icone: Icons.directions_bus_outlined,
                cor: const Color(0xFFEAF2FF),
                corIcone: const Color(0xFF1554C0),
                titulo: 'Veículos em operação',
                valor: '38',
                descricao: 'de 42 disponíveis',
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: largura,
              child: _cardResumo(
                largura: largura,
                icone: Icons.directions_bus_outlined,
                cor: const Color(0xFFEAF9F2),
                corIcone: const Color(0xFF079455),
                titulo: 'Viagens concluídas',
                valor: '1.156',
                descricao: '90% das programadas',
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: largura,
              child: _cardResumo(
                largura: largura,
                icone: Icons.access_time,
                cor: const Color(0xFFFFF8E8),
                corIcone: const Color(0xFFE68A00),
                titulo: 'Pontualidade média',
                valor: '93,4%',
                descricao: 'meta municipal: 95%',
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: largura,
              child: _cardResumo(
                largura: largura,
                icone: Icons.warning_amber_outlined,
                cor: const Color(0xFFFFF0F0),
                corIcone: const Color(0xFFE31B23),
                titulo: 'Ocorrências abertas',
                valor: '3',
                descricao: '1 ocorrência prioritária',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _cardResumo({
    required double largura,
    required IconData icone,
    required Color cor,
    required Color corIcone,
    required String titulo,
    required String valor,
    required String descricao,
  }) {
    return Container(
      width: largura,
      height: 145,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD8E0EA),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icone,
              size: 18,
              color: corIcone,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            titulo,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF536783),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            valor,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF071A33),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            descricao,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF7185A1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabelaLinhas() {
    final linhas = [
      {
        'linha': '01 — Circular Centro',
        'veiculo': 'SCS-1024',
        'viagens': '42 / 44',
        'pontualidade': '96%',
        'ocupacao': 74,
        'situacao': 'Em operação',
      },
      {
        'linha': '03 — Barcelona / Centro',
        'veiculo': 'SCS-1018',
        'viagens': '36 / 36',
        'pontualidade': '98%',
        'ocupacao': 62,
        'situacao': 'Em operação',
      },
      {
        'linha': '04 — Nova Gerty / Centro',
        'veiculo': 'SCS-1031',
        'viagens': '31 / 34',
        'pontualidade': '91%',
        'ocupacao': 88,
        'situacao': 'Atenção',
      },
      {
        'linha': '07 — Prosperidade / Centro',
        'veiculo': 'SCS-1009',
        'viagens': '28 / 30',
        'pontualidade': '93%',
        'ocupacao': 55,
        'situacao': 'Em operação',
      },
      {
        'linha': '11 — Santa Maria / Centro',
        'veiculo': 'SCS-1027',
        'viagens': '18 / 24',
        'pontualidade': '82%',
        'ocupacao': 41,
        'situacao': 'Atraso',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD8E0EA),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _cabecalhoTabela(),

          const Divider(
            height: 1,
            color: Color(0xFFDCE4ED),
          ),

          _cabecalhoColunas(),

          ...linhas.map(
            (linha) => _linhaTabela(linha),
          ),
        ],
      ),
    );
  }

  Widget _cabecalhoTabela() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 15, 17, 13),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Linhas municipais',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF071A33),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Atualização demonstrativa às 10:30',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7185A1),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFC9D5E5),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                _filtro('Todas', true),
                _filtro('Atenção', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filtro(String texto, bool selecionado) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selecionado
            ? const Color(0xFFF1F6FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 10,
          color: selecionado
              ? const Color(0xFF1554C0)
              : const Color(0xFF536783),
          fontWeight:
              selecionado ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _cabecalhoColunas() {
    return Container(
      height: 36,
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: _TituloColuna('LINHA'),
          ),
          Expanded(
            flex: 1.4,
            child: _TituloColuna('VEÍCULO'),
          ),
          Expanded(
            flex: 1.3,
            child: _TituloColuna('VIAGENS'),
          ),
          Expanded(
            flex: 1.7,
            child: _TituloColuna('PONTUALIDADE'),
          ),
          Expanded(
            flex: 2,
            child: _TituloColuna('OCUPAÇÃO'),
          ),
          Expanded(
            flex: 1.7,
            child: _TituloColuna('SITUAÇÃO'),
          ),
        ],
      ),
    );
  }

  Widget _linhaTabela(Map<String, dynamic> dados) {
    final ocupacao = dados['ocupacao'] as int;
    final situacao = dados['situacao'] as String;

    Color corBarra = const Color(0xFF1554C0);

    if (ocupacao >= 80) {
      corBarra = const Color(0xFFFF9800);
    }

    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE4EAF1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              dados['linha'],
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF071A33),
              ),
            ),
          ),

          Expanded(
            flex: 1.4,
            child: Text(
              dados['veiculo'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF526985),
              ),
            ),
          ),

          Expanded(
            flex: 1.3,
            child: Text(
              dados['viagens'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF526985),
              ),
            ),
          ),

          Expanded(
            flex: 1.7,
            child: Text(
              dados['pontualidade'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF526985),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 66,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDF3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: ocupacao / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: corBarra,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 7),

                Text(
                  '$ocupacao%',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF526985),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 1.7,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _status(situacao),
            ),
          ),
        ],
      ),
    );
  }

  Widget _status(String status) {
    Color fundo;
    Color texto;

    switch (status) {
      case 'Atenção':
        fundo = const Color(0xFFFFF6E5);
        texto = const Color(0xFFE58300);
        break;

      case 'Atraso':
        fundo = const Color(0xFFFFEEEE);
        texto = const Color(0xFFD9272E);
        break;

      default:
        fundo = const Color(0xFFE7F9F1);
        texto = const Color(0xFF078A50);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: texto,
        ),
      ),
    );
  }

  Widget _rodape() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFD8E0EA),
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SEMOB-SCS — Secretaria de Mobilidade Urbana de São Caetano do Sul',
            style: TextStyle(
              fontSize: 9,
              color: Color(0xFF58708F),
            ),
          ),
          Text(
            'Dados demonstrativos • Atualizado em 18/06/2025 às 10:30',
            style: TextStyle(
              fontSize: 9,
              color: Color(0xFF58708F),
            ),
          ),
        ],
      ),
    );
  }
}

class _TituloColuna extends StatelessWidget {
  final String texto;

  const _TituloColuna(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: Color(0xFF526985),
      ),
    );
  }
}