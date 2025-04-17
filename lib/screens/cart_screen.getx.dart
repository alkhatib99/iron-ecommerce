// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/user_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/responsive_widgets.dart';
import '../../routes/app_routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GetX Controllers
    final CartController cartController = Get.find<CartController>();
    final UserController userController = Get.find<UserController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const CustomLoadingIndicator();
        }
        
        if (cartController.error.value != null) {
          return CustomErrorWidget(
            message: cartController.error.value!,
            onRetry: () {
              if (userController.isLoggedIn) {
                cartController.loadCart(userController.userData.value!['uid']);
              }
            },
          );
        }
        
        if (cartController.isEmpty) {
          return const CustomEmptyState(
            title: 'Your Cart is Empty',
            message: 'Add some products to your cart to see them here.',
            icon: Icons.shopping_cart_outlined,
          );
        }
        
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ResponsiveContainer(
                  padding: const EdgeInsets.all(AppTheme.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Items',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.paddingLarge),
                      
                      // Cart items list
                      ...cartController.itemsList.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppTheme.paddingMedium),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                                    child: SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(width: AppTheme.paddingMedium),
                                  
                                  // Product details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        
                                        const SizedBox(height: AppTheme.paddingSmall),
                                        
                                        Text(
                                          '\$${item.price.toStringAsFixed(2)} per ${item.unit}',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        
                                        const SizedBox(height: AppTheme.paddingMedium),
                                        
                                        // Quantity selector
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                if (item.quantity > 1) {
                                                  cartController.updateQuantity(item.productId, item.quantity - 1);
                                                } else {
                                                  cartController.removeItem(item.productId);
                                                }
                                              },
                                            ),
                                            Text(
                                              item.quantity.toString(),
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                cartController.updateQuantity(item.productId, item.quantity + 1);
                                              },
                                            ),
                                            Text(
                                              item.unit,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Price and remove button
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${item.totalPrice.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                      
                                      const SizedBox(height: AppTheme.paddingMedium),
                                      
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          cartController.removeItem(item.productId);
                                        },
                                        color: Theme.of(context).colorScheme.error,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      
                      const SizedBox(height: AppTheme.paddingLarge),
                      
                      // Order summary
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.paddingMedium),
                      
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.paddingMedium),
                          child: Column(
                            children: [
                              // Subtotal
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    '\$${cartController.subtotal.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: AppTheme.paddingSmall),
                              
                              // Shipping
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Shipping',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    cartController.shippingCost > 0
                                        ? '\$${cartController.shippingCost.toStringAsFixed(2)}'
                                        : 'Free',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: cartController.shippingCost > 0
                                          ? null
                                          : Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: AppTheme.paddingSmall),
                              
                              // Tax
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tax (8%)',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    '\$${cartController.tax.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                              
                              const Divider(height: AppTheme.paddingLarge),
                              
                              // Total
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${cartController.total.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              
                              if (cartController.subtotal < 1000) ...[
                                const SizedBox(height: AppTheme.paddingMedium),
                                Text(
                                  'Add \$${(1000 - cartController.subtotal).toStringAsFixed(2)} more to qualify for free shipping!',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Checkout button
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$${cartController.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (userController.isLoggedIn) {
                          Get.toNamed(Routes.CHECKOUT);
                        } else {
                          Get.toNamed(Routes.LOGIN, arguments: {'redirect': Routes.CHECKOUT});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingMedium),
                      ),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
