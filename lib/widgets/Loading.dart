import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';

class Loading extends StatelessWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
            height: 75,
            width: 75,
            child: SpinKitCircle(color: AppColors.primary),
          ),
      ),
    );
  }
}