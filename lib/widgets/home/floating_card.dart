import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';

class FloatingCard extends StatelessWidget {

  final double borderRadius;
  final Map<String, double> sections;

  const FloatingCard({ 
    Key? key,
    required this.sections,
    this.borderRadius = 25,
  }) : super(key: key);


  Widget getSection(item, number, {double fontSizeTitle = 26, double fontSizeNumber = 30,}){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: TextStyle(
              fontSize: fontSizeTitle
            ),
          ),
          AnimatedFlipCounter(
            duration: Duration(milliseconds: 300),
            fractionDigits: 2,
            curve: Curves.easeInOut,
            value: number,
            suffix: "₼",
            textStyle: TextStyle(
              color: AppColors.textBlack,
              fontWeight: FontWeight.bold,
              fontSize: fontSizeNumber
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotal(){

    double totalNum = 0;

    for (var item in sections.keys.toList()) {
      totalNum += sections[item]!;
    }

    return totalNum;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            blurRadius: 90.0,
            color: Colors.grey[350]!,
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            for (var item in sections.keys.toList()) ...[
              getSection(item, sections[item]),
            ],
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: getSection("Total", calculateTotal(), fontSizeTitle: 48, fontSizeNumber: 44),
              ),
            ]
        ),
      )
    );
  }
}