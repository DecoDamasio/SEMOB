import 'package:flutter/material.dart';

import '../theme/tema.dart';

class ColunaTabela {
  final String titulo;
  final int flex;
  final bool alinharDireita;

  const ColunaTabela(
    this.titulo, {
    this.flex = 1,
    this.alinharDireita = false,
  });
}

/// Tabela simples; rola na horizontal quando a tela é mais estreita que [larguraMinima].
class Tabela extends StatelessWidget {
  final List<ColunaTabela> colunas;
  final List<List<Widget>> linhas;
  final double larguraMinima;

  const Tabela({
    super.key,
    required this.colunas,
    required this.linhas,
    this.larguraMinima = 820,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth < larguraMinima
            ? larguraMinima
            : constraints.maxWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: largura,
            child: Column(
              children: [
                Container(
                  height: 40,
                  color: Cores.cabecalhoTabela,
                  child: _linha(
                    colunas
                        .map(
                          (coluna) => Text(
                            coluna.titulo.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: Cores.textoSecundario,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                ...linhas.map(
                  (celulas) => Container(
                    height: 52,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Cores.grade),
                      ),
                    ),
                    child: _linha(celulas),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _linha(List<Widget> celulas) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(colunas.length, (index) {
          final coluna = colunas[index];
          return Expanded(
            flex: coluna.flex,
            child: Align(
              alignment: coluna.alinharDireita
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: celulas[index],
            ),
          );
        }),
      ),
    );
  }
}
