import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../theme/tema.dart';
import '../utils/formatacao.dart';
import '../widgets/graficos/grafico_linhas.dart';
import '../widgets/graficos/grafico_rosca.dart';
import '../widgets/kpi_card.dart';
import '../widgets/painel.dart';
import '../widgets/tabela.dart';
import 'comum.dart';

class PassagensPage extends StatelessWidget {
  final DadosPainel dados;

  const PassagensPage({super.key, required this.dados});

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
              titulo: 'Total de passageiros',
              valor: formatarNumero(atual.passageirosTotais),
              icone: Icons.groups_outlined,
              variacao: variacao(
                atual.passageirosTotais,
                anterior.passageirosTotais,
              ),
            ),
            KpiCard(
              titulo: 'Pagantes na catraca',
              valor: formatarNumero(atual.passageirosCatraca),
              icone: Icons.person_outline,
              variacao: variacao(
                atual.passageirosCatraca,
                anterior.passageirosCatraca,
              ),
            ),
            KpiCard(
              titulo: 'Antecipados (cartão)',
              valor: formatarNumero(atual.passageirosAntecipados),
              icone: Icons.credit_card,
              variacao: variacao(
                atual.passageirosAntecipados,
                anterior.passageirosAntecipados,
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
          ],
        ),
        const SizedBox(height: 16),
        LinhaPaineis(
          principal: Painel(
            titulo: 'Fluxo de passageiros',
            subtitulo: subtituloSerie(dados, 'Pagantes e não pagantes por dia'),
            child: serie.isEmpty
                ? semDadosDePassageiros
                : GraficoLinhas(
                    area: true,
                    series: [
                      SerieGrafico(
                        nome: 'Pagantes',
                        cor: Cores.serie1,
                        valores: serie
                            .map((p) => p.indicadores.passageirosPagantes.toDouble())
                            .toList(),
                      ),
                      SerieGrafico(
                        nome: 'Não pagantes',
                        cor: Cores.serie2,
                        valores: serie
                            .map((p) => p.indicadores.passageirosNaoPagantes.toDouble())
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
            titulo: 'Participação por categoria',
            subtitulo: '${formatarNumero(atual.passageirosTotais)} embarques no período',
            child: !atual.temPassageiros
                ? semDadosDePassageiros
                : Column(
                    children: [
                      const SizedBox(height: 8),
                      GraficoRosca(
                        valorCentral: formatarPercentual(atual.participacaoPagantes, 0),
                        rotuloCentral: 'pagantes',
                        fatias: [
                          FatiaRosca('Pagantes', atual.passageirosPagantes.toDouble(), Cores.serie1),
                          FatiaRosca('Não pagantes', atual.passageirosNaoPagantes.toDouble(), Cores.serie2),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _caixaValor(
                              'Pagantes',
                              atual.passageirosPagantes,
                              Cores.infoFundo,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _caixaValor(
                              'Não pagantes',
                              atual.passageirosNaoPagantes,
                              Cores.sucessoFundo,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Painel(
          titulo: 'Passageiros por dia',
          subtitulo: subtituloSerie(
            dados,
            'Os relatórios trazem passageiros só do sistema todo, não por linha',
          ),
          conteudoSemMargem: true,
          child: serie.isEmpty
              ? semDadosDePassageiros
              : Tabela(
                  colunas: const [
                    ColunaTabela('Data', flex: 14),
                    ColunaTabela('Catraca', flex: 12, alinharDireita: true),
                    ColunaTabela('Antecipados', flex: 12, alinharDireita: true),
                    ColunaTabela('Não pagantes', flex: 12, alinharDireita: true),
                    ColunaTabela('Total', flex: 12, alinharDireita: true),
                    ColunaTabela('Por viagem', flex: 11, alinharDireita: true),
                  ],
                  linhas: serie.reversed.map((ponto) {
                    final ind = ponto.indicadores;
                    return <Widget>[
                      Text(
                        '${formatarDiaSemana(ponto.data)}, ${formatarDiaMes(ponto.data)}',
                        style: Estilos.celulaDestaque,
                      ),
                      Text(formatarNumero(ind.passageirosCatraca), style: Estilos.celula),
                      Text(formatarNumero(ind.passageirosAntecipados), style: Estilos.celula),
                      Text(formatarNumero(ind.passageirosNaoPagantes), style: Estilos.celula),
                      Text(formatarNumero(ind.passageirosTotais), style: Estilos.celulaDestaque),
                      Text(formatarDecimal(ind.passageirosPorViagem), style: Estilos.celula),
                    ];
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _caixaValor(String rotulo, int valor, Color fundo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rotulo,
            style: const TextStyle(fontSize: 11.5, color: Cores.textoSecundario),
          ),
          const SizedBox(height: 2),
          Text(
            formatarNumero(valor),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Cores.texto,
            ),
          ),
        ],
      ),
    );
  }
}
