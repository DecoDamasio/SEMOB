import 'package:flutter/material.dart';

import '../models/operacao.dart';
import '../theme/tema.dart';

class SeletorPeriodo extends StatelessWidget {
  final Periodo selecionado;
  final ValueChanged<Periodo> onSelecionar;

  const SeletorPeriodo({
    super.key,
    required this.selecionado,
    required this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: _botoes(),
    );
  }

  Widget _botoes() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Cores.borda),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: Periodo.values.map((periodo) {
          final ativo = periodo == selecionado;

          return InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => onSelecionar(periodo),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: ativo ? Cores.primaria : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                periodo.rotulo,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                  color: ativo ? Colors.white : Cores.textoSecundario,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
