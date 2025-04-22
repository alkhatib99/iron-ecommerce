import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_ecommerce_app/controllers/cart_controller.dart';

class OrderModel {

  String? id;
  String? userId;
  List<CartItem>? items;
  // String? quantity;
  String? status;  
    double? total;
    Timestamp? createdAt;

  OrderModel({
    this.id,
    this.userId,
    this.items,
    // this.quantity,
    this.status,
    this.total,
    this.createdAt,
  });

  // Factory constructor to create an OrderModel from a Map (e.g., from Firestore)
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      // quantity: map['quantity'] as String,
      status: map['status'] as String,
      total: map['total'] as double,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  // Convert OrderModel to a Map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items?.map((item) => item.toMap()).toList(),
      // 'quantity': quantity,
      'status': status,
      'total': total,
      'createdAt': createdAt,
    };
  }

} 