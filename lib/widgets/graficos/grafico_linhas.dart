import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/tema.dart';
import 'legenda.dart';

class SerieGrafico {
  final String nome;
  final Color cor;
  final List<double> valores;

  const SerieGrafico({
    required this.nome,
    required this.cor,
    required this.valores,
  });
}

/// Teto "redondo" para o eixo Y, dividido em 4 faixas (ex.: 22.000 -> 25.000).
double tetoEixo(double maximo) {
  if (maximo <= 0) return 4;
  final faixa = maximo / 4;
  final magnitude = pow(10, (log(faixa) / ln10).floor()).toDouble();
  final normalizado = faixa / magnitude;
  final passo = normalizado <= 1
      ? 1
      : normalizado <= 2
          ? 2
          : normalizado <= 2.5
              ? 2.5
              : normalizado <= 5
                  ? 5
                  : 10;
  return passo * magnitude * 4;
}

/// Gráfico de linhas (ou área) com um único eixo Y; todas as séries na mesma unidade.
class GraficoLinhas extends StatelessWidget {
  final List<SerieGrafico> series;
  final List<String> rotulosEixo;
  final List<String> rotulosDica;
  final String Function(double) formatarEixo;
  final String Function(double) formatarValor;
  final bool area;
  final double altura;

  const GraficoLinhas({
    super.key,
    required this.series,
    required this.rotulosEixo,
    required this.rotulosDica,
    required this.formatarEixo,
    required this.formatarValor,
    this.area = false,
    this.altura = 240,
  });

  @override
  Widget build(BuildContext context) {
    final pontos = rotulosEixo.length;
    final maximo = series
        .expand((serie) => serie.valores)
        .fold<double>(0, (a, b) => max(a, b));
    final maxY = tetoEixo(maximo);
    final passoRotulo = (pontos / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (series.length > 1) ...[
          Legenda(
            itens: series.map((s) => ItemLegenda(s.nome, s.cor)).toList(),
          ),
          const SizedBox(height: 14),
        ],
        SizedBox(
          height: altura,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: max(pontos - 1, 1).toDouble(),
              minY: 0,
              maxY: maxY,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
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
                    reservedSize: 56,
                    interval: maxY / 4,
                    getTitlesWidget: (valor, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(formatarEixo(valor), style: Estilos.eixo),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    interval: 1,
                    getTitlesWidget: (valor, meta) {
                      final indice = valor.toInt();
                      if (indice != valor ||
                          indice >= pontos ||
                          indice % passoRotulo != 0) {
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
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Cores.texto,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (tocados) => tocados.map((ponto) {
                    final serie = series[ponto.barIndex];
                    final cabecalho = ponto == tocados.first
                        ? '${rotulosDica[ponto.x.toInt()]}\n'
                        : '';
                    return LineTooltipItem(
                      cabecalho,
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                      textAlign: TextAlign.left,
                      children: [
                        TextSpan(
                          text: '${serie.nome}: ${formatarValor(ponto.y)}',
                          style: const TextStyle(
                            color: Color(0xFFDCE4EE),
                            fontWeight: FontWeight.w500,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              lineBarsData: series
                  .map(
                    (serie) => LineChartBarData(
                      spots: List.generate(
                        serie.valores.length,
                        (i) => FlSpot(i.toDouble(), serie.valores[i]),
                      ),
                      isCurved: true,
                      curveSmoothness: 0.25,
                      preventCurveOverShooting: true,
                      color: serie.cor,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: pontos <= 1),
                      belowBarData: BarAreaData(
                        show: area,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            serie.cor.withValues(alpha: 0.18),
                            serie.cor.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
