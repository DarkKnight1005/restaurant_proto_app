import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/services/db_service.dart';

class ItemNotifier extends ChangeNotifier {
  
  int productCount = 1;

  void incremenet(){
    productCount++;
    notifyListeners();
  }

  void decremenet(){
    productCount = (productCount - 1) <= 0 ? 0 : productCount - 1;
    notifyListeners();
  }

  void updateCount(int newCount){
    productCount = newCount;
    notifyListeners();
  } 
  
}
