class Product {
    Product({
        required this.id,
        required this.categoryId,
        required this.subcategoryId,
        required this.title,
        required this.description,
        required this.price,
        required this.imageUrl,
    });

    final int id;
    final int categoryId;
    final int subcategoryId;
    final String title;
    final String description;
    final double price;
    final String imageUrl;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        categoryId: json["categoryId"],
        subcategoryId: json["subcategoryId"],
        title: json["title"],
        description: json["description"],
        price: json["price"].toDouble(),
        imageUrl: json["photoUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "categoryId": categoryId,
        "subcategoryId": subcategoryId,
        "title": title,
        "description": description,
        "price": price,
        "photoUrl": imageUrl,
    };
}
