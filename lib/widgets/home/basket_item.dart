import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/models/product.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/widgets/home/icon_button_bg.dart';

class BasketItem extends StatelessWidget {

  final Product product;

  BasketItem({ Key? key, required this.product}) : super(key: key);

  BasketNotifier? basketNotifier;

  @override
  Widget build(BuildContext context) {

    basketNotifier = Provider.of<BasketNotifier>(context);

    int orderedProductCount = basketNotifier!.orderedProducts[product.id] ?? 1;

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
                  imageUrl: product.imageUrl,
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
              width: 220,
              // color: Colors.red,
              child: Text(
                product.title,
                style: TextStyle(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            IconButtonBG(
              onPress: (){
                if(orderedProductCount - 1 != 0){
                  basketNotifier!.updateItemCount(product.id, orderedProductCount - 1);
                }else{
                  basketNotifier!.removeItem(product.id);
                }
              }, 
              icon: orderedProductCount == 1 ? FontAwesome.trash_empty : Icons.remove_rounded,
              iconColor: orderedProductCount == 1 ? AppColors.textWhite : AppColors.textBlack,
              bgColor: orderedProductCount == 1 ? AppColors.primaryRed : AppColors.bg, 
              iconSize: orderedProductCount == 1 ? 40 : 48,
              scaleFactor: 0.62,
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
            IconButtonBG(
              onPress: (){
                basketNotifier!.updateItemCount(product.id, basketNotifier!.orderedProducts[product.id]! + 1);
              }, 
              icon: Icons.add_rounded,
              iconColor: AppColors.textBlack,
              iconSize: 48,
              scaleFactor: 0.62,
            ),
            Expanded(child: Container(height: 1)),
            Container(
              child: AnimatedFlipCounter(
                duration: Duration(milliseconds: 300),
                fractionDigits: 2,
                curve: Curves.easeInOut,
                value: orderedProductCount == 1 ? product.price : basketNotifier!.getPriceForProduct(product.id),
                suffix: "\$",
                textStyle: TextStyle(
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}