import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';

class Category extends StatefulWidget {

  final String title;
  final bool isSelected;
  final Function(String title) onPress;
  final double height;
  final double width;
  final double fontSize;

  const Category({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onPress,
    this.height = 75,
    this.width = 200,
    this.fontSize = 25
  }) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

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
      onTap: () => widget.onPress(widget.title),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: this.widget.height,
        width: this.widget.width,
        decoration: BoxDecoration(
          color: widget.isSelected 
          ? AppColors.primary.withOpacity(isHover ? 0.75: 1)
          : AppColors.bg.withOpacity(isHover ? 0.75: 1),
          borderRadius: BorderRadius.all(Radius.circular(45.0)),
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: widget.isSelected 
              ? AppColors.textWhite.withOpacity(isHover ? 0.75: 1)
              : AppColors.textGrey.withOpacity(isHover ? 0.75: 1),
              fontSize: this.widget.fontSize,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}