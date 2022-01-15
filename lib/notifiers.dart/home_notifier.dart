import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/models/categories.dart';
import 'package:restaurant_proto_app/models/products.dart';
import 'package:restaurant_proto_app/models/subcategories.dart';
import 'package:restaurant_proto_app/services/API/menu_service.dart';
import 'package:restaurant_proto_app/services/API/product_service.dart';
import 'package:restaurant_proto_app/services/db_service.dart';
import 'package:restaurant_proto_app/widgets/helpWidgets/distance_determiner.dart';

enum PanelType{
  CURRENT_ORDER,
  ORDERED
}

class HomeNotifier extends ChangeNotifier {
  
  int? selectedCategory;
  int? selectedSubcategory;
  int? selectedProductID;

  double? deltaDistanceMain;
  double? deltaDistanceCategoriesTop;
  double? deltaDistanceCategoriesBottom;

  PanelType activePanelType = PanelType.CURRENT_ORDER;

  double opacity = 0;
  int panelNum = 0;

  GlobalKey<DistanceDeterminerState>? distanceDeterminer;

  Categories categories = Categories(categories: []);
  Subcategories subcategories = Subcategories(subcategories: []);
  Products products = Products(products: []);

  ScrollController? scrollController;

  void setCategories(Categories categories){
    this.categories = categories;
    updateCategory(categories.categories[0].id);
    notifyListeners();
  }
  
  void setSubcategories(Subcategories subcategories){
    this.subcategories = subcategories;
    notifyListeners();
    updateSubcategory(subcategories.subcategories.isEmpty ? -1 : subcategories.subcategories[0].id);
  }

  void setProducts(Products products){
    this.products = products;
    notifyListeners();
  }

  bool checkCanScroll(){
    bool isScrollable = products.products.length > 6;
    // bool isScrollable = scrollController != null ? (scrollController!.position.maxScrollExtent > 0) : true;
    return isScrollable;
  }

  void updateCategory(int newCategory, {bool needNotify = true}) async{
    selectedCategory = newCategory;
    MenuSerivce(homeNotifier: this).getSubcategories(newCategory);
    if (needNotify) notifyListeners();
    ProductService(homeNotifier: this).getByCategory();
    await Future.delayed(Duration(milliseconds: 1000));
    distanceDeterminer!.currentState!.updateDistance();
  }

  void updateSubcategory(int newSubcategory, {bool needNotify = true}){
    selectedSubcategory = newSubcategory;
    if(selectedCategory != -1) ProductService(homeNotifier: this).getBySubcategory();
    if (needNotify) notifyListeners();
  }

  void updateProduct(int newProductID, {bool needNotify = true}){
    selectedProductID = newProductID;
    if (needNotify) notifyListeners();
  }

  void updatePanelType(PanelType newActivePanelType, {bool needNotify = true}){
    activePanelType = newActivePanelType;
    if (needNotify) notifyListeners();
  }

  void updateDeltaDistanceMain(double newDistance){
    deltaDistanceMain = newDistance;
    notifyListeners();
  }

  void updateDeltaDistanceCategoriesTop(double newDistance){
    deltaDistanceCategoriesTop = newDistance;
    notifyListeners();
  }

  void updateDeltaDistanceCategoriesBottom(double newDistance){
    deltaDistanceCategoriesBottom = newDistance;
    notifyListeners();
  }

  void updateOpacity(double newOpacity){
    opacity = newOpacity;
    notifyListeners();
  }

  void updatePanelNum(int newPanelNum){
    if(panelNum != newPanelNum){
      panelNum = newPanelNum;
      notifyListeners();
    }
  }
}
