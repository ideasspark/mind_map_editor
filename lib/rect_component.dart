import 'package:flutter/material.dart';

class RectComponent extends StatefulWidget {
  final Offset initialPosition;
  final Color color;
  final Function(RectComponent) onTap;
  final Function(RectComponent, Offset) onPositionChanged;
  final Function(RectComponent)? onRightClick;
  Offset Function()? currentPosition;

  RectComponent({
    Key? key,
    required this.initialPosition,
    required this.color,
    required this.onTap,
    required this.onPositionChanged,
    this.currentPosition,
    this.onRightClick,
  }) : super(key: key);

  @override
  RectComponentState createState() => RectComponentState();
}

class RectComponentState extends State<RectComponent> {
  Offset _position = Offset.zero;

  Offset get position => _position;

  @override
  void initState() {
    super.initState();
    widget.currentPosition = () => _position;
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onTap: () => widget.onTap(widget),
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
          widget.onPositionChanged(this.widget, _position);
        },
        onSecondaryTap: (){
          widget.onRightClick?.call(widget);
        },
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 100,
            minHeight: 50,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.color,
          ),
          child: const Center(
            child: Text(
              'Drag me!',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
