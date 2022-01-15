import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';

class IconButtonBG extends StatefulWidget {

  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double scaleFactor;
  final Function() onPress;

  const IconButtonBG({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    this.bgColor = AppColors.bg,
    this.scaleFactor = 1,
    }) : super(key: key);

  @override
  State<IconButtonBG> createState() => _IconButtonBGState();
}

class _IconButtonBGState extends State<IconButtonBG> {

  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onHighlightChanged: (value) => setState(() {
        isHover = value;
      }),
      onTap: widget.onPress,
      child: AnimatedOpacity(
        opacity: isHover ? 0.75: 1,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: 100 * widget.scaleFactor,
          width: 100 * widget.scaleFactor,
          decoration: BoxDecoration(
            color: this.widget.bgColor.withOpacity(1),
            borderRadius: BorderRadius.all(Radius.circular(35.0 * (widget.scaleFactor * 0.9))),
          ),
          child: Center(
            child: Icon(widget.icon, size: widget.iconSize, color: widget.iconColor.withOpacity(1),)
          ),
        ),
      ),
    );
  }
}