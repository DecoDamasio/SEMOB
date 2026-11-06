import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:semob/pages/home_page.dart';
import 'package:semob/services/operacao_service.dart';

/// Responde com os JSONs salvos em test/fixtures (cópias reais da API).
OperacaoService _serviceDeTeste() {
  final cliente = MockClient((requisicao) async {
    final rota = requisicao.url.pathSegments.last;
    final periodo = requisicao.url.queryParameters['periodo'];
    final arquivo = File('test/fixtures/${rota}_$periodo.json');
    return http.Response.bytes(
      await arquivo.readAsBytes(),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  });
  return OperacaoService(client: cliente);
}

/// A leitura dos arquivos é IO real: deixa rodar fora do relógio falso do teste.
Future<void> _esperarCarregamento(WidgetTester tester) async {
  for (var i = 0; i < 20 && find.byType(CircularProgressIndicator).evaluate().isNotEmpty; i++) {
    await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 50)));
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

const _abas =['Visão geral', 'Passagens', 'Operações', 'Anomalias', 'Finanças'];
const _periodos = ['Diário', 'Semanal', 'Mensal'];

void main() {
  for (final tamanho in [const Size(1440, 900), const Size(390, 844)]) {
    testWidgets(
      'todas as abas e períodos renderizam sem overflow em ${tamanho.width.toInt()}px',
      (tester) async {
        tester.view.physicalSize = tamanho;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(home: HomePage(service: _serviceDeTeste())),
        );
        await _esperarCarregamento(tester);

        for (final periodo in _periodos) {
          await tester.tap(find.text(periodo));
          await _esperarCarregamento(tester);

          // No celular o menu de abas rola; volta para o início a cada período.
          final menu = find.byType(ListView).first;
          await tester.drag(menu, const Offset(2000, 0));
          await tester.pumpAndSettle();

          for (final aba in _abas) {
            await tester.dragUntilVisible(find.text(aba).first, menu, const Offset(-80, 0));
            await tester.tap(find.text(aba).first);
            await tester.pumpAndSettle();

            final erro = tester.takeException();
            expect(
              erro,
              isNull,
              reason: '$aba / $periodo\n'
                  '${erro is FlutterError ? erro.toStringDeep() : erro}',
            );
            expect(find.text('Não foi possível carregar os dados da API'), findsNothing);
          }
        }
      },
    );
  }
}
