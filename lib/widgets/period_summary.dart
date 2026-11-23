import 'package:flutter/material.dart';

class PeriodSummary extends StatelessWidget {
  const PeriodSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
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
            'Resumo do período',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172B4D),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Consolidado dos principais indicadores',
            style: TextStyle(
              fontSize: 7,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          _item('Viagens realizadas', '1.284'),
          const SizedBox(height: 8),
          _item('Quilometragem', '12.450 km'),
          const SizedBox(height: 8),
          _item('Passageiros transportados', '42.730'),
          const Spacer(),
          const Divider(
            height: 1,
            color: Color(0xFFE6EBF0),
          ),
          const SizedBox(height: 7),
          const Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 11,
                color: Color(0xFF16A36A),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Indicadores consolidados do período selecionado',
                  style: TextStyle(
                    fontSize: 6,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(String titulo, String valor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 7,
              color: Color(0xFF475569),
            ),
          ),
        ),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}