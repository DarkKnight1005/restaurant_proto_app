import 'package:after_layout/after_layout.dart';
import 'package:automatic_animated_list/automatic_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:fluttericon/linecons_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/models/order_data.dart';
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
import 'package:restaurant_proto_app/widgets/home/ordered_item.dart';

class OrderedPanel extends StatefulWidget {

   final int panelNum;

  OrderedPanel({ Key? key, required this.panelNum}) : super(key: key);

  @override
  State<OrderedPanel> createState() => _OrderedPanelState();
}

class _OrderedPanelState extends State<OrderedPanel> with AfterLayoutMixin<OrderedPanel>{

  HomeNotifier? homeNotifier;
  OrderNotifier? orderNotifier;
  BasketNotifier? basketNotifier;

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
                            "Ordered",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Expanded(child: Container(height: 1,)),
                        FlatButtonCustom(
                          title: "Current Order", 
                          onPress: (){
                            homeNotifier!.updatePanelType(PanelType.CURRENT_ORDER);
                          },
                          innerHorizontalPadding: 25,
                          innerVerticalPadding: 20,
                          borderRadius: 20,
                          fontSize: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Product",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                            fontSize: 26,
                          ),
                        ),
                        SizedBox(width: 252,),
                        Text(
                          "Count",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
                            fontSize: 26,
                          ),
                        ),
                        Expanded(child: Container(height: 0,)),
                        Padding(
                          padding: const EdgeInsets.only(right: 38),
                          child: Text(
                            "Price",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                              fontSize: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .67,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .62,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount: orderNotifier!.ordered.order.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: index == orderNotifier!.ordered.order.length - 1 ? 155 : 0),
                                  child: OrderedItem(order: orderNotifier!.ordered.order[index]),
                                );
                              },
                            ),
                          ),
                          Center(
                            child: Offstage(
                              offstage: orderNotifier!.ordered.order.length != 0,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      LineariconsFree.sad, 
                                      size: 55,
                                      color: AppColors.textGrey,
                                    ),
                                    SizedBox(height: 12,),
                                    Text(
                                      "Nothing is ordered yet",
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
                          FadeoutBound(height: 35),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: FloatingCard(
                              sections: {
                                "Subtotal": orderNotifier!.ordered.totalPrice,
                                "Service Fee": orderNotifier!.ordered.totalPrice * 0.05,
                            },
                          ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container(width: 1)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        transitionBuilder: (Widget child , Animation<double> animation) => ScaleTransition(scale: animation, child: child,),
                        child: !orderNotifier!.canShowCheckoutTypes
                        ? FloatingButton(
                          onPressed: orderNotifier!.isCheckoutRequested
                           ? null
                           : () => orderNotifier!.showCheckoutTypes(),
                          title: orderNotifier!.isCheckoutRequested
                          ? "Checkout Requested"
                          : "Request Checkout"
                        )
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.24,
                                child: FloatingButton(
                                  onPressed: () async{
                                    orderNotifier!.updateCheckoutType(CheckoutType.CASH, needNotify: false);
                                    orderService.requestCheckout();
                                    orderNotifier!.hideCheckoutTypes();
                                  },
                                  title: "Cash",
                                  fontSize: 40,
                                  prefixWidget: Icon(
                                    FontAwesome5.money_bill_wave,
                                    color: AppColors.textWhite,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.24,
                                child: FloatingButton(
                                  onPressed: () {
                                    orderNotifier!.updateCheckoutType(CheckoutType.CARD, needNotify: false);
                                    orderService.requestCheckout();
                                    orderNotifier!.hideCheckoutTypes();
                                  },
                                  title: "Card",
                                  fontSize: 40,
                                  prefixWidget: Icon(
                                    FontAwesome.credit_card_alt,
                                    color: AppColors.textWhite,
                                    size: 60,
                                  ),
                                ),
                              ),
                            ],
                        )
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
