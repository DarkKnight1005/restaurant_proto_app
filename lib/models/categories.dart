import 'package:meta/meta.dart';
import 'dart:convert';

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
    Categories({
        required this.categories,
    });

    final List<CategoryItem> categories;

    factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        categories: List<CategoryItem>.from(json["categories"].map((x) => CategoryItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    };
}

class CategoryItem {
    CategoryItem({
        required this.id,
        required this.title,
    });

    final int id;
    final String title;

    factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        id: json["_id"],
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
    };
}
