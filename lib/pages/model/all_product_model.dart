// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  int? id;
  String? title;
  double? price;
  String? category;
  String? description;
  String? image;
  Rating? rating;
  Product({
    this.id,
    this.title,
    this.price,
    this.category,
    this.description,
    this.image,
    this.rating,
  });
  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        category: json["category"] ?? '',
        title: json["title"] ?? '',
        price: json["price"]?.toDouble(),
        description: json["description"] ?? '',
        id: json["id"] ?? 0,
        image: json["image"] ?? '',
        rating: json["rating"] == null
            ? null
            : Rating.fromJson(
                json["rating"],
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "category": category,
        "image": image,
        "rating": rating?.toJson(),
      };
}

class Rating {
  double? rate;
  int? count;
  Rating({
    this.rate,
    this.count,
  });

  factory Rating.fromRawJson(String str) => Rating.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"] ?? 0,
      );
  Map<String, dynamic> toJson() => {
        "rate": rate,
        "count": count,
      };
}
