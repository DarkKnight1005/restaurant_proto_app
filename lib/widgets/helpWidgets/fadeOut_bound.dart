import 'package:flutter/material.dart';

class FadeoutBound extends StatelessWidget {

  final double height;

  const FadeoutBound({ Key? key, this.height = 80 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0)
            ],
          ),
        ),
      ),
    );
  }
}