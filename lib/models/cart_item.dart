import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final String? id; // Firestore document ID
  final String productId;
  final String name;
  final double price;
  final String unit;
  final String imageUrl;
  int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  // Factory constructor to create a CartItem from a Product
  factory CartItem.fromProduct(Product product, int quantity) {
    return CartItem(
      productId: product.id,
      name: product.name,
      price: product.price,
      unit: product.unit,
      imageUrl: product.imageUrl,
      quantity: quantity,
    );
  }

  // Factory constructor to create a CartItem from a Map (e.g., from Firestore)
  factory CartItem.fromMap(Map<String, dynamic> map, String id) {
    return CartItem(
      id: id,
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      unit: map['unit'] ?? 'piece',
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  // Convert CartItem to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'unit': unit,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}
