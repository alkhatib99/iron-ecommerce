import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/responsive_widgets.dart';
import '../../routes/app_routes.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get product ID from arguments
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String productId = args['productId'] ?? '';
    
    // GetX Controllers
    final ProductController productController = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();
    
    // Local state
    final selectedQuantity = 1.obs;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          Obx(() => IconButton(
            icon: Badge(
              label: Text(cartController.itemCount.toString()),
              isLabelVisible: cartController.itemCount > 0,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Get.toNamed(Routes.CART);
            },
          )),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: productController.getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          }
          
          if (snapshot.hasError) {
            return CustomErrorWidget(
              message: 'Error loading product: ${snapshot.error}',
              onRetry: () {
                // Refresh the screen
                Get.offAndToNamed(Routes.PRODUCT_DETAIL, arguments: {'productId': productId});
              },
            );
          }
          
          if (!snapshot.hasData || snapshot.data == null) {
            return const CustomEmptyState(
              title: 'Product Not Found',
              message: 'The requested product could not be found.',
              icon: Icons.error_outline,
            );
          }
          
          final product = snapshot.data!;
          
          return SingleChildScrollView(
            child: ResponsiveContainer(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                        image: DecorationImage(
                          image: NetworkImage(product['imageUrl'] ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.paddingLarge),
                  
                  // Product name and price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product['name'] ?? '',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'per ${product['unit'] ?? 'unit'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.paddingMedium),
                  
                  // Category and material
                  Wrap(
                    spacing: AppTheme.paddingSmall,
                    children: [
                      Chip(
                        label: Text(product['category'] ?? ''),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      Chip(
                        label: Text(product['material'] ?? ''),
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      Chip(
                        label: Text('Grade: ${product['grade'] ?? ''}'),
                        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.paddingLarge),
                  
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Text(
                    product['description'] ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  
                  const SizedBox(height: AppTheme.paddingLarge),
                  
                  // Specifications
                  Text(
                    'Specifications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  
                  // Dimensions table
                  if (product['dimensions'] != null)
                    Table(
                      border: TableBorder.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                                child: Text(
                                  'Dimension',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.paddingSmall),
                                child: Text(
                                  'Value',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...((product['dimensions'] as Map<String, dynamic>).entries.map((entry) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppTheme.paddingSmall),
                                  child: Text(
                                    entry.key.replaceAll('_', ' ') ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppTheme.paddingSmall),
                                  child: Text(
                                    '${entry.value} ${entry.key == 'weight' ? 'kg' : entry.key == 'length' || entry.key == 'width' || entry.key == 'height' || entry.key == 'thickness' || entry.key == 'diameter' ? 'in' : ''}',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList()),
                      ],
                    ),
                  
                  const SizedBox(height: AppTheme.paddingLarge),
                  
                  // Quantity selector
                  Text(
                    'Quantity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (selectedQuantity.value > 1) {
                            selectedQuantity.value--;
                          }
                        },
                      ),
                      Obx(() => Text(
                        selectedQuantity.value.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          selectedQuantity.value++;
                        },
                      ),
                      Text(
                        product['unit'] ?? 'unit',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Obx(() => Text(
                        'Total: \$${(product['price'] * selectedQuantity.value).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.paddingXLarge),
                  
                  // Add to cart button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.addItem(
                          product['id'],
                          product['name'],
                          product['price'].toDouble(),
                          product['unit'],
                          product['imageUrl'],
                          selectedQuantity.value,
                        );
                        
                        Get.snackbar(
                          'Added to Cart',
                          '${product['name']} has been added to your cart.',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingMedium),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.paddingMedium),
                  
                  // Request quote button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement request quote functionality
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingMedium),
                      ),
                      child: const Text('Request Custom Quote'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

extension StringExtension on String {
  String? get capitalize {
    return this.isNotEmpty ? '${this[0].toUpperCase()}${this.substring(1)}' : this;
  }
}
