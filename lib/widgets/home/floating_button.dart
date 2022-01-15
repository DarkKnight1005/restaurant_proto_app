import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';

class FloatingButton extends StatelessWidget {

  final Color bgColor;
  final double borderRadius;
  final Color textColor;
  final String title;
  final double fontSize;
  final double height;
  final FontWeight fontWeight;
  final Widget? prefixWidget;
  final Function()? onPressed;

  const FloatingButton({ 
    Key? key,
    this.bgColor = AppColors.primary,
    this.borderRadius = 25.0,
    this.textColor = AppColors.textWhite,
    this.fontSize = 30,
    this.fontWeight = FontWeight.bold,
    this.prefixWidget,
    this.height = 100,
    this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTap(
        scaleMinValue: 0.85,
        opacityMinValue: 1,
        onPressed: onPressed,
        child: AnimatedOpacity(
          opacity: onPressed == null ? 0.65 : 1,
          duration: Duration(milliseconds: 300),
          child: Container(
            // duration: Duration(milliseconds: 300),
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: this.bgColor,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 50,
                  color: Colors.grey[350]!
                ),
              ]
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefixWidget != null ? prefixWidget! : Container(height: 0, width: 0,),
                  SizedBox(width: prefixWidget != null ? 50 : 0,),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: fontWeight,
                      fontSize: fontSize,
                      color: textColor
                    ),
                  )
                ],
              )
            ),
          ),
        )
    );
  }
}