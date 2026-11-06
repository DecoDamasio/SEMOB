import 'package:flutter/material.dart';

import '../../theme/tema.dart';

class ItemLegenda {
  final String nome;
  final Color cor;

  const ItemLegenda(this.nome, this.cor);
}

class Legenda extends StatelessWidget {
  final List<ItemLegenda> itens;

  const Legenda({super.key, required this.itens});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 6,
      children: itens
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item.cor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  item.nome,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Cores.textoSecundario,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
