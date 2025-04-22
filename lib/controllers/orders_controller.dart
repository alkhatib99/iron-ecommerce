import 'dart:developer';

import 'package:get/get.dart';
import '../services/order_service.dart';
import '../controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersController extends GetxController {
  final OrderService _orderService;
  final AuthController _authController;

  // Observable state variables
  final orders = <DocumentSnapshot>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  // Constructor with dependency injection
  OrdersController({
    required OrderService orderService,
    required AuthController authController,
  })  : _orderService = orderService,
        _authController = authController;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // Load user orders
  Future<void> loadOrders() async {
    // log everything
    log('Loading orders... - orders_controller.dart');
    log('User logged in: ${_authController.isLoggedIn} - orders_controller.dart');
    if (!_authController.isLoggedIn) {
      error.value = 'User not logged in';
      return;
    }
    log('User ID: ${_authController.currentUser?.uid} - orders_controller.dart');
    log('User email: ${_authController.currentUser?.email} - orders_controller.dart');
    isLoading.value = true;
    error.value = null;
    
    try {
      final userOrders =
          await _orderService.getUserOrders(_authController.currentUser!.uid);
      orders.value = userOrders;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
      log('Orders loaded: ${orders.length} - orders_controller.dart');
      log('Orders: $orders - orders_controller.dart');
  }

  // Get order stream
  Stream<QuerySnapshot> getOrdersStream() {
    if (_authController.isLoggedIn) {
      throw Exception('User not logged in');
    }

    return _orderService.getUserOrdersStream(_authController.currentUser!.uid);
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId, String reason) async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await _orderService.cancelOrder(orderId, reason);
      if (result) {
        await loadOrders(); // Refresh orders list
      }
      return result;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Format date string
  String formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  // Format status string
  String formatStatus(String status) {
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }
}
