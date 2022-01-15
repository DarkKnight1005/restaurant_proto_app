import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/models/products.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app/services/API/base_service.dart';
import 'package:restaurant_proto_app/services/db_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ProductService extends BaseService {

  final HomeNotifier homeNotifier;

  ProductService({required this.homeNotifier}) : super('menu/product');

  Future<Products?> getByCategory() async {
    Products? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      if(homeNotifier.selectedCategory != -1){
        _dioResponse = await dio.post(
        serviceUrl + "byCategory",
        options: _options,
        data: {
          "categoryId": homeNotifier.selectedCategory
        }
      );
      }else{
        _dioResponse = await dio.get(
        serviceUrl + "recommendations",
        options: _options,
      );
      }
      
      _response = Products.fromJson(_dioResponse.data);
      homeNotifier.setProducts(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }

  Future<Products?> getBySubcategory() async {
    Products? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse = await dio.post(
        serviceUrl + "bySubcategory",
        options: _options,
        data: {
          "categoryId": homeNotifier.selectedCategory,
          "subcategoryId": homeNotifier.selectedSubcategory,
        }
      );
      _response = Products.fromJson(_dioResponse.data);
      homeNotifier.setProducts(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }
}