import 'package:meta/meta.dart';
import 'dart:convert';

NewOrder orderedFromJson(String str) => NewOrder.fromJson(json.decode(str));

String orderedToJson(NewOrder data) => json.encode(data.toJson());

class NewOrder {
    NewOrder({
        required this.orderProducts,
    });

    final List<NewOrderedProduct> orderProducts;

    factory NewOrder.fromJson(Map<String, dynamic> json) => NewOrder(
        orderProducts: List<NewOrderedProduct>.from(json["orderedProducts"].map((x) => NewOrderedProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "orderedProducts": List<dynamic>.from(orderProducts.map((x) => x.toJson())),
    };
}

class NewOrderedProduct {
    NewOrderedProduct({
        required this.productId,
        required this.count,
    });

    final int productId;
    final int count;

    factory NewOrderedProduct.fromJson(Map<String, dynamic> json) => NewOrderedProduct(
        productId: json["productId"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "productId": productId,
        "count": count,
    };
}
