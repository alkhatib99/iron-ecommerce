// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/cart_controller.dart';
// import '../controllers/user_controller.dart';
// import '../controllers/auth_controller.dart';
// import '../routes/app_routes.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});

//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   int _currentStep = 0;
//   final _formKey = GlobalKey<FormState>();
//   final _isProcessing = false.obs;
//   final _selectedAddressIndex = 0.obs;

//   // Payment method selection
//   final _selectedPaymentMethod = 'Credit Card'.obs;
//   final List<String> _paymentMethods = [
//     'Credit Card',
//     'Bank Transfer',
//     'Net Terms (Business Only)'
//   ];

//   // Get controllers using GetX dependency injection
//   final CartController _cartController = Get.find<CartController>();
//   final UserController _userController = Get.find<UserController>();
//   final AuthController _authController = Get.find<AuthController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: Stepper(
//           currentStep: _currentStep,
//           onStepContinue: () {
//             if (_currentStep < 2) {
//               setState(() {
//                 _currentStep += 1;
//               });
//             } else {
//               _processOrder();
//             }
//           },
//           onStepCancel: () {
//             if (_currentStep > 0) {
//               setState(() {
//                 _currentStep -= 1;
//               });
//             } else {
//               Get.back();
//             }
//           },
//           steps: [
//             Step(
//               title: const Text('Shipping Address'),
//               content: _buildShippingAddressStep(),
//               isActive: _currentStep >= 0,
//             ),
//             Step(
//               title: const Text('Payment Method'),
//               content: _buildPaymentMethodStep(),
//               isActive: _currentStep >= 1,
//             ),
//             Step(
//               title: const Text('Order Summary'),
//               content: _buildOrderSummaryStep(),
//               isActive: _currentStep >= 2,
//             ),
//           ],
//           controlsBuilder: (context, details) {
//             return Padding(
//               padding: const EdgeInsets.only(top: 20.0),
//               child: Row(
//                 children: [
//                   if (_currentStep < 2)
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: details.onStepContinue,
//                         child: const Text('CONTINUE'),
//                       ),
//                     )
//                   else
//                     Expanded(
//                       child: Obx(() => ElevatedButton(
//                             onPressed: _isProcessing.value
//                                 ? null
//                                 : details.onStepContinue,
//                             child: _isProcessing.value
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white)
//                                 : const Text('PLACE ORDER'),
//                           )),
//                     ),
//                   const SizedBox(width: 12),
//                   if (_currentStep > 0)
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: details.onStepCancel,
//                         child: const Text('BACK'),
//                       ),
//                     )
//                   else
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: details.onStepCancel,
//                         child: const Text('CANCEL'),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildShippingAddressStep() {
//     return Obx(() {
//       // Get user data from authController
//       final authController = Get.find<AuthController>();
//       final userData = authController.currentUser?.uid != null
//           ? _userController.userData.value
//           : null;

//       _userController.userData.value;
//       if (userData == null) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final addresses = userData['addresses'] as List<dynamic>? ?? [];

//       if (addresses.isEmpty) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('No shipping addresses found. Please add one.'),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to add address screen
//                 // For demo, we'll just add a mock address
//                 _userController.addAddress({
//                   'id': DateTime.now().millisecondsSinceEpoch.toString(),
//                   'name': 'John Doe',
//                   'street': '123 Main St',
//                   'city': 'New York',
//                   'state': 'NY',
//                   'zip': '10001',
//                   'country': 'USA',
//                   'isDefault': true,
//                 });
//               },
//               child: const Text('ADD ADDRESS'),
//             ),
//           ],
//         );
//       }

