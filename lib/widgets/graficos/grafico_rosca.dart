import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/tema.dart';

class FatiaRosca {
  final String nome;
  final double valor;
  final Color cor;

  const FatiaRosca(this.nome, this.valor, this.cor);
}

class GraficoRosca extends StatelessWidget {
  final List<FatiaRosca> fatias;
  final String valorCentral;
  final String rotuloCentral;
  final double tamanho;

  const GraficoRosca({
    super.key,
    required this.fatias,
    required this.valorCentral,
    required this.rotuloCentral,
    this.tamanho = 170,
  });

  @override
  Widget build(BuildContext context) {
    const espessura = 24.0;

    return SizedBox(
      width: tamanho,
      height: tamanho,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 2,
              centerSpaceRadius: tamanho / 2 - espessura,
              pieTouchData: PieTouchData(enabled: false),
              sections: fatias
                  .map(
                    (fatia) => PieChartSectionData(
                      value: fatia.valor,
                      color: fatia.cor,
                      radius: espessura,
                      showTitle: false,
                    ),
                  )
                  .toList(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                valorCentral,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Cores.texto,
                ),
              ),
              Text(
                rotuloCentral,
                style: const TextStyle(
                  fontSize: 11,
                  color: Cores.textoMudo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
