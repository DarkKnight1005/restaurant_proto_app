import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/models/product.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/item_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app/widgets/home/flat_button.dart';
import 'package:restaurant_proto_app/widgets/home/icon_button_bg.dart';

class ProductItem extends StatelessWidget {

  final Product product;
  final Function(int productID) onPress;
  final Function(int productID) onEdgeTap;
  final bool isActive;

  ProductItem({
    Key? key,
    required this.product,
    required this.onPress,
    required this.onEdgeTap,
    required this.isActive
    }) : super(key: key);

    BasketNotifier? basketNotifier;
    OrderNotifier? orderNotifier;


    String getButtonLabel(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      String label = !basketNotifier.contains(product.id)
        ? "Add"
        : itemNotifier.productCount == 0
        ? "Remove"
        : basketNotifier.getProductCount(product.id) == itemNotifier.productCount
        ? "Updated"
        : "Update";

        return label;
    }

    Color getButtonColor(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      Color color = basketNotifier.contains(product.id) && itemNotifier.productCount == 0
        ? AppColors.primaryRed
        : AppColors.bg;
      
      // color = getButtonLabel(basketNotifier, itemNotifier) == "Updated" ? AppColors.bgDark : color;

        return color;
    }

    Color getButtonTextColor(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      Color color = basketNotifier.contains(product.id) && itemNotifier.productCount == 0
        ? AppColors.secondaryRed
        : AppColors.textBlack;

        return color;
    }

    bool getHasFeedback(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      bool hasFeedback = getButtonLabel(basketNotifier, itemNotifier) != "Updated";

      return hasFeedback;
    }

    void getButtonAction(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      String buttonLabel = getButtonLabel(basketNotifier, itemNotifier);
      switch (buttonLabel) {
        case "Add":
          onAddPressed(basketNotifier, itemNotifier);
          break;
        case "Update":
          onUpdatePressed(basketNotifier, itemNotifier);
          break;
        case "Remove":
          onRemovePressed(basketNotifier, itemNotifier);
          break;
        default:
          break;
      }

    }

    void onAddPressed(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      basketNotifier.addItem(product.id, itemNotifier.productCount, product);
    }

    void onUpdatePressed(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      basketNotifier.updateItemCount(product.id, itemNotifier.productCount);
    }

    void onRemovePressed(BasketNotifier basketNotifier, ItemNotifier itemNotifier){
      basketNotifier.removeItem(product.id);
      itemNotifier.incremenet();
    }
    

  @override
  Widget build(BuildContext context) {

    basketNotifier = Provider.of<BasketNotifier>(context);
    orderNotifier = Provider.of<OrderNotifier>(context);
    
    return ChangeNotifierProvider<ItemNotifier>(
      create: (context) => ItemNotifier(),
      builder: (context, wg) => Consumer<ItemNotifier>(
        builder: (context, itemNotifier, child) {
          return Container(
            height: 245,
            width: 365,
            child:
                ScaleTap(
                  enableFeedback: !isActive ? true : false,
                  scaleMinValue: !isActive ? 0.85 : 1,
                  opacityMinValue: 1,
                  onPressed: !isActive ? (){onPress(product.id);} : (){},
                  child: Stack(
                    children: [
                      Container(
                        height: 280,
                        width: 410,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 90.0,
                              color: Colors.grey[350]!,
                            ),
                          ]
                        ),
                        // margin: const EdgeInsets.fromLTRB(24, 100, 1040, 10), //Defining The margins of the panel where 1040 helping to define proper width of the panel
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 45,
                                  left: 6,
                                  child: Container(
                                    height: 100,
                                    width: 160,
                                    child: Text(
                                      product.description,
                                      style: TextStyle(fontSize: 14, color: AppColors.textGrey.withOpacity(0.75)),
                                    ),
                                  )
                                ),
                                Positioned(
                                  left: 6,
                                  top: 0,
                                  child: Container(
                                    child: Text(
                                      product.title,
                                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ),
                                Positioned(
                                  left: 6,
                                  bottom: 0,
                                  child: Container(
                                    child: Text(
                                      product.price.toString() + "0₼",
                                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: AppColors.primary),
                                    ),
                                  )
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35.0),
                                    child: Container(
                                      height: 130,
                                      width: 130,
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
                                ),
                              ],
                            ),
                          )
                        ),
                      ),
                      Offstage(
                  offstage: !isActive,
                  child: AnimatedOpacity(
                    opacity: isActive ? 1 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      height: 280,
                      width: 410,
                      decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.75),
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child: Container(
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: (){onEdgeTap(product.id);},
                                  child: Container(
                                    color: Colors.transparent,
                                  )
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButtonBG(
                                          onPress: (){
                                            if(getButtonLabel(basketNotifier!, itemNotifier) == "Add" && itemNotifier.productCount > 1){
                                              itemNotifier.decremenet();
                                            }else if(getButtonLabel(basketNotifier!, itemNotifier) != "Add"){
                                              itemNotifier.decremenet();
                                            }
                                          },
                                          icon: Icons.remove_rounded,
                                          iconColor: Colors.black,
                                          scaleFactor: 0.65,
                                          iconSize: 55,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColors.bg,
                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                          ),
                                          child: Center(
                                            child: AnimatedFlipCounter(
                                                duration: Duration(milliseconds: 200),
                                                value: itemNotifier.productCount,
                                                textStyle: TextStyle(
                                                  fontSize: 30,
                                                ),
                                              ),
                                          ),
                                        ),
                                        IconButtonBG(
                                          onPress: (){
                                            itemNotifier.incremenet();
                                          },
                                          icon: Icons.add_rounded,
                                          iconColor: Colors.black,
                                          scaleFactor: 0.65,
                                          iconSize: 55,
                                        )
                                      ],
                                    ),
                                    FlatButtonCustom(
                                      title: getButtonLabel(basketNotifier!, itemNotifier),
                                      textColor: getButtonTextColor(basketNotifier!, itemNotifier),
                                      bg: getButtonColor(basketNotifier!, itemNotifier),
                                      innerHorizontalPadding: 20,
                                      innerVerticalPadding: 20,
                                      borderRadius: 20,
                                      hasFeedback: getHasFeedback(basketNotifier!, itemNotifier),
                                      onPress: !orderNotifier!.isCheckoutRequested
                                      ? (){
                                        getButtonAction(basketNotifier!, itemNotifier);
                                      }
                                      : null,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                      )
                    ),
                  ),
                )
                    ],
                  ),
                ),
          );
        }
      ),
    );
  }
}