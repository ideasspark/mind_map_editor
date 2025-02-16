import 'dart:math';

import 'package:flutter/material.dart';

import 'line.dart';

class LinePainter extends CustomPainter {
  final Line line;

  LinePainter(this.line);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Vẽ đường kẻ
    canvas.drawLine(line.start, line.end, paint);

    // Vẽ mũi tên tại điểm cuối
    _drawArrow(canvas, line.start, line.end, paint);
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    final arrowSize = 10.0; // Kích thước mũi tên
    final angle = (end - start).direction; // Góc của đường kẻ
    final arrowTip = end;

    // Tính toán các điểm của mũi tên
    final arrowPoint1 = Offset(
      arrowTip.dx - arrowSize * cos(angle - pi / 6),
      arrowTip.dy - arrowSize * sin(angle - pi / 6),
    );
    final arrowPoint2 = Offset(
      arrowTip.dx - arrowSize * cos(angle + pi / 6),
      arrowTip.dy - arrowSize * sin(angle + pi / 6),
    );

    // Vẽ mũi tên
    final path = Path()
      ..moveTo(arrowTip.dx, arrowTip.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();
    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}