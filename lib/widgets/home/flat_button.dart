import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';

// enum ColorSet{
//   STANDART,
//   RED,
//   WHITE,
// }

class FlatButtonCustom extends StatefulWidget {

  final String title;
  final Function()? onPress;
  final double fontSize;
  final FontWeight fontWeight;
  final Color bg;
  final Color textColor;
  final double innerHorizontalPadding;
  final double innerVerticalPadding;
  final double borderRadius;
  final bool hasFeedback;

  FlatButtonCustom({
    Key? key,
    required this.title,
    this.onPress,
    this.bg = AppColors.bg,
    this.textColor = AppColors.textGrey,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 25,
    this.innerHorizontalPadding = 35,
    this.innerVerticalPadding = 35,
    this.borderRadius = 35,
    this.hasFeedback = true,
  }): super(key: key);

  @override
  State<FlatButtonCustom> createState() => _FlatButtonCustomState();
}

class _FlatButtonCustomState extends State<FlatButtonCustom> with SingleTickerProviderStateMixin{

  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
              child: InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onHighlightChanged: (value) {
                  if(widget.hasFeedback){
                    setState(() {
                      isHover = value;
                    });
                  }
                },
                onTap: widget.onPress,
                child: AnimatedSize(
                  duration: Duration(milliseconds: 150),
                  reverseDuration: Duration(milliseconds: 150),
                  curve: Curves.linear,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: this.widget.bg.withOpacity(isHover || widget.onPress == null ? 0.75: 1),
                      borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.innerHorizontalPadding, vertical: widget.innerVerticalPadding),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: this.widget.textColor.withOpacity(isHover ? 0.75: 1),
                            fontSize: this.widget.fontSize,
                            fontWeight: this.widget.fontWeight
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}