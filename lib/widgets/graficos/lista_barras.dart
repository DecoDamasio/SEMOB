import 'package:flutter/material.dart';

import '../../theme/tema.dart';

class ItemBarra {
  final String rotulo;

  /// Comprimento da barra, de 0 a 1.
  final double proporcao;
  final String valor;

  const ItemBarra({
    required this.rotulo,
    required this.proporcao,
    required this.valor,
  });
}

/// Lista de barras horizontais com rótulo e valor (participações, rankings).
class ListaBarras extends StatelessWidget {
  final List<ItemBarra> itens;
  final Color cor;

  const ListaBarras({
    super.key,
    required this.itens,
    this.cor = Cores.serie1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: itens
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.rotulo,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Cores.textoSecundario,
                          ),
                        ),
                      ),
                      Text(
                        item.valor,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Cores.texto,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  BarraProgresso(proporcao: item.proporcao, cor: cor),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class BarraProgresso extends StatelessWidget {
  final double proporcao;
  final Color cor;
  final double altura;

  const BarraProgresso({
    super.key,
    required this.proporcao,
    this.cor = Cores.serie1,
    this.altura = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altura,
      decoration: BoxDecoration(
        color: Cores.grade,
        borderRadius: BorderRadius.circular(altura),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: proporcao.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(altura),
          ),
        ),
      ),
    );
  }
}
