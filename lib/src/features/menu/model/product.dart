import 'price.dart';
import 'category.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final Category category;
  final String imageUrl;
  final List<Price> prices;

  const Product(
      {required this.id,
      required this.description,
      required this.name,
      required this.prices,
      required this.imageUrl,
      required this.category});

  @override
  String toString() => name;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: Category.fromJson(json["category"]),
        imageUrl: json["imageUrl"],
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category.toJson(),
        "imageUrl": imageUrl,
        "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
      };
}
