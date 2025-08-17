import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  meat,
  dairy,
  carbs,
  fruit,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class Shopping {
  Shopping({
    required this.id,
    required this.name,
    required this.qty,
    required this.category,
  });

  String id, name;
  int qty;
  Category category;

  // From json method
  factory Shopping.fromJson(Map<String, dynamic> json) {
    return Shopping(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      qty: json["qty"],
      category: Category.fromJson(json['category']),
    );
  }

  // To json method
  Map<String, dynamic> toJsonWithoutId() {
    return {
      "category": {"title": category.title, "color": category.color.toARGB32()},
      "name": name,
      "qty": qty,
    };
  }

  // Shopping .copyWith() method
  Shopping copyWith({String? id, String? name, int? qty, Category? category}) {
    return Shopping(
      id: id ?? this.id,
      name: name ?? this.name,
      qty: qty ?? this.qty,
      category: category ?? this.category,
    );
  }
}

class Category {
  Category(this.title, this.color);

  String title;
  Color color;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(json['title'], Color(json['color']));
  }
}
