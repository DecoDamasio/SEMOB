
import 'package:flutter/material.dart';

class DashboardIndicator extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final String variation;
  final bool positive;

  const DashboardIndicator({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.variation,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 185,
      height: 80,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD9E1E9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FF),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  icon,
                  size: 10,
                  color: const Color(0xFF1554C0),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                color: positive
                    ? const Color(0xFFEAF8F1)
                    : const Color(0xFFFFF4E9),
                child: Text(
                  variation,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: positive
                        ? const Color(0xFF14804A)
                        : const Color(0xFFBD6B00),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              fontSize: 7,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 1),

          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),

          Text(
            unit,
            style: const TextStyle(
              fontSize: 6,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
