enum Periodo {
  diario('Diário', 1),
  semanal('Semanal', 7),
  mensal('Mensal', 30);

  final String rotulo;
  final int dias;

  const Periodo(this.rotulo, this.dias);
}

class Turno {
  final int programadas;
  final int realizadas;

  const Turno({required this.programadas, required this.realizadas});

  int get naoRealizadas => programadas - realizadas;

  factory Turno.fromJson(Map<String, dynamic> json) {
    return Turno(
      programadas: (json['programadas'] as num).toInt(),
      realizadas: (json['realizadas'] as num).toInt(),
    );
  }
}

/// Totais do sistema em um período (ou em um dia, na série).
class Indicadores {
  final double quilometragem;
  final double quilometragemProdutiva;
  final double quilometragemImprodutiva;
  final int viagensProgramadas;
  final int viagensRealizadas;
  final int passageirosCatraca;
  final int passageirosAntecipados;
  final int passageirosPagantes;
  final int passageirosNaoPagantes;

  /// Estimada pela API: pagantes x tarifa.
  final double receita;
  final double creditosVendidos;
  final double creditosUtilizados;
  final double frotaMedia;
  final int dias;
  final int diasComPassageiros;
  final Map<String, Turno> turnos;

  const Indicadores({
    required this.quilometragem,
    required this.quilometragemProdutiva,
    required this.quilometragemImprodutiva,
    required this.viagensProgramadas,
    required this.viagensRealizadas,
    required this.passageirosCatraca,
    required this.passageirosAntecipados,
    required this.passageirosPagantes,
    required this.passageirosNaoPagantes,
    required this.receita,
    required this.creditosVendidos,
    required this.creditosUtilizados,
    required this.frotaMedia,
    required this.dias,
    required this.diasComPassageiros,
    required this.turnos,
  });

  int get passageirosTotais => passageirosPagantes + passageirosNaoPagantes;

  bool get temPassageiros => diasComPassageiros > 0;

  double get cumprimento =>
      viagensProgramadas == 0 ? 0 : viagensRealizadas / viagensProgramadas;

  double get kmPorViagem =>
      viagensRealizadas == 0 ? 0 : quilometragem / viagensRealizadas;

  double get participacaoImprodutiva =>
      quilometragem == 0 ? 0 : quilometragemImprodutiva / quilometragem;

  double get passageirosPorViagem =>
      viagensRealizadas == 0 ? 0 : passageirosTotais / viagensRealizadas;

  double get receitaPorKm => quilometragem == 0 ? 0 : receita / quilometragem;

  double get receitaMediaDiaria =>
      diasComPassageiros == 0 ? 0 : receita / diasComPassageiros;

  double get participacaoPagantes =>
      passageirosTotais == 0 ? 0 : passageirosPagantes / passageirosTotais;

  factory Indicadores.fromJson(Map<String, dynamic> json) {
    double decimal(String chave) => (json[chave] as num? ?? 0).toDouble();
    int inteiro(String chave) => (json[chave] as num? ?? 0).toInt();

    return Indicadores(
      quilometragem: decimal('quilometragem'),
      quilometragemProdutiva: decimal('quilometragemProdutiva'),
      quilometragemImprodutiva: decimal('quilometragemImprodutiva'),
      viagensProgramadas: inteiro('viagensProgramadas'),
      viagensRealizadas: inteiro('viagensRealizadas'),
      passageirosCatraca: inteiro('passageirosCatraca'),
      passageirosAntecipados: inteiro('passageirosAntecipados'),
      passageirosPagantes: inteiro('passageirosPagantes'),
      passageirosNaoPagantes: inteiro('passageirosNaoPagantes'),
      receita: decimal('receita'),
      creditosVendidos: decimal('creditosVendidos'),
      creditosUtilizados: decimal('creditosUtilizados'),
      frotaMedia: decimal('frotaMedia'),
      dias: inteiro('dias'),
      diasComPassageiros: inteiro('diasComPassageiros'),
      turnos: ((json['turnos'] as Map<String, dynamic>?) ?? {}).map(
        (turno, valor) =>
            MapEntry(turno, Turno.fromJson(valor as Map<String, dynamic>)),
      ),
    );
  }
}

class ResumoOperacao {
  final Periodo periodo;
  final DateTime inicio;
  final DateTime fim;
  final double tarifa;
  final Indicadores atual;
  final Indicadores anterior;

  const ResumoOperacao({
    required this.periodo,
    required this.inicio,
    required this.fim,
    required this.tarifa,
    required this.atual,
    required this.anterior,
  });

  factory ResumoOperacao.fromJson(Map<String, dynamic> json) {
    return ResumoOperacao(
      periodo: Periodo.values.byName(json['periodo'] as String),
      inicio: DateTime.parse(json['inicio'] as String),
      fim: DateTime.parse(json['fim'] as String),
      tarifa: (json['tarifa'] as num).toDouble(),
      atual: Indicadores.fromJson(json['atual'] as Map<String, dynamic>),
      anterior: Indicadores.fromJson(json['anterior'] as Map<String, dynamic>),
    );
  }
}

class PontoSerie {
  final DateTime data;
  final Indicadores indicadores;

  const PontoSerie({
    required this.data,
    required this.indicadores,
  });

