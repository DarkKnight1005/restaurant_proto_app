import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/models/categories.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app/widgets/helpWidgets/distance_determiner.dart';
import 'package:restaurant_proto_app/widgets/helpWidgets/fadeOut_bound.dart';
import 'package:restaurant_proto_app/widgets/home/category.dart';


class CategoriesPanel extends StatelessWidget {

  final Categories categories;
  final int panelNum;

  CategoriesPanel({ Key? key, required this.categories, required this.panelNum}) : super(key: key);

  HomeNotifier? homeNotifier;

  @override
  Widget build(BuildContext context) {

    homeNotifier = Provider.of<HomeNotifier>(context);

    return Padding(
    padding: const EdgeInsets.only(top: 30), //Padding from top
    child: AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: MediaQuery.of(context).size.height * .87, // Height of the panel
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(35.0)),
        boxShadow: [
          BoxShadow(
            blurRadius: 50.0,
            color: (homeNotifier!.panelNum != 1 || homeNotifier!.opacity == 0) ? Colors.grey[350]! : Colors.grey,
          ),
        ]
      ),
      margin: const EdgeInsets.fromLTRB(1000, 80, 74, 10), //Defining The margins of the panel where 1040 helping to define proper width of the panel
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35.0),
        child: Offstage(
          offstage: homeNotifier!.panelNum != 1 || homeNotifier!.opacity == 0,
          child: Opacity(
            opacity: homeNotifier!.opacity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: DistanceDeterminer(
                          getDistance: (distance){
                            homeNotifier!.updateDeltaDistanceCategoriesTop(distance);
                          }
                        ),
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   child: Container(
                      //     // height: 100,
                      //     // width: 100,
                      //     color: Colors.black,
                      //     child: DistanceDeterminer(
                      //       getDistance: (distance){
                      //         homeNotifier!.updateDeltaDistanceCategoriesBottom(distance);
                      //       }
                      //     ),
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: homeNotifier!.deltaDistanceCategoriesTop == null ? (MediaQuery.of(context).size.height * .775) : (MediaQuery.of(context).size.height - homeNotifier!.deltaDistanceCategoriesTop! - 23.2/* + homeNotifier!.deltaDistanceCategoriesBottom!*/),
                          child: Stack(
                            children: [
                              Container(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: Column(
                                      children: [
                                        for (var category in categories.categories) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Category(
                                              title: category.title, 
                                              width: 260,
                                              isSelected: category.id == homeNotifier!.selectedCategory, 
                                              onPress: (title){
                                                homeNotifier!.updateCategory(category.id);
                                              }
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 44,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FadeoutBound(height: 35),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}