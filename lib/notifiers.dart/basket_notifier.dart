import 'package:flutter/material.dart';
import 'package:restaurant_proto_app/models/product.dart';

enum EventType{
  ADD,
  REMOVE,
  REMOVE_ALL,
  NONE
}

class BasketNotifier extends ChangeNotifier {
  Map<int, Product> productsData = Map();
  Map<int, int> orderedProducts = Map();

  int _removeAllInterval = 80;

  int get removeAllInterval => _removeAllInterval;

  EventType lastEvent = EventType.NONE;
  int removedIndex = 0;
  Product? removedProduct;

  void addItem(int itemID, int count, Product product){
    orderedProducts.addAll({itemID: count});
    productsData.addAll({itemID: product});
    lastEvent = EventType.ADD;
    notifyListeners();
  }

  void removeItem(int itemID){
    removedIndex = orderedProducts.keys.toList().indexOf(itemID);
    removedProduct = productsData[itemID]!;
    orderedProducts.remove(itemID);
    productsData.remove(itemID);
    // lastEvent = EventType.REMOVE;
    notifyListeners();
  }
  
  Future<void> removeAll() async {
    lastEvent = EventType.REMOVE_ALL;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: this.removeAllInterval + 10));
    for (var itemID in orderedProducts.keys.toList()) {
      this.removeItem(itemID);
      await Future.delayed(Duration(milliseconds: this.removeAllInterval + 10));
    }
    
    // notifyListeners();
  }

  void resetEventType(){
    lastEvent = EventType.NONE;
    removedIndex = 0;
    removedProduct = null;
    // removedProduct = Product(id: 1, categoryId: 2, subcategoryId: 3, title: 'title', description: 'description', price: 123, imageUrl: 'imageUrl');
  }

  void updateItemCount(int itemID, int newCount){
    orderedProducts[itemID] = newCount;
    notifyListeners();
  }


  double getTotalPrice(){
    double totalPrice = 0;
    for (var itemID in orderedProducts.keys.toList()) {
      totalPrice += (productsData[itemID]!.price * orderedProducts[itemID]!);
    }
    return totalPrice;
  }

  double getPriceForProduct(int itemID){
    return productsData[itemID]!.price * orderedProducts[itemID]!;
  }

  bool contains(int itemID){
    return orderedProducts.containsKey(itemID);
  }

  int getProductCount(int itemID){
    return orderedProducts[itemID]!;
  }

  int getNumOfBasketProducts(){
    return orderedProducts.keys.toList().length;
  }
}