  factory PontoSerie.fromJson(Map<String, dynamic> json) {
    return PontoSerie(
      data: DateTime.parse(json['data'] as String),
      indicadores: Indicadores.fromJson(json),
    );
  }
}

/// Totais de uma linha no período. Os relatórios não trazem passageiros por linha.
class LinhaOperacao {
  final String codigo;
  final String nome;

  /// Km produtivo (o relatório por linha não inclui o km ocioso).
  final double quilometragem;
  final int viagensProgramadas;
  final int viagensRealizadas;

  const LinhaOperacao({
    required this.codigo,
    required this.nome,
    required this.quilometragem,
    required this.viagensProgramadas,
    required this.viagensRealizadas,
  });

  double get cumprimento =>
      viagensProgramadas == 0 ? 0 : viagensRealizadas / viagensProgramadas;

  double get kmPorViagem =>
      viagensRealizadas == 0 ? 0 : quilometragem / viagensRealizadas;

  factory LinhaOperacao.fromJson(Map<String, dynamic> json) {
    return LinhaOperacao(
      codigo: json['codigo'] as String,
      nome: json['nome'] as String,
      quilometragem: (json['quilometragem'] as num).toDouble(),
      viagensProgramadas: (json['viagensProgramadas'] as num).toInt(),
      viagensRealizadas: (json['viagensRealizadas'] as num).toInt(),
    );
  }
}

enum Severidade {
  critico('Crítico'),
  alerta('Alerta');

  final String rotulo;

  const Severidade(this.rotulo);
}

enum CategoriaAnomalia {
  passageiros('Passageiros'),
  quilometragem('Quilometragem'),
  viagens('Viagens');

  final String rotulo;

  const CategoriaAnomalia(this.rotulo);
}

class Anomalia {
  final DateTime data;

  /// Null quando a anomalia é do sistema todo (ex.: passageiros).
  final String? codigoLinha;
  final String? nomeLinha;
  final CategoriaAnomalia categoria;
  final String descricao;
  final double desvio;
  final Severidade severidade;

  const Anomalia({
    required this.data,
    required this.codigoLinha,
    required this.nomeLinha,
    required this.categoria,
    required this.descricao,
    required this.desvio,
    required this.severidade,
  });

  String get origem => codigoLinha == null ? 'Sistema' : 'Linha $codigoLinha';

  factory Anomalia.fromJson(Map<String, dynamic> json) {
    final linha = json['linha'] as Map<String, dynamic>?;
    return Anomalia(
      data: DateTime.parse(json['data'] as String),
      codigoLinha: linha?['codigo'] as String?,
      nomeLinha: linha?['nome'] as String?,
      categoria: CategoriaAnomalia.values.byName(json['categoria'] as String),
      descricao: json['descricao'] as String,
      desvio: (json['desvio'] as num).toDouble(),
      severidade: Severidade.values.byName(json['severidade'] as String),
    );
  }
}

enum TipoFalha {
  naoRealizada('Não realizada'),
  naoIniciada('Não iniciada'),
  naoTerminada('Não terminada');

  final String rotulo;

  const TipoFalha(this.rotulo);
}

/// Viagem programada que não foi realizada, iniciada ou terminada.
class FalhaViagem {
  final DateTime data;
  final TipoFalha tipo;
  final String codigoLinha;
  final String atendimento;
  final String inicioProgramado;
  final String fimProgramado;

  const FalhaViagem({
    required this.data,
    required this.tipo,
    required this.codigoLinha,
    required this.atendimento,
    required this.inicioProgramado,
    required this.fimProgramado,
  });

  factory FalhaViagem.fromJson(Map<String, dynamic> json) {
    final linha = json['linha'] as Map<String, dynamic>;
    return FalhaViagem(
      data: DateTime.parse(json['data'] as String),
      tipo: TipoFalha.values.byName(json['tipo'] as String),
      codigoLinha: linha['codigo'] as String,
      atendimento: json['atendimento'] as String,
      inicioProgramado: json['inicioProgramado'] as String,
      fimProgramado: json['fimProgramado'] as String,
    );
  }
}

/// Tudo o que as telas precisam para um período, carregado de uma vez.
class DadosPainel {
  final Periodo periodo;
  final ResumoOperacao resumo;
  final List<LinhaOperacao> linhas;
  final List<Anomalia> anomalias;
  final List<FalhaViagem> falhas;

  /// No período diário a série cobre os últimos 7 dias, para dar contexto.
  final List<PontoSerie> serie;
  final List<Anomalia> anomaliasDaSerie;

  const DadosPainel({
    required this.periodo,
    required this.resumo,
    required this.linhas,
    required this.anomalias,
    required this.falhas,
    required this.serie,
    required this.anomaliasDaSerie,
  });

  Severidade? severidadeDaLinha(String codigo) {
    final daLinha = anomalias.where((a) => a.codigoLinha == codigo);
    if (daLinha.any((a) => a.severidade == Severidade.critico)) {
      return Severidade.critico;
    }
    if (daLinha.isNotEmpty) {
      return Severidade.alerta;
    }
    return null;
  }

  /// Dias da série que têm dados de passageiros.
  List<PontoSerie> get serieComPassageiros =>
      serie.where((p) => p.indicadores.temPassageiros).toList();
}
