import 'package:meta/meta.dart';
import 'dart:convert';

OrderData orderedFromJson(String str) => OrderData.fromJson(json.decode(str));

String orderedToJson(OrderData data) => json.encode(data.toJson());

class OrderData {
    OrderData({
        required this.order,
        required this.totalPrice,
    });

    final List<Order> order;
    final double totalPrice;

    factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        order: List<Order>.from(json["order"].map((x) => Order.fromJson(x))),
        totalPrice: json["totalPrice"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "order": List<dynamic>.from(order.map((x) => x.toJson())),
        "totalPrice": totalPrice,
    };
}

class Order {
    Order({
        required this.productData,
        required this.count,
        required this.price,
    });

    final ProductData productData;
    final int count;
    final double price;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        productData: ProductData.fromJson(json["productData"]),
        count: json["count"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "productData": productData.toJson(),
        "count": count,
        "price": price,
    };
}

class ProductData {
    ProductData({
        required this.id,
        required this.title,
        required this.photoUrl,
    });

    final int id;
    final String title;
    final String photoUrl;

    factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"],
        title: json["title"],
        photoUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "photoUrl": photoUrl,
    };
}
