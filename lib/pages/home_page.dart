import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../services/operacao_service.dart';
import '../theme/tema.dart';
import '../utils/formatacao.dart';
import '../widgets/app_header.dart';
import '../widgets/seletor_periodo.dart';
import 'anomalias_page.dart';
import 'financas_page.dart';
import 'operacoes_page.dart';
import 'passagens_page.dart';
import 'visao_geral_page.dart';

class _Aba {
  final AbaMenu menu;
  final String subtitulo;
  final Widget Function(DadosPainel dados) construir;

  const _Aba(this.menu, this.subtitulo, this.construir);
}

final _abas = [
  _Aba(
    const AbaMenu('Visão geral', Icons.grid_view_outlined),
    'Resumo consolidado da operação municipal',
    (dados) => VisaoGeralPage(dados: dados),
  ),
  _Aba(
    const AbaMenu('Passagens', Icons.person_outline),
    'Fluxo, perfil e demanda de passageiros',
    (dados) => PassagensPage(dados: dados),
  ),
  _Aba(
    const AbaMenu('Operações', Icons.directions_bus_outlined),
    'Quilometragem, viagens e desempenho das linhas',
    (dados) => OperacoesPage(dados: dados),
  ),
  _Aba(
    const AbaMenu('Anomalias', Icons.warning_amber_outlined),
    'Desvios detectados automaticamente nos dados da operação',
    (dados) => AnomaliasPage(dados: dados),
  ),
  _Aba(
    const AbaMenu('Finanças', Icons.payments_outlined),
    'Receita tarifária e desempenho financeiro',
    (dados) => FinancasPage(dados: dados),
  ),
];

class HomePage extends StatefulWidget {
  final OperacaoService? service;

  const HomePage({super.key, this.service});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final OperacaoService _service = widget.service ?? OperacaoService();

  int _abaSelecionada = 0;
  Periodo _periodo = Periodo.semanal;
  late Future<DadosPainel> _dados;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _dados = _service.buscarPainel(_periodo);
  }

  @override
  Widget build(BuildContext context) {
    final aba = _abas[_abaSelecionada];

    return Scaffold(
      backgroundColor: Cores.fundo,
      body: FutureBuilder(
        future: _dados,
        builder: (context, snapshot) {
          return Column(
            children: [
              AppHeader(
                abas: _abas.map((a) => a.menu).toList(),
                abaSelecionada: _abaSelecionada,
                onSelecionarAba: (index) {
                  setState(() => _abaSelecionada = index);
                },
                erro: snapshot.hasError,
                situacaoDados: snapshot.hasData
                    ? 'Dados até ${formatarDiaMes(snapshot.data!.resumo.fim)}'
                    : null,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1240),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _cabecalho(aba, snapshot.data),
                            const SizedBox(height: 20),
                            _conteudo(aba, snapshot),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cabecalho(_Aba aba, DadosPainel? dados) {
    final resumo = dados?.resumo;
    final intervalo = resumo == null
        ? ''
        : resumo.inicio == resumo.fim
            ? ' · ${formatarDiaMes(resumo.fim)}'
            : ' · ${formatarDiaMes(resumo.inicio)} a ${formatarDiaMes(resumo.fim)}';

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 12,
      spacing: 20,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(aba.menu.rotulo, style: Estilos.tituloPagina),
            const SizedBox(height: 4),
            Text('${aba.subtitulo}$intervalo', style: Estilos.subtituloPagina),
          ],
        ),
        SeletorPeriodo(
          selecionado: _periodo,
          onSelecionar: (periodo) {
            setState(() {
              _periodo = periodo;
              _carregar();
            });
          },
        ),
      ],
    );
  }

  Widget _conteudo(_Aba aba, AsyncSnapshot<DadosPainel> snapshot) {
    if (snapshot.hasError) {
      return _erro(snapshot.error!);
    }

    // Enquanto recarrega outro período, mantém os dados anteriores na tela.
    if (!snapshot.hasData) {
      return const Padding(
        padding: EdgeInsets.all(60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return aba.construir(snapshot.data!);
  }

  Widget _erro(Object erro) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Cores.criticoFundo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5C2C2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Não foi possível carregar os dados da API',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Cores.critico,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Verifique se a API está rodando em ${OperacaoService.baseUrl} '
            '(pasta server: npm start).\n$erro',
            style: const TextStyle(fontSize: 12.5, color: Cores.textoSecundario),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => setState(_carregar),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
