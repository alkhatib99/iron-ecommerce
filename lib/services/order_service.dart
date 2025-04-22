import 'dart:developer';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class OrderService extends GetxService {
  final FirebaseService _firebaseService;

  // Observable state variables
  final isLoading = false.obs;
  final error = Rxn<String>();

  // Constructor with dependency injection
  OrderService({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  // Save order to Firestore
  Future<String> saveOrder(Map<String, dynamic> orderData) async {
    isLoading.value = true;
    error.value = null;

    try {
      // Add timestamps
      orderData['createdAt'] = FieldValue.serverTimestamp();
      orderData['updatedAt'] = FieldValue.serverTimestamp();

      // Save to Firestore
      final orderId = await _firebaseService.createOrder(orderData);

      // Generate order number
      final orderNumber = 'ORD-${orderId.substring(0, 8).toUpperCase()}';

      // Update order with order number
      await _firebaseService.firestore
          .collection('orders')
          .doc(orderId)
          .update({'orderNumber': orderNumber});

      return orderId;
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Get order by ID
  Future<DocumentSnapshot> getOrder(String orderId) async {
    isLoading.value = true;
    error.value = null;

    try {
      return await _firebaseService.firestore
          .collection('orders')
          .doc(orderId)
          .get();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    isLoading.value = true;
    error.value = null;

    try {
      await _firebaseService.firestore
          .collection('orders')
          .doc(orderId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Get user orders
  Future<List<DocumentSnapshot>> getUserOrders(String userId) async {
    //Log everything
    log('Loading user orders... - order_service.dart');
    log('User ID: $userId - order_service.dart');
    isLoading.value = true;
    error.value = null;

    try {
      return await _firebaseService.getUserOrders(userId);

      log('User orders loaded: ${userId} - order_service.dart');
      log('User orders: ${userId} - order_service.dart');
    } catch (e) {
      error.value = e.toString();
      log('Error loading user orders: ${e.toString()} - order_service.dart');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // Get user orders stream
  Stream<QuerySnapshot> getUserOrdersStream(String userId) {
    try {
      return _firebaseService.getUserOrdersStream(userId);
    } catch (e) {
      error.value = e.toString();
      rethrow;
    }
  }

  // Process order payment (mock implementation)
  Future<bool> processPayment(
      String orderId, String paymentMethod, double amount) async {
    isLoading.value = true;
    error.value = null;

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Update order with payment information
      await _firebaseService.firestore
          .collection('orders')
          .doc(orderId)
          .update({
        'paymentStatus': 'paid',
        'paymentDate': FieldValue.serverTimestamp(),
        'paymentDetails': {
          'method': paymentMethod,
          'amount': amount,
          'transactionId': 'TXN-${DateTime.now().millisecondsSinceEpoch}',
        },
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId, String reason) async {
    isLoading.value = true;
    error.value = null;

    try {
      await _firebaseService.firestore
          .collection('orders')
          .doc(orderId)
          .update({
        'status': 'cancelled',
        'cancellationReason': reason,
        'cancellationDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