//       // Show existing addresses
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ...addresses.asMap().entries.map((entry) {
//             final index = entry.key;
//             final address = entry.value;
//             return Card(
//               margin: const EdgeInsets.only(bottom: 8.0),
//               child: Obx(() => RadioListTile<int>(
//                     title: Text(address['name']),
//                     subtitle: Text(
//                       '${address['street']}, ${address['city']}, ${address['state']} ${address['zip']}, ${address['country']}',
//                     ),
//                     value: index,
//                     groupValue: _selectedAddressIndex.value,
//                     onChanged: (value) {
//                       if (value != null) {
//                         _selectedAddressIndex.value = value;
//                       }
//                     },
//                   )),
//             );
//           }).toList(),
//           const SizedBox(height: 8),
//           TextButton.icon(
//             onPressed: () {
//               // Navigate to add address screen
//               // For demo, we'll just add a mock address with a different name
//               _userController.addAddress({
//                 'id': DateTime.now().millisecondsSinceEpoch.toString(),
//                 'name': 'Jane Doe',
//                 'street': '456 Oak Ave',
//                 'city': 'Chicago',
//                 'state': 'IL',
//                 'zip': '60601',
//                 'country': 'USA',
//                 'isDefault': false,
//               });
//             },
//             icon: const Icon(Icons.add),
//             label: const Text('Add New Address'),
//           ),
//         ],
//       );
//     });
//   }

//   Widget _buildPaymentMethodStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ..._paymentMethods.map((method) {
//           return Card(
//             margin: const EdgeInsets.only(bottom: 8.0),
//             child: Obx(() => RadioListTile<String>(
//                   title: Text(method),
//                   value: method,
//                   groupValue: _selectedPaymentMethod.value,
//                   onChanged: (value) {
//                     if (value != null) {
//                       _selectedPaymentMethod.value = value;
//                     }
//                   },
//                 )),
//           );
//         }).toList(),

//         const SizedBox(height: 16),

//         // Payment details form
//         Obx(() {
//           if (_selectedPaymentMethod.value == 'Credit Card') {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Card Details',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Card Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter card number';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'Expiry Date',
//                           border: OutlineInputBorder(),
//                           hintText: 'MM/YY',
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Required';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TextFormField(
//                         decoration: const InputDecoration(
//                           labelText: 'CVV',
//                           border: OutlineInputBorder(),
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Required';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Name on Card',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter name on card';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             );
//           } else if (_selectedPaymentMethod.value == 'Bank Transfer') {
//             return const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Bank Transfer Instructions',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'You will receive bank transfer instructions after placing your order. Please complete the transfer within 3 business days to avoid order cancellation.',
//                 ),
//               ],
//             );
//           } else if (_selectedPaymentMethod.value ==
//               'Net Terms (Business Only)') {
//             return const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Net Terms Information',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Net terms are available for approved business accounts only. Your account will be reviewed and you will be notified of approval status.',
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Standard terms: Net 30 days from invoice date.',
//                 ),
//               ],
//             );
//           }
//           return const SizedBox.shrink();
//         }),
//       ],
//     );
//   }

//   Widget _buildOrderSummaryStep() {
//     return Obx(() {
//       final cartItems = _cartController.itemsList;
//       final userData = _userController.userData.value;

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Order Items',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),

//           // Order items
//           ...cartItems.map((item) {
//             return ListTile(
//               contentPadding: EdgeInsets.zero,
//               title: Text(item.name),
//               subtitle: Text('${item.quantity} ${item.unit}'),
//               trailing:
//                   Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
//             );
//           }).toList(),

//           const Divider(),

//           // Order summary
//           _buildSummaryRow(
//               'Subtotal', '\$${_cartController.subtotal.toStringAsFixed(2)}'),
//           _buildSummaryRow('Shipping',
//               '\$${_cartController.shippingCost.toStringAsFixed(2)}'),
//           _buildSummaryRow(
//               'Tax', '\$${_cartController.tax.toStringAsFixed(2)}'),
//           const Divider(),
//           _buildSummaryRow(
//             'Total',
//             '\$${_cartController.total.toStringAsFixed(2)}',
//             isBold: true,
//             textColor: Theme.of(context).colorScheme.primary,
//           ),

//           const SizedBox(height: 16),

//           // Payment method summary
//           Obx(() => Text(
//                 'Payment Method: ${_selectedPaymentMethod.value}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               )),

//           const SizedBox(height: 8),

//           // Shipping address summary
//           if (userData != null) ...[
//             const Text(
//               'Shipping Address:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Obx(() {
//               final addresses = userData['addresses'] as List<dynamic>? ?? [];
//               if (addresses.isNotEmpty &&
//                   _selectedAddressIndex.value < addresses.length) {
//                 final address = addresses[_selectedAddressIndex.value];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(address['name']),
//                     Text('${address['street']}, ${address['city']}'),
//                     Text(
//                         '${address['state']} ${address['zip']}, ${address['country']}'),
//                   ],
//                 );
//               }
//               return const Text('No shipping address selected');
//             }),
//           ],
//         ],
//       );
//     });
//   }

//   Widget _buildSummaryRow(String label, String value,
//       {bool isBold = false, Color? textColor}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _processOrder() async {
//     if (_formKey.currentState!.validate()) {
//       _isProcessing.value = true;

//       try {
//         // Simulate order processing
//         await Future.delayed(const Duration(seconds: 2));

//         // Get user data
//         final userData = _userController.userData.value;
//         if (userData == null) {
//           throw Exception('User data not available');
//         }

//         final addresses = userData['addresses'] as List<dynamic>? ?? [];
//         if (addresses.isEmpty) {
//           throw Exception('No shipping address available');
//         }

//         final selectedAddress = addresses[_selectedAddressIndex.value];

//         // Create order object
//         final orderData = {
//           'userId': _authController.currentUser?.uid,
//           'items': _cartController.itemsList
//               .map((item) => {
//                     'productId': item.productId,
//                     'name': item.name,
//                     'price': item.price,
//                     'quantity': item.quantity,
//                     'unit': item.unit,
//                     'totalPrice': item.totalPrice,
//                   })
//               .toList(),
//           'subtotal': _cartController.subtotal,
//           'shippingCost': _cartController.shippingCost,
//           'tax': _cartController.tax,
//           'total': _cartController.total,
//           'paymentMethod': _selectedPaymentMethod.value,
//           'shippingAddress': selectedAddress,
//           'orderDate': DateTime.now().toIso8601String(),
//           'status': 'pending',
//         };

//         // In a real app, you would save the order to Firestore
//         // await _firebaseService.createOrder(orderData);

//         // Generate order number
//         final orderNumber =
//             'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}';

//         // Clear cart
//         _cartController.clear();

//         // Navigate to order confirmation
//         Get.offNamed(
//           Routes.ORDER_CONFIRMATION,
//           arguments: {
//             'orderNumber': orderNumber,
//             'orderTotal': _cartController.total,
//           },
//         );
//       } catch (e) {
//         Get.snackbar(
//           'Error',
//           'Error processing order: ${e.toString()}',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         _isProcessing.value = false;
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../services/firebase_service.dart';
import '../services/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _isProcessing = false.obs;
  final _selectedAddressIndex = 0.obs;

  // Payment method selection
  final _selectedPaymentMethod = 'Credit Card'.obs;
  final List<String> _paymentMethods = [
    'Credit Card',
    'Bank Transfer',
    'Net Terms (Business Only)'
  ];

  // Get controllers using GetX dependency injection
  final CartController _cartController = Get.find<CartController>();
  final UserController _userController = Get.find<UserController>();
  final AuthController _authController = Get.find<AuthController>();
  final OrderService _orderService = Get.find<OrderService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              _processOrder();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            } else {
              Get.back();
            }
          },
          steps: [
            Step(
              title: const Text('Shipping Address'),
              content: _buildShippingAddressStep(),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Payment Method'),
              content: _buildPaymentMethodStep(),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Order Summary'),
              content: _buildOrderSummaryStep(),
              isActive: _currentStep >= 2,
            ),
          ],
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  if (_currentStep < 2)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: const Text('CONTINUE'),
                      ),
                    )
                  else
                    Expanded(
                      child: Obx(() => ElevatedButton(
                            onPressed: _isProcessing.value
                                ? null
                                : details.onStepContinue,
                            child: _isProcessing.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('PLACE ORDER'),
                          )),
                    ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('BACK'),
                      ),
                    )
                  else
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('CANCEL'),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShippingAddressStep() {
    return Obx(() {
      final userData = _userController.userData.value;
      if (userData == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final addresses = userData['addresses'] as List<dynamic>? ?? [];

      if (addresses.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('No shipping addresses found. Please add one.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to add address screen
                // For demo, we'll just add a mock address
                _userController.addAddress({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'name': 'John Doe',
                  'street': '123 Main St',
                  'city': 'New York',
                  'state': 'NY',
                  'zip': '10001',
                  'country': 'USA',
                  'isDefault': true,
                });
              },
              child: const Text('ADD ADDRESS'),
            ),
          ],
        );
      }

      // Show existing addresses
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...addresses.asMap().entries.map((entry) {
            final index = entry.key;
            final address = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Obx(() => RadioListTile<int>(
                    title: Text(address['name']),
                    subtitle: Text(
                      '${address['street']}, ${address['city']}, ${address['state']} ${address['zip']}, ${address['country']}',
                    ),
                    value: index,
                    groupValue: _selectedAddressIndex.value,
                    onChanged: (value) {
                      if (value != null) {
                        _selectedAddressIndex.value = value;
                      }
                    },
                  )),
            );
          }).toList(),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              // Navigate to add address screen
              // For demo, we'll just add a mock address with a different name
              _userController.addAddress({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'name': 'Jane Doe',
                'street': '456 Oak Ave',
                'city': 'Chicago',
                'state': 'IL',
                'zip': '60601',
                'country': 'USA',
                'isDefault': false,
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Address'),
          ),
        ],
      );
    });
  }

  Widget _buildPaymentMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._paymentMethods.map((method) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Obx(() => RadioListTile<String>(
                  title: Text(method),
                  value: method,
                  groupValue: _selectedPaymentMethod.value,
                  onChanged: (value) {
                    if (value != null) {
                      _selectedPaymentMethod.value = value;
                    }
                  },
                )),
          );
        }).toList(),

        const SizedBox(height: 16),

        // Payment details form
        Obx(() {
          if (_selectedPaymentMethod.value == 'Credit Card') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Card Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date',
                          border: OutlineInputBorder(),
                          hintText: 'MM/YY',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name on Card',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name on card';
                    }
                    return null;
                  },
                ),
              ],
            );
          } else if (_selectedPaymentMethod.value == 'Bank Transfer') {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank Transfer Instructions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You will receive bank transfer instructions after placing your order. Please complete the transfer within 3 business days to avoid order cancellation.',
                ),
              ],
            );
          } else if (_selectedPaymentMethod.value ==
              'Net Terms (Business Only)') {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Net Terms Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Net terms are available for approved business accounts only. Your account will be reviewed and you will be notified of approval status.',
                ),
                SizedBox(height: 8),
                Text(
                  'Standard terms: Net 30 days from invoice date.',
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildOrderSummaryStep() {
    return Obx(() {
      final cartItems = _cartController.itemsList;
      final userData = _userController.userData.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Items',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Order items
          ...cartItems.map((item) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.name),
              subtitle: Text('${item.quantity} ${item.unit}'),
              trailing:
                  Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
            );
          }).toList(),

          const Divider(),

          // Order summary
          _buildSummaryRow(
              'Subtotal', '\$${_cartController.subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Shipping',
              '\$${_cartController.shippingCost.toStringAsFixed(2)}'),
          _buildSummaryRow(
              'Tax', '\$${_cartController.tax.toStringAsFixed(2)}'),
          const Divider(),
          _buildSummaryRow(
            'Total',
            '\$${_cartController.total.toStringAsFixed(2)}',
            isBold: true,
            textColor: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 16),

          // Payment method summary
          Obx(() => Text(
                'Payment Method: ${_selectedPaymentMethod.value}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),

          const SizedBox(height: 8),

          // Shipping address summary
          if (userData != null) ...[
            const Text(
              'Shipping Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Obx(() {
              final addresses = userData['addresses'] as List<dynamic>? ?? [];
              if (addresses.isNotEmpty &&
                  _selectedAddressIndex.value < addresses.length) {
                final address = addresses[_selectedAddressIndex.value];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address['name']),
                    Text('${address['street']}, ${address['city']}'),
                    Text(
                        '${address['state']} ${address['zip']}, ${address['country']}'),
                  ],
                );
              }
              return const Text('No shipping address selected');
            }),
          ],
        ],
      );
    });
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

  Future<void> _processOrder() async {
    if (_formKey.currentState!.validate()) {
      _isProcessing.value = true;

      try {
        // Get user data
        // final userData = _userController.userData.value;
        // CHECK IF USER IS LOGGED IN
        if (_authController.currentUser == null) {
          throw Exception('User data not available');
        }
        // if (userData == null) {
        //   throw Exception('User data not available');
        // }
        if (_authController.isLoggedIn) {
          // final addresses = userData['addresses'] as List<dynamic>? ?? [];
          // if (addresses.isEmpty) {
          //   throw Exception('No shipping address available');
          // }

          // final selectedAddress = addresses[_selectedAddressIndex.value];
          var totalOrderPrice = 0.0;
          _cartController.items.map((itemId, item) {
            if (item.price != null && item.quantity != null) {
              // Calculate total price for each item
              // item.totalPrice = item.price * item.quantity;
              totalOrderPrice += item.price * item.quantity;
            }
            return MapEntry(
              itemId,
              item,
            );
          });
          // Create order object
          final orderData = {
            'userId': _authController.currentUser?.uid,
            'userEmail': _authController.currentUser?.email,
            'userName': _authController.currentUser!.displayName ?? 'Customer',
            'items': _cartController.itemsList
                .map((item) => {
                      'productId': item.productId,
                      'name': item.name,
                      'price': item.price,
                      'quantity': item.quantity,
                      'unit': item.unit,
                      'totalPrice': item.totalPrice,
                    })
                .toList(),
            // 'subtotal': _cartController.subtotal,
            // 'shippingCost': _cartController.shippingCost,
            // 'tax': _cartController.tax,
            'total': _cartController.total,
            'itemCount': _cartController.itemCount,
            // 'paymentMethod': _selectedPaymentMethod.value,
            // 'paymentStatus': 'pending',
            // 'shippingAddress': selectedAddress,
            'orderDate': DateTime.now().toIso8601String(),
            'status': 'pending',
          };

          // Save the order to Firestore using OrderService
          final orderId = await _orderService.saveOrder(orderData);

          // Process payment (mock implementation)
          // if (_selectedPaymentMethod.value == 'Credit Card') {
          //   await _orderService.processPayment(
          //     orderId,
          //     _selectedPaymentMethod.value,
          //     _cartController.total
          //   );
          // }

          // Clear cart
          _cartController.clear();

          // Navigate to order confirmation
          Get.offNamed(
            Routes.ORDER_CONFIRMATION,
            arguments: {
              'orderId': orderId,
              'orderTotal': _cartController.total,
            },
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Error processing order: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        _isProcessing.value = false;
      }
    }
  }
}
