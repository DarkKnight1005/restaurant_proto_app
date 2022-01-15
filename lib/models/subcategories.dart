import 'package:meta/meta.dart';
import 'dart:convert';

Subcategories subcategoriesFromJson(String str) => Subcategories.fromJson(json.decode(str));

String subcategoriesToJson(Subcategories data) => json.encode(data.toJson());

class Subcategories {
    Subcategories({
        required this.subcategories,
    });

    final List<SubcategoryItem> subcategories;

    factory Subcategories.fromJson(Map<String, dynamic> json) => Subcategories(
        subcategories: List<SubcategoryItem>.from(json["subcategories"].map((x) => SubcategoryItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "subcategories": List<dynamic>.from(subcategories.map((x) => x.toJson())),
    };
}

class SubcategoryItem {
    SubcategoryItem({
        required this.id,
        required this.categoryId,
        required this.title,
    });

    final int id;
    final int categoryId;
    final String title;

    factory SubcategoryItem.fromJson(Map<String, dynamic> json) => SubcategoryItem(
        id: json["_id"],
        categoryId: json["categoryId"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "categoryId": categoryId,
        "title": title,
    };
}
