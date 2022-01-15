import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/widgets/home/category.dart';

class SubCategory extends StatelessWidget {

  final String title;
  final bool isSelected;
  final Function(String title) onPress;

  const SubCategory({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onPress
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Category(
      title: title,
      isSelected: isSelected,
      onPress: onPress,
      height: 50,
      width: 130,
      fontSize: 18,
    );
  }
}