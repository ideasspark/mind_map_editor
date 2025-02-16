import 'package:flutter/cupertino.dart';
import 'package:mind_map_editor/line.dart';
import 'package:mind_map_editor/line_painter.dart';

class LineWidget {
  final Line line;

  LineWidget(this.line);

  Widget renderUI() => CustomPaint(
    // key: ValueKey(line.uid),
    size: Size.infinite,
    painter: LinePainter(line),
  );
}
