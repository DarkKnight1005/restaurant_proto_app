import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class DistanceDeterminer extends StatefulWidget {

  final Function(double distance) getDistance;

  DistanceDeterminer({Key? key, required this.getDistance}) : super(key: key);

  @override
  DistanceDeterminerState createState() => DistanceDeterminerState();
}

class DistanceDeterminerState extends State<DistanceDeterminer> with AfterLayoutMixin<DistanceDeterminer>{

  @override
  void afterFirstLayout(BuildContext context) {
    updateDistance();
  }

  updateDistance(){
    setState(() {
      
    });
    RenderBox? box = context.findRenderObject() as RenderBox?;
    Offset position = box!.localToGlobal(Offset.zero);

    this.widget.getDistance(position.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: 1,
    );
  }
}