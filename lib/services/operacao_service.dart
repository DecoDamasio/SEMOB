import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/operacao.dart';

class OperacaoService {
  // Para outro endereço: flutter run --dart-define=API_URL=http://10.0.2.2:3000
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );

  final http.Client _client;

  OperacaoService({http.Client? client}) : _client = client ?? http.Client();

  Future<DadosPainel> buscarPainel(Periodo periodo) async {
    final periodoSerie = periodo == Periodo.diario ? Periodo.semanal : periodo;

    final (resumo, linhas, anomalias, falhas, serie, anomaliasDaSerie) = await (
      buscarResumo(periodo),
      buscarLinhas(periodo),
      buscarAnomalias(periodo),
      buscarFalhas(periodo),
      buscarSerie(periodoSerie),
      buscarAnomalias(periodoSerie),
    ).wait;

    return DadosPainel(
      periodo: periodo,
      resumo: resumo,
      linhas: linhas,
      anomalias: anomalias,
      falhas: falhas,
      serie: serie,
      anomaliasDaSerie: anomaliasDaSerie,
    );
  }

  Future<ResumoOperacao> buscarResumo(Periodo periodo) async {
    final json = await _get('/api/resumo', periodo);
    return ResumoOperacao.fromJson(json as Map<String, dynamic>);
  }

  Future<List<PontoSerie>> buscarSerie(Periodo periodo) async {
    final json = await _get('/api/serie', periodo);
    return _lista(json, PontoSerie.fromJson);
  }

  Future<List<LinhaOperacao>> buscarLinhas(Periodo periodo) async {
    final json = await _get('/api/linhas', periodo);
    return _lista(json, LinhaOperacao.fromJson);
  }

  Future<List<Anomalia>> buscarAnomalias(Periodo periodo) async {
    final json = await _get('/api/anomalias', periodo);
    return _lista(json, Anomalia.fromJson);
  }

  Future<List<FalhaViagem>> buscarFalhas(Periodo periodo) async {
    final json = await _get('/api/falhas', periodo);
    return _lista(json, FalhaViagem.fromJson);
  }

  List<T> _lista<T>(dynamic json, T Function(Map<String, dynamic>) converter) {
    return (json as List)
        .map((item) => converter(item as Map<String, dynamic>))
        .toList();
  }

  Future<dynamic> _get(String caminho, Periodo periodo) async {
    final uri = Uri.parse('$baseUrl$caminho').replace(
      queryParameters: {'periodo': periodo.name},
    );
    final resposta = await _client.get(uri);
    final corpo = jsonDecode(utf8.decode(resposta.bodyBytes));

    if (resposta.statusCode != 200) {
      throw Exception(corpo['erro'] ?? 'Erro ${resposta.statusCode}');
    }
    return corpo;
  }
}
