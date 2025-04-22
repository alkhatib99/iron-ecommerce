import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_ecommerce_app/models/category.dart';

class Product {
  String? id;
  String? name;
  String? description;
  double? price;
  String? unit;
  Category? category;
  DocumentReference? categoryRef;

  String? material;
  String? grade;
  String? imageUrl;
  // final Map<String, dynamic> dimensions;
  bool? inStock;
  String? createdAt;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.unit,
      this.category,
      this.material,
      this.grade,
      this.imageUrl,
      // required this.dimensions,
      this.inStock,
      this.createdAt,
      this.categoryRef});

  // Factory constructor to create a Product from a Map (e.g., from Firestore)
  factory Product.fromJson(Map<String, dynamic> map) {
    // check if map['category'] is DocumentReference
    final categoryField = map['category'];
    DocumentReference? categoryRef;

    if (categoryField != null && categoryField is DocumentReference) {
      categoryRef = categoryField;
    }
    return Product(
      // id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      unit: map['unit'] ?? 'piece',
      categoryRef: categoryRef,
      material: map['material'] ?? '',
      grade: map['grade'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      inStock: map['inStock'] ?? true,
      createdAt: map['createdAt']?.toString() ?? '',
    );
  }

  // Convert Product to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'category': category?.toMap(),
      'material': material,
      'grade': grade,
      'imageUrl': imageUrl,
      // 'dimensions': dimensions,
      'inStock': inStock,
      'createdAt': createdAt,
    };
  }

  // Convert fronJson to Product
}
