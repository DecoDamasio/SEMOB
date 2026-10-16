import 'package:flutter/material.dart';

class MovementChart extends StatelessWidget {
  const MovementChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFE1E4E8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Movimentação',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Dados de movimentação',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _ChartBar(altura: 70),
                _ChartBar(altura: 110),
                _ChartBar(altura: 85),
                _ChartBar(altura: 130),
                _ChartBar(altura: 95),
                _ChartBar(altura: 120),
                _ChartBar(altura: 75),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double altura;

  const _ChartBar({
    required this.altura,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: altura,
            width: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFDCE7F8),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}