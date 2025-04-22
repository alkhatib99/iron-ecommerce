import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../services/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderService _orderService = Get.find<OrderService>();

  OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments from navigation
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String orderId = args['orderId'] ?? '';
    final double orderTotal = args['orderTotal'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: orderId.isEmpty
          ? _buildErrorView()
          : FutureBuilder<DocumentSnapshot>(
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
                final orderNumber = orderData['orderNumber'] ?? 'Unknown';
                final orderStatus = orderData['status'] ?? 'pending';
                final paymentStatus = orderData['paymentStatus'] ?? 'pending';
                final paymentMethod = orderData['paymentMethod'] ?? 'Unknown';
                final shippingAddress =
                    orderData['shippingAddress'] as Map<String, dynamic>? ?? {};

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Thank You for Your Order!',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your order has been received and is being processed.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Order details card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Details',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Divider(),
                              _buildDetailRow('Order Number', orderNumber),
                              _buildDetailRow(
                                  'Order Status', _formatStatus(orderStatus)),
                              _buildDetailRow('Payment Status',
                                  _formatStatus(paymentStatus)),
                              _buildDetailRow('Payment Method', paymentMethod),
                              _buildDetailRow('Order Total',
                                  '\$${orderTotal.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Shipping address card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shipping Address',
                                style: Theme.of(context).textTheme.titleLarge,
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

                      // Order items card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Items',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Divider(),
                              ..._buildOrderItems(orderData),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Get.offAllNamed(Routes.HOME),
                              child: const Text('CONTINUE SHOPPING'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.toNamed(Routes.ORDERS),
                              child: const Text('VIEW MY ORDERS'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildErrorView({String error = 'An error occurred with your order'}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'Order Error',
              style: Get.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Get.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offAllNamed(Routes.HOME),
              child: const Text('RETURN TO HOME'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  List<Widget> _buildOrderItems(Map<String, dynamic> orderData) {
    final items = orderData['items'] as List<dynamic>? ?? [];

    if (items.isEmpty) {
      return [const Text('No items in this order')];
    }

    return items.map<Widget>((item) {
      final name = item['name'] ?? 'Unknown Product';
      final quantity = item['quantity'] ?? 0;
      // final unit = item['unit'] ?? 'pc';
      final price = item['price'] ?? 0.0;
      final totalPrice = item['totalPrice'] ?? 0.0;

      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(name),
        // subtitle: Text('${quantity.toString()} ${unit}'),
        trailing: Text('\$${totalPrice.toStringAsFixed(2)}'),
      );
    }).toList();
  }

  String _formatStatus(String status) {
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }
}
