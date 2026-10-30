import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../theme/tema.dart';

/// Selo de situação: Normal, Alerta ou Crítico (cor sempre acompanhada do texto).
class SeloStatus extends StatelessWidget {
  final Severidade? severidade;

  const SeloStatus({super.key, required this.severidade});

  @override
  Widget build(BuildContext context) {
    final (texto, cor, fundo) = switch (severidade) {
      Severidade.critico => ('Crítico', Cores.critico, Cores.criticoFundo),
      Severidade.alerta => ('Alerta', Cores.alerta, Cores.alertaFundo),
      null => ('Normal', Cores.sucesso, Cores.sucessoFundo),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cor.withValues(alpha: 0.35)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: cor,
        ),
      ),
    );
  }
}

/// Código da linha em destaque, ex.: [01].
class CodigoLinha extends StatelessWidget {
  final String codigo;

  const CodigoLinha(this.codigo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Cores.infoFundo,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        codigo,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Cores.primaria,
        ),
      ),
    );
  }
}

/// Contador em formato de pílula, ex.: "3 alertas".
class SeloContador extends StatelessWidget {
  final String texto;
  final Color cor;
  final Color fundo;

  const SeloContador({
    super.key,
    required this.texto,
    required this.cor,
    required this.fundo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: cor,
        ),
      ),
    );
  }
}
