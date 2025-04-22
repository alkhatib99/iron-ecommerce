import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/orders_controller.dart';
import '../routes/app_routes.dart';

class OrdersScreen extends StatelessWidget {
  final OrdersController _ordersController = Get.find<OrdersController>();

  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: Obx(
        () => RefreshIndicator(
            onRefresh: _ordersController.loadOrders,
            child: _ordersController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _ordersController.error.value != null
                    ? _buildErrorView(error: _ordersController.error.value!)
                    : _ordersController.orders.isEmpty
                        ? _buildEmptyView()
                        :
                        // final orders = snapshot.data!.docs;
                        ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _ordersController.orders.length,
                            itemBuilder: (context, index) {
                              final orderData = _ordersController.orders[index]
                                  .data() as Map<String, dynamic>;
                              final orderId =
                                  _ordersController.orders[index].id;
                              final orderNumber = orderData['orderNumber'] ??
                                  'Order #${orderId.substring(0, 8).toUpperCase()}';
                              final orderDate = orderData['orderDate'] ?? '';
                              final formattedDate =
                                  _ordersController.formatDate(orderDate);
                              final status = orderData['status'] ?? 'pending';
                              final formattedStatus =
                                  _ordersController.formatStatus(status);
                              final total = orderData['total'] ?? 0.0;
                              final itemCount = orderData['itemCount'] ?? 0;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                child: InkWell(
                                  onTap: () => _navigateToOrderDetails(orderId),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              orderNumber,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            _buildStatusChip(status),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text('Date: $formattedDate'),
                                        Text('Items: $itemCount'),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total: \$${total.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  _navigateToOrderDetails(
                                                      orderId),
                                              child: const Text('VIEW DETAILS'),
                                            ),
                                          ],
                                        ),
                                        if (status == 'pending' ||
                                            status == 'processing')
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () =>
                                                  _showCancelDialog(
                                                      context, orderId),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                              child: const Text('CANCEL ORDER'),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'processing':
        chipColor = Colors.blue;
        break;
      case 'shipped':
        chipColor = Colors.green;
        break;
      case 'delivered':
        chipColor = Colors.green.shade800;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        _ordersController.formatStatus(status),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your order history will appear here',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.offAllNamed(Routes.HOME),
            child: const Text('START SHOPPING'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView({String error = 'Failed to load orders'}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _ordersController.loadOrders,
            child: const Text('RETRY'),
          ),
        ],
      ),
    );
  }

  void _navigateToOrderDetails(String orderId) {
    Get.toNamed(
      Routes.ORDER_DETAILS,
      arguments: {'orderId': orderId},
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to cancel this order?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              final reason = reasonController.text.trim().isEmpty
                  ? 'Cancelled by customer'
                  : reasonController.text.trim();

              final success =
                  await _ordersController.cancelOrder(orderId, reason);

              if (success) {
                Get.snackbar(
                  'Success',
                  'Order cancelled successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Failed to cancel order: ${_ordersController.error.value}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('YES, CANCEL'),
          ),
        ],
      ),
    );
  }
}
