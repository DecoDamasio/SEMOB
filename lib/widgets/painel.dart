import 'package:flutter/material.dart';

import '../theme/tema.dart';
import 'kpi_card.dart';

/// Cartão branco com título e subtítulo, usado por gráficos e tabelas.
class Painel extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final Widget? acao;
  final Widget child;

  /// Remove o espaçamento lateral do conteúdo (tabelas encostam na borda).
  final bool conteudoSemMargem;

  const Painel({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.acao,
    required this.child,
    this.conteudoSemMargem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: decoracaoCartao,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: Estilos.tituloPainel),
                      if (subtitulo != null) ...[
                        const SizedBox(height: 3),
                        Text(subtitulo!, style: Estilos.subtituloPainel),
                      ],
                    ],
                  ),
                ),
                ?acao,
              ],
            ),
          ),
          Padding(
            padding: conteudoSemMargem
                ? EdgeInsets.zero
                : const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Painel principal (2/3) ao lado de um painel lateral (1/3); empilha em telas estreitas.
class LinhaPaineis extends StatelessWidget {
  final Widget principal;
  final Widget lateral;

  const LinhaPaineis({
    super.key,
    required this.principal,
    required this.lateral,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              principal,
              const SizedBox(height: 16),
              lateral,
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: principal),
              const SizedBox(width: 16),
              Expanded(child: lateral),
            ],
          ),
        );
      },
    );
  }
}

/// Mensagem para quando não há o que mostrar.
class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String texto;

  const EstadoVazio({
    super.key,
    required this.icone,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(icone, color: Cores.textoMudo, size: 28),
          const SizedBox(height: 8),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, color: Cores.textoSecundario),
          ),
        ],
      ),
    );
  }
}
