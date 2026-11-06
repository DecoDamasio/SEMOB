import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/tema.dart';
import 'grafico_linhas.dart';
import 'legenda.dart';

/// Barras verticais empilhadas para contagens inteiras (ex.: anomalias por dia).
class GraficoBarrasEmpilhadas extends StatelessWidget {
  final List<SerieGrafico> camadas;
  final List<String> rotulosEixo;
  final List<String> rotulosDica;
  final double altura;

  const GraficoBarrasEmpilhadas({
    super.key,
    required this.camadas,
    required this.rotulosEixo,
    required this.rotulosDica,
    this.altura = 230,
  });

  @override
  Widget build(BuildContext context) {
    final pontos = rotulosEixo.length;
    final totais = List.generate(
      pontos,
      (i) => camadas.fold<double>(0, (soma, c) => soma + c.valores[i]),
    );
    final maiorTotal = totais.fold<double>(0, max);
    final intervalo = maiorTotal <= 4 ? 1.0 : (maiorTotal / 4).ceilToDouble();
    final maxY = max(4.0, intervalo * 4);
    final passoRotulo = (pontos / 10).ceil();
    final larguraBarra = pontos > 15 ? 10.0 : 28.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Legenda(
          itens: camadas.map((c) => ItemLegenda(c.nome, c.cor)).toList(),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: altura,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: intervalo,
                getDrawingHorizontalLine: (_) => const FlLine(
                  color: Cores.grade,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: intervalo,
                    getTitlesWidget: (valor, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(valor.toInt().toString(), style: Estilos.eixo),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    getTitlesWidget: (valor, meta) {
                      final indice = valor.toInt();
                      if (indice % passoRotulo != 0) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(rotulosEixo[indice], style: Estilos.eixo),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Cores.texto,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItem: (grupo, _, _, _) => BarTooltipItem(
                    rotulosDica[grupo.x],
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                    textAlign: TextAlign.left,
                    children: camadas
                        .map(
                          (camada) => TextSpan(
                            text:
                                '\n${camada.nome}: ${camada.valores[grupo.x].toInt()}',
                            style: const TextStyle(
                              color: Color(0xFFDCE4EE),
                              fontWeight: FontWeight.w500,
                              fontSize: 11.5,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              barGroups: List.generate(pontos, (i) {
                var base = 0.0;
                final pilha = <BarChartRodStackItem>[];
                for (final camada in camadas) {
                  final valor = camada.valores[i];
                  if (valor > 0) {
                    pilha.add(BarChartRodStackItem(base, base + valor, camada.cor));
                    base += valor;
                  }
                }

                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: totais[i],
                      width: larguraBarra,
                      color: Cores.grade,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      rodStackItems: pilha,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
