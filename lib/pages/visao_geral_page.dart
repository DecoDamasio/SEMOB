import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../theme/tema.dart';
import '../utils/formatacao.dart';
import '../widgets/graficos/grafico_linhas.dart';
import '../widgets/graficos/grafico_rosca.dart';
import '../widgets/kpi_card.dart';
import '../widgets/painel.dart';
import '../widgets/selos.dart';
import 'comum.dart';

class VisaoGeralPage extends StatelessWidget {
  final DadosPainel dados;

  const VisaoGeralPage({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final atual = dados.resumo.atual;
    final anterior = dados.resumo.anterior;
    final serie = dados.serieComPassageiros;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradeKpis(
          cards: [
            KpiCard(
              titulo: 'Quilometragem',
              valor: '${formatarNumero(atual.quilometragem)} km',
              icone: Icons.route_outlined,
              variacao: variacao(atual.quilometragem, anterior.quilometragem),
            ),
            KpiCard(
              titulo: 'Viagens realizadas',
              valor: formatarNumero(atual.viagensRealizadas),
              icone: Icons.directions_bus_outlined,
              variacao: variacao(
                atual.viagensRealizadas,
                anterior.viagensRealizadas,
              ),
            ),
            KpiCard(
              titulo: 'Pass. pagantes',
              valor: formatarNumero(atual.passageirosPagantes),
              icone: Icons.person_outline,
              variacao: variacao(
                atual.passageirosPagantes,
                anterior.passageirosPagantes,
              ),
            ),
            KpiCard(
              titulo: 'Não pagantes',
              valor: formatarNumero(atual.passageirosNaoPagantes),
              icone: Icons.person_outline,
              corIcone: Cores.serie2,
              variacao: variacao(
                atual.passageirosNaoPagantes,
                anterior.passageirosNaoPagantes,
              ),
            ),
            KpiCard(
              titulo: 'Receita estimada',
              valor: formatarMoeda(atual.receita),
              icone: Icons.payments_outlined,
              variacao: variacao(atual.receita, anterior.receita),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinhaPaineis(
          principal: Painel(
            titulo: 'Evolução da demanda',
            subtitulo: subtituloSerie(dados, 'Passageiros transportados por dia'),
            child: serie.isEmpty
                ? semDadosDePassageiros
                : GraficoLinhas(
                    area: true,
                    series: [
                      SerieGrafico(
                        nome: 'Passageiros',
                        cor: Cores.serie1,
                        valores: serie
                            .map((p) => p.indicadores.passageirosTotais.toDouble())
                            .toList(),
                      ),
                    ],
                    rotulosEixo: rotulosEixo(serie),
                    rotulosDica: rotulosDica(serie),
                    formatarEixo: formatarNumero,
                    formatarValor: formatarNumero,
                  ),
          ),
          lateral: Painel(
            titulo: 'Composição de passageiros',
            subtitulo: 'Distribuição por tipo de embarque',
            child: atual.temPassageiros ? _composicao(atual) : semDadosDePassageiros,
          ),
        ),
        const SizedBox(height: 16),
        _PainelAnomalias(anomalias: dados.anomalias),
      ],
    );
  }

  Widget _composicao(Indicadores atual) {
    final pagantes = atual.participacaoPagantes;

    return Column(
      children: [
        const SizedBox(height: 8),
        GraficoRosca(
          valorCentral: formatarNumero(atual.passageirosTotais),
          rotuloCentral: 'embarques',
          fatias: [
            FatiaRosca('Pagantes', atual.passageirosPagantes.toDouble(), Cores.serie1),
            FatiaRosca('Não pagantes', atual.passageirosNaoPagantes.toDouble(), Cores.serie2),
          ],
        ),
        const SizedBox(height: 24),
        _linhaLegenda('Pagantes', Cores.serie1, pagantes),
        const SizedBox(height: 10),
        _linhaLegenda('Não pagantes (gratuidades)', Cores.serie2, 1 - pagantes),
      ],
    );
  }

  Widget _linhaLegenda(String nome, Color cor, double fracao) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            nome,
            style: const TextStyle(fontSize: 13, color: Cores.textoSecundario),
          ),
        ),
        Text(
          formatarPercentual(fracao, 0),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Cores.texto,
          ),
        ),
      ],
    );
  }
}

class _PainelAnomalias extends StatelessWidget {
  final List<Anomalia> anomalias;

  const _PainelAnomalias({required this.anomalias});

  @override
  Widget build(BuildContext context) {
    final destaques = anomalias.take(4).toList();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: anomalias.isEmpty ? Cores.borda : const Color(0xFFF3D9A4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: anomalias.isEmpty ? Cores.sucessoFundo : const Color(0xFFFFF9EB),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Icon(
                  anomalias.isEmpty
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_rounded,
                  size: 18,
                  color: anomalias.isEmpty ? Cores.sucesso : Cores.alerta,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    anomalias.isEmpty
                        ? 'Nenhuma anomalia detectada no período'
                        : 'Anomalias que exigem atenção',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: anomalias.isEmpty ? Cores.sucesso : const Color(0xFF8A4B00),
                    ),
                  ),
                ),
                if (anomalias.isNotEmpty)
                  SeloContador(
                    texto: anomalias.length == 1
                        ? '1 anomalia'
                        : '${anomalias.length} anomalias',
                    cor: const Color(0xFF8A4B00),
                    fundo: const Color(0xFFFCE8BF),
                  ),
              ],
            ),
          ),
          if (destaques.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final colunas = constraints.maxWidth >= 800 ? 2 : 1;
                final largura = constraints.maxWidth / colunas;

                return Wrap(
                  children: destaques
                      .map(
                        (anomalia) => SizedBox(
                          width: largura,
                          child: _ItemAnomalia(anomalia: anomalia),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ItemAnomalia extends StatelessWidget {
  final Anomalia anomalia;

  const _ItemAnomalia({required this.anomalia});

  @override
  Widget build(BuildContext context) {
    final cor = anomalia.severidade == Severidade.critico
        ? Cores.critico
        : Cores.alertaClaro;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Cores.grade),
          right: BorderSide(color: Cores.grade),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${anomalia.origem} · ${formatarDiaMes(anomalia.data)}',
                  style: Estilos.celulaDestaque,
                ),
                const SizedBox(height: 2),
                Text(
                  anomalia.descricao,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Cores.textoSecundario,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SeloStatus(severidade: anomalia.severidade),
        ],
      ),
    );
  }
}
