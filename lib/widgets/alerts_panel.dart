
import 'package:flutter/material.dart';

class AlertsPanel extends StatelessWidget {
  const AlertsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD9E1E9),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 37,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 14,
                  color: Color(0xFFF19A19),
                ),
                SizedBox(width: 7),
                Text(
                  'Alertas e possíveis anomalias',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172B4D),
                  ),
                ),
              ],
            ),
          ),

          _alert(
            color: const Color(0xFFF59E0B),
            title: 'Queda no número de viagens',
            description:
                'O total ficou 4,8% abaixo do período anterior. Verificar registros das linhas municipais.',
          ),

          _alert(
            color: const Color(0xFF3182F6),
            title: 'Pico de passageiros às 18h',
            description:
                'Volume 12% acima da média diária no horário de maior movimento.',
          ),
        ],
      ),
    );
  }

  Widget _alert({
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        11,
        9,
        11,
        9,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8EDF2),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 6,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
