import 'package:flutter/material.dart';

import '../theme/tema.dart';

class AbaMenu {
  final String rotulo;
  final IconData icone;

  const AbaMenu(this.rotulo, this.icone);
}

class AppHeader extends StatelessWidget {
  final List<AbaMenu> abas;
  final int abaSelecionada;
  final ValueChanged<int> onSelecionarAba;

  /// Texto da situação dos dados, ex.: "Dados até 30/10". Null enquanto carrega.
  final String? situacaoDados;
  final bool erro;

  const AppHeader({
    super.key,
    required this.abas,
    required this.abaSelecionada,
    required this.onSelecionarAba,
    this.situacaoDados,
    this.erro = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Cores.primaria,
      child: Column(
        children: [
          _Centralizado(
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.directions_bus_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SEMOB-SCS',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Inteligência de Mobilidade',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFC9D8EC),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _situacao(compacto: MediaQuery.sizeOf(context).width < 640),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          _Centralizado(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: abas.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (context, index) => _aba(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Em telas estreitas mostra só o indicador colorido, com o texto na dica.
  Widget _situacao({required bool compacto}) {
    final Color cor;
    final String titulo;

    if (erro) {
      cor = const Color(0xFFFF8A80);
      titulo = 'API indisponível';
    } else if (situacaoDados == null) {
      cor = const Color(0xFFC9D8EC);
      titulo = 'Carregando...';
    } else {
      cor = const Color(0xFF3DDC97);
      titulo = 'Sistema operacional';
    }

    final indicador = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: cor,
        shape: BoxShape.circle,
      ),
    );

    if (compacto) {
      return Tooltip(
        message: [titulo, ?situacaoDados].join(' · '),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: indicador,
        ),
      );
    }

    return Row(
      children: [
        indicador,
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (situacaoDados != null)
              Text(
                situacaoDados!,
                style: const TextStyle(
                  color: Color(0xFFC9D8EC),
                  fontSize: 10.5,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _aba(int index) {
    final aba = abas[index];
    final selecionada = index == abaSelecionada;
    final cor = selecionada ? Colors.white : const Color(0xFFC9D8EC);

    return InkWell(
      onTap: () => onSelecionarAba(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selecionada ? Colors.white : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(aba.icone, size: 16, color: cor),
            const SizedBox(width: 7),
            Text(
              aba.rotulo,
              style: TextStyle(
                color: cor,
                fontSize: 13,
                fontWeight: selecionada ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Centralizado extends StatelessWidget {
  final Widget child;

  const _Centralizado({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        ),
      ),
    );
  }
}
