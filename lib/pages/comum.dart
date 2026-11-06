import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../utils/formatacao.dart';
import '../widgets/painel.dart';

/// Rótulos do eixo X: dia da semana até 7 pontos, senão dd/MM.
List<String> rotulosEixo(List<PontoSerie> serie) {
  return serie
      .map(
        (ponto) => serie.length <= 7
            ? formatarDiaSemana(ponto.data)
            : formatarDiaMes(ponto.data),
      )
      .toList();
}

List<String> rotulosDica(List<PontoSerie> serie) {
  return serie
      .map((ponto) =>
          '${formatarDiaSemana(ponto.data)}, ${formatarDiaMes(ponto.data)}')
      .toList();
}

/// No período diário os gráficos mostram 7 dias; o subtítulo avisa isso.
String subtituloSerie(DadosPainel dados, String texto) {
  return dados.periodo == Periodo.diario ? '$texto · últimos 7 dias' : texto;
}

/// Os relatórios não têm passageiros de 01 a 14/07/2026.
const semDadosDePassageiros = EstadoVazio(
  icone: Icons.info_outline,
  texto: 'Sem dados de passageiros para este período nos relatórios.',
);
