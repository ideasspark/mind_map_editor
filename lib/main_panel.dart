import 'package:flutter/material.dart';
import 'package:mind_map_editor/rect_component.dart';

import 'comonent_type.dart';
import 'line.dart';
import 'line_painter.dart';
import 'line_widget.dart'; // Import RectWidget

class MainPanel extends StatefulWidget {
  @override
  MainPanelState createState() => MainPanelState();
}

class MainPanelState extends State<MainPanel>{
  final List<RectComponent> rectWidgets = [];
  ComponentType _selectedComponentType = ComponentType.rect;

  RectComponent? _selectedStartWidget; // Widget được chọn làm điểm đầu
  RectComponent? _selectedEndWidget; //Widget được chọn làm điểm cuối

  final List<LineWidget> lines = [];

  DateTime? _lastClickTime;


  void _addRectWidget(Offset position) {

    setState(() {
      rectWidgets.add(
        RectComponent(
          key: UniqueKey(),
          initialPosition: position,
          color: Colors.blueAccent,
          onTap:_handleWidgetTap,
          onPositionChanged: _handleWidgetPositionChanged,
          onRightClick: _handleWidgetRightClick,
        ),
      );
    });
  }


  void _handleWidgetTap(RectComponent widget) {
    if(_selectedComponentType == ComponentType.line){
      setState(() {
        if (_selectedStartWidget == null) {
          // Chọn điểm đầu
          _selectedStartWidget = widget;
        } else if (_selectedEndWidget == null && widget != _selectedStartWidget) {
          // Chọn điểm cuối
          _selectedEndWidget = widget;
          // Thêm đường kẻ vào danh sách
          lines.add(LineWidget(Line(_selectedStartWidget!, _selectedEndWidget!)));

          // Reset các widget được chọn
          _selectedStartWidget = null;
          _selectedEndWidget = null;
        }

      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('Draggable RectWidgets'),
        actions: [
          IconButton(
            onPressed: () {
              _selectedComponentType = ComponentType.rect;
            },
            icon: Icon(Icons.rectangle),
          ),
          IconButton(
            onPressed: () {
              _selectedComponentType = ComponentType.line;
            },
            icon: Icon(Icons.line_axis),
          ),
        ],
      ),
      body: Listener(
        onPointerDown: _handleDoubleClick,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              // Vẽ các đường kẻ
              for (var line in lines)
                GestureDetector(
                  key: ValueKey(line.line.uid),
                  // onTap: () => _handleLineTap(line),
                  // onTapDown: (details) => _handleLineTap(line, details.localPosition),
                  onSecondaryTapDown: (details) => _handleLineTap(line, details.localPosition),
                  child: line.renderUI(),
                ),
              ...rectWidgets,
            ],
          ),
        ),
      ),
    );
  }

  void _handleDoubleClick(PointerDownEvent event) {
    final now = DateTime.now();
    if (_lastClickTime != null &&
        now.difference(_lastClickTime!) < Duration(milliseconds: 500)) {
      // Double-click detected
      RenderBox box = context.findRenderObject() as RenderBox;
      // Offset localPosition = box.globalToLocal(event.position);
      // localPosition = Offset(localPosition.dx - 50, localPosition.dy - 25);
      var localPosition =
          Offset(event.localPosition.dx - 50, event.localPosition.dy - 25);
      _addRectWidget(localPosition);
    }
    _lastClickTime = now;
  }

  _handleWidgetPositionChanged(RectComponent p1, Offset p2) {
    // setState(() {
    //   // Cập nhật tất cả các đường kẻ liên quan đến widget này
    //   for (var line in lines) {
    //     if (line.startWidget == widget || line.endWidget == widget) {
    //       // Đường kẻ sẽ tự động cập nhật vì nó tham chiếu đến widget
    //     }
    //   }
    // });
  }

  void _handleWidgetRightClick(RectComponent widget) {
    // Hiển thị popup menu
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        widget.currentPosition!().dx,
        widget.currentPosition!().dy,
        widget.currentPosition!().dx + 100,
        widget.currentPosition!().dy + 100,
      ),
      items: [
        PopupMenuItem(
          child: Text('Xóa'),
          onTap: () {
            // Xóa widget khỏi danh sách
            setState(() {
              rectWidgets.remove(widget);
              // widgets.remove(widget);
              // Xóa các đường kẻ liên quan
              // lines.removeWhere((line) => line.startWidget == widget || line.endWidget == widget);
            });
          },
        ),
      ],
    );
  }
  void _handleLineTap( LineWidget line,Offset tapPosition,) {
    Line? closestLine;
    double closestDistance = double.infinity;

    // Tìm đường kẻ gần nhất với vị trí click
    for (var line in lines) {
      final distance = _distanceToLine(tapPosition, line.line);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestLine = line.line;
      }
    }

    // Nếu tìm thấy đường kẻ gần nhất, hiển thị popup menu
    if (closestLine != null) {
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
          tapPosition.dx,
          tapPosition.dy,
          tapPosition.dx + 100,
          tapPosition.dy + 100,
        ),
        items: [
          PopupMenuItem(
            child: Text('Xóa'),
            onTap: () {
              // Xóa đường kẻ khỏi danh sách
              setState(() {
                lines.removeWhere((l) => l.line == closestLine);
              });
            },
          ),
        ],
      );
    }
  }

// Tính khoảng cách từ điểm đến đường kẻ
  double _distanceToLine(Offset point, Line line) {
    final start = line.start;
    final end = line.end;

    // Vector từ điểm đầu đến điểm cuối của đường kẻ
    final lineVector = end - start;
    // Vector từ điểm đầu đến điểm click
    final pointVector = point - start;

    // Tính toán hình chiếu của điểm click lên đường kẻ
    final t = (pointVector.dx * lineVector.dx + pointVector.dy * lineVector.dy) /
        (lineVector.dx * lineVector.dx + lineVector.dy * lineVector.dy);

    // Giới hạn t trong khoảng [0, 1] để đảm bảo hình chiếu nằm trên đoạn thẳng
    final clampedT = t.clamp(0.0, 1.0);
    final closestPoint = start + Offset(lineVector.dx * clampedT, lineVector.dy * clampedT);

    // Khoảng cách từ điểm click đến điểm gần nhất trên đường kẻ
    return (point - closestPoint).distance;
  }
}

void main() {
  runApp(MaterialApp(
    home: MainPanel(),
  ));
}
