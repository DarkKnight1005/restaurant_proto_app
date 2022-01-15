import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:restaurant_proto_app/models/product.dart';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
    Products({
        required this.products,
    });

    final List<Product> products;

    factory Products.fromJson(Map<String, dynamic> json) => Products(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}
