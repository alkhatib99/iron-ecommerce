import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/order_service.dart';
import '../routes/app_routes.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderService _orderService = Get.find<OrderService>();

  OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from navigation
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String orderId = args['orderId'] ?? '';

    if (orderId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
          centerTitle: true,
        ),
        body: _buildErrorView(error: 'Order ID not provided'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _orderService.getOrder(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorView(error: snapshot.error.toString());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildErrorView(error: 'Order not found');
          }

          // Order data found
          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          return _buildOrderDetails(context, orderId, orderData);
        },
      ),
    );
  }

  Widget _buildOrderDetails(
      BuildContext context, String orderId, Map<String, dynamic> orderData) {
    final orderNumber = orderData['orderNumber'] ??
        'Order #${orderId.substring(0, 8).toUpperCase()}';
    final orderDate = orderData['orderDate'] ?? '';
    final formattedDate = _formatDate(orderDate);
    final status = orderData['status'] ?? 'pending';
    final paymentStatus = orderData['paymentStatus'] ?? 'pending';
    final paymentMethod = orderData['paymentMethod'] ?? 'Unknown';
    final subtotal = orderData['subtotal'] ?? 0.0;
    final shippingCost = orderData['shippingCost'] ?? 0.0;
    final tax = orderData['tax'] ?? 0.0;
    final total = orderData['total'] ?? 0.0;
    final shippingAddress =
        orderData['shippingAddress'] as Map<String, dynamic>? ?? {};
    final items = orderData['items'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Placed on $formattedDate'),
                ],
              ),
              _buildStatusChip(status),
            ],
          ),
          const SizedBox(height: 24),

          // Order status timeline
          _buildOrderTimeline(status, context),
          const SizedBox(height: 24),

          // Order items
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  ...items.map<Widget>((item) {
                    final name = item['name'] ?? 'Unknown Product';
                    final quantity = item['quantity'] ?? 0;
                    final unit = item['unit'] ?? 'pc';
                    final price = item['price'] ?? 0.0;
                    final totalPrice = item['totalPrice'] ?? 0.0;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(name),
                      subtitle: Text(
                          '${quantity.toString()} ${unit} × \$${price.toStringAsFixed(2)}'),
                      trailing: Text('\$${totalPrice.toStringAsFixed(2)}'),
                    );
                  }).toList(),
                  const Divider(),
                  _buildSummaryRow(
                      'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                  _buildSummaryRow(
                      'Shipping', '\$${shippingCost.toStringAsFixed(2)}'),
                  _buildSummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                  const Divider(),
                  _buildSummaryRow(
                    'Total',
                    '\$${total.toStringAsFixed(2)}',
                    isBold: true,
                    textColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Shipping information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipping Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  Text(shippingAddress['name'] ?? ''),
                  Text(
                      '${shippingAddress['street'] ?? ''}, ${shippingAddress['city'] ?? ''}'),
                  Text(
                      '${shippingAddress['state'] ?? ''} ${shippingAddress['zip'] ?? ''}, ${shippingAddress['country'] ?? ''}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment information
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  _buildSummaryRow('Method', paymentMethod),
                  _buildSummaryRow('Status', _formatStatus(paymentStatus)),
                  if (orderData.containsKey('paymentDetails')) ...[
                    const Divider(),
                    const Text(
                      'Payment Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(orderData['paymentDetails'] as Map<String, dynamic>)
                        .entries
                        .map(
                          (entry) => _buildSummaryRow(
                            _formatKey(entry.key),
                            entry.value.toString(),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          if (status == 'pending' || status == 'processing')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showCancelDialog(context, orderId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('CANCEL ORDER'),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text('BACK TO ORDERS'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(String status, BuildContext context) {
    final steps = ['pending', 'processing', 'shipped', 'delivered'];
    final currentStep = steps.indexOf(status);

    if (status == 'cancelled') {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel, color: Colors.red),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'This order has been cancelled',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final isActive = index <= currentStep;
            final isLast = index == steps.length - 1;

            return Expanded(
              child: Row(
                children: [
                  // Circle indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                    ),
                    child: isActive
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),

                  // Line connector
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentStep
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.map((step) {
            final isActive = steps.indexOf(step) <= currentStep;
            return Text(
              _formatStatus(step),
              style: TextStyle(
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
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
        _formatStatus(status),
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

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView({String error = 'Failed to load order details'}) {
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
            onPressed: () => Get.back(),
            child: const Text('BACK TO ORDERS'),
          ),
        ],
      ),
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

              final success = await _orderService.cancelOrder(orderId, reason);

              if (success) {
                Get.snackbar(
                  'Success',
                  'Order cancelled successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Get.back(); // Go back to orders screen
              } else {
                Get.snackbar(
                  'Error',
                  'Failed to cancel order',
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

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  String _formatStatus(String status) {
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }

  String _formatKey(String key) {
    // Convert camelCase to Title Case with spaces
    final result = key.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    );
    return result.substring(0, 1).toUpperCase() + result.substring(1);
  }
}
