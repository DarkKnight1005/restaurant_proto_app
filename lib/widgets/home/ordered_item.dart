import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/models/order.dart';
import 'package:restaurant_proto_app/models/order_data.dart';
import 'package:restaurant_proto_app/models/product.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app/widgets/home/icon_button_bg.dart';

class OrderedItem extends StatelessWidget {

  final Order order;

  OrderedItem({ Key? key, required this.order}) : super(key: key);

  OrderNotifier? orderNotifier;

  @override
  Widget build(BuildContext context) {

    orderNotifier = Provider.of<OrderNotifier>(context);

    int orderedProductCount = order.count;// orderNotifier!.ordered.

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                height: 75,
                width: 75,
                child: CachedNetworkImage(
                  imageUrl: order.productData.photoUrl,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                      )
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                ),

              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 265,
              // color: Colors.red,
              child: Text(
                order.productData.title,
                style: TextStyle(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              width: 80,
              child: AnimatedFlipCounter(
                duration: Duration(milliseconds: 200),
                value: orderedProductCount,
                textStyle: TextStyle(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Expanded(child: Container(height: 1)),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Container(
                child: AnimatedFlipCounter(
                  duration: Duration(milliseconds: 300),
                  fractionDigits: 2,
                  curve: Curves.easeInOut,
                  value: order.price,
                  suffix: "₼",
                  textStyle: TextStyle(
                    color: AppColors.textBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}