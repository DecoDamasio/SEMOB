import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

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
        children: const [
          Text(
            'Atividade recente',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 18),
          _ActivityItem(
            texto: 'Sem dados disponíveis',
          ),
          Divider(),
          _ActivityItem(
            texto: 'Nenhuma ocorrência registrada',
          ),
          Divider(),
          _ActivityItem(
            texto: 'Aguardando atualização',
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String texto;

  const _ActivityItem({
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}