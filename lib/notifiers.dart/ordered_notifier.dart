import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/models/order_data.dart';
import 'package:restaurant_proto_app/models/product.dart';

enum CheckoutType{
  CASH,
  CARD,
}

class OrderNotifier extends ChangeNotifier {
  
  bool canShowCheckoutTypes = false;
  bool isCheckoutRequested = false;
  CheckoutType checkoutType = CheckoutType.CASH;

  OrderData ordered = OrderData(order: [], totalPrice: 0);
  
  void updateCheckoutType(CheckoutType newCheckoutType, {bool needNotify = true}){
    checkoutType = newCheckoutType;
    if(needNotify) notifyListeners();
  }

  void showCheckoutTypes(){
    canShowCheckoutTypes = true;
    notifyListeners();
  }

  void hideCheckoutTypes(){
    canShowCheckoutTypes = false;
    notifyListeners();
  }

  void changeRequestChekoutStatus({bool isRequested = true}){
    isCheckoutRequested = isRequested;
    notifyListeners();
  }

  void updateOrdered(OrderData newOrdered){
    ordered = newOrdered;
    notifyListeners();
  }

  double getTotalPrice(){
    return ordered.totalPrice;
  }
}
