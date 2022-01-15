import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/models/auth_dto.dart';
import 'package:restaurant_proto_app/models/order.dart';
import 'package:restaurant_proto_app/models/order_data.dart';
import 'package:restaurant_proto_app/models/products.dart';
import 'package:restaurant_proto_app/models/std_responce.dart';
import 'package:restaurant_proto_app/notifiers.dart/account_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app/services/API/base_service.dart';
import 'package:restaurant_proto_app/services/db_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class OrderService extends BaseService {

  final OrderNotifier orderNotifier;
  final BasketNotifier basketNotifier;

  OrderService({required this.orderNotifier, required this.basketNotifier}) : super('order');

  Future<OrderData?> getOrdered() async {
    OrderData? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      _dioResponse = await dio.get(
        serviceUrl + "getOrdered/client",
        options: _options,
      );
      
      _response = OrderData.fromJson(_dioResponse.data);
      orderNotifier.updateOrdered(_response);
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }

  Future<StandartResponse?> makeOrder() async {
    StandartResponse? _response;

    NewOrder orderData = NewOrder(orderProducts: []);

    for (var productId in basketNotifier.orderedProducts.keys.toList()) {
      orderData.orderProducts.add(NewOrderedProduct(productId: productId, count: basketNotifier.orderedProducts[productId]!));
    }

    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      _dioResponse = await dio.post(
        serviceUrl + "makeOrder",
        options: _options,
        data: orderData.toJson()
      );
      
      _response = StandartResponse.fromJson(_dioResponse.data);
      basketNotifier.removeAll();
      this.getOrdered();
    } catch (e) {
      debugPrint(e.toString());
      return _response;
    }
  }

  Future<StandartResponse?> requestCheckout() async {
    orderNotifier.changeRequestChekoutStatus();
    StandartResponse? _response;
    try {
      
      String? token = dbService.getAuthToken();
      var _options = new Options(contentType: 'application/json', headers: {"Authorization": "Bearer " + (token ?? "")});

      var _dioResponse;
      
      _dioResponse = await dio.post(
        serviceUrl + "requestCheckout",
        options: _options,
        data: {
          "checkoutType": orderNotifier.checkoutType == CheckoutType.CARD ? "terminal" : "cash"
        }
      );
      
      _response = StandartResponse.fromJson(_dioResponse.data);
    } catch (e) {
      orderNotifier.changeRequestChekoutStatus(isRequested: false);
      debugPrint(e.toString());
      return _response;
    }
  }
}