
import 'package:flutter/material.dart';

class PassengersPanel extends StatelessWidget {
  const PassengersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD9E1E9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Passageiros',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172B4D),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Comparativo por categoria',
            style: TextStyle(
              fontSize: 7,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 16),

          _barra(
            titulo: 'Pagantes',
            valor: '38.520',
            porcentagem: 0.9,
            cor: const Color(0xFF1855D5),
          ),

          const SizedBox(height: 11),

          _barra(
            titulo: 'Não pagantes',
            valor: '4.210',
            porcentagem: 0.1,
            cor: const Color(0xFF18B9E6),
          ),

          const Spacer(),

          const Divider(
            height: 1,
            color: Color(0xFFE6EBF0),
          ),

          const SizedBox(height: 7),

          Row(
            children: const [
              Text(
                'Total de passageiros',
                style: TextStyle(
                  fontSize: 7,
                  color: Color(0xFF64748B),
                ),
              ),
              Spacer(),
              Text(
                '42.730',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF172B4D),
                ),
              ),
            ],
          ),

          const SizedBox(height: 2),

          const Text(
            'Não pagantes representam 9,9% do total',
            style: TextStyle(
              fontSize: 6,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barra({
    required String titulo,
    required String valor,
    required double porcentagem,
    required Color cor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 7,
                color: Color(0xFF475569),
              ),
            ),
            const Spacer(),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Stack(
          children: [
            Container(
              height: 7,
              width: double.infinity,
              color: const Color(0xFFEDF1F5),
            ),
            FractionallySizedBox(
              widthFactor: porcentagem,
              child: Container(
                height: 7,
                color: cor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
