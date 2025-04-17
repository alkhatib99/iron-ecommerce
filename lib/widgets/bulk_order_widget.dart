import 'package:flutter/material.dart';
import 'package:iron_ecommerce_app/models/product.dart';

class BulkOrderWidget extends StatefulWidget {
  final Product product;
  final Function(Product product, double quantity, String unit) onAddToCart;

  const BulkOrderWidget({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<BulkOrderWidget> createState() => _BulkOrderWidgetState();
}

class _BulkOrderWidgetState extends State<BulkOrderWidget> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  String _selectedUnit = 'ton';
  final List<String> _units = ['ton', 'kg', 'piece'];
  
  bool _isBusinessOrder = false;
  final _poNumberController = TextEditingController();
  final _deliveryDateController = TextEditingController();
  
  // Volume-based pricing tiers
  final Map<String, Map<double, double>> _pricingTiers = {
    'ton': {
      1: 1.0,    // Base price (no discount)
      5: 0.95,   // 5% discount for 5+ tons
      10: 0.9,   // 10% discount for 10+ tons
      25: 0.85,  // 15% discount for 25+ tons
      50: 0.8,   // 20% discount for 50+ tons
    },
    'kg': {
      1000: 1.0,    // Base price (no discount)
      5000: 0.95,   // 5% discount for 5000+ kg
      10000: 0.9,   // 10% discount for 10000+ kg
      25000: 0.85,  // 15% discount for 25000+ kg
      50000: 0.8,   // 20% discount for 50000+ kg
    },
    'piece': {
      10: 1.0,    // Base price (no discount)
      50: 0.95,   // 5% discount for 50+ pieces
      100: 0.9,   // 10% discount for 100+ pieces
      250: 0.85,  // 15% discount for 250+ pieces
      500: 0.8,   // 20% discount for 500+ pieces
    },
  };
  
  double _quantity = 1.0;
  double _discountMultiplier = 1.0;
  double _totalPrice = 0.0;
  
  @override
  void initState() {
    super.initState();
    _calculatePrice();
  }
  
  @override
  void dispose() {
    _quantityController.dispose();
    _poNumberController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    try {
      _quantity = double.parse(_quantityController.text);
    } catch (e) {
      _quantity = 1.0;
    }
    
    // Find the applicable discount tier
    _discountMultiplier = 1.0;
    final tiers = _pricingTiers[_selectedUnit] ?? {};
    
    // Sort tiers by quantity in descending order
    final sortedTiers = tiers.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    
    // Find the highest tier that applies
    for (final tier in sortedTiers) {
      if (_quantity >= tier.key) {
        _discountMultiplier = tier.value;
        break;
      }
    }
    
    // Calculate total price with discount
    _totalPrice = widget.product.price * _quantity * _discountMultiplier;
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quantity and unit selectors
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Must be > 0';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _calculatePrice();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: _selectedUnit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  items: _units.map((unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedUnit = value;
                        _calculatePrice();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Volume discount information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Volume Discount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (_discountMultiplier < 1.0) ...[
                  Text(
                    'You qualify for a ${((1 - _discountMultiplier) * 100).toInt()}% discount!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Order more to qualify for volume discounts:',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  _buildDiscountTiers(),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Business order toggle
          SwitchListTile(
            title: const Text('Business Order'),
            subtitle: const Text('Add purchase order details'),
            value: _isBusinessOrder,
            onChanged: (value) {
              setState(() {
                _isBusinessOrder = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          
          // Business order fields
          if (_isBusinessOrder) ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _poNumberController,
              decoration: const InputDecoration(
                labelText: 'Purchase Order Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _deliveryDateController,
              decoration: const InputDecoration(
                labelText: 'Requested Delivery Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now().add(const Duration(days: 3)),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                
                if (date != null) {
                  setState(() {
                    _deliveryDateController.text = '${date.month}/${date.day}/${date.year}';
                  });
                }
              },
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Price summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Unit Price:'),
                    Text('\$${widget.product.price.toStringAsFixed(2)} / ${widget.product.unit}'),
                  ],
                ),
                if (_discountMultiplier < 1.0) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Discount:'),
                      Text('${((1 - _discountMultiplier) * 100).toInt()}%'),
                    ],
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Quantity:'),
                    Text('$_quantity $_selectedUnit'),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Add to cart button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onAddToCart(
                    widget.product,
                    _quantity,
                    _selectedUnit,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('ADD TO CART', style: TextStyle(fontSize: 16)),
            ),
          ),
          
          if (_isBusinessOrder) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // In a real app, this would navigate to a quote request form
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quote request feature will be available soon'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('REQUEST CUSTOM QUOTE', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDiscountTiers() {
    final tiers = _pricingTiers[_selectedUnit] ?? {};
    final sortedTiers = tiers.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedTiers.map((tier) {
        if (tier.key == 1 || tier.key == 1000 || tier.key == 10) {
          return const SizedBox.shrink(); // Skip the base tier
        }
        
        return Text(
          '• ${tier.key}+ $_selectedUnit: ${((1 - tier.value) * 100).toInt()}% off',
          style: TextStyle(
            color: _quantity >= tier.key ? Colors.green : Colors.grey.shade700,
            fontWeight: _quantity >= tier.key ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
