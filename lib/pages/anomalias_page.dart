import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../theme/tema.dart';
import '../utils/formatacao.dart';
import '../widgets/graficos/grafico_barras_empilhadas.dart';
import '../widgets/graficos/grafico_linhas.dart';
import '../widgets/graficos/lista_barras.dart';
import '../widgets/kpi_card.dart';
import '../widgets/painel.dart';
import '../widgets/selos.dart';
import '../widgets/tabela.dart';
import 'comum.dart';

class AnomaliasPage extends StatelessWidget {
  final DadosPainel dados;

  const AnomaliasPage({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final anomalias = dados.anomalias;
    final criticas =
        anomalias.where((a) => a.severidade == Severidade.critico).length;
    final linhasAfetadas = anomalias
        .map((a) => a.codigoLinha)
        .whereType<String>()
        .toSet()
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradeKpis(
          cards: [
            KpiCard(
              titulo: 'Anomalias no período',
              valor: formatarNumero(anomalias.length),
              icone: Icons.warning_amber_rounded,
              corIcone: Cores.alerta,
              descricao: 'detectadas automaticamente',
            ),
            KpiCard(
              titulo: 'Críticas',
              valor: formatarNumero(criticas),
              icone: Icons.error_outline,
              corIcone: Cores.critico,
              descricao: 'desvio de 50% ou mais',
            ),
            KpiCard(
              titulo: 'Alertas',
              valor: formatarNumero(anomalias.length - criticas),
              icone: Icons.warning_amber_rounded,
              corIcone: Cores.alerta,
              descricao: 'desvios moderados',
            ),
            KpiCard(
              titulo: 'Viagens com falha',
              valor: formatarNumero(dados.falhas.length),
              icone: Icons.alt_route,
              descricao: '$linhasAfetadas linha(s) com anomalia',
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinhaPaineis(
          principal: Painel(
            titulo: 'Histórico de anomalias',
            subtitulo: subtituloSerie(dados, 'Anomalias detectadas por dia'),
            child: _historico(),
          ),
          lateral: Painel(
            titulo: 'Por categoria',
            subtitulo: 'Indicador em que o desvio apareceu',
            child: anomalias.isEmpty
                ? const EstadoVazio(
                    icone: Icons.check_circle_outline,
                    texto: 'Nenhuma anomalia no período',
                  )
                : ListaBarras(
                    itens: CategoriaAnomalia.values.map((categoria) {
                      final total =
                          anomalias.where((a) => a.categoria == categoria).length;
                      final fracao = total / anomalias.length;
                      return ItemBarra(
                        rotulo: categoria.rotulo,
                        proporcao: fracao,
                        valor: '$total · ${formatarPercentual(fracao, 0)}',
                      );
                    }).toList(),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        Painel(
          titulo: 'Central de anomalias',
          subtitulo: 'Desvios em relação ao padrão histórico de cada linha',
          conteudoSemMargem: true,
          acao: criticas > 0
              ? SeloContador(
                  texto: criticas == 1
                      ? '1 requer ação'
                      : '$criticas requerem ação',
                  cor: Cores.critico,
                  fundo: Cores.criticoFundo,
                )
              : null,
          child: anomalias.isEmpty
              ? const EstadoVazio(
                  icone: Icons.check_circle_outline,
                  texto: 'Nenhuma anomalia detectada no período selecionado.',
                )
              : Column(
                  children: anomalias
                      .map((anomalia) => _LinhaAnomalia(anomalia: anomalia))
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        Painel(
          titulo: 'Viagens com falha',
          subtitulo: 'Viagens programadas não realizadas, não iniciadas ou não terminadas',
          conteudoSemMargem: true,
          child: dados.falhas.isEmpty
              ? const EstadoVazio(
                  icone: Icons.check_circle_outline,
                  texto: 'Nenhuma viagem com falha no período.',
                )
              : Tabela(
                  colunas: const [
                    ColunaTabela('Data', flex: 10),
                    ColunaTabela('Linha', flex: 8),
                    ColunaTabela('Atendimento', flex: 34),
                    ColunaTabela('Horário programado', flex: 16),
                    ColunaTabela('Situação', flex: 14, alinharDireita: true),
                  ],
                  linhas: dados.falhas.map((falha) {
                    return <Widget>[
                      Text(formatarDiaMes(falha.data), style: Estilos.celulaDestaque),
                      CodigoLinha(falha.codigoLinha),
                      Text(
                        falha.atendimento,
                        overflow: TextOverflow.ellipsis,
                        style: Estilos.celula,
                      ),
                      Text(
                        '${falha.inicioProgramado} – ${falha.fimProgramado}',
                        style: Estilos.celula,
                      ),
                      Text(falha.tipo.rotulo, style: Estilos.celula),
                    ];
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _historico() {
    final dias = dados.serie.map((p) => p.data).toList();

    int contar(DateTime dia, Severidade severidade) {
      return dados.anomaliasDaSerie
          .where((a) => a.data == dia && a.severidade == severidade)
          .length;
    }

    return GraficoBarrasEmpilhadas(
      camadas: [
        SerieGrafico(
          nome: 'Alerta',
          cor: Cores.alertaClaro,
          valores: dias.map((d) => contar(d, Severidade.alerta).toDouble()).toList(),
        ),
        SerieGrafico(
          nome: 'Crítico',
          cor: Cores.critico,
          valores: dias.map((d) => contar(d, Severidade.critico).toDouble()).toList(),
        ),
      ],
      rotulosEixo: rotulosEixo(dados.serie),
      rotulosDica: rotulosDica(dados.serie),
    );
  }
}

class _LinhaAnomalia extends StatelessWidget {
  final Anomalia anomalia;

  const _LinhaAnomalia({required this.anomalia});

  @override
  Widget build(BuildContext context) {
    final cor = anomalia.severidade == Severidade.critico
        ? Cores.critico
        : Cores.alertaClaro;
    // No celular, linha e data vão para a segunda linha do texto.
    final compacto = MediaQuery.sizeOf(context).width < 640;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Cores.grade)),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          if (!compacto)
            SizedBox(
              width: 80,
              child: Text(
                anomalia.origem,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Cores.primaria,
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anomalia.descricao,
                  style: const TextStyle(fontSize: 13, color: Cores.texto),
                ),
                const SizedBox(height: 2),
                Text(
                  compacto
                      ? '${anomalia.origem} · ${formatarDiaMes(anomalia.data)} · ${anomalia.categoria.rotulo}'
                      : [anomalia.categoria.rotulo, ?anomalia.nomeLinha].join(' · '),
                  style: const TextStyle(fontSize: 11.5, color: Cores.textoMudo),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SeloStatus(severidade: anomalia.severidade),
          if (!compacto) ...[
            const SizedBox(width: 16),
            SizedBox(
              width: 44,
              child: Text(
                formatarDiaMes(anomalia.data),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Cores.textoMudo),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
