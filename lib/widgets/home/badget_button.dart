import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/widgets/home/icon_button_bg.dart';

class BadgedButton extends StatelessWidget {

  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Function() onPress;
  final double scaleFactor;
  final int badgeNum;

  const BadgedButton({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.scaleFactor,
    this.bgColor = AppColors.bg,
    this.badgeNum = 0,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: 125,
      child: Stack(
        children: [
          Center(
            child: Container(
              // height: 100,
              // width: 100,
              child: IconButtonBG(onPress: onPress, icon: icon, iconColor: iconColor, iconSize: iconSize, scaleFactor: scaleFactor,)
            ),
          ),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            // offstage: badgeNum == 0,
            crossFadeState: badgeNum == 0 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Padding(
              padding: const EdgeInsets.only(right: 17, top: 17),
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primaryRed,
                  child: AnimatedFlipCounter(
                    duration: Duration(milliseconds: 200),
                    value: badgeNum > 99 ? 99 : badgeNum >= 1 ? badgeNum : 1,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  // Text(
                  //   badgeNum > 99 ? "99" : badgeNum.toString(),
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 16
                  //   ),
                  // ),
                )
              ),
            ),
            secondChild: Container(),
          ),
        ],
      ),
    );
  }
}