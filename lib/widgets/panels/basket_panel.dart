import 'package:after_layout/after_layout.dart';
import 'package:automatic_animated_list/automatic_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/models/product.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:flip_card/flip_card.dart';
import 'package:restaurant_proto_app/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app/services/API/orderer_service.dart';
import 'package:restaurant_proto_app/widgets/helpWidgets/fadeOut_bound.dart';
import 'package:restaurant_proto_app/widgets/home/basket_item.dart';
import 'package:restaurant_proto_app/widgets/home/flat_button.dart';
import 'package:restaurant_proto_app/widgets/home/floating_button.dart';
import 'package:restaurant_proto_app/widgets/home/floating_card.dart';

class BasketPanel extends StatefulWidget {

   final int panelNum;

  BasketPanel({ Key? key, required this.panelNum}) : super(key: key);

  @override
  State<BasketPanel> createState() => _BasketPanelState();
}

class _BasketPanelState extends State<BasketPanel> with AfterLayoutMixin<BasketPanel>{

  HomeNotifier? homeNotifier;
  BasketNotifier? basketNotifier;
  OrderNotifier? orderNotifier;

  late OrderService orderService;

  @override
  void afterFirstLayout(BuildContext context) {
    orderService = OrderService(orderNotifier: orderNotifier!, basketNotifier: basketNotifier!);
  }

  @override
  Widget build(BuildContext context) {

    homeNotifier = Provider.of<HomeNotifier>(context);
    basketNotifier = Provider.of<BasketNotifier>(context);
    orderNotifier = Provider.of<OrderNotifier>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 30),  //Padding from top
      child: Container(
        height: MediaQuery.of(context).size.height * .95, // Height of the panel
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 50.0,
              color: Colors.grey,
            ),
          ]
        ),
        margin: const EdgeInsets.fromLTRB(80, 0, 560, 20), //Defining The margins of the panel where 1040 helping to define proper width of the panel
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35.0),
            child: Opacity(
              opacity: homeNotifier!.opacity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Current Order",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(child: Container(height: 1,)),
                        FlatButtonCustom(
                          title: "Ordered", 
                          onPress: (){
                            homeNotifier!.updatePanelType(PanelType.ORDERED);
                          },
                          innerHorizontalPadding: 25,
                          innerVerticalPadding: 20,
                          borderRadius: 20,
                          fontSize: 20,
                        ),
                        SizedBox(width: 12,),
                        FlatButtonCustom(
                          title: "Clear All", 
                          onPress: (){
                            basketNotifier!.removeAll();
                          },
                          innerHorizontalPadding: 25,
                          innerVerticalPadding: 20,
                          borderRadius: 20,
                          fontSize: 20,
                          bg: AppColors.secondaryRed,
                          textColor: AppColors.primaryRed,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .70,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .65,
                            width: double.infinity,
                            child: AutomaticAnimatedList<int>(
                              items: basketNotifier!.orderedProducts.keys.toList(),
                              insertDuration: Duration(milliseconds: 300),
                              removeDuration: Duration(milliseconds: basketNotifier!.lastEvent == EventType.REMOVE_ALL ? basketNotifier!.removeAllInterval : 300),
                              keyingFunction: (int item) => Key(item.toString()),
                              itemBuilder:
                                  (BuildContext context, int item, Animation<double> animation) {
                                    int index = basketNotifier!.orderedProducts.keys.toList().indexOf(item);
                                    index = index == -1 ? basketNotifier!.removedIndex : index;
                                return Padding(
                                  padding: EdgeInsets.only(top: index == 0 && basketNotifier!.lastEvent != EventType.REMOVE_ALL ? 6 : 0, bottom: (index == basketNotifier!.getNumOfBasketProducts() - 1 && index != basketNotifier!.removedIndex && index != basketNotifier!.removedIndex - 1) ? 175 : 0),
                                  child: FadeTransition(
                                    key: Key(item.toString()),
                                    opacity: animation,
                                    child: SizeTransition(
                                      sizeFactor: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOut,
                                        reverseCurve: Curves.easeIn,
                                      ),
                                      child: BasketItem(product: basketNotifier!.productsData[item] ?? basketNotifier!.removedProduct!)
                                    ),
                                  ),
                                );
                              },
                            )
                          ),
                          Center(
                            child: Offstage(
                              offstage: basketNotifier!.getNumOfBasketProducts() != 0,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SpinKitPouringHourGlass(
                                      color: AppColors.textGrey,
                                      size: 70,
                                    ),
                                    SizedBox(height: 12,),
                                    Text(
                                      "Waiting for a new item...",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: AppColors.textGrey
                                      ),
                                    ),
                                    SizedBox(height: 250,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 0,
                          //   left: 0,
                          //   right: 0,
                          //   child: RotatedBox(
                          //     quarterTurns: 2,
                          //     child: FadeoutBound(height: 30)
                          //   ),
                          // ),
                          FadeoutBound(height: 30),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: FloatingCard(
                              sections: {
                                "Current": basketNotifier!.getTotalPrice(),
                                "Ordered": orderNotifier!.getTotalPrice(),
                            },
                          ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container(width: 1)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FloatingButton(
                        onPressed: basketNotifier!.getNumOfBasketProducts() == 0 ? null : (){
                          orderService.makeOrder();
                        },
                        title: "Make Order"
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
