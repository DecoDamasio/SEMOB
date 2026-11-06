import 'package:flutter/material.dart';

import '../theme/tema.dart';
import '../utils/formatacao.dart';

class KpiCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icone;
  final Color corIcone;

  /// Variação relativa ao período anterior (0.032 = +3,2%).
  final double? variacao;

  /// Texto exibido no lugar da variação.
  final String? descricao;

  /// Mostra a variação em pontos percentuais em vez de %.
  final bool variacaoEmPontos;

  const KpiCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icone,
    this.corIcone = Cores.serie1,
    this.variacao,
    this.descricao,
    this.variacaoEmPontos = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: decoracaoCartao,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  titulo.toUpperCase(),
                  style: Estilos.rotuloKpi,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: corIcone.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icone, size: 18, color: corIcone),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(valor, style: Estilos.valorKpi),
          ),
          const SizedBox(height: 8),
          _rodape(),
        ],
      ),
    );
  }

  Widget _rodape() {
    if (variacao == null) {
      return Text(
        descricao ?? 'sem dados do período anterior',
        style: const TextStyle(fontSize: 11.5, color: Cores.textoMudo),
      );
    }

    final subiu = variacao! >= 0;
    final cor = subiu ? Cores.sucesso : Cores.critico;
    final texto = variacaoEmPontos
        ? '${formatarDecimal((variacao! * 100).abs())} p.p.'
        : formatarPercentual(variacao!.abs());

    return Row(
      children: [
        Icon(
          subiu ? Icons.north_east : Icons.south_east,
          size: 13,
          color: cor,
        ),
        const SizedBox(width: 3),
        Text(
          texto,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: cor,
          ),
        ),
        const SizedBox(width: 4),
        const Flexible(
          child: Text(
            'vs. período anterior',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11.5, color: Cores.textoMudo),
          ),
        ),
      ],
    );
  }
}

/// Distribui os cards em colunas iguais conforme a largura disponível.
class GradeKpis extends StatelessWidget {
  final List<Widget> cards;

  const GradeKpis({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    const espaco = 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        final colunas = largura >= 1000
            ? cards.length
            : largura >= 640
                ? (cards.length / 2).ceil()
                : 1;
        final larguraCard = (largura - espaco * (colunas - 1)) / colunas;

        return Wrap(
          spacing: espaco,
          runSpacing: espaco,
          children: cards
              .map((card) => SizedBox(width: larguraCard, child: card))
              .toList(),
        );
      },
    );
  }
}

final decoracaoCartao = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Cores.borda),
  boxShadow: const [
    BoxShadow(
      color: Color(0x0A0F1F33),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ],
);
