import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/widgets/home/flat_button.dart';
import 'package:after_layout/after_layout.dart';
import 'package:simple_timer/simple_timer.dart';

class TimerButton extends StatefulWidget {

  final String title;
  final Function() onPress;
  Function(Function() startTimer)? timerFunction;
  final double fontSize;
  final FontWeight fontWeight;
  final Color bg;
  final Color textColor;
  final double innerHorizontalPadding;
  final double innerVerticalPadding;
  final double borderRadius;
  final bool hasFeedback;

  TimerButton({
    Key? key,
    required this.title,
    required this.onPress,
    this.bg = AppColors.bg,
    this.textColor = AppColors.textGrey,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 25,
    this.innerHorizontalPadding = 35,
    this.innerVerticalPadding = 35,
    this.borderRadius = 35,
    this.hasFeedback = true,
    required this.timerFunction,
  }): super(key: key);

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> with AfterLayoutMixin<TimerButton>, SingleTickerProviderStateMixin{

  bool isPressed = false;

  double? _height = 0;
  double? _width = 0;

  late TimerController _timerController;

  @override
  void initState() {
    widget.timerFunction!(startTimer);
    _timerController = TimerController(this);
    super.initState();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      _height = context.size?.height;
      _width = context.size?.width;
    });
  }

  void startTimer(){
    setState(() {
      isPressed = true;
    });
    _timerController.addStatusListener((status) { 
      if(status == AnimationStatus.completed){
        setState(() {
          isPressed = false;
        });
        _timerController.reset();
      }
    });
     _timerController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlatButtonCustom(
          title: widget.title, 
          onPress: widget.onPress,
          bg: widget.bg,
          textColor: widget.textColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          innerHorizontalPadding: widget.innerHorizontalPadding,
          innerVerticalPadding: widget.innerVerticalPadding,
          borderRadius: widget.borderRadius,
          hasFeedback: widget.hasFeedback,
        ),
        Offstage(
          offstage: !isPressed,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _height,
            width: _width,
            decoration: BoxDecoration(
              color: AppColors.bg.withOpacity(isPressed ? 0.75 : 0),
              borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
            ),
            child: SimpleTimer(
                displayProgressIndicator: false,
                controller: _timerController,
                backgroundColor: Colors.transparent,
                duration: Duration(seconds: 60),
                progressTextStyle: TextStyle(color: AppColors.textBlack, fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }
}