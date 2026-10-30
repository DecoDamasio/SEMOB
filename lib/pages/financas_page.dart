import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../theme/tema.dart';
import '../utils/formatacao.dart';
import '../widgets/graficos/grafico_linhas.dart';
import '../widgets/graficos/lista_barras.dart';
import '../widgets/kpi_card.dart';
import '../widgets/painel.dart';
import '../widgets/tabela.dart';
import 'comum.dart';

class FinancasPage extends StatelessWidget {
  final DadosPainel dados;

  const FinancasPage({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final atual = dados.resumo.atual;
    final anterior = dados.resumo.anterior;
    final tarifa = formatarMoeda(dados.resumo.tarifa, centavos: true);
    final serie = dados.serieComPassageiros;
    final pagantes = atual.passageirosPagantes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradeKpis(
          cards: [
            KpiCard(
              titulo: 'Receita estimada',
              valor: formatarMoeda(atual.receita),
              icone: Icons.payments_outlined,
              variacao: variacao(atual.receita, anterior.receita),
            ),
            KpiCard(
              titulo: 'Receita média diária',
              valor: formatarMoeda(atual.receitaMediaDiaria),
              icone: Icons.calendar_today_outlined,
              variacao: variacao(
                atual.receitaMediaDiaria,
                anterior.receitaMediaDiaria,
              ),
            ),
            KpiCard(
              titulo: 'Créditos vendidos',
              valor: formatarMoeda(atual.creditosVendidos),
              icone: Icons.credit_card,
              corIcone: Cores.serie2,
              variacao: variacao(atual.creditosVendidos, anterior.creditosVendidos),
            ),
            KpiCard(
              titulo: 'Receita por km',
              valor: formatarMoeda(atual.receitaPorKm, centavos: true),
              icone: Icons.route_outlined,
              variacao: variacao(atual.receitaPorKm, anterior.receitaPorKm),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Receita estimada = passageiros pagantes (catraca + antecipados) × tarifa de $tarifa. '
          'Os relatórios da Smart Data não trazem a receita apurada.',
          style: const TextStyle(fontSize: 11.5, color: Cores.textoMudo),
        ),
        const SizedBox(height: 16),
        LinhaPaineis(
          principal: Painel(
            titulo: 'Evolução da receita',
            subtitulo: subtituloSerie(dados, 'Receita estimada por dia'),
            child: serie.isEmpty
                ? semDadosDePassageiros
                : GraficoLinhas(
                    area: true,
                    series: [
                      SerieGrafico(
                        nome: 'Receita',
                        cor: Cores.serie1,
                        valores: serie.map((p) => p.indicadores.receita).toList(),
                      ),
                    ],
                    rotulosEixo: rotulosEixo(serie),
                    rotulosDica: rotulosDica(serie),
                    formatarEixo: formatarMoedaCompacta,
                    formatarValor: (valor) => formatarMoeda(valor),
                  ),
          ),
          lateral: Painel(
            titulo: 'Composição dos pagantes',
            subtitulo: 'Forma de pagamento da tarifa',
            child: pagantes == 0
                ? semDadosDePassageiros
                : ListaBarras(
                    itens: [
                      ItemBarra(
                        rotulo: 'Catraca (dinheiro / bilhete)',
                        proporcao: atual.passageirosCatraca / pagantes,
                        valor: formatarPercentual(atual.passageirosCatraca / pagantes, 0),
                      ),
                      ItemBarra(
                        rotulo: 'Antecipados (cartão)',
                        proporcao: atual.passageirosAntecipados / pagantes,
                        valor: formatarPercentual(atual.passageirosAntecipados / pagantes, 0),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Painel(
          titulo: 'Créditos de cartão',
          subtitulo: subtituloSerie(dados, 'Venda × utilização de créditos por dia'),
          conteudoSemMargem: true,
          child: Tabela(
            colunas: const [
              ColunaTabela('Data', flex: 14),
              ColunaTabela('Vendas', flex: 14, alinharDireita: true),
              ColunaTabela('Utilização', flex: 14, alinharDireita: true),
              ColunaTabela('Saldo do dia', flex: 14, alinharDireita: true),
            ],
            linhas: dados.serie.reversed.map((ponto) {
              final ind = ponto.indicadores;
              final saldo = ind.creditosVendidos - ind.creditosUtilizados;
              return <Widget>[
                Text(
                  '${formatarDiaSemana(ponto.data)}, ${formatarDiaMes(ponto.data)}',
                  style: Estilos.celulaDestaque,
                ),
                Text(formatarMoeda(ind.creditosVendidos, centavos: true), style: Estilos.celula),
                Text(formatarMoeda(ind.creditosUtilizados, centavos: true), style: Estilos.celula),
                Text(
                  formatarMoeda(saldo, centavos: true),
                  style: Estilos.celulaDestaque.copyWith(
                    color: saldo < 0 ? Cores.critico : Cores.texto,
                  ),
                ),
              ];
            }).toList(),
          ),
        ),
      ],
    );
  }
}
