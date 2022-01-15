import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/models/categories.dart';
import 'package:restaurant_proto_app/models/subcategories.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app/services/API/base_service.dart';
import 'package:restaurant_proto_app/services/db_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class MenuSerivce extends BaseService {

  final HomeNotifier homeNotifier;

  MenuSerivce({required this.homeNotifier}) : super('menu');

  Future<Categories?> getCategories() async {
    Categories? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse = await dio.get(
        serviceUrl + "categories",
        options: _options,
      );
      _response = Categories.fromJson(_dioResponse.data);
      _response.categories.insert(0, (CategoryItem(id: -1, title: "Reccomended")));
      homeNotifier.setCategories(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }

  Future<Subcategories?> getSubcategories(int categoryID) async {
    Subcategories? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse = await dio.post(
        serviceUrl + "subcategories",
        options: _options,
        data: {
          "categoryId": categoryID
        }
      );
      _response = Subcategories.fromJson(_dioResponse.data);
      homeNotifier.setSubcategories(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }
}