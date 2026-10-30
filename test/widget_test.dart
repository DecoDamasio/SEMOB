import 'package:flutter_test/flutter_test.dart';

import 'package:semob/models/operacao.dart';
import 'package:semob/utils/formatacao.dart';

void main() {
  test('Indicadores calcula médias a partir do JSON da API', () {
    final indicadores = Indicadores.fromJson({
      'quilometragem': 1000,
      'quilometragemImprodutiva': 50,
      'viagensProgramadas': 100,
      'viagensRealizadas': 80,
      'passageirosPagantes': 1500,
      'passageirosNaoPagantes': 500,
      'receita': 7500,
      'diasComPassageiros': 3,
      'turnos': {
        'manha': {'programadas': 40, 'realizadas': 38},
      },
    });

    expect(indicadores.passageirosTotais, 2000);
    expect(indicadores.cumprimento, 0.8);
    expect(indicadores.kmPorViagem, 12.5);
    expect(indicadores.passageirosPorViagem, 25);
    expect(indicadores.participacaoPagantes, 0.75);
    expect(indicadores.participacaoImprodutiva, 0.05);
    expect(indicadores.receitaMediaDiaria, 2500);
    expect(indicadores.turnos['manha']!.naoRealizadas, 2);
  });

  test('Indicadores sem dados não dividem por zero', () {
    final indicadores = Indicadores.fromJson({});

    expect(indicadores.cumprimento, 0);
    expect(indicadores.kmPorViagem, 0);
    expect(indicadores.receitaMediaDiaria, 0);
    expect(indicadores.temPassageiros, isFalse);
  });

  test('anomalia do sistema não tem linha', () {
    final anomalia = Anomalia.fromJson({
      'data': '2026-09-07',
      'linha': null,
      'categoria': 'passageiros',
      'descricao': 'Queda',
      'desvio': -0.78,
      'severidade': 'critico',
    });

    expect(anomalia.origem, 'Sistema');
    expect(anomalia.codigoLinha, isNull);
  });

  test('formatação em pt-BR', () {
    expect(formatarNumero(26060), '26.060');
    expect(formatarPercentual(0.964), '96,4%');
    expect(variacao(110, 100), closeTo(0.1, 1e-9));
    expect(variacao(10, 0), isNull);
  });
}
