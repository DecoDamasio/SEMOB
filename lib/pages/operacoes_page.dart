import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../theme/tema.dart';
import '../utils/formatacao.dart';
import '../widgets/graficos/grafico_linhas.dart';
import '../widgets/graficos/lista_barras.dart';
import '../widgets/kpi_card.dart';
import '../widgets/painel.dart';
import '../widgets/selos.dart';
import '../widgets/tabela.dart';
import 'comum.dart';

const _nomesTurnos = {'manha': 'Manhã', 'tarde': 'Tarde', 'noite': 'Noite'};

class OperacoesPage extends StatelessWidget {
  final DadosPainel dados;

  const OperacoesPage({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final atual = dados.resumo.atual;
    final anterior = dados.resumo.anterior;
    final maisViagens = dados.linhas.fold<int>(
      0,
      (maior, linha) =>
          linha.viagensRealizadas > maior ? linha.viagensRealizadas : maior,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradeKpis(
          cards: [
            KpiCard(
              titulo: 'Quilometragem total',
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
              titulo: 'Km improdutivo',
              valor: formatarPercentual(atual.participacaoImprodutiva),
              icone: Icons.timelapse,
              corIcone: Cores.serie2,
              descricao:
                  '${formatarNumero(atual.quilometragemImprodutiva)} km sem passageiros',
            ),
            KpiCard(
              titulo: 'Índice de cumprimento',
              valor: formatarPercentual(atual.cumprimento),
              icone: Icons.task_alt,
              corIcone: Cores.serie2,
              variacao: anterior.viagensProgramadas == 0
                  ? null
                  : atual.cumprimento - anterior.cumprimento,
              variacaoEmPontos: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinhaPaineis(
          principal: Painel(
            titulo: 'Produção operacional',
            subtitulo: subtituloSerie(dados, 'Km produtivo e improdutivo por dia'),
            child: GraficoLinhas(
              series: [
                SerieGrafico(
                  nome: 'Produtivo',
                  cor: Cores.serie1,
                  valores: dados.serie
                      .map((p) => p.indicadores.quilometragemProdutiva)
                      .toList(),
                ),
                SerieGrafico(
                  nome: 'Improdutivo',
                  cor: Cores.serie2,
                  valores: dados.serie
                      .map((p) => p.indicadores.quilometragemImprodutiva)
                      .toList(),
                ),
              ],
              rotulosEixo: rotulosEixo(dados.serie),
              rotulosDica: rotulosDica(dados.serie),
              formatarEixo: formatarNumero,
              formatarValor: (valor) => '${formatarNumero(valor)} km',
            ),
          ),
          lateral: Painel(
            titulo: 'Viagens por linha',
            subtitulo: 'Viagens realizadas no período',
            child: ListaBarras(
              itens: dados.linhas
                  .map(
                    (linha) => ItemBarra(
                      rotulo: '${linha.codigo} · ${linha.nome}',
                      proporcao: maisViagens == 0
                          ? 0
                          : linha.viagensRealizadas / maisViagens,
                      valor: formatarNumero(linha.viagensRealizadas),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        LinhaPaineis(
          principal: Painel(
            titulo: 'Frota em operação',
            subtitulo: subtituloSerie(dados, 'Veículos utilizados por dia'),
            child: GraficoLinhas(
              altura: 200,
              series: [
                SerieGrafico(
                  nome: 'Veículos',
                  cor: Cores.serie1,
                  valores: dados.serie.map((p) => p.indicadores.frotaMedia).toList(),
                ),
              ],
              rotulosEixo: rotulosEixo(dados.serie),
              rotulosDica: rotulosDica(dados.serie),
              formatarEixo: formatarNumero,
              formatarValor: (valor) => '${formatarNumero(valor)} veículos',
            ),
          ),
          lateral: Painel(
            titulo: 'Viagens não realizadas por turno',
            subtitulo: 'Programadas que não aconteceram no período',
            child: _naoRealizadasPorTurno(atual),
          ),
        ),
        const SizedBox(height: 16),
        Painel(
          titulo: 'Desempenho por linha',
          subtitulo: 'Km produtivo e viagens (programadas = realizadas + não realizadas)',
          conteudoSemMargem: true,
          child: Tabela(
            colunas: const [
              ColunaTabela('Linha', flex: 8),
              ColunaTabela('Itinerário', flex: 22),
              ColunaTabela('Viagens', flex: 14, alinharDireita: true),
              ColunaTabela('Km produtivo', flex: 14, alinharDireita: true),
              ColunaTabela('Km / viagem', flex: 11, alinharDireita: true),
              ColunaTabela('Cumprimento', flex: 18, alinharDireita: true),
              ColunaTabela('Status', flex: 11, alinharDireita: true),
            ],
            linhas: dados.linhas.map((linha) {
              return <Widget>[
                CodigoLinha(linha.codigo),
                Text(linha.nome, style: Estilos.celula),
                Text(
                  '${formatarNumero(linha.viagensRealizadas)} / ${formatarNumero(linha.viagensProgramadas)}',
                  style: Estilos.celulaDestaque,
                ),
                Text('${formatarNumero(linha.quilometragem)} km', style: Estilos.celula),
                Text(formatarDecimal(linha.kmPorViagem), style: Estilos.celula),
                _cumprimento(linha.cumprimento),
                SeloStatus(severidade: dados.severidadeDaLinha(linha.codigo)),
              ];
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _naoRealizadasPorTurno(Indicadores atual) {
    final turnos = _nomesTurnos.keys
        .where(atual.turnos.containsKey)
        .map((chave) => MapEntry(chave, atual.turnos[chave]!))
        .toList();
    final maior = turnos.fold<int>(
      0,
      (m, t) => t.value.naoRealizadas > m ? t.value.naoRealizadas : m,
    );

    if (maior == 0) {
      return const EstadoVazio(
        icone: Icons.check_circle_outline,
        texto: 'Todas as viagens programadas foram realizadas.',
      );
    }

    return ListaBarras(
      itens: turnos
          .map(
            (turno) => ItemBarra(
              rotulo: '${_nomesTurnos[turno.key]} · '
                  '${formatarPercentual(turno.value.programadas == 0 ? 0 : turno.value.naoRealizadas / turno.value.programadas, 2)} das programadas',
              proporcao: turno.value.naoRealizadas / maior,
              valor: formatarNumero(turno.value.naoRealizadas),
            ),
          )
          .toList(),
    );
  }

  Widget _cumprimento(double valor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          child: BarraProgresso(proporcao: valor, altura: 6),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          child: Text(
            formatarPercentual(valor),
            textAlign: TextAlign.right,
            style: Estilos.celulaDestaque,
          ),
        ),
      ],
    );
  }
}
