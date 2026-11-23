
import 'package:flutter/material.dart';

class OperationChart extends StatelessWidget {
  const OperationChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 8),
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
            'Evolução da operação',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF172B4D),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Quantidade de viagens ao longo do período',
            style: TextStyle(
              fontSize: 7,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 5),

          Expanded(
            child: CustomPaint(
              painter: _ChartPainter(),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE7ECF2)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF1855D5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFF1855D5)
      ..style = PaintingStyle.fill;

    final pointBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final chartLeft = size.width * .30;
    final chartRight = size.width * .70;
    final chartTop = 18.0;
    final chartBottom = size.height - 19;

    final gridValues = [
      chartTop + 4,
      chartTop + 30,
      chartTop + 56,
    ];

    for (final y in gridValues) {
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        gridPaint,
      );
    }

    final points = [
      Offset(chartLeft + 5, chartBottom - 5),
      Offset(chartLeft + 38, chartBottom - 19),
      Offset(chartLeft + 70, chartBottom - 12),
      Offset(chartLeft + 103, chartBottom - 45),
      Offset(chartLeft + 136, chartBottom - 32),
      Offset(chartLeft + 169, chartBottom - 60),
      Offset(chartLeft + 202, chartBottom - 51),
    ];

    final path = Path();

    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(
          points[i].dx,
          points[i].dy,
        );
      } else {
        path.lineTo(
          points[i].dx,
          points[i].dy,
        );
      }
    }

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(
        point,
        3.7,
        pointPaint,
      );

      canvas.drawCircle(
        point,
        1.8,
        pointBorder,
      );
    }

    final textStyle = const TextStyle(
      fontSize: 6,
      color: Color(0xFF7890A8),
    );

    _text(
      canvas,
      '06h',
      Offset(chartLeft - 1, size.height - 9),
      textStyle,
    );

    _text(
      canvas,
      '09h',
      Offset(chartLeft + 82, size.height - 9),
      textStyle,
    );

    _text(
      canvas,
      '12h',
      Offset(chartLeft + 165, size.height - 9),
      textStyle,
    );

    _text(
      canvas,
      '15h',
      Offset(chartLeft + 247, size.height - 9),
      textStyle,
    );

    _text(
      canvas,
      '18h',
      Offset(chartLeft + 330, size.height - 9),
      textStyle,
    );

    _text(
      canvas,
      '21h',
      Offset(chartLeft + 413, size.height - 9),
      textStyle,
    );

    _text(
      canvas,
      '00h',
      Offset(chartLeft + 496, size.height - 9),
      textStyle,
    );

    final legendPaint = Paint()
      ..color = const Color(0xFF1855D5);

    canvas.drawCircle(
      Offset(size.width - 63, 7),
      2.5,
      legendPaint,
    );

    _text(
      canvas,
      'Viagens realizadas',
      Offset(size.width - 58, 2),
      const TextStyle(
        fontSize: 6,
        color: Color(0xFF64748B),
      ),
    );
  }

  void _text(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      offset,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}
